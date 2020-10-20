
CREATE OR REPLACE VIEW last_raid_attendance AS
SELECT p.id AS player, p.name AS player_name, r.instance, count(r.id) attendance
FROM raid             AS r
INNER JOIN raid_entry AS re ON r.id = re.raid
INNER JOIN player     AS p ON p.id = re.player AND p.rank != 'inactif'
WHERE r.date >= DATE(DATE_SUB(NOW(), INTERVAL 14 DAY))
GROUP BY player, instance;

CREATE OR REPLACE VIEW raid_size AS
SELECT r.id AS raid, r.name, r.date, count(e.player) AS size
FROM       raid       AS r
INNER JOIN raid_entry AS e ON r.id = e.raid
GROUP BY raid;

-- supression des l'ancien systeme de point
CREATE OR REPLACE VIEW no_loot AS
SELECT count(e.raid) AS nb_raid, e.player
FROM raid AS r
INNER JOIN raid_entry AS e ON e.raid = r.id
WHERE r.date > (SELECT loot_date FROM last_player_loot AS lpl WHERE lpl.player = e.player)
GROUP BY player;

CREATE OR REPLACE VIEW player_nb_raid AS
SELECT count(e.raid) AS nb_raid, e.player
FROM   raid_entry    AS e
GROUP BY player;

CREATE OR REPLACE VIEW player_statistic AS
SELECT p.id AS player, p.name, p.class, p.rank,
e.ev, e.gp, e.ratio,
IFNULL(pnl.nb_loot, 0) AS nb_loot,
IFNULL(pnr.nb_raid, 0) AS nb_raid,
IFNULL(nl.nb_raid, 0)  AS nb_raid_without_loot
FROM player              AS p
LEFT JOIN evgp           AS e   ON e.player   = p.id
LEFT JOIN player_nb_loot AS pnl ON pnl.player = p.id
LEFT JOIN player_nb_raid AS pnr ON pnr.player = p.id
LEFT JOIN no_loot        AS nl  ON nl.player  = p.id;

-- suppression colonne ratio --
CREATE OR REPLACE VIEW item_priority AS
SELECT  i.id                      AS item,
        p.id                      AS player,
        i.name                    AS item_name,
        p.name                    AS player_name,
        0                         AS point,
        pw.attribution            AS attribution,
        evgp.ev                   AS ev,
        evgp.gp                   AS gp,
        ROUND(evgp.ratio * 100)   AS evgp_ratio,
        pnl.nb_loot               AS nb_loot,
        pnr.nb_raid               AS nb_raid,
        IFNULL(nl.nb_raid, 0)     AS nb_raid_without_loot,
        IFNULL(pww.nb_raid, 0)    AS nb_raid_wait,
        pw.selected
FROM player_wish                  AS pw
INNER JOIN item                   AS i   ON pw.item     = i.id
INNER JOIN player                 AS p   ON pw.player   = p.id
LEFT JOIN no_loot                 AS nl  ON nl.player   = p.id
LEFT JOIN player_nb_loot          AS pnl ON pnl.player  = p.id
LEFT JOIN player_nb_raid          AS pnr ON pnr.player  = p.id
LEFT JOIN player_wish_wait        AS pww ON pww.player  = pw.player
                                        AND pww.item    = pw.item
LEFT JOIN evgp                           ON evgp.player = p.id
WHERE pw.running = true
GROUP BY item, player;

CREATE OR REPLACE VIEW last_player_loot AS
SELECT e.player, MAX(r.date) AS loot_date
FROM       raid        AS r
INNER JOIN raid_entry  AS e ON r.id = e.raid
INNER JOIN player_loot AS l ON r.id = l.raid AND l.player = e.player
WHERE l.attribution = 'primary'
GROUP BY e.player;

CREATE OR REPLACE VIEW player_nb_loot AS
SELECT count(p.item) AS nb_loot, p.player
FROM   player_loot   AS p
WHERE  p.attribution = 'primary'
GROUP BY player;

CREATE OR REPLACE VIEW player_wish_wait AS
SELECT i.id            AS item,
       i.name          AS item_name,
       p.id            AS player,
       p.name          AS player_name,
       p.rank,
       p.class,
       0 AS point,
       count(rpw.raid) AS nb_raid
FROM raid_player_wish  AS rpw
INNER JOIN player_wish AS pw  ON pw.player = rpw.player AND pw.item = rpw.item AND pw.running = true
INNER JOIN player      AS p   ON p.id = rpw.player
INNER JOIN item        AS i   ON i.id = rpw.item
GROUP BY item, player;

CREATE OR REPLACE VIEW evgp AS
SELECT ev.player,
       ev.name,
       ev.ev,
       gp.gp,
       gp.gp / ev.ev AS ratio
FROM      player_ev AS ev
LEFT JOIN player_gp AS gp ON gp.player = ev.player;

CREATE OR REPLACE VIEW loot_history AS
SELECT i.id AS item_id,
  i.name    AS item_name,
  i.big     AS item_big,
  p.id      AS player_id,
  p.name    AS player_name,
  r.date    AS loot_date,
  r.id      AS raid,
  i.gp      AS initial_gp,
  ROUND(i.gp * POWER(0.85, DATEDIFF(CURDATE(),r.date) div 7)) AS gp,
  CASE
    WHEN pl.wl = true                     THEN 'wishList'
    ELSE pl.attribution
  END AS attribution
FROM player_loot       AS pl
INNER JOIN item        AS i  ON i.id = pl.item
INNER JOIN player      AS p  ON p.id = pl.player
INNER JOIN raid        AS r  ON r.id = pl.raid;

-- attendance --
CREATE OR REPLACE VIEW raid_attendance AS
(
	SELECT p.id AS player, p.name AS player_name, r.instance, count(r.id) AS attendance , 'always' AS period
	FROM player           AS p
	INNER JOIN raid_entry AS re ON p.id = re.player
	INNER JOIN raid       AS r  ON r.id = re.raid
	GROUP BY player, instance
) UNION (
	SELECT p.id AS player, p.name AS player_name, r.instance, count(r.id) AS attendance, 'day28' AS period
	FROM player           AS p
	INNER JOIN raid_entry AS re ON p.id = re.player
	INNER JOIN raid       AS r  ON r.id = re.raid
	                     AND r.date >= DATE(DATE_SUB(NOW(), INTERVAL 28 DAY))
	GROUP BY player, instance
) UNION (
	SELECT p.id AS player, p.name AS player_name, r.instance, count(r.id) AS attendance, 'day14' AS period
	FROM player           AS p
	INNER JOIN raid_entry AS re ON p.id = re.player
	INNER JOIN raid       AS r  ON r.id = re.raid
	                     AND r.date >= DATE(DATE_SUB(NOW(), INTERVAL 14 DAY))
	GROUP BY player, instance
);

-- suppression raid.point --
CREATE OR REPLACE VIEW player_gp AS
SELECT p.id AS player,
       p.name,
       SUM(ROUND(i.gp * POWER(0.85, DATEDIFF(CURDATE(),r.date) div 7))) AS gp
FROM       player      AS p
INNER JOIN player_loot AS pl ON p.id = pl.player AND pl.attribution = 'primary'
INNER JOIN raid        AS r  ON r.id = pl.raid
INNER JOIN item        AS i  ON i.id = pl.item
GROUP BY player;

CREATE OR REPLACE VIEW raid_ev AS
SELECT r.id AS raid,
  r.name,
  r.instance,
  r.date,
  rs.size,
  sum(i.gp)                                                                    AS initial_ev,
  DATEDIFF(CURDATE(),r.date) div 7                                             AS week_ago,
  ROUND(sum(i.gp) * POWER(0.9, DATEDIFF(CURDATE(),r.date) div 7))              AS ev,
  sum(i.gp) div rs.size                                                        AS ev_per_player_initial,
  ROUND(sum(i.gp) * POWER(0.9, DATEDIFF(CURDATE(),r.date) div 7)) DIV rs.size  AS ev_per_player
FROM raid AS r
INNER JOIN raid_size   AS rs ON r.id = rs.raid
INNER JOIN player_loot AS pl ON r.id = pl.raid AND pl.attribution = 'primary'
INNER JOIN item        AS i  ON i.id = pl.item
GROUP BY raid;

-- inprogress armory --

CREATE OR REPLACE VIEW armory AS (
	SELECT pl.player, p.name AS player_name, p.class, p.rank,
	  pl.item, i.name AS item_name, i.slot, i.ilvl, i.raid,
	  pl.attribution, pl.wl, true AS optained
	FROM player_loot     AS pl
	INNER JOIN item      AS i  ON i.id = pl.item
	INNER JOIN player    AS p  ON p.id = pl.player
	WHERE p.rank <> 'inactif'
) UNION (
	SELECT pw.player, p.name AS player_name, p.class, p.rank,
	  pw.item, i.name AS item_name, i.slot, i.ilvl, i.raid,
	  pw.attribution, true AS wl, false AS optained
	FROM player_wish     AS pw
	INNER JOIN item      AS i  ON i.id = pw.item
	INNER JOIN player    AS p  ON p.id = pw.player
	WHERE p.rank <> 'inactif'
	  AND pw.running IS true
);


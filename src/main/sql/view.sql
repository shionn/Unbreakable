
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

-- suppression colonne ratio --
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

CREATE OR REPLACE VIEW loot_history AS
SELECT i.id AS item_id,
  i.name    AS item_name,
  i.big     AS item_big,
  p.id      AS player_id,
  p.name    AS player_name,
  r.date    AS loot_date,
  r.id      AS raid,
  i.gp      AS initial_gp,
  ROUND(i.gp * POWER(0.9, DATEDIFF(CURDATE(),r.date) div 7)) AS gp,
  CASE
    WHEN pl.wl = true                     THEN 'wishList'
    ELSE pl.attribution
  END AS attribution
FROM player_loot       AS pl
INNER JOIN item        AS i  ON i.id = pl.item
INNER JOIN player      AS p  ON p.id = pl.player
INNER JOIN raid        AS r  ON r.id = pl.raid;

-- suppression raid.point --
CREATE OR REPLACE VIEW player_gp AS
SELECT p.id AS player,
       p.name,
       SUM(ROUND(i.gp * POWER(0.9, DATEDIFF(CURDATE(),r.date) div 7))) AS gp
FROM       player      AS p
INNER JOIN player_loot AS pl ON p.id = pl.player AND pl.attribution = 'primary'
INNER JOIN raid        AS r  ON r.id = pl.raid
INNER JOIN item        AS i  ON i.id = pl.item
GROUP BY player;

-- inprogress armory --
CREATE OR REPLACE VIEW armory AS (
	SELECT pl.player, p.name AS player_name, p.class, p.rank,
	  pl.item, i.name AS item_name, i.slot, i.ilvl, i.raid,
	  pl.attribution, pl.wl, true AS optained, false AS editable
	FROM player_loot     AS pl
	INNER JOIN item      AS i  ON i.id = pl.item
	INNER JOIN player    AS p  ON p.id = pl.player
	WHERE p.rank <> 'inactif'
) UNION (
	SELECT pw.player, p.name AS player_name, p.class, p.rank,
	  pw.item, i.name AS item_name, i.slot, i.ilvl, i.raid,
	  pw.attribution, true AS wl, false AS optained, false AS editable
	FROM player_wish     AS pw
	INNER JOIN item      AS i  ON i.id = pw.item
	INNER JOIN player    AS p  ON p.id = pw.player
	WHERE p.rank <> 'inactif'
	  AND pw.running IS true
) UNION(
	SELECT ps.player, p.name AS player_name, p.class, p.rank,
	  ps.item, i.name AS item_name, i.slot, i.ilvl, i.raid,
	  null AS attribution, false AS wl, true AS optained, true AS editable
	FROM player_stuff    AS ps
	INNER JOIN item      AS i  ON i.id = ps.item
	INNER JOIN player    AS p  ON p.id = ps.player
	WHERE p.rank <> 'inactif'
);

-- reroll count evgp --
CREATE OR REPLACE VIEW raid_ev AS
SELECT r.id AS raid, r.name, r.instance, r.date, rs.size, r.reroll_as_main,
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

CREATE OR REPLACE VIEW player_ev AS
SELECT IFNULL(m.id, p.id)      AS player,
       IFNULL(m.id, p.id)      AS player_id,
       IFNULL(m.name, p.name)  AS name,
       SUM(CASE
         WHEN m.id IS NULL THEN ev.ev_per_player
         ELSE ev.ev_per_player DIV 2
         END) AS ev
FROM       player      AS p
INNER JOIN raid_entry  AS re ON p.id    = re.player
INNER JOIN raid_ev     AS ev ON re.raid = ev.raid
LEFT  JOIN player      AS m  ON m.id    = p.main
                            AND p.rank  = 'reroll'
                            AND ev.reroll_as_main IS TRUE
                            AND NOT EXISTS (SELECT * FROM player_loot AS pl WHERE pl.raid = ev.raid AND pl.player = p.id AND pl.attribution = 'primary')
GROUP BY player_id;

-- reroll attendance as main --
CREATE OR REPLACE VIEW raid_attendance AS
(
	SELECT IFNULL(m.id, p.id) AS player,
	  IFNULL(m.id, p.id)      AS player_id,
	  IFNULL(m.name, p.name)  AS name,
	  r.instance,
	  'always'                AS period,
	  ROUND(SUM(CASE WHEN m.id IS NULL THEN 1 ELSE 0.5  END))
                            AS attendance
	FROM player           AS p
	INNER JOIN raid_entry AS re ON p.id = re.player
	INNER JOIN raid       AS r  ON r.id = re.raid
	LEFT  JOIN player     AS m  ON m.id    = p.main
                             AND p.rank  = 'reroll'
                             AND r.reroll_as_main IS TRUE
                             AND NOT EXISTS (SELECT * FROM player_loot AS pl
                                             WHERE pl.raid = r.id
                                               AND pl.player = p.id
                                               AND pl.attribution = 'primary')
	GROUP BY player_id, instance
) UNION (
	SELECT IFNULL(m.id, p.id) AS player,
	  IFNULL(m.id, p.id)      AS player_id,
	  IFNULL(m.name, p.name)  AS name,
	  r.instance,
	  'day28'                 AS period,
	  ROUND(SUM(CASE WHEN m.id IS NULL THEN 1 ELSE 0.5  END))
                            AS attendance
	FROM player           AS p
	INNER JOIN raid_entry AS re ON p.id = re.player
	INNER JOIN raid       AS r  ON r.id = re.raid
	                     AND r.date >= DATE(DATE_SUB(NOW(), INTERVAL 28 DAY))
	LEFT  JOIN player     AS m  ON m.id    = p.main
                             AND p.rank  = 'reroll'
                             AND r.reroll_as_main IS TRUE
                             AND NOT EXISTS (SELECT * FROM player_loot AS pl
                                             WHERE pl.raid = r.id
                                               AND pl.player = p.id
                                               AND pl.attribution = 'primary')
	GROUP BY player_id, instance
) UNION (
	SELECT IFNULL(m.id, p.id) AS player,
	  IFNULL(m.id, p.id)      AS player_id,
	  IFNULL(m.name, p.name)  AS name,
	  r.instance,
	  'day14'                AS period,
	  ROUND(SUM(CASE WHEN m.id IS NULL THEN 1 ELSE 0.5  END))
                            AS attendance
	FROM player           AS p
	INNER JOIN raid_entry AS re ON p.id = re.player
	INNER JOIN raid       AS r  ON r.id = re.raid
	                     AND r.date >= DATE(DATE_SUB(NOW(), INTERVAL 14 DAY))
	LEFT  JOIN player     AS m  ON m.id    = p.main
                             AND p.rank  = 'reroll'
                             AND r.reroll_as_main IS TRUE
                             AND NOT EXISTS (SELECT * FROM player_loot AS pl
                                             WHERE pl.raid = r.id
                                               AND pl.player = p.id
                                               AND pl.attribution = 'primary')
	GROUP BY player_id, instance
);


-- ergp --
CREATE OR REPLACE VIEW raid_avg_er AS
SELECT instance, ROUND(AVG(ev)) AS er, ROUND(AVG(ev_per_player)) AS er_per_player
FROM raid_ev
GROUP BY instance;

CREATE OR REPLACE VIEW raid_er AS
SELECT r.id AS raid, r.name, r.instance, r.date, rs.size, r.reroll_as_main,
  er.er                                                                        AS initial_er,
  DATEDIFF(CURDATE(),r.date) div 7                                             AS week_ago,
  ROUND(er.er * POWER(0.9, DATEDIFF(CURDATE(),r.date) div 7))                  AS er,
  er.er div rs.size                                                            AS er_per_player_initial,
  ROUND(er.er * POWER(0.9, DATEDIFF(CURDATE(),r.date) div 7)) div rs.size      AS er_per_player
FROM raid AS r
INNER JOIN raid_avg_er AS er ON r.instance = er.instance
INNER JOIN raid_size   AS rs ON r.id = rs.raid
GROUP BY raid;

CREATE OR REPLACE VIEW player_er AS
SELECT IFNULL(m.id, p.id)      AS player,
       IFNULL(m.id, p.id)      AS player_id,
       IFNULL(m.name, p.name)  AS name,
       SUM(CASE
         WHEN m.id IS NULL THEN er.er_per_player
         ELSE er.er_per_player DIV 2
         END) AS er
FROM       player      AS p
INNER JOIN raid_entry  AS re ON p.id    = re.player
INNER JOIN raid_er     AS er ON re.raid = er.raid
LEFT  JOIN player      AS m  ON m.id    = p.main
                            AND p.rank  = 'reroll'
                            AND er.reroll_as_main IS TRUE
                            AND NOT EXISTS (SELECT * FROM player_loot AS pl WHERE pl.raid = er.raid AND pl.player = p.id AND pl.attribution = 'primary')
GROUP BY player_id;

CREATE OR REPLACE VIEW evergp AS
SELECT ev.player,
       ev.name,
       ev.ev,
       er.er,
       gp.gp,
       gp.gp / ev.ev AS evgp_ratio,
       gp.gp / er.er AS ergp_ratio
FROM      player_ev AS ev
LEFT JOIN player_er AS er ON er.player = ev.player
LEFT JOIN player_gp AS gp ON gp.player = ev.player;

CREATE OR REPLACE VIEW player_statistic AS
SELECT p.id AS player, p.name, p.display_name, p.class, p.rank,
e.ev, e.er, e.gp,
ROUND(e.evgp_ratio * 100)  AS evgp_ratio,
ROUND(e.ergp_ratio * 100)  AS ergp_ratio,
IFNULL(pnl.nb_loot, 0)     AS nb_loot,
IFNULL(pnr.nb_raid, 0)     AS nb_raid,
IFNULL(nl.nb_raid, 0)      AS nb_raid_without_loot,
lpl.loot_date              AS last_loot_date
FROM player                AS p
LEFT JOIN evergp           AS e   ON e.player   = p.id
LEFT JOIN player_nb_loot   AS pnl ON pnl.player = p.id
LEFT JOIN player_nb_raid   AS pnr ON pnr.player = p.id
LEFT JOIN no_loot          AS nl  ON nl.player  = p.id
LEFT JOIN last_player_loot AS lpl ON lpl.player = p.id;

CREATE OR REPLACE VIEW item_priority AS
SELECT  i.id                           AS item,
        p.id                           AS player,
        i.name                         AS item_name,
        p.name                         AS player_name,
        0                              AS point,
        pw.attribution                 AS attribution,
        evergp.ev                      AS ev,
        evergp.er                      AS er,
        evergp.gp                      AS gp,
        ROUND(evergp.evgp_ratio * 100) AS evgp_ratio,
        ROUND(evergp.ergp_ratio * 100) AS ergp_ratio,
        pnl.nb_loot                    AS nb_loot,
        pnr.nb_raid                    AS nb_raid,
        IFNULL(nl.nb_raid, 0)          AS nb_raid_without_loot,
        IFNULL(pww.nb_raid, 0)         AS nb_raid_wait,
        pw.selected,
        lpl.loot_date                  AS last_loot_date
FROM player_wish                  AS pw
INNER JOIN item                   AS i   ON pw.item       = i.id
INNER JOIN player                 AS p   ON pw.player     = p.id
LEFT JOIN no_loot                 AS nl  ON nl.player     = p.id
LEFT JOIN player_nb_loot          AS pnl ON pnl.player    = p.id
LEFT JOIN player_nb_raid          AS pnr ON pnr.player    = p.id
LEFT JOIN player_wish_wait        AS pww ON pww.player    = pw.player
                                        AND pww.item      = pw.item
LEFT JOIN evergp                         ON evergp.player = p.id
LEFT JOIN last_player_loot        AS lpl ON lpl.player    = p.id
WHERE pw.running = true
GROUP BY item, player;


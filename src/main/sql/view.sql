CREATE OR REPLACE VIEW item_priority AS
SELECT i.id AS item, p.id AS player,
       i.name AS item_name, p.name AS player_name,
       IFNULL(sum(r.point * rpw.ratio),0) AS point,
       pw.ratio AS ratio
FROM       raid_player_wish AS rpw
INNER JOIN raid             AS r  ON rpw.raid  = r.id
INNER JOIN player_wish      AS pw ON pw.player = rpw.player AND pw.item = rpw.item AND pw.running = true
INNER JOIN item             AS i  ON pw.item   = i.id
INNER JOIN player           AS p  ON pw.player = p.id
group by item, player;


CREATE OR REPLACE VIEW item_priority AS
SELECT i.id AS item, p.id AS player,
       i.name AS item_name, p.name AS player_name,
       IFNULL(sum(r.point * rpw.ratio), 0) AS point, pw.ratio AS ratio
FROM       player_wish      AS pw
LEFT JOIN  raid_player_wish AS rpw ON pw.player = rpw.player AND pw.item = rpw.item
LEFT JOIN  raid             AS r   ON rpw.raid  = r.id
INNER JOIN item             AS i   ON pw.item   = i.id
INNER JOIN player           AS p   ON pw.player = p.id
WHERE pw.running = true
group by item, player;

CREATE OR REPLACE VIEW item_point_history AS
(
SELECT i.id AS item, i.name AS item_name,
		p.id AS player, p.name AS player_name,
		NULL AS item_loot_name,
		r.point AS point,
		r.date AS date,
		'raid' AS type
FROM raid_entry        AS rp
INNER JOIN raid        AS r   ON r.id = rp.raid
INNER JOIN player      AS p   ON p.id = rp.player
INNER JOIN player_wish AS pw  ON pw.player = rp.player
INNER JOIN item        AS i   ON i.id = pw.item
) UNION (
SELECT i.id AS item, i.name AS item_name,
		p.id AS player, p.name AS player_name,
		il.name AS item_loot_name,
		-pl.ratio AS point,
		r.date AS date,
		'loot' AS type
FROM player_loot       AS pl
INNER JOIN raid        AS r  ON r.id = pl.raid
INNER JOIN player_wish AS pw ON pl.player = pw.player
INNER JOIN item        AS i  ON i.id  = pw.item
INNER JOIN item        AS il ON il.id = pl.item
INNER JOIN player      AS p  ON p.id  = pl.player
where pl.ratio != 0
);

CREATE OR REPLACE VIEW item_priority AS
SELECT pw.item, pw.player, i.name AS item_name, p.name AS player_name,
       IFNULL(sum(iph.point), 0) AS point, pw.ratio AS ratio
FROM       player_wish        AS pw
LEFT JOIN  item_point_history AS iph ON pw.player = iph.player AND pw.item = iph.item
INNER JOIN player             AS p   ON p.id = pw.player
INNER JOIN item               AS i   ON i.id = pw.item
WHERE pw.running = true
group by item, player;

CREATE OR REPLACE VIEW item_point_history_loot AS
SELECT item, player, sum(-point) AS point
FROM item_point_history
WHERE type = 'loot'
GROUP BY item, player;

CREATE OR REPLACE VIEW item_point_history_raid AS
SELECT item, player, sum(point) AS point
FROM item_point_history
WHERE type = 'raid'
GROUP BY item, player;

CREATE OR REPLACE VIEW item_priority AS
SELECT  i.id   AS item,      p.id   AS player,
        i.name AS item_name, p.name AS player_name,
        ROUND(IFNULL(sum(l.point) * 100 / sum(r.point), 0)) AS point,
        pw.ratio           AS ratio,
        IFNULL(sum(l.point), 0) AS nb_loot,
        IFNULL(sum(r.point), 0) AS nb_raid,
        IFNULL(nl.nb_raid, 0)   AS nb_raid_without_loot
FROM player_wish                  AS   pw
INNER JOIN item                   AS i  ON pw.item   = i.id
INNER JOIN player                 AS p  ON pw.player = p.id
LEFT JOIN item_point_history_loot AS l  ON pw.item   = l.item AND pw.player = l.player
LEFT JOIN item_point_history_raid AS r  ON pw.item   = r.item AND pw.player = r.player
LEFT JOIN no_loot                 AS nl ON nl.player = p.id
WHERE pw.running = true
GROUP BY item, player;


CREATE OR REPLACE VIEW last_player_loot AS
SELECT e.player, MAX(r.date) AS loot_date
FROM       raid        AS r
INNER JOIN raid_entry  AS e ON r.id = e.raid
INNER JOIN player_loot AS l ON r.id = l.raid AND l.player = e.player
WHERE pl.ratio >= 10
GROUP BY e.player;

CREATE OR REPLACE VIEW no_loot AS
SELECT sum(r.point) AS nb_raid, e.player
FROM raid AS r
INNER JOIN raid_entry AS e ON e.raid = r.id
WHERE r.date > (SELECT loot_date FROM last_player_loot AS lpl WHERE lpl.player = e.player)
GROUP BY player;

CREATE OR REPLACE VIEW loot_history AS
SELECT i.id AS item_id, i.name AS item_name,
p.id AS player_id, p.name AS player_name,
r.date AS loot_date, r.id AS raid,
CASE
  WHEN pw.ratio IS NOT NULL             THEN 'wishList'
  WHEN pl.ratio >= 10                   THEN 'primary'
  WHEN i.id IN(82, 143, 144, 147, 169)  THEN 'bag'
  ELSE 'secondary'
END AS attribution
FROM player_loot       AS pl
INNER JOIN item        AS i  ON i.id = pl.item
INNER JOIN player      AS p  ON p.id = pl.player
INNER JOIN raid        AS r  ON r.id = pl.raid
LEFT  JOIN player_wish AS pw ON i.id = pw.item AND pw.player = pl.player;

CREATE OR REPLACE VIEW player_wish_wait AS
SELECT i.id AS item, i.name AS item_name, p.id AS player, p.name AS player_name, p.rank, p.class, sum(r.point*rpw.ratio)/10 AS point
FROM raid_player_wish  AS rpw
INNER JOIN player_wish AS pw  ON pw.player = rpw.player AND pw.item = rpw.item AND pw.running = true
INNER JOIN raid        AS r   ON r.id = rpw.raid
INNER JOIN player      AS p   ON p.id = rpw.player
INNER JOIN item        AS i   ON i.id = rpw.item
GROUP BY item, player;

CREATE OR REPLACE VIEW item_priority AS
SELECT  i.id   AS item,      p.id   AS player,
        i.name AS item_name, p.name AS player_name,
        ROUND(IFNULL(sum(l.point) * 100 / sum(r.point), 0)) AS point,
        pw.ratio           AS ratio,
        IFNULL(sum(l.point), 0) AS nb_loot,
        IFNULL(sum(r.point), 0) AS nb_raid,
        IFNULL(nl.nb_raid, 0)   AS nb_raid_without_loot,
        IFNULL(pww.point, 0)    AS nb_raid_wait
FROM player_wish                  AS pw
INNER JOIN item                   AS i   ON pw.item   = i.id
INNER JOIN player                 AS p   ON pw.player = p.id
LEFT JOIN item_point_history_loot AS l   ON pw.item   = l.item AND pw.player = l.player
LEFT JOIN item_point_history_raid AS r   ON pw.item   = r.item AND pw.player = r.player
LEFT JOIN no_loot                 AS nl  ON nl.player = p.id
LEFT JOIN player_wish_wait        AS pww ON pww.player = pw.player AND pww.item = pw.item
WHERE pw.running = true
GROUP BY item, player;

CREATE OR REPLACE VIEW last_raid_attendance AS
SELECT p.id AS player, p.name AS player_name, r.instance, count(r.id) attendance
FROM raid             AS r
INNER JOIN raid_entry AS re ON r.id = re.raid
INNER JOIN player     AS p ON p.id = re.player AND p.rank != 'inactif'
WHERE r.date >= DATE(DATE_SUB(NOW(), INTERVAL 14 DAY))
GROUP BY player, instance;

CREATE OR REPLACE VIEW raid_attendance AS
SELECT p.id AS player, p.name AS player_name, r.instance, count(r.id) attendance
FROM raid             AS r
INNER JOIN raid_entry AS re ON r.id = re.raid
INNER JOIN player     AS p ON p.id = re.player AND p.rank != 'inactif'
GROUP BY player, instance;

CREATE OR REPLACE VIEW loot_history AS
SELECT i.id AS item_id, i.name AS item_name, i.big AS item_big,
p.id AS player_id, p.name AS player_name,
r.date AS loot_date, r.id AS raid,
CASE
  WHEN pw.ratio IS NOT NULL             THEN 'wishList'
  WHEN pl.ratio >= 10                   THEN 'primary'
  WHEN i.id IN(82, 143, 144, 147, 169)  THEN 'bag'
  ELSE 'secondary'
END AS attribution
FROM player_loot       AS pl
INNER JOIN item        AS i  ON i.id = pl.item
INNER JOIN player      AS p  ON p.id = pl.player
INNER JOIN raid        AS r  ON r.id = pl.raid
LEFT  JOIN player_wish AS pw ON i.id = pw.item AND pw.player = pl.player;

CREATE OR REPLACE VIEW raid_size AS
SELECT r.id AS raid, r.name, r.date, count(e.player) AS size
FROM       raid       AS r
INNER JOIN raid_entry AS e ON r.id = e.raid
GROUP BY raid;

CREATE OR REPLACE VIEW raid_ev AS
SELECT r.id AS raid, r.name, r.instance, r.date, rs.size,
  sum(i.gp) AS ev_inital,
  DATEDIFF(CURDATE(),r.date) div 7 AS week_ago,
  ROUND(sum(i.gp) * POWER(0.9, DATEDIFF(CURDATE(),r.date) div 7)) AS ev,
  sum(i.gp) div rs.size AS ev_per_player_initial,
  ROUND(sum(i.gp) * POWER(0.9, DATEDIFF(CURDATE(),r.date) div 7)) DIV rs.size AS ev_per_player
FROM raid AS r
INNER JOIN raid_size   AS rs ON r.id = rs.raid
INNER JOIN player_loot AS pl ON r.id = pl.raid AND pl.ratio > 0
INNER JOIN item        AS i ON i.id = pl.item
WHERE r.point > 0
GROUP BY raid;

CREATE OR REPLACE VIEW player_gp AS
SELECT p.id AS player, p.name, SUM(ROUND(i.gp * POWER(0.85, DATEDIFF(CURDATE(),r.date) div 7))) AS gp
FROM       player      AS p
INNER JOIN player_loot AS pl ON p.id = pl.player AND pl.ratio > 0
INNER JOIN raid        AS r  ON r.id = pl.raid AND r.point > 0
INNER JOIN item        AS i  ON i.id = pl.item
GROUP BY player;

CREATE OR REPLACE VIEW player_ev AS
SELECT p.id AS player, p.name, SUM(ev.ev_per_player) AS ev
FROM       player      AS p
INNER JOIN raid_entry  AS re ON p.id    = re.player
INNER JOIN raid_ev     AS ev ON re.raid = ev.raid
GROUP BY player;

CREATE OR REPLACE VIEW evgp AS
SELECT ev.player, ev.name, ev.ev, gp.gp, gp.gp / ev.ev AS ratio
FROM player_ev AS ev
LEFT JOIN player_gp AS gp ON gp.player = ev.player;

CREATE OR REPLACE VIEW item_priority AS
SELECT  i.id   AS item,      p.id   AS player,
        i.name AS item_name, p.name AS player_name,
        ROUND(IFNULL(sum(l.point) * 100 / sum(r.point), 0)) AS point,
        pw.ratio           AS ratio,
        evgp.ev AS ev,
        evgp.gp AS gp,
        ROUND(evgp.ratio * 100) AS evgp_ratio,
        ROUND(IFNULL(sum(l.point), 0)) AS nb_loot,
        IFNULL(sum(r.point), 0) AS nb_raid,
        IFNULL(nl.nb_raid, 0)   AS nb_raid_without_loot,
        IFNULL(pww.point, 0)    AS nb_raid_wait
FROM player_wish                  AS pw
INNER JOIN item                   AS i   ON pw.item   = i.id
INNER JOIN player                 AS p   ON pw.player = p.id
LEFT JOIN item_point_history_loot AS l   ON pw.item   = l.item AND pw.player = l.player
LEFT JOIN item_point_history_raid AS r   ON pw.item   = r.item AND pw.player = r.player
LEFT JOIN no_loot                 AS nl  ON nl.player = p.id
LEFT JOIN player_wish_wait        AS pww ON pww.player = pw.player AND pww.item = pw.item
LEFT JOIN evgp                           ON evgp.player = p.id
WHERE pw.running = true
GROUP BY item, player;

CREATE OR REPLACE VIEW loot_history AS
SELECT i.id AS item_id, i.name AS item_name, i.big AS item_big,
p.id AS player_id, p.name AS player_name,
r.date AS loot_date, r.id AS raid,
i.gp AS initial_gp,
ROUND(i.gp * POWER(0.85, DATEDIFF(CURDATE(),r.date) div 7)) AS gp,
CASE
  WHEN pl.wl = true                     THEN 'wishList'
  WHEN pl.ratio >= 10                   THEN 'primary'
  WHEN i.id IN(82, 143, 144, 147, 169)  THEN 'bag'
  ELSE 'secondary'
END AS attribution
FROM player_loot       AS pl
INNER JOIN item        AS i  ON i.id = pl.item
INNER JOIN player      AS p  ON p.id = pl.player
INNER JOIN raid        AS r  ON r.id = pl.raid;

CREATE OR REPLACE VIEW raid_ev AS
SELECT r.id AS raid, r.name, r.instance, r.date, rs.size,
  sum(i.gp) AS initial_ev,
  DATEDIFF(CURDATE(),r.date) div 7 AS week_ago,
  ROUND(sum(i.gp) * POWER(0.9, DATEDIFF(CURDATE(),r.date) div 7)) AS ev,
  sum(i.gp) div rs.size AS ev_per_player_initial,
  ROUND(sum(i.gp) * POWER(0.9, DATEDIFF(CURDATE(),r.date) div 7)) DIV rs.size AS ev_per_player
FROM raid AS r
INNER JOIN raid_size   AS rs ON r.id = rs.raid
INNER JOIN player_loot AS pl ON r.id = pl.raid AND pl.ratio > 0
INNER JOIN item        AS i ON i.id = pl.item
WHERE r.point > 0
GROUP BY raid;

CREATE OR REPLACE VIEW item_priority AS
SELECT  i.id   AS item,      p.id   AS player,
        i.name AS item_name, p.name AS player_name,
        ROUND(IFNULL(sum(l.point) * 100 / sum(r.point), 0)) AS point,
        pw.ratio           AS ratio,
        evgp.ev AS ev,
        evgp.gp AS gp,
        ROUND(evgp.ratio * 100) AS evgp_ratio,
        ROUND(IFNULL(sum(l.point), 0)) AS nb_loot,
        IFNULL(sum(r.point), 0) AS nb_raid,
        IFNULL(nl.nb_raid, 0)   AS nb_raid_without_loot,
        IFNULL(pww.point, 0)    AS nb_raid_wait, 
        pw.selected
FROM player_wish                  AS pw
INNER JOIN item                   AS i   ON pw.item   = i.id
INNER JOIN player                 AS p   ON pw.player = p.id
LEFT JOIN item_point_history_loot AS l   ON pw.item   = l.item AND pw.player = l.player
LEFT JOIN item_point_history_raid AS r   ON pw.item   = r.item AND pw.player = r.player
LEFT JOIN no_loot                 AS nl  ON nl.player = p.id
LEFT JOIN player_wish_wait        AS pww ON pww.player = pw.player AND pww.item = pw.item
LEFT JOIN evgp                           ON evgp.player = p.id
WHERE pw.running = true
GROUP BY item, player;



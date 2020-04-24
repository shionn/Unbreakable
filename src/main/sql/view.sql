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
		pw.ratio * r.point AS point,
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
		-pl.ratio * r.point AS point,
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
GROUP BY e.player;

CREATE OR REPLACE VIEW no_loot AS
SELECT sum(r.point)*10 AS nb_raid, e.player
FROM raid AS r
INNER JOIN raid_entry AS e ON e.raid = r.id
WHERE r.date > (SELECT loot_date FROM last_player_loot AS lpl WHERE lpl.player = e.player)
GROUP BY player;

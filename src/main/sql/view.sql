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
SELECT i.id AS item, p.id AS player, i.name AS item_name, NULL AS item_loot_name, p.name AS player_name, rpw.ratio * r.point AS point, r.date AS date, 'raid' AS type
FROM raid_player_wish AS rpw
INNER JOIN raid AS r ON r.id = rpw.raid
INNER JOIN item AS i On i.id = rpw.item
INNER JOIN player AS p ON p.id = rpw.player
) UNION (
SELECT i.id AS item, p.id AS player, i.name AS item_name, il.name AS item_loot_name, p.name AS player_name, -pl.ratio * r.point AS point, r.date AS date, 'loot' AS type
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




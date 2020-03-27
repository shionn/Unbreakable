CREATE OR REPLACE VIEW item_priority AS
SELECT i.id AS item, p.id AS player, i.name AS item_name, p.name AS player_name, sum(r.point * rpw.ratio) AS point, pw.ratio AS ratio
FROM       raid_player_wish AS rpw
INNER JOIN raid             AS r  ON rpw.raid  = r.id
INNER JOIN player_wish      AS pw ON pw.player = rpw.player AND pw.item = rpw.item AND pw.running = true
INNER JOIN item             AS i  ON pw.item   = i.id
INNER JOIN player           AS p  ON pw.player = p.id
group by item, player

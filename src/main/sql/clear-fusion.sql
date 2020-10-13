


DELETE FROM raid_player_wish WHERE raid IN (SELECT id FROM raid WHERE date < '2020-09-23');
DELETE FROM player_loot WHERE raid IN (SELECT id FROM raid WHERE date < '2020-09-23');
DELETE FROM raid_entry WHERE raid IN (SELECT id FROM raid WHERE date < '2020-09-23');
DELETE FROM raid WHERE date < '2020-09-23';

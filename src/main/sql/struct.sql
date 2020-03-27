-- phpMyAdmin SQL Dump
-- version 4.6.6deb4
-- https://www.phpmyadmin.net/
--
-- Client :  localhost:3306
-- Généré le :  Ven 27 Mars 2020 à 12:27
-- Version du serveur :  10.1.26-MariaDB-0+deb9u1
-- Version de PHP :  7.0.33-0+deb9u5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `ubk`
--

-- --------------------------------------------------------

--
-- Structure de la table `item`
--

CREATE TABLE `item` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `raid` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `item_prio`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `item_prio` (
`item` int(11)
,`player` int(11)
,`item_name` varchar(64)
,`player_name` varchar(64)
,`point` decimal(42,0)
);

-- --------------------------------------------------------

--
-- Structure de la table `player`
--

CREATE TABLE `player` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `class` varchar(16) NOT NULL,
  `rank` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `player_wish`
--

CREATE TABLE `player_wish` (
  `player` int(11) NOT NULL,
  `item` int(11) NOT NULL,
  `ratio` int(11) NOT NULL,
  `running` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `raid`
--

CREATE TABLE `raid` (
  `id` int(11) NOT NULL,
  `name` varchar(128) NOT NULL,
  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `point` int(11) NOT NULL,
  `running` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `raid_entry`
--

CREATE TABLE `raid_entry` (
  `raid` int(11) NOT NULL,
  `player` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `raid_player_wish`
--

CREATE TABLE `raid_player_wish` (
  `raid` int(11) NOT NULL,
  `player` int(11) NOT NULL,
  `item` int(11) NOT NULL,
  `ratio` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `name` varchar(128) NOT NULL,
  `email` varchar(128) NOT NULL,
  `pass` varchar(256) NOT NULL,
  `role` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la vue `item_prio`
--
DROP TABLE IF EXISTS `item_prio`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `item_prio`  AS  select `i`.`id` AS `item`,`p`.`id` AS `player`,`i`.`name` AS `item_name`,`p`.`name` AS `player_name`,sum((`r`.`point` * `rpw`.`ratio`)) AS `point` from ((((`raid_player_wish` `rpw` join `raid` `r` on((`rpw`.`raid` = `r`.`id`))) join `player_wish` `pw` on(((`pw`.`player` = `rpw`.`player`) and (`pw`.`item` = `rpw`.`item`) and (`pw`.`running` = 1)))) join `item` `i` on((`pw`.`item` = `i`.`id`))) join `player` `p` on((`pw`.`player` = `p`.`id`))) group by `i`.`id`,`p`.`id` ;

--
-- Index pour les tables exportées
--

--
-- Index pour la table `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `player`
--
ALTER TABLE `player`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `player_wish`
--
ALTER TABLE `player_wish`
  ADD PRIMARY KEY (`player`,`item`),
  ADD KEY `item` (`item`);

--
-- Index pour la table `raid`
--
ALTER TABLE `raid`
  ADD PRIMARY KEY (`id`),
  ADD KEY `running` (`running`);

--
-- Index pour la table `raid_entry`
--
ALTER TABLE `raid_entry`
  ADD PRIMARY KEY (`raid`,`player`),
  ADD KEY `raid-entry-player` (`player`);

--
-- Index pour la table `raid_player_wish`
--
ALTER TABLE `raid_player_wish`
  ADD PRIMARY KEY (`raid`,`player`,`item`),
  ADD KEY `player` (`player`,`item`);

--
-- Index pour la table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT pour les tables exportées
--

--
-- AUTO_INCREMENT pour la table `item`
--
ALTER TABLE `item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT pour la table `player`
--
ALTER TABLE `player`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT pour la table `raid`
--
ALTER TABLE `raid`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT pour la table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `player_wish`
--
ALTER TABLE `player_wish`
  ADD CONSTRAINT `player_wish_ibfk_1` FOREIGN KEY (`player`) REFERENCES `player` (`id`),
  ADD CONSTRAINT `player_wish_ibfk_2` FOREIGN KEY (`item`) REFERENCES `item` (`id`);

--
-- Contraintes pour la table `raid_entry`
--
ALTER TABLE `raid_entry`
  ADD CONSTRAINT `raid_entry_ibfk_1` FOREIGN KEY (`raid`) REFERENCES `raid` (`id`),
  ADD CONSTRAINT `raid_entry_ibfk_2` FOREIGN KEY (`player`) REFERENCES `player` (`id`);

--
-- Contraintes pour la table `raid_player_wish`
--
ALTER TABLE `raid_player_wish`
  ADD CONSTRAINT `raid_player_wish_ibfk_1` FOREIGN KEY (`raid`,`player`) REFERENCES `raid_entry` (`raid`, `player`),
  ADD CONSTRAINT `raid_player_wish_ibfk_2` FOREIGN KEY (`player`,`item`) REFERENCES `player_wish` (`player`, `item`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

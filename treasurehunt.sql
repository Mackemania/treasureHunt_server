-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Värd: 127.0.0.1
-- Tid vid skapande: 01 feb 2018 kl 10:57
-- Serverversion: 10.1.19-MariaDB
-- PHP-version: 7.0.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Databas: `treasurehunt`
--

-- --------------------------------------------------------

--
-- Tabellstruktur `category`
--

CREATE TABLE `category` (
  `categoryID` int(11) NOT NULL,
  `name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellstruktur `challenge`
--

CREATE TABLE `challenge` (
  `challengeID` int(11) NOT NULL,
  `name` varchar(20) NOT NULL,
  `description` text NOT NULL,
  `needProps` tinyint(1) NOT NULL,
  `creatorID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellstruktur `challenge_category`
--

CREATE TABLE `challenge_category` (
  `ID` int(11) NOT NULL,
  `challengeID` int(11) NOT NULL,
  `categoryID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellstruktur `gameroom`
--

CREATE TABLE `gameroom` (
  `roomID` int(11) NOT NULL,
  `roomcode` varchar(8) NOT NULL,
  `roomname` varchar(20) NOT NULL,
  `creatorID` int(11) NOT NULL,
  `gameOver` tinyint(1)NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellstruktur `hash`
--

CREATE TABLE `hash` (
  `hashID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `loginTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `hashkey` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellstruktur `location`
--

CREATE TABLE `location` (
  `locationID` int(11) NOT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL,
  `creatorID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellstruktur `users`
--

CREATE TABLE `users` (
  `userID` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `lastName` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumpning av Data i tabell `users`

-- --------------------------------------------------------

--
-- Tabellstruktur `user_room`
--

CREATE TABLE `user_room` (
  `userRoomID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `roomID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Index för dumpade tabeller
--

--
-- Index för tabell `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`categoryID`),
  ADD UNIQUE KEY `UNIQUE` (`name`);

--
-- Index för tabell `challenge`
--
ALTER TABLE `challenge`
  ADD PRIMARY KEY (`challengeID`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `creatorID` (`creatorID`);

--
-- Index för tabell `challenge_category`
--
ALTER TABLE `challenge_category`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `categoryID` (`categoryID`),
  ADD KEY `challengeID` (`challengeID`);

--
-- Index för tabell `gameroom`
--
ALTER TABLE `gameroom`
  ADD PRIMARY KEY (`roomID`),
  ADD KEY `creatorID` (`creatorID`);

--
-- Index för tabell `hash`
--
ALTER TABLE `hash`
  ADD PRIMARY KEY (`hashID`),
  ADD UNIQUE KEY `UNIQUE` (`hashkey`),
  ADD KEY `userID` (`userID`);

--
-- Index för tabell `location`
--
ALTER TABLE `location`
  ADD PRIMARY KEY (`locationID`),
  ADD KEY `creatorID` (`creatorID`);

--
-- Index för tabell `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`userID`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Index för tabell `user_room`
--
ALTER TABLE `user_room`
  ADD PRIMARY KEY (`userRoomID`),
  ADD KEY `userID` (`userID`),
  ADD KEY `roomID` (`roomID`);

--
-- AUTO_INCREMENT för dumpade tabeller
--

--
-- AUTO_INCREMENT för tabell `category`
--
ALTER TABLE `category`
  MODIFY `categoryID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT för tabell `challenge`
--
ALTER TABLE `challenge`
  MODIFY `challengeID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT för tabell `challenge_category`
--
ALTER TABLE `challenge_category`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT för tabell `gameroom`
--
ALTER TABLE `gameroom`
  MODIFY `roomID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT för tabell `hash`
--
ALTER TABLE `hash`
  MODIFY `hashID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT för tabell `location`
--
ALTER TABLE `location`
  MODIFY `locationID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT för tabell `users`
--
ALTER TABLE `users`
  MODIFY `userID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT för tabell `user_room`
--
ALTER TABLE `user_room`
  MODIFY `userRoomID` int(11) NOT NULL AUTO_INCREMENT;
--
-- Restriktioner för dumpade tabeller
--

--
-- Restriktioner för tabell `challenge`
--
ALTER TABLE `challenge`
  ADD CONSTRAINT `challenge_ibfk_1` FOREIGN KEY (`creatorID`) REFERENCES `users` (`userID`);

--
-- Restriktioner för tabell `challenge_category`
--
ALTER TABLE `challenge_category`
  ADD CONSTRAINT `challenge_category_ibfk_1` FOREIGN KEY (`challengeID`) REFERENCES `challenge` (`challengeID`),
  ADD CONSTRAINT `challenge_category_ibfk_2` FOREIGN KEY (`categoryID`) REFERENCES `category` (`categoryID`);

--
-- Restriktioner för tabell `gameroom`
--
ALTER TABLE `gameroom`
  ADD CONSTRAINT `gameroom_ibfk_1` FOREIGN KEY (`creatorID`) REFERENCES `users` (`userID`);

--
-- Restriktioner för tabell `hash`
--
ALTER TABLE `hash`
  ADD CONSTRAINT `hash_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`);

--
-- Restriktioner för tabell `location`
--
ALTER TABLE `location`
  ADD CONSTRAINT `location_ibfk_1` FOREIGN KEY (`creatorID`) REFERENCES `users` (`userID`);

--
-- Restriktioner för tabell `user_room`
--
ALTER TABLE `user_room`
  ADD CONSTRAINT `user_room_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`),
  ADD CONSTRAINT `user_room_ibfk_2` FOREIGN KEY (`roomID`) REFERENCES `gameroom` (`roomID`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

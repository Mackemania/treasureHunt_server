-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Värd: 127.0.0.1
-- Tid vid skapande: 07 feb 2018 kl 13:36
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
  `gameOver` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellstruktur `gameroom_challenge`
--

CREATE TABLE `gameroom_challenge` (
  `roomChallengeID` int(11) NOT NULL,
  `roomID` int(11) NOT NULL,
  `challengeID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellstruktur `gameroom_location`
--

CREATE TABLE `gameroom_location` (
  `gameLocationID` int(11) NOT NULL,
  `gameroomID` int(11) NOT NULL,
  `locationID` int(11) NOT NULL
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

--
-- Dumpning av Data i tabell `location`
--

INSERT INTO `location` (`locationID`, `latitude`, `longitude`, `creatorID`) VALUES
(1, 58.39713731780648, 13.877248456701636, 1),
(2, 58.39713731780648, 13.897248456701636, 1),
(3, 58.397079, 13.87697, 1);

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
--

INSERT INTO `users` (`userID`, `username`, `password`, `firstName`, `lastName`) VALUES
(1, 'Mackemania', 'Admin', 'M', 'M'),
(2, 'a', 'a', 'a', 'a');

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
-- Dumpning av Data i tabell `user_room`
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
-- Index för tabell `gameroom_challenge`
--
ALTER TABLE `gameroom_challenge`
  ADD PRIMARY KEY (`roomChallengeID`),
  ADD KEY `INDEX` (`challengeID`),
  ADD KEY `roomID` (`roomID`),
  ADD KEY `challengeID` (`challengeID`);

--
-- Index för tabell `gameroom_location`
--
ALTER TABLE `gameroom_location`
  ADD PRIMARY KEY (`gameLocationID`),
  ADD KEY `gameroomID` (`gameroomID`),
  ADD KEY `locationID` (`locationID`);

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
-- AUTO_INCREMENT för tabell `gameroom_challenge`
--
ALTER TABLE `gameroom_challenge`
  MODIFY `roomChallengeID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT för tabell `gameroom_location`
--
ALTER TABLE `gameroom_location`
  MODIFY `gameLocationID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT för tabell `hash`
--
ALTER TABLE `hash`
  MODIFY `hashID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT för tabell `location`
--
ALTER TABLE `location`
  MODIFY `locationID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT för tabell `users`
--
ALTER TABLE `users`
  MODIFY `userID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
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
-- Restriktioner för tabell `gameroom_challenge`
--
ALTER TABLE `gameroom_challenge`
  ADD CONSTRAINT `gameroom_challenge_ibfk_1` FOREIGN KEY (`roomID`) REFERENCES `gameroom` (`roomID`),
  ADD CONSTRAINT `gameroom_challenge_ibfk_2` FOREIGN KEY (`challengeID`) REFERENCES `gameroom` (`roomID`);

--
-- Restriktioner för tabell `gameroom_location`
--
ALTER TABLE `gameroom_location`
  ADD CONSTRAINT `gameroom_location_ibfk_1` FOREIGN KEY (`gameroomID`) REFERENCES `gameroom` (`roomID`),
  ADD CONSTRAINT `gameroom_location_ibfk_2` FOREIGN KEY (`locationID`) REFERENCES `location` (`locationID`);

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

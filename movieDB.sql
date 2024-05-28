-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: May 28, 2024 at 08:34 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `movieDB`
--

-- --------------------------------------------------------

--
-- Table structure for table `movies`
--

CREATE TABLE `movies` (
  `movie_id` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `release_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `genre` varchar(255) DEFAULT NULL,
  `runtime` time DEFAULT NULL,
  `rating` varchar(255) DEFAULT NULL,
  `budget` int(11) DEFAULT NULL,
  `collection` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `movie_person_mapping`
--

CREATE TABLE `movie_person_mapping` (
  `mapping_id` int(11) NOT NULL,
  `movie_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `person`
--

CREATE TABLE `person` (
  `person_id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `roletype_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roletype`
--

CREATE TABLE `roletype` (
  `roletype_id` int(11) NOT NULL,
  `type_name` varchar(255) DEFAULT NULL COMMENT 'e.g. actor, director, producer',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `movies`
--
ALTER TABLE `movies`
  ADD PRIMARY KEY (`movie_id`);

--
-- Indexes for table `movie_person_mapping`
--
ALTER TABLE `movie_person_mapping`
  ADD PRIMARY KEY (`mapping_id`),
  ADD KEY `movie_person_mapping_ibfk_1` (`movie_id`),
  ADD KEY `movie_person_mapping_ibfk_2` (`person_id`);

--
-- Indexes for table `person`
--
ALTER TABLE `person`
  ADD PRIMARY KEY (`person_id`),
  ADD KEY `roletype_id` (`roletype_id`);

--
-- Indexes for table `roletype`
--
ALTER TABLE `roletype`
  ADD PRIMARY KEY (`roletype_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `movie_person_mapping`
--
ALTER TABLE `movie_person_mapping`
  ADD CONSTRAINT `movie_person_mapping_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`movie_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `movie_person_mapping_ibfk_2` FOREIGN KEY (`person_id`) REFERENCES `person` (`person_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `person`
--
ALTER TABLE `person`
  ADD CONSTRAINT `person_ibfk_1` FOREIGN KEY (`roletype_id`) REFERENCES `roletype` (`roletype_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

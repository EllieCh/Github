-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Oct 13, 2015 at 03:15 AM
-- Server version: 5.6.17
-- PHP Version: 5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `babies`
--

-- --------------------------------------------------------

--
-- Table structure for table `babynames`
--

CREATE TABLE IF NOT EXISTS `babynames` (
  `year` int(11) NOT NULL,
  `rank` int(11) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `name` varchar(20) NOT NULL,
  PRIMARY KEY (`year`,`rank`,`gender`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `babynames`
--

INSERT INTO `babynames` (`year`, `rank`, `gender`, `name`) VALUES
(2005, 1, 'Female', 'Emily'),
(2005, 1, 'Male', 'Jacob'),
(2006, 1, 'Female', 'Emily'),
(2006, 1, 'Male', 'Jacob'),
(2007, 1, 'Female', 'Emily'),
(2007, 1, 'Male', 'Jacob'),
(2008, 1, 'Female', 'Emma'),
(2008, 1, 'Male', 'Jacob'),
(2009, 1, 'Female', 'Isabella'),
(2009, 1, 'Male', 'Jacob'),
(2010, 1, 'Female', 'Isabella'),
(2010, 1, 'Male', 'Jacob'),
(2011, 1, 'Female', 'Sophia'),
(2011, 1, 'Male', 'Jacob'),
(2012, 1, 'Female', 'Sophia'),
(2012, 1, 'Male', 'Jacob'),
(2013, 1, 'Female', 'Sophia'),
(2013, 1, 'Male', 'Noah'),
(2014, 1, 'Female', 'Emma'),
(2014, 1, 'Male', 'Noah');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

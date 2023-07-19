-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 19, 2023 at 07:39 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `puskesmas`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_pasien_dokter_by_spesialis` (IN `spesialis_param` VARCHAR(100))   BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE pasien_id INT;
  DECLARE dokter_id INT;
 
  DECLARE cur CURSOR FOR 
    SELECT id_pasien, id_dokter 
    FROM periksa 
    WHERE id_dokter IN (SELECT id_dokter FROM dokter WHERE spesialis = spesialis_param);
    

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  

  CREATE TEMPORARY TABLE temp_pasien_dokter (
    nama_pasien VARCHAR(100),
    nama_dokter VARCHAR(100),
    spesialis VARCHAR(100)
  );

  OPEN cur;

  read_loop: LOOP
    FETCH cur INTO pasien_id, dokter_id;
    IF done THEN
      LEAVE read_loop;
    END IF;
    
    INSERT INTO temp_pasien_dokter (nama_pasien, nama_dokter, spesialis)
    SELECT p.nama, d.nama, d.spesialis
    FROM pasien p
    JOIN dokter d ON p.id_pasien = pasien_id AND d.id_dokter = dokter_id;
  END LOOP;

  CLOSE cur;

  SELECT * FROM temp_pasien_dokter;

  DROP TEMPORARY TABLE temp_pasien_dokter;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `namadokter_by_pasien` (`pasien_id` INT) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
  DECLARE nama_dokter VARCHAR(100);
  SELECT dokter.nama INTO nama_dokter
  FROM dokter
  JOIN periksa ON dokter.id_dokter = periksa.id_dokter
  WHERE periksa.id_pasien = pasien_id
  LIMIT 1;
  RETURN nama_dokter;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `catatan_medis`
--

CREATE TABLE `catatan_medis` (
  `id` int(11) NOT NULL,
  `id_pasien` int(11) DEFAULT NULL,
  `id_penyakit` int(11) DEFAULT NULL,
  `id_obat` int(11) DEFAULT NULL,
  `diagnosis` varchar(100) DEFAULT NULL,
  `resep` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `catatan_medis`
--

INSERT INTO `catatan_medis` (`id`, `id_pasien`, `id_penyakit`, `id_obat`, `diagnosis`, `resep`) VALUES
(1, 1, 3, 1, 'Demam', 'Parasetamol 500mg, Minum 3x sehari setelah makan'),
(2, 2, 4, 2, 'Sakit Tenggorokan', 'Amoksisilin 500mg, Minum 2x sehari selama 7 hari'),
(3, 3, 5, 3, 'Alergi', 'Ibuprofen 200mg, Minum 2x sehari setelah makan'),
(4, 1, 2, 4, 'Sakit Kepala', 'Deksametason 0,5mg, Minum 1x sehari selama 3 hari'),
(5, 5, 7, 5, 'Pilek', 'Loratadin 10mg, Minum 1x sehari setelah makan'),
(6, 7, 1, 6, 'Flu', 'Metformin 500mg, Minum 2x sehari setelah makan'),
(7, 10, 9, 7, 'Batuk', 'Cetirizine 5mg, Minum 1x sehari sebelum tidur'),
(8, 8, 6, 8, 'Keseleo', 'Omeprazole 20mg, Minum 1x sehari sebelum makan'),
(9, 4, 8, 9, 'Sakit Perut', 'Asam Mefenamat 500mg, Minum 3x sehari setelah makan'),
(10, 6, 10, 10, 'Infeksi Telinga', 'Simvastatin 40mg, Minum 1x sehari sebelum tidur'),
(11, 2, 11, 11, 'Asma', 'Salbutamol inhaler, Gunakan saat sesak nafas'),
(12, 12, 12, 12, 'Diabetes', 'Glibenklamid 5mg, Minum 2x sehari setelah makan'),
(13, 5, 7, 5, 'Pilek', 'Loratadin 10mg, Minum 1x sehari setelah makan'),
(14, 1, 1, 2, 'Flu', 'Paracetamol 500mg 3x1'),
(15, 2, 3, 4, 'Sakit Perut', 'Maagguard 20mg 2x1'),
(16, 3, 2, 3, 'Demam', 'Ibuprofen 400mg 3x1'),
(17, 4, 5, 6, 'Luka Ringan', 'Betadine Ointment'),
(18, 5, 2, 3, 'Batuk dan Pilek', 'Mucos Drop 2x1');

-- --------------------------------------------------------

--
-- Table structure for table `dokter`
--

CREATE TABLE `dokter` (
  `id_dokter` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `spesialis` varchar(100) DEFAULT NULL,
  `kontak` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dokter`
--

INSERT INTO `dokter` (`id_dokter`, `nama`, `spesialis`, `kontak`) VALUES
(1, 'Dr. Asyer', 'Gigi', '12345678'),
(2, 'Dr. Gunawan', 'Kandungan', '98765432'),
(3, 'Dr. Husi', 'Mata', '11111111'),
(4, 'Dr. Amru', 'Organ Dalam', '22222222'),
(5, 'Dr. Maul', 'Anak', '33333333'),
(6, 'Dr. Raze', 'Psikologis', '444444444');

-- --------------------------------------------------------

--
-- Table structure for table `log_catatan_medis`
--

CREATE TABLE `log_catatan_medis` (
  `id_log` int(11) NOT NULL,
  `id_pasien` int(11) DEFAULT NULL,
  `id_dokter` int(11) DEFAULT NULL,
  `tanggal_periksa` datetime DEFAULT NULL,
  `diagnosis` varchar(100) DEFAULT NULL,
  `resep` varchar(200) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `log_catatan_medis`
--

INSERT INTO `log_catatan_medis` (`id_log`, `id_pasien`, `id_dokter`, `tanggal_periksa`, `diagnosis`, `resep`, `created_at`) VALUES
(1, 5, 5, '2023-07-19 23:36:22', 'Pilek', 'Loratadin 10mg, Minum 1x sehari setelah makan', '2023-07-19 23:36:22'),
(2, 1, 1, '2023-07-19 23:40:25', 'Flu', 'Paracetamol 500mg 3x1', '2023-07-19 23:40:25'),
(3, 2, 2, '2023-07-19 23:40:25', 'Sakit Perut', 'Maagguard 20mg 2x1', '2023-07-19 23:40:25'),
(4, 3, 3, '2023-07-19 23:40:25', 'Demam', 'Ibuprofen 400mg 3x1', '2023-07-19 23:40:25'),
(5, 4, 4, '2023-07-19 23:40:25', 'Luka Ringan', 'Betadine Ointment', '2023-07-19 23:40:25'),
(6, 5, 5, '2023-07-19 23:40:25', 'Batuk dan Pilek', 'Mucos Drop 2x1', '2023-07-19 23:40:25');

-- --------------------------------------------------------

--
-- Table structure for table `obat`
--

CREATE TABLE `obat` (
  `id_obat` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `obat`
--

INSERT INTO `obat` (`id_obat`, `nama`) VALUES
(1, 'Parasetamol'),
(2, 'Amoksisilin'),
(3, 'Ibuprofen'),
(4, 'Deksametason'),
(5, 'Loratadin'),
(6, 'Metformin'),
(7, 'Cetirizine'),
(8, 'Omeprazole'),
(9, 'Asam Mefenamat'),
(10, 'Simvastatin'),
(11, 'Salbutamol'),
(12, 'Glibenklamid'),
(13, 'Metronidazol');

-- --------------------------------------------------------

--
-- Table structure for table `pasien`
--

CREATE TABLE `pasien` (
  `id_pasien` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `alamat` varchar(200) DEFAULT NULL,
  `tgl_lahir` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pasien`
--

INSERT INTO `pasien` (`id_pasien`, `nama`, `alamat`, `tgl_lahir`) VALUES
(1, 'Jana', 'Jl. Raya No. 123', '1990-05-15'),
(2, 'Agus', 'Jl. Anggrek No. 456', '1985-08-20'),
(3, 'Julia', 'Jl. Melati No. 789', '1998-12-10'),
(4, 'Desi', 'Jl. Mawar No. 321', '2000-02-28'),
(5, 'Okta', 'Jl. Cempaka No. 654', '1992-11-07'),
(6, 'Mei', 'Jl. Dahlia No. 987', '1994-09-12'),
(7, 'Febrianto', 'Jl. Tulip No. 456', '1997-04-25'),
(8, 'Junaidi', 'Jl. Mawar No. 123', '1988-06-30'),
(9, 'March', 'Jl. Anggrek No. 111', '1996-07-05'),
(10, 'Aprilia', 'Jl. Melati No. 222', '1989-03-18'),
(11, 'Septi', 'Jl. Raya No. 333', '1993-11-22'),
(12, 'Novian', 'Jl. Cempaka No. 444', '1991-09-09');

-- --------------------------------------------------------

--
-- Table structure for table `pasien_dokter`
--

CREATE TABLE `pasien_dokter` (
  `id_pasien` int(11) NOT NULL,
  `id_dokter` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pasien_dokter`
--

INSERT INTO `pasien_dokter` (`id_pasien`, `id_dokter`) VALUES
(1, 1),
(2, 2),
(3, 3),
(3, 6),
(4, 4),
(5, 5),
(6, 1),
(7, 2),
(7, 6),
(8, 3),
(9, 4),
(10, 5),
(11, 1),
(12, 2),
(12, 6);

-- --------------------------------------------------------

--
-- Table structure for table `penyakit`
--

CREATE TABLE `penyakit` (
  `id_penyakit` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `penyakit`
--

INSERT INTO `penyakit` (`id_penyakit`, `nama`) VALUES
(1, 'Flu'),
(2, 'Sakit Kepala'),
(3, 'Demam'),
(4, 'Sakit Tenggorokan'),
(5, 'Alergi'),
(6, 'Keseleo'),
(7, 'Pilek'),
(8, 'Sakit Perut'),
(9, 'Batuk'),
(10, 'Infeksi Telinga'),
(11, 'Asma'),
(12, 'Diabetes');

-- --------------------------------------------------------

--
-- Table structure for table `periksa`
--

CREATE TABLE `periksa` (
  `id_periksa` int(11) NOT NULL,
  `id_dokter` int(11) DEFAULT NULL,
  `id_pasien` int(11) DEFAULT NULL,
  `tanggal_periksa` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `periksa`
--

INSERT INTO `periksa` (`id_periksa`, `id_dokter`, `id_pasien`, `tanggal_periksa`) VALUES
(1, 1, 1, '2023-07-10 08:00:00'),
(2, 2, 2, '2023-07-11 10:30:00'),
(3, 3, 3, '2023-07-12 09:15:00'),
(4, 4, 4, '2023-07-13 13:45:00'),
(5, 5, 5, '2023-07-14 11:00:00'),
(6, 1, 6, '2023-07-15 14:30:00'),
(7, 2, 7, '2023-07-16 15:00:00'),
(8, 3, 8, '2023-07-17 12:45:00'),
(9, 4, 9, '2023-07-18 10:00:00'),
(10, 5, 10, '2023-07-19 08:30:00'),
(11, 1, 11, '2023-07-20 14:00:00'),
(12, 2, 5, '2023-07-21 11:45:00'),
(13, 3, 12, '2023-07-22 09:30:00'),
(14, 4, 3, '2023-07-23 15:15:00'),
(15, 6, 1, '2023-08-11 08:00:00'),
(16, 6, 7, '2023-05-19 07:00:00'),
(17, 4, 6, '2023-05-19 09:00:00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `catatan_medis`
--
ALTER TABLE `catatan_medis`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_pasien` (`id_pasien`),
  ADD KEY `id_penyakit` (`id_penyakit`),
  ADD KEY `id_obat` (`id_obat`);

--
-- Indexes for table `dokter`
--
ALTER TABLE `dokter`
  ADD PRIMARY KEY (`id_dokter`);

--
-- Indexes for table `log_catatan_medis`
--
ALTER TABLE `log_catatan_medis`
  ADD PRIMARY KEY (`id_log`);

--
-- Indexes for table `obat`
--
ALTER TABLE `obat`
  ADD PRIMARY KEY (`id_obat`);

--
-- Indexes for table `pasien`
--
ALTER TABLE `pasien`
  ADD PRIMARY KEY (`id_pasien`);

--
-- Indexes for table `pasien_dokter`
--
ALTER TABLE `pasien_dokter`
  ADD PRIMARY KEY (`id_pasien`,`id_dokter`),
  ADD KEY `id_dokter` (`id_dokter`);

--
-- Indexes for table `penyakit`
--
ALTER TABLE `penyakit`
  ADD PRIMARY KEY (`id_penyakit`);

--
-- Indexes for table `periksa`
--
ALTER TABLE `periksa`
  ADD PRIMARY KEY (`id_periksa`),
  ADD KEY `id_dokter` (`id_dokter`),
  ADD KEY `id_pasien` (`id_pasien`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `log_catatan_medis`
--
ALTER TABLE `log_catatan_medis`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `catatan_medis`
--
ALTER TABLE `catatan_medis`
  ADD CONSTRAINT `catatan_medis_ibfk_1` FOREIGN KEY (`id_pasien`) REFERENCES `pasien` (`id_pasien`),
  ADD CONSTRAINT `catatan_medis_ibfk_2` FOREIGN KEY (`id_penyakit`) REFERENCES `penyakit` (`id_penyakit`),
  ADD CONSTRAINT `catatan_medis_ibfk_3` FOREIGN KEY (`id_obat`) REFERENCES `obat` (`id_obat`);

--
-- Constraints for table `pasien_dokter`
--
ALTER TABLE `pasien_dokter`
  ADD CONSTRAINT `pasien_dokter_ibfk_1` FOREIGN KEY (`id_pasien`) REFERENCES `pasien` (`id_pasien`),
  ADD CONSTRAINT `pasien_dokter_ibfk_2` FOREIGN KEY (`id_dokter`) REFERENCES `dokter` (`id_dokter`);

--
-- Constraints for table `periksa`
--
ALTER TABLE `periksa`
  ADD CONSTRAINT `periksa_ibfk_1` FOREIGN KEY (`id_dokter`) REFERENCES `dokter` (`id_dokter`),
  ADD CONSTRAINT `periksa_ibfk_2` FOREIGN KEY (`id_pasien`) REFERENCES `pasien` (`id_pasien`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

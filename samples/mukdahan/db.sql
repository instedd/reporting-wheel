-- phpMyAdmin SQL Dump
-- version 3.2.5
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 26, 2010 at 05:04 PM
-- Server version: 5.1.44
-- PHP Version: 5.3.2

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `geochat`
--

-- --------------------------------------------------------

--
-- Table structure for table `diseases_code`
--

CREATE TABLE IF NOT EXISTS `diseases_code` (
  `ds_code` int(11) NOT NULL DEFAULT '0',
  `Diseases` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `code_thai` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ds_code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `diseases_code`
--

INSERT INTO `diseases_code` VALUES(1, 'Avian Flu', '');
INSERT INTO `diseases_code` VALUES(2, 'AFP', '65');
INSERT INTO `diseases_code` VALUES(3, 'SARS', '');
INSERT INTO `diseases_code` VALUES(4, 'Cholera/Severe Diarrhea', '02');
INSERT INTO `diseases_code` VALUES(5, 'Encephalitis', '28');
INSERT INTO `diseases_code` VALUES(6, 'Tetanus', '');
INSERT INTO `diseases_code` VALUES(7, 'Meningitis', '');
INSERT INTO `diseases_code` VALUES(8, 'Diphtheria', '23');
INSERT INTO `diseases_code` VALUES(9, 'PHEIC', '');
INSERT INTO `diseases_code` VALUES(10, 'Dengue fever', '66');
INSERT INTO `diseases_code` VALUES(11, 'Typhoid fever', '');
INSERT INTO `diseases_code` VALUES(12, 'Measles', '');
INSERT INTO `diseases_code` VALUES(13, 'Leptospirosis', '43');
INSERT INTO `diseases_code` VALUES(14, 'Chikungunya', '');
INSERT INTO `diseases_code` VALUES(15, 'Malaria', '309');
INSERT INTO `diseases_code` VALUES(16, 'Pneumonia', '');
INSERT INTO `diseases_code` VALUES(17, 'HIV/AIDs', '');
INSERT INTO `diseases_code` VALUES(18, 'Tuberculosis', '');
INSERT INTO `diseases_code` VALUES(19, 'อุจจาระร่วง', NULL);
INSERT INTO `diseases_code` VALUES(20, 'อาหารเป็นพิษ', NULL);
INSERT INTO `diseases_code` VALUES(21, 'บิด', NULL);
INSERT INTO `diseases_code` VALUES(22, 'โรคตาแดง', NULL);
INSERT INTO `diseases_code` VALUES(23, 'สุกใส', NULL);
INSERT INTO `diseases_code` VALUES(24, 'หัด', NULL);
INSERT INTO `diseases_code` VALUES(25, 'คางทูม', NULL);
INSERT INTO `diseases_code` VALUES(26, 'งูกัด', NULL);
INSERT INTO `diseases_code` VALUES(27, 'กินเห็ดมีพิษ', NULL);
INSERT INTO `diseases_code` VALUES(28, 'งูสวัด', NULL);
INSERT INTO `diseases_code` VALUES(29, 'ILI', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `gis_village_thai`
--

CREATE TABLE IF NOT EXISTS `gis_village_thai` (
  `vill_code` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `vill_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lat` float DEFAULT NULL,
  `long_` float DEFAULT NULL,
  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`vill_code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `gis_village_thai`
--

INSERT INTO `gis_village_thai` VALUES('49010101', 'KHAM TU NANG', 16.5646, 104.658, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010102', 'NA KHAM NOI', 16.5564, 104.632, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010103', 'SUN MAI', 16.5449, 104.665, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010104', 'KUT NGONG NOI', 16.5599, 104.647, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010105', 'KUT NGONG YAI', 16.5701, 104.651, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010106', 'DAN KHAM', 16.5732, 104.686, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010301', 'PA RAI', 16.6166, 104.537, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010302', 'BAN KHOK', 16.6271, 104.542, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010303', 'NONG BUA', 16.6184, 104.522, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010304', 'PA KLUAI', 16.635, 104.531, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010305', 'PHANG KHONG', 16.6178, 104.557, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010306', 'SONG PUAI', 16.6117, 104.578, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010307', 'PA WAI', 16.6375, 104.539, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010308', 'NONG WAENG NUA', 16.5878, 104.532, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010309', 'NONG WEANG', 16.5788, 104.529, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010310', 'PHANG KHONG', 16.6131, 104.556, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010311', 'KHOK HIN TANG', 16.6149, 104.583, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010312', 'NON SA_AT', 16.5842, 104.527, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010313', 'NONG CHOT', 16.559, 104.53, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010401', 'BANG SAI YAI', 16.6118, 104.743, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010402', 'BANG SAI YAI', 16.6019, 104.743, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010403', 'KHOK SUNG', 16.6023, 104.729, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010404', 'DON MUAI', 16.6281, 104.728, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010405', 'NONG AEK', 16.6442, 104.696, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010406', 'NONG HOI', 16.6113, 104.685, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010407', 'KHAM PHAK NOK', 16.5874, 104.733, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010408', 'PA WAI', 16.5978, 104.706, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010409', 'SONG PUAI', 16.5908, 104.741, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010410', 'NON SAWANG', 16.6503, 104.693, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010501', 'NA SOK NOI', 16.6014, 104.615, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010502', 'PONG PAO', 16.5642, 104.601, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010503', 'PHON SAI', 16.5766, 104.607, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010504', 'NA THON', 16.5275, 104.609, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010505', 'NONG YA SAI', 16.592, 104.608, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010506', 'KAEN TAO', 16.5899, 104.626, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010507', 'KHAM HI', 16.6155, 104.644, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010508', 'MUANG HAK', 16.5655, 104.62, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010509', 'PHON SAI', 16.5796, 104.607, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010510', 'NA THON NOI', 16.5307, 104.594, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010511', 'DON MUANG PHATTHANA', 16.6608, 104.65, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010601', 'PHUNG DAED', 16.6294, 104.482, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010602', 'PHUNG DAED', 16.6318, 104.482, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010603', 'NON TUM', 16.607, 104.488, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010604', 'KHAM PHUNG', 16.5947, 104.521, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010605', 'NA KHAM', 16.6198, 104.502, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010606', 'NA KHAM', 16.6312, 104.488, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010607', 'CHOM MANI TAI', 16.6039, 104.503, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010608', 'NONG PHAI', 16.641, 104.466, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010609', 'KOK BOK', 16.6375, 104.471, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010610', 'NONG LAENG', 16.6391, 104.49, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010611', 'NONG PLA SIU', 16.5881, 104.515, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010612', 'BAN NONG KHIAN', 16.643, 104.473, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010613', 'KHAM PHUNG NOI', 16.6165, 104.487, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010701', 'NA SOK', 16.5074, 104.509, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010702', 'NONG NAM TAO', 16.4315, 104.554, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010703', 'NA SOK', 16.5035, 104.526, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010704', 'LAO PA PED', 16.5109, 104.51, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010705', 'NA BON', 16.5141, 104.477, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010706', 'NA DO', 16.4402, 104.543, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010707', 'KHOK PONG PUAI', 16.4598, 104.473, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010708', 'BAN KAENG', 16.5176, 104.467, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010709', 'NA HUA PHU', 16.503, 104.579, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010710', 'KHOK PONG PUAI', 16.4644, 104.478, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010711', 'LAO PA PED', 16.5067, 104.52, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010712', 'BAN NA DO NOI', 16.4376, 104.545, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010713', 'BAN NON BUP PHA', 16.51, 104.524, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010714', 'BAN BURAPHA PRACHA SUK', 16.4761, 104.6, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010715', 'WATTHANA NAKHON', 16.4444, 104.511, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010801', 'NA SI NUAN', 16.4697, 104.808, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010802', 'SOM POI', 16.4738, 104.8, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010803', 'NON SI', 16.4783, 104.794, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010804', 'LAO LOM', 16.4833, 104.787, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010805', 'KHON SAI', 16.4676, 104.806, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010806', 'THA KHRAI', 16.4492, 104.844, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010807', 'NA LAE', 16.4499, 104.845, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010808', 'SOM POI NUA', 16.4755, 104.788, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010809', 'KHAO MA NO ROM', 16.4662, 104.812, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010810', 'BAN KHAM PHU NGOEN', 16.4866, 104.782, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010901', 'KHAM PA LAI', 16.7275, 104.658, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010902', 'SAM KHA', 16.6849, 104.662, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010903', 'NA SUA LAI', 16.7809, 104.653, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010904', 'NA TA BAENG', 16.7629, 104.686, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010905', 'BAN KAENG', 16.7381, 104.561, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010906', 'NA KHAM NOI', 16.7451, 104.588, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010907', 'NA NONG YO', 16.7787, 104.674, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010908', 'NA SONG HONG', 16.6971, 104.707, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010909', 'SAM KHA NUA', 16.6829, 104.667, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010910', 'KHAM NAM THIANG', 16.6654, 104.592, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49010911', 'NOI NA TA BAENG', 16.7046, 104.61, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011001', 'KHAM A HOAN', 16.4979, 104.675, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011002', 'MUANG BA', 16.5254, 104.684, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011003', 'KHAM KHUANG', 16.5097, 104.649, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011004', 'PHAN UN', 16.5067, 104.629, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011005', 'DONG MAN', 16.4542, 104.651, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011006', 'KHAM MEK', 16.5095, 104.703, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011007', 'NON SA_AT', 16.4804, 104.7, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011008', 'KHOK SUNG', 16.4561, 104.715, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011009', 'LAO KHRAM', 16.4576, 104.709, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011010', 'KHONG SAMRAN', 16.4409, 104.639, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011011', 'NI KHOM SA HA KORN', 16.4605, 104.672, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011012', 'BAN LAO KHAM', 16.4644, 104.709, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011101', 'DONG YEN', 16.3715, 104.712, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011102', 'NONG KHAEN', 16.3785, 104.672, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011103', 'PONG PHON', 16.4293, 104.66, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011104', 'SAM KHUA', 16.3825, 104.741, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011105', 'KHOK TA BAENG', 16.3689, 104.75, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011106', 'PHON SAWANG', 16.3439, 104.7, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011107', 'KHOK KHAM LIAN', 16.3482, 104.681, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011108', 'NA CHAN', 16.3741, 104.683, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011109', 'KHAM BONG', 16.3986, 104.668, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011110', 'DON SAWAN', 16.3873, 104.741, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011111', 'NON SAWAN', 16.4166, 104.667, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011112', 'NA THONG', 16.3763, 104.7, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011201', 'DONG MON', 16.678, 104.497, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011202', 'DON SAWAN', 16.6835, 104.498, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011203', 'SONG PUAI NUA', 16.6884, 104.492, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011204', 'DON SOM HONG', 16.6913, 104.485, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011205', 'LAO KHAEM', 16.6664, 104.5, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011206', 'CHOM MANI NUA', 16.6715, 104.48, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011207', 'HUAI YANG', 16.6608, 104.485, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011208', 'NA DI', 16.6424, 104.511, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011209', 'BAN RAI', 16.7087, 104.469, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011301', 'SOM SA_AT', 16.5888, 104.59, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011302', 'KUT KHAE TAI', 16.5843, 104.574, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011303', 'NA KO', 16.5731, 104.592, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011304', 'DONG YANG', 16.6016, 104.588, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011305', 'KUT KHAE', 16.5891, 104.577, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49011306', 'BAN NAN THA WAN', 16.5997, 104.592, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020103', 'BAN KHOK KLANG', 16.3628, 104.537, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020104', 'BAN DAN MON', 16.3491, 104.571, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020105', 'BAN UN KHAM CHARECN', 16.3743, 104.552, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020106', 'BAN DET CHAM NONG', 16.3609, 104.568, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020107', 'BAN KHAM KANG', 16.3743, 104.532, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020108', 'BAN NON KASEM', 16.36, 104.557, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020109', 'BAN NON SAWANG', 16.3493, 104.548, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020110', 'BAN PHU PHAENG MA', 16.3005, 104.602, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020111', 'BAN SUK SAMRAN', 16.378, 104.554, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020114', 'BAN LAO SAMAKKHI', 16.3044, 104.6, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020201', 'BAN NA KOK', 16.3884, 104.562, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020202', 'BAN KUT NGONG', 16.4176, 104.552, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020203', 'BAN NON SAWANG', 16.3646, 104.583, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020204', 'BAN NA SONG MUANG', 16.3742, 104.604, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020205', 'BAN NAM THIANG', 16.416, 104.557, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020206', 'BAN KHLONG SA_AT', 16.3716, 104.588, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020207', 'BAN HUAI KOK', 16.3924, 104.58, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020208', 'BAN DAN YAO', 16.3528, 104.587, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020209', 'BAN NON SAWAN', 16.3595, 104.596, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020210', 'BAN KASET SOMBUN', 16.3806, 104.575, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020211', 'BAN NONG BUA BAN', 16.3977, 104.554, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020212', 'BAN SI CHOMPHU', 16.3669, 104.611, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020213', 'BAN KHAM CHIANG SA', 16.3809, 104.592, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020301', 'BAN NONG WAENG', 16.386, 104.605, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020302', 'BAN NONG KHA', 16.4043, 104.614, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020303', 'BAN NONG KRA SO', 16.3958, 104.589, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020304', 'BAN PONG DAENG', 16.4182, 104.578, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020305', 'BAN NONG KOK PLOEI', 16.4113, 104.63, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020306', 'BAN NON KO', 16.4248, 104.602, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020307', 'BAN TAO THAN', 16.4394, 104.63, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020308', 'BAN NON SA_AT', 16.3855, 104.638, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020309', 'BAN LAO TON YOM', 16.4249, 104.574, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020310', 'BAN BANG I', 16.3966, 104.582, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020311', 'BAN LAO LUANG', 16.4222, 104.581, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020401', 'BAN KOK DAENG', 16.4151, 104.534, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020402', 'BAN LAO KLANG', 16.4123, 104.526, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020403', 'BAN UM PHAI', 16.4221, 104.511, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020404', 'BAN KHAM HAET YAI', 16.4103, 104.516, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020405', 'BAN BA', 16.3946, 104.544, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020406', 'BAN HIN LAT', 16.3847, 104.523, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020407', 'BAN NONG SAPHANG', 16.3748, 104.492, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020408', 'BAN CHAI CHAROEN', 16.4035, 104.538, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020409', 'BAN NA LUANG', 16.4065, 104.485, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020410', 'BAN KHAM HAET NOI', 16.4066, 104.511, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020411', 'BAN PA DAENG', 16.4173, 104.529, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020412', 'BAN ARANYA', 16.408, 104.534, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020413', 'BAN NON CHAROEN', 16.4091, 104.524, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020501', 'BAN NA UDOM', 16.2299, 104.631, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020502', 'BAN KHON KAEN', 16.2723, 104.639, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020503', 'BAN PA TOEI', 16.2518, 104.607, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020504', 'BAN SAI LAI LAENG', 16.3056, 104.638, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020505', 'BAN KHAM LAI', 16.2675, 104.592, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020602', 'BAN KHLONG NAM SAI', 16.347, 104.522, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020603', 'BAN NONG WAENG NOI', 16.3453, 104.505, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020604', 'BAN KHAM BONG', 16.3684, 104.523, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020605', 'BAN KHAM PHOK', 16.3175, 104.535, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020606', 'BAN KHAM PA KHA', 16.3459, 104.512, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020607', 'BAN NONG LI', 16.3507, 104.519, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020608', 'BAN NONG WAENG NUA', 16.3526, 104.507, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020701', 'BAN LOM KLAO', 16.3638, 104.472, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020702', 'BAN LOM KLAO', 16.3558, 104.473, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020703', 'BAN LOM KLAO', 16.3673, 104.457, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020704', 'BAN NONG NOK KHIAN', 16.3457, 104.428, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020705', 'BAN KHAM NANG OK', 16.3772, 104.465, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020707', 'BAN PHO SAI', 16.4081, 104.469, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49020709', 'SURIYO', 16.3925, 104.464, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030106', 'BAN NA MUANG', 16.3011, 104.924, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030107', 'BAN TAN RUNG', 16.3261, 104.934, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030108', 'BAN NA TAN', 16.338, 104.918, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030109', 'BAN NON SI THONG', 16.3039, 104.924, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030112', 'BAN TAN RUNG', 16.3356, 104.919, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030201', 'BAN PHO SAI', 16.3946, 104.871, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030202', 'BAN PHO SAI', 16.3891, 104.867, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030203', 'BAN NONG LOM', 16.4108, 104.865, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030204', 'BAN KHOK', 16.418, 104.86, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030205', 'BAN NA PHO', 16.3615, 104.886, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030206', 'BAN NA PHO', 16.3621, 104.89, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030207', 'BAN PHO SAI', 16.3937, 104.866, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030301', 'BAN PA CHAT', 16.2295, 104.739, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030302', 'BAN PA RAI', 16.2321, 104.744, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030303', 'BAN NONG MEK', 16.2299, 104.783, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030304', 'BAN NA MON', 16.2302, 104.776, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030305', 'BAN NA PONG', 16.2256, 104.727, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030306', 'BAN NON SAWAT', 16.2411, 104.686, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030307', 'BAN HUAY SAI', 16.2491, 104.725, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030308', 'BAN NA THAM', 16.2854, 104.704, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030309', 'BAN PONG KHAM', 16.228, 104.725, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030401', 'BAN LAO MI', 16.3437, 104.818, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030402', 'BAN LAO MI', 16.3432, 104.823, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030403', 'BAN PA PHAYOM', 16.3634, 104.799, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030404', 'BAN NA SING', 16.3318, 104.777, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030405', 'BAN NA YO', 16.3783, 104.827, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030406', 'BAN KHOK SAWANG', 16.3608, 104.818, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030407', 'BAN THA HUAI KHAM', 16.3416, 104.78, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030408', 'BAN LAO KHAEM THONG', 16.3169, 104.774, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030409', 'BAN NA YO', 16.3793, 104.833, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030501', 'BAN BAK', 16.2318, 104.885, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030502', 'BAN BAK', 16.232, 104.882, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030503', 'BAN NONG BON', 16.2535, 104.882, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030504', 'BAN NA YANG', 16.2587, 104.922, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030505', 'BAN NA YANG', 16.26, 104.925, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030506', 'BAN PHU LOM', 16.2355, 104.821, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030507', 'BAN PHU KHAM', 16.2276, 104.814, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030601', 'BAN NA SAMENG', 16.304, 104.882, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030602', 'BAN NA SAMENG', 16.3027, 104.884, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030603', 'BAN NA SANO', 16.34, 104.884, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030604', 'BAN NA WA', 16.3047, 104.841, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030605', 'BAN KHOK PHATTHANA', 16.2699, 104.873, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030606', 'BAN NONG KRA YANG', 16.282, 104.835, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030607', 'BAN NON SA_AT', 16.2973, 104.881, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030608', 'BAN PHU PA HOM', 16.2707, 104.82, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030701', 'BAN KIANG', 16.4167, 104.832, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030702', 'BAN KHAM DU', 16.4158, 104.843, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030703', 'BAN DONG', 16.4111, 104.851, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030704', 'BAN NA KHAM NOI', 16.4339, 104.831, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030705', 'BAN PHU WONG', 16.4035, 104.828, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030706', 'BAN NONG BUA', 16.4187, 104.823, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49030707', 'BAN KHAM TAO LEK', 16.4377, 104.83, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040101', 'BAN PHON DEANG', 16.838, 104.526, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040102', 'BAN PIAT', 16.7879, 104.525, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040103', 'BAN DONG LUANG', 16.842, 104.518, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040104', 'BAN LUA CHAROEN', 16.8007, 104.506, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040105', 'BAN SAENG SAWANG', 16.8132, 104.545, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040106', 'BAN NONG KHON KAEN', 16.8567, 104.547, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040107', 'BAN MAI', 16.819, 104.515, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040108', 'BAN SOK', 16.8034, 104.506, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040109', 'BAN NONG MAK SUK', 16.8309, 104.519, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040110', 'BAN DONG LUANG', 16.8206, 104.545, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040201', 'BAN NONG BUA', 16.8136, 104.573, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040202', 'BAN NONG NAO', 16.8154, 104.563, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040203', 'BAN NOM BO', 16.834, 104.563, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040204', 'BAN LAO DONG', 16.811, 104.587, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040205', 'BAN LAO NUA', 16.8169, 104.584, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040206', 'BAN NONG BUA NOI', 16.8203, 104.575, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040207', 'BAN NON SA-AT', 16.8091, 104.576, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040208', 'BAN NONG NAO NGAM', 16.8173, 104.569, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040301', 'BAN KOK TUM', 16.8357, 104.249, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040302', 'BAN KOK KOK', 16.8703, 104.226, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040303', 'BAN NA KHOK KUNG', 16.7984, 104.149, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040304', 'BAN SAN WAE', 16.7709, 104.169, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040305', 'BAN KHUA SUNG', 16.8753, 104.168, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040306', 'BAN KHAM PHAK KUT', 16.7681, 104.187, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040307', 'BAN KAENG NANG', 16.7173, 104.242, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040308', 'BAN NA HIN KONG', 16.735, 104.211, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040309', 'BAN PAK CHONG', 16.7487, 104.196, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040310', 'BAN PA MAI PHATTHANA', 16.8281, 104.141, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040401', 'BAN KAN LUANG DONG', 16.7582, 104.533, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040402', 'BAN NONG KHAEN', 16.7667, 104.506, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040403', 'BAN PHON HI', 16.7718, 104.468, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040404', 'BAN KAN LUANG DONG', 16.7563, 104.537, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040405', 'BAN KAN LUANG DONG', 16.7437, 104.526, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040406', 'BAN BANG SAI PHATTHANA', 16.7685, 104.5, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040407', 'BAN KHOK YAO', 16.7535, 104.453, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040501', 'BAN CHA NOT', 16.8119, 104.609, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040502', 'BAN NON THAN', 16.8192, 104.613, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040503', 'BAN CHA NOT NOI', 16.8073, 104.612, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040504', 'BAN DON CHAT', 16.8095, 104.603, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040505', 'BAN NONG YANG NOI', 16.831, 104.597, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040506', 'BAN NONG YANG', 16.7961, 104.631, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040507', 'BAN YOM PHATTANA', 16.8001, 104.63, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040601', 'BAN PANG DEABG', 16.8161, 104.383, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040602', 'BAN MA NAO', 16.8324, 104.333, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040603', 'BAN TIU', 16.8059, 104.401, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040604', 'BAN NA LAK', 16.7967, 104.433, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040605', 'BAN NONG MU', 16.789, 104.419, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040606', 'BAN PHON SAWANG', 16.7865, 104.445, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040607', 'BAN HUAI LAO', 16.7765, 104.364, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49040608', 'BAN NONG KHONG', 16.7868, 104.376, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050301', 'BAN NA SI NUAN', 16.6014, 104.442, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050302', 'BAN SONG', 16.5902, 104.423, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050303', 'BAN NON SANG SI', 16.5951, 104.458, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050304', 'BAN PHO SI', 16.5907, 104.451, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050305', 'BAN NON KO', 16.5874, 104.462, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050306', 'BAN SONG', 16.5892, 104.429, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050307', 'NON SANG SI', 16.5947, 104.426, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050401', 'BAN KHAM CHA I', 16.532, 104.356, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050402', 'BAN KHOK HI', 16.5082, 104.343, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050403', 'BAN HUAI SAI', 16.5439, 104.38, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050404', 'BAN KHAM CHA I', 16.5207, 104.361, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050405', 'BAN NON SAWANG', 16.5685, 104.329, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050406', 'BAN NONG KA PAD', 16.5153, 104.369, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050407', 'BAN NA PUNG', 16.5772, 104.357, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050408', 'BAN SI MONG KHON', 16.5341, 104.342, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050409', 'BAN HUAI SAI', 16.5401, 104.39, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050410', 'BAN KAENG CHANG NIAM', 16.5694, 104.276, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050411', 'BAN KHAM CHA I', 16.5255, 104.358, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050501', 'BAN NONG IAN', 16.6181, 104.457, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050502', 'BAN NONG IAN', 16.62, 104.457, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050503', 'BAN NONG IN MO', 16.6184, 104.438, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050504', 'BAN THUNG NANG NAI', 16.6115, 104.47, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050505', 'BAN NONG BONG', 16.6138, 104.446, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050506', 'BAN NA LUANG', 16.5962, 104.471, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050507', 'BAN HUA KUA', 16.6251, 104.45, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050508', 'BAN NA LUANG', 16.5913, 104.469, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050509', 'BAN NONG BONG', 16.6102, 104.447, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050601', 'BAN KHOK', 16.6526, 104.409, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050602', 'BAN KHO', 16.6413, 104.421, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050603', 'BAN KHO', 16.6402, 104.418, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050604', 'BAN DONG YANG', 16.6421, 104.404, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050605', 'BAN KHAE', 16.6325, 104.44, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050606', 'BAN KHAE', 16.636, 104.435, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050607', 'DONG YANG', 16.646, 104.393, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050701', 'BAN LAO', 16.6244, 104.41, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050702', 'BAN NA SAN TAT', 16.6126, 104.397, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050703', 'BAN LAO', 16.6271, 104.406, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050704', 'BAN NONG YA PO', 16.6167, 104.382, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050705', 'BAN MAET', 16.625, 104.386, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050706', 'BAN PHAENG', 16.6299, 104.393, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050707', 'BAN PHON', 16.6194, 104.413, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050708', 'BAN MUANG', 16.6025, 104.398, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050709', 'BAN NONG PLA SIU', 16.6238, 104.418, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050710', 'BAN MAET', 16.6311, 104.385, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050801', 'BAN PHON NGAM', 16.6686, 104.435, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050802', 'BAN PHON NGAM', 16.666, 104.438, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050803', 'BAN TUM WAN', 16.6683, 104.42, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050804', 'BAN DON PA KHAEN', 16.6877, 104.422, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050805', 'BAN NON PA DAENG', 16.6713, 104.419, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050806', 'BAN NONG SAPHANG', 16.6512, 104.438, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050807', 'BAN FAEK', 16.6404, 104.449, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050808', 'BAN NA DOK MAI', 16.6744, 104.411, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050809', 'BAN NONG SAPHANG', 16.6473, 104.437, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49050810', 'BAN FAEK', 16.6649, 104.434, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49051101', 'BAN LAO SANG THO', 16.5814, 104.482, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49051102', 'BAN LAO SANG THO', 16.5773, 104.481, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49051103', 'BAN KHOK', 16.5931, 104.49, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49051104', 'BAN NONG HI', 16.5773, 104.499, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49051105', 'BAN NONG HI', 16.5821, 104.5, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49051201', 'BAN BAK', 16.5148, 104.395, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49051202', 'BAN KLANG', 16.4987, 104.422, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49051203', 'BAN HUAI LAM MONG', 16.4982, 104.432, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49051204', 'BAN KHAM BOK', 16.5063, 104.412, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49051205', 'BAN NON SA-AT', 16.5013, 104.426, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49051401', 'BAN DON SAWAN', 16.5768, 104.415, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49051403', 'BAN NONG IAN DONG', 16.541, 104.415, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49051404', 'BAN DONG YANG', 16.577, 104.397, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49051407', 'BAN KHOK PA WAI', 16.5901, 104.4, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49051408', 'BAN NONG IAN DONG', 16.5383, 104.42, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49051409', 'NONG IAN DONG', 16.5715, 104.409, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060101', 'BAN WAN YAI TAI', 16.6982, 104.749, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060102', 'BAN WAN NOI', 16.6978, 104.763, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060103', 'BAN WAN YAI', 16.7187, 104.755, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060104', 'BAN WAN YAI', 16.7228, 104.754, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060105', 'BAN NA NONG BOK', 16.7181, 104.751, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060106', 'BAN NONG PHU', 16.7176, 104.739, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060107', 'BAN DON MUANG', 16.7042, 104.74, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060108', 'BAN NONG SAENG', 16.7138, 104.749, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060109', 'BAN KHOK NAM SANG', 16.7182, 104.728, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060110', 'BAN NON SAWANG', 16.7028, 104.725, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060111', 'BAN NA PHAENG', 16.7194, 104.717, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060201', 'BAN PONG KHAM', 16.7518, 104.752, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060202', 'BAN SONG KHON', 16.7698, 104.745, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060203', 'BAN SONG KHON', 16.7735, 104.743, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060204', 'BAN NA DI', 16.7385, 104.729, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060205', 'BAN NA KHAM POM', 16.7298, 104.744, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060206', 'BAN SOM SA-AT', 16.73, 104.758, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060207', 'BAN PHAI LOM', 16.7353, 104.756, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060208', 'BAN PONG KHAM', 16.7566, 104.746, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060209', 'BAN KHOK SAWAT', 16.7384, 104.727, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060210', 'BAN NA KAE NOI', 16.7774, 104.741, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060211', 'BAN MAI SONG KHON', 16.7847, 104.727, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060301', 'BAN BANG SAI NOI', 16.637, 104.744, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060302', 'BAN BANG SAI NOI', 16.6327, 104.744, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060303', 'BAN DON SAMAKKHI', 16.6503, 104.721, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060304', 'BAN KHAM POM', 16.6627, 104.721, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060305', 'BAN PHAK KHAYA', 16.6514, 104.73, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060306', 'BAN SAI THONG', 16.6514, 104.745, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060307', 'BAN NA MON', 16.668, 104.719, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060308', 'BAN SUK SAM RAN', 16.6577, 104.714, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060309', 'BAN DAO RUANG', 16.6417, 104.746, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060310', 'BAN PHO THONG', 16.6583, 104.721, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060311', 'BAN BANG SAI NOI TAI', 16.636, 104.748, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060401', 'BAN CHANOT TAI', 16.6783, 104.761, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060402', 'BAN CHANOT NUA', 16.6829, 104.759, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060403', 'BAN PA LU KA', 16.6688, 104.757, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060404', 'BAN PA LA KA', 16.6622, 104.745, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060405', 'BAN PHO CHAROEN', 16.6816, 104.754, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060501', 'BAN NIKHOM THAHARN PHANSUK', 16.7925, 104.719, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060502', 'BAN NIKHOM THAHARN PHANSUK', 16.7957, 104.719, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060503', 'BAN NIKHOM THAHARN PHANSUK', 16.8008, 104.723, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060504', 'BAN NIKHOM THAHARN PHANSUK', 16.8006, 104.72, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49060505', 'BAN NIKHOM THAHARN PHANSUK', 16.7999, 104.716, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070101', 'BAN NONG SUNG', 16.455, 104.371, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070102', 'BAN NONG SUNG', 16.4748, 104.371, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070103', 'BAN DONG MA NAENG', 16.4668, 104.369, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070104', 'BAN NONG SUNG', 16.4719, 104.358, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070105', 'BAN NON NAM KHAM', 16.4614, 104.352, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070106', 'BAN NONG SUNG MAI', 16.4779, 104.356, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070107', 'BAN NONG SUNG', 16.4792, 104.351, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070108', 'BAN NA NONG KHAEN', 16.4782, 104.349, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070109', 'BAN NONG TAE', 16.4798, 104.346, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070110', 'BAN KAN THAE', 16.4822, 104.349, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070111', 'BAN PA MEK', 16.4931, 104.351, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070112', 'BAN NONG SUNG', 16.5004, 104.345, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070201', 'BAN NON YANG', 16.4776, 104.327, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070202', 'BAN NON YANG', 16.4808, 104.321, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070203', 'BAN NONG O', 16.478, 104.342, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070204', 'BAN NGIU', 16.5156, 104.285, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070205', 'BAN KHAM PHOK', 16.4913, 104.248, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070206', 'BAN WANG NONG', 16.4441, 104.264, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070207', 'BAN LAO KWANG', 16.4698, 104.272, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070208', 'BAN NONG O', 16.4843, 104.341, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070209', 'BAN NGIU', 16.5209, 104.282, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070301', 'BAN WANG HI', 16.4488, 104.391, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070302', 'BAN WANG HI', 16.453, 104.389, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070303', 'BAN PHA KHAM', 16.4593, 104.406, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070304', 'BAN BUNG', 16.452, 104.421, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070305', 'BAN BUNG', 16.4528, 104.414, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070306', 'BAN NA TA BAENG', 16.4518, 104.456, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070307', 'BAN NA TA BAENG', 16.4455, 104.449, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070401', 'BAN PHU', 16.4384, 104.331, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070402', 'BAN PHU', 16.433, 104.336, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070403', 'BAN PAO', 16.4158, 104.341, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070404', 'BAN KHAM PHI', 16.3977, 104.347, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070405', 'BAN PAO', 16.4073, 104.343, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070406', 'BAN PA SAET', 16.4192, 104.338, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070501', 'BAN LUB BUNG', 16.3981, 104.388, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070502', 'BAN KHOK KLANG', 16.3712, 104.39, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070503', 'BAN WAENG', 16.3635, 104.375, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070504', 'BAN LAO NOI', 16.3856, 104.379, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070505', 'BAN KHOK HIN KONG', 16.3417, 104.382, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070506', 'BAN WAENG', 16.3694, 104.372, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070507', 'BAN NONG KHAEN NOI', 16.3981, 104.407, 'Thai');
INSERT INTO `gis_village_thai` VALUES('49070508', 'WAENG MAI', 16.3737, 104.373, 'Thai');

-- --------------------------------------------------------

--
-- Table structure for table `log`
--

CREATE TABLE IF NOT EXISTS `log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

--
-- Dumping data for table `log`
--


-- --------------------------------------------------------

--
-- Table structure for table `report`
--

CREATE TABLE IF NOT EXISTS `report` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `disease_code` int(11) NOT NULL,
  `report_date` datetime NOT NULL,
  `onset_date` date NOT NULL,
  `admit_date` date DEFAULT NULL,
  `age` int(11) NOT NULL,
  `location` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `house_number` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `sender` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

--
-- Dumping data for table `report`
--


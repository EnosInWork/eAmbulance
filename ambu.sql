INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_ambulance', 'Ambulance', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_ambulance', 'Ambulance', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_ambulance', 'Ambulance', 1)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
('ambulance', 0, 'ambulance', 'Ambulancier', 20, '{}', '{}'),
('ambulance', 1, 'doctor', 'Medecin', 40, '{}', '{}'),
('ambulance', 2, 'chief_doctor', 'Medecin-chef', 60, '{}', '{}'),
('ambulance', 3, 'boss', 'Chirurgien', 80, '{}', '{}');

INSERT INTO `jobs` (name, label) VALUES
	('ambulance','Ambulance')
;

ALTER TABLE `users`
	ADD `is_dead` TINYINT(1) NULL DEFAULT '0'
;

INSERT INTO items (name, label, weight) VALUES
    ('compresse','Compresse', 2),
    ('bandage','Bandage', 2),
    ('medikit','Kit médical', 2)
; 

CREATE TABLE `fiche_medical` (
  `id` int(11) NOT NULL,
  `author` text NOT NULL,
  `date` text NOT NULL,
  `firstname` text NOT NULL,
  `lastname` text NOT NULL,
  `reason` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `fiche_medical`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `fiche_medical`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;
COMMIT;

CREATE TABLE `stockambulance` (
  `id` int(11) NOT NULL,
  `type` varchar(30) NOT NULL,
  `model` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `stockambulance`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `stockambulance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

CREATE TABLE `stockambulanceN` (
  `id` int(11) NOT NULL,
  `type` varchar(30) NOT NULL,
  `model` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `stockambulanceN`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `stockambulanceN`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;
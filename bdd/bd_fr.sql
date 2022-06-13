 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema db_fr
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema db_fr
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `db_fr` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `db_fr` ;

-- -----------------------------------------------------
-- Table `db_fr`.`entreprise`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_fr`.`entreprise` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `db_fr`.`formation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_fr`.`formation` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(255) NOT NULL,
  `personnalise` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `db_fr`.`theme`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_fr`.`theme` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(255) NOT NULL,
  `parent_id` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `theme_parent_id_theme_id` (`parent_id` ASC) VISIBLE,
  CONSTRAINT `theme_parent_id_theme_id`
    FOREIGN KEY (`parent_id`)
    REFERENCES `db_fr`.`theme` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `db_fr`.`formation_theme`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_fr`.`formation_theme` (
  `formation_id` INT NOT NULL,
  `theme_id` INT NOT NULL,
  PRIMARY KEY (`formation_id`, `theme_id`),
  INDEX `fk_formation_theme_theme1_idx` (`theme_id` ASC) VISIBLE,
  CONSTRAINT `fk_formation_theme_formation1`
    FOREIGN KEY (`formation_id`)
    REFERENCES `db_fr`.`formation` (`id`),
  CONSTRAINT `fk_formation_theme_theme1`
    FOREIGN KEY (`theme_id`)
    REFERENCES `db_fr`.`theme` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `db_fr`.`session`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_fr`.`session` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `date` DATETIME NOT NULL,
  `lieu` VARCHAR(255) NOT NULL,
  `formation_id` INT NOT NULL,
  `prix` INT NOT NULL,
  `lien` VARCHAR(255) NOT NULL,
  `type` ENUM('intra', 'inter') NOT NULL,
  `confirmation_formateur` TINYINT NULL,
  PRIMARY KEY (`id`),
  INDEX `session_formation_id_formation_id` (`formation_id` ASC) VISIBLE,
  CONSTRAINT `session_formation_id_formation_id`
    FOREIGN KEY (`formation_id`)
    REFERENCES `db_fr`.`formation` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `db_fr`.`service`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_fr`.`service` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(255) NULL,
  `mail` VARCHAR(100) NULL,
  `telephone` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_fr`.`utilisateur`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_fr`.`utilisateur` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(100) NOT NULL,
  `prenom` VARCHAR(100) NOT NULL,
  `date_naissance` DATE NOT NULL,
  `entreprise_id` INT NULL,
  `role` ENUM('formateur', 'client', 'responsable') NOT NULL,
  `service_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `utilisateur_entreprise_id_entreprise_id` (`entreprise_id` ASC) VISIBLE,
  INDEX `fk_utilisateur_service1_idx` (`service_id` ASC) VISIBLE,
  CONSTRAINT `utilisateur_entreprise_id_entreprise_id`
    FOREIGN KEY (`entreprise_id`)
    REFERENCES `db_fr`.`entreprise` (`id`),
  CONSTRAINT `fk_utilisateur_service1`
    FOREIGN KEY (`service_id`)
    REFERENCES `db_fr`.`service` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `db_fr`.`utilisateur_session`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_fr`.`utilisateur_session` (
  `utilisateur_id` INT NOT NULL,
  `session_id` INT NOT NULL,
  `note_formateur` INT NULL,
  INDEX `utilisateur_session_utilisateur_id_utilisateur_id` (`utilisateur_id` ASC) VISIBLE,
  INDEX `utilisateur_session_session_id_session_id` (`session_id` ASC) VISIBLE,
  CONSTRAINT `utilisateur_session_session_id_session_id`
    FOREIGN KEY (`session_id`)
    REFERENCES `db_fr`.`session` (`id`),
  CONSTRAINT `utilisateur_session_utilisateur_id_utilisateur_id`
    FOREIGN KEY (`utilisateur_id`)
    REFERENCES `db_fr`.`utilisateur` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `db_fr`.`test`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_fr`.`test` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `lien` VARCHAR(255) NULL,
  `note` INT NULL,
  `session_id` INT NOT NULL,
  PRIMARY KEY (`id`, `session_id`),
  INDEX `fk_test_session1_idx` (`session_id` ASC) VISIBLE,
  CONSTRAINT `fk_test_session1`
    FOREIGN KEY (`session_id`)
    REFERENCES `db_fr`.`session` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS; 
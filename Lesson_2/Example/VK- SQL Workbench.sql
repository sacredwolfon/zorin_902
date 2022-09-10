-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` ;
-- -----------------------------------------------------
-- Schema vk
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema vk
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `vk` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `mydb` ;
USE `vk` ;

-- -----------------------------------------------------
-- Table `vk`.`communities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`communities` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id` (`id` ASC) VISIBLE,
  INDEX `communities_name_idx` (`name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `vk`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`users` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `firstname` VARCHAR(50) NULL DEFAULT NULL,
  `lastname` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Фамилия',
  `email` VARCHAR(120) NULL DEFAULT NULL,
  `phone` BIGINT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id` (`id` ASC) VISIBLE,
  UNIQUE INDEX `email` (`email` ASC) VISIBLE,
  INDEX `users_phone_idx` (`phone` ASC) VISIBLE,
  INDEX `users_firstname_lastname_idx` (`firstname` ASC, `lastname` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 101
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `vk`.`friend_requests`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`friend_requests` (
  `initiator_user_id` BIGINT UNSIGNED NOT NULL,
  `target_user_id` BIGINT UNSIGNED NOT NULL,
  `status` ENUM('requested', 'approved', 'unfriended', 'declined') NULL DEFAULT NULL,
  `requested_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `confirmed_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`initiator_user_id`, `target_user_id`),
  INDEX `initiator_user_id` (`initiator_user_id` ASC) VISIBLE,
  INDEX `target_user_id` (`target_user_id` ASC) VISIBLE,
  CONSTRAINT `friend_requests_ibfk_1`
    FOREIGN KEY (`initiator_user_id`)
    REFERENCES `vk`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE RESTRICT,
  CONSTRAINT `friend_requests_ibfk_2`
    FOREIGN KEY (`target_user_id`)
    REFERENCES `vk`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `vk`.`media_types`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`media_types` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id` (`id` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `vk`.`media`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`media` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `media_type_id` BIGINT UNSIGNED NULL DEFAULT NULL,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `body` TEXT NULL DEFAULT NULL,
  `filename` VARCHAR(255) NULL DEFAULT NULL,
  `size` INT NULL DEFAULT NULL,
  `metadata` JSON NULL DEFAULT NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id` (`id` ASC) VISIBLE,
  INDEX `user_id` (`user_id` ASC) VISIBLE,
  INDEX `media_type_id` (`media_type_id` ASC) VISIBLE,
  CONSTRAINT `media_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `vk`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `media_ibfk_2`
    FOREIGN KEY (`media_type_id`)
    REFERENCES `vk`.`media_types` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 101
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `vk`.`likes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`likes` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `media_id` BIGINT UNSIGNED NOT NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id` (`id` ASC) VISIBLE,
  INDEX `user_id` (`user_id` ASC) VISIBLE,
  INDEX `media_id` (`media_id` ASC) VISIBLE,
  CONSTRAINT `likes_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `vk`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `likes_ibfk_2`
    FOREIGN KEY (`media_id`)
    REFERENCES `vk`.`media` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 21
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `vk`.`messages`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`messages` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `from_user_id` BIGINT UNSIGNED NOT NULL,
  `to_user_id` BIGINT UNSIGNED NOT NULL,
  `body` TEXT NULL DEFAULT NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id` (`id` ASC) VISIBLE,
  INDEX `messages_from_user_id` (`from_user_id` ASC) VISIBLE,
  INDEX `messages_to_user_id` (`to_user_id` ASC) VISIBLE,
  CONSTRAINT `messages_ibfk_1`
    FOREIGN KEY (`from_user_id`)
    REFERENCES `vk`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `messages_ibfk_2`
    FOREIGN KEY (`to_user_id`)
    REFERENCES `vk`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 101
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `vk`.`profiles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`profiles` (
  `user_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `gender` CHAR(1) NULL DEFAULT NULL,
  `birthday` DATE NULL DEFAULT NULL,
  `photo_id` BIGINT UNSIGNED NULL DEFAULT NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `hometown` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `user_id` (`user_id` ASC) VISIBLE,
  INDEX `photo_id` (`photo_id` ASC) VISIBLE,
  CONSTRAINT `profiles_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `vk`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `profiles_ibfk_2`
    FOREIGN KEY (`photo_id`)
    REFERENCES `vk`.`media` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 101
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `vk`.`users_communities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`users_communities` (
  `user_id` BIGINT UNSIGNED NOT NULL,
  `community_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`user_id`, `community_id`),
  INDEX `community_id` (`community_id` ASC) VISIBLE,
  CONSTRAINT `users_communities_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `vk`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `users_communities_ibfk_2`
    FOREIGN KEY (`community_id`)
    REFERENCES `vk`.`communities` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

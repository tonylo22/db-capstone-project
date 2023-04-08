-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LittleLemonDB` DEFAULT CHARACTER SET utf8 ;
USE `LittleLemonDB` ;

-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Customers` (
  `customerID` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(100) NULL,
  `surname` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(15) NULL,
  `email` VARCHAR(255) NULL,
  PRIMARY KEY (`customerID`),
  UNIQUE INDEX `customerID_UNIQUE` (`customerID` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Bookings` (
  `bookingID` INT NOT NULL AUTO_INCREMENT,
  `date` DATETIME NOT NULL,
  `table_no` INT NOT NULL,
  `persons` INT NOT NULL,
  `customerID` INT NOT NULL,
  PRIMARY KEY (`bookingID`),
  UNIQUE INDEX `bookingID_UNIQUE` (`bookingID` ASC) VISIBLE,
  INDEX `customerID_idx` (`customerID` ASC) VISIBLE,
  CONSTRAINT `bookings_customerID`
    FOREIGN KEY (`customerID`)
    REFERENCES `LittleLemonDB`.`Customers` (`customerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Menu` (
  `itemID` INT NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `cuisine` VARCHAR(45) NULL,
  `type` VARCHAR(45) NOT NULL,
  `price` DECIMAL(4,2) NOT NULL,
  PRIMARY KEY (`itemID`),
  UNIQUE INDEX `itemID_UNIQUE` (`itemID` ASC) VISIBLE,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Orders` (
  `orderID` INT NOT NULL AUTO_INCREMENT,
  `itemID` INT NOT NULL,
  `quantity` INT NOT NULL,
  `bill_no` INT NOT NULL,
  `customerID` INT NOT NULL,
  PRIMARY KEY (`orderID`),
  UNIQUE INDEX `orderID_UNIQUE` (`orderID` ASC) VISIBLE,
  INDEX `itemID_idx` (`itemID` ASC) VISIBLE,
  INDEX `customerID_idx` (`customerID` ASC) VISIBLE,
  CONSTRAINT `orders_itemID`
    FOREIGN KEY (`itemID`)
    REFERENCES `LittleLemonDB`.`Menu` (`itemID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `orders_customerID`
    FOREIGN KEY (`customerID`)
    REFERENCES `LittleLemonDB`.`Customers` (`customerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Order_status_types`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Order_status_types` (
  `typeID` INT NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`typeID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Order_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Order_status` (
  `statusID` INT NOT NULL AUTO_INCREMENT,
  `orderID` INT NOT NULL,
  `statusType` INT NOT NULL,
  `date` DATETIME NOT NULL,
  PRIMARY KEY (`statusID`),
  INDEX `statusType_idx` (`statusType` ASC) VISIBLE,
  INDEX `orderID_idx` (`orderID` ASC) VISIBLE,
  CONSTRAINT `status_statusType`
    FOREIGN KEY (`statusType`)
    REFERENCES `LittleLemonDB`.`Order_status_types` (`typeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `status_orderID`
    FOREIGN KEY (`orderID`)
    REFERENCES `LittleLemonDB`.`Orders` (`orderID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Employees` (
  `employeeID` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(100) NOT NULL,
  `surname` VARCHAR(100) NOT NULL,
  `role` VARCHAR(45) NOT NULL,
  `salary` DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (`employeeID`),
  UNIQUE INDEX `employeeID_UNIQUE` (`employeeID` ASC) VISIBLE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

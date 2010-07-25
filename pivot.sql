DELIMITER $$

DROP PROCEDURE IF EXISTS `PIVOT_REPORT` $$
CREATE PROCEDURE `PIVOT_REPORT`()
BEGIN
  DECLARE col_number       INT(2)         DEFAULT 0;
  DECLARE counter          INT(2)         DEFAULT 0;
  DECLARE done             INT(1)         DEFAULT 0;
  DECLARE last_prod        VARCHAR(128)   DEFAULT "";
  DECLARE prod_name        VARCHAR(128);
  DECLARE cross_prod_name  VARCHAR(128);
  DECLARE col_name         VARCHAR(32);
  DECLARE create_temp_tbl  TEXT;

  -- ------------------------------------------------------------------------
  -- Query for fetching products and associated cross products.
  -- ------------------------------------------------------------------------
  DECLARE cross_products CURSOR FOR
    SELECT SQL_NO_CACHE
      b.product_name,
      c.product_name
    FROM cross_sell_products AS a
    INNER JOIN product_names AS b ON
      a.product_id = b.product_id
    INNER JOIN product_names AS c ON
      a.cross_sell_product_id = c.product_id;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


  -- ------------------------------------------------------------------------
  -- Find the largest number of cross products for a single product
  -- ------------------------------------------------------------------------
  SELECT SQL_NO_CACHE
    COUNT(*) AS total INTO col_number
  FROM cross_sell_products
  GROUP BY product_id
  ORDER BY total DESC
  LIMIT 1;


  -- ------------------------------------------------------------------------
  -- Get rid of any instance of report_tmp. Given its structure is changing
  -- from procedure call to procedure call, it might cause problems because
  -- of the different number of columns it has versus the ones that we want
  -- to insert.
  -- ------------------------------------------------------------------------
  DROP TABLE IF EXISTS report_temp;


  -- ------------------------------------------------------------------------
  -- Create a table with as many fields for cross products as the number
  -- stored in col_number (which is the maximum number of cross products for
  -- a single product).
  -- Also, make product_name a primary key. We'll need this later in the
  -- insertion phase.
  -- ------------------------------------------------------------------------
  SET create_temp_tbl = "CREATE TEMPORARY TABLE report_temp (product_name VARCHAR(128) PRIMARY KEY, ";

  WHILE counter < col_number DO
    SET col_name = CONCAT("cross_sel_product_", counter);
    SET create_temp_tbl = CONCAT(create_temp_tbl, CONCAT(col_name, " VARCHAR(128)"));

    IF counter != col_number - 1 THEN
        SET create_temp_tbl = CONCAT(create_temp_tbl, ", ");
    END IF;

    SET counter = counter + 1;
  END WHILE;

  SET @x = CONCAT(create_temp_tbl, ");");

  PREPARE stmt FROM @x;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;
  TRUNCATE TABLE report_temp;


  -- ------------------------------------------------------------------------
  -- Begin fetch of products and cross products
  -- ------------------------------------------------------------------------
  OPEN cross_products;

  REPEAT
    FETCH cross_products INTO prod_name, cross_prod_name;

    IF NOT done THEN
      -- ----------------------------------------------------------------
      -- Be sure to reset the counter every time the product group is
      -- changing, so that we don't attempt to use more fields than
      -- there are in the temporary table.
      -- ----------------------------------------------------------------
      IF NOT prod_name = last_prod THEN
          SET counter = 0;
          SET last_prod = prod_name;
      END IF;

      -- ----------------------------------------------------------------
      -- For each cross product of a product, try to insert it, in case
      -- it's not the first one in the group a key duplication error will
      -- be reported. In this case, update the entry with a new cross
      -- product.
      -- ----------------------------------------------------------------
      SET col_name     = CONCAT("cross_sel_product_", counter);
      SET @insert_stmt = CONCAT("INSERT INTO report_temp SET"
                               ," product_name = ?, "
                               ,  col_name  ," = ? "
                               ,"ON DUPLICATE KEY UPDATE "
                               ,  col_name  ," = ?");

      SET @prod_name       = prod_name;
      SET @cross_prod_name = cross_prod_name;

      PREPARE stmt_ins FROM @insert_stmt;
      EXECUTE stmt_ins USING @prod_name, @cross_prod_name, @cross_prod_name;
      DEALLOCATE PREPARE stmt_ins;

      -- Go to next field
      SET counter = counter + 1;
    END IF;
  UNTIL done END REPEAT;

  CLOSE cross_products;

  -- ------------------------------------------------------------------------
  -- Return desired result
  -- ------------------------------------------------------------------------
  SELECT SQL_NO_CACHE * FROM report_temp;
END $$

DELIMITER ;



-- ----------------------------------------------------------------------------
-- Table structure for table 'cross_sell_products'
-- ----------------------------------------------------------------------------

CREATE TABLE /*!32312 IF NOT EXISTS*/ `cross_sell_products` (
  `product_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cross_sell_product_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`product_id`,`cross_sell_product_id`) /*!50100 USING BTREE */
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;



-- ----------------------------------------------------------------------------
-- Dumping data for table 'cross_sell_products'
-- ----------------------------------------------------------------------------

LOCK TABLES `cross_sell_products` WRITE;
/*!40000 ALTER TABLE `cross_sell_products` DISABLE KEYS*/;
INSERT INTO `cross_sell_products` (`product_id`, `cross_sell_product_id`) VALUES
  ('1','2'),
  ('1','3'),
  ('2','1'),
  ('2','4'),
  ('2','5'),
  ('2','6');
/*!40000 ALTER TABLE `cross_sell_products` ENABLE KEYS*/;
UNLOCK TABLES;


-- ----------------------------------------------------------------------------
-- Table structure for table 'products'
-- ----------------------------------------------------------------------------

CREATE TABLE /*!32312 IF NOT EXISTS*/ `products` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;



-- ----------------------------------------------------------------------------
-- Dumping data for table 'products'
-- ----------------------------------------------------------------------------

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS*/;
INSERT INTO `products` (`id`) VALUES
  ('1'),
  ('2'),
  ('3');
/*!40000 ALTER TABLE `products` ENABLE KEYS*/;
UNLOCK TABLES;


-- ----------------------------------------------------------------------------
-- Table structure for table 'product_names'
-- ----------------------------------------------------------------------------

CREATE TABLE /*!32312 IF NOT EXISTS*/ `product_names` (
  `product_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_name` varchar(128) NOT NULL,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;



-- ----------------------------------------------------------------------------
-- Dumping data for table 'product_names'
-- ----------------------------------------------------------------------------

LOCK TABLES `product_names` WRITE;
/*!40000 ALTER TABLE `product_names` DISABLE KEYS*/;
INSERT INTO `product_names` (`product_id`, `product_name`) VALUES
  ('1','first product'),
  ('2','second product'),
  ('3','third product'),
  ('4','fourth product'),
  ('5','fifth product'),
  ('6','sixth product');
/*!40000 ALTER TABLE `product_names` ENABLE KEYS*/;
UNLOCK TABLES;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS*/;

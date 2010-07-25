-- WARNING: this procedure won't work with InnoDB tables, as the total number
-- of rows in such a table cannot be trust.

DELIMITER $$

DROP PROCEDURE IF EXISTS `DROP_EMPTY_TABLES_FROM` $$
CREATE PROCEDURE `DROP_EMPTY_TABLES_FROM`(IN schema_target VARCHAR(128))
BEGIN
  DECLARE table_list TEXT;
  DECLARE total      VARCHAR(11);

  SELECT
    GROUP_CONCAT(`TABLE_NAME`),
    COUNT(`TABLE_NAME`)
  INTO
    table_list,
    total
  FROM `information_schema`.`TABLES`
  WHERE `TABLE_SCHEMA` = schema_target
    AND `TABLE_ROWS`   = 0;

  IF table_list IS NOT NULL THEN
    SET @drop_tables = CONCAT("DROP TABLE ", table_list);

    PREPARE stmt FROM @drop_tables;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
  END IF;

  SELECT total AS affected_tables;
END $$

DELIMITER ;

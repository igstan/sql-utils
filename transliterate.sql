DELIMITER $$

DROP FUNCTION IF EXISTS `transliterate` $$
CREATE FUNCTION `transliterate` (original VARCHAR(128)) RETURNS VARCHAR(128)
BEGIN

  DECLARE translit VARCHAR(128) DEFAULT '';
  DECLARE len      INT(3)       DEFAULT 0;
  DECLARE pos      INT(3)       DEFAULT 1;
  DECLARE letter   CHAR(1);

  SET len = CHAR_LENGTH(original);

  WHILE (pos <= len) DO
    SET letter = SUBSTRING(original, pos, 1);

    CASE TRUE
      WHEN letter = 'a' THEN SET letter = 'a';
      WHEN letter = 'b' THEN SET letter = 'b';
      WHEN letter = 'c' THEN SET letter = 'c';
      WHEN letter = 'd' THEN SET letter = 'd';
      WHEN letter = 'e' THEN SET letter = 'e';
      WHEN letter = 'f' THEN SET letter = 'f';
      WHEN letter = 'g' THEN SET letter = 'g';
      WHEN letter = 'h' THEN SET letter = 'h';
      WHEN letter = 'i' THEN SET letter = 'i';
      WHEN letter = 'j' THEN SET letter = 'j';
      WHEN letter = 'k' THEN SET letter = 'k';
      WHEN letter = 'l' THEN SET letter = 'l';
      WHEN letter = 'm' THEN SET letter = 'm';
      WHEN letter = 'n' THEN SET letter = 'n';
      WHEN letter = 'o' THEN SET letter = 'o';
      WHEN letter = 'p' THEN SET letter = 'p';
      WHEN letter = 'q' THEN SET letter = 'q';
      WHEN letter = 'r' THEN SET letter = 'r';
      WHEN letter = 's' THEN SET letter = 's';
      WHEN letter = 't' THEN SET letter = 't';
      WHEN letter = 'u' THEN SET letter = 'u';
      WHEN letter = 'v' THEN SET letter = 'v';
      WHEN letter = 'w' THEN SET letter = 'w';
      WHEN letter = 'x' THEN SET letter = 'x';
      WHEN letter = 'y' THEN SET letter = 'y';
      WHEN letter = 'z' THEN SET letter = 'z';
      ELSE
        SET letter = letter;
    END CASE;

    SET translit = CONCAT(translit, letter);
    SET pos = pos + 1;
  END WHILE;

  RETURN translit;

END $$

DELIMITER ;

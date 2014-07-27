DELIMITER $$

DROP FUNCTION IF EXISTS `transliterate` $$
CREATE FUNCTION `transliterate` (original VARCHAR(512)) RETURNS VARCHAR(512)
BEGIN

  DECLARE translit VARCHAR(512) DEFAULT '';
  DECLARE len      INT(3)       DEFAULT 0;
  DECLARE pos      INT(3)       DEFAULT 1;
  DECLARE letter   CHAR(1);
  DECLARE is_lower BIT;

  SET len = CHAR_LENGTH(original);

  WHILE (pos <= len) DO
    SET letter   = SUBSTRING(original, pos, 1);
    SET is_lower = IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 1, 0);

    CASE TRUE
      WHEN letter = 'a' THEN SET letter = IF(is_lower, 'a', 'A');
      WHEN letter = 'b' THEN SET letter = IF(is_lower, 'b', 'B');
      WHEN letter = 'c' THEN SET letter = IF(is_lower, 'c', 'C');
      WHEN letter = 'č' THEN SET letter = IF(is_lower, 'c', 'C');
      WHEN letter = 'd' THEN SET letter = IF(is_lower, 'd', 'D');
      WHEN letter = 'ď' THEN SET letter = IF(is_lower, 'd', 'D');
      WHEN letter = 'e' THEN SET letter = IF(is_lower, 'e', 'E');
      WHEN letter = 'ě' THEN SET letter = IF(is_lower, 'e', 'E');
      WHEN letter = 'f' THEN SET letter = IF(is_lower, 'f', 'F');
      WHEN letter = 'g' THEN SET letter = IF(is_lower, 'g', 'G');
      WHEN letter = 'h' THEN SET letter = IF(is_lower, 'h', 'H');
      WHEN letter = 'i' THEN SET letter = IF(is_lower, 'i', 'I');
      WHEN letter = 'j' THEN SET letter = IF(is_lower, 'j', 'J');
      WHEN letter = 'k' THEN SET letter = IF(is_lower, 'k', 'K');
      WHEN letter = 'l' THEN SET letter = IF(is_lower, 'l', 'L');
      WHEN letter = 'ł' THEN SET letter = IF(is_lower, 'l', 'L');
      WHEN letter = 'm' THEN SET letter = IF(is_lower, 'm', 'M');
      WHEN letter = 'n' THEN SET letter = IF(is_lower, 'n', 'N');
      WHEN letter = 'ň' THEN SET letter = IF(is_lower, 'n', 'N');
      WHEN letter = 'o' THEN SET letter = IF(is_lower, 'o', 'O');
      WHEN letter = 'p' THEN SET letter = IF(is_lower, 'p', 'P');
      WHEN letter = 'q' THEN SET letter = IF(is_lower, 'q', 'Q');
      WHEN letter = 'r' THEN SET letter = IF(is_lower, 'r', 'R');
      WHEN letter = 'ř' THEN SET letter = IF(is_lower, 'r', 'R');
      WHEN letter = 's' THEN SET letter = IF(is_lower, 's', 'S');
      WHEN letter = 'š' THEN SET letter = IF(is_lower, 's', 'S');
      WHEN letter = 't' THEN SET letter = IF(is_lower, 't', 'T');
      WHEN letter = 'ť' THEN SET letter = IF(is_lower, 't', 'T');
      WHEN letter = 'u' THEN SET letter = IF(is_lower, 'u', 'U');
      WHEN letter = 'v' THEN SET letter = IF(is_lower, 'v', 'V');
      WHEN letter = 'w' THEN SET letter = IF(is_lower, 'w', 'W');
      WHEN letter = 'x' THEN SET letter = IF(is_lower, 'x', 'X');
      WHEN letter = 'y' THEN SET letter = IF(is_lower, 'y', 'Y');
      WHEN letter = 'z' THEN SET letter = IF(is_lower, 'z', 'Z');
      WHEN letter = 'ž' THEN SET letter = IF(is_lower, 'z', 'Z');
      ELSE
        SET letter = letter;
    END CASE;

    -- CONCAT seems to ignore the whitespace character. As a workaround we use
    -- CONCAT_WS with a whitespace separator when the letter is a whitespace.
    SET translit = CONCAT_WS(IF(letter = ' ', ' ', ''), translit, letter);
    SET pos = pos + 1;
  END WHILE;

  RETURN translit;

END $$

DELIMITER ;

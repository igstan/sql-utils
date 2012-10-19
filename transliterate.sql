DELIMITER $

DROP FUNCTION IF EXISTS `transliterate` $
CREATE FUNCTION `transliterate` (original VARCHAR(256)) RETURNS VARCHAR(256)
BEGIN

DECLARE translit VARCHAR(256) DEFAULT '';
DECLARE len INT(3) DEFAULT 0;
DECLARE pos INT(3) DEFAULT 1;
DECLARE letter CHAR(1);

SET len = CHAR_LENGTH(original);

WHILE (pos <= len) DO
SET letter = SUBSTRING(original, pos, 1);

CASE TRUE
WHEN letter = 'a' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'a', 'A'));
WHEN letter = 'ą' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'a', 'A'));
WHEN letter = 'b' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'b', 'B'));
WHEN letter = 'c' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'c', 'C'));
WHEN letter = 'ć' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'c', 'C'));
WHEN letter = 'd' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'd', 'D'));
WHEN letter = 'e' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'e', 'E'));
WHEN letter = 'ę' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'e', 'E'));
WHEN letter = 'f' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'f', 'F'));
WHEN letter = 'g' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'g', 'G'));
WHEN letter = 'h' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'h', 'H'));
WHEN letter = 'i' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'i', 'I'));
WHEN letter = 'j' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'j', 'J'));
WHEN letter = 'k' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'k', 'K'));
WHEN letter = 'l' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'l', 'L'));
WHEN letter = 'ł' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'l', 'L'));
WHEN letter = 'm' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'm', 'M'));
WHEN letter = 'n' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'n', 'N'));
WHEN letter = 'ń' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'n', 'N'));
WHEN letter = 'ó' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'o', 'O'));
WHEN letter = 'p' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'p', 'P'));
WHEN letter = 'q' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'q', 'Q'));
WHEN letter = 'r' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'r', 'R'));
WHEN letter = 's' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 's', 'S'));
WHEN letter = 't' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 't', 'T'));
WHEN letter = 'u' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'u', 'U'));
WHEN letter = 'v' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'v', 'V'));
WHEN letter = 'w' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'w', 'W'));
WHEN letter = 'x' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'x', 'X'));
WHEN letter = 'y' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'y', 'Y'));
WHEN letter = 'z' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'z', 'Z'));
WHEN letter = 'ź' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'z', 'Z'));
WHEN letter = 'ż' THEN SET translit = CONCAT(translit, IF(LCASE(letter) COLLATE utf8_bin = letter COLLATE utf8_bin, 'z', 'Z'));
ELSE SET translit = CONCAT(translit, SUBSTRING(original, pos, 1));
END CASE;

SET pos = pos + 1;
END WHILE;

RETURN translit;
END $

DELIMITER ;
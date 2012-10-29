DELIMITER $$

DROP FUNCTION IF EXISTS `slug` $$
CREATE FUNCTION `slug` (original VARCHAR(128)) RETURNS VARCHAR(128)
BEGIN

  DECLARE url        VARCHAR(128) DEFAULT '';
  DECLARE len        INT(3)       DEFAULT 0;
  DECLARE pos        INT(3)       DEFAULT 1;
  DECLARE put_hyphen BIT(1)       DEFAULT 1;
  DECLARE letter     CHAR(1);

  SET original = TRIM(original);
  SET len = CHAR_LENGTH(original);

  WHILE (pos <= len) DO
    SET letter = SUBSTRING(original, pos, 1);

    -- Replace all latin based characters, with their standard latin variant.
    -- That means, diacritics will be stripped out, which is actually the
    -- reason for the weird comparison.
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
      WHEN letter = 'ł' THEN SET letter = 'l';
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
      -- If letter is one of these: ` ! @ # $ % ^ & * ( ) | { } [ ] " ' < > / ? \
      -- strip it out completely.
      -- The order of characters in the comment is the same as the order of the
      -- ASCII numbers in the code
      WHEN ASCII(letter) IN (96,33,64,35,36,37,94,38,42,40,41,124,123,125,91,93,34,39,60,62,47,63,92) THEN
        SET letter = '';
      ELSE
        IF letter NOT IN ('0','1','2','3','4','5','6','7','8','9') THEN
          SET letter = '-';
        END IF;
    END CASE;

    IF letter = '-' THEN
      -- If previous characters wasn't a hyphen then append the new hyphen
      -- and set the hyphen flag to 0 so that the next letter, if a hyphen,
      -- doesn't get appended
      IF put_hyphen THEN
        SET put_hyphen = 0;
        SET url = CONCAT(url, letter);
      END IF;
    ELSE
      -- Allow hyphens to be appended
      IF letter != '' THEN
        SET put_hyphen = 1;
      END IF;

      SET url = CONCAT(url, letter);
    END IF;

    -- Go to next letter in string
    SET pos = pos + 1;
  END WHILE;

  -- Strip hyphens from the beggining of the string
  IF SUBSTRING(url, 1, 1) = '-' THEN
    SET url = SUBSTRING(url, 2);
  END IF;

  -- Strip hyphens from the end of the string
  IF SUBSTRING(url, -1) = '-' THEN
    SET url = SUBSTRING(url, 1, CHAR_LENGTH(url) - 1);
  END IF;

  RETURN url;
END $$

DELIMITER ;

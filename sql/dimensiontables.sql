DROP TABLE IF EXISTS tblfacts;
DROP TABLE IF EXISTS numbers_small;
CREATE TABLE numbers_small (number INT);
INSERT INTO numbers_small VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

DROP TABLE IF EXISTS numbers;
CREATE TABLE numbers (number BIGINT);
INSERT INTO numbers
SELECT thousands.number * 1000 + hundreds.number * 100 + tens.number * 10 + ones.number
FROM numbers_small thousands, numbers_small hundreds, numbers_small tens, numbers_small ones
LIMIT 1000000;

DROP TABLE IF EXISTS Dates_D;
CREATE TABLE Dates_D (
date_id          INT PRIMARY KEY,
date             DATE NOT NULL,
day              CHAR(10),
day_of_week      INT,
day_of_month     INT,
day_of_year      INT,
previous_day     date NOT NULL default '0000-00-00',
next_day         date NOT NULL default '0000-00-00',
weekend          CHAR(10) NOT NULL DEFAULT "Weekday",
week_of_year     CHAR(2),
month            CHAR(10),
month_of_year    CHAR(2),
quarter_of_year INT,
year             INT,
UNIQUE KEY `date` (`date`));

INSERT INTO Dates_D (date_id, date)
SELECT number, DATE_ADD( '2010-01-01', INTERVAL number DAY )
FROM numbers
WHERE DATE_ADD( '2010-01-01', INTERVAL number DAY ) BETWEEN '2010-01-01' AND '2023-12-31'
ORDER BY number;

UPDATE Dates_D SET
day             = DATE_FORMAT( date, "%W" ),
day_of_week     = DAYOFWEEK(date),
day_of_month    = DATE_FORMAT( date, "%d" ),
day_of_year     = DATE_FORMAT( date, "%j" ),
previous_day    = DATE_ADD(date, INTERVAL -1 DAY),
next_day        = DATE_ADD(date, INTERVAL 1 DAY),
weekend         = IF( DATE_FORMAT( date, "%W" ) IN ('Saturday','Sunday'), 'Weekend', 'Weekday'),
week_of_year    = DATE_FORMAT( date, "%V" ),
month           = DATE_FORMAT( date, "%M"),
month_of_year   = DATE_FORMAT( date, "%m"),
quarter_of_year = QUARTER(date),
year            = DATE_FORMAT( date, "%Y" );

DROP TABLE IF EXISTS NUTS_D;
CREATE TABLE NUTS_D (
region_id			INT AUTO_INCREMENT,
nuts_III          CHAR(50),
concelho     CHAR(50),

PRIMARY KEY(region_id));

source /var/www/Base-de-Dados/big_scripts/region.sql;
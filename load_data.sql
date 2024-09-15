-- Modify File Location as Needed
-- stations
.import --csv --skip 1 /bcur_csvs/station_names.csv stations

-- coordinates
.import --csv --skip 1 /bcur_csvs/coordinates_by_id.csv coordinates

-- 2019_friday
.import --csv --skip 1 /bcur_csvs/2019_friday.csv friday_2019

-- 2019_montothu
.import --csv --skip 1 /bcur_csvs/2019_montothu.csv montothu_2019

-- 2019_saturday
.import --csv --skip 1 /bcur_csvs/2019_saturday.csv saturday_2019

-- 2019_sunday
.import --csv --skip 1 /bcur_csvs/2019_sunday.csv sunday_2019

-- 2022_friday
.import --csv --skip 1 /bcur_csvs/2022_friday.csv friday_2022

-- 2022_monday
.import --csv --skip 1 /bcur_csvs/2022_monday.csv monday_2022

-- 2022_saturday
.import --csv --skip 1 /bcur_csvs/2022_saturday.csv saturday_2022

-- 2022_sunday
.import --csv --skip 1 /bcur_csvs/2022_sunday.csv sunday_2022

-- 2022_tuetothu
.import --csv --skip 1 /bcur_csvs/2022_tuetothu.csv tuetothu_2022

-- regions
.import --csv --skip 1 /bcur_csvs/boroughs_and_sub_regions.csv regions

-- classify
.import --csv --skip 1 /bcur_csvs/regional_classification.csv classify



-- morning	05:00-07:00
-- am_peak	07:00-10:00
-- midday	10:00-16:00
-- pm_peak	16:00-19:00
-- evening	19:00-22:00
-- late	    22:00-00:30

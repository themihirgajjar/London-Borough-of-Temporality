-- Totals
-- By day
-- Total 2019 Monday to Thursday exits
SELECT "name", "dest_id",
SUM ("morning" + "am_peak" + "midday" + "pm_peak" + "evening" + "late") AS "total_montothu_exits"
FROM "montothu_2019"
JOIN "stations" ON "stations"."id" = "montothu_2019"."dest_id"
GROUP BY "dest_id"
LIMIT 5;

-- Total 2019 Friday Exits
SELECT "name", "dest_id",
SUM ("morning" + "am_peak" + "midday" + "pm_peak" + "evening" + "late") AS "total_friday_exits"
FROM "friday_2019"
JOIN "stations" ON "stations"."id" = "friday_2019"."dest_id"
GROUP BY "dest_id"
LIMIT 5;

-- Total 2019 Saturday Exits
SELECT "name", "dest_id",
SUM ("morning" + "am_peak" + "midday" + "pm_peak" + "evening" + "late") AS "total_saturday_exits"
FROM "saturday_2019"
JOIN "stations" ON "stations"."id" = "saturday_2019"."dest_id"
GROUP BY "dest_id"
LIMIT 5;

-- Total 2019 Sunday Exits
SELECT "name", "dest_id",
SUM ("morning" + "am_peak" + "midday" + "pm_peak" + "evening" + "late") AS "total_sunday_exits"
FROM "sunday_2019"
JOIN "stations" ON "stations"."id" = "sunday_2019"."dest_id"
GROUP BY "dest_id"
LIMIT 5;

-- Total 2022 Monday Exits
SELECT "name", "dest_id",
SUM ("morning" + "am_peak" + "midday" + "pm_peak" + "evening" + "late") AS "total_monday_exits"
FROM "monday_2022"
JOIN "stations" ON "stations"."id" = "monday_2022"."dest_id"
GROUP BY "dest_id";

-- Total 2022 Tuesday to Thursday Exits
SELECT "name", "dest_id",
SUM ("morning" + "am_peak" + "midday" + "pm_peak" + "evening" + "late") AS "total_tuetothu_exits"
FROM "tuetothu_2022"
JOIN "stations" ON "stations"."id" = "tuetothu_2022"."dest_id"
GROUP BY "dest_id";

-- Total 2022 Monday to Thursday Exits [Adjusted as (Monday + (TuetoThu * 3))/4]
SELECT "name", "monday_2022"."dest_id",
(SUM ("monday_2022"."morning" + "monday_2022"."am_peak" + "monday_2022"."midday" + "monday_2022"."pm_peak" + "monday_2022"."evening" + "monday_2022"."late") +
SUM ("tuetothu_2022"."morning" + "tuetothu_2022"."am_peak" + "tuetothu_2022"."midday" + "tuetothu_2022"."pm_peak" + "tuetothu_2022"."evening" + "tuetothu_2022"."late") * 3)/4 AS "total_montothu_exits"
FROM "monday_2022"
JOIN "tuetothu_2022" ON "tuetothu_2022"."trip_id" = "monday_2022"."trip_id"
JOIN "stations" ON "stations"."id" = "monday_2022"."dest_id"
GROUP BY "monday_2022"."dest_id";

-- Total 2022 Friday Exits
SELECT "name", "dest_id",
SUM ("morning" + "am_peak" + "midday" + "pm_peak" + "evening" + "late") AS "total_friday_exits"
FROM "friday_2022"
JOIN "stations" ON "stations"."id" = "friday_2022"."dest_id"
GROUP BY "dest_id";

-- Total 2022 Saturday Exits
SELECT "name", "dest_id",
SUM ("morning" + "am_peak" + "midday" + "pm_peak" + "evening" + "late") AS "total_saturday_exits"
FROM "saturday_2022"
JOIN "stations" ON "stations"."id" = "saturday_2022"."dest_id"
GROUP BY "dest_id";

-- Total 2022 Sunday Exits
SELECT "name", "dest_id",
SUM ("morning" + "am_peak" + "midday" + "pm_peak" + "evening" + "late") AS "total_sunday_exits"
FROM "sunday_2022"
JOIN "stations" ON "stations"."id" = "sunday_2022"."dest_id"
GROUP BY "dest_id"
LIMIT 10;

-- Weekly total
-- 2019 [montothu * 4 because NUMBATS represents average exits for the day]
SELECT "name", "montothu_2019"."dest_id",
SUM ((("montothu_2019"."morning" + "montothu_2019"."am_peak" + "montothu_2019"."midday" + "montothu_2019"."pm_peak" + "montothu_2019"."evening" + "montothu_2019"."late")*4) +
    "friday_2019"."morning" + "friday_2019"."am_peak" + "friday_2019"."midday" + "friday_2019"."pm_peak" + "friday_2019"."evening" + "friday_2019"."late" +
    "saturday_2019"."morning" + "saturday_2019"."am_peak" + "saturday_2019"."midday" + "saturday_2019"."pm_peak" + "saturday_2019"."evening" + "saturday_2019"."late" +
    "sunday_2019"."morning" + "sunday_2019"."am_peak" + "sunday_2019"."midday" + "sunday_2019"."pm_peak" + "sunday_2019"."evening" + "sunday_2019"."late"
) AS "total_weekly_exits"
FROM "montothu_2019"
JOIN "friday_2019" ON "friday_2019"."trip_id" = "montothu_2019"."trip_id"
JOIN "saturday_2019" ON "saturday_2019"."trip_id" = "friday_2019"."trip_id"
JOIN "sunday_2019" ON "sunday_2019"."trip_id" = "saturday_2019"."trip_id"
JOIN "stations" ON "stations"."id" = "montothu_2019"."dest_id"
GROUP BY "montothu_2019"."dest_id"
LIMIT 10;

-- 2022
SELECT "name", "monday_2022"."dest_id",
SUM ("monday_2022"."morning" + "monday_2022"."am_peak" + "monday_2022"."midday" + "monday_2022"."pm_peak" + "monday_2022"."evening" + "monday_2022"."late" +
    (("tuetothu_2022"."morning" + "tuetothu_2022"."am_peak" + "tuetothu_2022"."midday" + "tuetothu_2022"."pm_peak" + "tuetothu_2022"."evening" + "tuetothu_2022"."late")*3) +
    "friday_2022"."morning" + "friday_2022"."am_peak" + "friday_2022"."midday" + "friday_2022"."pm_peak" + "friday_2022"."evening" + "friday_2022"."late" +
    "saturday_2022"."morning" + "saturday_2022"."am_peak" + "saturday_2022"."midday" + "saturday_2022"."pm_peak" + "saturday_2022"."evening" + "saturday_2022"."late" +
    "sunday_2022"."morning" + "sunday_2022"."am_peak" + "sunday_2022"."midday" + "sunday_2022"."pm_peak" + "sunday_2022"."evening" + "sunday_2022"."late"
) AS "total_weekly_exits"
FROM "monday_2022"
JOIN "tuetothu_2022" ON "tuetothu_2022"."trip_id" = "monday_2022"."trip_id"
JOIN "friday_2022" ON "friday_2022"."trip_id" = "tuetothu_2022"."trip_id"
JOIN "saturday_2022" ON "saturday_2022"."trip_id" = "friday_2022"."trip_id"
JOIN "sunday_2022" ON "sunday_2022"."trip_id" = "saturday_2022"."trip_id"
JOIN "stations" ON "stations"."id" = "monday_2022"."dest_id"
GROUP BY "monday_2022"."dest_id";

-- Weekly total by time of the day
-- 2019
-- Mornings
SELECT "name", "montothu_2019"."dest_id",
SUM ((("montothu_2019"."morning")*4) + "friday_2019"."morning" + "saturday_2019"."morning" + "sunday_2019"."morning") AS "2019_morning_exits"
FROM "montothu_2019"
JOIN "friday_2019" ON "friday_2019"."trip_id" = "montothu_2019"."trip_id"
JOIN "saturday_2019" ON "saturday_2019"."trip_id" = "friday_2019"."trip_id"
JOIN "sunday_2019" ON "sunday_2019"."trip_id" = "saturday_2019"."trip_id"
JOIN "stations" ON "stations"."id" = "montothu_2019"."dest_id"
GROUP BY "montothu_2019"."dest_id"
LIMIT 10;

-- AM Peak
SELECT "name", "montothu_2019"."dest_id",
SUM ((("montothu_2019"."am_peak")*4) + "friday_2019"."am_peak" + "saturday_2019"."am_peak" + "sunday_2019"."am_peak") AS "2019_am_peak_exits"
FROM "montothu_2019"
JOIN "friday_2019" ON "friday_2019"."trip_id" = "montothu_2019"."trip_id"
JOIN "saturday_2019" ON "saturday_2019"."trip_id" = "friday_2019"."trip_id"
JOIN "sunday_2019" ON "sunday_2019"."trip_id" = "saturday_2019"."trip_id"
JOIN "stations" ON "stations"."id" = "montothu_2019"."dest_id"
GROUP BY "montothu_2019"."dest_id"
LIMIT 10;

-- Midday
SELECT "name", "montothu_2019"."dest_id",
SUM ((("montothu_2019"."midday")*4) + "friday_2019"."midday" + "saturday_2019"."midday" + "sunday_2019"."midday") AS "2019_midday_exits"
FROM "montothu_2019"
JOIN "friday_2019" ON "friday_2019"."trip_id" = "montothu_2019"."trip_id"
JOIN "saturday_2019" ON "saturday_2019"."trip_id" = "friday_2019"."trip_id"
JOIN "sunday_2019" ON "sunday_2019"."trip_id" = "saturday_2019"."trip_id"
JOIN "stations" ON "stations"."id" = "montothu_2019"."dest_id"
GROUP BY "montothu_2019"."dest_id"
LIMIT 10;

-- PM Peak
SELECT "name", "montothu_2019"."dest_id",
SUM ((("montothu_2019"."pm_peak")*4) + "friday_2019"."pm_peak" + "saturday_2019"."pm_peak" + "sunday_2019"."pm_peak") AS "2019_pm_peak_exits"
FROM "montothu_2019"
JOIN "friday_2019" ON "friday_2019"."trip_id" = "montothu_2019"."trip_id"
JOIN "saturday_2019" ON "saturday_2019"."trip_id" = "friday_2019"."trip_id"
JOIN "sunday_2019" ON "sunday_2019"."trip_id" = "saturday_2019"."trip_id"
JOIN "stations" ON "stations"."id" = "montothu_2019"."dest_id"
GROUP BY "montothu_2019"."dest_id"
LIMIT 10;

-- Evening
SELECT "name", "montothu_2019"."dest_id",
SUM ((("montothu_2019"."evening")*4) + "friday_2019"."evening" + "saturday_2019"."evening" + "sunday_2019"."evening") AS "2019_evening_exits"
FROM "montothu_2019"
JOIN "friday_2019" ON "friday_2019"."trip_id" = "montothu_2019"."trip_id"
JOIN "saturday_2019" ON "saturday_2019"."trip_id" = "friday_2019"."trip_id"
JOIN "sunday_2019" ON "sunday_2019"."trip_id" = "saturday_2019"."trip_id"
JOIN "stations" ON "stations"."id" = "montothu_2019"."dest_id"
GROUP BY "montothu_2019"."dest_id"
LIMIT 10;

-- Late
SELECT "name", "montothu_2019"."dest_id",
SUM ((("montothu_2019"."late")*4) + "friday_2019"."late" + "saturday_2019"."late" + "sunday_2019"."late") AS "2019_late_exits"
FROM "montothu_2019"
JOIN "friday_2019" ON "friday_2019"."trip_id" = "montothu_2019"."trip_id"
JOIN "saturday_2019" ON "saturday_2019"."trip_id" = "friday_2019"."trip_id"
JOIN "sunday_2019" ON "sunday_2019"."trip_id" = "saturday_2019"."trip_id"
JOIN "stations" ON "stations"."id" = "montothu_2019"."dest_id"
GROUP BY "montothu_2019"."dest_id"
LIMIT 10;

-- 2022
-- Morning
SELECT "name", "monday_2022"."dest_id",
SUM ("monday_2022"."morning" + (("tuetothu_2022"."morning") * 3) + "friday_2022"."morning" + "saturday_2022"."morning" + "sunday_2022"."morning") AS "2022_morning_exits"
FROM "monday_2022"
JOIN "tuetothu_2022" ON "tuetothu_2022"."trip_id" = "monday_2022"."trip_id"
JOIN "friday_2022" ON "friday_2022"."trip_id" = "tuetothu_2022"."trip_id"
JOIN "saturday_2022" ON "saturday_2022"."trip_id" = "friday_2022"."trip_id"
JOIN "sunday_2022" ON "sunday_2022"."trip_id" = "saturday_2022"."trip_id"
JOIN "stations" ON "stations"."id" = "monday_2022"."dest_id"
GROUP BY "monday_2022"."dest_id"
LIMIT 10;

-- AM Peak
SELECT "name", "monday_2022"."dest_id",
SUM ("monday_2022"."am_peak" + (("tuetothu_2022"."am_peak") * 3) + "friday_2022"."am_peak" + "saturday_2022"."am_peak" + "sunday_2022"."am_peak") AS "2022_am_peak_exits"
FROM "monday_2022"
JOIN "tuetothu_2022" ON "tuetothu_2022"."trip_id" = "monday_2022"."trip_id"
JOIN "friday_2022" ON "friday_2022"."trip_id" = "tuetothu_2022"."trip_id"
JOIN "saturday_2022" ON "saturday_2022"."trip_id" = "friday_2022"."trip_id"
JOIN "sunday_2022" ON "sunday_2022"."trip_id" = "saturday_2022"."trip_id"
JOIN "stations" ON "stations"."id" = "monday_2022"."dest_id"
GROUP BY "monday_2022"."dest_id"
LIMIT 10;

-- Midday
SELECT "name", "monday_2022"."dest_id",
SUM ("monday_2022"."midday" + (("tuetothu_2022"."midday") * 3) + "friday_2022"."midday" + "saturday_2022"."midday" + "sunday_2022"."midday") AS "2022_midday_exits"
FROM "monday_2022"
JOIN "tuetothu_2022" ON "tuetothu_2022"."trip_id" = "monday_2022"."trip_id"
JOIN "friday_2022" ON "friday_2022"."trip_id" = "tuetothu_2022"."trip_id"
JOIN "saturday_2022" ON "saturday_2022"."trip_id" = "friday_2022"."trip_id"
JOIN "sunday_2022" ON "sunday_2022"."trip_id" = "saturday_2022"."trip_id"
JOIN "stations" ON "stations"."id" = "monday_2022"."dest_id"
GROUP BY "monday_2022"."dest_id"
LIMIT 10;

-- PM Peak
SELECT "name", "monday_2022"."dest_id",
SUM ("monday_2022"."pm_peak" + (("tuetothu_2022"."pm_peak") * 3) + "friday_2022"."pm_peak" + "saturday_2022"."pm_peak" + "sunday_2022"."pm_peak") AS "2022_pm_peak_exits"
FROM "monday_2022"
JOIN "tuetothu_2022" ON "tuetothu_2022"."trip_id" = "monday_2022"."trip_id"
JOIN "friday_2022" ON "friday_2022"."trip_id" = "tuetothu_2022"."trip_id"
JOIN "saturday_2022" ON "saturday_2022"."trip_id" = "friday_2022"."trip_id"
JOIN "sunday_2022" ON "sunday_2022"."trip_id" = "saturday_2022"."trip_id"
JOIN "stations" ON "stations"."id" = "monday_2022"."dest_id"
GROUP BY "monday_2022"."dest_id"
LIMIT 10;

-- Evening
SELECT "name", "monday_2022"."dest_id",
SUM ("monday_2022"."evening" + (("tuetothu_2022"."evening") * 3) + "friday_2022"."evening" + "saturday_2022"."evening" + "sunday_2022"."evening") AS "2022_evening_exits"
FROM "monday_2022"
JOIN "tuetothu_2022" ON "tuetothu_2022"."trip_id" = "monday_2022"."trip_id"
JOIN "friday_2022" ON "friday_2022"."trip_id" = "tuetothu_2022"."trip_id"
JOIN "saturday_2022" ON "saturday_2022"."trip_id" = "friday_2022"."trip_id"
JOIN "sunday_2022" ON "sunday_2022"."trip_id" = "saturday_2022"."trip_id"
JOIN "stations" ON "stations"."id" = "monday_2022"."dest_id"
GROUP BY "monday_2022"."dest_id"
LIMIT 10;

-- Late
SELECT "name", "monday_2022"."dest_id",
SUM ("monday_2022"."late" + (("tuetothu_2022"."late") * 3) + "friday_2022"."late" + "saturday_2022"."late" + "sunday_2022"."late") AS "2022_late_exits"
FROM "monday_2022"
JOIN "tuetothu_2022" ON "tuetothu_2022"."trip_id" = "monday_2022"."trip_id"
JOIN "friday_2022" ON "friday_2022"."trip_id" = "tuetothu_2022"."trip_id"
JOIN "saturday_2022" ON "saturday_2022"."trip_id" = "friday_2022"."trip_id"
JOIN "sunday_2022" ON "sunday_2022"."trip_id" = "saturday_2022"."trip_id"
JOIN "stations" ON "stations"."id" = "monday_2022"."dest_id"
GROUP BY "monday_2022"."dest_id"
LIMIT 10;

-- Percentage change from 2019 to 2022
SELECT "total_weekly_exits_2019"."name", "total_weekly_exits_2019"."dest_id", "total_weekly_exits_2019"."total_weekly_exits" AS "total_weekly_exits_19", "total_weekly_exits_2022"."total_weekly_exits" AS "total_weekly_exits_22", (("total_weekly_exits_2022"."total_weekly_exits" - "total_weekly_exits_2019"."total_weekly_exits") / "total_weekly_exits_2019"."total_weekly_exits") * 100 AS "percentage_change" 
FROM "total_weekly_exits_2019"
JOIN "total_weekly_exits_2022" ON "total_weekly_exits_2019"."dest_id" = "total_weekly_exits_2022"."dest_id"
ORDER BY "percentage_change" ASC;

-- Top 5 Stations by Percentage Change in Total Weekly Exits
SELECT "name", "percentage_change"
FROM (
    SELECT "total_weekly_exits_2019"."name", "total_weekly_exits_2019"."dest_id", (("total_weekly_exits_2022"."total_weekly_exits" - "total_weekly_exits_2019"."total_weekly_exits") / "total_weekly_exits_2019"."total_weekly_exits") * 100 AS "percentage_change" 
    FROM "total_weekly_exits_2019"
    JOIN "total_weekly_exits_2022" ON "total_weekly_exits_2019"."dest_id" = "total_weekly_exits_2022"."dest_id")
ORDER BY "percentage_change" DESC
LIMIT 5;

-- Bottom 5 Stations by Percentage Change in Total Weekly Exits
SELECT "name", "percentage_change"
FROM (
    SELECT "total_weekly_exits_2019"."name", "total_weekly_exits_2019"."dest_id", (("total_weekly_exits_2022"."total_weekly_exits" - "total_weekly_exits_2019"."total_weekly_exits") / "total_weekly_exits_2019"."total_weekly_exits") * 100 AS "percentage_change" 
    FROM "total_weekly_exits_2019"
    JOIN "total_weekly_exits_2022" ON "total_weekly_exits_2019"."dest_id" = "total_weekly_exits_2022"."dest_id")
ORDER BY "percentage_change" ASC
LIMIT 5;

-- Top Destination by Origin (Most Total Exits)
.schema
SELECT "trip_id", "org_id", "dest_id", MAX("total_daily_exits")
FROM(
    SELECT "trip_id", "org_id", "dest_id", ("morning" + "am_peak" + "midday" + "pm_peak" + "evening" + "late") AS "total_daily_exits" 
    FROM "montothu_2019")
GROUP BY "org_id";

-- Total Weekly Exits by OD Pairs 2019
SELECT "montothu_2019"."trip_id", "montothu_2019"."org_id", "montothu_2019"."dest_id",
SUM ((("montothu_2019"."morning" + "montothu_2019"."am_peak" + "montothu_2019"."midday" + "montothu_2019"."pm_peak" + "montothu_2019"."evening" + "montothu_2019"."late")*4) +
    "friday_2019"."morning" + "friday_2019"."am_peak" + "friday_2019"."midday" + "friday_2019"."pm_peak" + "friday_2019"."evening" + "friday_2019"."late" +
    "saturday_2019"."morning" + "saturday_2019"."am_peak" + "saturday_2019"."midday" + "saturday_2019"."pm_peak" + "saturday_2019"."evening" + "saturday_2019"."late" +
    "sunday_2019"."morning" + "sunday_2019"."am_peak" + "sunday_2019"."midday" + "sunday_2019"."pm_peak" + "sunday_2019"."evening" + "sunday_2019"."late"
) AS "total_weekly_exits"
FROM "montothu_2019"
JOIN "friday_2019" ON "friday_2019"."trip_id" = "montothu_2019"."trip_id"
JOIN "saturday_2019" ON "saturday_2019"."trip_id" = "friday_2019"."trip_id"
JOIN "sunday_2019" ON "sunday_2019"."trip_id" = "saturday_2019"."trip_id"
GROUP BY "montothu_2019"."dest_id"
ORDER BY "montothu_2019"."trip_id" ASC;

-- Top Destinations by Origins


SELECT "dest_id", COUNT("dest_id") FROM "2019"
GROUP BY "dest_id"
ORDER BY COUNT("dest_id") DESC, "dest_id" ASC;

-- Total Weekly Exits Rankings
-- 2019
SELECT * FROM "total_weekly_exits_2019"
ORDER BY "total_weekly_exits" DESC;

-- 2022
SELECT * FROM "total_weekly_exits_2022"
WHERE "dest_id" IN (
    SELECT "dest_id" FROM "total_weekly_exits_2019")
ORDER BY "total_weekly_exits" DESC;

-- Mention Missing Stations in Report
-- Absolute Ranking Change by Total Weekly Exits

-- total_weekly_exits_2019
-- total_weekly_exits_2022

-- 2.3 Top 20 Most Absolute Changes in Total Weekly Exits by Destination
SELECT "rank_19", "rank_22", ("rank_19" - "rank_22") AS "rank_change", "name", "weekly_total_2019", "weekly_total_2022"
FROM (
    SELECT * FROM (
        SELECT "dest_id", "rank_19", "name", "total_weekly_exits" AS "weekly_total_2019"
        FROM (
            SELECT ROW_NUMBER() OVER (ORDER BY "total_weekly_exits" DESC) AS "rank_19", *
            FROM "total_weekly_exits_2019"))
    NATURAL JOIN (
        SELECT "dest_id", "rank_22", "total_weekly_exits" AS "weekly_total_2022" FROM (
            SELECT ROW_NUMBER() OVER (ORDER BY "total_weekly_exits" DESC) AS "rank_22", *
            FROM (
                SELECT * FROM "total_weekly_exits_2022"
                WHERE "dest_id" IN (
                    SELECT "dest_id" FROM "total_weekly_exits_2019")
                ORDER BY "total_weekly_exits" DESC))
        )
ORDER BY ABS("rank_19" - "rank_22") DESC)
LIMIT 20;
-- Unchanged, increasing, weakening

.schema


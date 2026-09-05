.schema

-- Weekly Totals for Each Connection
-- 2019
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
GROUP BY "montothu_2019"."trip_id";

-- 2022
SELECT "monday_2022"."trip_id", "monday_2022"."org_id", "monday_2022"."dest_id",
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
GROUP BY "monday_2022"."trip_id";

-- Most Popular Destination by Origin 2019
SELECT "name", "dest_id", COUNT("dest_id") AS "choice_frequency"
FROM (
    SELECT "trip_id", "org_id", "dest_id", MAX(total_weekly_exits)
    FROM (
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
        GROUP BY "montothu_2019"."trip_id")
    GROUP BY "org_id")
JOIN "stations" ON "stations"."id" = "dest_id"
GROUP BY "dest_id"
ORDER BY COUNT("dest_id") DESC;

-- Most Popular Destination by Origin 2022

SELECT "name", "dest_id", COUNT("dest_id") AS "choice_frequency"
FROM (
    SELECT "trip_id", "org_id", "dest_id", MAX(total_weekly_exits)
    FROM (
        SELECT "monday_2022"."trip_id", "monday_2022"."org_id", "monday_2022"."dest_id",
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
        GROUP BY "monday_2022"."trip_id")
    GROUP BY "org_id")
JOIN "stations" ON "stations"."id" = "dest_id"
GROUP BY "dest_id"
ORDER BY COUNT("dest_id") DESC;

-- Monday vs Tuesday to Thursday Difference in 2022

-- Total 2022 Monday Exits
SELECT "name", "dest_id", COUNT("dest_id")
FROM (
    SELECT "trip_id", "org_id", "dest_id", MAX("total_monday_exits")
    FROM (
        SELECT "trip_id", "org_id", "dest_id",
        SUM ("morning" + "am_peak" + "midday" + "pm_peak" + "evening" + "late") AS "total_monday_exits"
        FROM "monday_2022"
        GROUP BY "trip_id")
    GROUP BY "org_id")
JOIN "stations" ON "stations"."id" = "dest_id"
GROUP BY "dest_id"
ORDER BY COUNT("dest_id") DESC, "name" ASC;

-- Total 2022 Tuesday to Thursday Exits
SELECT "name", "dest_id", COUNT("dest_id")
FROM (
    SELECT "trip_id", "org_id", "dest_id", MAX("total_tuetothu_exits")
    FROM (
        SELECT "trip_id", "org_id",  "dest_id",
        SUM ("morning" + "am_peak" + "midday" + "pm_peak" + "evening" + "late") AS "total_tuetothu_exits"
        FROM "tuetothu_2022"
        GROUP BY "trip_id")
    GROUP BY "org_id")
JOIN "stations" ON "stations"."id" = "dest_id"
GROUP BY "dest_id"
ORDER BY COUNT("dest_id") DESC, "name" ASC;

-- In monday, not in tuetothu
SELECT "name" 
FROM (
    SELECT "name", "dest_id", COUNT("dest_id")
    FROM (
        SELECT "trip_id", "org_id", "dest_id", MAX("total_monday_exits")
        FROM (
            SELECT "trip_id", "org_id", "dest_id",
            SUM ("morning" + "am_peak" + "midday" + "pm_peak" + "evening" + "late") AS "total_monday_exits"
            FROM "monday_2022"
            GROUP BY "trip_id")
        GROUP BY "org_id")
    JOIN "stations" ON "stations"."id" = "dest_id"
    GROUP BY "dest_id"
    ORDER BY COUNT("dest_id") DESC, "name" ASC)
WHERE "name" NOT IN (
    SELECT "name"
    FROM (
        SELECT "name", "dest_id", COUNT("dest_id")
        FROM (
            SELECT "trip_id", "org_id", "dest_id", MAX("total_tuetothu_exits")
            FROM (
                SELECT "trip_id", "org_id",  "dest_id",
                SUM ("morning" + "am_peak" + "midday" + "pm_peak" + "evening" + "late") AS "total_tuetothu_exits"
                FROM "tuetothu_2022"
                GROUP BY "trip_id")
            GROUP BY "org_id")
        JOIN "stations" ON "stations"."id" = "dest_id"
        GROUP BY "dest_id"
        ORDER BY COUNT("dest_id") DESC, "name" ASC));

-- In tuetothu not in monday
SELECT "name" 
FROM (
    SELECT "name", "dest_id", COUNT("dest_id")
        FROM (
            SELECT "trip_id", "org_id", "dest_id", MAX("total_tuetothu_exits")
            FROM (
                SELECT "trip_id", "org_id",  "dest_id",
                SUM ("morning" + "am_peak" + "midday" + "pm_peak" + "evening" + "late") AS "total_tuetothu_exits"
                FROM "tuetothu_2022"
                GROUP BY "trip_id")
            GROUP BY "org_id")
        JOIN "stations" ON "stations"."id" = "dest_id"
        GROUP BY "dest_id"
        ORDER BY COUNT("dest_id") DESC, "name" ASC)
WHERE "name" NOT IN (
    SELECT "name"
    FROM (
        SELECT "name", "dest_id", COUNT("dest_id")
        FROM (
            SELECT "trip_id", "org_id", "dest_id", MAX("total_monday_exits")
            FROM (
                SELECT "trip_id", "org_id", "dest_id",
                SUM ("morning" + "am_peak" + "midday" + "pm_peak" + "evening" + "late") AS "total_monday_exits"
                FROM "monday_2022"
                GROUP BY "trip_id")
            GROUP BY "org_id")
        JOIN "stations" ON "stations"."id" = "dest_id"
        GROUP BY "dest_id"
        ORDER BY COUNT("dest_id") DESC, "name" ASC));


-- Hypothesis Testing: Wilcoxon Test Reveals a significant difference between total weekly ridership between 2019 and 2022
-- General Overview: There seems to be an overall decline in ridership from 2019 to 2022
    -- Destination Popularity by Percentage Change: Add mean percentage change, stations that saw significant difference, stations that saw negligible difference
    -- Insights:

-- Hubs by Absolute Totals [2019 vs 2022]
    -- Gephi Map
  GROUP BY "trip_id")    -- Insights:

-- Hubs by Days of the Week [compared to eachother]
    -- Insights:

-- Hubs by Days of the Week [2019 vs 2022 (paired)]
    -- Insights:

-- Between Hubs Movement? [Possible Seggregation in Districts]
    -- Map the movement of origins for other hubs [Primary, Secondary, Tertiary Preference etc.], Is there a non-preference?

-- Finer Details for Selected Stations [Time of the day etc.]

-- Degree Centrality

SELECT * 
FROM (
    SELECT "name", COUNT("trip_id") AS "connections"
    FROM "montothu_2019"
    JOIN "stations" ON "stations"."id" = "montothu_2019"."org_id"
    GROUP BY "org_id"
    ORDER BY "connections" DESC)
WHERE "connections" < 206.9;

SELECT *, "name"
FROM (
    SELECT "trip_id", "org_id", "name" AS "origin", "dest_id", "morning" FROM "montothu_2019"
    JOIN "stations" ON "stations"."id" = "montothu_2019"."org_id"
    LIMIT 10)
JOIN "stations" ON "stations"."id" = "dest_id";





SELECT "trip_id", "org_id", "dest_id", MAX("total_weekly_exits")
FROM(
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
    GROUP BY "montothu_2019"."trip_id")
GROUP BY "org_id";


-- View for Visualisation
-- 2019
CREATE VIEW "hub_viz_2019" AS
SELECT * 
FROM (
    SELECT "trip_id", "org_id", "name" AS "origin", "lat" AS "org_lat", "long" AS "org_long"
    FROM (
        SELECT "trip_id", "org_id", "dest_id", MAX("total_weekly_exits")
        FROM(
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
            GROUP BY "montothu_2019"."trip_id")
        GROUP BY "org_id")
    JOIN "stations" ON "stations"."id" = "org_id"
    JOIN "coordinates" ON "coordinates"."station_id" = "org_id")

NATURAL JOIN (

    SELECT "trip_id", "dest_id", "name" AS "destination", "lat" AS "dest_lat", "long" AS "dest_long", "max_weekly_exits"
    FROM (
        SELECT "trip_id", "org_id", "dest_id", MAX("total_weekly_exits") AS "max_weekly_exits"
        FROM(
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
            GROUP BY "montothu_2019"."trip_id")
        GROUP BY "org_id")
    JOIN "stations" ON "stations"."id" = "dest_id"
    JOIN "coordinates" ON "coordinates"."station_id" = "dest_id");

-- 2022

SELECT "trip_id", "org_id", "dest_id", MAX(total_weekly_exits) AS "max_weekly_exits"
FROM (
    SELECT "monday_2022"."trip_id", "monday_2022"."org_id", "monday_2022"."dest_id",
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
    GROUP BY "monday_2022"."trip_id")
GROUP BY "org_id";
SELECT * FROM "hub_viz_2019";
-- Origin Table: Create View
CREATE VIEW "hub_viz_2022" AS
SELECT *
FROM (
    SELECT "trip_id", "org_id", "name" AS "origin", "lat" AS "org_lat", "long" AS "org_long"
    FROM (
        SELECT "trip_id", "org_id", "dest_id", MAX(total_weekly_exits) AS "max_weekly_exits"
        FROM (
            SELECT "monday_2022"."trip_id", "monday_2022"."org_id", "monday_2022"."dest_id",
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
            GROUP BY "monday_2022"."trip_id")
        GROUP BY "org_id")
    JOIN "stations" ON "stations"."id" = "org_id"
    JOIN "coordinates" ON "coordinates"."station_id" = "org_id")

NATURAL JOIN (

    SELECT "trip_id", "dest_id", "name" AS "destination", "lat" AS "dest_lat", "long" AS "dest_long", "max_weekly_exits"
    FROM (
    SELECT "trip_id", "org_id", "dest_id", MAX(total_weekly_exits) AS "max_weekly_exits"
        FROM (
            SELECT "monday_2022"."trip_id", "monday_2022"."org_id", "monday_2022"."dest_id",
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
            GROUP BY "monday_2022"."trip_id")
        GROUP BY "org_id")
    JOIN "stations" ON "stations"."id" = "dest_id"
    JOIN "coordinates" ON "coordinates"."station_id" = "dest_id");



-- Top 3 Destinations for Each Origin

-- 2019
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
GROUP BY "montothu_2019"."trip_id"
ORDER BY "montothu_2019"."org_id" ASC, "total_weekly_exits" DESC;

-- Join Names 
CREATE VIEW "destbyorg_2019" AS
SELECT * 
FROM (
    SELECT "trip_id", "org_id", "name" AS "origin"
    FROM (
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
        GROUP BY "montothu_2019"."trip_id"
        ORDER BY "montothu_2019"."org_id" ASC, "total_weekly_exits" DESC)
    JOIN "stations" ON "stations"."id" = "org_id")
NATURAL JOIN (
    SELECT "trip_id", "dest_id", "name" AS "destination", "total_weekly_exits"
    FROM (
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
        GROUP BY "montothu_2019"."trip_id"
        ORDER BY "montothu_2019"."org_id" ASC, "total_weekly_exits" DESC)
    JOIN "stations" ON "stations"."id" = "dest_id");

SELECT "destination", COUNT("destination")
FROM (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER (PARTITION BY "org_id" ORDER BY "total_weekly_exits" DESC) AS "rowrank"
        FROM "destbyorg_2019")
    WHERE "rowrank" <= 3)
GROUP BY "destination"
ORDER BY COUNT("destination") DESC;


SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY "org_id" ORDER BY "total_weekly_exits" DESC) AS "rowrank"
    FROM "destbyorg_2019")
WHERE "rowrank" <= 3;
GROUP BY "destination"
ORDER BY COUNT("destination") DESC;

-- destbyorg_2022

SELECT "monday_2022"."trip_id", "monday_2022"."org_id", "monday_2022"."dest_id",
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
GROUP BY "monday_2022"."trip_id"
ORDER BY "monday_2022"."org_id" ASC, "total_weekly_exits" DESC;

-- Join names
CREATE VIEW "destbyorg_2022" AS
SELECT * 
FROM (
    SELECT "trip_id", "org_id", "name" AS "origin"
    FROM (
        SELECT "monday_2022"."trip_id", "monday_2022"."org_id", "monday_2022"."dest_id",
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
        GROUP BY "monday_2022"."trip_id"
        ORDER BY "monday_2022"."org_id" ASC, "total_weekly_exits" DESC)
    JOIN "stations" ON "stations"."id" = "org_id")
NATURAL JOIN (
    SELECT "trip_id", "dest_id", "name" AS "destination", "total_weekly_exits"
    FROM (
        SELECT "monday_2022"."trip_id", "monday_2022"."org_id", "monday_2022"."dest_id",
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
        GROUP BY "monday_2022"."trip_id"
        ORDER BY "monday_2022"."org_id" ASC, "total_weekly_exits" DESC)
    JOIN "stations" ON "stations"."id" = "dest_id");

-- Top 3 destinations by origin 2022

SELECT "destination", COUNT("destination") AS "count"
FROM (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER (PARTITION BY "org_id" ORDER BY "total_weekly_exits" DESC) AS "rowrank"
        FROM "destbyorg_2022")
    WHERE "rowrank" <= 3)
GROUP BY "destination"
ORDER BY COUNT("destination")DESC;

-- Link Load Percentage Change
SELECT "total_link_load_2019"."trip_id", "total_link_load_2019"."org_id", "total_link_load_2019"."dest_id", "total_link_load_2019"."total_link_load" AS "load_19", "total_link_load_2022"."total_link_load" AS "load_22",
(("total_link_load_2022"."total_link_load" - "total_link_load_2019"."total_link_load") / "total_link_load_2019"."total_link_load") * 100 AS "percentage_change" 
FROM "total_link_load_2019"
JOIN "total_link_load_2022" ON "total_link_load_2022"."trip_id" = "total_link_load_2019"."trip_id"
ORDER BY "percentage_change" DESC;


-- Top Destination by Origin Count
-- 2019

SELECT "destination", COUNT("destination") AS "count"
FROM (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER (PARTITION BY "org_id" ORDER BY "total_weekly_exits" DESC) AS "rowrank"
        FROM "destbyorg_2019")
    WHERE "rowrank" = 1)
GROUP BY "destination"
ORDER BY COUNT("destination") DESC;


-- 2022
SELECT "destination", COUNT("destination") AS "count"
FROM (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER (PARTITION BY "org_id" ORDER BY "total_weekly_exits" DESC) AS "rowrank"
        FROM "destbyorg_2022")
    WHERE "rowrank" = 1)
GROUP BY "destination"
ORDER BY COUNT("destination")DESC;


-- Load Data Into "sig_stations"
CREATE VIEW "sig_stations" AS
SELECT "id", "name" FROM "stations"
WHERE "name" IN (
"Richmond",
"Chancery Lane",
"Ealing Broadway",
"Barbican",
"Lancaster Gate",
"Cannon Street LU",
"Heathrow Terminal 4 LU",
"Regent's Park",
"St. Paul's",
"Liverpool Street LU",
"Tottenham Court Road",
"Hyde Park Corner",
"Moorgate",
"Stonebridge Park",
"Mill Hill East",
"Kensington (Olympia)",
"Woodside Park",
"Kew Gardens",
"Wembley Park",
"Buckhurst Hill",
"Vauxhall LU",
"Leicester Square",
"Bond Street",
"Piccadilly Circus",
"Bank and Monument",
"Paddington TfL"
);

SELECT * FROM "sig_stations";

-- Peak Hours Heatmap
.schema

SELECT * FROM "friday_2019"
LIMIT 20;

-- 2019 table
SELECT "name", "dest_id", "day", "morning", "am_peak", "midday", "pm_peak", "evening", "late"
FROM (
    SELECT "dest_id", "a_montothu" AS "day", SUM("morning") AS "morning", SUM("am_peak") AS "am_peak", SUM("midday") AS "midday", SUM("pm_peak") AS "pm_peak", SUM("evening") AS "evening", SUM("late") AS "late"
    FROM "montothu_2019"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "b_friday" AS "day", SUM("morning") AS "morning", SUM("am_peak") AS "am_peak", SUM("midday") AS "midday", SUM("pm_peak") AS "pm_peak", SUM("evening") AS "evening", SUM("late") AS "late"
    FROM "friday_2019"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "c_saturday" AS "day", SUM("morning") AS "morning", SUM("am_peak") AS "am_peak", SUM("midday") AS "midday", SUM("pm_peak") AS "pm_peak", SUM("evening") AS "evening", SUM("late") AS "late"
    FROM "saturday_2019"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "d_sunday" AS "day", SUM("morning") AS "morning", SUM("am_peak") AS "am_peak", SUM("midday") AS "midday", SUM("pm_peak") AS "pm_peak", SUM("evening") AS "evening", SUM("late") AS "late"
    FROM "sunday_2019"
    GROUP BY "dest_id")
JOIN "stations" ON "stations"."id" = "dest_id" 
WHERE "dest_id" IN (
    SELECT "id" FROM "sig_stations");

-- 2022 table

SELECT "name", "dest_id", "day", "morning", "am_peak", "midday", "pm_peak", "evening", "late"
FROM (
    SELECT "dest_id", "a_monday" AS "day", SUM("morning") AS "morning", SUM("am_peak") AS "am_peak", SUM("midday") AS "midday", SUM("pm_peak") AS "pm_peak", SUM("evening") AS "evening", SUM("late") AS "late"
    FROM "monday_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "b_tuetothu" AS "day", SUM("morning") AS "morning", SUM("am_peak") AS "am_peak", SUM("midday") AS "midday", SUM("pm_peak") AS "pm_peak", SUM("evening") AS "evening", SUM("late") AS "late"
    FROM "tuetothu_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "c_friday" AS "day", SUM("morning") AS "morning", SUM("am_peak") AS "am_peak", SUM("midday") AS "midday", SUM("pm_peak") AS "pm_peak", SUM("evening") AS "evening", SUM("late") AS "late"
    FROM "friday_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "d_saturday" AS "day", SUM("morning") AS "morning", SUM("am_peak") AS "am_peak", SUM("midday") AS "midday", SUM("pm_peak") AS "pm_peak", SUM("evening") AS "evening", SUM("late") AS "late"
    FROM "saturday_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "e_sunday" AS "day", SUM("morning") AS "morning", SUM("am_peak") AS "am_peak", SUM("midday") AS "midday", SUM("pm_peak") AS "pm_peak", SUM("evening") AS "evening", SUM("late") AS "late"
    FROM "sunday_2022"
    GROUP BY "dest_id")
JOIN "stations" ON "stations"."id" = "dest_id"
WHERE "dest_id" IN (
    SELECT "id" FROM "sig_stations");





-- Heatmap files

-- 2019
SELECT "name", "dest_id", "day", "time", "value"
FROM (
    -- 2019 montothu
    SELECT "dest_id", "a_montothu" AS "day", "a_morning" AS "time", SUM("morning") AS "value"
    FROM "montothu_2019"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "a_montothu" AS "day", "b_am_peak" AS "time", SUM("am_peak") AS "value"
    FROM "montothu_2019"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "a_montothu" AS "day", "c_midday" AS "time", SUM("midday") AS "value"
    FROM "montothu_2019"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "a_montothu" AS "day", "d_pm_peak" AS "time", SUM("pm_peak") AS "value"
    FROM "montothu_2019"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "a_montothu" AS "day", "e_evening" AS "time", SUM("evening") AS "value"
    FROM "montothu_2019"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "a_montothu" AS "day", "f_late" AS "time", SUM("late") AS "value"
    FROM "montothu_2019"
    GROUP BY "dest_id"
    UNION
    -- 2019 friday
    SELECT "dest_id", "b_friday" AS "day", "a_morning" AS "time", SUM("morning") AS "value"
    FROM "friday_2019"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "b_friday" AS "day", "b_am_peak" AS "time", SUM("am_peak") AS "value"
    FROM "friday_2019"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "b_friday" AS "day", "c_midday" AS "time", SUM("midday") AS "value"
    FROM "friday_2019"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "b_friday" AS "day", "d_pm_peak" AS "time", SUM("pm_peak") AS "value"
    FROM "friday_2019"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "b_friday" AS "day", "e_evening" AS "time", SUM("evening") AS "value"
    FROM "friday_2019"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "b_friday" AS "day", "f_late" AS "time", SUM("late") AS "value"
    FROM "friday_2019"
    GROUP BY "dest_id"
    UNION
    -- 2019 saturday
    SELECT "dest_id", "c_saturday" AS "day", "a_morning" AS "time", SUM("morning") AS "value"
    FROM "saturday_2019"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "c_saturday" AS "day", "b_am_peak" AS "time", SUM("am_peak") AS "value"
    FROM "saturday_2019"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "c_saturday" AS "day", "c_midday" AS "time", SUM("midday") AS "value"
    FROM "saturday_2019"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "c_saturday" AS "day", "d_pm_peak" AS "time", SUM("pm_peak") AS "value"
    FROM "saturday_2019"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "c_saturday" AS "day", "e_evening" AS "time", SUM("evening") AS "value"
    FROM "saturday_2019"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "c_saturday" AS "day", "f_late" AS "time", SUM("late") AS "value"
    FROM "saturday_2019"
    GROUP BY "dest_id"
    UNION
    -- 2019 sunday
    SELECT "dest_id", "d_sunday" AS "day", "a_morning" AS "time", SUM("morning") AS "value"
    FROM "sunday_2019"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "d_sunday" AS "day", "b_am_peak" AS "time", SUM("am_peak") AS "value"
    FROM "sunday_2019"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "d_sunday" AS "day", "c_midday" AS "time", SUM("midday") AS "value"
    FROM "sunday_2019"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "d_sunday" AS "day", "d_pm_peak" AS "time", SUM("pm_peak") AS "value"
    FROM "sunday_2019"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "d_sunday" AS "day", "e_evening" AS "time", SUM("evening") AS "value"
    FROM "sunday_2019"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "d_sunday" AS "day", "f_late" AS "time", SUM("late") AS "value"
    FROM "sunday_2019"
    GROUP BY "dest_id")
JOIN "stations" ON "stations"."id" = "dest_id"
WHERE "dest_id" IN (
    SELECT "id" FROM "sig_stations"
);

-- 2022
SELECT "name", "dest_id", "day", "time", "value"
FROM (
    -- 2022 monday
    SELECT "dest_id", "a_monday" AS "day", "a_morning" AS "time", SUM("morning") AS "value"
    FROM "monday_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "a_monday" AS "day", "b_am_peak" AS "time", SUM("am_peak") AS "value"
    FROM "monday_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "a_monday" AS "day", "c_midday" AS "time", SUM("midday") AS "value"
    FROM "monday_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "a_monday" AS "day", "d_pm_peak" AS "time", SUM("pm_peak") AS "value"
    FROM "monday_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "a_monday" AS "day", "e_evening" AS "time", SUM("evening") AS "value"
    FROM "monday_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "a_monday" AS "day", "f_late" AS "time", SUM("late") AS "value"
    FROM "monday_2022"
    GROUP BY "dest_id"
    UNION
    -- 2022 tuetothu
    SELECT "dest_id", "b_tuetothu" AS "day", "a_morning" AS "time", SUM("morning") AS "value"
    FROM "tuetothu_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "b_tuetothu" AS "day", "b_am_peak" AS "time", SUM("am_peak") AS "value"
    FROM "tuetothu_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "b_tuetothu" AS "day", "c_midday" AS "time", SUM("midday") AS "value"
    FROM "tuetothu_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "b_tuetothu" AS "day", "d_pm_peak" AS "time", SUM("pm_peak") AS "value"
    FROM "tuetothu_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "b_tuetothu" AS "day", "e_evening" AS "time", SUM("evening") AS "value"
    FROM "tuetothu_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "b_tuetothu" AS "day", "f_late" AS "time", SUM("late") AS "value"
    FROM "tuetothu_2022"
    GROUP BY "dest_id"
    UNION
    -- 2022 friday
    SELECT "dest_id", "c_friday" AS "day", "a_morning" AS "time", SUM("morning") AS "value"
    FROM "friday_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "c_friday" AS "day", "b_am_peak" AS "time", SUM("am_peak") AS "value"
    FROM "friday_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "c_friday" AS "day", "c_midday" AS "time", SUM("midday") AS "value"
    FROM "friday_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "c_friday" AS "day", "d_pm_peak" AS "time", SUM("pm_peak") AS "value"
    FROM "friday_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "c_friday" AS "day", "e_evening" AS "time", SUM("evening") AS "value"
    FROM "friday_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "c_friday" AS "day", "f_late" AS "time", SUM("late") AS "value"
    FROM "friday_2022"
    GROUP BY "dest_id"
    UNION
    -- 2022 saturday
    SELECT "dest_id", "d_saturday" AS "day", "a_morning" AS "time", SUM("morning") AS "value"
    FROM "saturday_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "d_saturday" AS "day", "b_am_peak" AS "time", SUM("am_peak") AS "value"
    FROM "saturday_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "d_saturday" AS "day", "c_midday" AS "time", SUM("midday") AS "value"
    FROM "saturday_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "d_saturday" AS "day", "d_pm_peak" AS "time", SUM("pm_peak") AS "value"
    FROM "saturday_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "d_saturday" AS "day", "e_evening" AS "time", SUM("evening") AS "value"
    FROM "saturday_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "d_saturday" AS "day", "f_late" AS "time", SUM("late") AS "value"
    FROM "saturday_2022"
    GROUP BY "dest_id"
    UNION
    -- 2022 sunday
    SELECT "dest_id", "e_sunday" AS "day", "a_morning" AS "time", SUM("morning") AS "value"
    FROM "sunday_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "e_sunday" AS "day", "b_am_peak" AS "time", SUM("am_peak") AS "value"
    FROM "sunday_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "e_sunday" AS "day", "c_midday" AS "time", SUM("midday") AS "value"
    FROM "sunday_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "e_sunday" AS "day", "d_pm_peak" AS "time", SUM("pm_peak") AS "value"
    FROM "sunday_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "e_sunday" AS "day", "e_evening" AS "time", SUM("evening") AS "value"
    FROM "sunday_2022"
    GROUP BY "dest_id"
    UNION
    SELECT "dest_id", "e_sunday" AS "day", "f_late" AS "time", SUM("late") AS "value"
    FROM "sunday_2022"
    GROUP BY "dest_id")
JOIN "stations" ON "stations"."id" = "dest_id"
WHERE "dest_id" IN (
    SELECT "id" FROM "sig_stations"
);

SELECT * FROM "sig_stations";

-- total link load 2019
CREATE VIEW "total_link_load_2019" AS
SELECT "montothu_2019"."trip_id", "montothu_2019"."org_id", "montothu_2019"."dest_id",
SUM ((("montothu_2019"."morning" + "montothu_2019"."am_peak" + "montothu_2019"."midday" + "montothu_2019"."pm_peak" + "montothu_2019"."evening" + "montothu_2019"."late")*4) +
    "friday_2019"."morning" + "friday_2019"."am_peak" + "friday_2019"."midday" + "friday_2019"."pm_peak" + "friday_2019"."evening" + "friday_2019"."late" +
    "saturday_2019"."morning" + "saturday_2019"."am_peak" + "saturday_2019"."midday" + "saturday_2019"."pm_peak" + "saturday_2019"."evening" + "saturday_2019"."late" +
    "sunday_2019"."morning" + "sunday_2019"."am_peak" + "sunday_2019"."midday" + "sunday_2019"."pm_peak" + "sunday_2019"."evening" + "sunday_2019"."late"
) AS "link_load_19"
FROM "montothu_2019"
JOIN "friday_2019" ON "friday_2019"."trip_id" = "montothu_2019"."trip_id"
JOIN "saturday_2019" ON "saturday_2019"."trip_id" = "friday_2019"."trip_id"
JOIN "sunday_2019" ON "sunday_2019"."trip_id" = "saturday_2019"."trip_id"
GROUP BY "montothu_2019"."trip_id";

-- total link load 2022
CREATE VIEW "total_link_load_2022" AS
SELECT "monday_2022"."trip_id", "monday_2022"."org_id", "monday_2022"."dest_id",
SUM ("monday_2022"."morning" + "monday_2022"."am_peak" + "monday_2022"."midday" + "monday_2022"."pm_peak" + "monday_2022"."evening" + "monday_2022"."late" +
    (("tuetothu_2022"."morning" + "tuetothu_2022"."am_peak" + "tuetothu_2022"."midday" + "tuetothu_2022"."pm_peak" + "tuetothu_2022"."evening" + "tuetothu_2022"."late")*3) +
    "friday_2022"."morning" + "friday_2022"."am_peak" + "friday_2022"."midday" + "friday_2022"."pm_peak" + "friday_2022"."evening" + "friday_2022"."late" +
    "saturday_2022"."morning" + "saturday_2022"."am_peak" + "saturday_2022"."midday" + "saturday_2022"."pm_peak" + "saturday_2022"."evening" + "saturday_2022"."late" +
    "sunday_2022"."morning" + "sunday_2022"."am_peak" + "sunday_2022"."midday" + "sunday_2022"."pm_peak" + "sunday_2022"."evening" + "sunday_2022"."late"
) AS "link_load_22"
FROM "monday_2022"
JOIN "tuetothu_2022" ON "tuetothu_2022"."trip_id" = "monday_2022"."trip_id"
JOIN "friday_2022" ON "friday_2022"."trip_id" = "tuetothu_2022"."trip_id"
JOIN "saturday_2022" ON "saturday_2022"."trip_id" = "friday_2022"."trip_id"
JOIN "sunday_2022" ON "sunday_2022"."trip_id" = "saturday_2022"."trip_id"
GROUP BY "monday_2022"."trip_id";

-- sig_stations shortlist
-- add origin names
-- add destination names
-- combine origin and destination names

-- 2019 sig_stations link load
CREATE VIEW "sig_hub_2019" AS
SELECT * FROM (
    SELECT "trip_id", "org_id", "origin","lat" AS "org_lat", "long" AS "org_long" FROM (
        SELECT * FROM (
            SELECT "trip_id", "org_id", "name" AS "origin" FROM (
                SELECT * FROM "total_link_load_2019" 
                WHERE "dest_id" IN (
                    SELECT "id" FROM "sig_stations"))
            JOIN "stations" ON "stations"."id" = "org_id")
        NATURAL JOIN (
            SELECT "trip_id", "dest_id", "name" AS "destination", "link_load_19"  FROM (
                SELECT * FROM "total_link_load_2019" 
                WHERE "dest_id" IN (
                    SELECT "id" FROM "sig_stations"))
            JOIN "stations" ON "stations"."id" = "dest_id"))
    JOIN "coordinates" ON "coordinates"."station_id" = "org_id")
NATURAL JOIN (
    SELECT "trip_id", "dest_id", "destination", "lat" AS "dest_lat", "long" AS "dest_long", "link_load_19" FROM (
        SELECT * FROM (
            SELECT "trip_id", "org_id", "name" AS "origin" FROM (
                SELECT * FROM "total_link_load_2019" 
                WHERE "dest_id" IN (
                    SELECT "id" FROM "sig_stations"))
            JOIN "stations" ON "stations"."id" = "org_id")
        NATURAL JOIN (
            SELECT "trip_id", "dest_id", "name" AS "destination", "link_load_19"  FROM (
                SELECT * FROM "total_link_load_2019" 
                WHERE "dest_id" IN (
                    SELECT "id" FROM "sig_stations"))
            JOIN "stations" ON "stations"."id" = "dest_id"))
    JOIN "coordinates" ON "coordinates"."station_id" = "dest_id");

SELECT * FROM "sig_hub_2019";

-- 2022 sig_stations link load
CREATE VIEW "sig_hub_2022" AS
SELECT * FROM (
    SELECT "trip_id", "org_id", "origin", "lat" AS "org_lat", "long" AS "org_long" FROM (
        SELECT * FROM (
            SELECT "trip_id", "org_id", "name" AS "origin" FROM (
                SELECT * FROM "total_link_load_2022" 
                WHERE "dest_id" IN (
                    SELECT "id" FROM "sig_stations"))
            JOIN "stations" ON "stations"."id" = "org_id")
        NATURAL JOIN (
            SELECT "trip_id", "dest_id", "name" AS "destination", "link_load_22" FROM (
                SELECT * FROM "total_link_load_2022" 
                WHERE "dest_id" IN (
                    SELECT "id" FROM "sig_stations"))
            JOIN "stations" ON "stations"."id" = "dest_id"))
    JOIN "coordinates" ON "coordinates"."station_id" = "org_id")
NATURAL JOIN (
    SELECT "trip_id", "dest_id", "destination", "lat" AS "dest_lat", "long" AS "dest_long", "link_load_22" FROM (
        SELECT * FROM (
            SELECT "trip_id", "org_id", "name" AS "origin" FROM (
                SELECT * FROM "total_link_load_2022" 
                WHERE "dest_id" IN (
                    SELECT "id" FROM "sig_stations"))
            JOIN "stations" ON "stations"."id" = "org_id")
        NATURAL JOIN (
            SELECT "trip_id", "dest_id", "name" AS "destination", "link_load_22" FROM (
                SELECT * FROM "total_link_load_2022" 
                WHERE "dest_id" IN (
                    SELECT "id" FROM "sig_stations"))
            JOIN "stations" ON "stations"."id" = "dest_id"))
    JOIN "coordinates" ON "coordinates"."station_id" = "dest_id");

SELECT * FROM "sig_hub_2019"
NATURAL JOIN (
    SELECT * FROM "sig_hub_2022");

SELECT * FROM "sig_hub_2019"
NATURAL JOIN (
    SELECT * FROM "sig_hub_2022");


SELECT * FROM (
    SELECT "trip_id", "org_id", "origin", "dest_id", "destination", "link_load_19"
    FROM "sig_hub_2019")
NATURAL JOIN (
    SELECT "trip_id", "link_load_22"
    FROM "sig_hub_2022");

SELECT "destination", COUNT("destination") FROM "sig_hub_2022"
GROUP BY "destination";

CREATE VIEW "prop_change_by_trip" AS
SELECT "trip_id", "origin", "destination", "prop_19", "prop_22", ROUND("difference", 4) AS "round_diff" FROM (
    SELECT *, ("prop_22" - "prop_19") AS "difference" FROM (
        SELECT * FROM (
            SELECT *, (("link_load_19"/total_19) * 100) AS "prop_19" FROM (
                SELECT * FROM (
                    SELECT "trip_id", "org_id", "origin", "dest_id", "destination", "link_load_19"
                    FROM "sig_hub_2019"
                    ORDER BY "destination" ASC, "link_load_19" DESC)
                NATURAL JOIN (
                    SELECT "dest_id", "destination", SUM(link_load_19) AS "total_19"
                    FROM "sig_hub_2019"
                    GROUP BY "destination"))
            ORDER BY "destination" ASC, "prop_19" DESC)
        NATURAL JOIN (
            SELECT "trip_id", "link_load_22", "total_22", "prop_22" FROM (
                SELECT *, (("link_load_22"/total_22) * 100) AS "prop_22" FROM (
                    SELECT * FROM (
                        SELECT "trip_id", "org_id", "origin", "dest_id", "destination", "link_load_22"
                        FROM "sig_hub_2022"
                        ORDER BY "destination" ASC, "link_load_22" DESC)
                    NATURAL JOIN (
                        SELECT "dest_id", "destination", SUM(link_load_22) AS "total_22"
                        FROM "sig_hub_2022"
                        GROUP BY "destination"))
                ORDER BY "destination" ASC, "prop_22" DESC)))
ORDER BY "destination" ASC
);

-- Top 3 Proportion Decrease per Destination
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY "destination" ORDER BY "round_diff" ASC) AS "rank"
    FROM "prop_change_by_trip")
WHERE "rank" <= 3;
-- Top 3 Proportion Increase per Destination
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY "destination" ORDER BY "round_diff" DESC) AS "rank"
    FROM "prop_change_by_trip")
WHERE "rank" <= 3;


SELECT "inc_org", COUNT("inc_org") FROM (
    SELECT "destination", "origin" as "inc_org", "round_diff" AS "increase"
    FROM (
        SELECT * FROM (
            SELECT *, ROW_NUMBER() OVER (PARTITION BY "destination" ORDER BY "round_diff" DESC) AS "rank"
            FROM "prop_change_by_trip")
        WHERE "rank" <= 3))
GROUP BY "inc_org"
ORDER BY COUNT("inc_org") DESC;

SELECT "dec_org", COUNT("dec_org") FROM (
    SELECT "destination", "origin" AS "dec_org", "round_diff" AS "decline"
    FROM (
        SELECT * FROM (
            SELECT *, ROW_NUMBER() OVER (PARTITION BY "destination" ORDER BY "round_diff" ASC) AS "rank"
            FROM "prop_change_by_trip")
        WHERE "rank" <= 3)
    )
GROUP BY "dec_org" 
ORDER BY COUNT("dec_org") DESC;

SELECT * FROM "sig_stations";




SELECT "id", "origin" FROM (
    SELECT DISTINCT * FROM (
        SELECT DISTINCT("origin") FROM (
            SELECT * FROM (
                SELECT *, ROW_NUMBER() OVER (PARTITION BY "destination" ORDER BY "round_diff" DESC) AS "rank"
                FROM "prop_change_by_trip")
            WHERE "rank" <= 3
            UNION
            SELECT * FROM (
                SELECT *, ROW_NUMBER() OVER (PARTITION BY "destination" ORDER BY "round_diff" ASC) AS "rank"
                FROM "prop_change_by_trip")
            WHERE "rank" <= 3)
        UNION
        SELECT DISTINCT("destination") FROM (
            SELECT * FROM (
                SELECT *, ROW_NUMBER() OVER (PARTITION BY "destination" ORDER BY "round_diff" DESC) AS "rank"
                FROM "prop_change_by_trip")
            WHERE "rank" <= 3
            UNION
            SELECT * FROM (
                SELECT *, ROW_NUMBER() OVER (PARTITION BY "destination" ORDER BY "round_diff" ASC) AS "rank"
                FROM "prop_change_by_trip")
            WHERE "rank" <= 3)))
JOIN "stations" ON "stations"."name" = "origin";

SELECT * FROM "stations";
SELECT * FROM "coordinates";

SELECT "name" AS "station", "percentage_change" FROM (
    SELECT "total_weekly_exits_2019"."name", "total_weekly_exits_2019"."dest_id", 
    "total_weekly_exits_2019"."total_weekly_exits" AS "total_weekly_exits_19", 
    "total_weekly_exits_2022"."total_weekly_exits" AS "total_weekly_exits_22", 
    (("total_weekly_exits_2022"."total_weekly_exits" - "total_weekly_exits_2019"."total_weekly_exits") / "total_weekly_exits_2019"."total_weekly_exits") * 100 AS "percentage_change" 

    FROM "total_weekly_exits_2019"

    JOIN "total_weekly_exits_2022" ON "total_weekly_exits_2019"."dest_id" = "total_weekly_exits_2022"."dest_id"

    ORDER BY "percentage_change")
WHERE "name" IN 
    (
    SELECT "name" FROM "sig_stations"
    WHERE "id" IN (
        501, 513, 521, 524, 535, 536, 541, 553, 562, 574, 575, 577,
        590, 614, 625, 626, 629, 631, 634, 635, 637, 645, 665, 669,
        670, 674, 685, 697, 708, 728, 741, 746, 747, 761, 777)
);


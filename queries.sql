-- Total Weekly Exits 2019 by Destination
CREATE VIEW "total_weekly_exits_2019" AS
SELECT "name"  "montothu_2019"."dest_id" 
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
GROUP BY "montothu_2019"."dest_id";


-- Total Weekly Exits 2022 by Destination
CREATE VIEW "total_weekly_exits_2022" AS
SELECT "name"  "monday_2022"."dest_id" 
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


-- 2.1 Percentage Change in Traffic: 2019 vs 2022
-- Top 10 Stations with Most Percentage Increase
SELECT "total_weekly_exits_2019"."name", "total_weekly_exits_2019"."dest_id", "total_weekly_exits_2019"."total_weekly_exits" AS "total_weekly_exits_19", "total_weekly_exits_2022"."total_weekly_exits" AS "total_weekly_exits_22", (("total_weekly_exits_2022"."total_weekly_exits" - "total_weekly_exits_2019"."total_weekly_exits") / "total_weekly_exits_2019"."total_weekly_exits") * 100 AS "percentage_change" 
FROM "total_weekly_exits_2019"
JOIN "total_weekly_exits_2022" ON "total_weekly_exits_2019"."dest_id" = "total_weekly_exits_2022"."dest_id"
ORDER BY "percentage_change" DESC
LIMIT 10;


-- Top 10 Stations with Most Percentage Decline
SELECT "total_weekly_exits_2019"."name", "total_weekly_exits_2019"."dest_id", "total_weekly_exits_2019"."total_weekly_exits" AS "total_weekly_exits_19", "total_weekly_exits_2022"."total_weekly_exits" AS "total_weekly_exits_22", (("total_weekly_exits_2022"."total_weekly_exits" - "total_weekly_exits_2019"."total_weekly_exits") / "total_weekly_exits_2019"."total_weekly_exits") * 100 AS "percentage_change" 
FROM "total_weekly_exits_2019"
JOIN "total_weekly_exits_2022" ON "total_weekly_exits_2019"."dest_id" = "total_weekly_exits_2022"."dest_id"
ORDER BY "percentage_change" ASC
LIMIT 10;


-- 2.2 Top 20 Destinations by Total Weekly Exits

SELECT "rank_19", "rank_22", ("rank_19" - "rank_22") AS "change", "name" FROM ( 
    SELECT * FROM (
        -- 2019
        SELECT "name", ROW_NUMBER() OVER (ORDER BY "total_weekly_exits" DESC) AS "rank_19" 
        FROM "total_weekly_exits_2019"
        ORDER BY "total_weekly_exits" DESC)
    NATURAL JOIN (
        -- 2022 (without stations not in 2019 data)
        SELECT "name", ROW_NUMBER() OVER (ORDER BY "total_weekly_exits" DESC) AS "rank_22" 
        FROM "total_weekly_exits_2022"
        WHERE "dest_id" IN (
            SELECT "dest_id" FROM "total_weekly_exits_2019")
        ORDER BY "total_weekly_exits" DESC));


-- 2.3 Top 20 Most Absolute Rank Changes in Total Weekly Exits by Destination
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


-- 2.4 Top 3 Destinations by Origin

-- 2019 View
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

-- 2022 View
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

-- Top 3 Destinations by Origin 2019
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY "org_id" ORDER BY "total_weekly_exits" DESC) AS "rowrank"
    FROM "destbyorg_2019")
WHERE "rowrank" <= 3;

-- Top 3 Destinations by Origin 2022
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY "org_id" ORDER BY "total_weekly_exits" DESC) AS "rowrank"
    FROM "destbyorg_2022")
WHERE "rowrank" <= 3;


-- 2.5 Most Popular Destinations by Origin
-- 2019
SELECT "destination", COUNT("destination") AS "count"
FROM (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER (PARTITION BY "org_id" ORDER BY "total_weekly_exits" DESC) AS "rowrank"
        FROM "destbyorg_2019")
    WHERE "rowrank" = 1)
GROUP BY "destination"
ORDER BY COUNT("destination") DESC;

--2022
SELECT "destination", COUNT("destination") AS "count"
FROM (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER (PARTITION BY "org_id" ORDER BY "total_weekly_exits" DESC) AS "rowrank"
        FROM "destbyorg_2022")
    WHERE "rowrank" = 1)
GROUP BY "destination"
ORDER BY COUNT("destination")DESC;


-- 2.6 Changes in Most Preferred Destinations by Station [Rank]
-- 2019
SELECT "rank_19", "rank_22", ("rank_19" - "rank_22") AS "change", "destination"
FROM (
    SELECT * FROM (
        SELECT "destination", ROW_NUMBER() OVER (ORDER BY COUNT("destination") DESC) AS "rank_19"
        FROM (
            SELECT * FROM (
                SELECT *, ROW_NUMBER() OVER (PARTITION BY "org_id" ORDER BY "total_weekly_exits" DESC) AS "rowrank"
                FROM "destbyorg_2019")
            WHERE "rowrank" = 1)
        GROUP BY "destination"
        ORDER BY COUNT("destination") DESC)
    NATURAL JOIN (
    -- 2022
        SELECT "destination", ROW_NUMBER() OVER (ORDER BY COUNT("destination") DESC) AS "rank_22"
        FROM (
            SELECT * FROM (
                SELECT *, ROW_NUMBER() OVER (PARTITION BY "org_id" ORDER BY "total_weekly_exits" DESC) AS "rowrank"
                FROM "destbyorg_2022")
            WHERE "rowrank" = 1)
        GROUP BY "destination"
        ORDER BY COUNT("destination")DESC)
ORDER BY ("rank_19" - "rank_22") DESC);


-- 2.7 Shortlist

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


-- 3. Analysis
-- 3.1 Interactive Dashboard (Dashboard Made in Tableau)

-- Heatmaps
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


-- Networks
-- 2019
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

-- 2022
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


-- 3.2 Top 3 Proportional Increase and Decrease in Links by Destination
CREATE VIEW "prop_change_by_trip" AS
SELECT "trip_id", "org_id", "origin", "dest_id", "destination", "prop_19", "prop_22", ROUND("difference", 4) AS "round_diff" FROM (
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


-- 3.3 Change in Number of Links
SELECT *, ("links_22" - "links_19") AS "links_change" FROM (
    -- 2019
    SELECT "destination", COUNT("destination") AS "links_19" FROM "sig_hub_2019"
    GROUP BY "destination"
    ORDER BY "destination" ASC)
NATURAL JOIN (
    -- 2022
    SELECT "destination", COUNT("destination") AS "links_22" FROM "sig_hub_2022"
    GROUP BY "destination"
    ORDER BY "destination" ASC);


-- 3.4 Peak Traffic Hours

-- 2019
SELECT "name", "dest_id", "day", "time", MAX("value")
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
)
GROUP BY "name";

-- 2022
SELECT "name", "dest_id", "day", "time", MAX("value")
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
)
GROUP BY "name";

-- Changes in Concentration from 2019 to 2022 (Y/N) were Assessed Manually in MS Excel

-- 3.5 Sub-Regional Movement

-- List of All the Stations in Network Analysis (to Assign Region)
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

-- Regional Movements
SELECT "station_id", "region_id", "sub_region" 
FROM (
    SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY "destination" ORDER BY "round_diff" ASC) AS "rank"
    FROM "prop_change_by_trip")
WHERE "rank" <= 3 
)
JOIN "classify" ON "classify"."station_id" = 
JOIN "regions" ON "regions"."id" = "classify"."region_id";


SELECT "trip_id", "org_id", "region_id", "sub_region", "dest_id" FROM "classify"
JOIN "classify" ON "classify"."station_id" = "org_id"
JOIN "regions" ON "regions"."id" = "region_id";



-- Top 3 Proportion Decrease per Destination
CREATE VIEW "links_decrease" AS
SELECT "from"|| '-' ||"to" AS "link_name" FROM (
    SELECT "trip_id", "org_id", "sub_region" AS "from" FROM (
        SELECT * FROM (
            SELECT *, ROW_NUMBER() OVER (PARTITION BY "destination" ORDER BY "round_diff" ASC) AS "rank"
            FROM "prop_change_by_trip")
        WHERE "rank" <= 3)
    JOIN "classify" ON "classify"."station_id" = "org_id"
    JOIN "regions" ON "regions"."id" = "classify"."region_id")
NATURAL JOIN (
    SELECT "trip_id", "dest_id", "sub_region" AS "to" FROM (
        SELECT * FROM (
            SELECT *, ROW_NUMBER() OVER (PARTITION BY "destination" ORDER BY "round_diff" ASC) AS "rank"
            FROM "prop_change_by_trip")
        WHERE "rank" <= 3)
    JOIN "classify" ON "classify"."station_id" = "dest_id"
    JOIN "regions" ON "regions"."id" = "classify"."region_id");

-- Decrease Table
SELECT "link_name", COUNT("link_name") AS "decrease" FROM "links_decrease"
GROUP BY "link_name"
ORDER BY "decrease" DESC;

-- Top 3 Proportion Increase per Destination
CREATE VIEW "links_increase" AS
SELECT "from"|| '-' ||"to" AS "link_name" FROM (
    SELECT "trip_id", "org_id", "sub_region" AS "from" FROM (
        SELECT * FROM (
            SELECT *, ROW_NUMBER() OVER (PARTITION BY "destination" ORDER BY "round_diff" DESC) AS "rank"
            FROM "prop_change_by_trip")
        WHERE "rank" <= 3)
    JOIN "classify" ON "classify"."station_id" = "org_id"
    JOIN "regions" ON "regions"."id" = "classify"."region_id")
NATURAL JOIN (
    SELECT "trip_id", "dest_id", "sub_region" AS "to" FROM (
        SELECT * FROM (
            SELECT *, ROW_NUMBER() OVER (PARTITION BY "destination" ORDER BY "round_diff" DESC) AS "rank"
            FROM "prop_change_by_trip")
        WHERE "rank" <= 3)
    JOIN "classify" ON "classify"."station_id" = "dest_id"
    JOIN "regions" ON "regions"."id" = "classify"."region_id");

-- Increase Table
SELECT "link_name", COUNT("link_name") AS "increase" FROM "links_increase"
GROUP BY "link_name"
ORDER BY "increase" DESC;

-- stations
CREATE TABLE "stations" (
    "id" INTEGER,
    "name" TEXT,
    PRIMARY KEY ("id")
);

-- coordinates
CREATE TABLE "coordinates" (
    "station_id" INTEGER,
    "lat" REAL,
    "long" REAL,
    FOREIGN KEY ("station_id") REFERENCES "stations"("id")
);

-- friday_2019
CREATE TABLE "friday_2019" (
    "trip_id" INTEGER,
    "org_id" INTEGER,
    "dest_id" INTEGER,
    "morning" REAL,
    "am_peak" REAL,
    "midday" REAL,
    "pm_peak" REAL,
    "evening" REAL,
    "late" REAL,
    PRIMARY KEY ("trip_id"),
    FOREIGN KEY ("org_id") REFERENCES "stations"("id"),
    FOREIGN KEY ("dest_id") REFERENCES "stations"("id")
);

-- montothu_2019
CREATE TABLE "montothu_2019" (
    "trip_id" INTEGER,
    "org_id" INTEGER,
    "dest_id" INTEGER,
    "morning" REAL,
    "am_peak" REAL,
    "midday" REAL,
    "pm_peak" REAL,
    "evening" REAL,
    "late" REAL,
    PRIMARY KEY ("trip_id"),
    FOREIGN KEY ("org_id") REFERENCES "stations"("id"),
    FOREIGN KEY ("dest_id") REFERENCES "stations"("id")
);

-- saturday_2019
CREATE TABLE "saturday_2019" (
    "trip_id" INTEGER,
    "org_id" INTEGER,
    "dest_id" INTEGER,
    "morning" REAL,
    "am_peak" REAL,
    "midday" REAL,
    "pm_peak" REAL,
    "evening" REAL,
    "late" REAL,
    PRIMARY KEY ("trip_id"),
    FOREIGN KEY ("org_id") REFERENCES "stations"("id"),
    FOREIGN KEY ("dest_id") REFERENCES "stations"("id")
);

-- sunday_2019
CREATE TABLE "sunday_2019" (
    "trip_id" INTEGER,
    "org_id" INTEGER,
    "dest_id" INTEGER,
    "morning" REAL,
    "am_peak" REAL,
    "midday" REAL,
    "pm_peak" REAL,
    "evening" REAL,
    "late" REAL,
    PRIMARY KEY ("trip_id"),
    FOREIGN KEY ("org_id") REFERENCES "stations"("id"),
    FOREIGN KEY ("dest_id") REFERENCES "stations"("id")
);

-- friday_2022
CREATE TABLE "friday_2022" (
    "trip_id" INTEGER,
    "org_id" INTEGER,
    "dest_id" INTEGER,
    "morning" REAL,
    "am_peak" REAL,
    "midday" REAL,
    "pm_peak" REAL,
    "evening" REAL,
    "late" REAL,
    PRIMARY KEY ("trip_id"),
    FOREIGN KEY ("org_id") REFERENCES "stations"("id"),
    FOREIGN KEY ("dest_id") REFERENCES "stations"("id")
);

-- monday_2022
CREATE TABLE "monday_2022" (
    "trip_id" INTEGER,
    "org_id" INTEGER,
    "dest_id" INTEGER,
    "morning" REAL,
    "am_peak" REAL,
    "midday" REAL,
    "pm_peak" REAL,
    "evening" REAL,
    "late" REAL,
    PRIMARY KEY ("trip_id"),
    FOREIGN KEY ("org_id") REFERENCES "stations"("id"),
    FOREIGN KEY ("dest_id") REFERENCES "stations"("id")
);

-- saturday_2022
CREATE TABLE "saturday_2022" (
    "trip_id" INTEGER,
    "org_id" INTEGER,
    "dest_id" INTEGER,
    "morning" REAL,
    "am_peak" REAL,
    "midday" REAL,
    "pm_peak" REAL,
    "evening" REAL,
    "late" REAL,
    PRIMARY KEY ("trip_id"),
    FOREIGN KEY ("org_id") REFERENCES "stations"("id"),
    FOREIGN KEY ("dest_id") REFERENCES "stations"("id")
);

-- sunday_2022
CREATE TABLE "sunday_2022" (
    "trip_id" INTEGER,
    "org_id" INTEGER,
    "dest_id" INTEGER,
    "morning" REAL,
    "am_peak" REAL,
    "midday" REAL,
    "pm_peak" REAL,
    "evening" REAL,
    "late" REAL,
    PRIMARY KEY ("trip_id"),
    FOREIGN KEY ("org_id") REFERENCES "stations"("id"),
    FOREIGN KEY ("dest_id") REFERENCES "stations"("id")
);

-- tuetothu_2022
CREATE TABLE "tuetothu_2022" (
    "trip_id" INTEGER,
    "org_id" INTEGER,
    "dest_id" INTEGER,
    "morning" REAL,
    "am_peak" REAL,
    "midday" REAL,
    "pm_peak" REAL,
    "evening" REAL,
    "late" REAL,
    PRIMARY KEY ("trip_id"),
    FOREIGN KEY ("org_id") REFERENCES "stations"("id"),
    FOREIGN KEY ("dest_id") REFERENCES "stations"("id")
);

-- boroughs_and_sub_regions
CREATE TABLE "regions" (
    "id" INTEGER,
    "borough" "TEXT",
    "sub_region" "TEXT",
    PRIMARY KEY ("id")
);

-- area_classification
CREATE TABLE "classify" (
    "station_id" INTEGER,
    "region_id" INTEGER,
    FOREIGN KEY ("station_id") REFERENCES "stations"("id"),
    FOREIGN KEY ("region_id") REFERENCES "regions"("id")
);
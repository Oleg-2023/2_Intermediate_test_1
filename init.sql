CREATE TABLE public.austin_bikeshare_stations (
	latitude numeric NULL,
	"location" varchar NULL,	
	longitude numeric NULL,
	"name" varchar NULL,
	station_id serial4 NOT NULL,
	status varchar NULL,
	CONSTRAINT austin_bikeshare_stations_pk PRIMARY KEY (station_id)
);

CREATE TABLE IF NOT EXISTS public.austin_bikeshare_trips (
	bikeid int4 NULL,
	checkout_time time NULL,
	duration_minutes smallint NULL,
	end_station_id int4 NULL,
	end_station_name varchar NULL,
	"month" smallint NULL,
	start_station_id int4 NULL,
	start_station_name varchar NULL,
	start_time timestamp NULL,
	subscriber_type varchar NULL,
	trip_id bigint NOT NULL,
	"year" smallint NULL,
	CONSTRAINT austin_bikeshare_trips_pk PRIMARY KEY (trip_id)
);
-- public.austin_bikeshare_trips foreign keys
ALTER TABLE public.austin_bikeshare_trips ADD CONSTRAINT austin_bikeshare_trips_fk FOREIGN KEY (end_station_id) REFERENCES public.austin_bikeshare_stations(station_id);
ALTER TABLE public.austin_bikeshare_trips ADD CONSTRAINT austin_bikeshare_trips_fk_1 FOREIGN KEY (start_station_id) REFERENCES public.austin_bikeshare_stations(station_id);


-- intermediate table to convert same field
CREATE TABLE IF NOT EXISTS public.intermediate_trips (
	bikeid float NULL,
	checkout_time time NULL,
	duration_minutes smallint NULL,
	end_station_id float NULL,
	end_station_name varchar NULL,
	"month" float NULL,
	start_station_id float NULL,
	start_station_name varchar NULL,
	start_time timestamp NULL,
	subscriber_type varchar NULL,
	trip_id bigint NOT NULL,
	"year" float NULL
);

COPY public.austin_bikeshare_stations (
	latitude, 
	"location",
	longitude,
	"name", 
	station_id,
	status
)
FROM '/var/lib/postgresql/csv/austin_bikeshare_stations.csv'
DELIMITER ','
CSV HEADER;

COPY public.intermediate_trips (
	bikeid,
	checkout_time,
	duration_minutes,
	end_station_id,
	end_station_name,
	"month",
	start_station_id,
	start_station_name,
	start_time,
	subscriber_type,
	trip_id,
	"year"
)
FROM '/var/lib/postgresql/csv/austin_bikeshare_trips.csv'
DELIMITER ','
CSV HEADER;

-- convert data types
INSERT INTO public.austin_bikeshare_trips (
    bikeid,
	checkout_time,
	duration_minutes,
	end_station_id,
	end_station_name,
	"month",
	start_station_id,
	start_station_name,
	start_time,
	subscriber_type,
	trip_id,
	"year"
    )
	SELECT 
	  bikeid::int4,
	  checkout_time,
	  duration_minutes,
	  end_station_id::int4,
	  end_station_name,
	  "month"::smallint,
	  start_station_id::int4,
	  start_station_name,
	  start_time,
	  subscriber_type,
	  trip_id,
	  "year"::smallint
	FROM public.intermediate_trips;

DROP TABLE public.intermediate_trips;

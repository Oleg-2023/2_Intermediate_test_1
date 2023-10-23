CREATE TABLE public.austin_bikeshare_stations (
	station_id serial4 NOT NULL,
	"name" varchar NULL,
	status varchar NULL,
	latitude numeric NULL,
	longitude numeric NULL,
	"location" point NULL,
	CONSTRAINT austin_bikeshare_stations_pk PRIMARY KEY (station_id)
);


CREATE TABLE public.austin_bikeshare_trips (
	trip_id bigserial NOT NULL,
	bikeid int4 NULL,
	checkout_time time NULL,
	duration_minutes int4 NULL,
	end_station_id int4 NULL,
	end_station_name varchar NULL,
	"month" int4 NULL,
	start_station_id int4 NULL,
	start_station_name varchar NULL,
	start_time timestamp NULL,
	subscriber_type varchar NULL,
	"year" float4 NULL,
	CONSTRAINT austin_bikeshare_trips_pk PRIMARY KEY (trip_id)
);

-- public.austin_bikeshare_trips foreign keys

ALTER TABLE public.austin_bikeshare_trips ADD CONSTRAINT austin_bikeshare_trips_fk FOREIGN KEY (end_station_id) REFERENCES public.austin_bikeshare_stations(station_id);
ALTER TABLE public.austin_bikeshare_trips ADD CONSTRAINT austin_bikeshare_trips_fk_1 FOREIGN KEY (start_station_id) REFERENCES public.austin_bikeshare_stations(station_id);
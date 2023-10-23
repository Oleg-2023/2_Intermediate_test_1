
/*  
 * Принимаем, что поездка имеет ненулевую продолжительность 
 */
WITH years (tbl_year) AS (
  -- указываем актуальный год из диапазона 2013-2017
  VALUES (2016)
),
start_station AS (SELECT 
    -- уникальный идентификатор станции
    s.station_id,
	--количество начавшихся поездок в данной станции за данных год
	COUNT(t.trip_id) AS count_started_trips,  
    --средняя продолжительность поездок начавшихся в данной станции в данном году
	AVG(t.duration_minutes) AS avg_started_trip 
FROM austin_bikeshare_trips t
    -- Исключаем пустые и некоректные значения в стартовых станциях
    INNER JOIN austin_bikeshare_stations s ON t.start_station_id = s.station_id,
    years
-- исключаем поездки в другие года и в никуда
WHERE date_part('year', t.start_time) = years.tbl_year AND 
      t.duration_minutes > 0  
GROUP BY s.station_id
),
end_station AS (SELECT 
    -- уникальный идентификатор станции
    s.station_id,
	--количество начавшихся поездок в данной станции за данных год
	COUNT(t.trip_id) AS count_ended_trips,  
    --средняя продолжительность поездок начавшихся в данной станции в данном году
	AVG(t.duration_minutes) AS avg_ended_trip 
FROM austin_bikeshare_trips t
    -- Исключаем пустые и некорректные значения в конечных станциях
    INNER JOIN austin_bikeshare_stations s ON t.end_station_id = s.station_id,
    years
-- исключаем поездки в другие года и из ниоткуда
WHERE  date_part('year', t.start_time) = years.tbl_year AND
       t.duration_minutes > 0 
GROUP BY s.station_id
)
SELECT 
  s.station_id,
  st_start.count_started_trips,
  st_end.count_ended_trips,
  NULLIF(st_start.count_started_trips, 0) + NULLIF(st_end.count_ended_trips, 0) AS count_all_trips,
  st_start.avg_started_trip::NUMERIC(5,2),
  st_end.avg_ended_trip::NUMERIC(5,2)
FROM austin_bikeshare_stations s
  -- Теоретически могут быть станции где только начинаются или заканчиваются поездки 
  LEFT OUTER JOIN start_station st_start ON st_start.station_id=s.station_id 
  LEFT OUTER JOIN end_station st_end ON st_end.station_id=s.station_id
-- только астивные станции
WHERE s.status = 'active' AND 
      -- исключаем незадействованные станции
      st_start.count_started_trips IS NOT NULL AND 
      st_end.count_ended_trips IS NOT NULL 
ORDER BY st_start.avg_started_trip DESC 

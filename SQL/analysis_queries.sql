-- ANALYSIS

-- 1. 15.4x growth since 1965 + doubling cycle
SELECT 
  (SELECT primary_energy_twh FROM energy_india_clean WHERE year = 2019) /
  (SELECT primary_energy_twh FROM energy_india_clean WHERE year = 1965) AS growth_multiple;
  
-- 2. Solar scaling since 2010
SELECT
  (SELECT elec_solar_twh FROM energy_india_clean WHERE year = 2019) /
  (SELECT elec_solar_twh FROM energy_india_clean WHERE year = 2010) AS solar_growth_multiple;
  
-- 3. CO2 intensity trend - THE GRAPH SHALL BE PLOTTED BETWEEN co2_per_kwh and year; no query required as such 

-- 4. HHI (Herfindahl-Hirschman Index)
SELECT year,
  ROUND(POWER(coal_pct_elec,2) + POWER(gas_pct_elec,2) + POWER(hydro_pct_elec,2) +
        POWER(solar_pct_elec,2) + POWER(wind_pct_elec,2) + POWER(oil_pct_elec,2) +
        POWER(nuclear_pct_elec,2) + POWER(other_renew_pct_elec,2), 0) AS hhi
FROM energy_india_clean
WHERE electricity_generation_twh IS NOT NULL
ORDER BY year;

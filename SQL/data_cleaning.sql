-- CHECK IF ALL THE DATA IS LOADED
SELECT MIN(year), MAX(year) FROM staging_energy_raw;

-- ENSURE NO DUPLICATES

SELECT year, COUNT(*) 
FROM india_energy.staging_energy_raw 
GROUP BY year 
HAVING COUNT(*) > 1;

--  DATA QUALITY LOG 
USE india_energy;
CREATE TABLE data_quality_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    year INT,
    column_name VARCHAR(100),
    issue_type VARCHAR(50),
    description VARCHAR(255)
);

-- (A) Pre-1985 electricity mix gap
SELECT COUNT(*) AS null_years
FROM staging_energy_raw
WHERE electricity_generation_twh IS NULL;

-- (B) Zero vs NULL — solar/wind pre-1995
SELECT year, solar_consumption_ej, wind_consumption_ej
FROM staging_energy_raw
WHERE year < 1995;

-- (C) Duplicate nuclear % column check
SELECT COUNT(*) AS mismatches
FROM staging_energy_raw
WHERE NOT (nuclear_pct_elec <=> nuclear_pct_elec_dup);

--  (D) Consumption-vs-primary-energy unit cross-check
SELECT year,
       primary_energy_twh,
       ROUND((oil_consumption_ej + gas_consumption_ej + coal_consumption_ej +
              solar_consumption_ej + hydro_consumption_ej + nuclear_consumption_ej +
              wind_consumption_ej + geo_biomass_other_ej) * 277.7778, 2) AS reconstructed_twh,
       ROUND(primary_energy_twh -
             (oil_consumption_ej + gas_consumption_ej + coal_consumption_ej +
              solar_consumption_ej + hydro_consumption_ej + nuclear_consumption_ej +
              wind_consumption_ej + geo_biomass_other_ej) * 277.7778, 2) AS diff_twh
FROM staging_energy_raw
ORDER BY ABS(diff_twh) DESC
LIMIT 10;

-- (E) YoY change recalculation vs reported
SELECT year,
       annual_change_primary_energy_pct AS reported_pct,
       ROUND(((primary_energy_twh - LAG(primary_energy_twh) OVER (ORDER BY year))
              / LAG(primary_energy_twh) OVER (ORDER BY year)) * 100, 2) AS recalculated_pct,
       ROUND(annual_change_primary_energy_pct -
             ((primary_energy_twh - LAG(primary_energy_twh) OVER (ORDER BY year))
              / LAG(primary_energy_twh) OVER (ORDER BY year)) * 100, 2) AS diff
FROM staging_energy_raw
ORDER BY ABS(diff) DESC
LIMIT 10;

-- (F) Sparse column counts
SELECT
  SUM(CASE WHEN clean_cooking_access_pct IS NULL THEN 1 ELSE 0 END) AS null_clean_cooking,
  SUM(CASE WHEN access_electricity_pct IS NULL THEN 1 ELSE 0 END) AS null_access_elec
FROM staging_energy_raw;

-- (G) Biofuels gap
SELECT COUNT(*) AS null_biofuels_pre_2000
FROM staging_energy_raw
WHERE biofuels_twh IS NULL AND year < 2000;


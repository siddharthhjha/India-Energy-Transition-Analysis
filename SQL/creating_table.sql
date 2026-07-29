-- The dataset was uploaded to the SQL Workbench using the import data wizard and the tranformations are thus perfomed

 CREATE TABLE energy_india_clean AS
SELECT
    year,
    oil_consumption_ej AS oil_consumption_twh,
    gas_consumption_ej AS gas_consumption_twh,
    coal_consumption_ej AS coal_consumption_twh,
    solar_consumption_ej AS solar_consumption_twh,
    hydro_consumption_ej AS hydro_consumption_twh,
    nuclear_consumption_ej AS nuclear_consumption_twh,
    wind_consumption_ej AS wind_consumption_twh,
    geo_biomass_other_ej AS other_consumption_twh,
    primary_energy_twh,
    electricity_generation_twh,
    elec_coal_twh, elec_gas_twh, elec_hydro_twh, elec_solar_twh,
    elec_wind_twh, elec_oil_twh, elec_nuclear_twh, elec_other_renew_twh,
    coal_pct_elec, gas_pct_elec, hydro_pct_elec, solar_pct_elec,
    wind_pct_elec, oil_pct_elec, nuclear_pct_elec, other_renew_pct_elec,
    co2_per_kwh,
    energy_per_capita_kwh
FROM staging_energy_raw;
-- renamed _ej columns to _twh to reflect the real unit (mislabeled in source)
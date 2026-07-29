"""
Loads EnergyScenario.csv into the staging_energy_raw table in MySQL.
Handles NULLs explicitly so blank cells stay NULL (not 0.00).

Before running:
  pip install mysql-connector-python pandas

Update the DB_CONFIG block below with your actual MySQL credentials.
"""

import pandas as pd
import mysql.connector
import math

# ---- 1. UPDATE THESE ----
CSV_PATH = "EnergyScenario.csv"   # path to your CSV file
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "7477",
    "database": "india_energy",
}
# --------------------------

# Column order must match the CREATE TABLE statement for staging_energy_raw
COLUMNS = [
    "row_id", "year", "entity", "code",
    "oil_consumption_ej", "gas_consumption_ej", "coal_consumption_ej",
    "solar_consumption_ej", "hydro_consumption_ej", "nuclear_consumption_ej",
    "wind_consumption_ej", "geo_biomass_other_ej", "biofuels_twh",
    "clean_cooking_access_pct", "annual_change_primary_energy_pct", "co2_per_kwh",
    "electricity_generation_twh", "elec_coal_twh", "elec_gas_twh", "elec_hydro_twh",
    "elec_other_renew_twh", "elec_solar_twh", "elec_oil_twh", "elec_wind_twh",
    "elec_nuclear_twh", "energy_per_gdp_kwh", "fossil_pct_subenergy",
    "lowcarbon_pct_subenergy", "nuclear_pct_subenergy", "per_capita_elec_kwh",
    "energy_per_capita_kwh", "primary_energy_twh", "coal_pct_elec", "gas_pct_elec",
    "hydro_pct_elec", "solar_pct_elec", "wind_pct_elec", "oil_pct_elec",
    "nuclear_pct_elec", "other_renew_pct_elec", "fossil_pct_elec",
    "lowcarbon_pct_elec", "nuclear_pct_elec_dup", "renewables_pct_elec",
    "access_electricity_pct",
]

def clean_value(v):
    """Convert pandas NaN to Python None so MySQL stores true NULL."""
    if v is None:
        return None
    if isinstance(v, float) and math.isnan(v):
        return None
    return v

def main():
    df = pd.read_csv(CSV_PATH, index_col=0)
    df.insert(0, "row_id", range(len(df)))  # replicate original unnamed index column

    if len(df.columns) != len(COLUMNS):
        print(f"WARNING: CSV has {len(df.columns)} columns, expected {len(COLUMNS)}.")
        print("CSV columns:", list(df.columns))
        return

    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()

    placeholders = ", ".join(["%s"] * len(COLUMNS))
    col_list = ", ".join(COLUMNS)
    insert_sql = f"INSERT INTO staging_energy_raw ({col_list}) VALUES ({placeholders})"

    rows = [tuple(clean_value(v) for v in row) for row in df.itertuples(index=False, name=None)]

    cursor.executemany(insert_sql, rows)
    conn.commit()

    print(f"Inserted {cursor.rowcount} rows.")
    cursor.execute("SELECT COUNT(*) FROM staging_energy_raw")
    print("Total rows now in table:", cursor.fetchone()[0])

    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()

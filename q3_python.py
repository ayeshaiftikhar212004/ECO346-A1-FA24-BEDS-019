
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os

person = pd.read_csv("data/pslm_person_subset.csv")
household = pd.read_csv("data/pslm_hh_subset.csv")

hh_info = household[["hhid", "hhweight", "prov_code", "urban_rural"]]
data = person.merge(hh_info, on="hhid", how="left")

earners = data[
    (data["prov_code"] == 3) &
    (data["urban_rural"] == 2) &
    (data["age"] >= 15) &
    (data["age"] <= 64) &
    (data["earn_annual"] > 0)
].copy()

earners["age_band"] = (
    ((earners["age"] - 15) // 5) * 5 + 15
).astype(int)

earners["age_band"] = earners["age_band"].astype(str) + "-" + (
    earners["age_band"] + 4
).astype(str)

results = earners.groupby("age_band").apply(
    lambda g: pd.Series({
        "Number of earners": len(g),
        "Weighted mean (Rs)": round(
            (g["earn_annual"] * g["hhweight"]).sum() /
            g["hhweight"].sum()
        )
    }),
    include_groups=False
).reset_index()

results.to_csv("figures/age_band_python.csv", index=False)
print(results.to_string(index=False))

midpoints = np.arange(17, 63, 5)
fig, ax = plt.subplots(figsize=(10, 6))

jitter = np.random.uniform(-0.4, 0.4, len(earners))
ax.scatter(
    earners["age"] + jitter, earners["earn_annual"],
    alpha=0.15, s=10
)

ax.plot(midpoints, results["Weighted mean (Rs)"], marker="o")
ax.set_yscale("log")
ax.set_ylim(10000, 10000000)
ax.set_xlim(15, 65)
ax.set_xticks(range(15, 66, 5))
ax.set_xlabel("Age (years)")
ax.set_ylabel("Annual earnings (Rs, log scale)")
ax.set_title("Annual Earnings by Age — Urban Sindh")
ax.grid(True, alpha=0.2)

plt.tight_layout()
plt.savefig("figures/q3_python.svg", format="svg", bbox_inches="tight")
plt.close()

print("Python table and figure saved.")

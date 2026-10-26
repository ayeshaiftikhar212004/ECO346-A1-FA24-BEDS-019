# ECO346 Assignment 1 — FA24-BEDS-019

## Variant
Variant 3: Urban Sindh.

## Data
Source: PSLM 2019–20 person and household subsets.
The person and household files are merged using `hhid`.
The sample includes Urban Sindh residents aged 15–64 with positive annual earnings.
All weighted statistics use `hhweight`.

## Sample
Number of earners: 2644
Missing household weights: 0
Missing ages: 0
Missing annual earnings: 0

## Q2: Earnings distribution
- Weighted median: Rs 264,000
- Unweighted median: Rs 252,000
- Weighted 10th percentile: Rs 120,000
- Weighted 90th percentile: Rs 696,000
- P90/P10 ratio: 5.80

Figure: `figures/q2_histogram.svg`

## Q3: Earnings by age
| Age band | Earners | Weighted mean earnings (Rs) |
|---|---:|---:|
| 15–19 | 160 | 192523 |
| 20–24 | 296 | 222948 |
| 25–29 | 398 | 303154 |
| 30–34 | 396 | 379254 |
| 35–39 | 359 | 360221 |
| 40–44 | 344 | 446533 |
| 45–49 | 250 | 431697 |
| 50–54 | 212 | 530773 |
| 55–59 | 157 | 542400 |
| 60–64 | 72 | 414262 |

The highest weighted mean is in the 55–59 age band (Rs 542,400).

Figure: `figures/q3_earnings_by_age.svg`

## Q4: Redesign
The default scatter plot is saved as `figures/default.svg`.
The redesigned age graph uses transparency to reduce overplotting, a logarithmic earnings axis to show a wide range, and weighted age-band means to reveal the pattern across ages. The redesign makes the main trend easier to see but hides some of the raw-point detail shown in the default plot.

## Q5: Python comparison
The weighted means in Python match the R results to the nearest rupee.
Python table: `figures/age_band_python.csv`
Python graph: `figures/q3_python.svg`

## Reproduction
Run the R scripts in `scripts/` to reproduce the figures. Python was used to independently calculate the age-band means and draw the comparison figure.


## Q2: Interpretation
Annual earnings vary considerably across earners in Urban Sindh. The weighted median is Rs 264,000, while the 90th percentile is Rs 696,000 and the 10th percentile is Rs 120,000. The 90th percentile is 5.80 times the 10th percentile, indicating a substantial earnings gap within this sample.

## Q3: Interpretation and limitation
Weighted mean earnings generally rise across age bands, although the pattern is not perfectly steady. The highest weighted mean is Rs 542,400 for ages 55–59. The mean for ages 45–49 is higher than for ages 25–29. However, this is a cross-sectional survey, so it cannot show how the earnings of the same individuals change as they grow older.

## Q5: Python comparison
Python independently calculates the weighted mean earnings for each five-year age band using the same sample and household weights as R. The results should be compared after rounding to the nearest rupee. Python and R can differ in plotting defaults, so axis limits, labels, and scales were explicitly set for the comparison figure.

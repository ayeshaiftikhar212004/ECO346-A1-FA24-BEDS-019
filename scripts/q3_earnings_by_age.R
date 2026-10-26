library(ggplot2)

person <- read.csv("data/pslm_person_subset.csv")
household <- read.csv("data/pslm_hh_subset.csv")

hh_info <- household[, c("hhid", "hhweight", "prov_code", "urban_rural")]
data <- merge(person, hh_info, by = "hhid", all.x = TRUE)

earners <- subset(
  data,
  prov_code == 3 & urban_rural == 2 &
  age >= 15 & age <= 64 & earn_annual > 0
)

earners$age_band <- cut(
  earners$age,
  breaks = seq(15, 65, by = 5),
  right = FALSE,
  labels = c("15-19", "20-24", "25-29", "30-34", "35-39",
             "40-44", "45-49", "50-54", "55-59", "60-64")
)

bands <- aggregate(
  cbind(earn_annual, hhweight) ~ age_band,
  data = earners,
  FUN = sum
)

bands$count <- as.vector(table(earners$age_band))
bands$weighted_mean <- aggregate(
  earn_annual * hhweight ~ age_band,
  data = earners,
  FUN = sum
)[, 2] / bands$hhweight

bands$midpoint <- seq(17, 62, by = 5)
bands$thin <- bands$count < 30

p3 <- ggplot(earners, aes(x = age, y = earn_annual)) +
  geom_point(
    position = position_jitter(width = 0.4, height = 0),
    alpha = 0.15, size = 1
  ) +
  geom_line(
    data = bands,
    aes(x = midpoint, y = weighted_mean, group = 1),
    inherit.aes = FALSE
  ) +
  geom_point(
    data = bands,
    aes(x = midpoint, y = weighted_mean, shape = thin),
    inherit.aes = FALSE, size = 3
  ) +
  scale_shape_manual(values = c("FALSE" = 16, "TRUE" = 1)) +
  scale_y_log10(
    limits = c(10000, 10000000),
    breaks = c(10000, 100000, 1000000, 10000000)
  ) +
  scale_x_continuous(breaks = seq(15, 65, by = 5)) +
  labs(
    title = "Annual Earnings by Age: Urban Sindh",
    x = "Age (years)",
    y = "Annual earnings (rupees, logarithmic scale)",
    caption = "Source: PSLM 2019–20. Urban Sindh earners aged 15–64 with positive annual earnings; weighted means use household weights. Hollow markers indicate bands with fewer than 30 earners."
  ) +
  theme_minimal()

write.csv(
  bands[, c("age_band", "count", "weighted_mean")],
  "figures/age_band_r.csv",
  row.names = FALSE
)

svg("figures/q3_earnings_by_age.svg", width = 10, height = 6)
print(p3)
dev.off()

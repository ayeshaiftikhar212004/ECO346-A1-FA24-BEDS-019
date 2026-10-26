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

weighted_quantile <- function(x, w, p) {
  order_x <- order(x)
  x <- x[order_x]
  w <- w[order_x]
  cumulative_weight <- cumsum(w) / sum(w)
  x[which(cumulative_weight >= p)[1]]
}

weighted_median <- weighted_quantile(earners$earn_annual, earners$hhweight, 0.50)
weighted_p90 <- weighted_quantile(earners$earn_annual, earners$hhweight, 0.90)

earners <- subset(earners, earn_annual >= 10000 & earn_annual <= 10000000)
earners$log_earnings <- log10(earners$earn_annual)

p <- ggplot(earners, aes(x = log_earnings, weight = hhweight)) +
  geom_histogram(
    aes(y = after_stat(count / sum(count) / 0.1)),
    binwidth = 0.1, boundary = 4,
    fill = "steelblue", color = "white"
  ) +
  geom_vline(xintercept = log10(weighted_median), linetype = "dashed", color = "red") +
  geom_vline(xintercept = log10(weighted_p90), linetype = "dashed", color = "darkgreen") +
  scale_x_continuous(
    breaks = 4:7,
    labels = c("Rs 10,000", "Rs 100,000", "Rs 1,000,000", "Rs 10,000,000"),
    limits = c(4, 7)
  ) +
  labs(
    title = "Distribution of Annual Earnings: Urban Sindh",
    x = "Annual earnings (rupees, logarithmic scale)",
    y = "Weighted density per log10 unit",
    caption = "Source: PSLM 2019–20. Urban Sindh earners aged 15–64 with positive annual earnings. Weighted by household weight."
  ) +
  theme_minimal()

svg("figures/q2_histogram.svg", width = 10, height = 6)
print(p)
dev.off()

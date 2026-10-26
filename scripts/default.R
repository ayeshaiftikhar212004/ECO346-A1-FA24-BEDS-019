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

default_plot <- ggplot(earners, aes(x = age, y = earn_annual)) +
  geom_point()

svg("figures/default.svg", width = 7, height = 5)
print(default_plot)
dev.off()

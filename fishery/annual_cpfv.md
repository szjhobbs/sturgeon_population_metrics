
-----

-----

TODO: complete narative

``` r
source(file = "presentations/.base-par.R")
```

``` r
library(sportfish)
# library(package)
```

``` r
# the data directory for bay study
data_dir <- "data/cpfv"

# list.files(path = data_dir, pattern = ".rds")

# CPFV <- new.env()
# ReadRDSFiles(fileDir = data_dir, envir = CPFV)

SFESuccessful <- readRDS(file = file.path(data_dir, "SFESuccessful.rds"))

# clean up
rm(data_dir)
```

``` r
rng_vars <- lapply(SFESuccessful, FUN = range)
```

``` r
# NOTE: lines with `par(xaxp = c(rng_vars[["Year"]], 38))` susceptible to work
# not as intended as more data come on-line. The `38` needs to be automated so
# proper grid lines are drawn with continued addition of annual data

par(oma = c(4, 1, 1, 1))
# par(oma = c(8, 1, 1, 1))
par(mar = c(0.25, 4.1, 0.25, 1), lend = 1)

mat <- matrix(data = c(1:3), nrow = 3, ncol = 1, byrow = TRUE)

layout(mat = mat, heights = c(2, 2, 2))

# cpfv catch per angler-hour (CPUE) ---------------------------------------

plot(
  x = rng_vars[["Year"]],
  y = rng_vars[["CPUE"]],
  type = "n",
  xaxt = "n",
  xlab = NA,
  ylab = "Catch / Angler-hour"
)

# box(col= "grey90")
par(xaxp = c(rng_vars[["Year"]], 38))

grid(lwd = 1000, col = "grey90")
grid(lty = 1, col = "white", lwd = 1)

points(
  formula = CPUE ~ Year,
  data = SFESuccessful,
  type = "c",
  lty = 2,
  col = "grey75"
)

points(
  formula = CPUE ~ Year,
  data = SFESuccessful,
  type = "p",
  col = "steelblue",
  pch = 19
)

# plot(CPUE ~ Year, data = SFESuccessful, type = "b")

# cpfv effort (angler hours) ----------------------------------------------

# plot(AnglerHours ~ Year, data = SFESuccessful, type = "h", xaxt = "n")

div <- 1000

plot(
  x = rng_vars[["Year"]],
  y = rng_vars[["AnglerHours"]],
  type = "n",
  xaxt = "n",
  yaxt = "n",
  xlab = NA,
  ylab = sprintf("Angler-hour (x %s)", div),
  ylim = c(0, rng_vars[["AnglerHours"]][2])
)

# box(col= "grey90")
par(xaxp = c(rng_vars[["Year"]], 38))

grid(lwd = 1000, col = "grey90")
grid(lty = 1, col = "white", lwd = 1)

yax_vals <- axTicks(side = 2)

axis(
  side = 2,
  at = yax_vals,
  labels = yax_vals / div,
  col = "transparent",
  col.ticks = "black"
)

points(
  formula = AnglerHours ~ Year,
  data = SFESuccessful,
  type = "h",
  col = "black",
  lwd = 4
)

# cpfv number kept --------------------------------------------------------

# plot(NumKept ~ Year, data = SFESuccessful, type = "h", xlab = "Year")

div <- 100

plot(
  x = rng_vars[["Year"]],
  y = rng_vars[["NumKept"]],
  type = "n",
  xaxt = "n",
  yaxt = "n",
  # xlab = "Year",
  xlab = NA,
  ylab = sprintf("Number kept (x %s)", div),
  ylim = c(0, rng_vars[["NumKept"]][2])
)

# box(col= "grey90")
par(xaxp = c(rng_vars[["Year"]], 38))

grid(lwd = 1000, col = "grey90")
grid(lty = 1, col = "white", lwd = 1)

xax_vals <- axTicks(side = 1)
yax_vals <- axTicks(side = 2)

axis(
  side = 1,
  at = SFESuccessful[["Year"]][c(TRUE, rep(FALSE, times = 4))],
  labels = SFESuccessful[["Year"]][c(TRUE, rep(FALSE, times = 4))],
  col = "transparent",
  col.ticks = "black"
)

axis(
  side = 2,
  at = yax_vals,
  labels = yax_vals / div,
  col = "transparent",
  col.ticks = "black"
)

points(
  formula = NumKept ~ Year,
  data = SFESuccessful,
  type = "h",
  col = "black",
  lwd = 4
)

mtext(text = "Year", side = 1, line = 2.5, adj = 0.5)
```

![](annual_cpfv_files/figure-gfm/plot-cpue-1.png)<!-- -->

-----

CDFW, SportFish Unit  
2019-08-12

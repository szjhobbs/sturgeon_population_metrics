
------------------------------------------------------------------------

------------------------------------------------------------------------

Introduction
------------

Herein, we calculate White Sturgeon and Green Sturgeon year-class index (YCI) per methods defined in Heublein et al. (in process). We use CDFW Salvage data from 1980 through present (i.e., roughly one year behind current calendar year).

Some metadata to assist with understanding results.

Fish Salvage Facilities (Facilities)
- 1 = SWP (State Water Project)
- 2 = CVP (Central Valley Project)

Sturgeon
- 27 = White
- 28 = Green

Study Codes
- 0000 = normal operation
- 8888 = special study
- 9999 = predator removal
- blank = data not recorded

`CountMinutes` time in minutes of a species count
`TotalPumping` total minutes pumped
`Acrefeet` volume of water pumped ????

Libraries
---------

We load the `sportfish` package, currently available on GitHub. For now (06-Feb-2019), this is the only package required.

``` r
library(sportfish)
# library(package)
```

Load Data
---------

We load all `.rds` files from directory `data/salvage`. To keep our workspace clean, we load these files into a new environment called `Salvage`.

``` r
# the data directory for bay study
data_dir <- "data/salvage"

Salvage <- new.env()

ReadRDSFiles(fileDir = data_dir, envir = Salvage)
```

    ## RDS Files loaded from `data/salvage`:
    ## Catch.rdsDailyOps.rdsLengths.rds

``` r
# clean up
rm(data_dir)
```

Variables
---------

Here we create some variables we'll use throughout this process. We create them here and now for convenience.

*Note*: none needed at this time.

Method
------

Step-by-step we will document how we arrive at the final YCI. It's a multi-step process that could be helped by some custom functions, but for now we'll show all process details.

#### Proportional Acrefeet

We calculate proportional daily acre-feet based on the fraction of minutes pumped (during counts) and total minutes pumped. We add the results as a new field (`AFSub`) in `DailyOps`. (*Note*: `AFSub` is really poorly named, but you get the idea: a proportional sample or 'sub-sample' of total daily acre-feet.)

``` r
# add field for proportial acrefeet calculation
Salvage$DailyOps$AFSub <- with(data = Salvage$DailyOps, expr = {
  (CountMinutes / TotalPumping) * AcreFeet
})
```

For information only, we check all fields in `DailyOps` for values of `NA` or 0. We are not able to calculate `AFSub` for all records.

``` r
# check for NAs & zeroes
vapply(Salvage$DailyOps, FUN = function(x) {
  c(IsNA = sum(is.na(x)), Is0 = sum(x %in% 0))
}, FUN.VALUE = numeric(2L))
```

    ##      Facility SDate CountMinutes CountPumping TotalPumping AcreFeet AFSub
    ## IsNA        0     0            7            7            7        2    50
    ## Is0         0     0           61           61           43       40    18

#### Non-calendar Year

Based on methods described in Heublein et al. (in process), we 'offset' our calendar year according to sample month and fish facility. For SWP, year is 01-Aug to 31-Jul. For CVP, year is 01-Jun to 31-May. Below, we create a `group_year` variable accordingly.

``` r
# establish desired starting month for SWP [Aug, 8] & CVP [Jun, 6]
start_mon <- rep(8, times = nrow(Salvage$DailyOps))
start_mon[Salvage$DailyOps[["Facility"]] %in% 2] <- 6

# apply GroupYear function with appropriate starting month
group_year <- unlist(
  Map(GroupYear, Salvage$DailyOps[["SDate"]], startMon = start_mon),
  use.names = FALSE
)

# clean up
rm(start_mon)
```

#### Annual `AFSub`

Here we sum `AFSub` by `group_year` & facility. We then convert acre-feet to cubic meters using conversion factor 1233.48.

``` r
AnnualAF <- aggregate(
  Salvage$DailyOps["AFSub"],
  by = list(
    Year = group_year,
    Facility = Salvage$DailyOps[["Facility"]]
  ),
  FUN = sum,
  na.rm = TRUE
)

AnnualAF$CubicM <- AnnualAF[["AFSub"]] * 1233.48

# clean up
rm(group_year)
```

#### Catch Summary

We do likewise for catch: grouping by non-calendar year and then getting sum (of catch) by year and facility.

``` r
# establish desired starting month for SWP [Aug, 8] & CVP [Jun, 6]
start_mon_c <- rep(8, times = nrow(Salvage$Catch))
start_mon_c[Salvage$Catch[["Facility"]] %in% 2] <- 6

# apply GroupYear function with appropriate starting month
group_year_c <- unlist(
  Map(GroupYear, Salvage$Catch[["SDate"]], startMon = start_mon_c),
  use.names = FALSE
)

# clean up
rm(start_mon_c)
```

We don't include fish caught during predator removal or special studies. Thus, subset on `0000` (normal operations) or blank (for earlier years when such coding was not used).

``` r
# table(Salvage$Catch[["StudyCode"]], useNA = "ifany")
# bool_sc <- Salvage$Catch[["StudyCode"]] %in% c("", "0000")

# catch_sum <- aggregate(
#   Salvage$Catch["Count"],
#   by = list(
#     Year = group_year_c,
#     Facility = Salvage$Catch[["Facility"]],
#     Spcode = Salvage$Catch[["Spcode"]]
#   ),
#   FUN = sum,
#   na.rm = TRUE
# )

# favoring formula method for use of subset arg
catch_sum <- aggregate(
  formula = Count ~ group_year_c + Facility + Spcode,
  data = Salvage$Catch,
  FUN = sum,
  subset = StudyCode %in% c("", "0000")
)

# for column headings when reshaping in next chunk
catch_sum$Spcode <- lkp_sturgeon$species[as.character(catch_sum[["Spcode"]])]

# table(catch_sum[["Spcode"]], useNA = "ifany")

# for ease of merging
colnames(catch_sum)[1] <- "Year"

# clean up
rm(group_year_c)
```

We `reshape` catch data for merging with operations data. `AnnualAF` now contains catch and 'effort' (cubic meters) data.

``` r
# for merging with AnnualAF
catch_sum <- reshape2::dcast(
  data = catch_sum,
  formula = Year + Facility ~ Spcode,
  fill = 0,
  drop = FALSE,
  value.var = "Count"
)

# merge with AnnualAF for index calculation
AnnualAF <- merge(
  x = AnnualAF,
  y = catch_sum,
  by = c("Year", "Facility"),
  all.x = TRUE
)

# clean up
rm(catch_sum)
```

#### Index Calculation

Simply, index is catch divided by m<sup>3</sup> times 10<sup>8</sup> (for conversion). We do this for both White Sturgeon and Green Sturgeon. We remove year 1979, as we want our time series to begin with group year 1980.

``` r
AnnualAF$Green[is.na(AnnualAF[["Green"]])] <- 0
AnnualAF$White[is.na(AnnualAF[["White"]])] <- 0

# 1e+08 converts density to per 100 million cubic meters
AnnualAF <- within(data = AnnualAF, expr = {
  WYCI <- (White / CubicM) * 1e+08
  GYCI <- (Green / CubicM) * 1e+08
})

AnnualAF <- AnnualAF[AnnualAF[["Year"]] > 1979, ]
```

Below, we plot the four indices, where each has been standardized for ease of viewing. (Standardized: dividing each value by range difference.)

``` r
plots <- list(
  # c(column, facility)
  c("WYCI", 1),
  c("WYCI", 2),
  c("GYCI", 1),
  c("GYCI", 2)
)

standardize <- function(x) x / (max(x) - min(x))

# a possibility

vapply(plots, FUN = function(x) {
  
  b <- AnnualAF[["Facility"]] %in% as.numeric(x[2])
  
  fac <- if (x[2] == '1') "SWP" else "CVP"
  
  # to standardize divide by range difference
  y <- AnnualAF[b, x[1]]
  
  plot(
    x = AnnualAF[b, "Year"],
    y = standardize(y),
    type = "b",
    lwd = 1,
    lty = 2,
    # col.lty = "red",
    # lend = 2,
    col = 1,
    xlab = "Index year",
    ylab = sprintf("Index %s - %s", x[1], fac),
    las = 1
  )
  
  out <- paste0(round(range(y), digits = 2), collapse = "-")
  
  sprintf("Range for %s - %s: %s", x[1], fac, out)
  
}, FUN.VALUE = character(1L), USE.NAMES = FALSE)
```

    ## [1] "Range for WYCI - SWP: 0-113.13" "Range for WYCI - CVP: 0-56.09" 
    ## [3] "Range for GYCI - SWP: 0-3.72"   "Range for GYCI - CVP: 0-40.51"

<img src="yci_salvage_files/figure-markdown_github/plot-index-1.png" width="50%" /><img src="yci_salvage_files/figure-markdown_github/plot-index-2.png" width="50%" /><img src="yci_salvage_files/figure-markdown_github/plot-index-3.png" width="50%" /><img src="yci_salvage_files/figure-markdown_github/plot-index-4.png" width="50%" />

Save Results
------------

We save the results to `.csv` file for ease of use in other analytics and for viewing on GitHub.

``` r
write.csv(AnnualAF, file = "indices/yci_salvage.csv", row.names = FALSE)
```

------------------------------------------------------------------------

CDFW, SportFish Unit
2019-02-07

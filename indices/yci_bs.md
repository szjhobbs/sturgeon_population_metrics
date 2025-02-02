
## Introduction

Herein, we calculate White Sturgeon year-class index (YCI) per methods
defined in Fish 2010. Also, we calculate Green Sturgeon YCI using like
methods. We use CDFW San Francisco Bay Study data from 1980 through
present (roughly one year behind current year).

## Libraries

We load the `sportfish` package, currently available on GitHub. For now
(05-Feb-2019), this is the only package required.

``` r
library(sportfish)
# library(package)
```

## Load Data

We load all `.rds` files from directory `data/baystudy`. To keep our
workspace clean, we load these files into a new environment called
`BayStudy`.

``` r
# the data directory for bay study
data_dir <- "data/baystudy"

# list.files(path = data_dir, pattern = ".rds")
BayStudy <- new.env()

ReadRDSFiles(fileDir = data_dir, envir = BayStudy)
```

    ## RDS Files loaded from:
    ##  data/baystudy
    ##  **************
    ##  AgeAssign.rds
    ##  BayStudyTows.rds
    ##  BayWgtFactors.rds
    ##  Stations.rds
    ##  StuCatch.rds
    ##  **************

``` r
# clean up
rm(data_dir)
```

## Variables

Here we create some variables we’ll use throughout this process. We
create them here and now for convenience.

  - `cols_agg`  
    – fields on which we will aggregate our analytics
  - `cols_match`  
    – fields on which we’ll use to match tows with catch
  - `ntows`  
    – record count (i.e., number of tows)

<!-- end list -->

``` r
# columns in data by which to aggregate
# cols_agg <- c("Year", "Survey", "Station", "Net", "Tow", "Species", "AgeCat")
cols_agg <- c("Year", "Survey", "Bay", "Net", "Series")

cols_match <- intersect(
  x = colnames(BayStudy$BayStudyTows),
  y = colnames(BayStudy$StuCatch)
)

ntows <- nrow(BayStudy$BayStudyTows)
```

## Method

Step-by-step we will document how we arrive at the final YCI. It’s a
multi-step process that could be helped by some custom functions, but
for now we’ll so all process details. *Note*: several attempts were made
to economize this process. The one below seemed the most
straightforward, though (again) there is room for improvement.

#### Catch per Tow

Here we need to get catch (by age & by species) for each tow. Even zero
catch is important, as we’ll eventually calculate an average. To ensure
both species (White & Green) and all age categories (`AgeCat`) are
included, we convert both fields as factors. We’ll eventually apply
`base::table()`all levels will be included, using 0 for no catch.

``` r
# set factors for frequency on all 6 levels (3 ages * 2 species)
BayStudy$StuCatch <- within(data = BayStudy$StuCatch, expr = {
  AgeCat <- factor(AgeCat, levels = c("Age0", "Age1", "Age2+"))
  Species <- factor(Species, levels = c("Green", "White"))
})
```

#### Split Catch

Next, we split sturgeon catch (`StuCatch`) by intersecting fields with
`BayStudyTows` to get at catch per record (i.e., tow). We then match
records in `BayStudyTows` with names of split data. `index` *should*
have length equal to `nrow(BayStudyTows`), with `NAs` for non-matching
records.

``` r
# split catch on matching columns
stu_catch <- split(
  BayStudy$StuCatch[c("Species", "AgeCat")],
  f = BayStudy$StuCatch[cols_match],
  drop = TRUE
)

# establish index for each tow (i.e., record in BayStudyTows)
index <- match(
  x = Reduce(f = paste, x = BayStudy$BayStudyTows[cols_match]),
  table = gsub(pattern = "\\.", replacement = " ", x = names(stu_catch))
)
```

#### Sturgeon Catch

To `BayStudyTows`, add field `Sturgeon`, which will house a dataframe
(of catch by `Species` + `AgeCat`) for each record. Run through each
`index` (i.e., tow in `BayStudyTows`), and return dataframe for ease of
further analytics (‘zero’ dataframe if `index` is NA, i.e. no match).

``` r
no_catch <- expand.grid(
  Species = c("Green", "White"),
  AgeCat = c("Age0", "Age1", "Age2+"),
  Freq = 0,
  KEEP.OUT.ATTRS = FALSE,
  stringsAsFactors = FALSE
)

# run through each index
BayStudy$BayStudyTows$Sturgeon <- lapply(index, FUN = function(i, val) {
  if (is.na(i)) return(val)
  freq <- table(stu_catch[[i]])
  as.data.frame(freq, stringsAsFactors = FALSE)
}, val = no_catch)

# clean up
rm(no_catch, index, stu_catch)
```

#### Calculate CPUE

We use catch (`Freq`) and `TowValue` (see Metadata) to calculate CPUE.
We add `CPUE` field to each dataframe in `BayStudyTows$Sturgeon`.

  
![CPUE\_t=\\frac{\\text{catch}\_t}{\\text{tow value}\_t}
\\times 10^4](https://latex.codecogs.com/png.latex?CPUE_t%3D%5Cfrac%7B%5Ctext%7Bcatch%7D_t%7D%7B%5Ctext%7Btow%20value%7D_t%7D%20%5Ctimes%2010%5E4
"CPUE_t=\\frac{\\text{catch}_t}{\\text{tow value}_t} \\times 10^4")  

where *t* denotes tow (for which catch would be by species by age
category)

``` r
BayStudy$BayStudyTows$Sturgeon <- Map(function(x, y) {
  x$CPUE <- (x[["Freq"]] / y) * 10000
  x
}, BayStudy$BayStudyTows$Sturgeon, BayStudy$BayStudyTows$TowValue)
```

#### Mean CPUE

We calculate mean CPUE aggregating on fields in `cols_agg`. Here we use
only tows flagged with 0 (see Metadata). Split tows by `cols_agg` for
continue analytics.

``` r
# for only using desired rows
bool_flag <- BayStudy$BayStudyTows[["Flag"]] == 0

split_tows <- split(
  BayStudy$BayStudyTows[bool_flag, "Sturgeon"],
  f = BayStudy$BayStudyTows[bool_flag, cols_agg],
  drop = TRUE
)
```

Using names of `split_tows`, create dataframe for holding summarized
data. Because we know the aggregated fields are all numeric, we can
convert as such said fields (in new dataframe).

``` r
data_agg <- data.frame(
  do.call(what = rbind, args = strsplit(names(split_tows), split = "\\.")),
  stringsAsFactors = FALSE
)

# for convenience and restoring to orginal data type
colnames(data_agg) <- cols_agg
data_agg[] <- lapply(data_agg, FUN = as.numeric)
```

We add split data to `data_agg` for ease of
summarizing.

``` r
data_agg$Sturgeon <- lapply(unname(split_tows), FUN = do.call, what = rbind)
```

We need bay weighting factor to calculate `Index`. For this, we `Net`
and `Bay` fields of our aggregated data with those same fields in
`BayWgtFactors`.

``` r
index_bwf <- match(
  Reduce(f = paste, x = data_agg[c("Net", "Bay")]),
  table = Reduce(f = paste, x = BayStudy$BayWgtFactors[c("Net", "Bay")])
)
```

Now, for each species-age combo, we calculate mean CPUE. We multiply
mean CPUE and the appropriate bay weighting factor to get `Index`. We
add field `StuIndex` to our aggregated data for further analysis.

  
![Index=\\bar{X} \\times
\\beta](https://latex.codecogs.com/png.latex?Index%3D%5Cbar%7BX%7D%20%5Ctimes%20%5Cbeta
"Index=\\bar{X} \\times \\beta")  

where ![\\bar{X}](https://latex.codecogs.com/png.latex?%5Cbar%7BX%7D
"\\bar{X}") is mean CPUE by Year, Survey, Bay, Net, & Series (by species
& age category) ![\\beta](https://latex.codecogs.com/png.latex?%5Cbeta
"\\beta") is bay weight by net and by bay

``` r
data_agg$StuIndex <- Map(function(x, bwf) {
  
  r <- split(x, f = x[c("Species", "AgeCat")])
  
  r <- lapply(r, FUN = function(y) {
    
    m <- mean(y$CPUE)
    
    data.frame(
      Species = unique(y$Species),
      AgeCat = unique(y$AgeCat),
      Catch = sum(y$Freq),
      CPUEMean = m,
      CPUEVar = var(y$CPUE),
      CPUEN = length(y$CPUE),
      Index = m * bwf,
      # row.names = NULL,
      stringsAsFactors = FALSE
    )
  })
  
  r <- do.call(what = rbind, args = r)
  rownames(r) <- NULL
  r
  
}, data_agg$Sturgeon, BayStudy$BayWgtFactors$BayWgt[index_bwf])

# clean up
rm(split_tows, bool_flag, index_bwf)
```

#### Calculate YCI

Here, we follow the historic YCI calculation: using only otter trawl
(net = 2) and only series = 1. We establish a Boolean variable to assist
with this.

``` r
bool_ns <- data_agg[["Net"]] %in% 2 & data_agg[["Series"]] %in% 1
```

We’ll eventually sum Catch & Index by Year & Survey, so we split our
aggregated data on fields `Year` & `Survey`. Setting `drop = TRUE` will
exclude records when no survey was conducted for a specific year.

``` r
split_ys <- split(
  data_agg[bool_ns, ],
  f = data_agg[bool_ns, c("Year", "Survey")],
  drop = TRUE
)

# data_ys <- data.frame(
#   do.call(what = rbind, args = strsplit(names(split_ys), split = "\\.")),
#   stringsAsFactors = FALSE
# )
# 
# colnames(data_ys) <- c("Year", "Survey")
# data_ys[] <- lapply(data_ys, FUN = as.numeric)

# clean up
rm(data_agg, bool_ns)
```

Now, sum `Catch` & `Index` by `Species` &
`AgeCat`.

  
![Index\_{ys}=\\sum{Index\_{sa}}](https://latex.codecogs.com/png.latex?Index_%7Bys%7D%3D%5Csum%7BIndex_%7Bsa%7D%7D
"Index_{ys}=\\sum{Index_{sa}}")  

where *ys* denotes by year by survey and *sa* denotes by species by age
category

*Note*: we do likewise for Catch

``` r
data_ys <- lapply(split_ys, FUN = function(x) {
  
  d <- do.call(what = rbind, args = x$StuIndex)
  
  aggregate(
    formula = cbind(Catch, Index) ~ Species + AgeCat,
    data = d,
    FUN = sum,
    na.action = na.pass
  )
  
})

# clean up
rm(split_ys)
```

For convenience, create a dataframe of the split records in `data_ys`.

``` r
data_ys <- do.call(what = rbind, args = data_ys)

data_ys <- data.frame(
  do.call(
    what = rbind,
    args = strsplit(rownames(data_ys), split = "\\.")
  )[, 1:2],
  data_ys,
  row.names = NULL,
  stringsAsFactors = FALSE
)

data_ys[c("X1", "X2")] <- lapply(data_ys[c("X1", "X2")], FUN = as.numeric)

colnames(data_ys)[1:2] <- c("Year", "Survey")
```

In keeping with historic calculations, we use only surveys 4-10 for
age-0 and only surveys 2-10 for age-1. In this respect, we treat both
species the same. For the annual index (by age and species), we take the
mean index of the appropriate
surveys.

  
![Index\_y=\\bar{Index}\_{ys}](https://latex.codecogs.com/png.latex?Index_y%3D%5Cbar%7BIndex%7D_%7Bys%7D
"Index_y=\\bar{Index}_{ys}")  

where *y* denotes year & *s* denotes survey (either 4-10 for age-0 or
2-10 for age-1)

``` r
split_y <- split(data_ys, f = data_ys["Year"])

split_y <- lapply(split_y, FUN = function(x) {
  
  bs0 <- x[["Survey"]] %in% 4:10
  bs1 <- x[["Survey"]] %in% 2:10
  
  bsp <- x[["Species"]] %in% "White"
  
  ba0 <- x[["AgeCat"]] %in% "Age0"
  ba1 <- x[["AgeCat"]] %in% "Age1"
  
  catch <- list(
    WAge0 = sum(x[bs0 & bsp & ba0, "Catch"]),
    WAge1 = sum(x[bs1 & bsp & ba1, "Catch"]),
    GAge0 = sum(x[bs0 & !bsp & ba0, "Catch"]),
    GAge1 = sum(x[bs1 & !bsp & ba1, "Catch"])
  )
  
  index <- list(
    WAge0 = mean(x[bs0 & bsp & ba0, "Index"]),
    WAge1 = mean(x[bs1 & bsp & ba1, "Index"]),
    GAge0 = mean(x[bs0 & !bsp & ba0, "Index"]),
    GAge1 = mean(x[bs1 & !bsp & ba1, "Index"])
  )
  
  data.frame(Year = unique(x[["Year"]]), N = catch, In = index)
})

# clean up
rm(data_ys)
```

Create a dataframe of the results for convenience.

``` r
yci <- do.call(what = rbind, args = split_y)
rownames(yci) <- NULL

# clean up
rm(split_y)
```

#### Final Step

Calculate YCI using age-0 from year Y and age-1 from year Y+1. We create
variable `i` to facilitate offsetting records. Here `N_` represents
catch (or count) and ‘W’|‘G’ denote species. So YCI takes two years to
finalize.

  
![YCI\_y=\\bar{X}\_{age0\_y} +
\\bar{X}\_{age1\_{y+1}}](https://latex.codecogs.com/png.latex?YCI_y%3D%5Cbar%7BX%7D_%7Bage0_y%7D%20%2B%20%5Cbar%7BX%7D_%7Bage1_%7By%2B1%7D%7D
"YCI_y=\\bar{X}_{age0_y} + \\bar{X}_{age1_{y+1}}")  

where *y* denotes year &
![\\bar{X}](https://latex.codecogs.com/png.latex?%5Cbar%7BX%7D
"\\bar{X}") is mean annual index by species by age category

``` r
i <- c(2:nrow(yci), NA)

yci$NW.YCI <- yci[["N.WAge0"]] + yci[i, "N.WAge1"]
yci$NG.YCI <- yci[["N.GAge0"]] + yci[i, "N.GAge1"]

yci$WYCI <- yci[["In.WAge0"]] + yci[i, "In.WAge1"]
yci$GYCI <- yci[["In.GAge0"]] + yci[i, "In.GAge1"]

# uncomment if desired
# View(yci)

# clean up
rm(i, ntows, cols_agg, cols_match)
```

## Historical White Sturgeon YCI

Here we plot annual White Sturgeon YCI.

``` r
rng_yr <- range(yci[["Year"]])

b_five_yr <- yci[["Year"]] %% 5 == 0

plot(
  x = rng_yr,
  y = range(yci[["WYCI"]], na.rm = TRUE),
  type = "n",
  las = 1,
  xlim = rng_yr + c(0.5, -0.5),
  xlab = "Year",
  # ylab = "Year class index",
  ylab = NA,
  xaxt = "n",
  yaxt = "n"
)

par(xaxp = c(rng_yr, diff(rng_yr)))
# par(yaxp = par("yaxp") * c(1, 1, 2))
grid(lwd = 1000, col = "grey90")
grid(lty = 1, col = "white", lwd = 1)

yticks <- axTicks(side = 2)

yax_format <- AxisFormat(yticks)

points(
  x = yci[["Year"]],
  y = yci[["WYCI"]],
  type = "c",
  lty = 2,
  lwd = 0.5,
  col = "grey65"
)

points(
  x = yci[["Year"]],
  y = yci[["WYCI"]],
  pch = 21,
  bg = "grey20",
  col = "white"
)

axis(
  side = 1,
  at = yci[["Year"]][b_five_yr],
  labels = yci[["Year"]][b_five_yr],
  col = "transparent",
  col.ticks = "grey30"
)

axis(
  side = 2,
  at = yticks,
  labels = yax_format[["Labels"]],
  col = "transparent",
  col.ticks = "grey30",
  las = 1
)

mtext(
  text = yax_format$AxisTitle(var = "YCI"),
  side = 2,
  line = 2,
  las = 3,
  cex = 1.5
)
```

![](yci_bs_files/figure-gfm/plot-wst-yci-1.png)<!-- -->

## Save Summary Data

``` r
write.csv(yci, file = "indices/yci_bs.csv", row.names = FALSE)
```

-----

CDFW, SportFish Unit  
2019-08-22

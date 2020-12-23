White Sturgeon Age-Length Key: A Comparison of Datasets
================
CA Department of Fish and Wildlife
May 9, 2016

-   [Introduction](#introduction)
-   [General summary: CDFW Data (1973-1976)](#general-summary-cdfw-data-1973-1976)
-   [General summary: USFWS Data (2012-ongoing)](#general-summary-usfws-data-2012-ongoing)
-   [Length Frequency Distribution](#length-frequency-distribution)
-   [Age Frequency Distribution](#age-frequency-distribution)
-   [Mean Length at Age](#mean-length-at-age)
-   [Growth Curve: von Bertalanffy Growth Curve Applied](#growth-curve-von-bertalanffy-growth-curve-applied)
-   [Other Plots: raw data](#other-plots-raw-data)
-   [CDFW 1970s Data: summary count for some variables](#cdfw-1970s-data-summary-count-for-some-variables)
-   [CDFW 1970s Data: understanding the raw data](#cdfw-1970s-data-understanding-the-raw-data)

### Introduction

Herein we compare extant age-length data (1973-1976, CDFW) with recently-collected and recently-aged age-length data (2012-present, USFWS). Current data collection and ageing is ongoing, so consider this comparison very preliminary.

Further, herein is a comparison of sorts of the extant data to itself. We (CDFW) recently discovered (in electronic form) the age-length data behind our extant age-length key (see WSTALKEY.xls). Recreating the age-length key, we discovered certain (minor) discrepancies. Assuming, of course, we have all the data (and this is a safe assumption +/- a couple data points), the minor discrepancies may be from manual manipulation not (yet) evident in the .xls file or any metadata. In spite of this, we are confident the 1973-1976 data herein are represented in [Kohlhorst et al. (1980)](ftp://ftp.dfg.ca.gov/Adult_Sturgeon_and_Striped_Bass/White%20sturgeon%20age%20and%20growth%201980.pdf).

### General summary: CDFW Data (1973-1976)

-   All data are for White Sturgeon
-   Number of records: 1222
-   Number of columns: 15; "Year" field added for convenience
-   In counts per year (summary below), years 1998 and 2014 are likely entry errors
-   Errant data (i.e., data where year &gt; 1976) shown for reference only
-   Data in fields "Age" and "Age\_1" are identical
-   Data in fields "TL" and "TLen" are identical

<!-- -->

    ## 'data.frame':    1222 obs. of  15 variables:
    ##  $ ID       : chr  "72" "71" "69" "68" ...
    ##  $ Species  : int  2 2 2 2 2 2 2 2 2 2 ...
    ##  $ Date     : Date, format: "1973-03-22" "1973-04-09" ...
    ##  $ FL       : num  43 53 79 118 66 88 56 55 56 55 ...
    ##  $ TL       : num  50 61 89 132 75 99 64 63 64 63 ...
    ##  $ Sex      : int  NA NA NA NA 1 NA NA NA NA NA ...
    ##  $ CapMethod: int  1 2 2 1 NA NA 2 2 2 2 ...
    ##  $ Location : int  5 1 1 5 1 1 1 1 1 1 ...
    ##  $ Age      : int  3 4 5 20 5 10 3 4 4 4 ...
    ##  $ YearClass: int  69 69 68 53 68 63 70 69 69 69 ...
    ##  $ Check    : int  72 73 73 73 73 73 73 73 73 73 ...
    ##  $ Age_1    : int  3 4 5 20 5 10 3 4 4 4 ...
    ##  $ TLen     : num  50 61 89 132 75 99 64 63 64 63 ...
    ##  $ NewAge   : int  3 4 5 20 5 10 3 4 4 4 ...
    ##  $ Year     : num  1973 1973 1973 1973 1973 ...

    ## CountPerYear
    ## 1973 1974 1975 1976 1998 2014 
    ##  181  334  193  510    3    1

    ##       ID Species       Date FL  TL Sex CapMethod Location Age YearClass
    ## 227    7       2 2014-10-20 91 104   1         3       10   7        67
    ## 264 -136       2 1998-10-16 NA  92  NA         5       10   8        66
    ## 265 -137       2 1998-10-16 NA 100  NA         5       10   8        66
    ## 266 -138       2 1998-10-16 NA  96  NA         5       10   9        65
    ##     Check Age_1 TLen NewAge Year
    ## 227    74     7  104      7 2014
    ## 264    74     8   92      8 1998
    ## 265    74     8  100      8 1998
    ## 266    74     9   96      9 1998

### General summary: USFWS Data (2012-ongoing)

-   All data are for White Sturgeon
-   Number of records: 221
-   Number of columns: 5
-   Fish sampled during CDFW mark-recapture study & during sturgeon fishing derby

<!-- -->

    ## 'data.frame':    221 obs. of  5 variables:
    ##  $ Source     : chr  "CDFW" "CDFW" "CDFW" "CDFW" ...
    ##  $ SampleID   : chr  "1" "3" "4" "6" ...
    ##  $ Age        : int  9 6 8 7 8 10 7 9 8 8 ...
    ##  $ ForkLength : num  77 83 73 76 84 79 76 88 81 98 ...
    ##  $ TotalLength: num  87 93 82 85 94 89 85 99 91 110 ...

    ## 
    ##  CDFW DERBY 
    ##   128    93

### Length Frequency Distribution

Here we look at the length frequency distributions for both data sets. For the purposes of comparison, we used total length (TL, in centimeters) and binned lengths from 21 to 186+ by 5 cm. See overall stats (for TL) in table below.

| Source |  Count|       Mean|    Median|  Min|  Max|
|:-------|------:|----------:|---------:|----:|----:|
| CDFW   |   1222|   97.18674|  33.15791|   97|   24|
| USFWS  |    221|  113.88235|  35.45413|   98|   62|

Below, we plot length frequency distributions for CDFW (top) and USFWS (bottom).

![](WstAlKey_files/figure-markdown_github/LfDistPlots-1.png)![](WstAlKey_files/figure-markdown_github/LfDistPlots-2.png)

### Age Frequency Distribution

Age data for CDFW ranged 0-24 and for USFWS 3-23. Plots below display age frequency distribution (CDFW - top, USFWS - bottom). Note: different y-axis & USFWS plot begins at age-3.

![](WstAlKey_files/figure-markdown_github/AFDistPlots-1.png)![](WstAlKey_files/figure-markdown_github/AFDistPlots-2.png)

### Mean Length at Age

Presented below are mean lengths at each age (CDFW - top, USFWS - bottom). Along with means (Avg) are standard deviation (SD) and standard error (SE).

|  Age|  NACount|    N|    Min|    Max|      Avg|      SD|     SE|    Med|
|----:|--------:|----:|------:|------:|--------:|-------:|------:|------:|
|    0|        0|   32|   24.0|   38.0|   33.188|   3.074|  0.543|   34.0|
|    1|        0|   34|   36.0|   54.0|   46.971|   4.262|  0.731|   48.0|
|    2|        0|  127|   40.0|   69.0|   53.767|   5.017|  0.445|   54.0|
|    3|        0|   44|   50.0|   74.0|   61.091|   5.834|  0.880|   62.0|
|    4|        0|   49|   54.0|   82.0|   69.653|   6.323|  0.903|   71.0|
|    5|        0|   60|   60.0|   89.0|   74.717|   6.028|  0.778|   74.0|
|    6|        0|   81|   59.0|  110.0|   83.728|  10.351|  1.150|   82.0|
|    7|        0|  126|   63.0|  109.0|   91.873|   9.410|  0.838|   92.0|
|    8|        0|  117|   76.0|  121.6|   98.716|   9.351|  0.865|   98.0|
|    9|        0|  141|   83.0|  130.0|  102.955|   9.210|  0.776|  103.0|
|   10|        0|   93|   85.0|  133.0|  108.996|   9.879|  1.024|  109.2|
|   11|        0|   50|   92.0|  135.0|  116.032|  10.959|  1.550|  116.5|
|   12|        0|   30|  106.0|  149.0|  125.897|  10.046|  1.834|  125.5|
|   13|        0|   24|  106.0|  152.0|  129.804|  13.430|  2.741|  129.0|
|   14|        0|   37|  116.0|  160.0|  136.419|  11.834|  1.945|  138.0|
|   15|        0|   32|  118.0|  157.0|  137.016|  11.230|  1.985|  139.0|
|   16|        0|   38|  119.0|  172.0|  143.376|  12.389|  2.010|  143.0|
|   17|        0|   25|  126.0|  176.0|  146.468|  12.914|  2.583|  143.0|
|   18|        0|   31|  129.0|  181.0|  153.355|  12.548|  2.254|  151.0|
|   19|        0|   19|  128.0|  178.0|  156.926|  14.372|  3.297|  156.0|
|   20|        0|   22|  130.0|  201.0|  158.818|  19.651|  4.190|  157.0|
|   21|        0|    6|  142.0|  176.0|  158.167|  11.686|  4.771|  158.0|
|   22|        0|    1|  185.4|  185.4|  185.400|      NA|     NA|  185.4|
|   23|        0|    2|  180.0|  190.0|  185.000|   7.071|  5.000|  185.0|
|   24|        0|    1|  160.0|  160.0|  160.000|      NA|     NA|  160.0|

|  Age|  NACount|    N|  Min|  Max|      Avg|      SD|      SE|    Med|
|----:|--------:|----:|----:|----:|--------:|-------:|-------:|------:|
|    3|        0|    1|   62|   62|   62.000|      NA|      NA|   62.0|
|    4|        0|   34|   62|   88|   71.853|   6.131|   1.051|   71.0|
|    5|        0|    2|   74|   75|   74.500|   0.707|   0.500|   74.5|
|    6|        0|    5|   78|   93|   85.000|   5.745|   2.569|   84.0|
|    7|        0|   20|   73|  105|   91.000|   8.124|   1.817|   91.0|
|    8|        0|   49|   77|  139|   90.796|  10.494|   1.499|   91.0|
|    9|        0|   13|   80|   99|   90.538|   5.532|   1.534|   92.0|
|   10|        0|    6|   89|  147|  114.000|  22.698|   9.266|  106.5|
|   11|        0|    4|   95|  162|  140.500|  30.665|  15.332|  152.5|
|   12|        0|    5|  132|  157|  146.800|  10.616|   4.748|  146.0|
|   13|        0|   13|  134|  163|  150.000|   8.436|   2.340|  150.0|
|   14|        0|   19|  125|  168|  151.684|   8.049|   1.847|  153.0|
|   15|        0|   16|  133|  172|  153.000|   9.805|   2.451|  153.5|
|   16|        0|   11|  144|  166|  156.000|   6.229|   1.878|  156.0|
|   17|        0|    9|  146|  166|  156.778|   6.942|   2.314|  156.0|
|   18|        0|    5|  154|  167|  161.200|   4.764|   2.131|  162.0|
|   19|        0|    4|  155|  167|  161.000|   5.888|   2.944|  161.0|
|   20|        0|    3|  153|  165|  159.667|   6.110|   3.528|  161.0|
|   21|        0|    1|  162|  162|  162.000|      NA|      NA|  162.0|
|   23|        0|    1|  165|  165|  165.000|      NA|      NA|  165.0|

### Growth Curve: von Bertalanffy Growth Curve Applied

[Kohlhorst et al. (1980)](ftp://ftp.dfg.ca.gov/Adult_Sturgeon_and_Striped_Bass/White%20sturgeon%20age%20and%20growth%201980.pdf) applied the von Bertalanffy formula (below) to the 1973-1976 data. Here we repeat the application of this formula to the 1973-1976 data, plus we apply the formula to USFWS data. Note: here we use all ages. Kohlhorst et al. (1980) used ages 0-21. R code included below for reference.

*l*<sub>*t*</sub> = *L*<sub>∞</sub> \* (1 − *e*<sup>−*k* \* (*a**g**e* − *t*<sub>0</sub>)</sup>)

where:

*l*<sub>*t*</sub> = length (cm TL) at a given age
*L*<sub>∞</sub> = asymptotic length (or length at age infinity)
*k* = curvature parameter (how quickly fish gets to *L*<sub>∞</sub>)
*t*<sub>0</sub> = age at which fish has 0 length

[von Bertalanffy reference](http://www.fao.org/docrep/w5449e/w5449e05.htm)

``` r
# Here we apply the von Bertalanffy model to CDFW data and to USFWS data. 
# Summary output assigned to variable for use later in this report and in 
# plotting. VB algorithm fitted using R's nls() function, which requires 
# starting values (see list argument for 'start' parameter). For reference see 
# page 663 of "The R Book" (Crawley 2007)

# The nls() function requires starting values. Values were choses based on
# Kohlhorst et al. 1980 values.

# for simplicity...
# a = L_sub_inf (200)
# b = k         (0.05)
# c = t_sub_0   (0)

# CDFW
mod_vb_cdfw <- nls(
  formula = TLen ~ a * (1 - (exp(-b * (Age - c)))),
  data = old_al_data,
  start = list(a = 200, b = 0.05, c = 0)
)

# USFWS
mod_vb_usfws <- nls(
  formula = TotalLength ~ a * (1 - (exp(-b * (Age - c)))),
  data = wst_usfws_age_len,
  start = list(a = 200, b = 0.05, c = 0)
)

# get summary of each model
mod_vb_cdfw_sum <- summary(mod_vb_cdfw)
mod_vb_usfws_sum <- summary(mod_vb_usfws)
```

Results of the non-linear least squares model `nls()` are given below (CDFW - top, USFWS - bottom). Though displayed as 0, CDFW results are significant to p &lt; 0.001.

|     |     Estimate|  Std. Error|    t value|  Pr(&gt;|t|)|
|:----|------------:|-----------:|----------:|------------:|
| a   |  264.6379248|  12.0079264|   22.03860|            0|
| b   |    0.0395571|   0.0029426|   13.44310|            0|
| c   |   -3.6644396|   0.1858954|  -19.71238|            0|

|     |     Estimate|  Std. Error|    t value|  Pr(&gt;|t|)|
|:----|------------:|-----------:|----------:|------------:|
| a   |  317.0040037|  66.1399027|   4.792931|    0.0000030|
| b   |    0.0363004|   0.0121930|   2.977146|    0.0032383|
| c   |   -2.3849627|   0.8318109|  -2.867193|    0.0045475|

Here we plot the von Bertalanffy model output. Points are mean total length (cm) at age.

![](WstAlKey_files/figure-markdown_github/PlotVb-1.png)

### Other Plots: raw data

Below we plot total length (cm) as a function of age, with loess line added for reference (see blue line). Points are raw data (CDFW - top figure, USFWS - bottom figure) and are shaded according to degree of overlap.

![](WstAlKey_files/figure-markdown_github/RawDataPlots-1.png)![](WstAlKey_files/figure-markdown_github/RawDataPlots-2.png)

### CDFW 1970s Data: summary count for some variables

Below are summary outputs for CDFW data (1973-1976). We are in the process of finding metadata for the codes. Likely, though, for "Sex" 1 = male, 2 = female.

    ## CaptureMethod
    ##    1    2    3    4    5    6    7    8    9   10   11   13   70 <NA> 
    ##    9   36  242   46  264   32  440    3   12  107    3    9    2   17

    ## Location
    ##    1    4    5    7    9   10 <NA> 
    ##   48    9    2  436  282  442    3

    ## Sex
    ##    1    2  107 <NA> 
    ##  158  174    1  889

### CDFW 1970s Data: understanding the raw data

Prior to recent endeavors of ageing sturgeon (i.e., collaboration between CDFW & USFWS), we (CDFW) used the age-length key developed from the 1973-1976 data (see WSTALKEY.xls, tab 'A') to age sturgeon. Recently we found the raw data behind this age-length key. However, in trying to recreate the age-length key with this raw data, we discovered some discrepancies. Twenty of the 34 length bins are identical, leaving 14 with (what I'll call) minor deviations. See "ugly" output below for differences by each length bin. Row 3 of $Data is difference between second row (key of newly found age-length data) and first row (extant key). Row 4 is percent changes as calculated below, where *i* denotes each row. If $IsEqual is TRUE, then keys match for that row.

${change} = \\frac{new\_i - extant\_i}{extant\_i} \* {100}$

    $Bin21
    $Bin21$Data
      0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17
    1 1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    2 1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    3 0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    4 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
       18  19  20  21  22
    1   0   0   0   0   0
    2   0   0   0   0   0
    3   0   0   0   0   0
    4 NaN NaN NaN NaN NaN

    $Bin21$IsEqual
    [1] TRUE


    $Bin26
    $Bin26$Data
      0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17
    1 1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    2 1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    3 0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    4 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
       18  19  20  21  22
    1   0   0   0   0   0
    2   0   0   0   0   0
    3   0   0   0   0   0
    4 NaN NaN NaN NaN NaN

    $Bin26$IsEqual
    [1] TRUE


    $Bin31
    $Bin31$Data
      0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17
    1 1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    2 1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    3 0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    4 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
       18  19  20  21  22
    1   0   0   0   0   0
    2   0   0   0   0   0
    3   0   0   0   0   0
    4 NaN NaN NaN NaN NaN

    $Bin31$IsEqual
    [1] TRUE


    $Bin36
    $Bin36$Data
        0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17
    1 0.7 0.2 0.1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    2 0.7 0.2 0.1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    3 0.0 0.0 0.0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    4 0.0 0.0 0.0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
       18  19  20  21  22
    1   0   0   0   0   0
    2   0   0   0   0   0
    3   0   0   0   0   0
    4 NaN NaN NaN NaN NaN

    $Bin36$IsEqual
    [1] TRUE


    $Bin41
    $Bin41$Data
        0      1      2   3   4   5   6   7   8   9  10  11  12  13  14  15
    1   0 0.6667 0.3333   0   0   0   0   0   0   0   0   0   0   0   0   0
    2   0 0.6667 0.3333   0   0   0   0   0   0   0   0   0   0   0   0   0
    3   0 0.0000 0.0000   0   0   0   0   0   0   0   0   0   0   0   0   0
    4 NaN 0.0000 0.0000 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
       16  17  18  19  20  21  22
    1   0   0   0   0   0   0   0
    2   0   0   0   0   0   0   0
    3   0   0   0   0   0   0   0
    4 NaN NaN NaN NaN NaN NaN NaN

    $Bin41$IsEqual
    [1] TRUE


    $Bin46
    $Bin46$Data
        0      1      2      3   4   5   6   7   8   9  10  11  12  13  14  15
    1   0 0.3542 0.5625 0.0833   0   0   0   0   0   0   0   0   0   0   0   0
    2   0 0.3542 0.5625 0.0833   0   0   0   0   0   0   0   0   0   0   0   0
    3   0 0.0000 0.0000 0.0000   0   0   0   0   0   0   0   0   0   0   0   0
    4 NaN 0.0000 0.0000 0.0000 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
       16  17  18  19  20  21  22
    1   0   0   0   0   0   0   0
    2   0   0   0   0   0   0   0
    3   0   0   0   0   0   0   0
    4 NaN NaN NaN NaN NaN NaN NaN

    $Bin46$IsEqual
    [1] TRUE


    $Bin51
    $Bin51$Data
        0      1      2      3      4   5   6   7   8   9  10  11  12  13  14
    1   0 0.1148 0.8033 0.0656 0.0164   0   0   0   0   0   0   0   0   0   0
    2   0 0.1148 0.8033 0.0656 0.0164   0   0   0   0   0   0   0   0   0   0
    3   0 0.0000 0.0000 0.0000 0.0000   0   0   0   0   0   0   0   0   0   0
    4 NaN 0.0000 0.0000 0.0000 0.0000 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
       15  16  17  18  19  20  21  22
    1   0   0   0   0   0   0   0   0
    2   0   0   0   0   0   0   0   0
    3   0   0   0   0   0   0   0   0
    4 NaN NaN NaN NaN NaN NaN NaN NaN

    $Bin51$IsEqual
    [1] TRUE


    $Bin56
    $Bin56$Data
        0   1      2      3      4      5      6   7   8   9  10  11  12  13
    1   0   0 0.6863 0.2157 0.0588 0.0196 0.0196   0   0   0   0   0   0   0
    2   0   0 0.6863 0.2157 0.0588 0.0196 0.0196   0   0   0   0   0   0   0
    3   0   0 0.0000 0.0000 0.0000 0.0000 0.0000   0   0   0   0   0   0   0
    4 NaN NaN 0.0000 0.0000 0.0000 0.0000 0.0000 NaN NaN NaN NaN NaN NaN NaN
       14  15  16  17  18  19  20  21  22
    1   0   0   0   0   0   0   0   0   0
    2   0   0   0   0   0   0   0   0   0
    3   0   0   0   0   0   0   0   0   0
    4 NaN NaN NaN NaN NaN NaN NaN NaN NaN

    $Bin56$IsEqual
    [1] TRUE


    $Bin61
    $Bin61$Data
        0   1      2      3      4      5      6      7   8   9  10  11  12
    1   0   0 0.2308 0.3846 0.2308 0.0769 0.0513 0.0256   0   0   0   0   0
    2   0   0 0.2308 0.3846 0.2308 0.0769 0.0513 0.0256   0   0   0   0   0
    3   0   0 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000   0   0   0   0   0
    4 NaN NaN 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 NaN NaN NaN NaN NaN
       13  14  15  16  17  18  19  20  21  22
    1   0   0   0   0   0   0   0   0   0   0
    2   0   0   0   0   0   0   0   0   0   0
    3   0   0   0   0   0   0   0   0   0   0
    4 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN

    $Bin61$IsEqual
    [1] TRUE


    $Bin66
    $Bin66$Data
        0   1      2           3      4           5          6          7   8
    1   0   0 0.0625  0.28130000 0.3125  0.28130000  0.0313000  0.0313000   0
    2   0   0 0.0625  0.28120000 0.3125  0.28120000  0.0312000  0.0312000   0
    3   0   0 0.0000 -0.00010000 0.0000 -0.00010000 -0.0001000 -0.0001000   0
    4 NaN NaN 0.0000 -0.03554924 0.0000 -0.03554924 -0.3194888 -0.3194888 NaN
        9  10  11  12  13  14  15  16  17  18  19  20  21  22
    1   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    2   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    3   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    4 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN

    $Bin66$IsEqual
    [1] FALSE


    $Bin71
    $Bin71$Data
        0   1   2        3       4         5        6        7   8   9  10  11
    1   0   0   0 0.017500 0.33330  0.421100 0.210500 0.017500   0   0   0   0
    2   0   0   0 0.017900 0.33930  0.410700 0.214300 0.017900   0   0   0   0
    3   0   0   0 0.000400 0.00600 -0.010400 0.003800 0.000400   0   0   0   0
    4 NaN NaN NaN 2.285714 1.80018 -2.469722 1.805226 2.285714 NaN NaN NaN NaN
       12  13  14  15  16  17  18  19  20  21  22
    1   0   0   0   0   0   0   0   0   0   0   0
    2   0   0   0   0   0   0   0   0   0   0   0
    3   0   0   0   0   0   0   0   0   0   0   0
    4 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN

    $Bin71$IsEqual
    [1] FALSE


    $Bin76
    $Bin76$Data
        0   1   2   3        4        5         6       7      8   9  10  11
    1   0   0   0   0  0.11360 0.227300  0.409100  0.2500 0.0000   0   0   0
    2   0   0   0   0  0.10870 0.239100  0.391300  0.2391 0.0217   0   0   0
    3   0   0   0   0 -0.00490 0.011800 -0.017800 -0.0109 0.0217   0   0   0
    4 NaN NaN NaN NaN -4.31338 5.191377 -4.351014 -4.3600    Inf NaN NaN NaN
       12  13  14  15  16  17  18  19  20  21  22
    1   0   0   0   0   0   0   0   0   0   0   0
    2   0   0   0   0   0   0   0   0   0   0   0
    3   0   0   0   0   0   0   0   0   0   0   0
    4 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN

    $Bin76$IsEqual
    [1] FALSE


    $Bin81
    $Bin81$Data
        0   1   2   3          4      5      6      7      8      9     10  11
    1   0   0   0   0  0.0313000 0.1719 0.3125 0.2969 0.1094 0.0625 0.0156   0
    2   0   0   0   0  0.0312000 0.1719 0.3125 0.2969 0.1094 0.0625 0.0156   0
    3   0   0   0   0 -0.0001000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000   0
    4 NaN NaN NaN NaN -0.3194888 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 NaN
       12  13  14  15  16  17  18  19  20  21  22
    1   0   0   0   0   0   0   0   0   0   0   0
    2   0   0   0   0   0   0   0   0   0   0   0
    3   0   0   0   0   0   0   0   0   0   0   0
    4 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN

    $Bin81$IsEqual
    [1] FALSE


    $Bin86
    $Bin86$Data
        0   1   2   3   4      5      6      7      8     9     10  11  12  13
    1   0   0   0   0   0 0.0317 0.1746 0.3968 0.2381 0.127 0.0317   0   0   0
    2   0   0   0   0   0 0.0317 0.1746 0.3968 0.2381 0.127 0.0317   0   0   0
    3   0   0   0   0   0 0.0000 0.0000 0.0000 0.0000 0.000 0.0000   0   0   0
    4 NaN NaN NaN NaN NaN 0.0000 0.0000 0.0000 0.0000 0.000 0.0000 NaN NaN NaN
       14  15  16  17  18  19  20  21  22
    1   0   0   0   0   0   0   0   0   0
    2   0   0   0   0   0   0   0   0   0
    3   0   0   0   0   0   0   0   0   0
    4 NaN NaN NaN NaN NaN NaN NaN NaN NaN

    $Bin86$IsEqual
    [1] TRUE


    $Bin91
    $Bin91$Data
        0   1   2   3   4   5      6    7      8      9     10     11  12  13
    1   0   0   0   0   0   0 0.0526 0.25 0.3158 0.2763 0.0789 0.0263   0   0
    2   0   0   0   0   0   0 0.0526 0.25 0.3158 0.2763 0.0789 0.0263   0   0
    3   0   0   0   0   0   0 0.0000 0.00 0.0000 0.0000 0.0000 0.0000   0   0
    4 NaN NaN NaN NaN NaN NaN 0.0000 0.00 0.0000 0.0000 0.0000 0.0000 NaN NaN
       14  15  16  17  18  19  20  21  22
    1   0   0   0   0   0   0   0   0   0
    2   0   0   0   0   0   0   0   0   0
    3   0   0   0   0   0   0   0   0   0
    4 NaN NaN NaN NaN NaN NaN NaN NaN NaN

    $Bin91$IsEqual
    [1] TRUE


    $Bin96
    $Bin96$Data
        0   1   2   3   4   5      6        7         8        9      10
    1   0   0   0   0   0   0 0.0541 0.256800  0.310800 0.283800 0.08110
    2   0   0   0   0   0   0 0.0548 0.260300  0.301400 0.287700 0.08220
    3   0   0   0   0   0   0 0.0007 0.003500 -0.009400 0.003900 0.00110
    4 NaN NaN NaN NaN NaN NaN 1.2939 1.362928 -3.024453 1.374207 1.35635
            11  12  13  14  15  16  17  18  19  20  21  22
    1 0.013500   0   0   0   0   0   0   0   0   0   0   0
    2 0.013700   0   0   0   0   0   0   0   0   0   0   0
    3 0.000200   0   0   0   0   0   0   0   0   0   0   0
    4 1.481481 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN

    $Bin96$IsEqual
    [1] FALSE


    $Bin101
    $Bin101$Data
        0   1   2   3   4   5         6         7         8         9
    1   0   0   0   0   0   0 0.0526000 0.2281000  0.184200 0.3070000
    2   0   0   0   0   0   0 0.0531000 0.2301000  0.177000 0.3097000
    3   0   0   0   0   0   0 0.0005000 0.0020000 -0.007200 0.0027000
    4 NaN NaN NaN NaN NaN NaN 0.9505703 0.8768084 -3.908795 0.8794788
             10        11  12  13  14  15  16  17  18  19  20  21  22
    1 0.1579000 0.0702000   0   0   0   0   0   0   0   0   0   0   0
    2 0.1593000 0.0708000   0   0   0   0   0   0   0   0   0   0   0
    3 0.0014000 0.0006000   0   0   0   0   0   0   0   0   0   0   0
    4 0.8866371 0.8547009 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN

    $Bin101$IsEqual
    [1] FALSE


    $Bin106
    $Bin106$Data
        0   1   2   3   4   5      6      7      8   9     10  11     12
    1   0   0   0   0   0   0 0.0286 0.0571 0.2143 0.3 0.2429 0.1 0.0286
    2   0   0   0   0   0   0 0.0286 0.0571 0.2143 0.3 0.2429 0.1 0.0286
    3   0   0   0   0   0   0 0.0000 0.0000 0.0000 0.0 0.0000 0.0 0.0000
    4 NaN NaN NaN NaN NaN NaN 0.0000 0.0000 0.0000 0.0 0.0000 0.0 0.0000
          13  14  15  16  17  18  19  20  21  22
    1 0.0286   0   0   0   0   0   0   0   0   0
    2 0.0286   0   0   0   0   0   0   0   0   0
    3 0.0000   0   0   0   0   0   0   0   0   0
    4 0.0000 NaN NaN NaN NaN NaN NaN NaN NaN NaN

    $Bin106$IsEqual
    [1] TRUE


    $Bin111
    $Bin111$Data
        0   1   2   3   4   5   6   7      8      9     10     11     12
    1   0   0   0   0   0   0   0   0 0.1186 0.3051 0.4237 0.1017 0.0169
    2   0   0   0   0   0   0   0   0 0.1186 0.3051 0.4237 0.1017 0.0169
    3   0   0   0   0   0   0   0   0 0.0000 0.0000 0.0000 0.0000 0.0000
    4 NaN NaN NaN NaN NaN NaN NaN NaN 0.0000 0.0000 0.0000 0.0000 0.0000
          13  14  15  16  17  18  19  20  21  22
    1 0.0339   0   0   0   0   0   0   0   0   0
    2 0.0339   0   0   0   0   0   0   0   0   0
    3 0.0000   0   0   0   0   0   0   0   0   0
    4 0.0000 NaN NaN NaN NaN NaN NaN NaN NaN NaN

    $Bin111$IsEqual
    [1] TRUE


    $Bin116
    $Bin116$Data
        0   1   2   3   4   5   6   7      8      9     10     11     12
    1   0   0   0   0   0   0   0   0 0.1136 0.1818 0.1818 0.1591 0.1591
    2   0   0   0   0   0   0   0   0 0.1136 0.1818 0.1818 0.1591 0.1591
    3   0   0   0   0   0   0   0   0 0.0000 0.0000 0.0000 0.0000 0.0000
    4 NaN NaN NaN NaN NaN NaN NaN NaN 0.0000 0.0000 0.0000 0.0000 0.0000
          13     14     15     16  17  18  19  20  21  22
    1 0.0455 0.0909 0.0455 0.0227   0   0   0   0   0   0
    2 0.0455 0.0909 0.0455 0.0227   0   0   0   0   0   0
    3 0.0000 0.0000 0.0000 0.0000   0   0   0   0   0   0
    4 0.0000 0.0000 0.0000 0.0000 NaN NaN NaN NaN NaN NaN

    $Bin116$IsEqual
    [1] TRUE


    $Bin121
    $Bin121$Data
        0   1   2   3   4   5   6   7     8         9       10        11
    1   0   0   0   0   0   0   0   0 0.000  0.083300  0.11110  0.194400
    2   0   0   0   0   0   0   0   0 0.027  0.081100  0.10810  0.189200
    3   0   0   0   0   0   0   0   0 0.027 -0.002200 -0.00300 -0.005200
    4 NaN NaN NaN NaN NaN NaN NaN NaN   Inf -2.641056 -2.70027 -2.674897
             12        13        14       15        16  17  18  19  20  21  22
    1  0.138900  0.138900  0.138900  0.16670  0.027800   0   0   0   0   0   0
    2  0.135100  0.135100  0.135100  0.16220  0.027000   0   0   0   0   0   0
    3 -0.003800 -0.003800 -0.003800 -0.00450 -0.000800   0   0   0   0   0   0
    4 -2.735781 -2.735781 -2.735781 -2.69946 -2.877698 NaN NaN NaN NaN NaN NaN

    $Bin121$IsEqual
    [1] FALSE


    $Bin126
    $Bin126$Data
        0   1   2   3   4   5   6   7   8        9     10       11       12
    1   0   0   0   0   0   0   0   0   0 0.054100 0.0811 0.216200 0.135100
    2   0   0   0   0   0   0   0   0   0 0.055600 0.0833 0.222200 0.138900
    3   0   0   0   0   0   0   0   0   0 0.001500 0.0022 0.006000 0.003800
    4 NaN NaN NaN NaN NaN NaN NaN NaN NaN 2.772643 2.7127 2.775208 2.812731
            13       14       15     16        17       18       19       20
    1 0.054100 0.162200 0.054100 0.0811   0.08110 0.027000 0.027000 0.027000
    2 0.055600 0.166700 0.055600 0.0833   0.05560 0.027800 0.027800 0.027800
    3 0.001500 0.004500 0.001500 0.0022  -0.02550 0.000800 0.000800 0.000800
    4 2.772643 2.774353 2.772643 2.7127 -31.44266 2.962963 2.962963 2.962963
       21  22
    1   0   0
    2   0   0
    3   0   0
    4 NaN NaN

    $Bin126$IsEqual
    [1] FALSE


    $Bin131
    $Bin131$Data
        0   1   2   3   4   5   6   7   8   9       10       11       12
    1   0   0   0   0   0   0   0   0   0   0 0.088200 0.117600 0.147100
    2   0   0   0   0   0   0   0   0   0   0 0.090900 0.121200 0.151500
    3   0   0   0   0   0   0   0   0   0   0 0.002700 0.003600 0.004400
    4 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN 3.061224 3.061224 2.991162
            13       14       15       16        17       18  19       20  21
    1 0.117600 0.029400 0.117600 0.147100   0.11760 0.029400   0 0.088200   0
    2 0.121200 0.030300 0.121200 0.151500   0.09090 0.030300   0 0.090900   0
    3 0.003600 0.000900 0.003600 0.004400  -0.02670 0.000900   0 0.002700   0
    4 3.061224 3.061224 3.061224 2.991162 -22.70408 3.061224 NaN 3.061224 NaN
       22
    1   0
    2   0
    3   0
    4 NaN

    $Bin131$IsEqual
    [1] FALSE


    $Bin136
    $Bin136$Data
        0   1   2   3   4   5   6   7   8   9  10  11     12  13     14     15
    1   0   0   0   0   0   0   0   0   0   0   0   0 0.1154   0 0.2308 0.1538
    2   0   0   0   0   0   0   0   0   0   0   0   0 0.1154   0 0.2308 0.1538
    3   0   0   0   0   0   0   0   0   0   0   0   0 0.0000   0 0.0000 0.0000
    4 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN 0.0000 NaN 0.0000 0.0000
          16     17     18     19  20  21  22
    1 0.2308 0.1538 0.0385 0.0769   0   0   0
    2 0.2308 0.1538 0.0385 0.0769   0   0   0
    3 0.0000 0.0000 0.0000 0.0000   0   0   0
    4 0.0000 0.0000 0.0000 0.0000 NaN NaN NaN

    $Bin136$IsEqual
    [1] TRUE


    $Bin141
    $Bin141$Data
        0   1   2   3   4   5   6   7   8   9  10  11     12     13     14
    1   0   0   0   0   0   0   0   0   0   0   0   0 0.0286 0.0571 0.1429
    2   0   0   0   0   0   0   0   0   0   0   0   0 0.0286 0.0571 0.1429
    3   0   0   0   0   0   0   0   0   0   0   0   0 0.0000 0.0000 0.0000
    4 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN 0.0000 0.0000 0.0000
          15     16     17     18  19     20     21  22
    1 0.1429 0.2286 0.1714 0.1143   0 0.0857 0.0286   0
    2 0.1429 0.2286 0.1714 0.1143   0 0.0857 0.0286   0
    3 0.0000 0.0000 0.0000 0.0000   0 0.0000 0.0000   0
    4 0.0000 0.0000 0.0000 0.0000 NaN 0.0000 0.0000 NaN

    $Bin141$IsEqual
    [1] TRUE


    $Bin146
    $Bin146$Data
        0   1   2   3   4   5   6   7   8   9  10  11    12     13     14
    1   0   0   0   0   0   0   0   0   0   0   0   0 0.027 0.1081 0.1622
    2   0   0   0   0   0   0   0   0   0   0   0   0 0.027 0.1081 0.1622
    3   0   0   0   0   0   0   0   0   0   0   0   0 0.000 0.0000 0.0000
    4 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN 0.000 0.0000 0.0000
          15     16     17     18     19  20  21  22
    1 0.1622 0.1351 0.0541 0.1892 0.1622   0   0   0
    2 0.1622 0.1351 0.0541 0.1892 0.1622   0   0   0
    3 0.0000 0.0000 0.0000 0.0000 0.0000   0   0   0
    4 0.0000 0.0000 0.0000 0.0000 0.0000 NaN NaN NaN

    $Bin146$IsEqual
    [1] TRUE


    $Bin151
    $Bin151$Data
        0   1   2   3   4   5   6   7   8   9  10  11  12     13     14    15
    1   0   0   0   0   0   0   0   0   0   0   0   0   0 0.0435 0.1304 0.087
    2   0   0   0   0   0   0   0   0   0   0   0   0   0 0.0435 0.1304 0.087
    3   0   0   0   0   0   0   0   0   0   0   0   0   0 0.0000 0.0000 0.000
    4 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN 0.0000 0.0000 0.000
         16     17     18  19    20    21  22
    1 0.087 0.1304 0.3478   0 0.087 0.087   0
    2 0.087 0.1304 0.3478   0 0.087 0.087   0
    3 0.000 0.0000 0.0000   0 0.000 0.000   0
    4 0.000 0.0000 0.0000 NaN 0.000 0.000 NaN

    $Bin151$IsEqual
    [1] TRUE


    $Bin156
    $Bin156$Data
        0   1   2   3   4   5   6   7   8   9  10  11  12  13       14
    1   0   0   0   0   0   0   0   0   0   0   0   0   0   0 0.076900
    2   0   0   0   0   0   0   0   0   0   0   0   0   0   0 0.083300
    3   0   0   0   0   0   0   0   0   0   0   0   0   0   0 0.006400
    4 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN 8.322497
            15       16       17       18       19        20  21       22
    1 0.076900 0.153800 0.076900 0.153800 0.076900   0.30770   0 0.076900
    2 0.083300 0.166700 0.083300 0.166700 0.083300   0.25000   0 0.083300
    3 0.006400 0.012900 0.006400 0.012900 0.006400  -0.05770   0 0.006400
    4 8.322497 8.387516 8.322497 8.387516 8.322497 -18.75203 NaN 8.322497

    $Bin156$IsEqual
    [1] FALSE


    $Bin161
    $Bin161$Data
        0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15   16
    1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0 0.25
    2   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0 0.25
    3   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0 0.00
    4 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN 0.00
          17     18     19     20     21  22
    1 0.1667 0.1667 0.0833 0.1667 0.1667   0
    2 0.1667 0.1667 0.0833 0.1667 0.1667   0
    3 0.0000 0.0000 0.0000 0.0000 0.0000   0
    4 0.0000 0.0000 0.0000 0.0000 0.0000 NaN

    $Bin161$IsEqual
    [1] TRUE


    $Bin166
    $Bin166$Data
        0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15       16
    1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0.1250
    2   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0.1111
    3   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0  -0.0139
    4 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN -11.1200
       17       18       19      20  21  22
    1   0   0.1250   0.5000  0.2500   0   0
    2   0   0.1111   0.4444  0.3333   0   0
    3   0  -0.0139  -0.0556  0.0833   0   0
    4 NaN -11.1200 -11.1200 33.3200 NaN NaN

    $Bin166$IsEqual
    [1] FALSE


    $Bin171
    $Bin171$Data
        0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15      16
    1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0  0.1250
    2   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0  0.1429
    3   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0  0.0179
    4 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN 14.3200
            17      18       19  20  21  22
    1   0.2500  0.2500  0.37500   0   0   0
    2   0.1429  0.2857  0.42860   0   0   0
    3  -0.1071  0.0357  0.05360   0   0   0
    4 -42.8400 14.2800 14.29333 NaN NaN NaN

    $Bin171$IsEqual
    [1] FALSE


    $Bin176
    $Bin176$Data
        0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16
    1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    2   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    3   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    4 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
          17        18        19        20        21        22
    1 0.0000   0.16670   0.16670   0.33330   0.16670   0.16670
    2 0.1429   0.14290   0.14290   0.28570   0.14290   0.14290
    3 0.1429  -0.02380  -0.02380  -0.04760  -0.02380  -0.02380
    4    Inf -14.27714 -14.27714 -14.28143 -14.27714 -14.27714

    $Bin176$IsEqual
    [1] FALSE


    $Bin181
    $Bin181$Data
        0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17
    1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    2   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    3   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    4 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
          18  19     20  21     22
    1 0.3333   0 0.3333   0 0.3333
    2 0.3333   0 0.3333   0 0.3333
    3 0.0000   0 0.0000   0 0.0000
    4 0.0000 NaN 0.0000 NaN 0.0000

    $Bin181$IsEqual
    [1] TRUE


    $Bin186
    $Bin186$Data
        0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17
    1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    2   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    3   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    4 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
       18  19        20  21      22
    1   0   0   0.75000   0  0.2500
    2   0   0   0.66670   0  0.3333
    3   0   0  -0.08330   0  0.0833
    4 NaN NaN -11.10667 NaN 33.3200

    $Bin186$IsEqual
    [1] FALSE

To examine differences in the age-length keys, we ran fake data through both, and then compared the difference in frequency at age. Difference measured in direction wst\_alkey - alkey from length & age data found in 1973-1976 file (n = 1222). Fake length data was randomly generated, but this is fine since we are interested in the differences and not absolute counts at age.

The red line in the plot is set at y = 0, blue lines at 0.025 & -0.025.

![](WstAlKey_files/figure-markdown_github/PlotTestKeys-1.png)

<a href="#top">back to top</a>
\*\*\*
Report ran: 2017-04-11 12:47:06
End of report

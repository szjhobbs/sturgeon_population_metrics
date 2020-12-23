# ******************************************************************************
# Created: 31-May-2017
# Author:  J. DuBois
# Contact: jason.dubois@wildlife.ca.gov
# Purpose: This file contains code to calculate WST Petersen Abundance Estimates
#          as (M*C)/R. Code herein may eventually be moved to a .Rmd file for
#          ease of display and presentation on GitHub.
# ******************************************************************************

# NOTE: to date (01-Jun-2017) we have not recaptured a WST from release years 
# 2012 or 2013 or 2015; number of tags released in these years was low, so that
# may play into it

# TODO (01-Jun-2017):
# (2) for Recaps - decide on whether or not to include true within-season
#     recaptures (twsr) along with old
# (3) for Recaps - subset on length category (LenCat) or InSlot at release
# (4) figure out how to join C and R datasets according to proper year

# load data ---------------------------------------------------------------

SturgeonAll <- readRDS(file = "data/tagging/SturgeonAll.rds")

# libraries and source files ----------------------------------------------

# library(package)

source(file = "source/functions_pop_estimate.R")
source(file = "source/source_recaptures.R")

# variables: used throughout file -----------------------------------------

# section contains variable used within this file

# von Bertalanffy growth curve parameters (from Kohlhorst 1980)
vb_params <- list(Linf = 261.2, k = -0.04027, t0 = 3.638)

# create von Bertalanffy matrix to be used in assessing number of sturgeon
# captured that would have been legal sized in year Y given capture in Y+t,
# where t >= 1

# can set arguments as desired or set useDefault to TRUE to get 
# data/WSTVonBertMatrix.csv
WSTVonBertMatrix <- CreateVbMatrix(
  relYear = c(2016:2005, 2002:2001, 1998),
  minLen = 117,
  maxLen = c(rep(168, times = 10), rep(183, 5)),
  vbParams = vb_params
)

# gets matrix in data/WSTVonBertMatrix.csv
# WSTVonBertMatrix <- CreateVbMatrix(useDefault = TRUE)

# assessing recapture data ------------------------------------------------

# likely inaccurate (partial tag 2486 recaptured in 2014 cannot be positively
# matched to release tag)
Recaps[Recaps$DAL > 6000, ]

# removing tag RecTag 2486 - it was recaptured & only part of the tag number was
# recorded or could be read; tag was recaptured in 2014 & tag 2486 was released
# in 1968, making this a highly unlikely recap. So we remove this tag here.

Recaps <- subset(Recaps, subset = !(RecTag %in% "2486"))

# recaptures: cross-tab rel year x recap year -----------------------------

# subsetting DAL < 6000 removes the partial tag recovered in 2014 (tag 2486), 
# which matches with an impossible (given the length) 1968 release; might want
# to think about removing this tag earlier in the process
recap_xtab <- xtabs(
  ~ Rel.RelYear + RecYear,
  data = Recaps,
  subset = RecapType %in% c("old")
)

# for convenience when displaying
names(dimnames(recap_xtab)) <- c("Rel", "Rec")

# dim(recap_xtab)
# dimnames(recap_xtab)

# recaptures: dataframe from cross-tab ------------------------------------

recap_long <- as.data.frame(recap_xtab, stringsAsFactors = FALSE)

# to get recaptures per release year (rel or Rel)
recap_long_split_rel <- split(recap_long, f = recap_long[["Rel"]])

# number of recaptures per release year with N & cutoff year (year in which we 
# are not including anymore Rs or Cs); nZero = maximum allowable consecutive 0 
# (that is how many years will allow without a recap) -- adjust as needed;
# alternatively you can set a fixed number of year with setN & then nZero
# parameter is ignored
lst_recap_count <- lapply(recap_long_split_rel, FUN = GetRecapCount, nZero = 2)

# for better viewing
do.call(rbind, lst_recap_count)

vapply(lst_recap_count, FUN = function(x) x[["Value"]], FUN.VALUE = numeric(1L))

# clean up section
# rm()

# captures: calculating C in [M*C]/R --------------------------------------

# TODO: add coding for C (catch) values

# create matrix of catch, where colums are RelYear in WSTVonBertMatrix
mat_catch <- CatchMatrix(
  dat = SturgeonAll,
  len = TL,
  splitVar = RelYear,
  Species %in% "White" & !(RelYear %in% 1955),
  vbMatrix = WSTVonBertMatrix,
  params = vb_params
)

# 12-May-2017: tested function & output is accurate; differences between these 
# outputs and those of the past (e.g., 2011) may be due in part to how I was 
# subsettig the data in previous years. Am comfortable now functions herein are
# producing accurate results - J. DuBois
lst_catch <- apply(mat_catch[["CountMatrix"]], 2, FUN = GetFinalC, limitN = 5)



# marks: getting number of tagged fish ------------------------------------

# TODO: create function to get M and then combine all 3 in (M*C)/R


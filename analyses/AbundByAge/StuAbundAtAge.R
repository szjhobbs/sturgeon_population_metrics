# ******************************************************************************
# Created: 11-Apr-2016
# Author:  J. DuBois
# Contact: jason.dubois@wildlife.ca.gov
# Purpose: This file produces abundance at sturgeon age, particularly age-15 -
#          one of the metrics of the CVPIA. For this process, we currently
#          use age-length key WSTALKEY (the extant age-length key used by CDFW)
#          and abundance estimates by way of harvest (Card) and harvest rate
#          mark-recapture.
# ******************************************************************************

# TODO (J. DuBois, 15-Apr-2016): for lf dist decide whether or not to subset on
# ShedTag != Yes or Maybe & try to reconcile catch with WSTALKEY.xls (2006-2009)
# using various subsetting (i.e., understand where numbers are coming from)

# TODO (J. DuBois, 15-Apr-2016):  

# Background --------------------------------------------------------------

# we assign ages using age-length keys (alk)
# (1) alk developed with data from mostly 1970s (can be found in WSTALKEY.xls)
# (2) alk developed by USFWS who have aged sturgeon (some collected from CDFW
#     operations) starting in 2014

# we need to start first with a WST length frequency distribution then get age 
# frequency.

# add more here...

# File Paths --------------------------------------------------------------

# data_import <- "C:/Data/jdubois/RDataConnections/Sturgeon"

# Libraries and Source Files ----------------------------------------------

library(ggplot2)
# library(reshape)
# library(reshape2)

source(file = "../../RDataConnections/Sturgeon/OtherData.R")
source(file = "../../RDataConnections/Sturgeon/TaggingData.R")
source(file = "../../RSourcedCode/methods_len_freq.R")
source(file = "../../RSourcedCode/methods_age_freq.R")
source(file = "../../RSourcedCode/functions_global_data_subset.R")
# source(file = "source_stu_mark-recap.R")

# load .rds abundance data (NOTE: .rds file is saved in Analysis-AltAbundance,
# so run code therein to refresh this .rds file - last refreshed 15-Apr-2016)
AltAbundance <- readRDS("Analysis-AbundByAge/AltAbund.rds")

# Workspace Clean Up ------------------------------------------------------

# rm()

# Variables ---------------------------------------------------------------

# establish l-f breaks for WSTALKEY; note this alk uses TL not FL
#wst_alkey_breaks <- c(seq(from = 21, to = 186, by = 5), Inf)
wst_alkey_breaks <- c(wst_alkey$Bins, Inf)

# Length frequency: all sizes white sturgeon ------------------------------

# For now, lf below includes recaptured WST & WST recorded as shedding tag. Use 
# below in subset to further dial in lf dist for a particular subset of WST

# & !(ShedTag %in% c("Yes", "Maybe"))

# get length frequency distribution (from 2006-present for convenience) 
# including all WST (regardless of size or shed tag) but not recaptured WST
wst_lf <- GetLenFreq(
  dat = SturgeonAll,
  colX = TL,
  by = "RelYear",
  breaks = wst_alkey_breaks,
  #seqBy = 5,
  intBins = TRUE,
  subset = Species %in% "White" &
    RelYear > 2005 &
    # below removes recaptured WST
    StuType %in% c("Tag", "NoTag")
)

# just FIO
wst_lf$Breaks
wst_lf$Bins
wst_lf$Freq

# Length frequency: white sturgeon >= 85 cm TL ----------------------------

# NOTE: subsetting on >= 85 cm TL for use in getting at age-15 abundance. Alt
# abundance currently calculated using minimum WST length of >= 85 cm TL

# get length frequency distribution (from 2006-present for convenience) 
# including only WST >= 85 cm TL & *not* including recaptured WST (for now, this
# includes fish recorded as shedding tag)
wst_lf_85 <- GetLenFreq(
  dat = SturgeonAll,
  colX = TL,
  by = "RelYear",
  breaks = wst_alkey_breaks,
  #seqBy = 5,
  intBins = TRUE,
  subset = Species %in% "White" &
    # RelYear > 2005 & TL >= 85 &
    RelYear %in% c(2007:2014) & TL >= 85 &
    # below removes recaptured WST
    StuType %in% c("Tag", "NoTag")
)

# just FIO
wst_lf_85$Breaks
wst_lf_85$Bins
wst_lf_85$Freq
colSums(wst_lf_85$Freq)

# plot(wst_lf, lens = TL, fillBar = LenCat) + facet_grid(facets = RelYear ~ .)

# Length frequency: white sturgeon slot sized -----------------------------

# to compare abundance at age-15 when calculated using >= 85 cm TL sized fish or
# when using (as in this section) fish within the current slot limit

# get lf dist for fish within slot (117-168 cm TL)
wst_lf_slot <- GetLenFreq(
  dat = SturgeonAll,
  colX = TL,
  by = "RelYear",
  breaks = wst_alkey_breaks,
  #seqBy = 5,
  intBins = TRUE,
  subset = Species %in% "White" &
    # RelYear > 2005 & TL %in% 117:168 &
    RelYear %in% c(2007:2014) & TL %in% 117:168 &
    # below removes recaptured WST
    StuType %in% c("Tag", "NoTag")
)

# just FIO
wst_lf_slot$Breaks
wst_lf_slot$Bins
wst_lf_slot$Freq
colSums(wst_lf_slot$Freq)

# Age length key: create from other sources -------------------------------

# other sources in this case being 2014 USFWS data
GetRandomRows(wst_usfws_age_len)

# create usfws al key
wst_alk_usfws <- MakeALKey(
  dat = wst_usfws_age_len,
  len = TotalLength,
  age = Age,
  lenBreaks = wst_lf$Breaks,
  breakLabs = wst_lf$Bins,
  dia = TRUE
)

# convert wst_alk_usfws bins to integer for analytics to follow
wst_alk_usfws$Bins <- as.integer(as.character(wst_alk_usfws$Bins))

# confirm
typeof(wst_alk_usfws$Bins)

# Age frequency: all sizes white sturgeon ---------------------------------

# using different al keys get age frequency distribution for WST

# age frequency using extant CDFW age-length key
GetAgeFreq(
  lfTable = wst_lf$Freq,
  alk = wst_alkey,
  prop = FALSE
)

# age frequency using 2014(?) USFWS age-length key
GetAgeFreq(
  lfTable = wst_lf$Freq,
  alk = wst_alk_usfws,
  prop = FALSE
)

# Age frequency: white sturgeon >= 85 cm TL -------------------------------

# using different al keys get age frequency distribution for WST; for this
# purpose we get proportions of total (by year) for each age rather than count

# age frequency using extant CDFW age-length key
wst_af_cdfw <- GetAgeFreq(
  lfTable = wst_lf_85$Freq,
  alk = wst_alkey,
  prop = TRUE
)

# idea is to then multiply abundance by age freq proportions.
wst_af_cdfw[ , -1] * 100000

# age frequency using 2014(?) USFWS age-length key
wst_af_usfws <- GetAgeFreq(
  lfTable = wst_lf_85$Freq,
  alk = wst_alk_usfws,
  prop = TRUE
)

wst_af_usfws[ , -1] * 100000

# Age frequency: white sturgeon slot size ---------------------------------

# age frequency using extant CDFW age-length key
wst_af_cdfw_slot <- GetAgeFreq(
  lfTable = wst_lf_slot$Freq,
  alk = wst_alkey,
  prop = TRUE
)

# age frequency using data collected by USFWS
wst_af_usfws_slot <- GetAgeFreq(
  lfTable = wst_lf_slot$Freq,
  alk = wst_alk_usfws,
  prop = TRUE
)

# Abundance: at age -------------------------------------------------------

AltAbundance

# as alt abundance is segregated based on length category (sub, leg, ovr) we
# need to sum all values to get overall abundance
annual_abun <- aggregate(
  formula = N ~ Year,
  data = AltAbundance,
  FUN = sum
)

# age-15 abundance using fish >= 85 cm TL & CDFW age-length key
GetAbunAtAge(
  abun = annual_abun,
  af = wst_af_cdfw,
  age = 15
)

# age-15 abundance using fish >= 85 cm TL & USFWS age-length key
GetAbunAtAge(
  abun = annual_abun,
  af = wst_af_usfws,
  age = 15
)

# age-15 abundance using slot-sized fish & CDFW age-length key
GetAbunAtAge(
  abun = AltAbundance[AltAbundance$LenCat %in% "leg", c("Year", "N")],
  af = wst_af_cdfw_slot,
  age = 15
)

# age-15 abundance using slot-sized fish & USFWS age-length key
GetAbunAtAge(
  abun = AltAbundance[AltAbundance$LenCat %in% "leg", c("Year", "N")],
  af = wst_af_usfws_slot,
  age = 15
)

# some testing below can be deleted as we really cannot do abundance for all
# ages - sturgeon aren't fully recruited to out gear until ~ age-9
wst_af_cdfw[-c(1, 10), -1] * annual_abun$N

wifi[4:9] <- lapply(wifi[4:9], A)

wst_af_cdfw[-c(1, 10), -1] <- wst_af_cdfw[-c(1, 10), -1] * annual_abun$N

wst_af_usfws[-c(1, 10), -1] * annual_abun$N

# 

# TESTING: can be deleted at some point -----------------------------------

with(SturgeonAll[SturgeonAll$Species %in% "White" &
                   #SturgeonAll$StuType %in% c("Tag", "NoTag") &
                   !is.na(SturgeonAll$TL),], expr = {
  table(RelYear, ShedTag, useNA = "ifany")
})

SturgeonAll[SturgeonAll$RelYear %in% 2006 & SturgeonAll$ShedTag %in% c("Yes", "Maybe"),]

SturgeonAll[SturgeonAll$TagNum %in% "FF1191", ]


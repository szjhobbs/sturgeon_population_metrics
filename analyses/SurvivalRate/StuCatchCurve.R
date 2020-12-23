# ******************************************************************************
# Created: 17-Mar-2016
# Author:  J. DuBois
# Contact: jason.dubois@wildlife.ca.gov
# Purpose: This file creates all items associated with age frequency 
#          distributions of white sturgeon collected during CDFW tagging
#          operations and then using age distributions to create catch curves
#          to estimate survival; note: not performed on green sturgeon because
#          tagging operations don't encounter many green sturgeon
# ******************************************************************************

# TODO (J. DuBois, 17-Mar-2016): 

# Background --------------------------------------------------------------

# we assign ages using age-length keys (alk)
# (1) alk developed with data from mostly 1970s (can be found in WSTALKEY.xls)
# (2) alk developed by USFWS who have aged sturgeon (some collected from CDFW
#     operations) starting in 2014

# we need to start first with a length frequency distribution

# File Paths --------------------------------------------------------------

#data_import <- "C:/Data/jdubois/RDataConnections/Sturgeon"

# Libraries and Source Files ----------------------------------------------

library(ggplot2)
library(reshape)
#library(reshape2)
#library()

source(file = "../../RDataConnections/Sturgeon/OtherData.R")
source(file = "../../RDataConnections/Sturgeon/TaggingData.R")
source(file = "../../RSourcedCode/methods_len_freq.R")
source(file = "../../RSourcedCode/methods_age_freq.R")
source(file = "Analysis-CatchCurve/source_stu_cc.R")
#source(file = "source_stu_mark-recap.R")
#source(file = "../../RSourcedCode/functions_len_freq.R")

# Workspace Clean Up ------------------------------------------------------

#rm()

# Variables ---------------------------------------------------------------

# establish l-f breaks for WSTALKEY; note this alk uses TL not FL
#wst_alkey_breaks <- c(seq(from = 21, to = 186, by = 5), Inf)
wst_alkey_breaks <- c(wst_alkey$Bins, Inf)

# Length frequency --------------------------------------------------------

lf_wstalkey <- GetLenFreq(
  dat = SturgeonAll,
  colX = TL,
  by = "RelYear",
  breaks = wst_alkey_breaks,
  #seqBy = 5,
  intBins = TRUE,
  subset = Species %in% "White" &
    RelYear > 2005
)

# for now does include rescue fish of 2011
table(
  lf_wstalkey$Data$RelYear,
  lf_wstalkey$Data$Location,
  useNA = "ifany"
)

# Age frequency -----------------------------------------------------------

af_wst <- GetAgeFreq(lf = lf_wstalkey$Freq, alk = wst_alkey)

rowSums(af_wst[, -1])

data.frame(
  V1 = af_wst[, 1],
  n = round(rowSums(af_wst[, -1]), digits = 0),
  stringsAsFactors = FALSE
)

af_wst_melt <- melt(af_wst, id.vars = "RelYear", variable_name = "Age")

n_fish <- aggregate(value ~ RelYear, data = af_wst_melt, FUN = function(x) {
  round(sum(x), digits = 0)
})

# Age frequency: plot -----------------------------------------------------

ggplot(data = af_wst_melt, mapping = aes(x = Age, y = value)) +
  geom_bar(stat = "identity") +
  facet_wrap(facets = ~RelYear, ncol = 2)

# Catch curve -------------------------------------------------------------

ggplot(data = af_wst_melt, mapping = aes(x = Age, y = value)) +
  geom_point() +
  facet_wrap(facets = ~RelYear, ncol = 2, scales = "free_y") +
  scale_y_log10()

lm(log10(value) ~ as.numeric(as.character(Age)), data = af_wst_melt)

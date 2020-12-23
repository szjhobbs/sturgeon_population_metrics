# ******************************************************************************
# Created: 28-Mar-2016
# Author:  J. DuBois
# Contact: jason.dubois@wildlife.ca.gov
# Purpose: This file calculates alternative abundance estimates for White
#          Sturgeon (WST) using harvest (from Card data) and harvest rate
#          estimate (from mark-recapture data). 
#
#          Two aspects of this process are as follows:
#          (1) Getting Card data for various period rather than by calendar year
#          (2) Getting harvest rate for legal-sized WST
# ******************************************************************************

# Information -------------------------------------------------------------

# Steps provided herein calculate alternative abundance estimates of White 
# Sturgeon (WST; alternative to mark-recapture estimates per the Petersen method).
# The alternative method uses harvest from Card data and harvest rate from
# mark-recapture data.

# Estimates are calculated directly for legal-sized WST (leg) & indirectly for 
# sub-legal WST (sub) and over-legal WST (ovr). The indirect approach uses 
# ratios of proportions of each category (sub, leg, ovr) from mark-recapture 
# (tagging) data collected (typically) August-October each year. Using tagging 
# data, we categorized each WST (as sub, leg, ovr) based on length at tagging. 
# Proportions for each category were calculated based on the total (sub + leg + 
# ovr) not including WST with no length (i.e., those that could not be placed 
# into a size category). NOTE: for this exercise, we have made no adjustment to
# catch based on gear selectvity. Proportions of sub, leg, & ovr are based on
# straight catch.

# Libraries and Source Files ----------------------------------------------

library(ggplot2)
#library(reshape2)

# loads all Card Data (ALDS from 2012 to present & 2007-2011); loads all tagging
# data of releases and angler tag returns - needed for reconciliaton process
source(file = "../../RDataConnections/Sturgeon/CardData07.R", echo = TRUE)
source(file = "../../RDataConnections/Sturgeon/TaggingData.R", echo = TRUE)
source(file = "../../RDataConnections/Sturgeon/CardDataAlds.R", echo = TRUE)
source(file = "../../RSourcedCode/functions_global_general.R")
source(file = "Analysis-AltAbundance/source_alt_abundance.R")

# Step 1: combine ALDS and archived data ----------------------------------

# this section combines the ALDS and archived (2007-2011) data

card_alds <- subset(
  StuCardAll,
  select = -MonthF
)

# adds Document (or Card) number - needed for reconciliation with tag return
# data
card_alds <- merge(
  card_alds,
  ReturnedCards[, c("LicenseReportID", "DocumentNumber")],
  by = "LicenseReportID"
)

# adding date field for rbind()ing with 07 data
card_alds$DateOfCapture <- as.POSIXct(
  paste(
    card_alds$ItemYear,
    card_alds$Month,
    card_alds$Day,
    sep = "-"
  ),
  format = "%Y-%m-%d"
)

# subsetting & ordering for rbind()ing below
card_alds <- card_alds[, c(11, 3, 12, 6, 9, 10, 7, 8)]

card_arch <- subset(
  SturgeonsCards07,
  select = -c(SturgeonID, CorR)
)

# set column names equal for rbind()ing
colnames(card_arch) <- colnames(card_alds)

card_all <- rbind(
  card_arch,
  card_alds
)

# clean up
rm(card_arch, card_alds)

# Step 2: get needed stats for estimates ----------------------------------

# adding year field for convenience
Effort$RelYear <- as.numeric(format(Effort$RelDate, "%Y"))

# rescue locations from April 2011 which we don't want for this analysis
drop_locations <- c("Fremont Weir", "Tisdale Bypass")

# get start, mid, and end dates
dates <- ApplyFunToDf(
  Effort,
  !(Location %in% drop_locations) &
    RelYear > 2005,
  splitVars = "RelYear",
  FUN = TaggingDates
)

# get length category stats for White Sturgeon from 2006-present (added
# 05-Apr-2016 total length cutoff in keeping with IEP article "Estimating Annual
# Abundance of White Sturgeon 85-116 and ≥ 169 Centimeters Total Length")
lc_stats <- ApplyFunToDf(
  SturgeonAll,
  Species %in% "White" & RelYear > 2005 & TL >= 85,
  splitVars = "RelYear",
  FUN = GetLcStats
)

# clean up
rm(drop_locations)

# Step 3: calculate abundance estimates -----------------------------------

# calculate alternative abundance estimates for White Sturgeon from
# 2007-present; output is a list so use GetAltAbundance() for cleaner display of
# abundance estimates with CIs
alt_abundance <- CalcAltAbundance(
  datHarvest = GetWstCount(datCard = card_all, dates = dates),
  datLcStats = lc_stats
)

# tabular display of annual stats (e.g., harvest rate, tag returns) along with
# abundance estimates with Wald-type CIs and log-normal based CIs
GetAltAbundance(dat = alt_abundance)

# save abundance for Analysis-AbundByAge (must be re-saved when data is updated
# (i.e., ~ annually))
saveRDS(
  object = GetAltAbundance(dat = alt_abundance)$Abundance,
  file = "Analysis-AbundByAge/AltAbund.rds"
)

# write.csv(
#   alt_abundance$HR,
#   file = "Analysis-AltAbundance/HRAll.csv"
# )

# Plotting: abundance with confidence intervals ---------------------------

# possilbe plotting option (change data source)
# ggplot(data = abnd$Abundance, mapping = aes(x = Year, y = N)) +
#   geom_bar(
#     mapping = aes(fill = LenCat),
#     position = "dodge",
#     stat = "identity"
#   )

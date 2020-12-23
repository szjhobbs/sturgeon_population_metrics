# ******************************************************************************
# Created: 16-Mar-2016
# Author:  J. DuBois
# Contact: jason.dubois@wildlife.ca.gov
# Purpose: This file creates all items associated with length frequency
#          distributions of sturgeon collected during CDFW tagging operations
# ******************************************************************************

# TODO (J. DuBois, 17-Mar-2016): format wst l-f plot; try to move facet labels
# to y2 axis allowing more room for data; continue to format theme in source
# file

# File Paths --------------------------------------------------------------

#data_import <- "C:/Data/jdubois/RDataConnections/Sturgeon"

# Libraries and Source Files ----------------------------------------------

library(ggplot2)
#library(reshape2)
#library()

source(file = "../../RDataConnections/Sturgeon/TaggingData.R")
source(file = "../../RSourcedCode/methods_len_freq.R")
source(file = "Analysis-LengthFreq/source_stu_lf.R")
#source(file = "source_stu_mark-recap.R")
#source(file = "../../RSourcedCode/functions_len_freq.R")

# Workspace Clean Up ------------------------------------------------------

#rm()

# Variables ---------------------------------------------------------------

# FIO about length range and count
sapply(X = split(SturgeonAll, SturgeonAll[, c("RelYear", "Species")],
                 drop = TRUE), FUN = function(x) {
                   range(x$FL, na.rm = TRUE)
                 }, simplify = FALSE)

# FIO
with(data = SturgeonAll, expr = {
  length(FL[FL %in% c(145:149) & !is.na(FL) &
              RelYear %in% 2006 & Species %in% "White"])
})

# set min release year for l-f dist (tabular and plot)
rel_year <- 2005

# set length breaks
#wst_fl_breaks <- SeqBreaks(from = 35, to = 180, by = 5, includeInf = TRUE)
#gst_fl_breaks <- SeqBreaks(from = 45, to = 180, by = 3, includeInf = TRUE)

# other options for length breaks
#wst_fl_breaks <- c(0, seq(from = 55, to = 180, by = 6), Inf)
#wst_fl_breaks2 <- c(seq(from = 35, to = 200, by = 5))
#gst_fl_breaks <- c(seq(from = 45, to = 180, by = 3), 197)
#wst_tl_breaks <- c(seq(from = 21, to = 186, by = 5), Inf) # WSTALKEY

# Analytics: annual length frequency --------------------------------------

lf_wst <- GetLenFreq(
  dat = SturgeonAll,
  colX = FL,
  by = "RelYear",
  breaks = NULL,
  seqBy = 5,
  intBins = FALSE,
  subset = Species %in% "White" &
    RelYear > 2005
)

lf_wst$DescStats

lf_gst <- GetLenFreq(
  dat = SturgeonAll,
  colX = FL,
  by = "RelYear",
  breaks = NULL,
  seqBy = 5,
  intBins = FALSE,
  subset = Species %in% "Green" &
    RelYear > 2005
)

lf_gst$DescStats

# Plotting: white stureon length frequency --------------------------------

# converting to factor for fill(ing) in plot below
lf_wst$Data$InSlot <- factor(
  lf_wst$Data$InSlot ,
  levels = c(1, 0)
)

# displaying tabular data FIO
print(lf_wst$FreqFraction, digits = 4, quote = FALSE)
lf_wst$MaxPercent

# create plot (using fraction of total - POT)
lf_wst_plot <- plot(
  lf = lf_wst,
  lens = FL,
  fillBar = InSlot,
  type = "POT",
  addMed = TRUE,
  addN = TRUE
)

# formatting plot and arranging facets (RelYear)
lf_wst_plot +
  facet_wrap(facets = ~RelYear, ncol = 2) + #, switch = "y"
  scale_fill_manual(
    "In Slot",
    values = c('1' = "black", '0' = "grey50"),
    labels = c('1' = 'Y', '0' = 'N')
  ) +
  xlab("Fork length (cm)") #+
  #theme_stu_lf

# Plotting: green stureon length frequency --------------------------------

# gst l-f likely not all that useful as we just don't catch many gst and catch
# varies wildly from year-to-year

# create gst length frequency plot
lf_gst_plot <- plot(
  lf = lf_gst,
  lens = FL,
  fillBar = NULL,
  type = "POT",
  addMed = TRUE,
  addN = TRUE
)

# formatting and facetting
lf_gst_plot +
  facet_wrap(facets = ~RelYear, ncol = 2) + #, switch = "y"
  xlab("Fork length (cm)") #+
#theme_stu_lf

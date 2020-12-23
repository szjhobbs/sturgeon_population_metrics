# ******************************************************************************
# Created: 04-May-2016
# Author:  J. DuBois
# Contact: jason.dubois@wildlife.ca.gov
# Purpose: This file is for demonstrating how previous biologists developed the
#          age-length key for WST (as in WSTALKEY.xls). I found data that looks
#          to be that used to develop this key and herein will explore this data
#          to confirm or dismiss my hunch.
# ******************************************************************************

# load libraries
library(ggplot2)
library(dplyr)

# Load data ---------------------------------------------------------------

# get age-length (al) data from yesteryear (saved as a .txt file because saving
# to .csv was raising some error for reasons unknown)
old_al_data <- read.table(
  file = "../1_NonDbData/WstAgeLenData.txt",
  header = TRUE,
  sep = "\t", 
  # colClasses = c(
  #   "character", "integer", "POSIXct", "double",
  #   "double", rep("integer", 7), "double",
  #   "integer"
  # ),
  col.names = c(
    "ID", "Species", "Date", "FL", "TL", "Sex", "CapMethod",
    "Location", "Age", "YearClass", "Check", "Age_1", "TLen",
    "NewAge"
  ),
  stringsAsFactors = FALSE
)

# Checking some data ------------------------------------------------------

str(old_al_data)
range(old_al_data$Date)
table(old_al_data$Loc, useNA = "ifany") # change variable as needed

# fields are the same
identical(old_al_data$Age, old_al_data$Age_1)
identical(old_al_data$TL, old_al_data$TLen)

# fields NOT the same
identical(old_al_data$Age, old_al_data$NewAge)

# using age to develop al key - need to combine all fish > age-22 to age-22
# (this is per design of WSTALKEY)
old_al_data$Age[old_al_data$Age > 22] <- 22

# check - should now be FALSE
identical(old_al_data$Age, old_al_data$Age_1)

# trying conversion to observe effect
# old_al_data$TL <- round(old_al_data$TL, digits = 0)
# old_al_data$TL <- as.integer(old_al_data$TL)
# old_al_data$TL <- old_al_data$TL - 0.01

# Create al key with extant (1973-1976) data ------------------------------

wst_alkey_check <-  MakeALKey(
  dat = old_al_data,
  len = TL,
  age = Age,
  lenBreaks = wst_alkey_breaks,
  breakLabs = wst_alkey_breaks[-35],
  dia = FALSE
)

# convert wst_alk_usfws bins to integer for analytics to follow
wst_alkey_check$Bins <- as.integer(as.character(wst_alkey_check$Bins))

# compare with WSTALKEY (tab 'A' in WSTALKEY.xls) - as of now still yielding
# FALSE even with rounding to appropriate number of digits
identical(
  x = wst_alkey,
  y = round(wst_alkey_check, 4)
)

wst_alkey - round(wst_alkey_check, 4)

# Analysis of ALKEY differences: bin by bin -------------------------------

# for looping through sapply below
rows <- 1:nrow(wst_alkey)

# to compare each line (bin) of wst_alkey with the newly-created alkey
lst_diff <- sapply(X = rows, FUN = function(x) {
  res <- rbind(
    wst_alkey[x, ],
    round(wst_alkey_check[x, ], digits = 4)
  )
  
  res <- rbind(res, res[1, ] - res[2, ])
  
  list(
    Data = res,
    Good = all(res[1, ] - res[2, ] == 0)
  )
  
}, simplify = FALSE)

# ideally would yield number equivalent to number of bins (n=34) but only yields
# 20, so 14 bins of newly-created alkey to not "align" with extant WSTALKEY
sum(
  sapply(X = rows, FUN = function(x) {
    lst_diff[[x]]$Good
  })
)

# Mean length at age ------------------------------------------------------

mean_len_age <- old_al_data %>%
  group_by(Age) %>%
  select(Age, TL) %>%
  do(GetDescStats(.$TL))

# More analysis of differences --------------------------------------------

old_al_data[old_al_data$TLen >=176 & old_al_data$TLen <= 180.3000, ]
old_al_data[old_al_data$TLen >=76 & old_al_data$TLen <= 80, ]
old_al_data[old_al_data$TLen >=181, ]

test <- old_al_data[old_al_data$TLen >=101 & old_al_data$TLen <= 105, ]
old_al_data[old_al_data$Age %in% 18, ]

table(
  cut(
    old_al_data$TL,
    breaks = wst_alkey_breaks,
    include.lowest = FALSE,
    right = FALSE
  ),
  old_al_data$Age,
  useNA = "ifany"
)

old_al_data$TL[old_al_data$TL %% 1 > 0]

length(old_al_data$ID[old_al_data$ID < 0])

# more tinkering
table(
  format(
    as.Date(
      old_al_data$Date,
      format = "%m/%d/%y"
    ), "%Y"
  ),
  useNA = "ifany"
)

# experimenting with cut() function
cut(
  c(25.9, 26),
  breaks = wst_alkey_breaks - 0.1,
  include.lowest = FALSE,
  right = F
)

# Plotting: exploratory ---------------------------------------------------

ggplot(data = old_al_data, mapping = aes(x = Age, y = TL, group = Age)) +
  geom_boxplot() #+
  # facet_grid(facets = Location ~ .)

ggplot(data = old_al_data, mapping = aes(x = YearClass, y = Check)) +
  geom_point() 

ggplot(data = old_al_data, mapping = aes(x = TL)) +
  # geom_histogram(breaks = wst_alkey_breaks[-35]) 
  geom_histogram(binwidth = 5) 

ggplot(data = old_al_data, mapping = aes(x = Age, y = TL)) +
  geom_smooth() +
  stat_summary(fun.y = mean, geom = "point") +
  geom_line(mapping = aes(y = 261.2 * (1 - exp(-0.04027 * (Age + 3.638)))), colour = "red")


plot(261.2 * (1 - exp(-0.04027 * (0:100 + 3.638))))

# Fitting von Bertalanffy curve -------------------------------------------

# Kohlhorst et al. (1980) fitted White Sturgeon age-length data (collected
# 1973-1976) to the von Bertalanffy growth curve. Below, I will attempt to
# recreate the model fit to better understand the model parameters.

# (1) using non-linear least squares (nls)
# (2) von Bertalanffy growth curve (vbgc) =
#     len_inf * (1 - (exp(-k * (ages - t0))))

mod_vb_cdfw <- nls(
  formula = TLen ~ a * (1 - (exp(-b * (Age - c)))),
  data = old_al_data,
  start = list(
    a = 200,
    b = 0.05,
    c = 0
  )
)

summary(mod_vb_cdfw)

mod_vb_usfws <- nls(
  formula = TotalLength ~ a * (1 - (exp(-b * (Age - c)))),
  data = wst_usfws_age_len,
  start = list(
    a = 200,
    b = 0.05,
    c = 0
  )
)

summary(mod_vb_usfws)

plot(mod_vb_usfws$m$resid())





ggplot(data = old_al_data, mapping = aes(x = Age, y = TLen, group = Age)) +
  geom_point(alpha = 1/5, size = 3)# +
  # geom_boxplot()










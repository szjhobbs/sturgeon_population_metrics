###tagging-season report script
###By Jim Hobbs
###11/4/2020

###Hobbs attempting to recreat the tagging-season.Rmd in tidy-R



# sportfish currently available on GitHub
library(sportfish)
library(tidyr)
library(here)


###setting graphics 
par(
  # bg = "white",
  # fg = "black",
  # col = "grey70",
  # mar: c(bottom, left, top, right)
  # mar = c(4, 4, 1, 1) + 0.1
  # mar = c(5, 6, 1, 1),
  # cex.axis = 1.5,
  # cex.lab = 1.5,
  col.axis = "grey40",
  col.lab = "black",
  # las = 1,
  bty = "n",
  mgp = c(3, 0.75, 0),
  tcl = -0.3,
  lend = 1
)


###load the data, data are stored as .rds files here
###U:\SportFish\Staff Files\JDuBois\0_RProjects\SturgeonPopMetrics\data\tagging











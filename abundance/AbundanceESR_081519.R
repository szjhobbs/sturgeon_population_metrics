
path <- "U:/Public/SportFish/EnhancedStatusReport/WhiteStuESRData.xlsx"

dat <- readxl::read_xlsx(path = path, sheet = "abundance")

library(sportfish)

vars <- with(data = dat, expr = {
  boolPet <- Year >= 1979 & Year <= 2006
  boolDFW <- Year >= 2007
  
  rangeX <- c(1979, 2018)
  rangeY <- range(
    Petersen[boolPet] + PetersenCI[boolPet],
    Petersen[boolPet] - PetersenCI[boolPet], 
    na.rm = TRUE
  )
  
  list(
    boolPet = boolPet,
    boolDFW = boolDFW,
    rangeX = rangeX,
    rangeY = rangeY
  )
  
})

par(
  # bg = "white",
  # fg = "black",
  # col = "grey70",
  # mar: c(bottom, left, top, right)
  # mar = c(4, 4, 1, 1) + 0.1
  mar = c(5, 6, 1, 1),
  cex.axis = 1.5,
  cex.lab = 1.5,
  col.axis = "grey40",
  col.lab = "black",
  las = 1,
  bty = "n",
  mgp = c(3, 0.75, 0),
  tcl = -0.3,
  lend = 1
)



plot(
  x = vars[["rangeX"]],
  y = vars[["rangeY"]],
  type = "n",
  xaxt = "n",
  yaxt = "n",
  xlab = "Year",
  ylab = NA,
  xlim = vars[["rangeX"]] + c(0.5, -0.5)
)

# par("xaxp")[1:2]

par(xaxp = c(1979, 2018, diff(vars[["rangeX"]])))

y_axis_ticks <- axTicks(side = 2)
custom_y <- AxisFormat(y_axis_ticks)

grid(lwd = 1000, col = "grey90")
grid(lty = 1, col = "white", lwd = 1)

par("xaxp")


segments(
  x0 = dat[vars[["boolPet"]], "Year", drop = TRUE],
  y0 = unlist(dat[vars[["boolPet"]], "Petersen"] - dat[vars[["boolPet"]], "PetersenCI"]),
  y1 = unlist(dat[vars[["boolPet"]], "Petersen"] + dat[vars[["boolPet"]], "PetersenCI"])
)

segments(
  x0 = dat[vars[["boolDFW"]], "Year", drop = TRUE],
  y0 = unlist(dat[vars[["boolDFW"]], "CDFW"] - dat[vars[["boolDFW"]], "CDFW-CI"]),
  y1 = unlist(dat[vars[["boolDFW"]], "CDFW"] + dat[vars[["boolDFW"]], "CDFW-CI"])
)

points(
  formula = Petersen ~ Year,
  data = dat,
  subset = vars[["boolPet"]],
  pch = 21, bg = "white"
)

points(
  formula = CDFW ~ Year,
  data = dat,
  subset = vars[["boolDFW"]],
  pch = 22, bg = "grey20"
)

axis(
  side = 1,
  at = (1979:2018)[(1979:2018) %% 5 == 0],
  labels = (1979:2018)[(1979:2018) %% 5 == 0],
  tcl = -0.3,
  col = "transparent",
  col.ticks = "grey30"
)

axis(
  side = 2,
  at = axTicks(side = 2),
  labels = custom_y[["Labels"]],
  tcl = -0.3,
  col = "transparent",
  col.ticks = "grey30",
  las = 1
)

mtext(text = custom_y$AxisTitle("Abundance (N) "), side = 2, line = 2, las = 3, cex = 1.5)

legend(
  ncol = 2,
  x = 1980, y = 510000,
  legend = c("Petersen", "CDFW"),
  pch = c(21, 22),
  pt.bg = c("white", "grey20"),
  xpd = TRUE, bty = "n"
)

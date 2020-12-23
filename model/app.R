
# non-CRAN package installation -------------------------------------------

# need to install from github not source for `spopmodel` to be recognized for
# publishing app; uncomment below & run after making any changes to `spopmodel`

# devtools::install_github(repo = "jasondubois/spopmodel")

# libraries ---------------------------------------------------------------

library(shiny)
library(spopmodel)

# server & application ----------------------------------------------------

server <- function(input, output) {
  
  par_set <- par(
    mar = c(3, 3, 0.75, 0.25), 
    oma = c(0.25, 0.25, 0.25, 0.25), 
    mgp = c(1.75, 0.5, 0)
  )

  # data source -----------------------------------------------------------
  
  # retrieve data from user's selection; d will now be trammel_catch from
  # `spopmodel` - may need some try-catch block if unable to retrieve
  dd <- get(isolate(expr = { input$data_source }))
  
  d <- reactive({
    # dd <- get(input$data_source)
    
    bool_gte190 <- dd[["FL"]] >= 190
    bool_ageNA <- is.na(dd[["Age"]])
    dd[bool_gte190 & bool_ageNA, "Age"] <- 19

    # clean up (not needed)
    rm(bool_gte190, bool_ageNA)
    
    # range_fl <- range(dd[["FL"]])
    range_fl <- c(50, 220)
    
    # if (input$selectivity %in% "no") return(head(dd))
    if (input$selectivity %in% "no") return(dd)
    
    # otherwise apply Millar's selectivity model
    split_fl_mesh <- split(dd[["FL"]], f = dd[["MeshSize"]])
    
    freq <- lapply(
      split_fl_mesh,
      FUN = Frequency,
      binWidth = 5,
      xRange = range_fl
    )
    
    # expand length bins by counts
    freq_exp <- lapply(freq, FUN = function(x) {
      n <- length(x[["breaks"]])
      # tms <- x[["counts"]]
      # tms[tms <= 0 | is.na(tms)] <- 1
      rep(x[["breaks"]][-n], times = x[["counts"]])
      # rep(x[["breaks"]][-n], times = tms)
    })
    
    # for repeating mesh size in dataframe needed for ApplyNetFit
    n <- vapply(freq_exp, FUN = length, FUN.VALUE = numeric(1L))

    # creates dataframe needed by ApplyNetFit() & bins lengths as above; if not
    # needing binned lengths, then just use trammel_net as data supplied to
    # ApplyNetFit(); Blackburn applied gear selectivity models on length binned
    # by 5 cm
    mesh_data_temp <- data.frame(
      Mesh = rep(as.numeric(names(freq_exp)), times = n),
      FL = unlist(freq_exp, use.names = FALSE),
      stringsAsFactors = FALSE
    )
    
    apply_net_fit <- ApplyNetFit(
      data = mesh_data_temp,
      len = FL,
      mesh = Mesh,
      relPower = c(1, 1, 2)
    )
    
    # lowest deviance is desired
    model_deviance <- DeviancePlots(apply_net_fit)
    
    deviance_values <- vapply(model_deviance, FUN = function(x) {
      x["Deviance", ]
    }, FUN.VALUE = numeric(1L))
    
    # model_chosen <- names(which.min(deviance_values)); for now hard code to be
    # in-line with S. Blackburn's chosen model (22-Jul-2020)
    model_chosen <- "binorm.sca"
    
    # print(deviance_values)
    
    rr <- RelativeRetention(apply_net_fit, standardize = FALSE)[[model_chosen]]
    # print(mesh_data_temp)
    
    # for overall relative retention not just by mesh size
    rr_row_sums <- rowSums(rr[["Data"]][2:4])
    
    rr_stand <- rr_row_sums / max(rr_row_sums)
    # print(rr_stand)
    # print(table(mesh_data_temp[["FL"]]))
    
    # S. Blackburn's relative retention values from `size_selective_data.xlsx`,
    # tab `bi.norm`, column F
    sb <- c(
      0.49157779, 0.57460823, 0.65848795, 0.73990818, 0.81535366,
      0.88137855, 0.93489596, 0.97344113, 0.99537404, 1.00000000,
      0.98759057, 0.95931149, 0.91706928, 0.86330595, 0.80077257,
      0.73230331, 0.66062285, 0.58819520, 0.51712572, 0.44910702,
      0.38541133, 0.32691128, 0.27412252, 0.22725779, 0.18628429,
      # 0.15098010, 0.12098581, 0.09585021, 0.07506861, 0.05811487,
      0.15098010, 0.12098581, 0.07506861, 0.04446646, 0.01854676
    )
    
    freq_bin <- rowSums(rr[["Freq"]])
    freq_adj <- freq_bin / rr_stand
    # freq_adj <- freq_bin / sb
    # print(cbind(rr[["Data"]][[1]], freq_bin, sb))
    
    # print(rr_stand)
    
    # names(freq_adj) <- rr[["Data"]][[1]]
    
    # to get expanded data for additional processing outside this function
    res <- with(data = dd, expr = {
      
      Age[is.na(Age)] <- -1
      
      # bw <- spopmodel:::BinWidth(w = 5)
      
      out <- aggregate(
        MeshSize,
        by = list(Age = Age, FL = FL),
        FUN = length,
        drop = TRUE
      )
      
      out$Bins <- spopmodel:::CreateLenBins(
        len = out[["FL"]],
        # lenBreaks = bw(out[["FL"]]),
        lenBreaks = seq(from = range_fl[1], to = range_fl[2], by = 5),
        numericBin = TRUE
      )
      
      splt <- split(out[["x"]], f = out["Bins"])
      
      out$Prop <- unlist(lapply(splt, FUN = prop.table), use.names = FALSE)
      out
    })
    
    res$Age[res[["Age"]] %in% -1] <- NA
    
    # i <- match(res$Bins, table = names(freq_adj))
    i <- match(res$Bins, table = rr[["Data"]][[1]])
    
    # res$Adj <- freq_adj[i]
    # new_n <- ceiling(freq_adj[i] * res[["Prop"]])
    new_n <- floor(freq_adj[i] * res[["Prop"]])
    # print(new_n)
    # new_n[is.na(new_n)] <- 1
    res <- lapply(res, FUN = rep, times = new_n)
    res <- as.data.frame(res)[c("Age", "FL")]
    
    # range_fl <- range(dd[["FL"]])
    # len_breaks <- seq(from = range_fl[1], to = range_fl[2], by = 5)
    
    # # breaks are all identical for three mesh sizes
    # alk <- MakeALKey(
    #   data = dd,
    #   len = FL,
    #   age = Age,
    #   lenBreaks = freq[["6"]][["breaks"]]
    # )
    
    # clean up
    rm(n, mesh_data_temp)
    # colSums(alk * freq_adj, na.rm = TRUE) %/% 1
    # list(
    #   freq[["6"]][["breaks"]],
    #   rr[["Data"]]
    # )
    # table(mesh_data_temp$FL, useNA = "ifany")
    # dim(alk)
    # rr[["Data"]]
    # freq_bin
    # freq_adj
    # list(
    #   vapply(dd, FUN = function(x) {
    #     mean(is.na(x))
    #   }, FUN.VALUE = numeric(1L)),
    #   vapply(res, FUN = function(x) {
    #     mean(is.na(x))
    #   }, FUN.VALUE = numeric(1L))
    # )
    
    res
    
  })
  # end d()
  
  # for now testing in summary but will need new tab
  # output$summary <- renderPrint(expr = { print(d()) })

  # default age for very large fish ---------------------------------------
  
  # assigns age 19 to any fish greater than 190 cm FL with no age; there are
  # very few fish like this in this dataset & doing this helps when applying
  # AgeEach() or age-length key (i.e., no un-aged length bins)
  
  # bool_gte190 <- d()[["FL"]] >= 190
  # bool_ageNA <- is.na(d()[["Age"]])
  # d()[bool_gte190 & bool_ageNA, "Age"] <- 19
  # 
  # # clean up (not needed)
  # rm(bool_gte190, bool_ageNA)

  # option to apply gear selectivity models -------------------------------

  # for now moved to `data source`

  # length frequency ------------------------------------------------------
  len_freq <- reactive({
    Frequency(d()[["FL"]], binWidth = 5, xRange = c(50, 220))
  })
  # output$distPlot <- renderPlot(expr = { plot(len_freq(), xlab = "Length") })
  # output$summary <- renderPrint(expr = { print(len_freq()) })

  # age frequency ---------------------------------------------------------
  ages <- reactive({
    AgeEach(
      data = d(),
      len  = FL,
      age  = Age,
      lenBreaks = len_freq()[["breaks"]]
    )
  })
  # end ages
  
  # age_freq <- reactive( {table(ages()[["Ages"]], dnn = NULL)} )
  age_freq <- reactive({
    
    if (input$sb == "no") return(table(ages()[["Ages"]], dnn = NULL))
    
    # Blackburn's data from: size_selective_data.xlsx | tab Abundance | column B
    r <- c(
      45.23, 52.95, 127.91, 121.55, 164.19, 181.24, 136.04,
      71.53, 52.50, 33.52, 91.78, 55.50, 105.02, 7.04, 90.93,
      20.66, 65.64
    )
    names(r) <- 3:19
    r
  })
  # end age_freq
  
  # plot age frequency
  output$ageFreqPlot <- renderPlot(expr = {
    par(par_set)
    
    y <- as.vector(age_freq())
    
    plot(
      x = as.numeric(names(age_freq())),
      y = y,
      type = "h",
      col = "grey50",
      lwd = 5,
      lend = 1,
      las = 1,
      ylab = "Frequency",
      xlab = "Age",
      ylim = c(0, max(y))
    )
    # end plot
    
    mtext(
      text = sprintf(fmt = "n=%.0f", sum(y)), 
      side = 1, 
      line = 1.5, 
      adj = 1,
      font = 3
    )
    
  })
  # end output$ageFreqPlot

  # mean length at age ----------------------------------------------------

  # get mean-length-at-age given lengths with assigned ages
  mean_len_age <- reactive({
    
    # mean-length-at-age using data from d()
    r <- aggregate(d()[["FL"]], by = d()["Age"], FUN = mean)
    colnames(r)[2] <- "MeanFL"
    
    if (input$sb == "no") return(r)
    
    # Blackburn's data from: size_selective_data.xlsx | tab Abundance | column F
    data.frame(
      Age = 3:19,
      MeanFL = c(
        63.09090909, 65.23684211, 76.8, 77.56756757, 84.17088608,
        89.98882682, 99.47727273, 102.1911765, 117.0652174, 124.64,
        136.7916667, 148.0416667, 152.0857143, 167, 168.65,
        182.3333333, 187.75
      )
    )
  })
  # end mean_len_age
  
  # plot mean length-at-age (laa)
  output$laaPlot <- renderPlot(expr = {
    par(par_set)
    plot(
      x = mean_len_age()[["Age"]],
      y = mean_len_age()[["MeanFL"]],
      pch = "+",
      col = "darkred",
      las = 1,
      ylab = "Length (cm FL)",
      xlab = "Age"
    )
    # end plot
    
    # for possible display of n if not using SB data
    # if (input$sb == "no") {
    #   n_age <- length(d()[["Age"]])
    #   mtext(text = n_age)
    # }
    
    # for display of harvestable age range relating to length -
    # will take some massaging (24-Jul-2020)
    # segments(
    #   x0 = c(0, 10),
    #   y0 = c(mean_len_age()[["MeanFL"]][[8]], mean_len_age()[["MeanFL"]][[8]]),
    #   x1 = c(10, 10),
    #   y1 = c(mean_len_age()[["MeanFL"]][[8]], 0),
    #   col = 2
    # )
  })
  # end output$laaPlot

  # age distribution ------------------------------------------------------

  # establishes age distribution given input from params
  
  age_distribution <- reactive({
    AgeDist(
      ageFreq = age_freq(),
      abund = input$abund,
      fracFemale = input$frac
    )
  })
  
  # for later analyses
  est_abundance <- reactive({ age_distribution()[["EstAgeAbund"]] })

  # for now testing in summary but will need new tab
  # output$summary <- renderPrint(expr = { print(age_distribution()) })

  # predict age-1 & age-2 abundance ---------------------------------------
  
  # log-linear abundance to predict age 1-2 abundance
  mod <- reactive({
    y <- log(as.vector(est_abundance()))
    x <- as.numeric(names(est_abundance()))
    list(mod = lm(y ~ x), x = x, y = y)
  })
  
  # to plot linear regression model used to predict ages 1 & 2
  output$predage12Plot <- renderPlot(expr = {
    plot(
      x = mod()$x,
      y = mod()$y,
      type = "b", 
      col = "grey60",
      xlab = "Age",
      ylab = "log(EstAbund)",
      panel.first = abline(mod()$mod, col = "blue")
    )
  })
  # end predage12Plot

  # female abundance ------------------------------------------------------
  
  females <- reactive({
    age1_2 <- exp(predict(object = mod()$mod, newdata = list(x = c(1, 2))))
    c(
      age1_2 * age_distribution()[["FracFemale"]],
      age_distribution()[["CountFemByAge"]]
    )
  })
  
  # to plot female abundance with predicted ages 1 & 2
  output$femAbunPlot <- renderPlot(expr = {
    par(par_set)
    
    y <- females()
    
    # Blackburn's data from: corrected_transient_midfecund_current.R
    # variable `initial_age_dist` | ages 1-19
    y2 <- c(
      3242.553, 2013.134, 762.9124, 892.9627,
      2157.2744, 2050.1174, 2769.1556, 3056.7626, 2294.4497,
      1206.4047, 885.4213, 565.3075, 1548.0006, 935.9705,
      1771.2220, 118.7429, 1533.6657, 348.5073, 1107.0916
    )
    
    # colors for bars in plot to denote predicted
    cols <- c(
      # predicted from lm
      rep("steelblue", times = 2), 
      # derived from age data
      rep("grey50", times = length(y))
    )
    
    # to plot female abundance by ages 1-19(or max age)
    plot(
      x = as.numeric(names(females())),
      y = y,
      type = "h",
      col = cols,
      lwd = 5,
      lend = 1,
      las = 1,
      xlab = "Age",
      ylab = "N",
      ylim = c(0, max(y, y2))
    )
    
    # to show SB's points used in final model output
    points(
      x = as.numeric(names(females())),
      y = y2,
      col = "black",
      pch = "+",
      cex = 1.2
    )
    
    # to display total N for females
    mtext(
      text = sprintf(fmt = "N[%s]=%.0f", "\u2640", sum(y)), 
      side = 1, 
      line = 1.5, 
      adj = 1,
      font = 3
    )
  })
  # end femAbunPlot
  
  # spawning probability --------------------------------------------------
  
  # subset of age > 9
  bool_mlaa_gt9 <- reactive( {mean_len_age()[["Age"]] > 9} )
  
  # issues the glm warning - should be handled or suppressed
  prob_spawn2 <- reactive({
    
    cnames <- c("Age", "Prob", "Err")
    
    # if (input$sb == "yes") {
    #   p <- prob_spawn
    #   colnames(p) <- cnames
    #   return(p)
    # }
    
    p_spawn <- SpawningProb(
      len = mean_len_age()[bool_mlaa_gt9(), "MeanFL"],
      age = mean_len_age()[bool_mlaa_gt9(), "Age"],
      mature = input$mature
    )
    
    # output
    rbind(
      data.frame(Age = 0:9, Prob = 0, Err = 0),
      p_spawn[, cnames]
    )
  })
  
  # for now testing in summary but will need new tab
  # output$summary <- renderPrint(expr = { print(prob_spawn2()) })
  
  # clean up (no longer needed)
  # rm(bool_mlaa_gt9)

  # age distribution (complete) -------------------------------------------

  # Devore's (et al. 1995) equation to calculate number of eggs based on fork
  # length
  
  eggs_female <- reactive({
    0.072 * (mean_len_age()[bool_mlaa_gt9(), "MeanFL"])^2.94
  })
  # end eggs_female
  
  age0 <- reactive({
    
    r <- prob_spawn2()[11:20, "Prob"] * females()[10:19] * eggs_female()
    r <- sum(r)
    
    if (input$sb == "no") return(r)
    
    # add 38,832,615 to get SB's number or close to her value 219387277
    r + 38832615
  })
  # end age0
  
  age_dist2 <- reactive({
    r <- data.frame(
      Age = as.numeric(c(0, names(females()))),
      Freq = c(age0(), unname(females())),
      # Freq = c(input$agezero, unname(females())),
      row.names = NULL
    )
    
    if (input$sb == "no") return(r)
    
    r[2, "Freq"] <-  r[2, "Freq"] + 1092.843
    r
  })
  # end age_dist2
  
  # to compare SB's age distribution with those calculated herein
  output$ageDistCompare <- renderPlot(expr = {
    par(par_set)
    # par(mar = par_set$mar + c(0, 0, 1.5, 0))
    
    # to plot female abundance by ages 1-19(or max age)
    plot(
      x = age_dist[["freq"]][-1],
      y = age_dist2()[["Freq"]][-1],
      xlab = "SB's used age dist",
      ylab = "Age dist (here)"
    )
    
    abline(a = 0, b = 1, col = 2)
    
    # # to display age-0s; given the magnitude - better to display in upper
    # margin than on plot
    mtext(
      text = sprintf(
        fmt = "Age-0: SB used %s || calc here %s",
        format(age_dist[["freq"]][1], big.mark = ","),
        format(age_dist2()[["Freq"]][1], big.mark = ",")
      ),
      side = 3,
      line = 0,
      adj = 0.5,
      cex = 0.85,
      font = 1
    )
  })
  # end ageDistCompare
  
  # egg count -------------------------------------------------------------

  # egg count age-10 to age-19
  num_eggs <- reactive({
    mean_len <- mean_len_age()[bool_mlaa_gt9(), "MeanFL"]
    age_at_len <- mean_len_age()[bool_mlaa_gt9(), "Age"]
    ec <- EggCount(len = mean_len, age = age_at_len)
    
    rbind(
      data.frame(Age = 0:9, Count = 0, Err = 0),
      ec[, c("Age", "Count", "Err")]
    )
  })
  
  # to compare SB's age distribution with those calculated herein
  output$numEggCompare <- renderPlot(expr = {
    par(par_set)
    # par(mar = par_set$mar - c(0, 0, 1.5, 0))
    
    b <- number_eggs[["age"]] > 9
    
    # to compare number of eggs
    plot(
      x = number_eggs[b, "count"],
      y = num_eggs()[b, "Count"],
      xlab = "SB's used number eggs",
      ylab = "Number eggs (here)"
    )
    
    # to show ages next to each data point
    text(
      x = number_eggs[b, "count"],
      y = num_eggs()[b, "Count"],
      labels = number_eggs[b, "age"],
      cex = 0.9,
      col = "grey15",
      adj = c(0.5, 1.25)
    )
    
    abline(a = 0, b = 1, col = 2)
  })
  # end numEggCompare
  
  # cumulative survival rate ----------------------------------------------
  
  # to show survival rate applied to age-0 produces age structure
  output$cumSurvRate <- renderPlot(expr = {
    par(par_set)
    
    # to compare number of eggs
    plot(
      x = 1:20,
      y = cumprod(prob_survival[["prob"]]) * age0(),
      xlab = "Age",
      ylab = "Number survive to next year"
    )
  })
  # end cumSurvRate

  # survival probability --------------------------------------------------
  
  # for use in simulations (next steps)
  prob_surv <- reactive({
    SurvivalProb(
      ages = prob_survival[["age"]],
      sRate = prob_survival[1:3, "prob"],
      sRateErr = prob_survival[1:3, "se"],
      mu = seq(from = 0, to = 0.30, by = 0.01),
      # agesMu = c(input$ageharvest[1], input$ageharvest[2]),
      agesMu = input$ageharvest[1]:input$ageharvest[2],
      estS = input$surv,
      estMu = input$harv,
      methodSB = TRUE
    )
  })
  
  # test <- reactive({input$ageharvest[1]:input$ageharvest[2]})
  # 
  # output$summary <- renderPrint(expr = { print(prob_surv()) })
  
  # model -----------------------------------------------------------------
  
  # works but need to rename variable
  mod_out <- eventReactive(
    eventExpr = { input$action },
    # valueExpr = { input$abund }
    valueExpr = {
      
      sims_prob_spawn <- Simulations(
        data  = prob_spawn2(),
        prob  = Prob,
        std   = Err,
        iters = input$sims,
        type  = "spawning"
      )
      
      sims_num_eggs <- Simulations(
        data  = num_eggs(),
        prob  = Count,
        std   = Err,
        iters = input$sims,
        type  = "numeggs"
      )
      
      sims_prob_surv <- mapply(
        FUN = Simulations,
        prob_surv(),
        MoreArgs = list(
          prob  = "Prob",
          std   = "Err",
          recruitment = input$recruit,
          iters = input$sims,
          type  = "survival"
        ),
        SIMPLIFY = FALSE
      )
      
      sims_fecund <- sims_num_eggs * sims_prob_spawn * input$frac
      
      # hard-coding indices susceptible to problems if data change
      final_age <- lapply(prob_surv(), FUN = "[", 20, 2:3)
      
      mu_levels <- setNames(
        object = names(sims_prob_surv),
        nm = names(sims_prob_surv)
      )
      
      pop_proj <- lapply(mu_levels, FUN = function(x) {
        PopProjections(
          fSims = sims_fecund,
          sSims = sims_prob_surv[[x]],
          mn = final_age[[x]][["Prob"]],
          sdev = final_age[[x]][["Err"]],
          ageFreq = age_dist2()[["Freq"]],
          # ageFreq = age_dist[["freq"]],
          period = 20
          # period = 40
        )
      })
      
      lambda_mu <- lapply(mu_levels, FUN = function(x) {
        mu <- as.numeric(sub(pattern = "mu_", replacement = "", x = x))
        out <- Lambda(
          popChanges = pop_proj[[x]]["pop.changes", ], 
          selectCI = as.numeric(input$ci)
        )
        out[["MuLevel"]] <- mu
        out
      })
      
      lambda_mu <- do.call(what = rbind, args = lambda_mu)
      rownames(lambda_mu) <- NULL
      
      lambda_mu
    }
  )
  
  # output$summary <- renderPrint(expr = {
  #   # print(prob_spawn2()[11:20, "Prob"] * females()[10:19] * eggs_female())
  #   # print(females())
  #   print(num_eggs())
  #   # print(females())
  #   # print(mean_len_age()[bool_mlaa_gt9(), "MeanFL"])
  #   # print(prob_spawn2())
  #   # print(prob_spawn2()[11:20, "Prob"])
  #   # print( mean_len_age()[bool_mlaa_gt9(), "MeanFL"])
  # })
  
  output$mortparams <- renderPrint(expr = {
    print(spopmodel:::FishingParams(S = input$surv, mu = input$harv))
    # print(input$ci)
    # print(mod_out())
  })
  
  output$modelPlot <- renderPlot(expr = {
    par(par_set)
    
    plot(
      x = mod_out()[["MuLevel"]],
      y = mod_out()[["MeanLambda"]],
      col = "orange2",
      lty = 1,
      lwd = 2,
      type = "n",
      ylim = c(0.8, 1.2),
      xlab = "Exploitation",
      ylab = "Population growth rate"
    )
    
    # polygon()
    
    # x & y values for drawing polygon as lower & upper bounds
    poly_list <- list(
      x = c(
        mod_out()[["MuLevel"]][1],
        mod_out()[["MuLevel"]],
        rev(mod_out()[["MuLevel"]][-1])
      ),
      y = c(
        mod_out()[["QuantLow"]][1],
        mod_out()[["QuantUpp"]],
        rev(mod_out()[["QuantLow"]][-1])
      )
    )
    
    polygon(poly_list, col = "grey90", border = NA)
    
    lines(
      x = mod_out()[["MuLevel"]],
      y = mod_out()[["MeanLambda"]],
      col = "orange2",
      lty = 1,
      lwd = 2
    )
    
    abline(h = 1, col = adjustcolor(col = "steelblue", alpha.f = 0.5))
    
    # mtext(text = paste0(est_abundance(), collapse = " | "), side = 3)
    # mtext(text = nrow(d()), side = 3, line = 0, adj = 1)
  })
}
# end server

# shinyApp(ui = htmlTemplate("model/www/index.html"), server = server)
shinyApp(ui = htmlTemplate("www/index.html"), server = server)

#' @import ggplot2
#' @import olsrr
myleastsquare <- function(x,y)
{
 # Solve linear fit
 n <- length(x)
 Y <- as.matrix(y)
 X <- as.matrix(cbind(rep(1,length(x)), x))
 XtX <- t(X) %*% X

 # Use solve to calculates the inverse
 beta <- solve(XtX)%*%t(X)%*%Y
 offset_estimate <- beta[1]
 slope_estimate <- beta[2]

 # Residuals
 residuals <- y - (slope_estimate*x + offset_estimate)

 #  Projection matrix
 P <- X %*%solve(XtX)%*%t(X)

 # Leverage P
  pii <- diag(P)

  # Compare our solution with lm
  my_model <- stats::lm(y~x)

  # Confirm the sum of square residuals of from the LA method are identical to those from the lm-package
  residuals <- y - (slope_estimate*x + offset_estimate)

  sum(residuals**2)
  my_model$coefficients
  sum(my_model$residuals**2)
 return(list(res = residuals, offeset=offset_estimate, slope=slope_estimate,leverage=pii))
}

calcMeasures <- function(x,y, measure)
{
  n <- length(x)
  results <- myleastsquare(x,y)
  residuals <- results$res
  my_model <- stats::lm(y~x)
  pii <- results$leverage

  if  (measure == "Cooks")
  {
    # Estimate of sigma
    sigma_hat <- as.numeric(sqrt(t(residuals)%*%residuals/(n-2)))

    # Studentize Residuals
    studentsized_residuals  <- residuals/(sigma_hat*sqrt(1-pii))

    distance <- (0.5*studentsized_residuals**2)*(pii/(1-pii))

    # threshold
    threshold <- 4/n

    # Prepare Indices of Values over threshold
    txt <- 1:n
    txt[distance < threshold] = NA

    # Store all in datafrom (easier for ggplot)
    d <- data.frame(obs=x, cd=distance, txt=txt)

    title <- "Cook's Distance Plot"
    ylabel <-  "Cook's D"
    gg <- ggplot2::ggplot(d, aes(x = obs, y = cd, label = txt, ymin = min(cd), ymax = cd)) +
        geom_linerange(colour = "blue") + ggplot2::geom_point(colour = "black") +
        xlab("Observation") + ylab(ylabel) + ggtitle(title)
    gg <-  gg + geom_text(vjust = -1, size = 3, family = "serif", fontface = "italic", colour = "darkred", na.rm = TRUE)
      # Add threshold line plot
    gg <-  gg +geom_hline(yintercept = threshold, colour = "red")

      # Add text line plot
    gg <-  gg + annotate("text", x = Inf, y = Inf, hjust = 1.2, vjust = 2, family = "serif", fontface = "italic", colour = "darkred",
                           label = paste("Threshold:", round(threshold, 3)))
    result <- list(measure=distance, graph=gg)
    # For check
    # olsrr::ols_plot_cooksd_chart(my_model)
  }

  if  (measure == "DFITS"){
    SSE_i <- rep(0, n)
    # Calculate SSE without the ith values for each i
    for (i in 1:n){
      tempbool <- rep(T, n)
      tempbool[i] <- F
      SSE_i[i]  <- as.numeric(sqrt(  (t(residuals[tempbool])%*%residuals[tempbool])/(n-3)))
    }

    # Calculate r* and DFITS
    ext_studentsized_residuals  <- residuals/(SSE_i*sqrt(1-pii))
    distance <- ext_studentsized_residuals*sqrt(pii/(1-pii))

    # threshold
    threshold <- round(2*sqrt(2/n),3)


    # Prepare Indices of Values over threshold
    txt <- 1:n
    txt[(distance < threshold) & (distance > -threshold)] = NA

    # Store all in dataframe (easier for ggplot)
    index <- distance > 0
    d <- data.frame(obs=x[index], cd=distance[index], txt=txt[index])
    d2 <- data.frame(obs=x[!index], cd=distance[!index], txt=txt[!index])

    title <- "DFITTS"
    ylabel <-  "DFFITS"
    gg <- ggplot() +
     geom_linerange(d, mapping =aes(x = obs, y = cd,  ymin = 0, ymax = cd),colour = "blue") +
     geom_linerange(d2, mapping =aes(x = obs, y = cd, ymin = cd, ymax = 0),colour = "blue") +
     geom_point(d, mapping =aes(x = obs, y = cd),colour = "black")+
     geom_point(d2, mapping =aes(x = obs, y = cd),colour = "black") +
     xlab("Observation") + ylab(ylabel) + ggtitle(title)

    # Add threshold line plot
    gg <-  gg +geom_hline(yintercept = threshold, colour = "red")
    gg <-  gg +geom_hline(yintercept = -threshold, colour = "red")

    gg <-  gg + geom_text(vjust = -1, size = 3, family = "serif", fontface = "italic", colour = "darkred", na.rm = TRUE)
    gg <- gg + geom_text(d, mapping =aes(x = obs, y = cd, label=txt), colour = "darkred", nudge_x = 0.1, na.rm = TRUE)
    gg <- gg + geom_text(d2, mapping =aes(x = obs, y = cd, label=txt), colour = "darkred", nudge_x = 0.1,, na.rm = TRUE)

    # Add text line plot
    gg <-  gg + annotate("text", x = Inf, y = Inf, hjust = 1.2, vjust = 2, family = "serif", fontface = "italic", colour = "darkred",
                         label = paste("Threshold:", round(threshold, 3)))
    result <- list(measure=distance, graph=gg)

    # For Check
    #olsrr::ols_plot_dffits(my_model) + ggplot2::geom_point(y=as.vector(distance))
  }


  if  (measure == "Hadi"){

    # Calculate the normalized residuals
    dd2 <- residuals**2/as.numeric(t(residuals)%*%residuals)

    # Calculate H
    distance <- (pii/(1-pii)) + (2/(1-pii))*(dd2)/(1-dd2)

    # threshold
    threshold <- 2*sqrt(1/n)

    # Prepare Indices of Values over threshold
    txt <- 1:n
    txt[distance < threshold] = NA

    # Store all in datafrom (easier for ggplot)
    d <- data.frame(obs=x, cd=distance, txt=txt)

    title <- "Hadi's Influence Measure"
    ylabel <-  "Hadi's Measure"

    gg <- ggplot2::ggplot(d, mapping =aes(x = obs, y = cd, label = txt, ymin = min(cd), ymax = cd)) +
      ggplot2::geom_linerange(colour = "blue") + ggplot2::geom_point(colour = "black") +
      xlab("Observation") + ylab(ylabel) + ggplot2::ggtitle(title)
    gg <-  gg + ggplot2::geom_text(vjust = -1, size = 3, family = "serif", fontface = "italic", colour = "darkred", na.rm = TRUE)

    # Add threshold line plot
    gg <-  gg +ggplot2::geom_hline(yintercept = threshold, colour = "red")

    # Add text line plot
    gg <-  gg + ggplot2::annotate("text", x = Inf, y = Inf, hjust = 1.2, vjust = 2, family = "serif", fontface = "italic", colour = "darkred",
                         label = paste("Threshold:", round(threshold, 3)))

    result <- list(measure=distance, graph=gg)
    # For Check
  #  gg
  #  olsrr::ols_plot_hadi(my_model) + ggplot2::geom_point(y=as.vector(distance))
  }
  return(result)

}


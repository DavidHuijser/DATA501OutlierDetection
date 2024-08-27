
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

    my_cooks_distance <- (0.5*studentsized_residuals**2)*(pii/(1-pii))

    # Compare my Cooks-distance with Cooksplot from Olsrr packages by overplot my Cooksdistances (black dots)
    #temp  <-cooks.distance(my_model)
    olsrr::ols_plot_cooksd_chart(my_model) + ggplot2::geom_point(y=as.vector(my_cooks_distance))
    return(my_cooks_distance)
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

    my_DFITS <- ext_studentsized_residuals*sqrt(pii/(1-pii))

    # Compare my DFITS  with DFITS from Olsrr packages by over plotting my DFITS-values  (black dots)
    olsrr::ols_plot_dffits(my_model)+ ggplot2::geom_point(y=as.vector(my_DFITS))
    return(my_DFITS)
  }


  if  (measure == "Hadi"){
    # Calculate the normalized residuals
    dd2 <- residuals**2/as.numeric(t(residuals)%*%residuals)
    # Calculate H
    my_Hadis <- (pii/(1-pii)) + (2/(1-pii))*(dd2)/(1-dd2)

    # Plot Hadis Measure
    olsrr::ols_plot_hadi(my_model) + ggplot2::geom_point(y=as.vector(my_DFITS))
    return(my_DFITS)
  }


}


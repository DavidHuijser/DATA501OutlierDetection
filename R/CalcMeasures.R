
myleastsquare <- function(x,y)
{
 # Solve linear fit
 n <- length(x)
 Y <- as.matrix(y)
 X <- cbind(rep(1,length(x)), x)
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
  model <- lm(y~x)

  # Confirm the sum of square residuals of from the LA method are identical to those from the lm-package
  residuals <- y - (slope_estimate*x + offset_estimate)

  sum(residuals**2)
  model$coefficients
  sum(model$residuals**2)
 return(list(res = residuals, offeset=offset_estimate, slope=slope_estimate,leverage=pii))
}

calcDistances <- function(x,y, measure)
{

  results <- myleastsquare(x,y)
  residuals = results$res

  if  (measure == "Cooks")
  {

    # Estimate of sigma
    sigma_hat <- as.numeric(sqrt(t(residuals)%*%residuals/(n-2)))

    # Studentize Residuals
    studentsized_residuals  <- residuals/(sigma_hat*sqrt(1-pii))

    my_cooks_distance <- (0.5*studentsized_residuals**2)*(pii/(1-pii))

    # Compare my Cooks-distance with Cooksplot from Olsrr packages by overplot my Cooksdistances (black dots)
    model <- lm(y~x)
    temp  <-cooks.distance(model)
    ols_plot_cooksd_chart(model) + geom_point(y=as.vector(my_cooks_distance))



  }
  if  (measure == "DFFITS"){

  }
  if  (measure == "Hadis"){

  }


}


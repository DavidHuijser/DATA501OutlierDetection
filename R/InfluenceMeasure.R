#' InfluenceMeasure
#'
#' The function InfluenceMeasure is aimed to identify points of high influence,which
#' might have a large impact in linear regression.
#'
#' @param data either a lm-object or a dataframe, the code expect to both have variables named x and y.

#' @param measure is a string to indicate the type of influence measure to be used:
#'         "Cooks","DFITS" or "Hadi"
#'
#' @param output is string which describes the type of output the user prefers "plot" or "influences".
#'
#' @return The functions returns either plot or the influence measures.
#' @export
#'
#' @examples
#' slope <-  4
#' offset <- -3
#' sds <- 7
#' x <- seq(from = 1, to = 10, length.out= 100)
#' y <- slope*x + offset
#  Add regular noise
#' noise <- rnorm(length(x),sd=2)
#' y <- y + noise
#  generate number of outliers
#' num <- 3
#' s <- sample(length(x), num)
#' y[s] <- y[s] +  rnorm(num, sd=sds) + runif(num, -sds,sds)
#'
#'
#' lin_model <- lm(y~x)
#' results <- InfluenceMeasure(lin_model, measure="Hadi", output = "values")
#'
InfluenceMeasure <- function(data, measure, output="plot"){

   # Test Input Data Class
   if (!(class(data) %in% list("data.frame","lm")))  stop(paste(" Incorrect data argument"))

   # Test Input measure
   if (!(measure %in% list("Cooks","DFITS", "Hadi")))  stop(paste(" Incorrect measure argument"))

   # Test output
   if (!(output %in% list("values","plot")))  stop(paste(" Incorrect output argument"))

   # Obtain x and y from the data & determine if input is lm-model or dataframe
   if (attr(data,"class") == "data.frame")
   {
     x <-data$x
     y <-data$y
   }
   else
   {
     x <- data$model$x
     y <- data$model$y
   }

    myInfluenceMeasures  <- calcMeasures(x,y,measure)

    if (output == "values")
    {
    return(myInfluenceMeasures)
    }
    if (output == "plot")
    {
      return(myInfluenceMeasures)
    }
}




InfluenceMeasure <- function(data, measure, output="plot"){

   # Test Input Data Class
   if (!(class(data) %in% list("data.frame","lm")))  stop(paste(" Incorrect data argument"))

   # Test Input measure
   if (!(measure %in% list("Cooks","DFITS", "Hadi")))  stop(paste(" Incorrect measure argument"))

   # Test output
   if (!(output %in% list("values","plot")))  stop(paste(" Incorrect output argument"))


   if (class(data) == "data.frame")  print(" Data 1")
   {
     x <- c(lmmodel$model["x"])
     y <- c(lmmodel$model["y"])
   }
   if (class(data) == "lm")  print(" Data 2")
  {
    x <- df$x
    y <- df$y
   }


   plot(x,y)
    #first determine if input is lm-model or dataframe
   if  (measure == "Cooks")  print(" Option 1")
   if  (measure == "DFFITS")  print(" Option 2")
   if  (measure == "Hadis")  print(" Option 3")

    print("Hello, world!")
    print(output)
}


InfluenceMeasure(model, measure="Cooks", output = "plot")
InfluenceMeasure(model, measure="Cooks", output = "values")
InfluenceMeasure(data, measure="Cooks")
InfluenceMeasure(2, measure="Cooks")
InfluenceMeasure(data, measure="Whatever")
InfluenceMeasure(lmmodel, measure="Cooks", output = "Pickles")

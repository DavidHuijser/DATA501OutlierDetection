
InfluenceMeasure <- function(data, measure, output=plot){

   # Test Input Data Class
   if (!(class(data) %in% list("data.frame","lm")))  print(" Wrong input class")

   # Test Input measure
   if (!(measure %in% list("Cooks","DFITS", "Hadi")))  print(" Wrong measure class")

  # Test output
  if (!(output %in% list("values","plot")))  print(" Wrong output")


   if (class(data) == "data.frame")  print(" Data 1")
   if (class(data) == "lm")  print(" Data 2")


    #first determine if input is lm-model or dataframe
   if  (measure == "Cooks")  print(" Option 1")
   if  (measure == "DFFITS")  print(" Option 2")
   if  (measure == "Hadis")  print(" Option 3")

    print("Hello, world!")
}

InfluenceMeasure(model, measure="Cooks")
InfluenceMeasure(data, measure="Cooks")
InfluenceMeasure(2, measure="Cooks")

# generate test data
slope <-  4
offset <- -3
sds <- 7
x <- seq(from = 1, to = 10, length.out= 100)
y <- slope*x + offset

# Add regular noise
noise <- rnorm(length(x),sd=2)
y <- y + noise

# generate number of outliers
num <- 3
s <- sample(length(x), num)
y[s] <- y[s] +  rnorm(num, sd=sds) + runif(num, -sds,sds)

df <- data.frame(x,y)

lin_model <- lm(y~x)



## Valid inputs testing
test_that("The package gives helpful errors for invalid inputs", {
  expect_error(InfluenceMeasure(list(x,y), measure="Cooks", output = "plot"), "Incorrect data argument")
  expect_error(InfluenceMeasure(df, measure="Two Donuts", output = "plot"), "Incorrect measure argument")
  expect_error(InfluenceMeasure(df, measure="Cooks", output = "Nothing"), "Incorrect output argument")




  })

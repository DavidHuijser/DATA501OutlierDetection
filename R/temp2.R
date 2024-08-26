# Create plotzzzz
library(ggplot2)
library(olsrr)
library(stats)
library(Matrix)
library(corpcor)

# Now we need create a package to detect outliers
# 1. Generate data with a few outliers
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
index <- seq(size)

# Create plot
df <- data.frame(x,y,index)


ggplot(data=df, aes(x=x, y=y)) +
geom_point()

# now we need to provide the script with a model
makeModels <- function(formula, data) {
  # size is looked in data first, which is why this works
  m <- lm(formula, na.action = na.omit, data =  data)
  return(m)
}

run <- function(df, measure = "Cooks") {

  # Test Input

  #
  size <- length(df$x)
  # Create model
  f <- formula(y ~ x)
  m1 <- lm(formula = f, na.action = na.omit, data = df)
  m2 <- makeModels(formula = f, data = df)

  if  (measure == "Cooks")  print(" Option 1")
  if  (measure == "DFFITS")  print(" Option 2")
  if  (measure == "Hadis")  print(" Option 3")

  # perform outlier detection

  my_cooks_distance(df)


  #Cooks Distance Measure (Cook, 1977)
  # DFFITS (Welsch and Kuh, 1977; Belsley, 1980)
  # Hadis Influence Measure (Hadi, 1992)
  return(list(m1, m2))
}

temp <- run(df, measure="Cooks")
temp <- run(df, measure="DFFITS")
temp <- run(df, measure="Hadis")
model <- lm(y~x)


# there are a few quantities we need
# 1 Leverage
# 2

inv <-

x <- matrix(x)
  x

#library(corpcor)
#beta <- pseudoinverse(x*t(x))*t(x)*y
#pseudoinverse(x*t(x))*x*y


# Solve linear fit
library(Matrix)
Y <- as.matrix(y)
X <- cbind(rep(1,length(x)), x)
XtX <- t(X) %*% X
#find inverse
beta <- solve(XtX)%*%t(X)%*%Y
offset_estimate <- beta[1]
slope_estimate <- beta[2]
model <- lm(y~x)

# Leverage P
P <- X %*%solve(XtX)%*%t(X)
pii <- diag(P)

# residuals
residuals <- y - (slope_estimate*x + offset_estimate)
sum(residuals)
model$coefficients
sum(model$residuals)
SSE <- sum(residuals**2)
sigma_hat <- SSE/(length(x)-2)

my_cooks_distance <- (residuals**2/2)*(pii/(1-pii))
plot(my_cooks_distance)

# Solve linear fit
library(Matrix)
Y <- as.matrix(y)
X <- cbind(rep(1,length(x)), x)
XtX <- t(X) %*% X
#find inverse
solve(XtX)%*%t(X)%*%Y

lm(Y~X)

getAnywhere("ols_plot_cooksd_chart")
ols_plot_cooksd_chart(model)
ols_plot_dffits()
ols_plot_hadi()

#
my_cooks_distance <- function(df)
  {
  # Threshold
  size <- length(df$x)

  # Create model
  f <- formula(y ~ x)
  for (i in 1:size)
  {
     tempbool <- rep(T, size)
     tempbool[i] <- F
     tempdf <- subset(df, tempbool)
     m1 <- lm(formula = f, na.action = na.omit, data = tempdf)
     m2 <- makeModels(formula = f, data = tempdf)

  }






  }

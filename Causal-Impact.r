#install.packages("CausalImpact")
library(CausalImpact)
library(zoo)

#Test Data
#https://cran.r-project.org/web/packages/CausalImpact/vignettes/CausalImpact.html#creating-an-example-dataset
set.seed(1)
x1 <- 100 + arima.sim(model = list(ar = 0.999), n = 100)
y <- 1.2 * x1 + rnorm(100)
y[71:100] <- y[71:100] + 10
data <- cbind(y, x1)

dim(data)

head(data)

matplot(data, type = "l")

pre.period <- c(1, 70)
post.period <- c(71, 100)

# This says that time points 1 ... 70 will be used for training, and time points 71 ... 100 will be used for computing predictions. Alternatively, we could specify the periods in terms of dates or time points; see Section 5 for an example.
# To perform inference, we run the analysis using:

impact <- CausalImpact(data, pre.period, post.period)
plot(impact)

# By default, the plot contains three panels. The first panel shows the data and a counterfactual prediction for the post-treatment period. 
# The second panel shows the difference between observed data and counterfactual predictions. This is the pointwise causal effect, as estimated by the model. 
# The third panel adds up the pointwise contributions from the second panel, resulting in a plot of the cumulative effect of the intervention.
# 
# Remember, once again, that all of the above inferences depend critically on the assumption that the covariates were not themselves affected 
# by the intervention. The model also assumes that the relationship between covariates and treated time series, as established during the pre-period, remains stable throughout the post-period.

# Time and dates
time.points <- seq.Date(as.Date("2014-01-01"), by = 1, length.out = 100)
data <- zoo(cbind(y, x1), time.points)
head(data)


pre.period <- as.Date(c("2014-01-01", "2014-03-11"))
post.period <- as.Date(c("2014-03-12", "2014-04-10"))
impact <- CausalImpact(data, pre.period, post.period)
plot(impact)
summary(impact)
summary(impact, "report")
impact$summary

data2 <- as.data.frame(data)

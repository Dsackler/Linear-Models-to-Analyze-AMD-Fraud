require(dplyr)
#load lmtest library
install.packages("lmtest")
library(lmtest)
install.packages("tseries")
library(tseries)


stock_info <- read.csv('Assignment 2/data/stockreturns.csv',stringsAsFactors=TRUE)

amd = "ADVANCED MICRO DEVICES INC"


working_ds <- stock_info %>%
  filter(hcomnam %in% c(
    "ADVANCED MICRO DEVICES INC", 
    "ANALOG DEVICES INC", 
    "INTERNATIONAL BUSINESS MACHS COR", 
    "INTEL CORP", 
    "NVIDIA CORP", 
    "QUALCOMM INC"
  )) %>%
  group_by(date) %>%
  mutate(
    peer_avg = mean(
      ret[hcomnam %in% c("ANALOG DEVICES INC", "INTERNATIONAL BUSINESS MACHS COR", "INTEL CORP", "NVIDIA CORP", "QUALCOMM INC")], 
      na.rm = TRUE
    ),
    peer_sum = sum(
      vol[hcomnam %in% c("ANALOG DEVICES INC", "INTERNATIONAL BUSINESS MACHS COR", "INTEL CORP", "NVIDIA CORP", "QUALCOMM INC")]
    )
  ) %>%
  filter(hcomnam == "ADVANCED MICRO DEVICES INC") %>%
  select(date, hcomnam, ret, vol, peer_avg, peer_sum, sprtrn)
working_ds$date <- as.Date(working_ds$date, format = "%Y-%m-%d")

#Question 1
#a
ad.model <- lm(ret~peer_avg+sprtrn,data=working_ds[working_ds$date >=  '2022-01-01'& working_ds$date <= '2022-12-31', ])

model_summary = summary(ad.model)
coefficients <- model_summary$coefficients
point_estimates <- coefficients[, 1]  # Beta estimates
p_values <- coefficients[, 4]         # P-values
significant <- ifelse(p_values < 0.10, "Yes", "No")


# Extract R²
r_squared <- model_summary$r.squared

# Create a table with the results
results_table <- data.frame(
  Term = rownames(coefficients),
  Estimate = point_estimates,
  P_Values = p_values,
  Significant_at_10 = significant,
  R_Squared = c(r_squared, rep(NA, nrow(coefficients) - 1))  # R² in first row
)

#b
#Intercept: The base return for AMD, assuming no impact from the market or peers.
#Peer Avg: For each 1% increase in average peer returns, AMD's return changes by the estimated coefficient. If this value is significant, it shows AMD moves in tandem with industry peers.
#S&P Return: Captures how much AMD's returns are affected by general market conditions.
#R Squared terms tells us how much of the variability in the predicted values is explained by the predictors
#In this case, 77% of the variability in AMD's predicted return is explained by the peer average and s & p


#c

plot(ad.model$residuals,ylab='Residuals')
hist(ad.model$residuals)
ks.test(ad.model$residuals/summary(ad.model)$sigma,pnorm)
#p value is greater than .05, so cant reject null that it is normal
#Also use Shapiro Wilk test to test normality
shapiro.test(ad.model$residuals/summary(ad.model)$sigma)
#p-value is less than .05, not normal
#Test for autocorrelation
acf(ad.model$residuals)
#Hard to tell if autocorrelation. Perform box test below to further test
Box.test(ad.model$residuals, lag = 10, type = "Ljung")
#P-value is .908 so fail to reject null hyp that residuals are independent
plot(d, ad.model$residuals, type = "l", col = "black", lwd = 1,
     xlab = "d", ylab = "Residuals", main = "Residuals Line Graph")
plot(ad.model$fitted.values, ad.model$residuals)
#perform Breusch-Pagan Test to test for hetero
bptest(ad.model)
#p-value is greater than .05, so reject null that it is hetero

#Question 2
ad2011.model <- lm(ret~peer_avg+sprtrn, data = working_ds[working_ds$date >= '2011-10-12 '& working_ds$date <= '2012-10-11', ])
summary(ad.model)
summary(ad2011.model)
#This model is worse. Lower r^2 value, residuals are greater, more of an emphasis on the s & p 500
ad2011.model$coefficients
head(ad2011.model$fitted.values)
head(ad2011.model$residuals)
summary(ad2011.model)$sigma^2
summary(ad2011.model)$r.squared


model2011_summary = summary(ad2011.model)
coefficients2011 <- model2011_summary$coefficients
point_estimates2011 <- coefficients2011[, 1]  # Beta estimates
p_values2011 <- coefficients2011[, 4]         # P-values
significant2011 <- ifelse(p_values2011 < 0.10, "Yes", "No")
r_squared2011 <- model2011_summary$r.squared


# Create a table with the results
results_table2011 <- data.frame(
  Term = rownames(coefficients2011),
  Estimate = point_estimates2011,
  P_Values = p_values2011,
  Significant_at_10 = significant2011,
  R_Squared = c(r_squared2011, rep(NA, nrow(coefficients2011) - 1))  # R² in first row
)


#b

plot(ad2011.model$residuals,ylab='Residuals')
hist(ad2011.model$residuals) #doesnt look normal
ks.test(ad2011.model$residuals/summary(ad2011.model)$sigma,pnorm) #close to, but lower than .05. So reject null.
#Also use Shapiro Wilk test to test normality
shapiro.test(ad2011.model$residuals/summary(ad2011.model)$sigma)
#less than .05. Normal
#perform Breusch-Pagan Test to test for hetero
bptest(ad2011.model)
#p-value is greater than .05, so fail to reject null

#plot residuals against fitted values
plot(ad2011.model$fitted.values, ad2011.model$residuals)

#Check for autocorrelation
acf(ad2011.model$residuals) #Doesn't seem like there is autocorrelation
Box.test(ad2011.model$residuals, lag = 10, type = "Ljung")
#fail to reject that they are independant because value is greater than .05

#c
# Create a data frame with future predictor values, including ret
future_data <- working_ds[working_ds$date %in% c('2012-10-12', '2012-10-19'), 
                          c('peer_avg', 'sprtrn', 'ret')]

# Generate predictions with 95% confidence intervals, selecting only the needed columns
predictions_with_ci <- predict(ad2011.model, 
                               newdata = future_data[, c('peer_avg', 'sprtrn')], 
                               interval = "prediction", level = 0.95)

# Print the predictions with confidence intervals
print(predictions_with_ci)
# Create a data frame with predictions and confidence intervals
AMD_Intervals <- data.frame(
  Dates = c('2012-10-12', '2012-10-19'),
  Return = future_data[, "ret"],
  Predicted_return = predictions_with_ci[, "fit"],
  Worst_Case = predictions_with_ci[, "lwr"],
  Excess_Return = c(future_data$ret[1] - predictions_with_ci[3][1], future_data$ret[2] - predictions_with_ci[4][1])
)

#Excess Return: The difference between the actual return and the worst-case return from the 95% CI.
#Interpretation: These abnormal returns measure the unexpected stock movement, which can indicate potential market reaction to news events.
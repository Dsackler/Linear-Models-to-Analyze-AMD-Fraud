# AMD Lawsuit Analysis: "Fraud on the Market"

This project analyzes a lawsuit against AMD where shareholders allege a "fraud on the market" in late 2011 and early 2012.

---

## Pre-Processing

### Question: How was the stock dataset prepared for analysis?
**Answer:**  
I began by creating a daily dataset over the trading period with the following columns:
- **Date**
- **The daily return on Advanced Micro Devices (AMD)**: a microchip manufacturer.
- **The daily volume on AMD**.
- **An equal-weighted average of the daily return for a group of AMD’s peers and competitors**: Analog Devices, IBM, Intel, Nvidia, and Qualcomm.
- **The total (summed) daily volume for these five peer companies**.
- **The S&P 500 index return**.

The resulting dataset contains **3,700 rows**. I then considered the following regression model to explain the movements in the stock market.

---

## Regression Analysis

### Question: What were the regression results for AMD stock returns using data from 2022? Provide a summary table of the results.
**Answer:**  
I ran the regression for AMD stock returns using only the data from the year 2022. Below is the results table.

![Summary_Table](https://github.com/Dsackler/Analysis_of_AMD_Fraud/blob/main/images/Summary%20table%201.png)

### Question: How should the parameters β₀, β₁, and β₂ in the 2022 regression model be interpreted? Are these parameters statistically significant at a 10% significance level? What does the R² value indicate about the model's explanatory power?
**Answer:**  
The parameters from the regression model can be interpreted as follows:

- **β₀ (Intercept):**  
  - **Value:** -0.00087  
  - **Interpretation:** This intercept suggests that AMD's stock returns would be slightly negative when the returns of AMD’s competitors and the S&P 500 Index are zero.  
  - **P-value:** 0.453 (greater than 0.1)  
  - **Conclusion:** Not statistically significant at the 10% significance level.

- **β₁ (Competitor Returns):**  
  - **Value:** 1.237  
  - **Interpretation:** For a 1% return in the equal-weighted average daily return of AMD's competitor stocks, AMD’s stock return is expected to increase by 1.237%.  
  - **P-value:** 2.45 × 10⁻²² (less than 0.1)  
  - **Conclusion:** Statistically significant.

- **β₂ (S&P 500 Returns):**  
  - **Value:** 0.387  
  - **Interpretation:** For a 1% return in the daily return of the S&P 500 Index, AMD’s stock return is expected to be 0.387%.  
  - **P-value:** 2.65 × 10⁻² (less than 0.1)  
  - **Conclusion:** Statistically significant.

- **R² (Coefficient of Determination):**  
  - **Value:** 0.771  
  - **Interpretation:** 77.1% of the variation in AMD’s daily stock returns can be explained by the returns of AMD’s competitors and the S&P 500 Index.

---

### Question: How was the normality of the residuals tested for the 2022 regression model, and what conclusions were drawn?
**Answer:**  
- **Kolmogorov-Smirnov (K-S) Test:**  
  - **P-value:** 0.321  
  - **Conclusion:** Fail to reject the null hypothesis, suggesting residuals may be normally distributed.

- **Shapiro-Wilk Test:**  
  - **P-value:** 0.01625  
  - **Conclusion:** Reject the null hypothesis, indicating that the residuals are not normally distributed.

---

### Question: Were the residuals tested for autocorrelation and heteroskedasticity? If so, what were the results of these tests?
**Answer:**  
- **Autocorrelation Test:**  
  - **Test:** Durbin-Watson  
  - **P-value:** 0.36  
  - **Conclusion:** No autocorrelation in residuals.

- **Heteroskedasticity Test:**  
  - **Test:** Breusch-Pagan  
  - **P-value:** 0.37  
  - **Conclusion:** Residuals are homoskedastic.

---

### Question: Based on these tests, does the model meet the assumptions of an OLS regression model? What implications does this have for interpreting the results?
**Answer:**  
The model passes the tests for autocorrelation and heteroskedasticity but fails the test for normality of residuals. Therefore, while the regression model meets most assumptions, the violation of normality implies that hypothesis testing, confidence intervals, and prediction intervals should be interpreted with caution.

---

## Regression Results for October 12, 2011, to October 11, 2012

### Question: What were the regression results for AMD stock returns using data from October 12, 2011, to October 11, 2012? How do the parameter estimates (β₀, β₁, β₂) from this model compare with the 2022 model? Are these parameters statistically significant at a 10% significance level?
**Answer:**  
I re-ran the regression model using data from this period. Below is the results table.

![Result_Table_2](https://github.com/Dsackler/Analysis_of_AMD_Fraud/blob/main/images/Summary%20table%202.png)

- **β₀ (Intercept):**  
  - **Value:** -0.0021 (slightly larger in magnitude compared to the prior model).  
  - **P-value:** 0.11479 (greater than 0.1).  
  - **Conclusion:** Not statistically significant.

- **β₁ (Competitor Returns):**  
  - **Value:** 1.133 (similar to the previous model).  
  - **P-value:** 4.3 × 10⁻⁸ (less than 0.1).  
  - **Conclusion:** Statistically significant.

- **β₂ (S&P 500 Returns):**  
  - **Value:** 0.854 (noticeably higher than the previous model).  
  - **P-value:** 0.001 (less than 0.1).  
  - **Conclusion:** Statistically significant.

- **R² (Coefficient of Determination):**  
  - **Value:** 0.536  
  - **Interpretation:** Indicates a reduced explanatory power compared to the 2022 model (R² = 77.1%).

---

### Question: How was the normality of the residuals tested for the 2011-2012 regression model, and what conclusions were drawn? Were the residuals tested for autocorrelation and heteroskedasticity? If so, what were the results of these tests? Based on these tests, does the model meet the assumptions of an OLS regression model? What does this imply about the reliability of the model's conclusions?
**Answer:**  
I tested whether this model meets the IID assumptions of ordinary least squares regression using a 10% significance threshold.

- **Normality of Residuals:**
  - **Test:** Shapiro-Wilk 
  - **P-value:** 1.045 × 10⁻⁹
  - **Conclusion:** Reject the null hypothesis, indicating that the residuals are not normally distributed.
- **Autocorrelation:**
  - **Test:** Durbin-Watson test
  - **Statistic:** 2.124
  - **P-value:** 0.312
  - **Conclusion:** Fail to reject the null hypothesis, suggesting no autocorrelation.
- **Heteroskedasticity:**
  - **Test:** Breusch-Pagan test
  - **P-value:** 0.542
  - **Conclusion:** Fail to reject the null hypothesis, suggesting that the residuals are homoskedastic.

**Conclusion for 2011-2012 Model:**

While the model satisfies the assumptions of no autocorrelation and homoskedasticity, it fails the test for normality of residuals. Similar to the 2022-2023 model, this suggests that some results derived from this model, such as hypothesis testing and confidence intervals, should be interpreted cautiously.

---

### Question: Predict how AMD shares would be expected to move on 2012-10-12 and 2012-10-19. Construct 95% confidence intervals for these predictions. 
The below chart contains the return and confidence interval information.

![Conf_chart](https://github.com/Dsackler/Analysis_of_AMD_Fraud/blob/main/images/Return%20and%20conf.png)

***Conclusion and interpretation***

The significant negative returns on October 12 and 19 2012 (-14.3% and -16.7% respectively), which fall well below the lower bounds of the 95% confidence interval and generate significant negative excess returns, suggest that AMD’s stock decline on these days was not due to typical market volatility. Based on the model’s output and predictor contributions, I can be 95% confident that the returns of AMD for these dates would not have dropped below −4.9% and −8.7%, respectively, given the values of the predictors (competitor and S&P 500 returns) for those days. This abnormal movement provides compelling evidence that AMD’s misrepresentation led to shareholder losses, supporting a securities fraud claim based on the financial harm caused by inaccurate reporting.


####---------_---------------------------------------------------------####
#   title:   Predincting Automobile sales (Elantra)                       #
#   author:  Elias Castro Hernandez                                       #
#   date:    Fall 2017                                                    # 
#   purpose: Perform feature selection,                                   #
#            and perform a linear regression to forecast sales            #
#            of Hyndai Elantra                                            #
#                                                                         #
#   notes:   For simplicity, data is loaded as neeeded with new names     #
####-------------------------------------------------------------------####

#### Install library dependencies ####
# Data manipulation
library(dplyr)
# Plotting
library(ggplot2)
library(GGally)
# Variable Inflation Factor (VIF)
library(car) 


# Load data:
elantra <- read.csv("Elantra142-Fall2017.csv") 
# Confirm data:
View(elantra) 


#### Linear filtering of time series, by chronological order (year) ####
elantra.train <- filter(elantra, Year < 2015) 
elantra.test <- filter(elantra, Year > 2014)
# Confirm proper training
View(elantra.train)
View(elantra.test)


#### Train of model using linear regression function: lm(<output> ~ from features, data = <desired data>) ####
ElantraSales <- lm(ElantraSales ~ Unemployment + ElantraQueries + CPI.Energy + CPI.All, data = elantra.train)
# Identify Subset of features to be considered, according to Significance codes
summary(ElantraSales)


##### Testing quality of model's estimators ####
# 1. Confidence interval plot
ggcoef(
  ElantraSales,
  vline_color = "red",
  vline_linetype =  "solid",
  errorbar_color = "blue",
  errorbar_height = .25,
  exclude_intercept = TRUE
)

# Outputs stars based on importance of feature
vif(ElantraSales)


#### New model, excludeing 'non-relevant' predictors: CPI.Energy and Unemployment ####
sub_ElantraSales <- lm(ElantraSales ~ ElantraQueries + CPI.All, data = elantra.train)
# View overall quality of model
summary(sub_ElantraSales)


#### Testing quality of new model ####
# 1. Confidence interval plot
ggcoef(
  sub_ElantraSales,
  vline_color = "red",
  vline_linetype =  "solid",
  errorbar_color = "orange",
  errorbar_height = .25,
  exclude_intercept = TRUE
)

# 2. Outputs stars based on importance of feature
vif(sub_ElantraSales)


#### Evaluate model on training data ####
# Compute y^hat_i
predictions_ElantraSales <- predict(sub_ElantraSales, newdata=elantra.test) 
# 5 Point analysis on predicted reponses
summary(predictions_ElantraSales)

# Sum of Squared Errors from regression model (aka Residual Sum of Squares)
SSE_a = sum((elantra.test$ElantraSales - predictions_ElantraSales)^2)
# Sum of Squared Erros from baseline model  (aka Total Sum of Squres)  
SST_a = sum((elantra.test$ElantraSales - mean(elantra.train$ElantraSales))^2)
# Out of Sample R^2
OSR2_a = 1 - SSE_a/SST_a
OSR2_a


# Exploring a varitation of the data set
# Load data:
elantra_plot <- read.csv("Elantra142-Fall2017-RGDP.csv") 
# Confirm data:
View(elantra_plot) 

#### EDA ####
ggplot(elantra_plot, aes(x = MonthNumeric, y = ElantraSales, color = MonthFactor)) + 
  geom_point() + xlab("2010 through 2017") + ylab("Elantra Units Sold")

#### Iterations for selecting best model ####
seasonal_ES <- lm(ElantraSales ~ MonthFactor + Unemployment + 
                    ElantraQueries + CPI.Energy + CPI.All, data = elantra.train)

#### Identify Subset of features to be considered ####
# 1. Confidence interval plot
ggcoef(
  seasonal_ES,
  vline_color = "red",
  vline_linetype =  "solid",
  errorbar_color = "blue",
  errorbar_height = .25,
  exclude_intercept = TRUE)

# 2. Outputs stars based on importance of feature
vif(seasonal_ES)

## Second Iteration minus Unemployment ##
seasonal_ES2 <- lm(ElantraSales ~ MonthFactor + ElantraQueries + CPI.Energy + CPI.All, data = elantra.train)
vif(seasonal_ES2)

## Third Iteration less CPI.Energy ##
seasonal_ES3 <- lm(ElantraSales ~ MonthFactor + ElantraQueries + CPI.All, data = elantra.train)
vif(seasonal_ES3)
ggcoef(seasonal_ES3, vline_color = "red", vline_linetype =  "solid", errorbar_color = "blue", errorbar_height = .25, exclude_intercept = TRUE)
summary(seasonal_ES3)

## Evaluate seasonal model on training data ##
# Compute y^hat_i (responses)
prediction_seasonal_ES <- predict(seasonal_ES3, newdata=elantra.test) 
# 5 Point analysis on predicted reponses
summary(prediction_seasonal_ES)


#### Quantitavie evaluation of seasonal model ####
# Sum of Squared Errors from regression model (aka Residual Sum of Squares)
SSE_b = sum((elantra.test$ElantraSales - prediction_seasonal_ES)^2)
# Sum of Squared Erros from baseline model  (aka Total Sum of Squres)  
SST_b = sum((elantra.test$ElantraSales - mean(elantra.train$ElantraSales))^2)
# Out of Sample R^2
OSR2_b = 1 - SSE_b/SST_b
OSR2_b


#### Subset model built from part a and b ####
combination_ES <- lm(ElantraSales ~ MonthFactor + CPI.All, data = elantra.train)
# evaluating variables
vif(combination_ES)
# plot of evaluation
ggcoef(combination_ES, vline_color = "red", vline_linetype =  "solid", errorbar_color = "blue", errorbar_height = .25, exclude_intercept = TRUE)
summary(combination_ES)


#### Evaluate combined model on training data ####
# Compute y^hat_i
prediction_combination_ES <- predict(combination_ES, newdata=elantra.test) 
# 5 Point analysis on predicted reponses
summary(prediction_combination_ES)

## Quantitavie evaluation of combination model ##
# Sum of Squared Errors from regression model (aka Residual Sum of Squares)
SSE_c = sum((elantra.test$ElantraSales - prediction_combination_ES)^2)
# Sum of Squared Erros from baseline model  (aka Total Sum of Squres)  
SST_c = sum((elantra.test$ElantraSales - mean(elantra.train$ElantraSales))^2)
# Out of Sample R^2
OSR2_c = 1 - SSE_c/SST_c
OSR2_c


# Load data:
elantra3 <- read.csv("Elantra142-Fall2017-RGDP2.csv")
# Confirm data:
View(elantra3) 

#### Linear filtering of time series, by chronological order (year) ####
elantra3.train <- filter(elantra3, Year < 2015) 
elantra3.test <- filter(elantra3, Year > 2014)
# Confirm proper training
View(elantra3.train)
View(elantra3.test)

#### model based on new variable ####
custom_ES3 <- lm(ElantraSales ~ MonthFactor + ElantraQueries + CPI.Energy + RGDP, data = elantra3.train)
vif(custom_ES3)
ggcoef(custom_ES3, vline_color = "red", vline_linetype =  "solid", errorbar_color = "blue", errorbar_height = .25, exclude_intercept = TRUE)
summary(custom_ES3)

#### Evaluate seasonal model on training data ####
# Compute y^hat_i
prediction_custom_ES <- predict(custom_ES3, newdata=elantra3.test) 
# 5 Point analysis on predicted reponses
summary(prediction_custom_ES)

#### Quantitavie evaluation of combination model ####
# Sum of Squared Errors from regression model (aka Residual Sum of Squares)
SSE_d = sum((elantra3.test$ElantraSales - prediction_custom_ES)^2)
# Sum of Squared Erros from baseline model  (aka Total Sum of Squres)  
SST_d = sum((elantra3.test$ElantraSales - mean(elantra3.train$ElantraSales))^2)
# Out of Sample R^2
OSR2_d = 1 - SSE_d/SST_d
OSR2_d

# Using the combined model developed for part c:
summary(seasonal_ES3)
summary(combination_ES)
# Average number of elantra queries for Jan/17-Jul/17 
i <- 92
# CPI average for Jan/17-Jul/17 
j <- 244.03
# Actual sales
act <- 15127

Aug2017_ES_combined <- ((-84309.21) - 7011.47*(0) - 5063.52*(0) + 446.33*(0) + 416.636*(0) - 496.86*(0) + 696.16*(0) 
                                    - 2.97*(1) - 3122.47*(0) - 6600.71*(0) - 6039.35*(0) - 2505.80*(0) + 452.00*(j))
Error <- abs(Aug2017_ES_combined - act)
Error
####-------------------------------------------------------------------####
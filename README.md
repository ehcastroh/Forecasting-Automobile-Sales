# Forecasting Automobile Sales
## Forecasting Hyundai Elantra Sales (Adapted from Bertsimas 22.1)
### Elias Castro Hernandez - Fall 2017


## Intro
Nearly all companies seek to accurately predict future sales of their product(s). 
If the company can accurately predict sales before producing the product, then they can better match production with customer demand, thus reducing unnecessary inventory costs while being able to satisfy demand for their product.

In this exercise, we seek to predict the monthly sales in the United States of the Hyundai Elantra. The Hyundai Motor Company is a major automobile manufacturer based in South Korea. The Elantra is a car model that has been produced by Hyundai since 1990 and is sold all over the world, including in the United States. We will use linear regression to predict monthly sales of the Elantra using economic indicators of the United States as well as (normalized) Google search query volumes. The data for this problem is contained in the file Elantra142-Fall2017.csv. 

## Procedure
We start by splitting the data into a training set and testing set. The training set will contain all observations for 2010, 2011, 2012, 2013, and 2014. The testing set will have all observations for 2015, 2016, and 2017. 

To begin, we will consider just the four independent variables Unemployment, ElantraQueries, CPI.Energy, and CPI.All. Using regression in an iterative way, we will then choose a subset of these four variables and construct a regression model to predict monthly Elantra sales (ElantraSales). Based on plots, and Variable Inflation Factor (VIF) analysis, we will choose which of the four variables to use in what will be our initial (naive) linear regression model. 

Evaluation and results analysis of naive model will be carried out. The results of our naive model analysis will be used in the development of an improved model. This process will be carried out until finally, we will develop a combined model that considers user-selected variables and the efficacy of any prior model in its structure.

Finally, our most accurate model will be used to predict unit sales of the Hyundai Elantra for the month of August 2017.

## Start Here:
The R file attached is an expansion of an assigned regression project in IEOR 142 (UC Berkeley - Introduction to Machine Learning).
The file is writen to be executed as is, and can be easily modified for other purposes. 
Please note that there are multiple instance of read.csv commands that read the same data. This was done for the purpose of readability, and to ensure that the user could clearly tell which instance of the model is being used.


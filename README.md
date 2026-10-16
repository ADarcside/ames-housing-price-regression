# Ames Housing Price Prediction Using Multiple Linear Regression

## Overview

This project applies multiple linear regression to the Ames Housing dataset to study the relationship between residential property characteristics and sale prices.

The analysis uses R and ordinary least squares (OLS) to build an interpretable baseline model. It also examines model fit, statistical significance, predictive performance, and regression assumptions.

## Objectives

- Apply multiple linear regression to a real-world housing dataset.
- Estimate regression coefficients using ordinary least squares.
- Examine model fit using R² and adjusted R².
- Evaluate the model using a held-out test set.
- Assess regression assumptions through diagnostic plots.
- Connect classical regression methods with concepts discussed in regression literature.

## Dataset

The Ames Housing dataset contains historical residential sales from Ames, Iowa.

- **Response variable:** `SalePrice`
- **Predictors:** `OverallQual`, `GrLivArea`, `TotalBsmtSF`, `GarageCars`, `FullBath`, `YearBuilt`, and `Neighborhood`

Dataset sources:

- [Ames Housing dataset repository](https://github.com/emanrao/AmesHousing)
- [Kaggle: House Prices — Advanced Regression Techniques](https://www.kaggle.com/competitions/house-prices-advanced-regression-techniques/data)

The dataset represents historical US housing sales and is not intended to represent current housing prices in other markets.

## Methodology

1. Load the dataset into R.
2. Select the response and explanatory variables.
3. Prepare the data and encode neighbourhood as a categorical factor.
4. Split the data into training and test sets.
5. Fit a multiple linear regression model using `lm()`.
6. Examine coefficient estimates, R², adjusted R², and the overall F-test.
7. Evaluate predictions using RMSE, MAE, and test-set R².
8. Inspect residual and influence diagnostics.

## Model

The regression model can be represented as:

\[
SalePrice = \beta_0 + \beta_1 OverallQual + \beta_2 GrLivArea
+ \beta_3 TotalBsmtSF + \beta_4 GarageCars
+ \beta_5 FullBath + \beta_6 YearBuilt
+ \gamma Neighborhood + \epsilon
\]

## Tools and Technologies

- R
- RStudio
- Multiple linear regression
- Ordinary least squares
- ANOVA
- Statistical model evaluation and diagnostic plots

## Research Reference

Tai, Y. (2021). *A Survey of Regression Algorithms and Connections with Deep Learning*. arXiv:2104.12647. https://arxiv.org/abs/2104.12647

De Cock, D. (2011). *Ames, Iowa: Alternative to the Boston Housing Data as an End of Semester Regression Project*. Journal of Statistics Education, 19(3). https://doi.org/10.1080/10691898.2011.11889627

## Project Status

The project implements a multiple linear regression workflow. Numerical results and model-performance claims should be added after running the analysis and verifying the output.

## Limitations

The data are historical and geographically specific. The model estimates statistical associations rather than causal effects, and its predictive performance may not generalize to other housing markets.

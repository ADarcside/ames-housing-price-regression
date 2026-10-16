# MULTIPLE LINEAR REGRESSION: REAL HOUSE-SALE DATA
# Dataset: Ames Housing (De Cock, 2011), via a public GitHub mirror of the Kaggle data.
# Data describes houses sold in Ames, Iowa, USA; it is NOT Indian housing-market data.
# The script downloads the CSV directly, so a separate manual download is not required.

# --------------------------- 1. Load packages/data ---------------------------
# Uses base R only; no packages need to be installed.
data_url <- "https://raw.githubusercontent.com/emanrao/AmesHousing/master/train.csv"

cat("Downloading Ames Housing data...\n")
house <- read.csv(data_url, stringsAsFactors = FALSE)

cat("Rows:", nrow(house), " Columns:", ncol(house), "\n")
cat("Columns used in this model:\n")
print(c("SalePrice", "OverallQual", "GrLivArea", "TotalBsmtSF",
        "GarageCars", "FullBath", "YearBuilt", "Neighborhood"))

# --------------------------- 2. Select variables -----------------------------
# Response (Y): SalePrice in US dollars.
# Predictors (X): overall quality, above-ground living area, basement area,
# garage capacity, full bathrooms, year built, and neighborhood.
vars <- c("SalePrice", "OverallQual", "GrLivArea", "TotalBsmtSF",
          "GarageCars", "FullBath", "YearBuilt", "Neighborhood")
house_model <- house[, vars]

# Convert neighborhood to a categorical/factor variable.
house_model$Neighborhood <- factor(house_model$Neighborhood)

# Handle missing values only in the variables used by this model.
n_before <- nrow(house_model)
house_model <- na.omit(house_model)
cat("Rows retained after removing missing values in selected variables:",
    nrow(house_model), "of", n_before, "\n")

# --------------------------- 3. Explore data ---------------------------------
str(house_model)
summary(house_model)
cat("\nMissing values in model data:\n")
print(colSums(is.na(house_model)))

# Plot price vs living area and quality.
par(mfrow = c(1, 2))
plot(house_model$GrLivArea, house_model$SalePrice,
     xlab = "Above-ground living area (sq ft)",
     ylab = "Sale price (USD)", main = "Price vs living area",
     pch = 19, col = "steelblue")
plot(house_model$OverallQual, house_model$SalePrice,
     xlab = "Overall quality rating (1-10)",
     ylab = "Sale price (USD)", main = "Price vs overall quality",
     pch = 19, col = "darkgreen")
par(mfrow = c(1, 1))

# --------------------------- 4. Train/test split -----------------------------
# Fixed seed makes the split reproducible.
set.seed(2026)
train_id <- sample(seq_len(nrow(house_model)),
                   size = floor(0.80 * nrow(house_model)))
train <- house_model[train_id, ]
test  <- house_model[-train_id, ]

cat("Training rows:", nrow(train), "\n")
cat("Testing rows:", nrow(test), "\n")

# --------------------------- 5. Fit multiple linear regression ---------------
# This is a multiple linear regression because it uses several predictors.
# Neighborhood is categorical; R creates indicator/dummy variables automatically.
model <- lm(
  SalePrice ~ OverallQual + GrLivArea + TotalBsmtSF +
    GarageCars + FullBath + YearBuilt + Neighborhood,
  data = train
)

cat("\n================ MODEL SUMMARY ================\n")
print(summary(model))

cat("\n================ ANOVA TABLE ===================\n")
# Type I (sequential) ANOVA: sums of squares depend on predictor order.
print(anova(model))

# --------------------------- 6. Overall model ANOVA ---------------------------
# Overall F test: H0 that all non-intercept coefficients are zero.
# summary(model) reports this F statistic and its p-value.
model_summary <- summary(model)
cat("\nOverall F-statistic:", model_summary$fstatistic[1], "\n")
cat("Numerator df:", model_summary$fstatistic[2], "\n")
cat("Denominator df:", model_summary$fstatistic[3], "\n")
overall_p <- pf(model_summary$fstatistic[1],
                model_summary$fstatistic[2],
                model_summary$fstatistic[3],
                lower.tail = FALSE)
cat("Overall model p-value:", overall_p, "\n")

# --------------------------- 7. Test-set performance -------------------------
pred <- predict(model, newdata = test)
actual <- test$SalePrice

test_rmse <- sqrt(mean((actual - pred)^2))
test_mae  <- mean(abs(actual - pred))
test_r2   <- 1 - sum((actual - pred)^2) /
  sum((actual - mean(actual))^2)

cat("\n============= HELD-OUT TEST PERFORMANCE =============\n")
cat("Test RMSE (USD):", round(test_rmse, 2), "\n")
cat("Test MAE  (USD):", round(test_mae, 2), "\n")
cat("Test R-squared:", round(test_r2, 4), "\n")
cat("Training R-squared:", round(model_summary$r.squared, 4), "\n")
cat("Training adjusted R-squared:", round(model_summary$adj.r.squared, 4), "\n")

# Interpretation:
# R-squared describes the fraction of variation explained on the data used
# for that calculation. Adjusted R-squared penalizes model size, but is still
# a training-set statistic. Test RMSE/MAE/R2 assess performance on held-out data.

# --------------------------- 8. Diagnostic plots -----------------------------
par(mfrow = c(2, 2))
plot(model)
par(mfrow = c(1, 1))

# --------------------------- 9. Example prediction ----------------------------
# Example: a house with quality 7, 1,800 sq ft living area, 900 sq ft basement,
# a 2-car garage, 2 full bathrooms, built in 2000, in the NAmes neighborhood.
# Neighborhood must be one of the factor levels in the dataset.
new_house <- data.frame(
  OverallQual = 7,
  GrLivArea = 1800,
  TotalBsmtSF = 900,
  GarageCars = 2,
  FullBath = 2,
  YearBuilt = 2000,
  Neighborhood = factor("NAmes", levels = levels(train$Neighborhood))
)

if ("NAmes" %in% levels(train$Neighborhood)) {
  cat("\n============= EXAMPLE PREDICTION =============\n")
  print(predict(model, newdata = new_house, interval = "prediction"))
} else {
  cat("NAmes not present in training factor levels; choose a level from levels(train$Neighborhood).\n")
}

# --------------------------- 10. Optional log-price model --------------------
# Sale prices are often right-skewed. Compare this only if justified by residual
# diagnostics and your assignment requirements; don't select a model solely
# because it increases R-squared.
#
# log_model <- lm(
#   log(SalePrice) ~ OverallQual + GrLivArea + TotalBsmtSF +
#     GarageCars + FullBath + YearBuilt + Neighborhood,
#   data = train
# )
# summary(log_model)
# par(mfrow = c(2, 2)); plot(log_model); par(mfrow = c(1, 1))

# --------------------------- 11. Source citation ------------------------------
cat("\nDataset source: De Cock, D. (2011), Ames, Iowa: Alternative to the Boston Housing Data as an End of Semester Regression Project, Journal of Statistics Education, 19(3).\n")
cat("Original Kaggle competition: https://www.kaggle.com/c/house-prices-advanced-regression-techniques\n")
cat("Public CSV mirror: https://github.com/emanrao/AmesHousing\n")

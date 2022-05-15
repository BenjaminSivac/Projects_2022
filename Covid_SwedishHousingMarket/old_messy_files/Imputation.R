library(imputeTS)
library(missForest)

kb <- read.table("Data - makstat_bostadsratter - kboy_kommuner.csv", header = TRUE, sep = ",", dec = ".")

# Semi-listwise deletion 50%
kb[kb == 0] <- NA # assign NA to 0 values
delete.na <- function(BF, n=0) { # delete too many NA function
  BF[rowSums(is.na(BF)) <= n,]
}
kb <- delete.na(kb, 24)

#TRANSPOSE
n <- kb$LK # first remember the names
kb <- kb[, -c(1, 2, 3, 4, 5) ] # remove useless columns
kb_T <- t(kb) 
colnames(kb_T) <- n

#Imputation
kb_imp <- na_seadec(kb_T, algorithm = "interpolation", find_frequency=TRUE)

par(mfrow=c(2,1), oma=c(0,0,0,0))
#plot
kb_T_ts <- ts(kb_T[,37], frequency = 12, start = c(2017,10))
kb_imp_ts <- ts(kb_imp[,37], frequency = 12, start = c(2017,10))

ggplot_na_imputations(
  kb_T_ts,
  kb_imp_ts,
  title = "Imputed Values for price/square meter",
  subtitle = "Visualization of missing value replacements in Trosa",
  xlab = "Time",
  ylab = "Price / m^2",
  color_points = "steelblue",
  color_imputations = "indianred",
  color_truth = "seagreen3",
  color_lines = "lightslategray",
  shape_points = 16,
  shape_imputations = 18,
  shape_truth = 16,
  size_points = 1.5,
  size_imputations = 2.5,
  size_truth = 1.5,
  size_lines = 0.5,
  linetype = "solid",
  connect_na = TRUE,
  legend = TRUE,
  legend_size = 5,
  label_known = "known values",
  label_imputations = "imputed values",
  label_truth = "ground truth",
  theme = ggplot2::theme_linedraw()
)
#write table
write.table(kb_imp, "Data - kb_imp.csv", row.names = FALSE, sep = ",", dec = ".")



#########################################################################

kt <- read.table("Data - makstat_villor - K_T_kommune.csv", header = TRUE, sep = ",", dec = ".")

# Semi-listwise deletion 50%
kt[kt == 0] <- NA # assign NA to 0 values
delete.na <- function(BF, n=0) { # delete too many NA function
  BF[rowSums(is.na(BF)) <= n,]
}
kt <- delete.na(kt, 24)

#TRANSPOSE
n <- kt$LK # first remember the names
kt <- kt[, -c(1, 2, 3) ] # remove useless columns
kt_T <- t(kt) 
colnames(kt_T) <- n
#sum(is.na(kt_T)) = 875
#sum(!is.na(kt_T)) = 7861
# 10% missing NA's.
#Imputation

kt_imp <- na_seadec(kt_T, algorithm = "interpolation", find_frequency=TRUE)

# random tests
kb_ts <- ts(kt_T[,23], frequency = 12, start = c(2017, 10)) 
imp_ts<- ts(kt_imp[,23], start=c(2017,10), frequency = 12)

plot.ts(kb_ts)
lines(imp_ts, col = "red")

# Plot
ggplot_na_imputations(
  kt_T[,9],
  kt_imp[,9],
  x_with_truth = NULL,
  x_axis_labels = NULL,
  title = "Imputed Values for Purchase price / Taxable value - Coefficient",
  subtitle = "Visualization of missing value replacements in Salem",
  xlab = "Time",
  ylab = "P/T",
  color_points = "steelblue",
  color_imputations = "indianred",
  color_truth = "seagreen3",
  color_lines = "lightslategray",
  shape_points = 16,
  shape_imputations = 18,
  shape_truth = 16,
  size_points = 1.5,
  size_imputations = 2.5,
  size_truth = 1.5,
  size_lines = 0.5,
  linetype = "solid",
  connect_na = TRUE,
  legend = TRUE,
  legend_size = 5,
  label_known = "known values",
  label_imputations = "imputed values",
  label_truth = "ground truth",
  theme = ggplot2::theme_linedraw()
)
#Write table
write.table(kt_imp, "Data - kt_imp.csv", row.names = FALSE, sep = ",", dec = ".")








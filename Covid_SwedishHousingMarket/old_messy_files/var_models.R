library(dplyr)
library(forecast)
library(car)
library(orcutt)
library(lmtest)
library(stats)
library(urca)
library(vars)
library(strucchange)
library(aTSA)
library(seasonal)
library(ggplot2)

################################## Possible, Control variables ##########################
KPI <- c(1846,1850, 1857,
         1842, 1855, 1860, 1868, 1872, 1876, 1886, 1882, 1891, 1888, 1887, 1895, 
         1876, 1890, 1895, 1908, 1913, 1910, 1917, 1909, 1918, 1919, 1921, 1928, 
         1900, 1910, 1907, 1901, 1912, 1923, 1928, 1925, 1926, 1924, 1924, 1938,
         1930, 1936, 1939, 1944, 1947, 1949, 1954, 1964, 1974)
KPIK <- (KPI/1846)*100
KPIK <- KPIK/100
KIH <- c(105.7,	107.5,	106.6,	106.5,	104.6,	102.2,	102.4,	102.1,	100.3, 100.4,	103.8,
         104.9,	99.6,	98.6,	95.1,	93.2,	93.7,	96.3,	98.3,	95.1,	96.6,	99.0,
         94.8, 90.9,	93.8,	94.2,	94.7,	93.4,	98.9,	89.6, 72.8,	77.2,	84.2,	
         84.3,	84.9,	87.4,	89.9,	89.6,	92.1,	94.2,	97.8,	96.8,	103.3,	111.3,	108.7,	106.1,	107.8, 106.3)
KIH <- ((KIH/105.7) * 100) / 100 # KIHK

# icke stationär. https://www.ekonomifaKBa.se/faKBa/arbetsmarknad/arbetsloshet/arbetsloshet/.  
AL <- c(6.3, 5.8, 6.0, 7.0, 6.3, 6.5, 6.8, 6.5, 7.2, 6.2, 6.0, 5.8, 5.7, 5.8, 
        6.1, 6.5, 7.3, 7.7, 6.8, 7.1, 7.2, 6.9, 6.9, 6.0, 6.0, 6.8, 6.0, 7.5,
        8.2, 7.1, 8.2, 9.0, 9.8, 8.9, 8.8, 8.3, 7.8, 7.7, 8.2, 9.3, 9.7, 10.0, 9.4, 9.8, 10.3, 8.0, 8.5, 8.2)

SSVX <- c(-0.6841, -0.6841, -0.6798,	-0.7325, -0.7413, -0.6592, -0.656, -0.7073, -0.6939, -0.6677,	
          -0.6921, -0.6987, -0.5974, -0.6235, -0.6911, -0.7222,	-0.4486, -0.4008, -0.3995, -0.4003, 
          -0.4003, -0.391, -0.3909, -0.3955, -0.3992, -0.4316, -0.4175, -0.4157, -0.2478, -0.1704,
          -0.1899, -0.1405,	-0.1418, -0.1214,	-0.1134, -0.1299,	-0.1153, -0.1316,	-0.1263,
          -0.2092, -0.1722,	-0.1363, -0.1393,	-0.1519, -0.1487,	-0.1667, -0.1614,	-0.1982)

# Trend adjusted. https://www.ekonomifaKBa.se/FaKBa/Ekonomi/Hushallens-ekonomi/hushallens-konsumtion/
HK <- c(0.7, 1.6, 1.4, 0.6, 1.5, 2.9, 3.6, 2.6, 2.0, -0.6, -0.1,
        0.0, -0.2, 0.3, -0.6, 1.2, 0.4, 0.2, 0.1, -0.7, 0.0, 2.3, 2.3, 3.0, 2.2, 1.5, 2.7, 
        0.9, 2.0, -4.2, -11.1, -9.8, -6.6, -3.8, -3.9, -4.3, -4.3, -5.6, -6.5, 
        -3.9, -1.6, 5.5, 8.7, 10.7, 8.6, 6.6, 5.1, 4.6)
kb <- read.table("Data - makstat_bostadsratter - kboy_kommuner_imp.csv", header = TRUE, sep = ",", dec = ".")


######################### Indelning ###############################################
kb_1 <- subset(kb, Indelning.typ.3 == "1")
rownames(kb_1)<-kb_1[,1]
kb_1<-kb_1[-c(1,2,3)]
kb_1 <- t(kb_1)
kb_1_rs <- rowSums(kb_1, na.rm=FALSE, dims=1)
(kb_1_mean <- kb_1_rs/ncol(kb_1))
#kb_1_mean <- kb_1_mean / KPIK # KPI adjusted
kb_1_ts <- as.data.frame(kb_1_mean)
colnames(kb_1_ts) <- c("Kboy")
kb_1_ts$KPIK <- KPIK
kb_1_ts$KIH <- KIH
kb_1_ts$AL <- AL

kb_2 <- subset(kb, Indelning.typ.3 == "2")
rownames(kb_2)<-kb_2[,1]
kb_2<-kb_2[-c(1,2,3)]
kb_2 <- t(kb_2)
kb_2_rs <- rowSums(kb_2, na.rm=FALSE, dims=1)
(kb_2_mean <- kb_2_rs/ncol(kb_2))
# kb_2_mean <- kb_2_mean / KPIK
kb_2_ts <- as.data.frame(kb_2_mean)
colnames(kb_2_ts) <- c("Kboy")
kb_2_ts$KPIK <- KPIK
kb_2_ts$KIH <- KIH
kb_2_ts$AL <- AL

kb_3 <- subset(kb, Indelning.typ.3 == "3")
rownames(kb_3)<-kb_3[,1]
kb_3<-kb_3[-c(1,2,3)]
kb_3 <- t(kb_3)
kb_3_rs <- rowSums(kb_3, na.rm=FALSE, dims=1)
(kb_3_mean <- kb_3_rs/ncol(kb_3))
# kb_3_mean <- kb_3_mean / KPIK
kb_3_ts <- as.data.frame(kb_3_mean)
colnames(kb_3_ts) <- c("Kboy")
kb_3_ts$KPIK <- KPIK
kb_3_ts$KIH <- KIH
kb_3_ts$AL <- AL

############################## Plots ##########################################
plot(kb_1_ts$Kboy, type="o")
acf_kb1 <- as.data.frame(kb_1_ts[,1])
par(mfrow=c(2,1), oma=c(0,0,0,0))
acf(acf_kb1, lag.max = 48, type="correlation", main= "ACF of Price per m2, group 1")
acf(acf_kb1, lag.max = 48, type="partial", main= "ACF of Price / m2, group 1")
kb_1_ts <- ts(kb_1_ts, frequency = 12, start = c(2017,10))

plot(kb_2_ts$Kboy, type="o")
acf_kb2 <- as.data.frame(kb_2_ts[,1])
par(mfrow=c(2,1), oma=c(0,0,0,0))
acf(acf_kb2, lag.max=48, type="correlation", main= "ACF of Price per m2, group 2")
acf(acf_kb2, lag.max=48, type="partial", main= "ACF of Price per m2, group 2")
kb_2_ts <- ts(kb_2_ts, frequency = 12, start = c(2017,10))

plot(kb_3_ts$Kboy, type="o")
acf_kb3 <- as.data.frame(kb_3_ts[,1])
par(mfrow=c(3,2), oma=c(0,0,0,0))
acf(acf_kb3, lag.max=48, type="correlation", main= "ACF of Price per m2, group 3")
acf(acf_kb3, lag.max=48, type="partial", main= "ACF of Price per m2, group 3")
kb_3_ts <- ts(kb_3_ts, frequency = 12, start = c(2017,10))

plot.ts(kb_1_ts[,1], type = "o", ylim=range(18000,44000), main = "Price/m\u00B2 groups", ylab = "", xlab="", sub = "Group 1 = Black,Group 2 = Red, Group 3 = Blue")
lines(kb_2_ts[,1], type = "o", col = "red", sub="test")
lines(kb_3_ts[,1], type = "o", col = "blue")

############################### Fix non-stationarity ! #########################
# SEAT KB 1 - Better :) ARIMA: (0 1 1)
kb_comp.1 <- seas(kb_1_ts[,1], transform.function = "none")
autoplot(kb_comp.1, main = "Decomposition for Price/m\u00B2, using X-13ARIMA-SEATS: (0 2 2)")
checkresiduals(irregular(kb_comp.1))
par(mfrow=c(2,1), oma=c(0,0,0,0))
acf_kb_comp.1 <- as.data.frame(kb_comp.1)
acf(acf_kb_comp.1$irregular, lag.max = 48, main = "Remainder of Price/m\u00B2 group 1")
acf(acf_kb_comp.1$irregular, lag.max = 48, type="partial", main = "")
aTSA::adf.test(irregular(kb_comp.1), nlag = 13)
kpss.test(irregular(kb_comp.1), lag.short = FALSE) # Good
pp.test(irregular(kb_comp.1), lag.short = FALSE) # Good

kb_dt.1 <- irregular(kb_comp.1)
kb_dt.1 <- as.data.frame(kb_dt.1)
kb_s.1 <- seasonal(kb_comp.1)
kb_s.1 <- as.data.frame(kb_s.1)
colnames(kb_s.1) <- c("KB")
kb_t.1 <- trendcycle(kb_comp.1)
kb_t.1 <- as.data.frame(kb_t.1)
colnames(kb_t.1) <- c("KB")

kb_dt.1$KPIK <- KPIK
kb_dt.1$KIH <- KIH
kb_dt.1$AL <- AL
colnames(kb_dt.1) <- c("KB", "KPIK", "KIH", "AL")

# SEAT KB 2 (1 1 0)
kb_comp.2 <- seas(kb_2_ts[,1], transform.function = "none")
autoplot(kb_comp.2, main = "Decomposition for Price/m\u00B2, using X-13ARIMA-SEATS: (1 1 0)")
checkresiduals(irregular(kb_comp.2))
par(mfrow=c(2,1), oma=c(0,0,0,0))
acf_kb_comp.2 <- as.data.frame(kb_comp.2)
acf(acf_kb_comp.2$irregular, lag.max = 48, main = "Remainder of Price/m\u00B2 group 2")
acf(acf_kb_comp.2$irregular, lag.max = 48, type="partial", main = "")
aTSA::adf.test(irregular(kb_comp.2), nlag = 13)
kpss.test(irregular(kb_comp.2), lag.short = FALSE) # Good
pp.test(irregular(kb_comp.2), lag.short = FALSE) # Good

kb_dt.2 <- irregular(kb_comp.2)
kb_dt.2 <- as.data.frame(kb_dt.2)
kb_s.2 <- seasonal(kb_comp.2)
kb_s.2 <- as.data.frame(kb_s.2)
colnames(kb_s.2) <- c("KB")
kb_t.2 <- trendcycle(kb_comp.2)
kb_t.2 <- as.data.frame(kb_t.2)
colnames(kb_t.2) <- c("KB")

kb_dt.2$KPIK <- KPIK
kb_dt.2$KIH <- KIH
kb_dt.2$AL <- AL
colnames(kb_dt.2) <- c("KB", "KPIK", "KIH", "AL")

# SEAT KB 3  - (0 1 1)(0 1 1)
kb_comp.3 <- seas(kb_3_ts[,1], transform.function = "none")
autoplot(kb_comp.3, main = "Decomposition for Price/m\u00B2 group 3, using X-13ARIMA-SEATS: (0 1 1)(0 1 1)")
checkresiduals(irregular(kb_comp.3))
par(mfrow=c(2,1), oma=c(0,0,0,0))
acf_kb_comp.3 <- as.data.frame(kb_comp.3)
acf(acf_kb_comp.3$irregular, lag.max = 48, main = "Remainder of Price/m\u00B2 group 3")
acf(acf_kb_comp.3$irregular, lag.max = 48, type="partial", main = "")
aTSA::adf.test(irregular(kb_comp.3), nlag = 13)
kpss.test(irregular(kb_comp.3), lag.short = FALSE) # Good
pp.test(irregular(kb_comp.3), lag.short = FALSE) # Good

kb_dt.3 <- irregular(kb_comp.3)
kb_dt.3 <- as.data.frame(kb_dt.3)
kb_s.3 <- seasonal(kb_comp.3)
kb_s.3 <- as.data.frame(kb_s.3)
colnames(kb_s.3) <- c("KB")
kb_t.3 <- trendcycle(kb_comp.3)
kb_t.3 <- as.data.frame(kb_t.3)
colnames(kb_t.3) <- c("KB")

kb_dt.3$KPIK <- KPIK
kb_dt.3$KIH <- KIH
kb_dt.3$AL <- AL
colnames(kb_dt.3) <- c("KB", "KPIK", "KIH", "AL")

# STL test kpik.
stl_kpik <- stl(kb_1_ts[,2], t.window = 5, s.window = "periodic") # t=9, s = periodic. Try t=5
autoplot(stl_kpik, main = "Seasonal and Trend decomposition using Loess")
checkresiduals(remainder(stl_kpik))
par(mfrow=c(2,1), oma=c(0,0,0,0))
acf(remainder(stl_kpik), lag.max = 48, main = "Remainder of CPI")
acf(remainder(stl_kpik), lag.max = 48 , type="partial", main = "Remainder of CPI")
aTSA::adf.test(remainder(stl_kpik), nlag = 13)
kpss.test(remainder(stl_kpik), lag.short = FALSE) # good at t=5.
pp.test(remainder(stl_kpik), lag.short = FALSE)

kpik_dt <- remainder(stl_kpik)
kpik_dt <- as.data.frame(kpik_dt)

kb_dt.1$KPIK <- kpik_dt
kb_dt.2$KPIK <- kpik_dt
kb_dt.3$KPIK <- kpik_dt

kpik_s <- seasonal(stl_kpik)
kpik_s <- as.data.frame(kpik_s)
kpik_t <- trendcycle(stl_kpik)
kpik_t <- as.data.frame(kpik_t)

kb_s.1$KPIK <- kpik_s
kb_s.2$KPIK <- kpik_s
kb_s.3$KPIK <- kpik_s
kb_t.1$KPIK <- kpik_t
kb_t.2$KPIK <- kpik_t
kb_t.3$KPIK <- kpik_t

# STL test kih
stl_kih <- stl(kb_1_ts[,3], t.window = 9, s.window = 13) # t=9, s = 13. AC 9 & 11.
autoplot(stl_kih, main = "Seasonal and Trend decomposition using Loess")
checkresiduals(remainder(stl_kih))
par(mfrow=c(2,1), oma=c(0,0,0,0))
acf(remainder(stl_kih), lag.max = 48, main = "Remainder of HCI")
acf(remainder(stl_kih), lag.max = 48 , type="partial", main = "Remainder of HCI")
aTSA::adf.test(remainder(stl_kih), nlag = 13)
kpss.test(remainder(stl_kih), lag.short = FALSE)
pp.test(remainder(stl_kih), lag.short = FALSE)

kih_dt <- remainder(stl_kih)
kih_dt <- as.data.frame(kih_dt)

kb_dt.1$KIH <- kih_dt
kb_dt.2$KIH <- kih_dt
kb_dt.3$KIH <- kih_dt

kih_s <- seasonal(stl_kih)
kih_s <- as.data.frame(kih_s)
kih_t <- trendcycle(stl_kih)
kih_t <- as.data.frame(kih_t)

kb_s.1$KIH <- kih_s
kb_s.2$KIH <- kih_s
kb_s.3$KIH <- kih_s
kb_t.1$KIH <- kih_t
kb_t.2$KIH <- kih_t
kb_t.3$KIH <- kih_t

# STL test al. SUCCESS. TESTING
stl_al <- stl(kb_1_ts[,4], t.window = 5, s.window = "periodic") # t=5, s = 13. NO AC.
autoplot(stl_al, main = "Seasonal and Trend decomposition using Loess")
checkresiduals(remainder(stl_al))
par(mfrow=c(2,1), oma=c(0,0,0,0))
acf(remainder(stl_al), lag.max = 48, main = "Remainder of Unemployment")
acf(remainder(stl_al), lag.max = 48 , type="partial", main = "Remainder of Unemployment")
aTSA::adf.test(remainder(stl_al), nlag = 13)
kpss.test(remainder(stl_al), lag.short = FALSE) # good
pp.test(remainder(stl_al), lag.short = FALSE)

al_dt <- remainder(stl_al)
al_dt <- as.data.frame(al_dt)

kb_dt.1$AL <- al_dt
kb_dt.2$AL <- al_dt
kb_dt.3$AL <- al_dt

al_s <- seasonal(stl_al)
al_s <- as.data.frame(al_s)
al_t <- trendcycle(stl_al)
al_t <- as.data.frame(al_t)

kb_s.1$AL <- al_s
kb_s.2$AL <- al_s
kb_s.3$AL <- al_s
kb_t.1$AL <- al_t
kb_t.2$AL <- al_t
kb_t.3$AL <- al_t


######################### VAR-models ###############################################
library(vars)
# https://www.econometrics-with-r.org/16-1-vector-autoregressions.html
# https://otexts.com/fpp2/VAR.html
# https://online.stat.psu.edu/stat510/lesson/11/11.2

# For whole dataset: KB_1
kb_dt.1c <- subset(kb_dt.1, select = -c(4))
VARselect(kb_dt.1c[1:3], lag.max = 12, type="none") # Select the VAR() dependant on criterion, SC=BIC is the best criterion.
var.1 <- VAR(kb_dt.1c[1:3], p = 4, type="none") # 1:3 KPI & KIH, p = 4, Adjusted R-squared:  0.679 
serial.test(var.1, lags.pt = 10, type="PT.asymptotic") # Portmanteau test.
predict.1 <- predict(var.1, n.ahead = 12)
summary(var.1) 
roots(var.1)
par(mfrow=c(2,1), oma=c(0,0,0,0))
acf(var.1$varresult$KB$residuals, lag.max = 48, main = "Residuals of VAR(4) model of Price per m2, group 1")
acf(var.1$varresult$KB$residuals, lag.max = 48, type = "partial", main = "Residuals of VAR(4) model of Price per m2, group 1")
par(mfrow=c(2,2), oma=c(0,0,0,0))
qqnorm(var.1$varresult$KB$residuals, datax = FALSE, main = "Normal Q-Q plot", ylab = "Percent", xlab = "Residual")
qqline(var.1$varresult$KB$residuals)
plot(var.1$varresult$KB$fitted.values, main = "Residuals versus the fitted values", ylab = "Residual", xlab ="Fitted value")
abline(h=0)
hist(var.1$varresult$KB$residuals, add.normal=TRUE, main = "Histogram of the residuals", xlab = "Residual")
plot(var.1$varresult$KB$residuals, type="o", main = "Residuals versus the order of the data", ylab = "Residual", xlab = "Observation order")
abline(h=0)

vars::arch.test(var.1, lags.multi=4, multivariate.only = TRUE)
normality.test(var.1, multivariate.only = TRUE)

stability.var.1 <- stability(var.1, type="OLS-CUSUM")
plot(stability.var.1$stability$KB, main = "OLS-based Cusum test price per m2, group 1")

causality(var.1, cause = "KB")
causality(var.1, cause = "KPIK")# Significant
causality(var.1, cause = "KIH")# Significant

# to provide better forecast: t+s+r
kb_s.1s <- subset(kb_s.1, select = -c(4))
var.1s <- VAR(kb_s.1s[1:3], p = 4, type="none")
predict.1s <- predict(var.1s, n.ahead = 12)
fanchart(predict.1s)

kb_t.1t <- subset(kb_t.1, select = -c(4))
var.1t <- VAR(kb_t.1t[1:3], p = 4, type="none")
predict.1t <- predict(var.1t, n.ahead = 12)
fanchart(predict.1t)

### 
### First add and sum the endogen part (the first 48 values.)
predict.1.sum <- predict.1$endog[,1]
predict.1.sum <- as.data.frame(predict.1.sum)
names(predict.1.sum)[1] <-"Remainder"
predict.1.sum$season <- predict.1s$endog[,1]
predict.1.sum$trend <- predict.1t$endog[,1]
predict.1.sum
predict.1.sum <- rowSums(predict.1.sum, na.rm=TRUE, dims=1)
predict.1.sum <- as.data.frame(predict.1.sum)
### now we have to add and sum the forecasts. The forecast columns are in following order. Mean, lower, upper, CI. 
## We start with "lower"
rm(predict.1.sum.l)
predict.1$fcst$KB
predict.1.sum.l <-predict.1$fcst$KB[,2]
predict.1.sum.l <- as.data.frame(predict.1.sum.l)
names(predict.1.sum.l)[1] <-"Remainder"
predict.1.sum.l$season <-predict.1s$fcst$KB[,2]
predict.1.sum.l$trend <-predict.1t$fcst$KB[,2]
predict.1.sum.l <- rowSums(predict.1.sum.l, na.rm=TRUE, dims=1)
predict.1.sum.l <- as.data.frame(predict.1.sum.l)
## Upper
rm(predict.1.sum.u)
predict.1.sum.u <-predict.1$fcst$KB[,3]
predict.1.sum.u <- as.data.frame(predict.1.sum.u)
names(predict.1.sum.u)[1] <-"Remainder"
predict.1.sum.u$season <-predict.1s$fcst$KB[,3]
predict.1.sum.u$trend <-predict.1t$fcst$KB[,3]
predict.1.sum.u <- rowSums(predict.1.sum.u, na.rm=TRUE, dims=1)
predict.1.sum.u <- as.data.frame(predict.1.sum.u)
## Mean 
rm(predict.1.sum.m)
predict.1.sum.m <-predict.1$fcst$KB[,1]
predict.1.sum.m <- as.data.frame(predict.1.sum.m)
names(predict.1.sum.m)[1] <-"Remainder"
predict.1.sum.m$season <-predict.1s$fcst$KB[,1]
predict.1.sum.m$trend <-predict.1t$fcst$KB[,1]
predict.1.sum.m <- rowSums(predict.1.sum.m, na.rm=TRUE, dims=1)
predict.1.sum.m <- as.data.frame(predict.1.sum.m)
names(predict.1.sum)[1] <- "Merge"
predict.1.sum <- as.data.frame(predict.1.sum)
## Lower
predict.1.sum.l <- predict.1.sum %>% add_row(Merge=predict.1.sum.l[,1])
predict.1.sum.u <- predict.1.sum %>% add_row(Merge=predict.1.sum.u[,1])
predict.1.sum.m <- predict.1.sum %>% add_row(Merge=predict.1.sum.m[,1])
predict.1.sum.l.ts <- ts(predict.1.sum.l, frequency=12, start=c(2017, 10))
predict.1.sum.u.ts <- ts(predict.1.sum.u, frequency=12, start=c(2017, 10))
predict.1.sum.m.ts <- ts(predict.1.sum.m, frequency=12, start=c(2017, 10))
plot(predict.1.sum.u.ts, col="red", ylab = "Price", main = "18 months prediction for KB, group 1")
lines(predict.1.sum.l.ts, col="red")
lines(predict.1.sum.m.ts)

# For whole dataset: KB 2
kb_dt.2c <- subset(kb_dt.2, select = -c(4))
VARselect(kb_dt.2c[1:2], lag.max = 12, type="none") # Select the VAR() dependant on criterion, SC=BIC is the best criterion.
var.2 <- VAR(kb_dt.2c[1:3], p = 3, type="none") # seats: p=3, KIH & KPI 0.7465
serial.test(var.2, lags.pt = 10, type="PT.asymptotic") # Portmanteau test.
predict.2 <- predict(var.2, n.ahead = 12)
summary(var.2$varresult$KB) 
roots(var.2)
par(mfrow=c(2,1), oma=c(0,0,0,0))
acf(var.2$varresult$KB$residuals, lag.max = 48, main = "Residuals of VAR(3) model of price per m2, group 2")
acf(var.2$varresult$KB$residuals, lag.max = 48, type = "partial", main = "Residuals of VAR(3) model of price per m2, group 2")
par(mfrow=c(2,2), oma=c(0,0,0,0))
qqnorm(var.2$varresult$KB$residuals, datax = FALSE, main = "Normal Q-Q plot", ylab = "Percent", xlab = "Residual")
qqline(var.2$varresult$KB$residuals)
plot(var.2$varresult$KB$fitted.values, main = "Residuals versus the fitted values", ylab = "Residual", xlab ="Fitted value")
abline(h=0)
hist(var.2$varresult$KB$residuals, add.normal=TRUE, main = "Histogram of the residuals", xlab = "Residual")
plot(var.2$varresult$KB$residuals, type="o", main = "Residuals versus the order of the data", ylab = "Residual", xlab = "Observation order")
abline(h=0)

vars::arch.test(var.2, lags.multi=3, multivariate.only = TRUE)
normality.test(var.2, multivariate.only = TRUE)

stability.var.2 <- stability(var.2, type="OLS-CUSUM")
plot(stability.var.2$stability$KB, main = "OLS-based Cusum test price per m2, group 2")

causality(var.2, cause = "KB")
causality(var.2, cause = "KPIK") # Significant
causality(var.2, cause = "KIH") # Significant

# For prediction !
kb_s.2s <- subset(kb_s.2, select = -c(4))
var.2s <- VAR(kb_s.2s[1:2], p = 3, type="none")
predict.2s <- predict(var.2s, n.ahead = 12)
fanchart(predict.2s)

kb_t.2t <- subset(kb_t.2, select = -c(4))
var.2t <- VAR(kb_t.2t[1:2], p = 3, type="none")
predict.2t <- predict(var.2t, n.ahead = 12)
fanchart(predict.2t)

### 
### First add and sum the endogen part (the first 48 values.)
rm(predict.2.sum)
predict.2.sum <- predict.2$endog[,1]
predict.2.sum <- as.data.frame(predict.2.sum)
names(predict.2.sum)[1] <-"Remainder"
predict.2.sum$season <- predict.2s$endog[,1]
predict.2.sum$trend <- predict.2t$endog[,1]
predict.2.sum
predict.2.sum <- rowSums(predict.2.sum, na.rm=TRUE, dims=1)
predict.2.sum <- as.data.frame(predict.2.sum)
### now we have to add and sum the forecasts. The forecast columns are in following order. Mean, lower, upper, CI. 
## We start with "lower"
rm(predict.2.sum.l)
predict.2$fcst$KB
predict.2.sum.l <-predict.2$fcst$KB[,2]
predict.2.sum.l <- as.data.frame(predict.2.sum.l)
names(predict.2.sum.l)[1] <-"Remainder"
predict.2.sum.l$season <-predict.2s$fcst$KB[,2]
predict.2.sum.l$trend <-predict.2t$fcst$KB[,2]
predict.2.sum.l <- rowSums(predict.2.sum.l, na.rm= TRUE, dims=1)
predict.2.sum.l <- as.data.frame(predict.2.sum.l)
## Upper
rm(predict.2.sum.u)
predict.2.sum.u <-predict.2$fcst$KB[,3]
predict.2.sum.u <- as.data.frame(predict.2.sum.u)
names(predict.2.sum.u)[1] <-"Remainder"
predict.2.sum.u$season <-predict.2s$fcst$KB[,3]
predict.2.sum.u$trend <-predict.2t$fcst$KB[,3]
predict.2.sum.u <- rowSums(predict.2.sum.u, na.rm=TRUE, dims=1)
predict.2.sum.u <- as.data.frame(predict.2.sum.u)
## Mean 
rm(predict.2.sum.m)
predict.2.sum.m <-predict.2$fcst$KB[,1]
predict.2.sum.m <- as.data.frame(predict.2.sum.m)
names(predict.2.sum.m)[1] <-"Remainder"
predict.2.sum.m$season <-predict.2s$fcst$KB[,1]
predict.2.sum.m$trend <-predict.2t$fcst$KB[,1]
predict.2.sum.m <- rowSums(predict.2.sum.m, na.rm=TRUE, dims=1)
predict.2.sum.m <- as.data.frame(predict.2.sum.m)
names(predict.2.sum)[1] <- "Merge"
predict.2.sum <- as.data.frame(predict.2.sum)
## Lower
predict.2.sum.l <- predict.2.sum %>% add_row(Merge=predict.2.sum.l[,1])
predict.2.sum.u <- predict.2.sum %>% add_row(Merge=predict.2.sum.u[,1])
predict.2.sum.m <- predict.2.sum %>% add_row(Merge=predict.2.sum.m[,1])
predict.2.sum.l.ts <- ts(predict.2.sum.l, frequency=12, start=c(2017, 10))
predict.2.sum.u.ts <- ts(predict.2.sum.u, frequency=12, start=c(2017, 10))
predict.2.sum.m.ts <- ts(predict.2.sum.m, frequency=12, start=c(2017, 10))
plot(predict.2.sum.u.ts, col="red")
lines(predict.2.sum.l.ts, col="red")
lines(predict.2.sum.m.ts)

# For whole dataset: KB_3
kb_dt.3c <- subset(kb_dt.3, select = -c(3))
VARselect(kb_dt.3c[1:3], lag.max = 12, type="none") # Select the VAR() dependant on criterion, SC=BIC is the best criterion.
var.3 <- VAR(kb_dt.3c[1:2], p = 1, type="none") # 1:2 KIH, p = 3, Adjusted R-squared: 0.8305 (Fails). 1:2 KPI, p = 1, Adj R^2 = 0.78 (Succeeds)
serial.test(var.3, lags.pt = 10, type="PT.asymptotic") # Portmanteau test.
predict.3 <- predict(var.3, n.ahead = 12)
summary(var.3$varresult$KB) 
roots(var.3)
par(mfrow=c(2,1), oma=c(0,0,0,0))
acf(var.3$varresult$KB$residuals, lag.max = 48, main = "Residuals of VAR(1) model of price per m2, group 3")
acf(var.3$varresult$KB$residuals, lag.max = 48, type = "partial", main = "Residuals of VAR(1) model of price per m2, group 3")
par(mfrow=c(2,2), oma=c(0,0,0,0))
qqnorm(var.3$varresult$KB$residuals, datax = FALSE, main = "Normal Q-Q plot", ylab = "Percent", xlab = "Residual")
qqline(var.3$varresult$KB$residuals)
plot(var.3$varresult$KB$fitted.values, main = "Residuals versus the fitted values", ylab = "Residual", xlab ="Fitted value")
abline(h=0)
hist(var.3$varresult$KB$residuals, add.normal=TRUE, main = "Histogram of the residuals", xlab = "Residual")
plot(var.3$varresult$KB$residuals, type="o", main = "Residuals versus the order of the data", ylab = "Residual", xlab = "Observation order")
abline(h=0)

vars::arch.test(var.3, lags.multi=1, multivariate.only = TRUE)
normality.test(var.3, multivariate.only = TRUE)

stability.var.3 <- stability(var.3, type="OLS-CUSUM")
plot(stability.var.3$stability$KB, main = "OLS-based Cusum test price per m2, group 3")

causality(var.3, cause = "KB")
causality(var.3, cause = "KPIK") # Significant
causality(var.3, cause = "KIH") # Significant

# PREDICTION
kb_t.3t <- subset(kb_t.3, select = -c(3))
var.3t <- VAR(kb_t.3t[1:2], p = 1, type="none")
predict.3t <- predict(var.3t, n.ahead = 12)
fanchart(predict.3t)

kb_s.3s <- subset(kb_s.3, select = -c(3))
var.3s <- VAR(kb_s.3s[1:2], p = 1, type="none")
predict.3s <- predict(var.3s, n.ahead = 12)
fanchart(predict.3s)

### 
### First add and sum the endogen part (the first 48 values.)
rm(predict.3.sum)
predict.3.sum <- predict.3$endog[,1]
predict.3.sum <- as.data.frame(predict.3.sum)
names(predict.3.sum)[1] <-"Remainder"
predict.3.sum$season <- predict.3s$endog[,1]
predict.3.sum$trend <- predict.3t$endog[,1]
predict.3.sum
predict.3.sum <- rowSums(predict.3.sum, na.rm=TRUE, dims=1)
predict.3.sum <- as.data.frame(predict.3.sum)
### now we have to add and sum the forecasts. The forecast columns are in following order. Mean, lower, upper, CI. 
## We start with "lower"
rm(predict.3.sum.l)
predict.3$fcst$KB
predict.3.sum.l <-predict.3$fcst$KB[,2]
predict.3.sum.l <- as.data.frame(predict.3.sum.l)
names(predict.3.sum.l)[1] <-"Remainder"
predict.3.sum.l$season <-predict.3s$fcst$KB[,2]
predict.3.sum.l$trend <-predict.3t$fcst$KB[,2]
predict.3.sum.l <- rowSums(predict.3.sum.l, na.rm= TRUE, dims=1)
predict.3.sum.l <- as.data.frame(predict.3.sum.l)
## Upper
rm(predict.3.sum.u)
predict.3.sum.u <-predict.3$fcst$KB[,3]
predict.3.sum.u <- as.data.frame(predict.3.sum.u)
names(predict.3.sum.u)[1] <-"Remainder"
predict.3.sum.u$season <-predict.3s$fcst$KB[,3]
predict.3.sum.u$trend <-predict.3t$fcst$KB[,3]
predict.3.sum.u <- rowSums(predict.3.sum.u, na.rm=TRUE, dims=1)
predict.3.sum.u <- as.data.frame(predict.3.sum.u)
## Mean 
rm(predict.3.sum.m)
predict.3.sum.m <-predict.3$fcst$KB[,1]
predict.3.sum.m <- as.data.frame(predict.3.sum.m)
names(predict.3.sum.m)[1] <-"Remainder"
predict.3.sum.m$season <-predict.3s$fcst$KB[,1]
predict.3.sum.m$trend <-predict.3t$fcst$KB[,1]
predict.3.sum.m <- rowSums(predict.3.sum.m, na.rm=TRUE, dims=1)
predict.3.sum.m <- as.data.frame(predict.3.sum.m)
names(predict.3.sum)[1] <- "Merge"
predict.3.sum <- as.data.frame(predict.3.sum)
## Lower
predict.3.sum.l <- predict.3.sum %>% add_row(Merge=predict.3.sum.l[,1])
predict.3.sum.u <- predict.3.sum %>% add_row(Merge=predict.3.sum.u[,1])
predict.3.sum.m <- predict.3.sum %>% add_row(Merge=predict.3.sum.m[,1])
predict.3.sum.l.ts <- ts(predict.3.sum.l, frequency=12, start=c(2017, 10))
predict.3.sum.u.ts <- ts(predict.3.sum.u, frequency=12, start=c(2017, 10))
predict.3.sum.m.ts <- ts(predict.3.sum.m, frequency=12, start=c(2017, 10))
plot(predict.3.sum.u.ts, col="red")
lines(predict.3.sum.l.ts, col="red")
lines(predict.3.sum.m.ts)


#####

kb_BC.1 <- kb_dt.1[1:30,1:4]
kb_BC.2 <- kb_dt.2[1:30,1:4]
kb_BC.3 <- kb_dt.3[1:30,1:4]

# Split KB 1
kb_BC.1c <- subset(kb_BC.1, select = -c(4))
VARselect(kb_BC.1c[1:2], lag.max = 12, type="none") # Select the VAR() dependant on criterion, SC=BIC is the best criterion.
var1 <- VAR(kb_BC.1c[1:2], p = 3, type="none") # 1:2 KPI, p=3+, 0.523 
serial.test(var1, lags.pt = 6, type="PT.asymptotic") # Portmanteau test.
predict_1 <- predict(var1, n.ahead = 18)
summary(var1$varresult$KB)
roots(var1)
par(mfrow=c(2,1), oma=c(0,0,0,0))
acf(var1$varresult$KB$residuals, lag.max = 48, main = "Residuals of VAR(3) model of price per m2, group 1, before covid")
acf(var1$varresult$KB$residuals, lag.max = 48, type = "partial", main = "Residuals of VAR(3) model of price per m2, group 1, before covid")
par(mfrow=c(2,2), oma=c(0,0,0,0))
qqnorm(var1$varresult$KB$residuals, datax = FALSE, main = "Normal Q-Q plot", ylab = "Percent", xlab = "Residual")
qqline(var1$varresult$KB$residuals)
plot(var1$varresult$KB$fitted.values, main = "Residuals versus the fitted values", ylab = "Residual", xlab ="Fitted value")
abline(h=0)
hist(var1$varresult$KB$residuals, add.normal=TRUE, main = "Histogram of the residuals", xlab = "Residual")
plot(var1$varresult$KB$residuals, type="o", main = "Residuals versus the order of the data", ylab = "Residual", xlab = "Observation order")
abline(h=0)

vars::arch.test(var1, lags.multi=3, multivariate.only = TRUE)
normality.test(var1, multivariate.only = TRUE)

stability.var1 <- stability(var1, type="OLS-CUSUM")
plot(stability.var1$stability$KB, main = "OLS-based Cusum test price per m2, group 1, before covid")

causality(var1, cause = "KB")
causality(var1, cause = "KPIK") # Significant

# PREDICTION
kb_BC_1t <- subset(kb_t.1, select = -c(4))
var_1t <- VAR(kb_BC_1t[1:30,1:2], p = 3, type="none")
predict_1t <- predict(var_1t, n.ahead = 18)
fanchart(predict_1t)

kb_BC_1s <- subset(kb_s.1, select = -c(4))
var_1s <- VAR(kb_BC_1s[1:30,1:2], p = 3, type="none")
predict_1s <- predict(var_1s, n.ahead = 18)
fanchart(predict_1s)

### 
### First add and sum the endogen part (the first 48 values.)
rm(predict_1.sum)
predict_1.sum <- predict_1$endog[,1]
predict_1.sum <- as.data.frame(predict_1.sum)
names(predict_1.sum)[1] <-"Remainder"
predict_1.sum$season <- predict_1s$endog[,1]
predict_1.sum$trend <- predict_1t$endog[,1]
predict_1.sum
predict_1.sum <- rowSums(predict_1.sum, na.rm=TRUE, dims=1)
predict_1.sum <- as.data.frame(predict_1.sum)
### now we have to add and sum the forecasts. The forecast columns are in following order. Mean, lower, upper, CI. 
## We start with "lower"
rm(predict_1.sum.l)
predict_1$fcst$KB
predict_1.sum.l <-predict_1$fcst$KB[,2]
predict_1.sum.l <- as.data.frame(predict_1.sum.l)
names(predict_1.sum.l)[1] <-"Remainder"
predict_1.sum.l$season <-predict_1s$fcst$KB[,2]
predict_1.sum.l$trend <-predict_1t$fcst$KB[,2]
predict_1.sum.l <- rowSums(predict_1.sum.l, na.rm= TRUE, dims=1)
predict_1.sum.l <- as.data.frame(predict_1.sum.l)
## Upper
rm(predict_1.sum.u)
predict_1.sum.u <-predict_1$fcst$KB[,3]
predict_1.sum.u <- as.data.frame(predict_1.sum.u)
names(predict_1.sum.u)[1] <-"Remainder"
predict_1.sum.u$season <-predict_1s$fcst$KB[,3]
predict_1.sum.u$trend <-predict_1t$fcst$KB[,3]
predict_1.sum.u <- rowSums(predict_1.sum.u, na.rm=TRUE, dims=1)
predict_1.sum.u <- as.data.frame(predict_1.sum.u)
## Mean 
rm(predict_1.sum.m)
predict_1.sum.m <-predict_1$fcst$KB[,1]
predict_1.sum.m <- as.data.frame(predict_1.sum.m)
names(predict_1.sum.m)[1] <-"Remainder"
predict_1.sum.m$season <-predict_1s$fcst$KB[,1]
predict_1.sum.m$trend <-predict_1t$fcst$KB[,1]
predict_1.sum.m <- rowSums(predict_1.sum.m, na.rm=TRUE, dims=1)
predict_1.sum.m <- as.data.frame(predict_1.sum.m)
names(predict_1.sum)[1] <- "Merge"
predict_1.sum <- as.data.frame(predict_1.sum)
## Lower
predict_1.sum.l <- predict_1.sum %>% add_row(Merge=predict_1.sum.l[,1])
predict_1.sum.u <- predict_1.sum %>% add_row(Merge=predict_1.sum.u[,1])
predict_1.sum.m <- predict_1.sum %>% add_row(Merge=predict_1.sum.m[,1])
predict_1.sum.l.ts <- ts(predict_1.sum.l, frequency=12, start=c(2017, 10))
predict_1.sum.u.ts <- ts(predict_1.sum.u, frequency=12, start=c(2017, 10))
predict_1.sum.m.ts <- ts(predict_1.sum.m, frequency=12, start=c(2017, 10))
plot(predict_1.sum.u.ts, col="red")
lines(predict_1.sum.l.ts, col="red")
lines(predict_1.sum.m.ts)

## CHOW TEST, COMPARE THE MEAN VECTOR WITH THE TRUE VALUES. P-value < 0.05 indicates a structure break. 
sctest(predict_1.sum.m.ts ~ kb_1_ts[,1], type="Chow", point=30)
### There is a clear structure change at point = 30.

# Split KB 2
kb_BC.2c <- subset(kb_BC.2, select = -c(4))
VARselect(kb_BC.2c[1:2], lag.max = 12, type="none") # Select the VAR() dependant on criterion, SC=BIC is the best criterion.
var2 <- VAR(kb_BC.2c[1:2], p = 3, type="none") # 1:2 KPIK, p=3, 0.737
serial.test(var2, lags.pt = 6, type="PT.asymptotic") # Portmanteau test.
predict_2 <- predict(var2, n.ahead = 18)
summary(var2$varresult$KB)
roots(var2)
par(mfrow=c(2,1), oma=c(0,0,0,0))
acf(var2$varresult$KB$residuals, lag.max = 48, main = "Residuals of VAR(3) model of price per m2, group 2, before covid")
acf(var2$varresult$KB$residuals, lag.max = 48, type = "partial", main = "Residuals of VAR(3) model of price per m2, group 2, before covid")
par(mfrow=c(2,2), oma=c(0,0,0,0))
qqnorm(var2$varresult$KB$residuals, datax = FALSE, main = "Normal Q-Q plot", ylab = "Percent", xlab = "Residual")
qqline(var2$varresult$KB$residuals)
plot(var2$varresult$KB$fitted.values, main = "Residuals versus the fitted values", ylab = "Residual", xlab ="Fitted value")
abline(h=0)
hist(var2$varresult$KB$residuals, add.normal=TRUE, main = "Histogram of the residuals", xlab = "Residual")
plot(var2$varresult$KB$residuals, type="o", main = "Residuals versus the order of the data", ylab = "Residual", xlab = "Observation order")
abline(h=0)

vars::arch.test(var2, lags.multi=3, multivariate.only = TRUE)
normality.test(var2, multivariate.only = TRUE)

stability.var2 <- stability(var2, type="OLS-CUSUM")
plot(stability.var2$stability$KB, main = "OLS-based Cusum test price per m2, group 2, before covid")

causality(var2, cause = "KB") 
causality(var2, cause = "KPIK") # significant

#Var-models for trend and seasonality:
kb_BC_2t <- subset(kb_t.2, select = -c(4))
var_2t <- VAR(kb_BC_2t[1:30,1:2], p = 3, type="none")
predict_2t <- predict(var_2t, n.ahead = 18)
fanchart(predict_2t)

kb_BC_2s <- subset(kb_s.2, select = -c(4))
var_2s <- VAR(kb_BC_2s[1:30,1:2], p = 3, type="none")
predict_2s <- predict(var_2s, n.ahead = 18)
fanchart(predict_2s)

### 
### First add and sum the endogen part (the first 48 values.)
rm(predict_2.sum)
predict_2.sum <- predict_2$endog[,1]
predict_2.sum <- as.data.frame(predict_2.sum)
names(predict_2.sum)[1] <-"Remainder"
predict_2.sum$season <- predict_2s$endog[,1]
predict_2.sum$trend <- predict_2t$endog[,1]
predict_2.sum
predict_2.sum <- rowSums(predict_2.sum, na.rm=TRUE, dims=1)
predict_2.sum <- as.data.frame(predict_2.sum)
### now we have to add and sum the forecasts. The forecast columns are in following order. Mean, lower, upper, CI. 
## We start with "lower"
rm(predict_2.sum.l)
predict_2$fcst$KB
predict_2.sum.l <-predict_2$fcst$KB[,2]
predict_2.sum.l <- as.data.frame(predict_2.sum.l)
names(predict_2.sum.l)[1] <-"Remainder"
predict_2.sum.l$season <-predict_2s$fcst$KB[,2]
predict_2.sum.l$trend <-predict_2t$fcst$KB[,2]
predict_2.sum.l <- rowSums(predict_2.sum.l, na.rm= TRUE, dims=1)
predict_2.sum.l <- as.data.frame(predict_2.sum.l)
## Upper
rm(predict_2.sum.u)
predict_2.sum.u <-predict_2$fcst$KB[,3]
predict_2.sum.u <- as.data.frame(predict_2.sum.u)
names(predict_2.sum.u)[1] <-"Remainder"
predict_2.sum.u$season <-predict_2s$fcst$KB[,3]
predict_2.sum.u$trend <-predict_2t$fcst$KB[,3]
predict_2.sum.u <- rowSums(predict_2.sum.u, na.rm=TRUE, dims=1)
predict_2.sum.u <- as.data.frame(predict_2.sum.u)
## Mean 
rm(predict_2.sum.m)
predict_2.sum.m <-predict_2$fcst$KB[,1]
predict_2.sum.m <- as.data.frame(predict_2.sum.m)
names(predict_2.sum.m)[1] <-"Remainder"
predict_2.sum.m$season <-predict_2s$fcst$KB[,1]
predict_2.sum.m$trend <-predict_2t$fcst$KB[,1]
predict_2.sum.m <- rowSums(predict_2.sum.m, na.rm=TRUE, dims=1)
predict_2.sum.m <- as.data.frame(predict_2.sum.m)
names(predict_2.sum)[1] <- "Merge"
predict_2.sum <- as.data.frame(predict_2.sum)
## Lower
predict_2.sum.l <- predict_2.sum %>% add_row(Merge=predict_2.sum.l[,1])
predict_2.sum.u <- predict_2.sum %>% add_row(Merge=predict_2.sum.u[,1])
predict_2.sum.m <- predict_2.sum %>% add_row(Merge=predict_2.sum.m[,1])
predict_2.sum.l.ts <- ts(predict_2.sum.l, frequency=12, start=c(2017, 10))
predict_2.sum.u.ts <- ts(predict_2.sum.u, frequency=12, start=c(2017, 10))
predict_2.sum.m.ts <- ts(predict_2.sum.m, frequency=12, start=c(2017, 10))
plot(predict_2.sum.u.ts, col="red")
lines(predict_2.sum.l.ts, col="red")
lines(predict_2.sum.m.ts)

## CHOW TEST, COMPARE THE MEAN VECTOR WITH THE TRUE VALUES. P-value < 0.05 indicates a structure break. 
sctest(predict_2.sum.m.ts ~ kb_2_ts[,1], type="Chow", point=30)
### There is a clear structure change at point = 30.

# Split KB 3 Meh 
kb_BC.3c <- subset(kb_BC.3, select = -c(3))
VARselect(kb_BC.3c[1:2], lag.max = 12, type="none") # Select the VAR() dependant on criterion, SC=BIC is the best criterion.
var3 <- VAR(kb_BC.3c[1:2], p = 2, type="none") # 1:2, p = 1, KIH, 0.587 (fails). 1:2 KPI, p=2, 0.48 (succeeds)
serial.test(var3, lags.pt = 6, type="PT.asymptotic") # Portmanteau test.
predict_3 <- predict(var3, n.ahead = 18)
summary(var3$varresult$KB)
roots(var3)
par(mfrow=c(2,1), oma=c(0,0,0,0))
acf(var3$varresult$KB$residuals, lag.max = 30, main = "Residuals of VAR(2) model of price per m2, group 3, before covid")
acf(var3$varresult$KB$residuals, lag.max = 30, type = "partial", main = "Residuals of VAR(2) model of price per m2, group 3, before covid")
par(mfrow=c(2,2), oma=c(0,0,0,0))
qqnorm(var3$varresult$KB$residuals, datax = FALSE, main = "Normal Q-Q plot", ylab = "Percent", xlab = "Residual")
qqline(var3$varresult$KB$residuals)
plot(var3$varresult$KB$fitted.values, main = "Residuals versus the fitted values", ylab = "Residual", xlab ="Fitted value")
abline(h=0)
hist(var3$varresult$KB$residuals, main = "Histogram of the residuals", xlab = "Residual")
plot(var3$varresult$KB$residuals, type="o", main = "Residuals versus the order of the data", ylab = "Residual", xlab = "Observation order")
abline(h=0)

vars::arch.test(var3, lags.multi=2, multivariate.only = TRUE)
normality.test(var3, multivariate.only = TRUE)

stability.var3 <- stability(var3, type="OLS-CUSUM")
plot(stability.var3$stability$KB, main = "OLS-based Cusum test price per m2, group 3, before covid")

causality(var3, cause = "KB") 
causality(var3, cause = "KPIK") 

# VAR models for trend and seasonality:
kb_BC_3t <- subset(kb_t.3, select = -c(3))
var_3t <- VAR(kb_BC_3t[1:30,1:2], p = 2, type="none")
predict_3t <- predict(var_3t, n.ahead = 18)
fanchart(predict_3t)

kb_BC_3s <- subset(kb_s.3, select = -c(3))
var_3s <- VAR(kb_BC_3s[1:30,1:3], p = 2, type="none")
predict_3s <- predict(var_3s, n.ahead = 18)
fanchart(predict_3s)

### 
### First add and sum the endogen part (the first 48 values.)
rm(predict_3.sum)
predict_3.sum <- predict_3$endog[,1]
predict_3.sum <- as.data.frame(predict_3.sum)
names(predict_3.sum)[1] <-"Remainder"
predict_3.sum$season <- predict_3s$endog[,1]
predict_3.sum$trend <- predict_3t$endog[,1]
predict_3.sum
predict_3.sum <- rowSums(predict_3.sum, na.rm=TRUE, dims=1)
predict_3.sum <- as.data.frame(predict_3.sum)
### now we have to add and sum the forecasts. The forecast columns are in following order. Mean, lower, upper, CI. 
## We start with "lower"
rm(predict_3.sum.l)
predict_3$fcst$KB
predict_3.sum.l <-predict_3$fcst$KB[,2]
predict_3.sum.l <- as.data.frame(predict_3.sum.l)
names(predict_3.sum.l)[1] <-"Remainder"
predict_3.sum.l$season <-predict_3s$fcst$KB[,2]
predict_3.sum.l$trend <-predict_3t$fcst$KB[,2]
predict_3.sum.l <- rowSums(predict_3.sum.l, na.rm= TRUE, dims=1)
predict_3.sum.l <- as.data.frame(predict_3.sum.l)
## Upper
rm(predict_3.sum.u)
predict_3.sum.u <-predict_3$fcst$KB[,3]
predict_3.sum.u <- as.data.frame(predict_3.sum.u)
names(predict_3.sum.u)[1] <-"Remainder"
predict_3.sum.u$season <-predict_3s$fcst$KB[,3]
predict_3.sum.u$trend <-predict_3t$fcst$KB[,3]
predict_3.sum.u <- rowSums(predict_3.sum.u, na.rm=TRUE, dims=1)
predict_3.sum.u <- as.data.frame(predict_3.sum.u)
## Mean 
rm(predict_3.sum.m)
predict_3.sum.m <-predict_3$fcst$KB[,1]
predict_3.sum.m <- as.data.frame(predict_3.sum.m)
names(predict_3.sum.m)[1] <-"Remainder"
predict_3.sum.m$season <-predict_3s$fcst$KB[,1]
predict_3.sum.m$trend <-predict_3t$fcst$KB[,1]
predict_3.sum.m <- rowSums(predict_3.sum.m, na.rm=TRUE, dims=1)
predict_3.sum.m <- as.data.frame(predict_3.sum.m)
names(predict_3.sum)[1] <- "Merge"
predict_3.sum <- as.data.frame(predict_3.sum)
## Lower
predict_3.sum.l <- predict_3.sum %>% add_row(Merge=predict_3.sum.l[,1])
predict_3.sum.u <- predict_3.sum %>% add_row(Merge=predict_3.sum.u[,1])
predict_3.sum.m <- predict_3.sum %>% add_row(Merge=predict_3.sum.m[,1])
predict_3.sum.l.ts <- ts(predict_3.sum.l, frequency=12, start=c(2017, 10))
predict_3.sum.u.ts <- ts(predict_3.sum.u, frequency=12, start=c(2017, 10))
predict_3.sum.m.ts <- ts(predict_3.sum.m, frequency=12, start=c(2017, 10))
plot(predict_3.sum.u.ts, col="red")
lines(predict_3.sum.l.ts, col="red")
lines(predict_3.sum.m.ts)

## CHOW TEST, COMPARE THE MEAN VECTOR WITH THE TRUE VALUES. P-value < 0.05 indicates a structure break. 
sctest(predict_3.sum.m.ts ~ kb_3_ts[,1], type="Chow", point=30)
### There is a clear structure change at point = 30.

# Plot split data side-by-side
plot(predict_1.sum.m.ts, type="o", ylim=range(16000, 43000), main = "18-month prediction after covid outbreak")
lines(predict_2.sum.m.ts, type="o", col = "red")
lines(predict_3.sum.m.ts, type="o", col = "blue")
abline(v=c(2020.25), col = "black", lty = 5)

# plot future months side-by-side
plot(predict.1.sum.m.ts, type="o", ylim=range(16000, 47000), main = "12-month future prediction")
lines(predict.2.sum.m.ts, type="o", col = "red")
lines(predict.3.sum.m.ts,type="o", col = "blue")
abline(v=c(2021.833), col = "black", lty = 5)

# Table for KB whole VAR models.
tab_model(summary(var.1$varresult$KB), summary(var.2$varresult$KB), summary(var.3$varresult$KB), show.ci = FALSE,
          pred.labels = c("Price/m\u00B2.lag1","CPI.lag1","HCI.lag1","Price/m\u00B2.lag2","CPI.lag2","HCI.lag2","Price/m\u00B2.lag3",
                          "CPI.lag3","HCI.lag3","Price/m\u00B2.lag4","CPI.lag4","HCI.lag4"), dv.labels = c("VAR(4)","VAR(3)","VAR(1)"))

# Table for KB split:
tab_model(summary(var1$varresult$KB), summary(var2$varresult$KB), summary(var3$varresult$KB), show.ci = FALSE,
          pred.labels = c("Price/m\u00B2.lag1","CPI.lag1","Price/m\u00B2.lag2","CPI.lag2","Price/m\u00B2.lag3","CPI.lag3"), dv.labels = c("VAR(3)","VAR(3)","VAR(2)"))






KB_predict_1.sum.l.ts <- predict_1.sum.l.ts
KB_predict_1.sum.u.ts <- predict_1.sum.u.ts
KB_predict_1.sum.m.ts <- predict_1.sum.m.ts

KB_predict_2.sum.l.ts <- predict_2.sum.l.ts
KB_predict_2.sum.u.ts <- predict_2.sum.u.ts
KB_predict_2.sum.m.ts <- predict_2.sum.m.ts

KB_predict_3.sum.l.ts <- predict_3.sum.l.ts
KB_predict_3.sum.u.ts <- predict_3.sum.u.ts
KB_predict_3.sum.m.ts <- predict_3.sum.m.ts

KT_predict_1.sum.l.ts <- predict_1.sum.l.ts
KT_predict_1.sum.u.ts <- predict_1.sum.u.ts
KT_predict_1.sum.m.ts <- predict_1.sum.m.ts

KT_predict_2.sum.l.ts <- predict_2.sum.l.ts
KT_predict_2.sum.u.ts <- predict_2.sum.u.ts
KT_predict_2.sum.m.ts <- predict_2.sum.m.ts

KT_predict_3.sum.l.ts <- predict_3.sum.l.ts
KT_predict_3.sum.u.ts <- predict_3.sum.u.ts
KT_predict_3.sum.m.ts <- predict_3.sum.m.ts


par(mfrow=c(3,3), oma=c(0,0,0,0))
# split 
plot(kb_1_ts[,1], col="blue",  ylab="Price per m^2", xlab="Year", main="18 month forecasts, Group 1", ylim=range(21000, 32500))
lines(KB_predict_1.sum.l.ts, col="red", lty = 2)
lines(KB_predict_1.sum.u.ts, col="red", lty = 2)
lines(KB_predict_1.sum.m.ts)
#abline(v=c(2020.20), col = "black", lty = 3)

plot(kb_2_ts[,1], col="blue", ylab="Price per m^2", xlab="Year", main="18 month forecasts, Group 2", ylim=range(18000, 23000))
lines(KB_predict_2.sum.l.ts, col="red", lty = 2)
lines(KB_predict_2.sum.u.ts, col="red", lty = 2)
lines(KB_predict_2.sum.m.ts)
#abline(v=c(2020.2), col = "black", lty = 5)

plot(kb_3_ts[,1], col="blue", ylab="Price per m^2", xlab="Year", main="18 month forecasts, Group 3", ylim=range(37000, 44000))
lines(KB_predict_3.sum.l.ts, col="red", lty = 2)
lines(KB_predict_3.sum.u.ts, col="red", lty = 2)
lines(KB_predict_3.sum.m.ts)
#abline(v=c(2020.2), col = "black", lty = 5)

plot(kt_1_ts[,1], col="blue", ylab="P/T", xlab="Year", main="18 month forecasts, Group 1")
lines(KT_predict_1.sum.l.ts, col="red", lty = 2)
lines(KT_predict_1.sum.u.ts, col="red", lty = 2)
lines(KT_predict_1.sum.m.ts)
#abline(v=c(2020.2), col = "black", lty = 5)

plot(kt_2_ts[,1], col="blue",  ylab="P/T", xlab="Year", main="18 month forecasts, Group 2")
lines(KT_predict_2.sum.l.ts, col="red", lty = 2)
lines(KT_predict_2.sum.u.ts, col="red", lty = 2)
lines(KT_predict_2.sum.m.ts)
#abline(v=c(2020.2), col = "black", lty = 5)

plot(kt_3_ts[,1], col="blue",  ylab="P/T", xlab="Year", main="18 month forecasts, Group 3")
lines(KT_predict_3.sum.l.ts, col="red", lty = 2)
lines(KT_predict_3.sum.u.ts, col="red", lty = 2)
lines(KT_predict_3.sum.m.ts)
#abline(v=c(2020.2), col = "black", lty = 5)




# whole

KB_predict.1.sum.l.ts <- predict.1.sum.l.ts
KB_predict.1.sum.u.ts <- predict.1.sum.u.ts
KB_predict.1.sum.m.ts <- predict.1.sum.m.ts

KB_predict.2.sum.l.ts <- predict.2.sum.l.ts
KB_predict.2.sum.u.ts <- predict.2.sum.u.ts
KB_predict.2.sum.m.ts <- predict.2.sum.m.ts

KB_predict.3.sum.l.ts <- predict.3.sum.l.ts
KB_predict.3.sum.u.ts <- predict.3.sum.u.ts
KB_predict.3.sum.m.ts <- predict.3.sum.m.ts

KT_predict.1.sum.l.ts <- predict.1.sum.l.ts
KT_predict.1.sum.u.ts <- predict.1.sum.u.ts
KT_predict.1.sum.m.ts <- predict.1.sum.m.ts

KT_predict.2.sum.l.ts <- predict.2.sum.l.ts
KT_predict.2.sum.u.ts <- predict.2.sum.u.ts
KT_predict.2.sum.m.ts <- predict.2.sum.m.ts

KT_predict.3.sum.l.ts <- predict.3.sum.l.ts
KT_predict.3.sum.u.ts <- predict.3.sum.u.ts
KT_predict.3.sum.m.ts <- predict.3.sum.m.ts

par(mfrow=c(3,3), oma=c(0,0,0,0))
plot(kb_1_ts[,1],  ylab="Price per m^2", xlab="Year", main="12 month forecast, Group 1", ylim=range(21000, 33000), xlim=range(2017.80, 2022.80))
lines(KB_predict.1.sum.l.ts, col="red", lty = 2)
lines(KB_predict.1.sum.u.ts, col="red", lty = 2)
lines(KB_predict.1.sum.m.ts)

plot(kb_2_ts[,1], ylab="Price per m^2", xlab="Year",main="12 month forecast, Group 2", ylim=range(18000, 33000), xlim=range(2017.80, 2022.80))
lines(KB_predict.2.sum.l.ts, col="red", lty = 2)
lines(KB_predict.2.sum.u.ts, col="red", lty = 2)
lines(KB_predict.2.sum.m.ts)

plot(kb_3_ts[,1], ylab="Price per m^2", xlab="Year", main="12 month forecast, Group 3", ylim=range(35000, 49000), xlim=range(2017.80, 2022.80))
lines(KB_predict.3.sum.l.ts, col="red", lty = 2)
lines(KB_predict.3.sum.u.ts, col="red", lty = 2)
lines(KB_predict.3.sum.m.ts)

plot(kt_1_ts[,1], ylab="P/T", xlab="Year", main="12 month forecast, Group 1", ylim=range(1.7, 2.7), xlim=range(2017.80, 2022.80))
lines(KT_predict.1.sum.l.ts, col="red", lty = 2)
lines(KT_predict.1.sum.u.ts, col="red", lty = 2)
lines(KT_predict.1.sum.m.ts)

plot(kt_2_ts[,1],  ylab="P/T", xlab="Year", main="12 month forecast, Group 2", ylim=range(1.5, 2.7), xlim=range(2017.80, 2022.80))
lines(KT_predict.2.sum.l.ts, col="red", lty = 2)
lines(KT_predict.2.sum.u.ts, col="red", lty = 2)
lines(KT_predict.2.sum.m.ts)

plot(kt_3_ts[,1],  ylab="P/T", xlab="Year", main="12 month forecast, Group 3", ylim=range(1.3, 2.7), xlim=range(2017.80, 2022.80))
lines(KT_predict.3.sum.l.ts, col="red", lty = 2)
lines(KT_predict.3.sum.u.ts, col="red", lty = 2)
lines(KT_predict.3.sum.m.ts)







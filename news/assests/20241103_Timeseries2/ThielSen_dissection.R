

library(mblm)
library(EnvStats)

library(plyr)


n.vals <- n.yrs*12 

dat <- simulate_timeseries_vol(
  n = n.vals,           # About 20 years of daily data
  trend_slope = 0.05,   # Upward trend
  seasonal_amp = 2,     # Base seasonal amplitude
  seasonal_period = 12, # Monthly seasonality
  init_vol = 0.5,      # Initial volatility
  vol_persistence = 0.65,
  rw_sd = 0.3
)
## add some years and months
dat$timeseries  <-  cbind(dat$timeseries,
                          expand.grid(Mon = 1:12, Yr = 1990:(1990+(n.yrs-1)))
)
dat$timeseries$date <-  with(dat$timeseries,as.Date(paste(Yr,Mon,"01",sep="-")))


dat_yr <- ddply(dat$timeseries,c("Yr"),summarise,
                mean.val = mean(value),
                sd.val = sd(value)
)

mblm(mean.val~Yr,dat_yr,repeated=F)

#Intercept = -875.3943
#slope = 0.4406

kendallTrendTest(mean.val~Yr,dat_yr,correct=F)

#Intercept = -874.5206143
#slope = 0.4405568


## Fron EnvStats

y=dat_yr$mean.val
x=dat_yr$Yr

n=length(y)
index <- 2:n

S <- sum(sapply(index, function(i, x, y) {
  sum(sign((x[i] - x[1:(i - 1)]) * (y[i] - y[1:(i -
                                                  1)])))
}, x, y))
tau <- (2 * S)/(n * (n - 1))
slopes <- unlist(lapply(index, function(i, x, y) (y[i] -
                                                    y[1:(i - 1)])/(x[i] - x[1:(i - 1)]), x, y))
slopes <- sort(slopes[is.finite(slopes)])
slope <- median(slopes)
intercept <- median(y) - slope * median(x)
estimate <- c(tau, slope, intercept)
names(estimate) <- c("tau", "slope", "intercept")
method <- "Kendall's Test for Trend"


## From mblm

xx = sort(x)
yy = y[order(x)]
n = length(xx)

slopes = c()
intercepts = c()
smedians = c()
imedians = c()

for (i in 1:(n-1)) {
  for (j in i:n) {
    if (xx[j] != xx[i]) { slopes = c(slopes,(yy[j]-yy[i])/(xx[j]-xx[i])); }
  }
}

slope = median(slopes);
intercepts = yy - slope*xx;
intercept = median(intercepts);

median(yy) - slope * median(xx)

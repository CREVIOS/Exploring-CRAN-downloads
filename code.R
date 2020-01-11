library(jsonlite)
library(ggplot2)
library(lubridate)
library(dplyr)
# 1. Using the R-Hub cranlogs API to obtain data for total R package downloads for 2018 and 2019.

r_downloads_2018 <- jsonlite::fromJSON("https://cranlogs.r-pkg.org/downloads/total/2018-01-01:2018-12-31")

r_downloads_2019 <- jsonlite::fromJSON("https://cranlogs.r-pkg.org/downloads/total/2019-01-01:2019-12-31")

r_downloads_2018_19 <- rbind(r_downloads_2018,r_downloads_2019)

years <- c("2018","2019")
r_downloads_2018_19[["years"]] <- years

# 2. Using the R-Hub cranlogs API to obtain data for total Base R downloads for 2018 and 2019.

baseR_downloads_2018 <- jsonlite::fromJSON("https://cranlogs.r-pkg.org/downloads/total/2018-01-01:2018-12-31/R")

baseR_downloads_2019 <- jsonlite::fromJSON("https://cranlogs.r-pkg.org/downloads/total/2019-01-01:2019-12-31/R")

baseR_downloads_2018_19 <- rbind(baseR_downloads_2018,baseR_downloads_2019)

years <- c("2018","2019")
baseR_downloads_2018_19[["years"]] <- years

# 3. Visualizing R package downloads for 2018 and 2019.

r_2018_19_viz <- ggplot(r_downloads_2018_19, aes(years, downloads)) + geom_bar(stat = "identity")

# 4. Visualizing total base R downloads for 2018 and 2019.

baseR_2018_19_viz <- ggplot(baseR_downloads_2018_19, aes(years, downloads)) + geom_bar(stat = "identity")

# 5. Storing the results of 1 and 2 above in a single CSV file - one record for each year.

R_package_downloads_2018_19 <- rbind(r_downloads_2018_19, baseR_downloads_2018_19)

write.csv(R_package_downloads_2018_19,"D:\\exploring_CRAN_downloads\\r_package_downloads.csv", row.names = TRUE)

# 6. Compute (in percentage) the increase of base R downloads and R package downloads from 2018 to 2019.

## R packages 
r_increase <- (r_downloads_2019$downloads - r_downloads_2018$downloads)
r_increase_percent <- ((r_increase/r_downloads_2018$downloads) * 100)

## Base R packages
baseR_increase <- (baseR_downloads_2019$downloads - baseR_downloads_2018$downloads)
baseR_increase_percent <- ((baseR_increase/baseR_downloads_2018$downloads) * 100)

# 7. month-by-month comparison of R package downloads for 2018 and 2019 in a CSV table.

r_package_downloads <- jsonlite::fromJSON("http://cranlogs.r-pkg.org/downloads/daily/2018-01-01:2019-12-31")

downloadss <- r_package_downloads$downloads[[1]]

monthly <- downloadss %>% group_by(months=floor_date(as.Date(downloadss$day), "month")) %>%
  summarize(count_of_downloads = sum(downloads))

write.csv(monthly,"D:\\exploring_CRAN_downloads\\monthly_r_package_downloads.csv", row.names = TRUE)

## Visualisation

month_by_month_comparison <- ggplot(monthly, aes(months, count_of_downloads)) + geom_bar(stat = "identity")
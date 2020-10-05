library(rvest)
library(tidyverse)
library(lubridate)
library(stringr)

uit <- "http://timeplan.uit.no/emne_timeplan.php?sem=20h&module%5B%5D=BED-2056-1&View=list"

scrape <- function(url, class) {
  scraped <- read_html(url) %>%
    html_nodes(class) %>%
    html_table()
  return(scraped)
}

uit_scraped <- scrape(uit, "table")


# I got stuck in trying to transform the date. I wanted to pipe the uit_scraped variable, select just the uit_scraped element that contained the string "WeekdayDD.MM.YYY", apply a regex to it to remove any non-numeric chars and then use .asDate to format it as a date.

# One attempt to reach the goal, but I realised it is not efficient as we can do this with pipes from dplyr
# str_remove(uit_scraped[[1]][[1]], "\\D+")
#
# for (i in uit_scraped) {
#   x <- str_remove(i[[1]][[2]], "\\D+")
#   as.Date(x, format = "%d.%m. %Y")
# }


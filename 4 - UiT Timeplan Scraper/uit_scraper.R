library(rvest)
library(tidyverse)

uit <- "http://timeplan.uit.no/emne_timeplan.php?sem=20h&module%5B%5D=BED-2056-1&View=list"

scrape <- function(url, class) {
  scraped <- read_html(url) %>%
    html_nodes(class) %>%
    html_table()
  return(scraped)
}

uit_scraped <- scrape(uit, "table")

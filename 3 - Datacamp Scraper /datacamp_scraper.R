library(rvest)
library(tidyverse)

r <- "https://www.datacamp.com/courses/tech:r"
python <- "https://www.datacamp.com/courses/tech:python"

scrape <- function(url) {
  scraped <- read_html(url) %>%
    html_nodes(".course-block__title") %>%
    html_text()
  return(scraped)
}

r_scraped <- scrape(r)
python_scraped <- scrape(python)

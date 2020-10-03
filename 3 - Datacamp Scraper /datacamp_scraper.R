library(rvest)
library(tidyverse)

r <- "https://www.datacamp.com/courses/tech:r"
python <- "https://www.datacamp.com/courses/tech:python"

scrape <- function(url, class) {
  scraped <- read_html(url) %>%
    html_nodes(class) %>%
    html_text()
  return(scraped)
}

r_scraped <- scrape(r, ".course-block__title")
python_scraped <- scrape(python, ".course-block__title")

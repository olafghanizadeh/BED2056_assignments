library(rvest)
library(tidyverse)

r <- "https://www.datacamp.com/courses/tech:r"
python <- "https://www.datacamp.com/courses/tech:python"

# Create a function to do the scraping and data wrangling
scrape <- function(url, class, lang) {
  # 1st function argument, which url to scrape
  scraped <- read_html(url) %>%
    # 2nd function argument, the html selector we want to scrape
    html_nodes(class) %>%
    # Mapping to a data frame
    map_df(
      ~{
        tech <- .x %>% html_text()
        language <- lang
        data_frame(tech, language)
      }
    )
  return(scraped)
}

# call the functions and store in vars
r_scraped <- scrape(r, ".course-block__title", 'R')
python_scraped <- scrape(python, ".course-block__title", 'Python')

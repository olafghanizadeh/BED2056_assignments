rm(list=ls())

library(data.table)
library(tidyverse)

# Read the csv data
county_csv <- fread("http://data.ssb.no/api/v0/dataset/95274.csv?lang=no")
head(county_csv)

whole_country_csv <- fread("http://data.ssb.no/api/v0/dataset/95293.csv?lang=no")
head(whole_country_csv)
# ugly
rm(county_csv, whole_country_csv)

# Or reading json, the whole country
library(rjstat)
url <- "http://data.ssb.no/api/v0/dataset/95276.json?lang=no"
results <- fromJSONstat(url)
table <- results[[1]]
table

###############################################################
rm(list = ls())

#install.packages("PxWebApiData")
library(PxWebApiData)

?ApiData

county <- ApiData("http://data.ssb.no/api/v0/dataset/95274.json?lang=no",
                  getDataByGET = TRUE)

whole_country <- ApiData("http://data.ssb.no/api/v0/dataset/95276.json?lang=no",
                         getDataByGET = TRUE)

# two similar lists, different labels and coding
head(county[[1]])
head(county[[2]])

head(whole_country[[1]])

# Use first list, rowbind both data
dframe <- bind_rows(county[[1]], whole_country[[1]])


# new names, could have used dplyr::rename()
names(dframe)
names(dframe) <- c("region", "date", "variable", "value")
str(dframe)

# Split date
dframe <- dframe %>% separate(date,
                              into = c("year", "month"),
                              sep = "M")
head(dframe)

# Make a new proper date variable
library(lubridate)
dframe <- dframe %>%  mutate(date = ymd(paste(year, month, 1)))
str(dframe)

# And how many levels has the variable?
dframe %>% select(variable) %>% unique()


# dplyr::recode()
dframe <- dframe %>% mutate(variable = dplyr::recode(variable,
                                                      "Utleigde rom"="rentedrooms",
                                                      "Pris per rom (kr)"="roomprice",
                                                      "Kapasitetsutnytting av rom (prosent)"="roomcap",
                                                      "Kapasitetsutnytting av senger (prosent)"="bedcap",
                                                      "Losjiomsetning (1 000 kr)"="revenue",
                                                      "Losjiomsetning per tilgjengeleg rom (kr)"="revperroom",
                                                      "Losjiomsetning, hittil i Ã¥r (1 000 kr)"="revsofar",
                                                      "Losjiomsetning per tilgjengeleg rom, hittil i Ã¥r (kr)"="revroomsofar",
                                                      "Pris per rom hittil i Ã¥r (kr)"="roompricesofar",
                                                      "Kapasitetsutnytting av rom hittil i Ã¥r (prosent)"="roomcapsofar",
                                                      "Kapasitetsutnytting av senger, hittil i Ã¥r (prosent)"="bedcapsofar"))

dframe %>% select(variable2) %>% unique()
with(dframe, table(variable, variable))



# recode region
dframe <- dframe %>% mutate(region = dplyr::recode(region,
                                                   "Heile landet" = "Whole country",
                                                   "Trøndelag - Trööndelage" = "Trøndelag",
                                                   "Vestfold og Telemark" = "Vestfold and Telemark",
                                                   "Troms og Finnmark - Romsa ja Finnmárku" = "Svalbard, Troms and Finnmark",
                                                   "Møre og Romsdal" = "Møre and Romsdal"
                                                   ))

mosaic::tally(~region, data = dframe)

# we now have the data in long format ready for data wrangling
library(ggplot2)
roomcap <- filter(dframe, variable == "roomcap")

ggplot(roomcap, aes(month,value, group = region, colour = region)) +
  geom_line() +
  geom_point() +
  ylab("Room capacity") +
  xlab("Month")

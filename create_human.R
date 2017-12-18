# Juho Pirhonen 2017-11-18 juho.pirhonen@helsinki.fi
# This script performs data wrangling for my final assignment of Uni.Helsinki IODS-course
# https://github.com/Juhous/IODS-final

# Load required packages
library(ggplot2)
library(magrittr)
library(tidyr)
library(dplyr)
library(stringr)

# Opening and reformatting data
# Load dataframe
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", 
               stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", 
                stringsAsFactors = F, na.strings = "..")

# Shorten variable names
names(hd) <- c("HDIr", "country", "HDI", "lifeExp", "expEdu", "meanEdu", "GNIC", "GNICr_HDIr")
names(gii) <- c("GIIr", "country", "GII", "matMort", "adolBirthRate", "reprParl", 
                "edu2F", "edu2M", "labF", "labM")

# Check structure and summaries. Note that country is treatead as char.
str(hd)  #GNIC as chr!
hd %<>% mutate(GNIC = as.numeric(str_replace(GNIC, ",", "")))
str(hd) # All ok
str(gii) # All ok. 

summary(hd) # Note the amount of NA-values
summary(gii) # Note the amount of NA-values

# Add variables describing female to male ratios of education and labor proxy variables.
gii %<>% mutate(eduRatio = edu2F/edu2M, labRatio = labF/labM)
glimpse(gii)

# Join develpoment and gender equality dataframes, check structure. 
human <- inner_join(hd, gii, by = "country")
glimpse(human)

# Drop non-complete cases
human %<>% filter(complete.cases(.)) 
glimpse(human)

# Check that only observations for countries (not areas) are included
human$country

# Reorder to have country as 1st column. For clarity.
human %<>% select(country, HDIr, HDI:labRatio)
glimpse(human)

write.csv(human, file = "data/human.csv", row.names = F)

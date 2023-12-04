# Giovanni Marchi
# Mon Nov 27 2023
# Script with R code for Assignment4 data wrangling.

# read in the “Human development” and “Gender inequality” data sets
library(readr)
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")



# explore the datasets
str(hd)
str(gii)

dim(hd)
dim(gii)

summary(hd)
summary(gii)




# rename the variables
colnames(hd) <- c("HDI Rank", "Country", "HDI", "Life.Exp", "Edu.Exp", "Edu.Mean",
                  "GNI", "GNI-HDI")
colnames(gii) <- c("GII Rank", "Country", "GII", "Mat.Mor", "Ado.Birth", "Parli.F", "Edu2.F",
                   "Edu2.M", "Labo.F", "Labo.M")




# Mutate the “Gender inequality” data and create two new variables
gii$Edu2.FM <- gii$Edu2.F / gii$Edu2.M
gii$Labo.FM <- gii$Labo.F / gii$Labo.M


# join the datasets
human <- merge(hd, gii, by = "Country")
write_csv(human, "data/human.csv")




# Giovanni Marchi
# Mon Dec 3 2023
# Script with R code for Assignment5 data wrangling.

# explore the structure and the dimensions of the 'human' data
str(human)
dim(human)

# the dataset has 195 observations (countries) and 19 variables. The variables are
# indicators of quality of life:
colnames(human)




# store indicator for non-county lines
human$non_country <- ""
human$non_country <- ifelse(is.na(human$`HDI Rank`), TRUE, FALSE)
# keep only selected variables
keep <- c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor",
          "Ado.Birth", "Parli.F", "non_country")
human <- human[, keep]




# remove all rows with missing values
human <- human[complete.cases(human),]



# remove the observations which relate to regions instead of countries.
human <- human[human$non_country == FALSE,]
human$non_country <- NULL



# save again the dataset
write_csv(human, "data/human.csv")

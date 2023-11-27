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

# Giovanni Marchi
# Dec 7 2023
# Script with R code for Assignment4 data wrangling.



library(dplyr)
library(tidyr)



# load the data sets (BPRS and RATS) 
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt",
                   sep = " ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt",
                   sep = "\t", header = T)



# take a look at the data frames
dim(BPRS)
colnames(BPRS)
dim(RATS)
colnames(RATS)

# both datasets are in the "wide" data form: we have respectively 40 and 16 subjects
# (individuals or rats) that are split into two treatment/group categories. A
# biological measurement is taken for each individual/rat every week.



# convert categorical variables to factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)



# convert to longitudinal form
BPRS_L <-  pivot_longer(BPRS, cols= -c(treatment,subject), names_to = "weeks",
                       values_to = "bprs") %>% arrange(weeks)
BPRS_L <-  BPRS_L %>% mutate(week = as.integer(substr(weeks,5,5)))

RATS_L <- pivot_longer(RATS, cols = -c(ID, Group), names_to = "WD",
                     values_to = "Weight") %>%
  mutate(Time = as.integer(substr(WD, 3,4))) %>%
  arrange(Time)



# look at the longitudinal data
dim(BPRS_L)
colnames(BPRS_L)
glimpse(BPRS_L)
head(BPRS_L)

dim(RATS_L)
colnames(RATS_L)
glimpse(RATS_L)
head(RATS_L)

# Now, both datasets are in the longitudinal form. In the wide form, we had one 
# line per each individual/rat where variables were the treatment/group category
# and the time-points when the biological measurements were taken. However, in the
# longitudinal form, we have as many lines as many individuals/rats * time points
# (40 * 9 and 16 * 11): each line now is individual/rat #1 - time point #1 - biological
# measurement for time point #1.
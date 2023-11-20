# Giovanni Marchi
# Mon Nov 13 2023
# Script with R code for Assignment2 data wrangling.
library(dplyr)



# read learning2014 dataset
learn <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt",
                    header = T, sep = '\t')

# explore structure and dimension of dataset
str(learn)
dim(learn)
# The dataset is composed of 183 lines and 60 columns. All variables (columns) are
# numeric but the last one, gender, that is categorical, M or F.



# create an analysis dataset with the variables gender, age, attitude, deep, stra,
# surf and points
# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
# select the columns related to deep learning 
deep_columns <- select(learn, one_of(deep_questions))
# and create column 'deep' by averaging
learn$deep <- rowMeans(deep_columns)

# select the columns related to surface learning     
surface_columns <- select(learn, one_of(surface_questions))
# and create column 'surf' by averaging
learn$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning 
strategic_columns <- select(learn, one_of(strategic_questions))
# and create column 'stra' by averaging

learn$stra <- rowMeans(strategic_columns)
analysis <- select(learn, one_of(c("gender", "Age", "Attitude", "deep", "stra",
                                   "surf", "Points")))
# select rows where points is greater than zero
analysis <- analysis[analysis$Points > 0,]
# scale column "Attitude"
analysis$Attitude <- analysis$Attitude / 10



# set the working directory of your R session to the IODS Project folder
getwd("/home/giovama/Work/Courses/2023/IODS/IODS-project")

# save the analysis dataset to the ‘data’ folder
write.csv(analysis, "analysis.csv")
# demonstrate that you can also read the data again by using read_csv()
testing <- read.csv("analysis.csv", header = T, row.names = 1)

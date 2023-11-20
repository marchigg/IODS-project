# Giovanni Marchi
# Sun Nov 19 2023
# Script with R code for Assignment3 data wrangling.
# Data source is http://www.archive.ics.uci.edu/dataset/320/student+performance



# read student-mat.csv and student-por.csv and explore the structure and
# dimensions of the data. 
mat <- read.table("data/student-mat.csv", sep = ";", header = T)
dim(mat)
str(mat)
por <- read.table("data/student-por.csv", sep = ";", header = T)
dim(por)
str(por)


# join the two data sets using all other variables than "failures", "paid", "absences",
# "G1", "G2", "G3" as identifiers and explore the structure and dimensions of the
# joined data.
free_cols <- c("failures", "paid", "absences", "G1", "G2", "G3")
# the rest of the columns are common identifiers used for joining the data sets
join_cols <- setdiff(colnames(por), free_cols)
# join the two data sets by the selected identifiers
math_por <- inner_join(mat, por, by = join_cols)
dim(math_por)



# get rid of the duplicate records in the joined data set
math_por_unique <- math_por[,grep(paste(join_cols,collapse = "|"), colnames(math_por))]
math_por_dup <- math_por[,grep(paste(free_cols,collapse = "|"), colnames(math_por))]
for (i in free_cols) {
  fix <- math_por_dup[,grep(i, colnames(math_por_dup))]
  if (unique(unlist(lapply(fix, class))) == "integer") {
    math_por_unique[, ncol(math_por_unique) +1] <- round(rowMeans(fix))
    colnames(math_por_unique)[ncol(math_por_unique)] <- sub(".x", "", colnames(fix)[1])
  } else {
    math_por_unique[, ncol(math_por_unique) +1] <- fix[, 1]
    colnames(math_por_unique)[ncol(math_por_unique)] <- sub(".x", "", colnames(fix)[1])
  }
}



# Take the average of the answers related to weekday and weekend alcohol consumption
# to create a new column 'alc_use' to the joined data. Then use 'alc_use' to create
# a new logical column 'high_use' which is TRUE for students for which 'alc_use'
# is greater than 2 (and FALSE otherwise)
math_por_unique$alc_use <- (math_por_unique$Dalc + math_por_unique$Walc) /2
math_por_unique$high_use <- ifelse(math_por_unique$alc_use > 2, TRUE, FALSE)




# glimpse at the joined and modified data to make sure everything is in order.
# Save the joined and modified data set to the ‘data’ folder.
glimpse(math_por_unique)
write.table(math_por_unique, "data/alc.csv", sep = '\t', row.names = F)

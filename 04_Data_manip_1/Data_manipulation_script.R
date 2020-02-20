# Set your working directory to where the folder is saved on your computer
setwd("/home/han/PycharmProjects/CC_course_stream1/04_Data_manip_1")

# Load the elongation data
elongation <- read.csv("EmpetrumElongation.csv", header = TRUE)   

#import library
library(tidyr)
library(dplyr)

# Check import and preview data
head(elongation)   # first few observations
str(elongation)    # types of variables

# Let's get some information out of this object!
elongation$Indiv   # prints out all the ID codes in the dataset
length(unique(elongation$Indiv))   # returns the number of distinct shrubs in the data

# Here's how we get the value in the second row and fifth column
elongation[2,5]

# Here's how we get all the info for row number 6
elongation[6, ]

# And of course you can mix it all together! 
elongation[6, ]$Indiv   # returns the value in the column Indiv for the sixth observation
# (much easier calling columns by their names than figuring out where they are!) 

# Let's access the values for Individual number 603
elongation[elongation$Indiv == 603, ]



# Subsetting with one condition

elongation[elongation$Zone < 4, ]    # returns only the data for zones 2-3
elongation[elongation$Zone <= 4, ]   # returns only the data for zones 2-3-4


# This is completely equivalent to the last statement
elongation[!elongation$Zone >= 5, ]   # the ! means exclude


# Subsetting with two conditions
elongation[elongation$Zone == 2 | elongation$Zone == 7, ]    # returns only data for zones 2 and 7
elongation[elongation$Zone == 2 & elongation$Indiv %in% c(300:400), ]    # returns data for shrubs in zone 2 whose ID numbers are between 300 and 400


## CHANGING VARIABLE NAMES AND VALUES IN A DATA FRAME

# Let's create a working copy of our object
elong2 <- elongation

# Now suppose you want to change the name of a column: you can use the names() function
# Used on its own, it returns a vector of the names of the columns. Used on the left side of the assign arrow, it overwrites all or some of the names to value(s) of your choice. 

names(elong2)                 # returns the names of the columns

names(elong2)[1] <- "zone"    # Changing Zone to zone: we call the 1st element of the names vector using brackets, and assign it a new value
names(elong2)[2] <- "ID"      # Changing Indiv to ID: we call the 2nd element and assign it the desired value

# Now suppose there's a mistake in the data, and the value 5.1 for individual 373 in year 2008 should really be 5.7

## - option 1: you can use row and column number
elong2[1,4] <- 5.7

## - option 2: you can use logical conditions for more control
elong2[elong2$ID == 373, ]$X2008 <- 5.7   # completely equivalent to option 1


## CREATING A FACTOR

# Let's check the classes 
str(elong2)

# The zone column shows as integer data (whole numbers), but it's really a grouping factor (the zones could have been called A, B, C, etc.) Let's turn it into a factor:

elong2$zone <- as.factor(elong2$zone)        # converting and overwriting original class
str(elong2)                                  # now zone is a factor with 6 levels

## CHANGING A FACTOR'S LEVELS

levels(elong2$zone)  # shows the different factor levels

levels(elong2$zone) <- c("A", "B", "C", "D", "E", "F")   # you can overwrite the original levels with new names

# You must make sure that you have a vector the same length as the number of factors, and pay attention to the order in which they appear!


elongation_long <- gather(elongation, Year, Length,                           # in this order: data frame, key, value
                          c(X2007, X2008, X2009, X2010, X2011, X2012))        # we need to specify which columns to gather

# Here we want the lengths (value) to be gathered by year (key) 

# Let's reverse! spread() is the inverse function, allowing you to go from long to wide format
elong_spread <- spread(elongation_long, Year, Length) 

# same as line 86
elongation_long2 <- gather(elongation, Year, Length, c(3:8))

boxplot(Length ~ Year, data = elongation_long, 
        xlab = "Year", ylab = "Elongation (cm)", 
        main = "Annual growth of Empetrum hermaphroditum")

  ## Dplyr----
# rename variables----
# change the names of the columns and overwriting the dataframe
elong_long <- rename(elong_long, zone=Zone, indiv=Indiv, year=Year, length=Length)

# filter----
# keep those from zones 2 and 3, and from years 2009 to 2011
# filter() function works great for subsetting rows with logical operations.
elong_subset <- filter(elong_long, zone %in% c(2,3),
                       year %in% c("X2009", "X2010", "X2011"))

# select----
# remove the zone column
elong_no_zone <- select(elong_long, -zone)

# dplyr allows you to rename and reorder the column
elong_no_zone <- select(elong_long, Year=year, Shrub_ID=indiv, Growth=length)

# mutate----
elong_total <- mutate(elong, total_growth = X2007 + X2008 + X2009 + X2010 + X2011 + X2012)

# group_by----
elong_grouped <- group_by(elong_long, indiv)  # grouping our dataset by individual

# summarise----
summary1 <- summarise(elong_long, total_growth=sum(length))
summary2 <- summarise(elong_grouped, total_growth=sum(length))

summary3 <- summarise(elong_grouped, total_growth=sum(length),
                      mean_growth=mean(length),
                      sd_growth=sd(length))

# join----
treatments <- read.csv("EmpetrumTreatments.csv", header=TRUE, sep=";")
# join by ID, need to tell it which column names match with which
experiment <- left_join(elong_long, treatments, by=c("indiv"="Indiv", "zone"="Zone"))


boxplot(length~Treatment, data=experiment)

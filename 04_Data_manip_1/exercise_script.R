# Practice for tidyr and dplyr
# import data
dragon = read.csv("dragons.csv", header = TRUE)

# look at data
dim(dragon)
str(dragon)

# import libraries
library(tidyr)
library(dplyr)

# tidyr----
# renaming paprika to turmeric
dragon <- rename(dragon, turmeric=paprika)
  
# gathering the dataframe
dragon_long <- gather(dragon, spices, plume_length, c(3:6))

# change the values for the hungarian_horntail
dragon_long[dragon_long$species=="hungarian_horntail",]$plume_length <- dragon_long[dragon_long$species=="hungarian_horntail",]$plume_length - 30

# change fom centimeter to meters
dragon_long <- mutate(dragon_long, plume_meter=plume_length/100)

# subsetting----
hungarian_horntail <- filter(dragon_long, species=="hungarian_horntail")
swedish_shortsnout <- filter(dragon_long, species=="swedish_shortsnout")
welsh_green <- filter(dragon_long, species=="welsh_green")

# creating the plot
par(mfrow=c(2,2))
boxplot(plume_meter~spices, data = hungarian_horntail, main="Hungarian_horntail")
boxplot(plume_meter~spices, data = swedish_shortsnout, main="Swedish_shortsnout")
boxplot(plume_meter~spices, data = welsh_green, main="Welsh_green")

# turmeric caused the least plume length in all 3 species
# tabasco caused the most plume in Hungarian horntail
# jalapeno caused the most plume in Swedish shortsnout
# jalapeno and wasabi caused about equal plume length in Welsh green.

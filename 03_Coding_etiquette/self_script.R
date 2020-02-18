# Title     : etiquette_self_script
# Objective :
# Created by: han
# Created on: 17/02/2020

#library ----
library(tidyr)
library(dplyr)
library(ggplot2)
library(readr)

# Defining functions ----
# A custom ggplot2 function
theme.LPI <- function(){
  theme_bw()+
    theme(axis.text.x=element_text(size=12, angle=45, vjust=1, hjust=1),
          axis.text.y=element_text(size=12),
          axis.title.x=element_text(size=14, face="plain"),
          axis.title.y=element_text(size=14, face="plain"),
          panel.grid.major.x=element_blank(),
          panel.grid.minor.x=element_blank(),
          panel.grid.minor.y=element_blank(),
          panel.grid.major.y=element_blank(),
          plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), units = , "cm"),
          plot.title = element_text(size=20, vjust=1, hjust=0.5),
          legend.text = element_text(size=12, face="italic"),
          legend.title = element_blank(),
          legend.position=c(0.9, 0.9))
}

# Import data ----
LPI <- read.csv("/home/han/PycharmProjects/CC_course_stream1/03_Coding_etiquette/LPIdata_CC.csv")

# Formatting data ----
LPI2 <- gather(LPI, "year", "abundance", 9:53) # Transforming the data from wide to long format, some blank cells may disappear
# gather functions need tidyr package
LPI2$year <- parse_number(LPI2$year) # gets rid of the X in front of the years
names(LPI2) # look at what the variables are called
names(LPI2) <- tolower(names(LPI2)) # turn all the variables into lower case

# When manipulating data it's always good check if the variables have stayed how we want them
# Use the str() function
str(LPI2)

# abundance is a character at the moment
# Need to fix the abundance as it should be numeric
LPI2$abundance <- as.numeric(LPI2$abundance)

# Calc summary stats for each biome in the LPI database ----
levels(LPI2$biome)

LPI_biome_summ <- LPI2 %>% 
  group_by(biome) %>% 
  summarise(populations = n())

#visualise the number of populations in each biome with ggplot2 package----
(barplot <- ggplot(LPI_biome_summ, aes(biome, color=biome, y=populations))+geom_bar(stat = 
                    "identity")+
   theme.LPI()+
   ylab("Number of populations")+
   xlab("Biome")+
   theme(legend.position = "none"))

# Saving the plots----
png(file="biome_pop.png", width=1000, height = 2000)
ggplot(LPI_biome_summ, aes(biome, color=biome, y=populations))+geom_bar(stat="identity") +
  theme.LPI()+
  ylab("Number of populations") +
  xlab("Biome") +
  theme(legend.position = "none")
dev.off() # tells R that you're done

pdf(file="biome_pop.pdf", width=14, height=27)
ggplot(LPI_biome_summ, aes(biome, color=biome, y=populations)) + geom_bar(stat="identity") +
    theme.LPI() + ylab("Number of populations")+
    xlab("Biome")+
    theme(legend.position = "none")
dev.off()

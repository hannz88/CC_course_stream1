# Final analysis

# import the file----
Data<-read.csv("/home/han/PycharmProjects/CC_course_stream1/03_Coding_etiquette/LPIdata_CC.csv")

# import libraries----
library(tidyr)
library(ggplot2)
library(readr)
library(dplyr)

# Data cleaning----
lpi_long<-gather(Data,"year","abundance",9:53)  # turn the dataset into long

lpi_long$year <- parse_number(lpi_long$year)  # remove the X  
names(lpi_long)  #find out the column names
names(lpi_long) <- tolower(names(lpi_long))  # turn the column names into lower case
lpi_long$abundance <- as.numeric(lpi_long$abundance)  # turn the abundance values into numbers

# Calculate the populations for the bioe in wach group
lpi_biome<- lpi_long %>%
  group_by(biome) %>%
  summarise(populations = n())
lpi_biome[1:5,1:2]

# Create function for the theme of LPI
theme_lpi <- function(){
    theme_bw()+
    theme(axis.text.x=element_text(size=12, angle=45, vjust=1, hjust=1),axis.text.y=element_text(size=12),axis.title.x=element_text(size=14, face="plain"),axis.title.y=element_text(size=14, face="plain"),             
    panel.grid.major.x=element_blank(),panel.grid.minor.x=element_blank(),panel.grid.minor.y=element_blank(),panel.grid.major.y=element_blank(),  
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), units = , "cm"),
    plot.title = element_text(size=20, vjust=1, hjust=0.5),
    legend.text = element_text(size=12, face="italic"),legend.title = element_blank(),legend.position=c(0.9, 0.9))
  }

levels(lpi_long$biome)

# 3 different graphs
# Barplot for the biome
type = "bar"
biome_barplot <- ggplot(lpi_long, aes(biome, color = biome)) + {
  if(type=="bar")geom_bar() else geom_point(stat="count")
  } +
	theme_lpi() + 
  ylab("Number of populations") + 
  xlab("Biome") +
	theme(legend.position = "none")
biome_barplot# plot the ggplot plot

# Point plot for the biome
type = "point"
biome_pointplot <- ggplot(lpi_long, aes(biome, color = biome)) + {
  if(type == "bar") geom_bar() else geom_point(stat = "count")
  } +
	theme_lpi() + 
  ylab("Number of populations") + xlab("Biome") +
	theme(legend.position = "none")
biome_pointplot

# bar plot as pdf
type = "bar"
pdf(file="plot1.pdf",  width = 13.33, height = 26.66)
ggplot(lpi_long, aes(biome, color = biome)) + {
  if(type=="bar")geom_bar() else geom_point(stat="count")
  } +
	theme_lpi() +
  ylab("Number of populations") + xlab("Biome") +
	theme(legend.position = "none") 
dev.off()
dev.off()

library(RCurl)

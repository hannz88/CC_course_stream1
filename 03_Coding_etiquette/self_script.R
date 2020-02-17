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
LP12 <- gather()
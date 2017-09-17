#### Clean Up environment ---------------------------------------------------
rm(list=ls())

#### Packages ---------------------------------------------------------------
library(tidyverse)
library(readxl)

# Functions --------------------------------------------------------------

#### Data Input -------------------------------------------------------------

data.in <- read_excel("~/Documents/GitHub/Costing Project/Data/PROT01_August.xlsx", 
                      col_types = c("numeric", "numeric", "numeric", 
                                    "text", "text", "text", "text", "numeric", 
                                    "numeric", "text", "text", "text", 
                                    "text", "text", "text", "text", "text", 
                                    "text", "text", "numeric"))



#### Data Cleaning ----------------------------------------------------------

data.in2 <- data.in %>% 
        mutate(product_type = ifelse(PRODUCT == "QC", "QC", "Samples"))


data.in2 <- data.in2[,c(21,18)]
        
data.in3 <- table(data.in2)
data.in3 <- as.data.frame(data.in3)
data.in4 <- spread(data.in3, STATUS, Freq)
data.in4 <- data.in4[c(2,1),]

write.csv(data.in4, "Proteins_Aug_17.csv")

#### Visualising Data -------------------------------------------------------
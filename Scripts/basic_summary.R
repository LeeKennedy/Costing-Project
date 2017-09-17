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

## Creating new column to just identify samples and QC samples --------------
data.in2 <- data.in %>% 
        mutate(product_type = ifelse(PRODUCT == "QC", "QC", "Samples"))


data.in2 <- data.in2[,c(21,18)]
        
## A clumsy but working realignment of the data ----------------------------
data.in3 <- table(data.in2)
data.in3 <- as.data.frame(data.in3)
data.in4 <- spread(data.in3, STATUS, Freq)
data.in4 <- data.in4[c(2,1),]

## Relabelling test status codes --------------------------------------------

for(i in 2:6){
if(colnames(data.in4)[i] == "A") colnames(data.in4)[i] = "Authorised"
if(colnames(data.in4)[i] == "N") colnames(data.in4)[i] = "Not Entered"
if(colnames(data.in4)[i] == "E") colnames(data.in4)[i] = "Entered"
if(colnames(data.in4)[i] == "R") colnames(data.in4)[i] = "Rejected"
if(colnames(data.in4)[i] == "M") colnames(data.in4)[i] = "Modified"
if(colnames(data.in4)[i] == "X") colnames(data.in4)[i] = "Cancelled"
}

## Export summary table ----------------------------------------------------
write.csv(data.in4, "Proteins_Aug_17.csv")

#### Visualising Data -------------------------------------------------------
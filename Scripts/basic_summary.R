#### Clean Up environment ---------------------------------------------------
rm(list=ls())

#### Packages ---------------------------------------------------------------
library(tidyverse)
library(readxl)

# Functions --------------------------------------------------------------

#### Data Input -------------------------------------------------------------

data.in <- read_excel("~/Documents/GitHub/Costing Project/Data/PROT01_August.xlsx", 
                      col_types = c("numeric", "date", "date", 
                                    "text", "text", "text", "text", "text", 
                                    "numeric", "text", "text", "text", 
                                    "text", "text", "text", "text", "text", 
                                    "text", "text", "numeric"))



#### Data Cleaning ----------------------------------------------------------

raw_numbers <- length(unique(data.in$SAMPLE_NUMBER))
distribution <- as.data.frame.matrix(table(data.in$REPLICATE_COUNT,data.in$STATUS))
row_dist <- nrow(distribution)

distribution$Replicate <- 1:row_dist
distribution$product_type <- "All"
len_dist <- length(distribution)

distribution <- distribution[,c(len_dist, len_dist-1, 1:(len_dist-2))]

## Creating new column to just identify samples and QC samples --------------
data.in2 <- data.in %>% 
        mutate(product_type = ifelse(PRODUCT == "QC", "QC", "Samples"))


data.in2 <- data.in2[,c(21,18)]
        
## A clumsy but working realignment of the data ----------------------------
data.in3 <- table(data.in2)
data.in3 <- as.data.frame(data.in3)
data.in4 <- spread(data.in3, STATUS, Freq)
data.in4 <- data.in4[c(2,1),]
data.in4$Replicate <- 0
n <- length(data.in4)
data.in4 <- data.in4[,c(1,n,2:(n-1))]

data.in5 <- rbind(data.in4, distribution)

## Relabelling test status codes --------------------------------------------

for(i in 3:8){
if(colnames(data.in5)[i] == "A") colnames(data.in5)[i] = "Authorised"
if(colnames(data.in5)[i] == "N") colnames(data.in5)[i] = "Not Entered"
if(colnames(data.in5)[i] == "E") colnames(data.in5)[i] = "Entered"
if(colnames(data.in5)[i] == "R") colnames(data.in5)[i] = "Rejected"
if(colnames(data.in5)[i] == "M") colnames(data.in5)[i] = "Modified"
if(colnames(data.in5)[i] == "X") colnames(data.in5)[i] = "Cancelled"
}



## Export summary table ----------------------------------------------------
write.csv(data.in5, "Protein_August_17.csv")

#### Visualising Data -------------------------------------------------------
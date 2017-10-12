#### Clean Up environment -----------------------------
rm(list=ls())

#### Packages -----------------------------
library(readxl)
library(tidyverse)
library(dts.quality)
library(psych)

#### Functions -----------------------------


#### Data Input -----------------------------

batch <- read_excel("~/Desktop/FATS07.xlsx", 
                    col_types = c("numeric", "date", "date", 
                                  "text", "text", "text", "text", "numeric", 
                                  "numeric", "text", "text", "text", 
                                  "text", "text", "text", "text", "text", 
                                  "text", "text", "numeric", "text"))

#### Data Cleaning -----------------------------

batch <- batch %>% 
        mutate(Type = ifelse(PRODUCT == "QC", "QC", "Samples"))

batch <- batch[,-3]

batch2 <- as.data.frame.matrix(table(batch$NAME, batch$Type))
batch2 <- add_rownames(batch2, "Batch")
batch2

batch3 <- as.data.frame.matrix(table(batch$NAME, batch$STATUS))
batch3 <- add_rownames(batch3, "Batch")
batch3

batch_all <- merge(batch2, batch3, by.x = "Batch", by.y = "Batch")
batch_all

for(i in 4:9){
        if(colnames(batch_all)[i] == "A") colnames(batch_all)[i] = "Authorised"
        if(colnames(batch_all)[i] == "N") colnames(batch_all)[i] = "Not Entered"
        if(colnames(batch_all)[i] == "E") colnames(batch_all)[i] = "Entered"
        if(colnames(batch_all)[i] == "R") colnames(batch_all)[i] = "Rejected"
        if(colnames(batch_all)[i] == "M") colnames(batch_all)[i] = "Modified"
        if(colnames(batch_all)[i] == "X") colnames(batch_all)[i] = "Cancelled"
}

batch_data_1 <- write_csv(batch_all, "~/Desktop/batch_list.csv")
 
batch_summary <- describe(batch_all)
batch_summary <- batch_summary[-1, c(2:5,8,9)]
batch_summary <- add_rownames(batch_summary, "Sample")

batch_data_2 <- write_csv(batch_summary, "~/Desktop/batch_summary.csv")

# This script reads in the data from the excel file and generates an RDS for 
# use later on in the workflow

raw_data <- readxl::read_excel("raw_data.xlsx")

saveRDS(raw_data, "data/loaded_data.RDS")

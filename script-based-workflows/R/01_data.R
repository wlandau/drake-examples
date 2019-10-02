# This script will read in the data from the excel file and generate an RDS for 
# use later on in the script. Normally more would be done upon loading the data

raw_data = readxl::read_excel("raw_data.xlsx")

saveRDS(raw_data, here("data","loaded_data.RDS"))

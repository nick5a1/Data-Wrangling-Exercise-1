# Import excel file
library(readxl)
refine <- read_excel("refine.xlsx")

# install.packages("tidyr")
library(tidyr)
# install.packages("dplyr")
library(dplyr)
library(tibble)

# Clean company names
c = tolower(refine[[1]])
c = gsub("^p.*","philips",c)
c = gsub("^f.*","philips",c)
c = gsub("^a.*","akzo",c)
c = gsub("^v.*","van houten",c)
c = gsub("^u.*","unilever",c)
refine[[1]] = c

# Add columns for product code and number
refine = separate(refine,`Product code / number `,c("product_code","product_number"),sep="-",remove=FALSE)
refine$product_number = as.integer(refine$product_number)

# Add product_category
v = gsub("p","Smartphone",refine[[3]])
v = gsub("v","TV",v)
v = gsub("x","Laptop",v)
v = gsub("q","Tablet",v)
refine = add_column(refine,product_category=v)

# Add full_address
refine = add_column(refine,full_address=paste(refine$address,refine$city,refine$country,sep=", "))

# Add binary columns
refine = spread(refine,company,company)
i = 10
while (i<14) {
  refine[[i]] = as.integer(replace(refine[[i]],which(!is.na(refine[[i]])),1))
  refine[[i]] = as.integer(replace(refine[[i]],which(is.na(refine[[i]])),0))
  i = i+1
}

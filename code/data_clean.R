library(readxl)
library(dplyr)
library(tidyverse)
library(janitor)
## Import Data ------

##due to export restrictions, powerbi desktop data query was sent to powerbi service (online) and exported to excel month by month
##service line is limited to outpatient oncology due to data size limits
##the monthly clinic data is read in one by one

jul24 <- read_excel("C:/Users/4477078/OneDrive - Moffitt Cancer Center/Key Drivers/kdr_clinic/data/kdr_clinic_jul2024.xlsx")
aug24 <- read_excel("C:/Users/4477078/OneDrive - Moffitt Cancer Center/Key Drivers/kdr_clinic/data/kdr_clinic_aug2024.xlsx")
sep24 <- read_excel("C:/Users/4477078/OneDrive - Moffitt Cancer Center/Key Drivers/kdr_clinic/data/kdr_clinic_sep2024.xlsx")
oct24 <- read_excel("C:/Users/4477078/OneDrive - Moffitt Cancer Center/Key Drivers/kdr_clinic/data/kdr_clinic_oct2024.xlsx")
nov24 <- read_excel("C:/Users/4477078/OneDrive - Moffitt Cancer Center/Key Drivers/kdr_clinic/data/kdr_clinic_nov2024.xlsx")
dec24 <- read_excel("C:/Users/4477078/OneDrive - Moffitt Cancer Center/Key Drivers/kdr_clinic/data/kdr_clinic_dec2024.xlsx")

##combine rows of data tables

clinic_data<-rbind(jul24, aug24, sep24, oct24, nov24, dec24)

clinic_data <- clinic_data%>%
  clean_names() %>%
  filter(service == "ON") %>%
  as.data.frame() %>%
  rename(unit0=pg_unit,
         clinic0=pg_clinic,
         question=question_text_latest,
         top_box=top_box_ind) %>%
  mutate(recdate = as.Date(recdate)) %>%
  mutate(response = as.numeric(response))

distinct(clinic_data,unit0)
distinct(clinic_data,clinic0)


#Fix problems with the data
##From "Plastic Surgery Center" to "Reconstructive Oncology Clinic"
##From Blood and Marrow Treatment Center(BMTC) to BMTT unit.

clinic_data$unit<-ifelse(clinic_data$clinic0 =="Blood and Marrow Treatment Center","BMTT",
                                ifelse( clinic_data$clinic0 == "Moffitt Wesley Chapel Infusion Center", "WCIC",
                                          clinic_data$unit0)
                                )

clinic_data$clinic<-ifelse(clinic_data$clinic0 =="Plastic Surgery Center",
                                  "Reconstructive Oncology Clinic", 
                                  clinic_data$clinic0
                                  )

# 
# distinct(clinic_data,unit)
# distinct(clinic_data,clinic)

clinic_data <- clinic_data %>%
  select (-c(clinic0,unit0))

#This data will now be saved as an Rdata file and will be used for all individual clinic level key drivers for this time period
save(clinic_data, file = "C:/Users/4477078/OneDrive - Moffitt Cancer Center/Key Drivers/kdr_clinic/data/clinic_data.Rdata")

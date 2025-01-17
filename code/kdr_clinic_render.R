library(quarto)
library(tidyverse)

load("C:/Users/4477078/OneDrive - Moffitt Cancer Center/Key Drivers/kdr_clinic/data/clinic_data.Rdata")

x <- "ON" #set service line

# y <- "O7"
if (x =='ON'){
  y <- "O3" #Outpatient Oncology
  } else {
  y <- "O4" # Virtual Health
  } 


##Running kdr reports for those providers who meet the specified criteria

allresults <- clinic_data %>%
  filter(service == x ) %>%
  filter(varname == y ) %>%
  group_by(clinic, unit) %>%
  summarise(tbscore=sum(top_box)/n()*100,n=n())


runners <- clinic_data %>%
  filter(service == x ) %>%
  filter(varname == y ) %>%
  group_by(clinic, unit) %>%
  summarise(tbscore=sum(top_box)/n()*100,n=n()) %>%
  filter(tbscore<100 )

t<- nrow(runners)

units <- runners %>%
  pull(unit) %>%
  as.character()

clinics <- runners %>%
  pull(clinic) %>%
  as.character()

reports<-
  tibble(
    input="kdr_clinic.qmd",
    output_file = str_glue("{clinics}.html"),
    execute_params=map(units,~list(unit=.))
  )

reports<-reports%>%
  slice(1:t)

pwalk(reports,quarto_render)



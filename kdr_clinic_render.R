library(quarto)
library(tidyverse)

load("G:/Press Ganey II/Reports/Ad Hoc/DEEP DIVE/Key Driver Reports/data/clinic_data.Rdata")

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
  group_by(clinic2, unit2) %>%
  summarise(tbscore=sum(top_box)/n()*100,n=n())


runners <- clinic_data %>%
  filter(service == x ) %>%
  filter(varname == y ) %>%
  group_by(clinic2, unit2) %>%
  summarise(tbscore=sum(top_box)/n()*100,n=n()) %>%
  filter(tbscore<100 )

t<- nrow(runners)

units <- runners %>%
  pull(unit2) %>%
  as.character()

clinics <- runners %>%
  pull(clinic2) %>%
  as.character()

reports<-
  tibble(
    input="kdr_clinic.qmd",
    output_file = str_glue("{clinics}.html"),
    execute_params=map(units,~list(unit2=.))
  )

reports<-reports%>%
  slice(1:t)

pwalk(reports,quarto_render)



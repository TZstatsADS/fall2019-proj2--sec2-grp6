
library(dplyr)

# # read and clean current year crime data
# nyc_crime_current <- read.csv(file="NYPD_Complaint_Data_Current__Year_To_Date_.csv", header=TRUE, sep=",")
# nyc_crime_current <- subset(nyc_crime_current, select = c(OFNS_DESC, LAW_CAT_CD, CMPLNT_FR_DT, Latitude, Longitude, X_COORD_CD, Y_COORD_CD))
# nyc_crime_current <- nyc_crime_current[as.Date(nyc_crime_current$CMPLNT_FR_DT, format = "%m/%d/%Y") >= as.Date("01/01/2019", format = "%m/%d/%Y"),]
# 
# # read and clean historic crime data for 2015-2018
# nyc_crime_historic <- read.csv(file="NYPD_Complaint_Data_Historic.csv", header=TRUE, sep=",")
# nyc_crime_historic <- subset(nyc_crime_historic, select = c(OFNS_DESC, LAW_CAT_CD, CMPLNT_FR_DT, Latitude, Longitude, X_COORD_CD, Y_COORD_CD))
# nyc_crime_historic <- nyc_crime_historic[(as.Date(nyc_crime_historic$CMPLNT_FR_DT, format = "%m/%d/%Y") >= as.Date("01/01/2015", format = "%m/%d/%Y")) & (as.Date(nyc_crime_historic$CMPLNT_FR_DT, format = "%m/%d/%Y") < as.Date("01/01/2019", format = "%m/%d/%Y")),]
# 
# # merge current year and historic crime data
# nyc_crime <- rbind(nyc_crime_current, nyc_crime_historic)
# 
# # clean NA
# unique(nyc_crime[is.na(nyc_crime$LAW_CAT_CD),]) # Where LAW_CAT_CD is NA, all other features are NA
# nyc_crime <- nyc_crime[complete.cases(nyc_crime),]
# 
# # save as csv file
# write.csv(nyc_crime, "nyc_crime.csv", row.names=F)

nyc_crime <- read.csv(file = "nyc_crime.csv", header = TRUE, sep = ",")
head(nyc_crime)

# felony <- filter(nyc_crime, LAW_CAT_CD == "FELONY")
# misdemeanor <- filter(nyc_crime, LAW_CAT_CD == "MISDEMEANOR")
# violation <- filter(nyc_crime, LAW_CAT_CD == "VIOLATION")
# 
# write.csv(felony, "felony.csv", row.names=F)
# write.csv(misdemeanor, "misdemeanor.csv", row.names=F)
# write.csv(violation, "violation.csv", row.names=F)

felony <- read.csv(file = "felony.csv", header = TRUE, sep = ",")
misdemeanor <- read.csv(file = "misdemeanor.csv", header = TRUE, sep = ",")
violation <- read.csv(file = "violation.csv", header = TRUE, sep = ",")

# # read and clean current year shooting data
# nyc_shooting_current <- read.csv(file="NYPD_Shooting_Incident_Data__Year_To_Date_.csv", header=TRUE, sep=",")
# nyc_shooting_current <- subset(nyc_shooting_current, select = c(OCCUR_DATE, Latitude, Longitude, X_COORD_CD, Y_COORD_CD))
# nyc_shooting_current <- nyc_shooting_current[as.Date(nyc_shooting_current$OCCUR_DATE, format = "%m/%d/%Y") >= as.Date("01/01/2019", format = "%m/%d/%Y"),]
# 
# # read and clean historic shooting data for 2015-2018
# nyc_shooting_historic <- read.csv(file="NYPD_Shooting_Incident_Data__Historic_.csv", header=TRUE, sep=",")
# nyc_shooting_historic <- subset(nyc_shooting_historic, select = c(OCCUR_DATE, Latitude, Longitude, X_COORD_CD, Y_COORD_CD))
# nyc_shooting_historic <- nyc_shooting_historic[(as.Date(nyc_shooting_historic$OCCUR_DATE, format = "%m/%d/%Y") >= as.Date("01/01/2015", format = "%m/%d/%Y")) & (as.Date(nyc_shooting_historic$OCCUR_DATE, format = "%m/%d/%Y") < as.Date("01/01/2019", format = "%m/%d/%Y")),]
# 
# # merge current year and historic shooting data
# nyc_shooting <- rbind(nyc_shooting_current, nyc_shooting_historic)
# nyc_shooting <- nyc_shooting[complete.cases(nyc_shooting),]
# 
# # # save as csv file
# write.csv(nyc_shooting, "nyc_shooting.csv", row.names=F)

nyc_shooting <- read.csv(file="nyc_shooting.csv", header=TRUE, sep=",")





######INCOME FROM HERE######


# # read and clean income data
# nyc_income <- read.csv(file="Participatory_Budgeting_Survey_Data.csv", header=TRUE, sep=",")
# nyc_income <- subset(nyc_income, select = c(DISTRICT, EDUCATION, INCOME, AGE))
# nyc_income <- nyc_income[complete.cases(nyc_income$INCOME),] # drop cases where income is not provided
# head(nyc_income)
# 
# # check unique values for each feature
# unique(nyc_income$DISTRICT)
# unique(nyc_income$EDUCATION)
# unique(nyc_income$INCOME)
# unique(nyc_income$AGE)
# 
# # clean data for participants with age less than 17 and participants with unknown income
# nyc_income <- nyc_income[!nyc_income$AGE %in% c("","14-17","<13","11 to 13","14 to 17","10 or younger"),]
# nyc_income <- nyc_income[!nyc_income$INCOME %in% c("", "I don't know"),]
# nyc_income <- nyc_income[!nyc_income$EDUCATION %in% c("Currently entrolled in Middle School","Currently entrolled in High School"),]
# 
# # drop AGE and EDUCATION
# nyc_income<- subset(nyc_income, select = c(INCOME, DISTRICT))
# 
# # save csv file
# write.csv(nyc_income, "nyc_income.csv", row.names=F)

nyc_income<-read.csv(file = "nyc_income.csv", header = TRUE, sep = ",")
unique(nyc_income$DISTRICT)
unique(nyc_income$INCOME)

# library(plyr)
# 
# income_by_district <- count(nyc_income, vars=c("DISTRICT", "INCOME"))
# write.csv(income_by_district, "income_by_district.csv", row.names = F)

# income_by_district <- read.csv(file="income_by_district.csv", header=TRUE, sep=",")
# 
# library(dplyr)
# 
# income_order <- c("Under $10,000","$10,000-$24,999","$25,000-$49,999","$50,000-$74,999","$75,000-$99,999","$100,000 or more","$125,000 or more")
# 
# perc_income_by_district <- income_by_district %>%
#   group_by(DISTRICT) %>%
#   mutate(perc = (freq/sum(freq) * 100))%>%
#   slice(match(income_order, INCOME))
# 
# perc_income_by_district$DISTRICT <- as.numeric(gsub("D","",perc_income_by_district$DISTRICT))
# 
# write.csv(perc_income_by_district, "perc_income_by_district.csv", row.names = F)

perc_income_by_district <- read.csv(file="perc_income_by_district.csv", header=TRUE, sep=",")

# median_income_by_district <- data.frame(District = c(1:51), Median = "unknown", stringsAsFactors=FALSE)
# 
# for (district in c(1:51)){
#   temp <- perc_income_by_district[perc_income_by_district$DISTRICT == district,]
#   if (nrow(temp) == 0){
#     next
#   }
#   cum = 0
#   for (i in c(1:nrow(temp))){
#     perc <- temp[i,4]
#     cum = cum + perc
#     med <- temp[i,2]
#     if (cum >= 50){
#       break
#     }
#   }
#   median_income_by_district[district,2] = toString(med)
# }
# 
# write.csv(median_income_by_district, 'median_income_by_district.csv', row.names=F)

read.csv(file = "median_income_by_district.csv", header=TRUE, sep=",")
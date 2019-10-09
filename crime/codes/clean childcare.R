library(RDSTK)
library(readr)

childcare <- read_csv("DOHMH_Childcare_Center_Inspections.csv")
colnames(childcare) <- make.names(colnames(childcare), unique=TRUE)

nrow(childcare)

head(childcare)

childcare_2018 <- childcare[as.Date(childcare$Inspection.Date, format = "%m/%d/%Y") >= as.Date("01/01/2018", format = "%m/%d/%Y"),]# & as.Date(childcare$`Inspection Date`, format = "%m/%d/%Y") < as.Date("01/01/2019", format = "%m/%d/%Y"),]

ordered_childcare <- childcare_2018[order(childcare_2018$Legal.Name),]
final <- ordered_childcare[!duplicated(ordered_childcare$Legal.Name),]
final <- subset(final, select = c(Legal.Name, Center.Name, Building, Street, Borough, ZipCode, Phone, Age.Range, Program.Type, Child.Care.Type, Violation.Rate.Percent, Average.Violation.Rate.Percent))
final <- final[rowSums(is.na(final)) != ncol(final), ]

head(final)

nrow(final)

unique(final$Age.Range)

unique(final[final$Age.Range == "3 YEARS - 5 YEARS","Program.Type"])

final[final$Program.Type == "Preschool", "Program.Type"] <- "PRESCHOOL"


unique(final[final$Child.Care.Type == "School Based Child Care", "Average.Violation.Rate.Percent"])
unique(final[final$Child.Care.Type == "Child Care - Infants/Toddlers", "Average.Violation.Rate.Percent"])
unique(final[final$Child.Care.Type == "Child Care - Pre School", "Average.Violation.Rate.Percent"])

final[is.na(final$Average.Violation.Rate.Percent) & final$Child.Care.Type == "School Based Child Care","Average.Violation.Rate.Percent"] <- 41.61
final[is.na(final$Average.Violation.Rate.Percent) & final$Child.Care.Type == "Child Care - Infants/Toddlers","Average.Violation.Rate.Percent"] <- 30.9
final[is.na(final$Average.Violation.Rate.Percent) & final$Child.Care.Type == "Child Care - Pre School","Average.Violation.Rate.Percent"] <- 33.2

final[is.na(final$Average.Violation.Rate.Percent)]

final$lessThanAve = as.integer(final$Violation.Rate.Percent < final$Average.Violation.Rate.Percent)
final$noViolation = as.integer(final$Violation.Rate.Percent== 0)

head(final[c("lessThanAve", "noViolation")])

write.csv(final, 'child_care.csv', row.names = F)

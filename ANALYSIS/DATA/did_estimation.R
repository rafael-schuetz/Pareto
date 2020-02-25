### DiD-Schätzungen

# Erstellung von Interaktionstermen, in denen die Treatment-Variable mit den Jahres-Dummies interagiert werden
### DID Term (Interaktionsterm erstellen) ####

library(dplyr)
library(stargazer)

dfcEF$treat_2011 <- NULL
dfcEF$treat_2012 <- NULL
dfcEF$treat_2013 <- NULL
dfcEF$treat_2014 <- NULL
dfcEF$treat_2015 <- NULL
dfcEF$treat_2016 <- NULL
dfcEF$treat_2017 <- NULL
dfcEF$treat_2018 <- NULL


dfcEF <- dfcEF %>% 
  mutate(
    treat_2011 = treatEF*dummy_2011,
    treat_2012 = treatEF*dummy_2012,
    treat_2013 = treatEF*dummy_2013,
    treat_2014 = treatEF*dummy_2014,
    treat_2015 = treatEF*dummy_2015,
    treat_2016 = treatEF*dummy_2016,
    treat_2017 = treatEF*dummy_2017,
    treat_2018 = treatEF*dummy_2018
  )

#dfcEF <- dfcEF %>% 
#  mutate(
#    treat_2011 = ifelse(treatEF == 1 & dummy_2011 == 1, 1, 0),
#    treat_2012 = ifelse(treatEF == 1 & dummy_2012 == 1, 1, 0),
#    treat_2013 = ifelse(treatEF == 1 & dummy_2013 == 1, 1, 0),
#   treat_2014 = ifelse(treatEF == 1 & dummy_2014 == 1, 1, 0),
#    treat_2015 = ifelse(treatEF == 1 & dummy_2015 == 1, 1, 0),
#    treat_2016 = ifelse(treatEF == 1 & dummy_2015 == 1, 1, 0),
#    treat_2017 = ifelse(treatEF == 1 & dummy_2015 == 1, 1, 0),
#    treat_2018 = ifelse(treatEF == 1 & dummy_2015 == 1, 1, 0)
#  )

#id als factor definieren
dfcEF$id <- as.factor(dfcEF$id)
dfcEF$year <- as.factor(dfcEF$year)
dfcEF$treatEF <- as.numeric(dfcEF$treatEF)

### DID Regression ####

#treatEF ist der treatment Effekt
#year ist der Year fixed effect (Zeitfixedeffect)
#id ist der ID fixed effect
#treat_2011 ist beispielsweise der Interaktionsterm zwischen 2011 und der Treatment Variable

lmdid <- lm(dfcEF$selfworth ~ dfcEF$treatEF + dfcEF$id + dfcEF$year + (dfcEF$year*dfcEF$treatEF))

lm_did_daytodayskills1 <- lm( dfcEF$dayToDaySkills ~ dfcEF$treatEF + dfcEF$id + dfcEF$year
                              +  dfcEF$treat_2012
                              + dfcEF$treat_2013 + dfcEF$treat_2014 + dfcEF$treat_2015 + dfcEF$treat_2016 + 
                                dfcEF$treat_2017 + dfcEF$treat_2018
)

lm_did_daytodayskills <- lm(dfcEF$dayToDaySkills ~ dfcEF$treatEF + dfcEF$id + dfcEF$dummy_2012
                            + dfcEF$dummy_2013
                            + dfcEF$dummy_2014
                            + dfcEF$dummy_2015
                            + dfcEF$dummy_2016
                            + dfcEF$dummy_2017
                            + dfcEF$dummy_2018
                            + dfcEF$treat_2012 +
                         dfcEF$treat_2013 + dfcEF$treat_2014 + dfcEF$treat_2015 + dfcEF$treat_2016 + 
                         dfcEF$treat_2017 + dfcEF$treat_2018)

summary(lm_did_daytodayskills, cluster = c('id'))
summary(lm_did_daytodayskills)

summary(lm.object, cluster=c("variable")) 

summary(lmdid)

alias(lm_did_selfworth)


### Regression for DID Estimation ####
library(sandwich)
library(estimatr)
library(robustbase)

#lineares Modell mit robusten Standardfehlern und fixed effects (time und ID)
lmdid2 <- lm_robust(dfcEF$dayToDaySkills ~ dfcEF$treatEF,
                    fixed_effects = ~ dfcEF$id + dfcEF$year, se_type = "HC1")

lmdid3 <- lm(dfcEF$dayToDaySkills ~ dfcEF$treatEF + dfcEF$id + dfcEF$year )
  
summary(lmdid2)
summary(lmdid3)

library(texreg)

texreg(lmdid2)

#treat EF misst den Treatment Effekt in den jeweiligen Zeitperioden
#Also 0011111 oder 011111 oder 00000011
#id ist der ID fixed effect
#year misst den year fixed effect
#beides als fixed effect, weil die Variable als factor definiert ist


### Regression Results Table ####

table_did_daytodayskills <- stargazer(lmdid3,
                                 omit = c('id104','id105','id106','id108','id109','id111','id112','id113','id114','id118','id122',
                                         'id123','id124','id125','id130','id131','id132','id133','id136','id137','id139','id141',
                                         'id142','id165','id186','id187','id188','id189','id190','id191','id192','id193','id194',
                                         'id209','id213','id214','id215','id216','id217','id218','id219','id220','id221','id226',
                                         'id233','id249','id255','id269','id270','id281','id282','id403','id404','id417','id418',
                                         'id437','id482','id483','id599','id600','id601','id602','id623','id684','id685','id686',
                                         'id687', 'year2012', 'year2013', 'year2014', 'year2015', 'year2016', 'year2017',
                                         'year2018', 'year2', 'year3', 'year4', 'year5', 'year6', 'year7', 'year8',
                                         'dummy_2012',
                                         'dummy_2013',
                                         'dummy_2014',
                                         'dummy_2015',
                                         'dummy_2016',
                                         'dummy_2017',
                                         'dummy_2018'),
                                 add.lines = list(c('ID fixed effects', 'Yes'),
                                                  c('Year fixed effects', 'Yes')),
                                 type = 'text')


corr.test(dfcEF$dummy_2018, dfcEF$treatEF, use = 'pairwise', method = 'pearson', ci = TRUE)

cor(dfcEF$dummy_2018, dfcEF$treatEF, use = 'everything', method = 'pearson')

alias(lm_did_daytodayskills)

library(RCurl)
library(gdata) 
library(zoo)

lmdid3 <- lm(dfcEF$dayToDaySkills ~ dfcEF$treatEF + dfcEF$id + dfcEF$year)

### clustern #####

library(robustbase)
library(tidyverse)
library(sandwich)
library(lmtest)
library(modelr)
library(broom)

lmdid3 <- lm(dfcEF$dayToDaySkills ~ dfcEF$treatEF + dfcEF$id + dfcEF$year)

lmdid3 <- coeftest(lmdid3, vcov. = vcovHC(lmdid3, type = 'HC1'))

summary(lmdid3)






















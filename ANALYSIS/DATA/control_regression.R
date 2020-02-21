### Regressionen

library(stats)
library(car)
library(estimatr)

### 1. Regression: Simple linear regression
# Die Zielvariable y wird nur auf die Treatment-Variable "treatEF" regressiert

lm1_selfworth <- lm_robust(dfcEF$selfworth ~ dfcEF$treatEF)
summary(lm1_selfworth)

lm1_skills <- lm_robust(dfcEF$dayToDaySkills ~ dfcEF$treatEF)
summary(lm1_skills)

### 2. Regression: Lineare Regression mit year-fixed effects 
# Die lineare Regression wird um year-fixed effects erweitert, indem die Dummy-Variablen für die
# die verschiedenen Jahre berücksichtigt werden.
# Methode: Fixed Effects using Least Squares dummy variable model

# In dem ersten Fixed effects - Modell werden alle t Jahres-Dummies inkludiert und der Intercept
# weggelassen, um perfekte Multikollinearität zu verhindern

lm2_selfworth <- lm(dfcEF$selfworth ~ dfcEF$treatEF + dfcEF$dummy_2011 + dfcEF$dummy_2012 
                    + dfcEF$dummy_2013 + dfcEF$dummy_2014 + dfcEF$dummy_2015 + dfcEF$dummy_2016 
                    + dfcEF$dummy_2017 + dfcEF$dummy_2018 - 1)
summary(lm2_selfworth)

# Die Warnung "1 not defined because of singularities" erscheint, wenn zwischen den x-Variablen
# eine starke Korrelation bzw. Multikollinearität besteht. Wenn die lineare Regressionsfunktion
# lm() verwendet wird, dann liefert R ein "NA" als Koeffizient für stark korrelierte Variablen.
# Aus diesem Grund ist der Koeffizient für die Dummy-Variable "dummy_2018" ein "NA", obwohl der 
# Intercept bereits weggelassen wurde.

# Die Funktion alias() findet linear abhängige Terme in einem linearen Modell, welches anhand
# der Funktion lm() spezifiziert wurde.
alias(lm2_selfworth)

# Alle Werte der alias-Tabelle, die 1 oder -1 sind, zeigen, dass diese Variablen in linearer
# Abhängigkeit zu der Dummy-Variable "dummy_2018" stehen. Das bedeutet, dass diese Variablen
# stark korrliert sind, allerdings können die Terme auch stark miteinander korreliert sein,
# ohne linear voneinander abhängig zu sein.

# Um zu verhindern, dass der geschätzte Regressionskoeffizient für bestimmte Variablen "NA"
# annimmt, kann die Dummy-Variable für ein Jahr ausgelassen werden, sodass die Regression nur noch 
# t-1 Jahres-Dummies enthält. Dabei wird die Dummy-Variable "dummy_2011" für das erste betrachtete
# Jahr ausgelassen. In diesem Fall kann der Intercept wieder berücksichtigt werden.

lm2_selfworth <- lm(dfcEF$selfworth ~ dfcEF$treatEF + dfcEF$dummy_2012 + dfcEF$dummy_2013
          + dfcEF$dummy_2014 + dfcEF$dummy_2015 + dfcEF$dummy_2016 
          + dfcEF$dummy_2017 + dfcEF$dummy_2017 + dfcEF$dummy_2018)
summary(lm2_selfworth)

# Mit robusten Standardfehlern
lm2_selfworth <- lm_robust(dfcEF$selfworth ~ dfcEF$treatEF + dfcEF$dummy_2012 + dfcEF$dummy_2013
                    + dfcEF$dummy_2014 + dfcEF$dummy_2015 + dfcEF$dummy_2016 
                    + dfcEF$dummy_2017 + dfcEF$dummy_2017 + dfcEF$dummy_2018)
summary(lm2_selfworth)

## Analog dazu: "dayToDaySkills" als Zielvariable

# Regression mit allen Jahres-Dummies und ohne Intercept
lm2_skills <- lm(dfcEF$dayToDaySkills ~ dfcEF$treatEF + dfcEF$dummy_2011 + dfcEF$dummy_2012 + dfcEF$dummy_2013
                    + dfcEF$dummy_2014 + dfcEF$dummy_2015 + dfcEF$dummy_2016 
                    + dfcEF$dummy_2017 + dfcEF$dummy_2017 + dfcEF$dummy_2018 - 1)
summary(lm2_skills)

# Test auf Multikollinearität bzw. starke Korrelation
alias(lm2_skills)

# Regression mit t-1 Jahres-Dummies (Dummy für 2011 ausgelassen) und mit Intercept
lm2_skills <- lm(dfcEF$dayToDaySkills ~ dfcEF$treatEF + dfcEF$dummy_2012 + dfcEF$dummy_2013
                 + dfcEF$dummy_2014 + dfcEF$dummy_2015 + dfcEF$dummy_2016 
                 + dfcEF$dummy_2017 + dfcEF$dummy_2017 + dfcEF$dummy_2018)
summary(lm2_skills)

# Mit robusten Standardfehlern
lm2_skills <- lm_robust(dfcEF$dayToDaySkills ~ dfcEF$treatEF + dfcEF$dummy_2012 + dfcEF$dummy_2013
                 + dfcEF$dummy_2014 + dfcEF$dummy_2015 + dfcEF$dummy_2016 
                 + dfcEF$dummy_2017 + dfcEF$dummy_2017 + dfcEF$dummy_2018)
summary(lm2_skills)

### 3. Regression: Lineare Regression mit id-fixed effects (= entity-fixed effects)
# Die lineare Regression wird um id-fixed effects erweitert, indem die n-1 Dummy-Variablen für
# die verschiedenen Einrichtungen berücksichtigt werden.
# Methode: Fixed Effects using Least Squares dummy variable dummy

lm3_selfworth <-lm(dfcEF$selfworth ~ dfcEF$treatEF + dfcEF$dummy104 + dfcEF$dummy105 + 
                     dfcEF$dummy106 + dfcEF$dummy108 + dfcEF$dummy109 + dfcEF$dummy111 + 
                     dfcEF$dummy112 + dfcEF$dummy113 + dfcEF$dummy114 + dfcEF$dummy118 +
                     dfcEF$dummy122 + dfcEF$dummy123 + dfcEF$dummy124 + dfcEF$dummy125 +
                     dfcEF$dummy130 + dfcEF$dummy131 + dfcEF$dummy132 + dfcEF$dummy133 +
                     dfcEF$dummy136 + dfcEF$dummy137 + dfcEF$dummy139 + dfcEF$dummy141 +
                     dfcEF$dummy142 + dfcEF$dummy165 + dfcEF$dummy186 + dfcEF$dummy187 + 
                     dfcEF$dummy188 + dfcEF$dummy189 + dfcEF$dummy190 + dfcEF$dummy191 + 
                     dfcEF$dummy192 + dfcEF$dummy193 + dfcEF$dummy194 + dfcEF$dummy209 + 
                     dfcEF$dummy213 + dfcEF$dummy214 + dfcEF$dummy215 + dfcEF$dummy216 + 
                     dfcEF$dummy217 + dfcEF$dummy218 + dfcEF$dummy219 + dfcEF$dummy220 + 
                     dfcEF$dummy221 + dfcEF$dummy226 + dfcEF$dummy233 + dfcEF$dummy249 +
                     dfcEF$dummy255 + dfcEF$dummy269 + dfcEF$dummy270 + dfcEF$dummy281 + 
                     dfcEF$dummy282 + dfcEF$dummy403 + dfcEF$dummy404 + dfcEF$dummy417 + 
                     dfcEF$dummy418 + dfcEF$dummy437 + dfcEF$dummy482 + dfcEF$dummy483 +
                     dfcEF$dummy599 + dfcEF$dummy600 + dfcEF$dummy601 + dfcEF$dummy602 + 
                     dfcEF$dummy623 + dfcEF$dummy663 + dfcEF$dummy664 + dfcEF$dummy665 + 
                     dfcEF$dummy666 + dfcEF$dummy667 + dfcEF$dummy684 + dfcEF$dummy685 +
                     dfcEF$dummy686 + dfcEF$dummy687)
summary(lm3_selfworth)

# Die Warnung "5 not defined because of singularities" erscheint, da zwischen bestimmten
# x-Variablen eine starke Korrelation bzw. Multikollinearität besteht. 
# Aus diesem Grund ist der Koeffizient für die Dummy-Variablen "dummy663", "dummy664",
# "dummy665", "dummy666", "dummy667" ein "NA"

# Die Funktion alias() findet linear abhängige Terme in einem linearen Modell, welches anhand
# der Funktion lm() spezifiziert wurde.
alias(lm3_selfworth)

# Die Alias-Tabelle zeigt nur Werte von 0, sodass davon auszugehen ist, dass die Variablen
# "dummy663", "dummy664", "dummy665", "dummy666", "dummy667" untereinander stark korreliert sind.
# Die betroffenen Einrichtungen mit der Einrichtungs-ID von 663-667 wurden seit Beginn der
# Förderung sowohl für 2018 als auch für 2019 nicht für den Mittagstisch beobachtet.
# Daher sollte überlegt werden, ob die Einrichtungen aus dem Datensatz rausgenommen werden.

# Regression ohne die Dummy-Variablen "dummy663", "dummy664", "dummy665", "dummy666", "dummy667"
# und ohne Intercept

lm3_selfworth <-lm(dfcEF$selfworth ~ dfcEF$treatEF + dfcEF$dummy103 + dfcEF$dummy104 + dfcEF$dummy105 + 
                     dfcEF$dummy106 + dfcEF$dummy108 + dfcEF$dummy109 + dfcEF$dummy111 + 
                     dfcEF$dummy112 + dfcEF$dummy113 + dfcEF$dummy114 + dfcEF$dummy118 +
                     dfcEF$dummy122 + dfcEF$dummy123 + dfcEF$dummy124 + dfcEF$dummy125 +
                     dfcEF$dummy130 + dfcEF$dummy131 + dfcEF$dummy132 + dfcEF$dummy133 +
                     dfcEF$dummy136 + dfcEF$dummy137 + dfcEF$dummy139 + dfcEF$dummy141 +
                     dfcEF$dummy142 + dfcEF$dummy165 + dfcEF$dummy186 + dfcEF$dummy187 + 
                     dfcEF$dummy188 + dfcEF$dummy189 + dfcEF$dummy190 + dfcEF$dummy191 + 
                     dfcEF$dummy192 + dfcEF$dummy193 + dfcEF$dummy194 + dfcEF$dummy209 + 
                     dfcEF$dummy213 + dfcEF$dummy214 + dfcEF$dummy215 + dfcEF$dummy216 + 
                     dfcEF$dummy217 + dfcEF$dummy218 + dfcEF$dummy219 + dfcEF$dummy220 + 
                     dfcEF$dummy221 + dfcEF$dummy226 + dfcEF$dummy233 + dfcEF$dummy249 +
                     dfcEF$dummy255 + dfcEF$dummy269 + dfcEF$dummy270 + dfcEF$dummy281 + 
                     dfcEF$dummy282 + dfcEF$dummy403 + dfcEF$dummy404 + dfcEF$dummy417 + 
                     dfcEF$dummy418 + dfcEF$dummy437 + dfcEF$dummy482 + dfcEF$dummy483 +
                     dfcEF$dummy599 + dfcEF$dummy600 + dfcEF$dummy601 + dfcEF$dummy602 + 
                     dfcEF$dummy623 + dfcEF$dummy684 + dfcEF$dummy685 +
                     dfcEF$dummy686 + dfcEF$dummy687 -1)
summary(lm3_selfworth)

# Dieser Lösungsweg ist relativ aufwendig.


## Wesentlich schnellerer Lösungsweg:

# Der Datentyp der Variable "dfcEF$id" wird von numeric in factor umgewandelt

dfcEF$id <- as.factor(dfcEF$id)
class(dfcEF$id)

# Der Befehl lm() konvertiert Variablen im Datentyp "factor" automatisch in Dummy-Variablen.
# Wenn die Variable "dfcEF$id" somit im Datentyp "factor" codiert ist, dann berücksichtigt 
# der Befehl lm() automatisch die id-fixed effects und liefert dasselbe Ergebnis wie die
# Regression mit den Einrichtungs-Dummies. Weiterhin werden dann automatisch die
# Regressionskoeffizienten weggelassen, die in der vorherigen Regression ein "NA" lieferten.

# Ohne intercept:
lm3_selfworth <-lm(dfcEF$selfworth ~ dfcEF$treatEF + dfcEF$id - 1)
summary(lm3_selfworth)

# Mit intercept: 
lm3_selfworth <-lm(dfcEF$selfworth ~ dfcEF$treatEF + dfcEF$id)
summary(lm3_selfworth)

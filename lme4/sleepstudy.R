library(lme4)
# sleepstudy
fm1 <- lmer(Reaction ~ Days + (Days|Subject), sleepstudy)
fm1ML <- refitML(fm1)
REMLcrit(fm1)
deviance(fm1ML)
deviance(fm1,REML=FALSE)  ## FIXME: not working yet (NA)
deviance(fm1,REML=TRUE)

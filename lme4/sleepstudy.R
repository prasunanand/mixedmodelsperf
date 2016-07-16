library(lme4)
# sleepstudy
# formula
fm1 <- lmer(Reaction ~ Days + (Days|Subject), sleepstudy)
# maximum likelihood
fm1ML <- refitML(fm1)
REMLcrit(fm1)
deviance(fm1ML)
deviance(fm1,REML=FALSE)  ## FIXME: not working yet (NA)
deviance(fm1,REML=TRUE)

parsedFormula <- lFormula(formula = Reaction ~ Days + (Days | Subject), data = sleepstudy)
devianceFunction <- do.call(mkLmerDevfun, parsedFormula)

optimizerOutput <- optimizeLmer(devianceFunction)

mkMerMod( rho = environment(devianceFunction),
          opt = optimizerOutput,
          reTrms = parsedFormula$reTrms,
          fr = parsedFormula$fr
        )
library(lme4)
library(microbenchmark)

alien_species = read.csv('../examples/data/alien_species.csv')
# mixed_models expects that all variable names in the data frame are ruby Symbols:
# alien_species.vectors = Daru::Index.new(alien_species.vectors.map { |v| v.to_sym })
# alien_species.head
model_fit = LMM.from_formula(formula: "Aggression ~ Age + Species + (Age | Location)", 
                             data: alien_species)
print("Fixed effects:")
print(model_fit.fix_ef)
print("Random effects:")
print(model_fit.ran_ef)

print(model_fit.fix_ef_summary)

print(model_fit.ran_ef_summary)

print( "REML criterion used: \t#{model_fit.reml}" )
print( "Residual variance: \t#{model_fit.sigma2}" )
print( "Formula: \t" + model_fit.formula )
print( "Variance of the intercept due to 'location' (i.e. variance of b0): \t#{model_fit.sigma_mat[0,0]}" )
print( "Variance of the effect of 'age' due to 'location' (i.e. variance of b1): \t#{model_fit.sigma_mat[1,1]}" )
print( "Covariance of b0 and b1: \t#{model_fit.sigma_mat[0,1]}" )


print( "Residual standard deviation: \t#{model_fit.sigma}" )
print( "REML criterion: \t#{model_fit.deviance}" )

print( "Fitted values at the population level:" )
model_fit.fitted(with_ran_ef: false)

print( "Model residuals:" )
model_fit.residuals
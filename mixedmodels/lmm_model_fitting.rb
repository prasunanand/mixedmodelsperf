require 'daru'

alien_species = Daru::DataFrame.from_csv '../examples/data/alien_species.csv'
# mixed_models expects that all variable names in the data frame are ruby Symbols:
alien_species.vectors = Daru::Index.new(alien_species.vectors.map { |v| v.to_sym })
alien_species.head

require_relative '../ext/mixed_models/lib/mixed_models.rb'
model_fit = LMM.from_formula(formula: "Aggression ~ Age + Species + (Age | Location)", 
                             data: alien_species)
puts "Fixed effects:"
puts model_fit.fix_ef
puts "Random effects:"
puts model_fit.ran_ef

puts model_fit.fix_ef_summary

puts model_fit.ran_ef_summary

puts "REML criterion used: \t#{model_fit.reml}"
puts "Residual variance: \t#{model_fit.sigma2}"
puts "Formula: \t" + model_fit.formula
puts "Variance of the intercept due to 'location' (i.e. variance of b0): \t#{model_fit.sigma_mat[0,0]}"
puts "Variance of the effect of 'age' due to 'location' (i.e. variance of b1): \t#{model_fit.sigma_mat[1,1]}"
puts "Covariance of b0 and b1: \t#{model_fit.sigma_mat[0,1]}"


puts "Residual standard deviation: \t#{model_fit.sigma}"
puts "REML criterion: \t#{model_fit.deviance}"

puts "Fitted values at the population level:"
model_fit.fitted(with_ran_ef: false)

puts "Model residuals:"
model_fit.residuals
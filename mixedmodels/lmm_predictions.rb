require 'mixed_models'

alien_species = Daru::DataFrame.from_csv '../examples/data/alien_species.csv'
# mixed_models expects that all variable names in the data frame are ruby Symbols:
alien_species.vectors = Daru::Index.new(alien_species.vectors.map { |v| v.to_sym })

model_fit = LMM.from_formula(formula: "Aggression ~ Age + Species + (Age | Location)", 
                             data: alien_species)
model_fit.fix_ef_summary

newdata = Daru::DataFrame.from_csv '../examples/data/alien_species_newdata.csv'
newdata.vectors = Daru::Index.new(newdata.vectors.map { |v| v.to_sym })
newdata

puts "Predictions of aggression levels on a new data set:"
pred =  model_fit.predict(newdata: newdata, with_ran_ef: true)

newdata = Daru::DataFrame.from_csv '../examples/data/alien_species_newdata.csv'
newdata.vectors = Daru::Index.new(newdata.vectors.map { |v| v.to_sym })
newdata[:Predicted_Agression] = pred
newdata

puts "88% confidence intervals for the predictions:"
ci = model_fit.predict_with_intervals(newdata: newdata, level: 0.88, type: :confidence)
Daru::DataFrame.new(ci, order: [:pred, :lower88, :upper88])

puts "88% prediction intervals for the predictions:"
pi = model_fit.predict_with_intervals(newdata: newdata, level: 0.88, type: :prediction)
Daru::DataFrame.new(pi, order: [:pred, :lower88, :upper88])
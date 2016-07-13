require 'mixed_models'

alien_species = Daru::DataFrame.from_csv '../examples/data/alien_species.csv'
# mixed_models expects that all variable names in the data frame are ruby Symbols:
alien_species.vectors = Daru::Index.new(alien_species.vectors.map { |v| v.to_sym })

model_fit = LMM.from_formula(formula: "Aggression ~ Age + Species + (Age | Location)", 
                             data: alien_species)

puts "Fixed effects terms estimates and some diagnostics:"
puts model_fit.fix_ef_summary.inspect(20)
puts "Random effects correlation structure:"
puts model_fit.ran_ef_summary.inspect(12)

complex_model = LMM.from_formula(formula: "Aggression ~ Age + Species + (Age | Location)", 
                                 data: alien_species, reml: false)
simple_model = LMM.from_formula(formula: "Aggression ~ Species + (1 | Location)", 
                                data: alien_species, reml: false)

LMM.likelihood_ratio(simple_model, complex_model)

chi2_p_value = LMM.likelihood_ratio_test(simple_model, complex_model, method: :chi2)

bootstrap_p_value = LMM.likelihood_ratio_test(simple_model, complex_model, method: :bootstrap, nsim: 1000)

lrt_p_value = complex_model.fix_ef_p(variable: :Age, method: :lrt)

bootstrap_p_value = complex_model.fix_ef_p(variable: :Age, method: :bootstrap, nsim: 1000)

model_fit.fix_ef_sd

model_fit.fix_ef_z

model_fit.fix_ef_p(method: :wald)

bootstrap_t_intervals = model_fit.fix_ef_conf_int(level: 0.98, method: :bootstrap, 
                                                  boottype: :studentized, nsim: 1000)

conf_int = model_fit.fix_ef_conf_int(level: 0.9, method: :wald)

df = Daru::DataFrame.rows(conf_int.values, order: [:lower90, :upper90], index: model_fit.fix_ef_names)
df[:coef] = model_fit.fix_ef.values
df

ci = model_fit.fix_ef_conf_int(method: :all, nsim: 1000)

complex_model.ran_ef_p(variable: :intercept, grouping: :Location, method: :lrt)

complex_model.ran_ef_p(variable: :Age, grouping: :Location, method: :bootstrap, nsim: 1000)
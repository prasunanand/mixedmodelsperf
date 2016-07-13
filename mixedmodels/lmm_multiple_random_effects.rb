require 'mixed_models'
# we pass `headers: true` to `#from_csv`, because
# mixed_models expects that all variable names in the data frame are ruby Symbols
df = Daru::DataFrame.from_csv "../spec/data/crossed_effects_data.csv", headers: true
df.head 5

mod = LMM.from_formula(formula: "y ~ x + (x|g) + (x|h)", data: df, reml: false)
mod.ran_ef_summary

p_value = mod.fix_ef_p(variable: :x, method: :bootstrap, nsim: 1000)

alternative_p_value = mod.fix_ef_p(variable: :x, method: :lrt)

df = Daru::DataFrame.from_csv("../spec/data/nested_effects_with_slope_data.csv", headers: true)
df.head 5

mod = LMM.from_formula(formula: "y ~ x + (1|a) + (1|a:b)", data: df, reml: false)
mod.ran_ef_summary

p_val = mod.ran_ef_p(variable: :intercept, grouping: [:a, :b], method: :lrt)

p_val_boot = mod.ran_ef_p(variable: :intercept, grouping: [:a, :b], 
                           method: :bootstrap, nsim: 1000)
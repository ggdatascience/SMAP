# SMAP - Small area estimation for policy makers

Delen van dit script mogen gekopieerd worden voor eigen gebruik onder vermelding van de auteur en een referentie naar het SMAP artikel:

Estimating the prevalence of 26 health-related indicators at neighbourhood level in the Netherlands using structured additive regression. Van de Kassteele J, Zwakhals L, Breugelmans O, Ameling C, Van den Brink C. *International Journal of Health Geographics*, 2017, **16**(1), 23. https://ij-healthgeographics.biomedcentral.com/articles/10.1186/s12942-017-0097-5

## Background

Local policy makers increasingly need information on health-related indicators at smaller geographic levels like districts or neighbourhoods. Although more large data sources have become available, direct estimates of the prevalence of a health-related indicator cannot be produced for neighbourhoods for which only small samples or no samples are available. Small area estimation provides a solution, but unit-level models for binary-valued outcomes that can handle both non-linear effects of the predictors and spatially correlated random effects in a unified framework are rarely encountered.

## Methods

We used data on 26 binary-valued health-related indicators collected on 387,195 persons in the Netherlands. We associated the health-related indicators at the individual level with a set of 12 predictors obtained from national registry data. We formulated a structured additive regression model for small area estimation. The model captured potential non-linear relations between the predictors and the outcome through additive terms in a functional form using penalized splines and included a term that accounted for spatially correlated heterogeneity between neighbourhoods. The registry data were used to predict individual outcomes which in turn are aggregated into higher geographical levels, i.e. neighbourhoods. We validated our method by comparing the estimated prevalences with observed prevalences at the individual level and by comparing the estimated prevalences with direct estimates obtained by weighting methods at municipality level.

## Results

We estimated the prevalence of the 26 health-related indicators for 415 municipalities, 2599 districts and 11,432 neighbourhoods in the Netherlands. We illustrate our method on overweight data and show that there are distinct geographic patterns in the overweight prevalence. Calibration plots show that the estimated prevalences agree very well with observed prevalences at the individual level. The estimated prevalences agree reasonably well with the direct estimates at the municipal level.

## Conclusions

Structured additive regression is a useful tool to provide small area estimates in a unified framework. We are able to produce valid nationwide small area estimates of 26 health-related indicators at neighbourhood level in the Netherlands. The results can be used for local policy makers to make appropriate health policy decisions.

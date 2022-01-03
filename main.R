library('dplyr')
library('tidyverse')

source('selectors.R')
source('plotters.R')


variants <- c('D614G',
              'B.1.1.7',
              'B.1.351',
              'B.1.617.2')


# Computes Omicron IC50 titres by dividing  Delta  IC50 titres, for dose 1 or 2, by delta_drop
# Computes % of Omicron below each lod.
# Boosted (3rd dose) Omicron titres can obtained
runTitresVsAgeOmicron <- function(lods = c(10, 20), delta_drop = 20,
                                  booster_increase_folds = 1, dose = 2,
                                  variant =  'B.1.617.2',
                                  vaccine = 'Comirnaty') {


  delta_drop <- delta_drop / booster_increase_folds
  titres <- getVariantTitres(vaccine = vaccine, zero_prior_covid = F) %>% filter(Dose == dose)
  titres <- titres[(!is.na(titres[(variant )])),]
  delta <- columnToRealVector(titres[(variant)])

  fil <- function(x, lod, replace = 5) {
    if (x < lod) { replace } else { x }
  }

  omicron <- delta / delta_drop
  df <- tibble(
    Age = titres$Age
  )
  for (lod in lods) {
    column <-paste0('LOD: ', lod)
    df[(column)] <- sapply(omicron, fil, lod = lod, replace = min(5, lod))

  }
  plotDeltaOmicronVsAges(df, vaccine = vaccine)
}


#
runPercentsBelowLODs <- function(lods = c(1, 4, 10, 20, 40), delta_drop = 20, booster_increase_folds = 1, dose = 2,
                                 variant =  'B.1.617.2',
                                 vaccine = 'Comirnaty') {

  delta_drop <- delta_drop / booster_increase_folds
  titres <- getVariantTitres(vaccine = vaccine, zero_prior_covid = F) %>% filter(Dose == dose)

  percentsBelow <- function(vector, lods) {
    count <- length(vector)
    ans <- NULL
    for (lod in lods) {
      prob <- length(vector[vector < lod]) / count
      ans <- rbind(ans, prob)
    }
    c(ans)
  }




  delta <- columnToRealVector(titres[(variant)])
  omicron <- delta / delta_drop
  counts_omicron <- round(100 * percentsBelow(omicron, lods))

  probs <- tibble(LOD = lods,
                  Percent = counts_omicron)

  plotOmicronTitresHistogramLOD(titres_df = titres, omi_percent = probs, drop_2 = delta_drop, variant = variant,
                                vaccine = vaccine)

  probs

}


# Comirnaty. Default: Delta.
runPercentsBelowLODs(delta_drop = 20)
runPercentsBelowLODs(delta_drop = 20, variant = 'B.1.1.7')
runTitresVsAgeOmicron(delta_drop = 20)
runTitresVsAgeOmicron(delta_drop = 20, variant = 'B.1.1.7')

# Vaxzevria
runPercentsBelowLODs(delta_drop = 20,  vaccine = 'Vaxzevria')
runPercentsBelowLODs(delta_drop = 20,  vaccine = 'Vaxzevria', variant = 'B.1.351')
runTitresVsAgeOmicron(delta_drop = 20, vaccine = 'Vaxzevria')


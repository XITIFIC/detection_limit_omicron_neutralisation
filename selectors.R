library('tidyverse')
library('stringr')
library('DescTools')
library('xtable')



#(OS dependent?)
current_dir <- getwd()
data_path <- paste0(current_dir, '/datafiles/')


columnToRealVector <- function(column) {
  r <- as.numeric(unlist(column))
  r[(!is.na(r))]
}





readFile <- function(fileName) {
  file <- paste0(data_path, fileName, '.csv')
  df <- as_tibble(read.csv(file))
  df %>% mutate(across(where(is.character), str_trim))
}

greekVariantNames <- function(variants) {
  ans <- rep(NA, length(variants))

  for (k in seq_len(length(variants))) {
    variant <- variants[k]

    ans[k] <- switch(variant,
                     'B.1.617.2' = 'DELTA',
                     'B.1.1.7' = 'ALPHA',
                     'B.1.351' = 'BETA',
                     'WildType' = 'WILD TYPE',
                     'D614G' = 'D614G',
                     'P.1' = 'GAMMA',
                     variant
    )
  }
  ans
}



#  Comirnaty vaccine
getVariantTitres <- function(zero_prior_covid = F, above_age = 0, vaccine = 'Comirnaty') {

  file <- if(vaccine == 'Comirnaty'){
    'Crick_Comirnaty'
  } else {
    'Crick_Vaxzevria'
  }
  df <- readFile(file)%>% filter(sampleOrderInVaccStatus == 1)


  guessAge <- function(ageBand) {
    as.numeric(substr(ageBand, 1, 2)) + 2
  }




  ages <- guessAge(df$ageRange_by5)


  r <- tibble(
    Vaccine = 'Comirnaty',
    Dose = df$COVID_vaccStatus,
    DoseInterval = df$COVID_daysBetweenJabs,
    Site = df$site,
    Age = ages,
    WildType = df$Wildtype_ic50,
    D614G = df$D614G_ic50,
    B.1.1.7 = df$B.1.1.7_ic50,
    B.1.351 = df$B.1.351_ic50,
    B.1.617.2 = df$B.1.617.2_ic50,
    Participant_ID = df$bc_participant_id,
    Prior_Covid = df$COVID_symptoms

  ) %>% filter(Age >= above_age)




  if (zero_prior_covid) {
    r %>% filter(Prior_Covid == 0)
  } else { r }

}













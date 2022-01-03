# detection_limit_omicron_neutralisation
Code and data for exploring limits of detection (LOD) in Omicron neutralisation studies. (LOD is the lowest antibody titre in the study.) 

## Data sources
The neutralisation data are from the Crick/UCLH Legacy study with Pfizer-BioNTech Comirnaty and Oxford-AstraZeneca Vaxzevria vaccines. 
Crick_Comirnaty.csv sourced from 
https://github.com/davidlvb/Crick-UCLH-Legacy-AZ-VOCs-2021-06/blob/main/Crick_Legacy_2021-24-05_B-1-617-2_PUBLIC.Rda

"Neutralising antibody activity against SARS-CoV-2 VOCs B.1.617.2 and B.1.351 by BNT162b2 vaccination."

Wall EC, Wu M, Harvey R, Kelly G, Warchal S, Sawyer C, Daniels R, Hobson P, Hatipoglu E, Ngai Y, Hussain S, Nicod J, Goldstone R, Ambrose K, Hindmarsh S, Beale R, Riddell A, Gamblin S, Howell M, Kassiotis G, Libri V, Williams B, Swanton C, Gandhi S, Bauer DLV. Lancet. 2021 Jun 19;397(10292):2331-2333. doi: 10.1016/S0140-6736(21)01290-3. Epub 2021 Jun 3. PMID: 34090624; PMCID: PMC8175044.


Crick_Vaxzevria.csv sourced from 
https://github.com/davidlvb/Crick-UCLH-Legacy-AZ-VOCs-2021-06/blob/main/Crick_Legacy_2021-24-05_B-1-617-2_PUBLIC.Rda

" AZD1222-induced neutralising antibody activity against SARS-CoV-2 Delta VOC."

Wall EC, Wu M, Harvey R, Kelly G, Warchal S, Sawyer C, Daniels R, Adams L, Hobson P, Hatipoglu E, Ngai Y, Hussain S, Ambrose K, Hindmarsh S, Beale R, Riddell A, Gamblin S, Howell M, Kassiotis G, Libri V, Williams B, Swanton C, Gandhi S, Bauer DL.Lancet. 2021 Jul 17;398(10296):207-209. doi: 10.1016/S0140-6736(21)01462-8. Epub 2021 Jun 28. PMID: 34197809; PMCID: PMC8238446.

## Usage
Runs from the main.R file. 

NB The code was developed and tested on MacOS in Pycharm R-plugin. 
The function showInChrome() in plotters.R shows plots as tabs in a Chrome browser window. It is  Mac and Chrome specific. 
If necessary, change this function or write fig instead of showInChrome(fig) in the plotting functions. 




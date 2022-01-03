library('tidyverse')
library('plotly')
library('dplyr')
library('plyr')

source('selectors.R')

blue <- '#1f77b4'
red <- '#d62728'
green <- '#2ca02c'
purple <- '#9467bd'
black <- '#000000'
pink <- '#e377c2'
blueLight <- '#56B4E9'
grey <- '#BCBCBC'
greyMedium <- '#808080'
orange <- "#E69F00"

# HELPER FUNCTIONS
# works for macos with a chrome browser. Tested in Catalina, Monterey + zsh
showInChrome <- function(widget, showFigure = T) {
  if (!showFigure) {
    return()
  }
  # Generate random file name
  temp <- paste(tempfile('plotly'), 'html', sep = '.')
  # Save.
  htmlwidgets::saveWidget(widget, temp, selfcontained = FALSE)
  # Show in chrome
  system(sprintf("open -a 'google chrome'  /%s", temp))

}





plotOmicronTitresHistogramLOD <- function(titres_df, omi_percent, drop_2, variant, vaccine) {


  local <- function(fig, variant, title, colour = blueLight, fold_drop = 1, arrow_x = NULL, arrow_label = NULL) {
    data <- columnToRealVector(titres_df[(variant)])
    gmean <- log10(Gmean(data, method = 'classic') / fold_drop)


    bin_start <- min(log10(data) - log10(fold_drop))
    gmt_label <- round(10^gmean, 1)

    title_y <- 0.25

    fig <- fig %>%
      add_histogram(x = log10(data) - log10(fold_drop), type = 'histogram', name = title, marker=list(color=colour),
                histnorm = "probability", xbins = list(size = 0.1, start = bin_start))

    if (title[1] == "OMICRON") {

      for (k in seq_len(nrow(omi_percent))) {
        row <- omi_percent[k,]
        x <- log10(row$LOD)
        percent <- paste0(row$Percent, '\U200A', '%')
        fig <- fig %>%
          add_trace(x = x, y = c(0, title_y - 0.01), name = 'Qualitative Threshold', type = 'scatter', mode = 'lines',
                    line = list(color = black, width = 2, dash = 'dot')) %>%
          add_annotations(x = x,
                          y = -0.01,
                          text = row$LOD,
                          showarrow = F,
                          textposition = "right center") %>%
          add_annotations(x = x - 0.05,
                          y = title_y - 0.02,
                          text = percent,
                          showarrow = F,
                          textposition = "top center")

      }


    }


    fig <- fig %>%
      add_trace(x = gmean, y = 0, name = 'GMT', type = 'scatter', mode = 'markers', marker = list(color = black,
                                                                                                  size = 11),
                showlegend = F) %>%
      add_annotations(x = gmean,
                      y = title_y,
                      text = title,
                      showarrow = FALSE,
                      textposition = "top left") %>%
      add_annotations(x = gmean,
                      y = -0.0056,
                      text = gmt_label,
                      showarrow = FALSE,
                      textposition = "top left")

    if (!is.null(arrow_x))
    { fig <- fig %>%
      add_trace(x = arrow_x, y = title_y, name = 'GMT', type = 'scatter', mode = 'markers',
                marker = list(color = colour,
                              symbol = 'triangle-left',
                              size = 24)) %>%
      add_annotations(x = arrow_x + 0.1,
                      y = title_y,
                      text = arrow_label,
                      showarrow = F,
                      font = list(size = 15),
                      textposition = "top center")
    }

    fig

  }


  gmt_delta <- log10(Gmean(columnToRealVector(titres_df[(variant)])))

  fold_label <- if(is.integer(drop_2)){
    paste0(drop_2, 'x')
  } else {
    paste0(round(drop_2,1), 'x')
  }

  title <- paste0(toupper(vaccine), ': Omicron Log IC50, % Below LOD')
  fig <- plot_ly(alpha = 0.6) %>%
    local(variant = variant, title = 'OMICRON', fold_drop = drop_2, colour = grey) %>%

    local(variant = variant, title = greekVariantNames(variant), colour = blue, arrow_x = gmt_delta - log10(sqrt(drop_2)) + 0.1, arrow_label = fold_label) %>%
    layout(barmode = "overlay", title=title,
           showlegend = F, xaxis = list(showticklabels = F, showgrid = F), yaxis = list(showticklabels = F, showgrid = F))

  showInChrome(fig)

}

# maximum three plots
plotDeltaOmicronVsAges <- function(df, vaccine) {
  titres <- select(df, -Age)


  local <- function(col) {
    vals <- columnToRealVector(col)
    fig <- plot_ly() %>%
      add_trace(x = df$Age, y = vals, type = 'scatter', name = colnames(col), mode = 'markers',
                marker=list(size=10)) %>%
      layout(xaxis = list(title = 'Age', showline = T, showgrid = F),
             yaxis = list(showticklabels = F, type = 'log', title = 'Log Titre', showgrid = F),
             showlegend = FALSE) %>%
      add_text(x= 20, y = 30, text = colnames(col))

  }

  count <- min(3, ncol(titres))
  if (count == 1) {
    fig <- local(titres[, 1])

  }
  if (count == 2) {
    fig <- subplot(
      local(titres[, 1]),
      local(titres[, 2]),
      nrows = 2)

  }
  if (count == 3) {
    fig <- subplot(
      local(titres[, 1]),
      local(titres[, 2]),
      local(titres[, 3]),
      nrows = 3)

  }

    title <- paste0(toupper(vaccine), ': Omicron Log IC50 vs Age')
 fig <- fig %>% layout(title=title)

  showInChrome(fig)
}



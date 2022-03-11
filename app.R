library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(ggplot2)
library(plotly)
library(dplyr)
library(tidyverse)

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

movie <- read.csv('data/movies_clean_df.csv') %>% 
  setNames(c("Index", "Title", "Major_Genre","Duration","Year", "US_Revenue",
             "IMDB_Rating", "MPAA_Rating"))

genre <- unique(movie$Major_Genre)

default_genres <- c("Action", "Adventure", "Comedy", "Drama", "Horror", "Romantic Comedy")

app$layout(
  dbcContainer(
    list(
      dccGraph(id='plot-area'),
      htmlBr(),
      htmlLabel('Year'),
      dccRangeSlider(
        id='year_range',
        step = 1,
        min = 1980,
        max = 2016,
        marks = list("1980"="1980", "2016"="2016"),
        value = list(1990, 2005)
      ),
      htmlBr(),
      htmlBr(),
      htmlLabel('Genre'),
      dccChecklist(
        id="genre_checklist",                    
        className="genre-container",
        inputClassName="genre-input",
        labelClassName="genre-label",
        options=genre,                        
        value=default_genres)
    )
  )
)

app$callback(
  output('plot-area', 'figure'),
  list(input('year_range', 'value'),
       input('genre_checklist', 'value')),
  
  function(year, genre) {
    p <- movie %>% 
      filter(Year >= year[1] & Year <= year[2], Major_Genre %in% genre) %>%
      group_by(Major_Genre) %>%
      summarise(US_Revenue = sum(US_Revenue)) %>%
      ggplot(aes(x = US_Revenue, 
                 y = reorder(Major_Genre, desc(Major_Genre)),
                 fill = Major_Genre)) +
      geom_bar(stat = "identity") +
      xlab ("Gross Revenue (in millions USD)") +
      ylab("Major genre") +
      ggtitle("Gross revenue (box office) by genre")
    p <- p + theme(legend.position="none")
    ggplotly(p)
  }
)

app$run_server(host = '0.0.0.0')
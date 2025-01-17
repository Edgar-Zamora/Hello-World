``` r
library(tidyverse)
library(janitor)
library(ggtext)

#load data
epl18_19 <- read_csv("2018-2019.csv") %>% 
  clean_names()

#https://datahub.io/sports-data/english-premier-league
```

``` r
#clean data
epl18_19 <- epl18_19 %>% 
  select(home_team, away_team, fthg, ftag, htag, hthg) %>% 
  mutate(total_goals = fthg + ftag,
         result = as.factor(case_when(fthg > ftag ~ 1,
                                      fthg == ftag ~ 0,
                                      TRUE ~ -1))) %>% 
  mutate_at(c("home_team", "away_team"), ~as.factor(.))


#Create table with club abbrivations
abr_names <- tibble(
  away_team = factor(c("Arsenal", "Bournemouth", "Brighton", "Burnley", "Cardiff",
                       "Chelsea", "Crystal Palace", "Everton", "Fulham", "Huddersfield",
                       "Leicester", "Liverpool","Man City", "Man United", "Newcastle", "Southampton",
                       "Tottenham", "Watford", "West Ham", "Wolves")),
  away_team_abr = factor(c("ARS", "BOU", "BHA", "BUR", "CAR", "CHE", "CRY", "EVE",
                           "FUL", "HUD", "LEI", "LIV", "MCI", "MUN", "NEW", "SOU",
                           "TOT", "WAT", "WHU", "WOL"),
                         levels = c("ARS", "BOU", "BHA", "BUR", "CAR", "CHE", "CRY", "EVE",
                                    "FUL", "HUD", "LEI", "LIV", "MCI", "MUN", "NEW", "SOU",
                                    "TOT", "WAT", "WHU", "WOL")))
```

``` r
epl18_19 %>% 
  left_join(abr_names) %>% 
  ggplot(aes(away_team_abr, fct_rev(home_team), fill = result)) +
  geom_tile(show.legend = FALSE) +
  geom_text(aes(label = paste0(fthg, "-", ftag))) +
  scale_fill_manual(name = "title",
                    values = c("#FCBBBB", "#FFFFBB", "#BBF3FF")) +
  labs(
    x = "",
    y = "",
    title = "2018-19 Premier Leauge Results Matrix",
    caption = "Colour: 
    <br> <span style = 'color:#BBF3FF;'>Blue =</span> Home team win 
    <br> <span style = 'color:#FCBBBB;'>Red  =</span> Away team win
    <br> <span style = 'color:#FFFFBB;'>Yellow  =</span> Tie"
      ) +
  scale_x_discrete(position = "top") +
  scale_y_discrete(labels = rev(c("Aresenal", "Bournemouth", "Brighton & Hove Albion", "Burnley", "Cardiff", "Chelsea",
                                  "Crystal Palace", "Everton", "Fulham", "Huddersfield Town", "Leicester City",
                                  "Liverpool", "Manchester City", "Manchester United", "Newcastle United", "Southampton",
                                  "Tottenham Hotspur", "Watford", "West Ham United", "Wolverhampton Wanderers"))) +
  theme(
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    plot.caption = element_markdown(hjust = 0)) 
```

    ## Joining, by = "away_team"

![](README_files/figure-markdown_github/viz-1.png)

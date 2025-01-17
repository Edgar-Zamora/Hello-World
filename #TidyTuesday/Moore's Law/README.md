What the f%\>%k is Moore’s Law?
===============================

Moore’s Law refers to a perception that was first formulated by Gordon
Moore who believed that “the number of transistors on a microchip
doubles every two years, though the cost of computers is halved”[1].
With that in mind, there were a multitude of different ways one could
analyze this perception to decide whether it was true or if it was
lacking in credibility.

Creating the visualization
==========================

As is customary when discussing R analysis, I have provided the
necessary packages to replicate my visualization.

``` r
library(tidyverse)
library(scales)
library(grid)
library(ggimage)
library(knitr)
library(extrafont)
```

The data for Moore’s Law can be found on the tidytuesday
[GitHub](https://github.com/rfordatascience/tidytuesday/tree/master/data/2019/2019-09-03).

``` r
cpu <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-03/cpu.csv")
```

Fonts in R visualizations
=========================

You should know that I used a **MacBook Pro** to load fonts. I am unsure
about how this would work on machines but I assume it would work in a
similar fashion. To view and load different fonts into R, you will need
to install and load the `extrafont` package. The primary function within
this package that you will be using is the `font_import()` function.
Running this function will import all fonts that are currently available
on your machine. In addition to the default fonts on your machine, you
are also able to bring in additional fonts. If you have added a font
manually, you can bring load it by using the `font_import()` with the
specific font name as an argument like so: `font_import("my_new_font")`.
For more detail regarding the package I encourage you to check out the
GitHub [documentation](https://github.com/wch/extrafont).

``` r
#Importing Fonts
#font_import()      #imports fonts onto your machine
#fonttable()       #this function allows you to see all the fonts currently available
```

Adding a background
===================

To add a background to any visualization is very easy with the `ggimage`
package. The primary function that will be used to add a background is
the `ggbackground()` function. There are two steps:

1.  Store your visualization to a object.
2.  Use the `ggbackground()` function to compile the image and the plot.

In the code below, I begin by building my plot. I will not be going
through each step but what I have done is build a scatter plot that
plots the date in which the CPU was build and also the area of said
transistors. Additionally, to account for the distribution in
transistors counts, I decided to `log2()` the value. After creating the
visualization to my like, I store it into an object named plot.

``` r
 plot <- cpu %>% 
  ggplot(aes(date_of_introduction, area)) +
  geom_point(aes(colour = log2(transistor_count)), size = 3.5, alpha = .8) +
  scale_color_gradient2(high = "gold") +
  scale_y_continuous(breaks = seq(0,800,100)) +
  guides(colour = guide_legend(expression('Num. Of Transistors (log'[2]*')'))) +
  theme(legend.key = element_rect(fill = "white"),
        legend.position = "bottom",
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        text = element_text(colour = "white", size = 16, family = "CourierNewPSMT"),
        plot.title = element_text(size = 25, family = "CourierNewPSMT"),
        axis.text = element_text(colour = "white", size = 11, family = "CourierNewPSMT"),
        legend.margin = margin(0,0,0,0),
        legend.box.margin = margin(-5,-5,-10,-5),
        legend.text = element_text(size = 10),
        legend.title = element_text(size = 10)) +
  labs(x = "Year Introduced",
       y = "Area of Chip (mm)",
       title = "Does A Bigger CPU Lead To More Transistors?",
       caption = "@Edgar_Zamora_")
```

Before using the `ggbackground()` you will have to have the image you
want to use in your working directory. I have not experienced
limitations in what type of files you can use for you image, but I would
recommend using .jpg, .pdf, or some other common type. The
`ggbackground()` function takes two main arguments. The first is the
object, which in this case is the first. The second is the background
image you want to use. This can be an object which has the stored image
or it can be the path name like I have it. It should look something
similar to what I have below.

``` r
TidyTuesday_plot <- ggbackground(plot, "CircuitBoard.jpg")
```

![](TidyTuesday_Circuit.jpg)

[1] <a href="https://www.investopedia.com/terms/m/mooreslaw.asp" class="uri">https://www.investopedia.com/terms/m/mooreslaw.asp</a>

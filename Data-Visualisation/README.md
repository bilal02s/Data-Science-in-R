# Data Visualisation using R

## Table of Contents
1. [Introduction](#introduction)
2. [Sections](#sections)
    * [US Gun Murders](#us-gun-murders-2010)
    * [Height analysis](#height-analysis)
    * [Life Expectancy vs Fertility Rate](#life-expectancy-vs-fertility-rate)
    * [Rich Countries vs Poor Countries](#rich-countries-vs-poor-countries)
3. [Results](#result)
    * [US Gun Murders](#us-gun-murders)
    * [Height analysis](#height-analysis-1)
    * [Life Expectancy vs Fertility Rate](#life-expectancy-vs-fertility-rate-1)
    * [Rich Countries vs Poor Countries](#rich-countries-vs-poor-countries-1)
4. [How to Run](#how-to-run)

## Introduction
This section is intended to answer some questions related to different economic and social topics. By analysing data we possess, manipulating it, and drawing some meaningful graphs, in order to make observations that will help us find the correct answers, and depict some myths in order to find the truth. <br/>
All the data used are open source and free to use, graphs are generated using **ggplot**. <br/>
The scripts generating each graph is provided in the same folder.

## Sections
1. ### US Gun Murders 2010
    1. How do states vary across population size and total number of murders?
    2. Is there any relationship between murders totals and population size?
    3. how are different regions classified with respect to the average murder rate?

2. ### Height Analysis
    1. does the height mesurement of males and females follow a certain distribution?
    2. how to prove the answer of the preceding question?

3. ### Life Expectancy vs Fertility Rate </br>
    Myth : the world is divided into two groups, the Western World, composed of western europe and north america, which is characterized by long lifespans and small families versus the developing world, Africa, Asia, and Latin America, characterized by short lifespans and large families.

4. ### Rich Countries vs Poor Countries </br>
    Myth : poor countries have become poorer and rich countries have become richer. </br>
    In order to check the validity of the previous statement, we will proceed by processing the gdp of countries to answer several intermediate questions. (gdp numbers are adjusted across the years for inflation)
    1. what is the average income distribution across countries in 1970?
    2. what countries were considered rich? and what countries were considered poor?
    3. how has the average income varied across time?
    4. what countries have improved the most? what countries have improved the least?
    5. is the previous statement correct or false?
## Results
![states variation across population size and total number of murders](./images/US-Gun-Murders-2010.png)

1. ### US Gun Murders
    1. Most of the states in the west region have low population size, other regions are spread across the scale
    2. There is a positive linear relationship between population size and the murders totals
    3. Most states located in south region have murder rates above the average (which are shown by the points above the dashed line).

![Histogram](./images/HeightAnalysis.png)

2. ### Height Analysis
    1. Males height distribution follows the normal distribution. contrary to the female's that shows two modes instead of one
    2. This is proven by the fact that the point of the Q-Q plot lie on the line of slope 1 and intercept 0 for the male's data, while the female's data are shifted upward along the higher quantiles. The female's result doesn't match the expectation, the reason could be an error in the sampling phase.

![countries variation across life expectency and fertility rate](./images/Life-Expectancy-vs-Fertility-Rate.png)
    
3. ### Life Expectancy vs Fertility Rate
    1. the graph clearly shows that the previous statement holds in the past but the circumstances are changing, and no longer holds in the present time. which proven by the fact that most asian and african countries are shifting to the top left of the graph which is the region of low fertility rate and high life expectency.

![Rich vs poor](./images/Rich-vs-Poor1.png) ![rich vs poor](./images/Rich-vs-Poor2.png) ![rich vs poor](./images/Rich-vs-Poor3.png) ![rich vs poor](./images/Rich-vs-Poor4.png)

4. ### Rich Countries vs Poor Countries
    1. the first histogram shows that a bimodal distriubiton of the average income across country, with the first mode at around 2$ and the second mode at 32$, which indicate indeed the presence of distinct rich and poor countries in 1970.
    2. we can determine the rich and poor country by examining the plot 2, rich countries are concentrated in europe, north america, australia and new zealand (having a median above 32$), while the poor countries makes up the rest of the world.
    3. by looking at the plot 3 we can see a shift toward to the right (increase in average income) for both west and developing countries by 2010, although the shift is larger, concern more developing countries than the west.
    4.the plot 4 shows the ratio of average income between 1970 and 2010, sorted to right from the highest to lowest. We can deduce that asian and some african countries have made more improvement toward their average income than the rich countries denoted by the west (Europe, north America, Australia and New Zealand).
    5. we can conclude from the preceding observation that although rich countries have improved and became richer, developing countries have made even more efforts to their improvement that could be considered even greater than the west countries.

## How to Run
In order to run all the script to generate the graphs used in this report, you have to install R if you don't have it already from [this website](https://cran.r-project.org/bin/windows/base/) if you are on windows, or by executing the following command if you are using an ubuntu software:
```bash
    sudo apt install r-base-core
```
If you don't already have the necessary packages and dependencies to run the scripts please consider downloading them.
* Required dependencies:
    1. dplyr
    2. dslabs
    3. ggplot2
    3. gridExtra
    4. ggrepel
    5. ggthemes

In order to install all of them, you can execute the following commands from the terminal:
* The following command will open an R session
```bash
    R
```
* After that execute the commands one by one
```bash
    install.packages("dplyr")
    install.packages("dslabs")
    install.packages("ggplot2")
    install.packages("gridExtra")
    install.packages("ggrepel")
    install.packages("ggthemes")
```
* After installing all the required package, close the R session:
```bash
    quit()
```
* Finally we can run the scripts:
```bash
    Rscript Height-Analysis.R
    Rscript Life-Expectancy-vs-Fertility-Rate.R
    Rscript Rich-vs-Poor.R
    Rscript US-Gun-Murders.R
```
Running the scripts all at once will cause one script to override the pdf plot file generated by the previous script, make sure to run them one by one, and retrieving the plot afterward.
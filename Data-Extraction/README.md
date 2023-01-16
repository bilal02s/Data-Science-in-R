# Data Scraping

## Table of Contents
1. [Introduction](#introduction)
2. [Sections](#sections)
    * [US Murders Data](#us-murders-data)
    * [Heights Data](#heights-data)
3. [How to Run](#how-to-run)

## Introduction
Data scraping is a way to obtain data and tidy it to be used later in machine learning tasks or visualisation. <br/>
In this section we show how to extract such data, and generate the dataframe file corresponding to it

## Sections

### US Murders Data
The data is extracted into a dataframe from a wikipedia page that has the data inside html tables.
The numbers are parsed as well as the abbreviation of the states are added to the data. And finally the rda file is generated to be used in the data visualisation [US gun murders analysis](../Data-Visualisation/README.md#us-gun-murders) section.

### Heights Data
The data is obtained from the dslabs package, in a raw format. The goal is to tidy this data so that it can be analysed easly. To start we see that the data are made up of string containing height inputs from users in the imperial system, the data is analysed by using regular expressions to extract the desired information and converted to metric system. (because some input contains comas/spaces, some of them explicitly contains words like inches and feet/ft, and some have spelled the numbers) <br/>
The data is then used to visualise [the heights of males and females](../Data-Visualisation/README.md#height-analysis-1).

## How to Run
If you don't already have R installed please install it from [this website](https://cran.r-project.org/bin/windows/base/) if you are on windows, or by executing the following command if you are using an ubuntu software:
```bash
    sudo apt install r-base-core
```
If you don't already have the necessary packages and dependencies to run the scripts please consider downloading them.
* Dependencies for US Murders Data:
    1. dplyr
    2. readr
    3. rvest
* Dependencies for Heights Data:
    1. dslabs
    2. dplyr
    3. tidyr
    4. stringr

In order to install all of them, you can execute the following commands from the terminal:
* The following command will open an R session.
```bash
    R
```
* After that execute the commands one by one. 
```bash
    install.packages("dplyr")
    install.packages("dslabs")
    install.packages("readr")
    install.packages("rvest")
    install.packages("tidyr")
    install.packages("stringr")
```
* After installing all the required package, close the R session:
```bash
    quit()
```
* Finally we can run the scripts:
```bash
    Rscript extracting-heights-data.R
    Rscript scraping-murders-data.R
```
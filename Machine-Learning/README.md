# Machine Learning

## Table of Contents
1. [Introduction](#introduction)
2. [Certificate](#certificate)
3. [Sections](#sections)
    * [Titanic Survival Predictions](#titanic-survival-predictions)
    * [Mnist hand written digits recognition](#mnist-hand-written-digits-recognition)
    * [Recommendation System](#recommendation-system)
4. [How to Run](#how-to-run)

## Introduction
In this section, we have used machine learning to solve several tasks that required predictions.

## Certificate
1. [PH125.8x: Data Science: Machine Learning](https://courses.edx.org/certificates/7329dcdd665b42adaf2b779b6e3ee7a3)

## Sections

### Titanic Survival Predictions
The goal of this section is to be able to predict which passengers is more likely to have survived based on the information at our disposal such as his sex, the class of this ticket, the price he paid for, as well as other predictors that we obtained from the titanic package. <br/>
#### **Conclusions** <br/>
(Note : Running the appropriate script, Titanic-Survival-Prediction.R [see below](#how-to-run), will print out a report of the analysis that has been done)
* The sex is the strongest predictor, female passengers were more likely to survive than males
* The passenger's class is the second strongest predictor, first class passengers were more likely to survive.
* For males, Age played a huge role, since children were the most passengers rescued.
* Three machine learning models were used on all predictors : logistic regression, k-nearest-neighbours, decision tree. The logistic regression gave the highest accuracy.

### MNIST hand written digits recognition
The goal is to predict the hand written digit from the data collected by MNIST. <br/>
Executing the corresponding script, mnist.R, will do the following steps:
* Retireve the mnist dataset
* Create a training set and a test set
* train a k-nearest-neighbour model and a ramdon forest model on the training set
* combine the predictions from both models on the test set
* construct a confusion matrix and print out the corresponding table prediction

### Recommendation System
We will attempt to create a model that will predict a rating on a given movie for a given user, based on the data we have, which are the previous ratings of user to several movies.
The approach we make is similar to the approach done by the winners of the netflix 1 million$ prize competition.<br/>
The goal is to have a residual mean squared error inferior to 0.9

#### Explanation
we will consider that a rating from a user to a movie is composed of several component as follow :

```bash
    Y = mu + bi + bu + sigma
```

Where :
* mu : is the average of the ratings from all users to all the movies
* bi : a value corresponding to the movie's unique effect
* bu : a value corresponding to the user's unique effect
* sigma : random variability having a mean of 0 and low standard deviation

1. The movie's unique effect manifest in the case where a certain movie is successfull and tends to be rated higher than average, or the opposite case if a movie tends to be rated lower than average.
2. The user's unique effect manifest in the user having a certain character trait, some users might be too harsh when rating a movie, some of them might like all movie they watch even if some of them are bad.
3. Supposing a great movie which is rated above average, thus having a positive bi, is being rated by a user who is known to be harsh, thus having a negative bu, then the bi and bu will cancel out and we will be predicting an average rating.

The script, Recommendation-System.R, impements such a model and calculates and values mu, bi and bu from the training set. And then calculates the residual mean squared error of the model on a test set and prints it out to the terminal.

## How to Run
If you don't already have R installed please install it from [this website](https://cran.r-project.org/bin/windows/base/) if you are on windows, or by executing the following command if you are using an ubuntu software:
```bash
    sudo apt install r-base-core
```
If you don't already have the necessary packages and dependencies to run the scripts please consider downloading them.
* Dependencies for US Murders Data:
    1. dplyr
    2. dslabs
    3. titanic
    4. caret
    5. rpart
    6. Rborist


In order to install all of them, you can execute the following commands from the terminal:
* The following command will open an R session.
```bash
    R
```
* After that execute the commands one by one. 
```bash
    install.packages("dplyr")
    install.packages("dslabs")
    install.packages("titanic")
    install.packages("caret")
    install.packages("rpart")
    install.packages("Rborist")
```
* After installing all the required package, close the R session:
```bash
    quit()
```
* Finally we can run the scripts:
```bash
    Rscript Titanic-Survival-Prediction.R
    Rscript mnist.r
    Rscript Recommendation-System.r
```

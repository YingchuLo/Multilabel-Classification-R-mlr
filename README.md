# Multilabel Classification
R language
Package: mlr,OpenML,farff,readr
Dataset: scene
         - X(numerical): variable 1 ~ 294
         - Y(6labels): "Beach", "Sunset", "FallFoliage", "Field", "Mountain", "Urban"
Fun fact: Use predicted labels as features for other labels
Take a multilabel classification as an example.
If label 1 and label 2 are highly correlated, it may be beneficial to predict label 1 first and use this prediction as a feature for predicting label 2.

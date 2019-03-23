library(mlr)
library(OpenML)
library(farff)
library(readr)
#1) Introduction to multilabel classification
setOMLConfig(apikey = "c1994bdb7ecb3c6f3c8f3b35f4b47f1f") # api key
#dataset: scene
oml.id = listOMLDataSets(tag = "2016_multilabel_r_benchmark_paper")$data.id
scene = getOMLDataSet(data.id = oml.id[8])
target = scene$target.features
feats = setdiff(colnames(scene$data), target)
head(scene$data[, c(feats[1], feats[2], target)])
#2) Let’s Train and Predict!
set.seed(1729)
target
scene.task = makeMultilabelTask(data = scene$data, target = target)
binary.learner = makeLearner("classif.rpart")
lrncc = makeMultilabelClassifierChainsWrapper(binary.learner)
n = getTaskSize(scene.task)
train.set = seq(1, n, by = 2)
test.set = seq(2, n, by = 2)
head(scene)
scene.mod.cc = train(lrncc, scene.task, subset = train.set)
scene.pred.cc = predict(scene.mod.cc, task = scene.task, subset = test.set)
listMeasures("multilabel")
performance(scene.pred.cc, measures = list(multilabel.hamloss,multilabel.subset01, multilabel.f1, multilabel.acc))
#3) Comparison Binary Relevance vs. Classifier Chains
lrnbr = makeMultilabelBinaryRelevanceWrapper(binary.learner)

scene.mod.br = train(lrnbr, scene.task, subset = train.set)
scene.pred.br = predict(scene.mod.br, task = scene.task, subset = test.set)

performance(scene.pred.br, measures = list(multilabel.hamloss, 
                                           multilabel.subset01, multilabel.f1, multilabel.acc))
#4) Resampling
rdesc = makeResampleDesc("Subsample", iters = 10, split = 2/3)
r = resample(lrncc, scene.task, rdesc, measures = multilabel.subset01)
r
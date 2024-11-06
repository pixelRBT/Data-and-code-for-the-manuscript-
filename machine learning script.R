library(mlr3)
library(mlr3learners)
library(mlr3extralearners)
library(mlr3viz)
library(iml)
library(beepr)
library(parallel)
#use multisession to increase the calcuation efficiency
future::plan('multisession',workers=detectCores()/2)

#a small function for illustrating the calculation progress
ProgressBar=function(n=100,i)
{
  pb=txtProgressBar(min=0,max = n,style = 3)
  setTxtProgressBar(pb,i)
}

#set random seeds
set.seed(395)
seeds=round(runif(10,max = 300))

#predict sqrtBOE from data quality
predictions=list()

for (i in 1:length(newdat)) {
  pre=matrix(NA,nrow(newdat[[i]]),300)
  
  for (n in 1:length(seeds)) {
    
    set.seed(seeds[n])
    
    #run the benchmark
    bmr=benchmark(designs[[i]],store_models = T)
    
    writeLines(paste('The benchmark of model ',n,'is complete.'))
    
    #collect the best results
    rr=bmr$resample_result(1)
    
    #prediction
    writeLines(paste('Start the',n,'time of prediction.'))
    
    for (j in 1:30) {
      t=rr$learners[[j]]$predict_newdata(newdat[[i]],task=rr$task)
      pre[,(n-1)*30+j]=t$response
      ProgressBar(30,j)
    }
    writeLines('')
    writeLines(paste('The',n,'time of prediction complete.'))
  }
  predictions=append(predictions,list(pre))
}

#summarize the prediction results
prediction_summary=list()
for (i in 1:length(predictions)) {
  pres=c()
  sds=c()
  for (j in 1:nrow(predictions[[i]])) {
    pres=c(pres,mean(t(predictions[[i]][j,])))
    sds=c(sds,sd(t(predictions[[i]][j,])))
  }
  prediction_summary=append(prediction_summary,list(data.frame(pres,sds)))
}

#creating the random sources
delta_2H=seq(-121.92,-39.89,length.out=1000)
sd_2H=seq(0.43,1.02,length.out=1000)
delta_18O=seq(-16.6,-6.37,length.out=1000)
sd_18O=seq(0.04,0.11,length.out=1000)

set.seed(200)
delta_2H_sampled=sample(delta_2H,10)
sd_2H_sampled=sample(sd_2H,10)

set.seed(300)
delta_18O_sampled=sample(delta_18O,10)
sd_18O_sampled=sample(sd_18O,10)

sources=data.frame(delta_2H_sampled,sd_2H_sampled,delta_18O_sampled,sd_18O_sampled)

#list out each source combinations
c3=t(combn(1:10,3))
c4=t(combn(1:10,4))
c5=t(combn(1:10,5))
c6=t(combn(1:10,6))
c7=t(combn(1:10,7))
cs=list(c3,c4,c5,c6,c7)
cbs=list()
for (i in 1:5) {
  cb=matrix(NA,nrow(cs[[i]]),ncol(cs[[i]])*4)
  for (m in 1:nrow(cs[[i]])) {
    for (n in 1:ncol(cs[[i]])) {
      cb[m,(n*4-3):(n*4)]=as.matrix(sources[cs[[i]][m,n],])
    }
  }
  cbs=append(cbs,list(cb))
}


#creating the p vectors
p=seq(0.05,0.7,0.05) #minimum p=0.05, maximum p=0.7, interval=0.05
ps=list()
for (n in 3:7) {  #NOS¡Ê[3,7]
  pn=matrix(0,length(p)^n,n)
  for (i in 1:n) {
    t=rep(p,each=length(p)^(i-1))
    t=rep(t,length(p)^(n-i))
    pn[,i]=t
  }
  sum2one=c()
  for (i in 1:nrow(pn)) {
    if(sum(pn[i,])==1) sum2one=c(sum2one,i)
  }
  pn=pn[sum2one,]
  ps=append(ps,list(pn))
  rm(pn)
}

#calculate the CVa and combine into ps
for (i in 1:5) {
  cva=c()
  for (j in 1:nrow(ps[[i]])) {
    cva=c(cva,sd(ps[[i]][j,])/mean(ps[[i]][j,]))
  }
  ps[[i]]=data.frame(ps[[i]],cva)
  ps[[i]]=ps[[i]][order(ps[[i]][,ncol(ps[[i]])]),]
  rm(cva)
}

#resample ps by CVa
library(dplyr)
ps_resampled=list()
for (i in 1:5) {
  ps_resampled=append(ps_resampled,list( sample_n( group_by(ps[[i]] , ps[[i]][,ncol(ps[[i]])]) , size = 1) ) )
  ps_resampled[[i]]=as.data.frame(ps_resampled[[i]][,1:(ncol(ps_resampled[[i]])-1)])
}

#create the mixing scenarios, the last two column of each element of list mixscen (stands for mixing scenarios) is the ¦Ä2H and ¦Ä18O of the mixture, respectively 
mixscen=list()
for (i in 1:5) {
  ms=matrix(NA,nrow(cbs[[i]])*nrow(ps_resampled[[i]]),ncol(cbs[[i]])+ncol(ps_resampled[[i]])+1)
  
  for (j in 1:(ncol(ps_resampled[[i]])-1)) {
    ms[,j]=rep(ps_resampled[[i]][,j],each=nrow(cbs[[i]]))
  }
  
  for (j in 1:ncol(cbs[[i]])) {
    ms[,j+ncol(ps_resampled[[i]])-1]=rep(cbs[[i]][,j],nrow(ps_resampled[[i]]))
  }
  
  mixture_2H=matrix(NA,nrow(ms),ncol(ps_resampled[[i]])-1)
  mixture_18O=mixture_2H
  
  for (j in 1:(ncol(ps_resampled[[i]])-1)) {
    mixture_2H[,j]=ms[,j]*ms[,ncol(ps_resampled[[i]])-1+j*4-3]
    mixture_18O[,j]=ms[,j]*ms[,ncol(ps_resampled[[i]])-1+j*4-1]
  }
  
  for (j in 1:nrow(ms)) {
    ms[j,ncol(ms)-1]=sum(mixture_2H[j,])
    ms[j,ncol(ms)]=sum(mixture_18O[j,])
  }
  
  mixscen=append(mixscen,list(ms))
  rm(ms)
}

#randomly resample the amount of the mixing scenarios to 500, with 100 scenarios for different NOS
set.seed(298)
mixscen_resampled=list()
for (i in 1:5) {
  mixscen_resampled=append(mixscen_resampled,list(mixscen[[i]][sample(c(1:nrow(mixscen[[i]])),100),]))
}

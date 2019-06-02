library(R.matlab)

ephysroot = '~/Downloads/STA141A/PROJECT/PROJECT_DATA/'; # path of the data set 
mstr = 'Krebs'; # mouse names
### Load saved data:
exp_data<- readMat(paste(ephysroot,mstr,'_reduced.mat',sep=''));

# check out data structure
str(exp_data)

brain_regions= ls(exp_data)[-c(1:3)]; 
n_time= dim(exp_data$faceSVD)[2];
n_sv = dim(exp_data$faceSVD)[1];

##### Extracting Spike Trains -----------------------------
############################

plot_list = list()
for(i_region in 1:9) {
  time_range = c(1000, 2000); # indices of time frame
  
  ### Extract the spike train for this region
  spikes_this_region = exp_data[[brain_regions[i_region]]]
  
  ### Visualize the spike train 
  n_neurons = dim(spikes_this_region)[1]; 
  p = plot(x=0,y=0,pch=16,col="white",type="l",lwd=3,ylim=c(0,n_neurons),
           xlim=time_range,cex.lab=1,cex.main=1,ylab='Neuron',xlab='Time frame',
           main=paste0("Spike Train Region ", i_region, " Time ", time_range[1], 
                       " to ", time_range[2]))
  #yaxt='n',xaxt='n',
  
  for(i_neuron in 1:n_neurons){
    spk_times =which(spikes_this_region[i_neuron,time_range[1]:time_range[2]]>0);
    if (length(spk_times)>0){
      points(y=rep(i_neuron,length(spk_times)),x=spk_times+time_range[1]-1,col="#000000",pch='.',cex=2)
    }
  }
  
  plot_list[[i_region]] = p
}

t0 <- 0
tn <- n_time

hists <- list()
neuron_count <- vector()
neuron_avg_df_c <- data.frame()
neuron_pt_mean <- vector()
  for(i_region in 1:9){
    ### initialize time frame to work with
    time_frame <- c(t0,tn)
    
    ### Extract the spike train for this region
    spikes_this_region = exp_data[[brain_regions[i_region]]]
    
    ### number of neurons in i_region stored in vector
    #neuron_count[i_region] <- dim(spikes_this_region)[1]
    neuron_count <- dim(spikes_this_region)[1]
    
    ### neurons at given time frame 
    neuron_time <- colSums(spikes_this_region) # sums binary ints per time_frame index
    
    ### number of neurons at given time given total neuron count
    neurons_pt <- as.vector(neuron_time/neuron_count) 
    
    neuron_pt_mean[i_region] <- mean(neurons_pt)
    
    neuron_hist <- hist(neurons_pt)
    hists[[i_region]] <- neuron_hist ## frequency of neurons at time / total neurons
    
    ### stores neuron time / total neurons for i_regions as data frame
    neuron_avg_df_c <- rbind(neuron_avg_df_c,neurons_pt)
  }

plot(neuron_pt_mean, xlab = "Brain region", main = "Average Proportion of Neurons Firing per Brain Region", ylab = "Average Proportion of Fired Neurons")

corr.prop.neurons <- cor(t(neuron_avg_df_c))


library(corrplot)
library(RColorBrewer)
corrplot(corr.prop.neurons, type="upper", order="hclust",
         col=brewer.pal(n=8, name="RdYlBu"))




        # neur_df <- t(neuron_avg_df_c)
        # neur_df <- as.matrix(neur_df)
        # # neur_df[-which(rowSums(neur_df ==0 )>0),]
        # # library(data.table)
        # # setattr(neur_df, "row.names", 1:n_time)
        # rownames(neuron_avg_df_c) <- 1:nrow(neuron_avg_df_c) # make row names numeric for time indices
        # 
        # neur_df <- subset.data.frame(neuron_avg_df_c, neuron_avg_df_c > 0)
        # 
        # for (i in 1: nrow(neuron_avg_df_c)){
        # neur <- subset(t(neuron_avg_df_c), neuron_avg_df_c[i,] > 0)
        # }


### remove columns with zero

neur_df_red <- t(neuron_avg_df_c)
row_sub <- apply(neur_df_red,1, function(row) all(row!=0))
neur_df_red <- neur_df_red[row_sub,]


corr.red.nuerons <- cor(neur_df_red)
corrplot(corr.red.nuerons, type="upper", order="hclust",
         col=brewer.pal(n=8, name="RdYlBu"))


##### 3 frame krebs
time_list = c(1,1000, 2000)
dims=dim(exp_data$motionMask);

par(mfrow=c(1,length(time_list)))
for (it in 1:length(time_list)){
  face_i = matrix(0,nrow=dims[1],ncol=dims[2]);
  i=time_list[it];
  
  for (i_sv in 1:n_sv){
    tmp=exp_data$motionMask[,,i_sv];
    tmp[is.nan(tmp)]=0;
    face_i=face_i+exp_data$faceSVD[i_sv,i]*tmp;
    
  }
  face_i= apply(face_i, 2, rev)
  image( t(face_i),col=heat.colors(20),zlim=c(-10,10))
}




###### avg frame : sexy pic of krebs
tmp=exp_data$avgframe;
tmp= apply(tmp, 2, rev)
par(mfrow=c(1,1))
image(t(tmp),col=heat.colors(20) )


########### neuron count
for (i in 1:9){
  spikes_this_region = exp_data[[brain_regions[i]]] ## not a spike train
  n_time = dim(spikes_this_region)[2]
  n_neurons = dim(spikes_this_region)[i]
  #Calculating the average number of neurons for each time frame
  neurons_fired = colSums(spikes_this_region)
  avg.neurons =as.vector(neurons_fired/length(spikes_this_region))
  smoothScatter(1:n_time, neurons_fired)
  
}






library(R.matlab)

ephysroot = 'C:/Users/karis/Desktop/'; # path of the data set 
mstr = 'Krebs'; # mouse names
### Load saved data:
exp_data<- readMat(paste(ephysroot,mstr,'_reduced.mat',sep=''));

n_time= dim(exp_data$faceSVD)[2];
n_sv <- dim(exp_data$faceSVD)[1];

time_list = c(1:n_time) # ADJUST IF YOU'RE NOT CONFIDENT IT WORKS YET # 39053 IS A LOT OF FRAMES TO MAKE # I.E. IT TAKES TIME
dims=dim(exp_data$motionMask);

jpeg("tmp/foo%02d.jpg")
my.plot <- list() # create empty list to store all the images
par(mfrow=c(1,length(time_list)))
for (it in 1:length(time_list)){
  face_i = matrix(0,nrow=dims[1],ncol=dims[2]);
  i=time_list[it];
  
  for (i_sv in 1:n_sv){
    tmp=exp_data$motionMask[,,i_sv];
    tmp[is.nan(tmp)]=0;
    face_i=face_i+exp_data$faceSVD[i_sv,i]*tmp;
    
  }
  face_i= apply(face_i, 2, rev) # flips image (haha rev =reverse gottem)
  image <- image( t(face_i),col=heat.colors(20),zlim=c(-10,10)) # plots it
  my.plot[[it]] <- image
  
}
dev.off()

# install IMAGEMAGICK

make.mov <- function(){
  unlink("plot.mpg")
  system("convert -delay 0.5 plot*.jpg plot.mpg") 
}

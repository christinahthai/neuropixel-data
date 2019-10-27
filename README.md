# Project

This is a class project from the course STA 141 Introduction to Data Science provided by the University of California, Davis.

## Purpose
Examine neural activity throughout the entire time period and locate where there may be significant changes in neural activity

## Getting Started

### Requirements
- MATLAB (R2018 on a Mac computer)
- This repository (add all folders and subfolders to your MATLAB path)
- [The npy-matlab repository](http://github.com/kwikteam/npy-matlab)
- [The Allen Mouse Brain Atlas volume and annotations](http://data.cortexlab.net/allenCCF/) (download all 4 files from this link) 
Locate the data files at //zserver/Lab/Atlas/allenCCF. Alternatively, see setup_utils to download and preprocess the files yourself. See also https://alleninstitute.github.io/AllenSDK/reference_space.html to access the data directly via the Allen Inst python API.

- RStudios (Version 1.1.383 on a Mac computer)
- Libraries utilized: ggcorrplot, corrplot, knitr, matrixStats, qlcMatrix, dygraphs, dplyr, plotly

### Repository files
#### Reduced_Krebs.mat
reduced data set contains Neuropixel recordings of a mouse named Krebs during spontaneous activity. The full data set can be found at this [webpage](https://janelia.figshare.com/articles/Eight-probe_Neuropixels_recordings_during_spontaneous_behaviors/7739750).

The data used has already been preprocessed using a Matlab script. 

### Summary of Data
This report focuses on data collected from an experiment done with a mouse named Krebs. The neuron activation recorded from stimuli from whisking (measured by summed videographic motion energy within the whisker region).

This data set contains [spike trains](https://en.wikipedia.org/wiki/Neural_coding) of neurons in nine regions in the mouse brain.

These spike trains for the duration of recording period are visualized as follows. Each point represents a neuron firing within its brain region at the given time period. A spike corresponds to all of the neural firings at a time frame. Each time frame index corresponds to 30ms. In total, we have 39053 time frames, corresponding to 1171.59s of recorded data for Krebs. Sequences of spikes, form a spike train such as follows. 


The following represent elements of behavior data:
`avgframe` Average Frame of Recording <br />
`faceSVD` Singular Value Decompositon of Compressed Image of Face <br />
`motionMask` Corresponding Masks to Singular Values <brv/>

The data set being referenced `Reduced_Krebs.mat` contains the first 50 singular values and their masks. These are used to reproduce an image based on the average of the frames within the data set using infrared camera. 


The following columns represent the nine regions for Krebs in the mouse brain:

`stall.CP` Caudate Putamen <br />
`stall.FrMoCtx` Frontal Motor Cortex<br />
`stall.HPF` Hippocampal Formation<br />
`stall.LS` Lateral Septum<br />
`stall.MB` Midbrain<br />
`stall.SC` Superior Colliculus<br />
`stall.SomMoCtxx` Somatomotor Cortex<br />
`stall.TH` Thalamus<br />
`stall.V1` Primary Visual Cortex <br />

The data set contains spike trains of neurons in nine regions of the mouse brain. Each corresponding column represents a specific region of the brain; for example, the vector `stall.CP` relates to the activity and activation of neurons located in the Caudate Putamen.

A more in depth explanation on the structure of our data is that it is a binary matrix with values of 1 denoting an existance of neural activity and 0 being that there is no neural activity at the specific time frame. Each row represents a neuron within the region. 



## Output Visuals

### Image of Probe Locations in Mouse Brain

![probe locations](https://pastepic.xyz/images/2019/10/26/mouse_braina836f256113004d8.jpg)

The figure above is the reconstructed probe locations of recordings in Krebs. The poles are generated using the borders of the brain regions and map depth of the region in microns relative to position of the principal axes of the body (AP/DV/LR). 

**Note:** AP refers the antero-posterior, DV refers to the dorso-ventral, and LR refers to the left-right axis formation.



### GIF of Interactive Plot of Neural Spike Time Series 
![gif of interactive plot](https://media.giphy.com/media/TI9QL7fs8lr4uH4VqB/giphy.gif)


### Authors
#### Christina Thai

 * Introduction
 * Background
 * Summary of Data
 * Visual of Probe Locations in Brain
 * Time Series Visual of Average Number of Neurons/Region
 * Kendall Tau's correlation
 
 Can be reached at christinahthai@gmail.


#### Karishma Johnson
* Spike Trains and Spike Train Analysis
* Statistics Regarding Neurons 
* Population and Study Design
* Correlation Matrices for entire time frame
* Visuals of Krebs
* Data Transformation


### Acknowledgements

Images gathered from reference [bioRxiv paper](https://www.biorxiv.org/content/early/2018/10/19/447995).

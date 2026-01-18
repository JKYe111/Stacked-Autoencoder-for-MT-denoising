# A Deep Stacked Autoencoder for Magnetotelluric Data Denoising via End-to-End Time-Domain Noise Mapping

# Installation
1. Clone the git repository (Or use "DownLoad zip") somewhere you can easily reach it.
2. Add the folder to your path in MATLAB Deep Learning Toolbox

# Demo
## Noise generating
Generate_noise.m: containing automatic random Charge-discharge triangle/Impulse noise generation
## Network training
Train_SAE.m: training a noise mapping network with SAE architecture
## Noise mapping - corresponding Fig.8 & 9,  Tab.2 & 3 in the manuscript
TestTriangle.m: Triangle noise process
TestSquare.m: Square noise process
TestImpulse.m: Impulse noise process
TestMixed.m: Mixed noise process
## Functions
snrmsenccsr.m: denoising metrics
fun_WT: Wavelet denoising function

# Dependencies
Matlab 2021a and above

Deep Learning Toolbox

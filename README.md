## Super-Resolution Reconstruction In Cardiac Magnetic Resonance 
The repository contains data and codes to estimate the four-dimensional motion of the heart using super-resolution reconstruction of cardiac magnetic resonance images. 

1. CSRR contains codes to create a super-resolution grid of CMR images using combinations of arbitrarily aligned low-resolution images and masks. 
2. Phantom_codes contains codes to create synthetic SR images from finite element solutions of cardiac contraction.
3. NRIR_codes contains codes to calculate 4D anatomical (radial-circumferential-longitudinal) strains using the SR images.
4. Visualization contains codes to obtain graphics present in the publication

## SRR in CMR (SRR_codes/img_csrr/img_csrr_script.m)
The code recieves the short-axis and long-axis images of the phantom heart, and creates a super-resolution grid based on user-defined parameters.

## Strain Calculations (Phantom_codes/NRIR_codes/NRIR_script.m)
Uses the diffeomorphic demons algorithm to implement non-rigid image registration in deriving myocardial strains. 

## Sythetic data generation (Phantom_codes/Create_Phantom.py)
Creates a synthetic image set using finite element simulations of a mouse heart.

## SRR for phantom (Phantom_codes/img_csrr/csrr_phantom_script.m)
The code recieves the short-axis and long-axis images of the phantom heart, and creates a super-resolution grid based on user-defined parameters.

## Requirements 
MATLAB, Python >= 3.8 (numpy, scipy, pyvista, vtk, pillow, pydicom)
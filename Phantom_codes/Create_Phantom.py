#################### 
# @Author: Tanmay.Mukherjee  
# @Date: 2023-08-23 13:00:15  
# @Last Modified by: Tanmay.Mukherjee  
# @Last Modified time: 2023-08-23 13:00:15 
####################
import os
import numpy as np
import pyvista as pv 
import tqdm
from time import sleep

from Img_Samplers import Orthogonal_Sample, Radial_Sample, Short_Axis_Sample
from Writers import Write_LA_DCM_Image, Write_SA_DCM_Image
from Plotters import plot_vtk_planes


def main():

    direc = os.getcwd() # Current working directory
    fig_direc = os.getcwd() # Directory to store figures 
    fe_direc = os.path.join(direc, "FE") # Input FE solutions directory
    img_direc = os.path.join(direc,"img") # Output Image directory
    la_sequence = "Orthogonal"
    la_sample = False
    sa_sample = True
    fe_files = os.listdir(fe_direc) # List all vtk files in the FE directory 
    # fe_files = ["position_0000.vtk"]

    
    for count, fid in tqdm.tqdm(enumerate(fe_files)):
        sleep(0.1)

        mesh = pv.read(os.path.join(fe_direc, fid))
        img_planes = []

        if count == 0: mesh_center = mesh.center
        mesh.points -= mesh_center
        
        if la_sample:

            if la_sequence == "Orthogonal":
                source_normal =  np.array([1,1,0])
                la_img_planes = Orthogonal_Sample(mesh=mesh, normal=source_normal)
                img_planes.extend(la_img_planes)

            if la_sequence == "Radial":
                # source_normal =  np.array([1,1,0])
                la_img_planes = Radial_Sample(mesh=mesh)
                img_planes.extend(la_img_planes)
                # print(la_img_planes)
            
            ss_fid = os.path.join(fig_direc, la_sequence + "_phantom_" + str(count).zfill(4) + ".png")

        if sa_sample: 
            sa_img_planes = Short_Axis_Sample(mesh = mesh)
            img_planes.extend(sa_img_planes)

        # Write_LA_DCM_Image(la_img_planes, img_direc, la_sequence, count)

        # Write_SA_DCM_Image(sa_img_planes, img_direc, la_sequence, count)

        if not la_sample:
            ss_fid = os.path.join(fig_direc, "phantom_" + str(count).zfill(4) + ".png")
        plot_vtk_planes(img_planes, fid = ss_fid)

        # count = 1
        
    return 0

if __name__ == "__main__":
    main()
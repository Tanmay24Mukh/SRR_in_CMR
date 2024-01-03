import numpy as np
import pyvista as pv 

from Converters import  vtkmesh_2_image_map

def Short_Axis_Sample(mesh = pv.UnstructuredGrid, normal = np.array([0,0,1])):
    
    sa_planes = np.linspace(mesh.bounds[-2], mesh.bounds[-1]-1, 8)

    img_plx_list = []
    
    for ind,pl in enumerate(sa_planes[1:]):
        og = mesh.center
        og[-1] = pl
        slx = mesh.slice(normal="z", origin=og)
        plx = pv.Plane(direction=np.array([0,0,1]), center=og, i_size = 100, j_size = 100, \
                       i_resolution= 100, j_resolution=100)

        img_plx = vtkmesh_2_image_map(grid=plx, mid_slice= slx)
        img_plx["source_normal"] = normal*np.ones((img_plx.points.shape))

        img_plx_list.append(img_plx)

    return img_plx_list

def Radial_Sample(mesh = pv.UnstructuredGrid):
    
    ## Radial sampling
    planes = np.array([[1,0,0], [0,1,0], [1,1,0], [-1,1,0]])
    
    img_plx_list = []

    for pl in planes:
        normal = pl/np.linalg.norm(pl)
        slx = mesh.slice(normal=normal, origin=mesh.center)
        plx = pv.Plane(direction=normal, center=mesh.center, i_size = 100, j_size = 100, \
                       i_resolution= 100, j_resolution=100)
        # p.add_mesh(slx, color = "green")
        
        img_plx = vtkmesh_2_image_map(grid=plx, mid_slice= slx)
        img_plx["source_normal"] = normal*np.ones((img_plx.points.shape))

        img_plx_list.append(img_plx)
    
 
    
    return img_plx_list

def Orthogonal_Sample(mesh = pv.UnstructuredGrid, normal = np.array([1,1,0]), No_of_planes = 7):

    xmin, xmax, ymin, ymax = mesh.bounds[0], mesh.bounds[1], \
        mesh.bounds[2], mesh.bounds[3]
    
    xo, yo = np.linspace(xmin,xmax,No_of_planes), np.linspace(ymin,ymax,No_of_planes)
    
    zo = mesh.center[-1]*np.ones(xo.shape)
    
    origins = np.hstack((np.c_[xo],np.c_[yo],np.c_[zo]))

    count = 0

    img_plx_list = []
    for og in origins:
        
        normal = normal/np.linalg.norm(normal)

        slx = mesh.slice(normal = normal, origin = og)
        
        plx = pv.Plane(direction = normal, center = og, i_size = 100, j_size = 100, \
                       i_resolution= 100, j_resolution=100)
        
        img_plx = vtkmesh_2_image_map(grid=plx, mid_slice= slx)
        img_plx["source_normal"] = normal*np.ones((img_plx.points.shape))


        if np.max(plx["intensity"]) > 0:
            img_plx_list.append(img_plx)


    return img_plx_list
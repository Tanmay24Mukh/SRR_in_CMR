import os
import numpy as np
import pyvista as pv 
import tqdm
from time import sleep


def plot_vtk_planes(image_planes = [], fid = 'screenshot.png'):
    """
    image_planes is a list of vtk PolyData meshes corresponding
    to the slices sampled from the mesh
    """

    pv.set_plot_theme('document')
    # p = pv.Plotter()
    p = pv.Plotter(off_screen = True)
    for img_plane in image_planes:
        
        lv_points = img_plane.points[np.where(img_plane["intensity"] > 200)]
        lv_pc = pv.PolyData(lv_points)
        lv_mesh = lv_pc.delaunay_2d(alpha=5)

        plane_opacity_array = np.ones(img_plane["intensity"].shape)
        plane_opacity_array[np.where(img_plane["intensity"] > 200)] = 0

        p.add_mesh(img_plane, cmap = "gray", opacity=0.4*plane_opacity_array, show_scalar_bar=False)
        p.add_mesh(lv_mesh, color = "white")

    
    p.camera_position = "xz"
    p.camera.elevation += 25
    p.camera.azimuth -= 145

    p.add_light(pv.Light(intensity=0.3))
    # p.show()
    p.show(auto_close=True, screenshot=fid)
    return 0
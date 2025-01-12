import os
import numpy as np  
import pyvista as pv
from matplotlib.colors import ListedColormap

def main():
    direc = os.getcwd()
    study = "M101"
    t = 15
    vtk_direc = os.path.join(direc, study, study+"_results", "dat_files")

    vtk_fid = os.path.join(vtk_direc, study+"_body_tf_" + str(t) + ".vtk")
    

    z_pos = 25
    strain_id = "circum_strain"
    mesh = pv.read(vtk_fid)
   
    pc = mesh.points[np.abs(mesh.points[:,2]) == z_pos]
    pc_scalars = mesh.get_array(strain_id)[np.abs(mesh.points[:,2]) == z_pos]

    p = pv.Plotter()
    p.add_mesh(pc, cmap="jet", scalars=pc_scalars)
    p.show()

    # print(vtk_fid)
    # print(os.path.isfile(vtk_fid))

def multi_plot():

    direc = "D:\\CMR_package\\Datasets\\WT_dbdb_mice\\"
    studies = os.listdir(direc)
    wt_studies = [item for item in studies if (os.path.isdir(os.path.join(direc,item)) and "M1" in item)]
    t = 15
    super_res = True
    if super_res:
        z_pos = 5
        store_folder = "SR"
    else:
        z_pos = 10
        store_folder = "LR"

    strain_id = "radial_strain"
    store_direc = os.path.join(os.getcwd(), "Fig_10", store_folder)

    pv.set_plot_theme("document")

    # p = pv.Plotter(shape=(1,len(wt_studies)), border=False, off_screen=True)
    # p = pv.Plotter(shape=(1,len(wt_studies)), border=False)

    clr = ListedColormap(create_colorbar())
    
    for ind, study in enumerate(wt_studies):

        vtk_direc = os.path.join(direc, study, study+"_results", "dat_files")

        vtk_fid = os.path.join(vtk_direc, study+"_body_tf_" + str(t) + ".vtk")
        
        if not os.path.isfile(vtk_fid):     
            # raise ValueError(f'the vtk file for {study} does not exist')
            vtk_fid = os.path.join(vtk_direc, study+"_body_tf_" + str(t-1) + ".vtk")
        
        if not os.path.isfile(vtk_fid):
            continue

        # p.subplot(0,ind)
        p = pv.Plotter(off_screen=True)
        mesh = pv.read(vtk_fid)
   
        pc = mesh.points[np.abs(mesh.points[:,2]) == z_pos]
        pc_scalars = mesh.get_array(strain_id)[np.abs(mesh.points[:,2]) == z_pos]

        # print(mesh_pc)

        # print(study)
        

        try:
            pc_circle_points, pc_circle_scalars = post_calc_map_sector_2D(vertices = pc, values = pc_scalars, min_r = 0.25, max_r = 1)
           
            segment_mean_dict, segment_sdv_dict, segment_mean_array = extract_AHA_segments(vertices=pc_circle_points, values=pc_circle_scalars)          

            # with open(os.path.join(store_direc, 'Segment_' + strain_id +'_averages_' + study +'.txt'), 'w') as file:
            #     # Write only the values (numbers) to the file
            #     for value in segment_mean_dict.values():
            #         file.write(f"{value}\n")
            
            # with open(os.path.join(store_direc,'Segment_' + strain_id +'_sdv_' + study +'.txt', 'w')) as file:
            #     # Write only the values (numbers) to the file
            #     for value in segment_sdv_dict.values():
            #         file.write(f"{value}\n")
            # break
            
            pc_pc = pv.PolyData(pc_circle_points)
            print(len(pc_circle_scalars))
            mesh_pc = pc_pc.delaunay_2d(alpha=0.2)
            mesh_pc["strain"] = pc_circle_scalars
            mesh_pc["mean_strain"] = segment_mean_array
            p.add_mesh(mesh_pc, cmap=clr, scalars=mesh_pc["strain"], clim = [-0.4,0.4], show_scalar_bar=False)
            # p.add_mesh(mesh_pc, cmap="jet", scalars=mesh_pc["strain"], show_scalar_bar=False)
            p.camera_position = "xy"
            p.add_light(pv.Light(intensity=0.2))
            p.show(screenshot=os.path.join(store_direc,"Fig10_" + strain_id + study +".png"), auto_close=True)
            


        except:
            continue
    
    
    # p.show(screenshot="Fig10_LR.png", auto_close=True)
    # p.add_light(pv.Light(intensity=0.2))
    # p.show()


  
def post_calc_map_sector_2D(vertices = np.array([0,0,0]), values = np.array([0]), \
    t1 = 182, t2 = 540, min_r = 0.5, max_r = 1):

    x_array, y_array, z_array = np.c_[vertices[:,0]], np.c_[vertices[:,1]], np.c_[vertices[:,2]]
    xc, yc = np.mean(x_array), np.mean(y_array)

    x_ideal, y_ideal, z_ideal = np.array([]),np.array([]),np.array([])
    u_ideal = x_ideal.copy()

    count = 0
     
    radii_array = (((x_array - xc)**2 + (y_array - yc)**2)**0.5)
    theta_array = np.radians(360) + np.arctan2(y_array -yc,x_array -xc)
    polar_array = np.hstack((radii_array, theta_array))
    # print("polar_array.shape is: ", polar_array.shape)
    polar_array[:,0], polar_array[:,1] = np.round(polar_array[:,0],4), np.round(polar_array[:,1],4)

    theta = np.radians(t1)
    r,t, u = [],[], []
    r_array = np.array([0,0,0])
    t_list = []

        # print("max_r is: ", max_r)
    while theta <= np.radians(t2):
        t_list.append(theta)
        for ind, val in enumerate(polar_array[:,1]):
            if abs((theta - val)/theta) < 0.01:
                r.append(polar_array[ind,0]) # Radius of each point in real plane
                t.append(val)                # Theta of each point in real plane
                u.append(values[ind])     # Strain value for each point

        for ind, val in enumerate(r):

            if val == min(r):
                r_array = np.vstack((r_array, np.hstack((min_r, t[ind] , u[ind]))))
            
            elif val == max(r): 
                r_array = np.vstack((r_array, np.hstack((max_r, t[ind] , u[ind]))))
            
            else:
                r_array = np.vstack((r_array, np.hstack((min_r + (((max_r - min_r)/(max(r) - min(r))*(val- min(r)))), t[ind], u[ind]))))
        
        r, t, u = [], [], []
        
        theta += np.pi/180
 
    r_array = np.unique(r_array,axis = 0) # Collects all unique points in (r, theta)
    # print("r_array shape: ", r_array.shape)

    r_i, t_i = np.r_[r_array[1:,0]], np.r_[r_array[1:,1]] # Points in ideal plane (polar co-ordinates)
    u_i = r_array[1:,2] # Strain values
    
    x_i, y_i, z_i = np.array([]), np.array([]), np.array([]) # Points in ideal plane (cartesian co-ordinates)

    x_i = r_array[1:,0] * np.cos(r_array[1:,1])
    y_i = r_array[1:,0] * np.sin(r_array[1:,1])
    z_i = np.ones(x_i.shape)

    # print("x_i shape: ", np.c_[x_i].shape)

  
    x_ideal, y_ideal, z_ideal = np.c_[x_i], np.c_[y_i], np.c_[z_i]
    u_ideal = np.c_[u_i]

    # print((u_ideal))
    ideal_vertices = np.hstack((x_ideal, y_ideal, z_ideal))
    
    return ideal_vertices, u_ideal

    # studies = ["M" + str(101+val) for val in range(6)]
    # print(wt_studies)

    # p = pv.Plotter(shape=(1,3))

    # p.subplot(0,0)

def create_colorbar():
    cbar = np.genfromtxt(os.path.join(os.getcwd(), "colorbar.dat"), delimiter=",")
    return cbar
    
def extract_AHA_segments(vertices = np.array([0,0,0]), values = np.array([0])):

    x_array, y_array, z_array = np.c_[vertices[:,0]], np.c_[vertices[:,1]], np.c_[vertices[:,2]]
    xc, yc = np.mean(x_array), np.mean(y_array)

    x_ideal, y_ideal, z_ideal = np.array([]),np.array([]),np.array([])
    u_ideal = x_ideal.copy()

    count = 0
     
    radii_array = (((x_array - xc)**2 + (y_array - yc)**2)**0.5)
    theta_array = np.radians(180) + np.arctan2(y_array -yc,x_array -xc)

    mean_array = np.zeros(theta_array.shape)

    # print(np.min(np.degrees(theta_array)))
    # print(np.max(np.degrees(theta_array)))
    polar_array = np.hstack((radii_array, theta_array))

    segments = [val for val in range(17)]

    
    # AHA segment 1 = segment 1 + 5
    segment_angles = {1: [0, 45], 2: [45, 135], 3: [135, 225], 4: [225,315], 5: [315,360], 
                      6: [225,315], 7: [315,360], 8: [0,45], 9: [45,135], 10: [135,180], 11: [180,225], 
                      12: [180,225], 13: [225,315], 14: [315,360], 15: [0, 45], 16: [45, 135], 17: [135, 180]}
    
    segment_averages = {}
    segment_sdv = {}
    
   
    for segment in segment_angles.keys():

        
        if segment < 6: 
            min_radius = 0
            max_radius = 0.5
        elif segment >= 6 and segment < 11:
            min_radius = 0.5
            max_radius = 0.75
        elif segment >= 11  and segment < 17:
            min_radius = 0.75
            max_radius = 1.1
        
        min_theta, max_theta = np.radians(segment_angles[segment][0]), np.radians(segment_angles[segment][1])

        segment_values = values[np.where((radii_array > min_radius) & (radii_array <= max_radius) & (theta_array > min_theta) & (theta_array <= max_theta))]
        avg_strain = np.average(segment_values)
        sd_strain = np.std(segment_values)

        mean_array[np.where((radii_array > min_radius) & (radii_array <= max_radius) & (theta_array > min_theta) & (theta_array <= max_theta))] = avg_strain
        segment_averages[segment] = avg_strain
        segment_sdv[segment] = sd_strain
        
        # print(1)
        # segment_averages[segment] = 0

    # print(segment_averages)

    return segment_averages, segment_sdv, mean_array

if __name__ == "__main__":
    multi_plot()
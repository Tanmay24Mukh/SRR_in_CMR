import os
import numpy as np
import pydicom
import tqdm
from time import sleep

from Converters import project_2_plane, vtkPolyData_2_PILImage, vtkmesh_2_image_map, PILImage_2_dicom

def Write_SA_DCM_Image(sa_img_planes, img_direc, la_sequence, count):
    
    for ind, img_plx in enumerate(sa_img_planes):

        center_of_projection = np.min(img_plx.points, axis = 0)
        projection_normal = np.array([0,1,0])
        source_normal = np.unique(img_plx["source_normal"], axis=0)[0]
        Orientation = np.vstack((np.c_[source_normal],np.c_[projection_normal]))

        xz_img_plane = project_2_plane(img_plx= img_plx, target_normal=projection_normal)

    
        intensity_image, intensity_map, shape_dims = vtkPolyData_2_PILImage(xz_img_plane)

        output_direc = os.path.join(img_direc,la_sequence,"SA", "SA_" + str(ind))

        if not os.path.isdir(output_direc): 
            os.makedirs(output_direc)

        output_filename = os.path.join(output_direc,'PhantomMRI' + str(count).zfill(2) +'.dcm')

        # Define DICOM metadata
        metadata = {
            'PatientName': "M202_phantom",
            'ImageType': ["ORIGINAL", "PRIMARY", ""],
            'ImagePositionPatient': [val for val in center_of_projection],
            'ImageOrientationPatient': [val for val in Orientation],
            'SeriesDescription': la_sequence + "_SA_phantom"}

        dicom_image = PILImage_2_dicom(image = intensity_image, metadata=metadata)

        # Write DCM Image
        pydicom.dcmwrite(filename=output_filename, dataset = dicom_image)

    return 0


def Write_LA_DCM_Image(la_img_planes, img_direc, la_sequence, count):
    
    for ind, img_plx in enumerate(la_img_planes):

        center_of_projection = np.min(img_plx.points, axis = 0)
        projection_normal = np.array([0,1,0])
        source_normal = np.unique(img_plx["source_normal"], axis=0)[0]
        Orientation = np.vstack((np.c_[source_normal],np.c_[projection_normal]))

        xz_img_plane = project_2_plane(img_plx= img_plx, target_normal=projection_normal)

    
        intensity_image, intensity_map, shape_dims = vtkPolyData_2_PILImage(xz_img_plane)

        output_direc = os.path.join(img_direc,la_sequence,"LA", "LA_" + str(ind))

        if not os.path.isdir(output_direc): 
            os.makedirs(output_direc)

        output_filename = os.path.join(output_direc,'PhantomMRI' + str(count).zfill(2) +'.dcm')

        # Define DICOM metadata
        metadata = {
            'PatientName': "M202_phantom",
            'ImageType': ["ORIGINAL", "PRIMARY", ""],
            'ImagePositionPatient': [val for val in center_of_projection],
            'ImageOrientationPatient': [val for val in Orientation],
            'SeriesDescription': la_sequence + "_LA_phantom"}

        dicom_image = PILImage_2_dicom(image = intensity_image, metadata=metadata)

        # Write DCM Image
        pydicom.dcmwrite(filename=output_filename, dataset = dicom_image)

    return 0
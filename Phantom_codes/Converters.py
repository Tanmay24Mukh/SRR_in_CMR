import numpy as np
import pyvista as pv 
from PIL import Image, ImageOps
import matplotlib.pyplot as plt
from pydicom.dataset import Dataset

from Rotation_Methods import rotate_and_translate_points

def project_2_plane(img_plx = pv.PolyData, target_normal = np.array([0,1,0]), center_of_projection = np.array([0,0,0])):

    points = img_plx.points
    
    source_normal = np.unique(img_plx.get_array("source_normal"), axis = 0)
    source_normal = source_normal[0]

    projected_points = rotate_and_translate_points(source_normal, target_normal, points)

    projected_points += center_of_projection

    projected_plane = pv.PolyData(projected_points)
    projected_plane["intensity"] = img_plx.get_array("intensity")
    # projected_plane["plane_normal"] = target_normal*np.ones((projected_plane.points.shape))
    projected_plane["source_normal"] = target_normal*np.ones((projected_plane.points.shape))

    return projected_plane

def vtkPolyData_2_PILImage(grid = pv.PolyData):
    intensity_array = np.array([grid.get_array('intensity')])
    shape_idx = int(intensity_array.shape[1]**0.5)
    shape_dims = (shape_idx,shape_idx)
    intensity_map = intensity_array.reshape(shape_dims).T
    im = Image.fromarray(np.uint8(intensity_map[:,:]))
    intensity_image = ImageOps.flip(im)
    # plt.imshow(intensity_image, cmap="gray")
    # plt.show()
    return intensity_image, intensity_map, shape_dims


def vtkmesh_2_image_map(grid = pv.Plane, mid_slice = pv.PolyData, map_strains = False):
    
    grid["intensity"] = np.zeros((grid.points.shape[0],1))
    grid["strain"] = np.empty((grid.points.shape[0],1))

    for ind, point in enumerate(grid.points):

        x_distance = (point[0] - mid_slice.points[:,0])**2 
        y_distance = (point[1] - mid_slice.points[:,1])**2
        z_distance = (point[2] - mid_slice.points[:,2])**2
        distance = (x_distance + y_distance + z_distance)**0.5

        proximity = distance[np.where(distance <= 2)]
        proximity_len = len(proximity)

        if proximity_len >= 1: 
            
            if grid["intensity"][ind] <= 255: 
                grid["intensity"][ind] += 255
        
        else:
            if map_strains is True:
                grid["strain"][ind] = np.nan

    return grid



def PILImage_2_dicom(image, metadata):
    # Create a new DICOM dataset
    ds = Dataset()
    ds.PatientName = metadata['PatientName']
    ds.ImageType = metadata['ImageType']
    ds.ImagePositionPatient = metadata["ImagePositionPatient"]
    ds.ImageOrientationPatient = metadata["ImageOrientationPatient"]
    ds.SeriesDescription = metadata["SeriesDescription"]
    ds.SamplesPerPixel = 1
    ds.PhotometricInterpretation = "MONOCHROME2"
    ds.Rows, ds.Columns = image.size
    ds.BitsAllocated = 8  # Number of bits allocated for each pixel
    ds.BitsStored = 8     # Number of bits stored for each pixel
    ds.HighBit = 7        # The highest bit that is stored
    ds.PixelRepresentation = 0  # Unsigned integer
    # Add more DICOM metadata fields as needed

    # Convert the image to pixel array
    pixel_array = image.convert("L")  # Convert to grayscale
    pixel_data = pixel_array.tobytes()
    ds.PixelData = pixel_data

    ds.is_little_endian = True
    ds.is_implicit_VR = True

    # # Save the DICOM dataset
    # pydicom.dcmwrite(filename, ds)
    return ds


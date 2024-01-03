import numpy as np

def rotation_matrix_from_vectors(vec1, vec2):
    """
    Calculate the rotation matrix that rotates vec1 onto vec2 using Rodrigues' rotation formula.
    """

    
    v = np.cross(vec1, vec2)
    c = np.dot(vec1, vec2)
    s = np.linalg.norm(v)

    # print(v)
    # print(c)
    # print(s)

    skew_matrix = np.array([[0, -v[2], v[1]],
                            [v[2], 0, -v[0]],
                            [-v[1], v[0], 0]])
    # print(skew_matrix)
    
    non_skew_matrix = np.dot(skew_matrix, skew_matrix) * ((1 - c) / (s ** 2))
    # print(np.dot(skew_matrix, skew_matrix))
    
    rotation_matrix = np.eye(3) + skew_matrix + np.dot(skew_matrix, skew_matrix) * ((1 - c) / (s ** 2))
    # print(rotation_matrix)
    
    return rotation_matrix

def rotate_and_translate_points(source_normal, target_normal, points):
    
    # Normalize the plane normals
    source_normal = source_normal / np.linalg.norm(source_normal)
    target_normal = target_normal / np.linalg.norm(target_normal)
    
    # Calculate the rotation matrix
    rotation_matrix = rotation_matrix_from_vectors(source_normal, target_normal)

    
    # Project the points onto the target plane
    projected_points = np.dot(points, rotation_matrix.T)

    # print(projected_points)

    # Translate the points to the zero plane
    projected_points -= np.min(projected_points, axis = 0)
    
    return projected_points

if __name__ == "__main__":
    rotation_matrix_from_vectors(np.array([0.7071,0.7071,0]), np.array([0,1,0]))

    points = np.array([[1,0,1],[1,0,2],[1,0,3]])

    projected_points =  rotate_and_translate_points( np.array([0,1,0]),np.array([0.7071,0.7071,0]), points)

    # print(projected_points)

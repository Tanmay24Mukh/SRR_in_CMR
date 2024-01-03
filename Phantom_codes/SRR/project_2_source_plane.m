AI = dicomread("C:\Users\tanmaymu\Documents\C2BL\Repos\CSRR\Validation\Test_Case\output_0.dcm");
A = dicominfo("C:\Users\tanmaymu\Documents\C2BL\Repos\CSRR\Validation\Test_Case\output_0.dcm");

project_2_source_plane(AI,A);

function [X_proj, Y_proj, Z_proj] = project_2_source_plane(image_map, image_info)
    I = double(image_info.Width); J = double(image_info.Height);
   
    X = linspace(1,I,I);
    Y = linspace(1,I,I);
    Z = zeros(1,size(X,2));
    
    points = [X',Y',Z'];

    
    % points = [X, Y, Z];
    % 
    % source_normal = np.unique(img_plx.get_array("source_normal"), axis = 0)
    % source_normal = source_normal[0]
    % 
    % projected_points = rotate_and_translate_points(source_normal, target_normal, points)
    % 
    % projected_points += center_of_projection
    % 
    % projected_plane = pv.PolyData(projected_points)
    % projected_plane["intensity"] = img_plx.get_array("intensity")
    % # projected_plane["plane_normal"] = target_normal*np.ones((projected_plane.points.shape))
    % projected_plane["source_normal"] = target_normal*np.ones((projected_plane.points.shape))

end


% def rotation_matrix_from_vectors(vec1, vec2):
%     """
%     Calculate the rotation matrix that rotates vec1 onto vec2 using Rodrigues' rotation formula.
%     """
% 
% 
%     v = np.cross(vec1, vec2)
%     c = np.dot(vec1, vec2)
%     s = np.linalg.norm(v)
% 
% 
%     skew_matrix = np.array([[0, -v[2], v[1]],
%                             [v[2], 0, -v[0]],
%                             [-v[1], v[0], 0]])
% 
%     rotation_matrix = np.eye(3) + skew_matrix + np.dot(skew_matrix, skew_matrix) * ((1 - c) / (s ** 2))
% 
%     return rotation_matrix
% 
% def rotate_and_translate_points(source_normal, target_normal, points):
% 
%     # Normalize the plane normals
%     source_normal = source_normal / np.linalg.norm(source_normal)
%     target_normal = target_normal / np.linalg.norm(target_normal)
% 
%     # Calculate the rotation matrix
%     rotation_matrix = rotation_matrix_from_vectors(source_normal, target_normal)
% 
%     # Project the points onto the target plane
%     projected_points = np.dot(points, rotation_matrix.T)
% 
%     # Translate the points to the zero plane
%     projected_points -= np.min(projected_points, axis = 0)
% 
%     return projected_points


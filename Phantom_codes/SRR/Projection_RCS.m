AI = dicomread("C:\Users\tanmaymu\Documents\C2BL\Repos\CSRR\Validation\Test_Case\output_0.dcm");
A = dicominfo("C:\Users\tanmaymu\Documents\C2BL\Repos\CSRR\Validation\Test_Case\output_0.dcm");

[X_RCS, Y_RCS, Z_RCS, I_gray] = img_2_rcs(AI,A);

function [X_RCS, Y_RCS, Z_RCS, image_grayscale] = img_2_rcs(image_map, image_info)

I = double(image_info.Width);
J = double(image_info.Height);

x = linspace(1,I,I);
z = linspace(1,I,I);

[X,Z] = meshgrid(x,z);
X_og = reshape(X,[],1); Z_og = reshape(Z,[],1);
Y_og = zeros(size(X_og,1),1);

points = [X_og,Y_og,Z_og];

proj_normal = image_info.ImageOrientationPatient(1:3);
source_normal = image_info.ImageOrientationPatient(4:end);
center_of_projection = image_info.ImagePositionPatient;

projected_points = rotate_and_translate_points(source_normal, proj_normal, points);

% Accounting for patient position
projected_points =  projected_points + center_of_projection';


X_proj = projected_points(:,1); Y_proj = projected_points(:,2); Z_proj = projected_points(:,3);

image_grayscale = mat2gray(image_map);

X_RCS = flip(reshape(X_proj,size(image_grayscale)),1);
Y_RCS = flip(reshape(Y_proj,size(image_grayscale)),1);
Z_RCS = flip(reshape(Z_proj,size(image_grayscale)),1);


end

function projected_points = rotate_and_translate_points(source_normal, target_normal, points)

    % Normalize the plane normals
    source_normal = source_normal ./ norm(source_normal,2);
    target_normal = target_normal ./ norm(target_normal,2);


    % %  Calculate the rotation matrix
    rotation_matrix = rotation_matrix_from_vectors(source_normal, target_normal);

    % Project the points onto the target plane
    % projected_points = squeeze(sum(bsxfun(@times, points, permute(rotation_matrix, [3, 2, 1])), 2));
    
    projected_points = [];
    for i = 1:size(points,1)
        point = points(i,:);
        projected_point = point*rotation_matrix';
        projected_points = [projected_points;projected_point];
    end

    a = 2;
    % % Translate the points to the zero plane
    projected_points = projected_points - min(projected_points);

end

function rotation_matrix = rotation_matrix_from_vectors(vec1, vec2)

    % Calculate the rotation matrix that rotates vec1 onto vec2 using Rodrigues' rotation formula.


    v = cross(vec1, vec2);
    c = dot(vec1, vec2);
    s = norm(v,2);

    skew_matrix = [0 -v(3) v(2); v(3) 0 -v(1); -v(2), v(1), 0];
    non_skew_matrix = diag(dot(skew_matrix, skew_matrix')) * (1 - c)/s^2;

    rotation_matrix = eye(3) + skew_matrix + non_skew_matrix;
end

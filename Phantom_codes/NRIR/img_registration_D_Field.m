function [disp_field,targetReg]=img_registration_D_Field(images,iterations,smoothing_ratio,img_Dim,Slice_z,t_start,t_end, frame_skip)


disp_field = cell(1,t_end-1);
targetReg = cell(1,t_end-1);

if (img_Dim==2)
    for tt = 1:frame_skip:t_end-1
        if tt >= t_start
            fixed=images{tt+1}(:,:,Slice_z);
            moving=images{tt}(:,:,Slice_z); %Goal is to find the def that allows us to arrive at fixed
            %         moving = imhistmatch(moving,fixed);
            [disp_field{tt},targetReg{tt}] = imregdemons(moving,fixed,iterations,...
                'AccumulatedFieldSmoothing',smoothing_ratio);
        else
            disp_field{tt} = [];
            targetReg{tt} = [];
        end
    end
elseif (img_Dim==3)
    for tt = 1:frame_skip:t_end-1
        if tt >= t_start
            fixed=images{tt+1}(:,:,:);
            moving=images{tt}(:,:,:); %Goal is to find the def that allows us to arrive at fixed
            %         moving = imhistmatch(moving,fixed);
            [disp_field{tt},targetReg{tt}] = imregdemons(moving,fixed,iterations,...
                'AccumulatedFieldSmoothing',smoothing_ratio);
        else
            disp_field{tt} = [];
            targetReg{tt} = [];
        end
    end
end
end
function [ stitch_img ] = stitchImage( img1, img2, H, is_disp )
[y_len, x_len, layer] = size(img1);
[y_len2, x_len2, ~] = size(img2);

[old_x, old_y] = meshgrid(1:x_len,1:y_len);
flat_shape = [1,x_len*y_len];
old_x = reshape(old_x, flat_shape);
old_y = reshape(old_y, flat_shape);
new_xy = H * [old_x; old_y; ones(flat_shape)];
new_xy = round(bsxfun(@rdivide, new_xy, new_xy(end,:)));

off_x = min(1, min(new_xy(1,:)))-1;
off_y = min(1, min(new_xy(2,:)))-1;
max_x = max(x_len2, max(new_xy(1,:)));
max_y = max(y_len2, max(new_xy(2,:)));

% Initialize stitched image
stitch_img = uint8(zeros(max_y-off_y, max_x-off_x, layer));
stitch_img((1:y_len2)-off_y, (1:x_len2)-off_x, :) = img2;

% Stitch two image
for i = 1:flat_shape(2)
    new_y = new_xy(2,i)-off_y;
    new_x = new_xy(1,i)-off_x;
    if ~any(stitch_img(new_y, new_x, :))
        stitch_img(new_y, new_x, :) = img1(old_y(i), old_x(i), :);
    end
end

if is_disp
    % Display stitch result
    figure('Position', [100,150,1000,600])
    subplot(1,3,1)
    imshow(img1)
    title('Original image 1')
    subplot(1,3,2)
    imshow(uint8(img2))
    title('Original image 2')
    subplot(1,3,3);
    imshow(stitch_img);
    hold on
    corner_ind = [1, y_len, x_len*y_len, (x_len-1)*y_len+1, 1];
    plot(new_xy(1, corner_ind)-off_x, new_xy(2, corner_ind)-off_y, 'r',...
        'linewidth', 2);
    hold off
    title('Stich image 1 and 2');
    drawnow;
end
end


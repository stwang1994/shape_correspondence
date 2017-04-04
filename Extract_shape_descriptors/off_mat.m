function off_mat(srcpath, dstpath)
%###############################
% Chang off file into mat file
%###############################

fnames = dir(fullfile(srcpath, '*.off'));

for i = 1 : length(fnames)
    fprintf('Converting %s\n', fnames(i).name)
    
    % Read off file
    result = offread(fullfile(srcpath, fnames(i).name));

    % Read (x,y,z) coordinate
    a = result(4,:);
    a = cell2mat(a);
    a = a';
    coord_x = a(:,1);
    coord_y = a(:,2);
    coord_z = a(:,3);

    % Read triangle
    b = result(5,:);
    b = cell2mat(b);
    triv = b(2:4,:) + 1;
    triv = triv';

    % Make structure
    surface = struct('TRIV',triv,'X',coord_x,'Y',coord_y,'Z',coord_z);

    % Save to mat file
    [~,b,~] = fileparts(fnames(i).name);
    path_save = strcat(dstpath, b,'.mat');
    save(path_save,'surface')
end


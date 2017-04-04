rng(42,'twister')
addpath(genpath('isc'))

%% Parameter
fix_num = 6889;
datapath = 'data/multiple/';
croppath = 'data/crop/';
diskpath = fullfile(datapath,'disk','cat'); 
hkspath = fullfile(croppath,'hks','horse');

%% Cut disk data
dstpath = 'data/crop/disk/cat';
fnames = dir(fullfile(diskpath, '*.mat'));
for i = 1 : length(fnames)
%i = 1;

    fprintf('%s is processing.\n', fnames(i).name);
    tmp = load(fullfile(diskpath, fnames(i).name));
    tmp = tmp.M;
    [a,max] = size(tmp);
    max = 27894; %25289(dog);%19247(horse);%27894(cat)
    inter = (max - 1)/fix_num;
    array = 1:inter:max;
    array = fix(array);
    partArray = [];
    for j = 1:length(array)
        aa = array(j);
        b = (array(j) - 1) * 80 + 1;
        c = (array(j))*80;
        part = b:c;
        partArray = [partArray,part];        
    end
    tmp = tmp(:,array);
    tmp = tmp(partArray,:);
    path_save = fullfile(dstpath,fnames(i).name);
    M = tmp;
    save(path_save, 'M', '-v7.3');
end

%% Cut geovec
geopath = fullfile(datapath,'hks','horse');
dstpath = 'data/crop/hks/horse';
fnames = dir(fullfile(geopath, '*.mat'));
for i = 1 : length(fnames)
    fprintf('%s is processing.\n', fnames(i).name);
    tmp = load(fullfile(geopath, fnames(i).name));
    tmp = tmp.desc;
    max = 27894; %25289(dog);%19247(horse);%27894(cat)
    inter = (max - 1)/fix_num;
    array = 1:inter:max;
    array = fix(array);
    tmp = tmp(array,:);
    desc = tmp;
    path_save = fullfile(dstpath,fnames(i).name);
    save(path_save, 'desc', '-v7.3');
end

%% Labels
dstpath = 'data/crop/labels/';
labels = 1:fix_num + 1;

fnames = dir(fullfile(diskpath, '*.mat'));
for i = 1 : length(fnames)
    fprintf('%s saves labels.\n', fnames(i).name);
    path_save = fullfile(dstpath,fnames(i).name);
    save(path_save, 'labels', '-v7.3');
end

%% Create train list
% Manually seperate the data into two group, test and train
GetTxtFile(diskpath,'data/crop/descs/test/','test');
GetTxtFile(diskpath,'data/crop/descs/train/','train');

%% Concate desc data
  dstpath = 'data/crop/descs/';
  descpath1 = 'data/crop/hks/';
  descpath2 = 'data/crop/desc/';
  concate(descpath1,descpath2,dstpath);
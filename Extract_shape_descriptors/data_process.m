rng(42,'twister')
addpath(genpath('isc'))


%% HKS
srcpath = 'data/identical/';
dstpath = 'data/identical/hks/';

%srcpath = 'data/mutilple/';
%dstpath = 'data/multiple/hks/';

fnames = dir(fullfile(srcpath, '*.mat'));
for i = 1 : length(fnames)
    fprintf('%s computes HKS.\n', fnames(i).name);
    Hks(srcpath,fnames(i).name,dstpath);
end





rng(42,'twister')
addpath(genpath('isc'))
inter = 4;

%% Compute LBO
nLBO = 150;

extract_lbo('data/identical/mat/', 'data/identical/lbo', nLBO,inter);
%extract_lbo('data/multiple/mat/', 'data/multiple/lbo', nLBO,inter);

%% Compute GEOVEC
nGEOVEC = 150;
geovec_params = estimate_geovec_params('data/identical/lbo', nGEOVEC);
extract_geovec('data/identical/lbo', 'data/identical/geovec', geovec_params);

%geovec_params = estimate_geovec_params('data/multiple/lbo', nGEOVEC);
%extract_geovec('data/multiple/lbo', 'data/multiple/geovec', geovec_params);

%% Compute patch operator (disk)
patch_params.rad          = 0.01;    % disk radius 0.01
patch_params.flag_dist    = 'fmm';   % possible choices: 'fmm' or 'min'
patch_params.nbinsr       = 5;       % number of rings
patch_params.nbinsth      = 16;      % number of rays
patch_params.fhs          = 2.0;     % factor determining hardness of scale quantization
patch_params.fha          = 0.01;    % factor determining hardness of angle quantization
patch_params.geod_th      = true;
extract_patch_operator('data/identical/mat', 'data/identical/disk', patch_params);
%extract_patch_operator('data/multiple/shapes', 'data/multiple/disk', patch_params);

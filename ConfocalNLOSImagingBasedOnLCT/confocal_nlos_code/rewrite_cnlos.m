% 1. Choose your scene
%   1 - resolution chart at 40cm from wall
%   2 - resolution chart at 65cm from wall
%   3 - dot chart at 40cm from wall
%   4 - dot chart at 65cm from wall
%   5 - mannequin
%   6 - exit sign
%   7 - "SU" scene (default)
%   8 - outdoor "S"
%   9 - diffuse "S"
scene = 9;

% 2. Initial parameters
%    2.1 constant parameters
bin_resolution = 4e-12;     % time resolution (depended on TSCPC,Time-correlated Single Photon Counting)
c              = 3e8;       % speed of light

%    2.2 adjustable parameters
isbackprop = 0;             % toggle backpropagetion
isdiffuse  = 0;             % toggle diffuse
K          = 2;             % resample (Downsample) data to 4ps*2^{K} = 16ps for K = 2
snr        = 8e-1;          % 0.8, about -1dB
z_trim     = 60;            % Set first 600 bins to zeros

% 3. Paraperation
%    3.1 Change dir to data and code folder
cd('E:\code\matlab\NLOS\confocal_nlos_code')

%    3.2 Load data according to input scene number
switch scene
    case {1}
        load data_resolution_chart_40cm.mat
        z_offset = 350;
    case {2}
        load data_resolution_chart_65cm.mat
        z_offset = 700;
    case {3}
        load data_dot_chart_40cm.mat
        z_offset = 350;
    case {4}
        load data_dot_chart_65cm.mat
        z_offset = 700;
	case {5}
        load data_mannequin.mat
        z_offset = 300;
    case {6}
        load data_exit_sign.mat
        z_offset = 600;
    case {7}
        load data_s_u.mat
        z_offset = 800;
    case {8}
        load data_outdoor_s.mat
        z_offset = 700;
    case {9}
        load data_diffuse_s.mat
        z_offset = 100;
        
        % Scene 9 is diffuse, so we need to toggle the diffuse flag and 
        % adjust the snr
        isdiffuse = 1;
        % why change this? Is snr should be changed as `isdiffuse`
        % automatically?
        snr = snr .* 0.1;
end

N = size(rect_data, 1);     % Spatial Size
M = size(rect_data, 3);     % Temporal Size
range = M .* c .* bin_resolution;   % Length, maxium range for histogram

% Downsample data to 16 picoseconds
for l = 1 : K
    M = M ./ 2;
    bin_resolution = 2 * bin_resolution;
    rect_data = rect_data( :, :, 1: 2: end) + rect_data(:, :, 2: 2: end);
    z_trim = round(z_trim ./ 2);
    z_offset = round(z_offset ./ 2);
end

% Set first group of histogram bins to zero
% to remove direct component
rect_data(:, :, 1:z_trim) = 0;

% Define NLOS blur kernel
psf = definePsf(N, M, width ./ range)



%------------------------------------Set path
clc;

fp = mfilename('fullpath');
rootdir = fileparts(fp);
p{1} = fullfile(rootdir,'Demo');
p{2} = fullfile(rootdir,'image');
p{3} = fullfile(rootdir,'function');
p{4} = fullfile(rootdir,'TEST');

for i = 1:4
addpath(rootdir,p{i});
end
%------------------------------------

fprintf('TEST...Demo,...Image,...function,...All paths have been added');
fprintf('\n')
fprintf('----------------------------*---------------------------------\n');
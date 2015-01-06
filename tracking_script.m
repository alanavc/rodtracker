%% set up parameters for creating cells
% folder where segmented files are: e.g. '~/home/data/folder'
pars.folder='images_example';
% name of files: e.g. if file is 'datainfo001c1.tif', then write 'datainfo'
pars.filebasename='dfbwtlaciat37ct';
% number of digits: e.g. if file is 'datainfo001c1.tif', then write 3 (because of the 001)
pars.numdigits=2;
% channel index:  e.g. if file is 'datainfo001c1.tif', then write 3 'c1'
pars.indexchar='c1';
% file extension:  e.g. if file is 'datainfo001c1.tif', then write 3 'tif'
pars.fileext='tif';
% files numbers to be analyzed: for 'datainfo001c1.tif' to 'datainfo048c1.tif' write 1:48
pars.FILENUMS=1:30;
% color of bacteria from tif file: color label used in the segmentration (double check!)
pars.colorbacteria=1;
% minimal area of bacteria: in case some small areas have the same color as segmented bacteria
pars.minarea=100;
% maximal movement of cells (in pixels)
pars.maxmove=40; 
% maximal movement of poles after septation
pars.maxmovediv=(pars.maxmove)/2; %in pixels; for 3 min frames
% growth rate log(2)/doublingtime
pars.growth=log(2)/22; 
% time between frames
pars.framedist=3; %minutes
% error in percentage (increase if segmentation was not good)
pars.errorlength=.2; 
%%folder of fluorescence data.
pars.folderGFP='~/GIT_STUFF/rodtracker/images_example';
pars.filebasenameGFP='dfbwtlaciat37ct';
pars.numdigitsGFP=2;
pars.indexcharGFP='c2';
pars.fileextGFP='tif';
pars.FILENUMSGFP=pars.FILENUMS;
% file where all information will be saved ( .mat extension)
datafile='example.mat'; 

%% put information into matlab format (automatic)
read_data_fun(pars,datafile); 

%% correct 1 (manually): fix cells that show up as white and yellow
warning('off', 'Images:initSize:adjustingMag'); 
graph_manualcorrection1_fun(datafile,1)

%% make trivial corrections (automatic)
graph_red_fun(datafile)

%% correct 2 (manually): fix cells that show up as white and reduce "cyan/magenta clusters"
warning('off', 'Images:initSize:adjustingMag');
graph_manualcorrection2_fun(datafile,1)

%% check for errors (automatic): if errors are detected repeat previous step
check_for_errors_fun(datafile);

%% optimize movement (automatic)
graph_optimization_fun(datafile,1)

%% get data (automatic)
getdata_fun(datafile)

%% save data as csv file (automatic)
csvfile='example.csv';
getdata_csvfile_fun(datafile,csvfile)

%% plot lineage
M=csvread(csvfile);plot(M)


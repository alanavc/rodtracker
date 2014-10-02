function create_edges_fun(pars,outputfile)
%% Create Edges
load(outputfile);
ALLEDGES={};
parfor framenum=1:size(CELLS,2)-1, 
    disp(['making trajectories ' num2str(framenum) '->' num2str(framenum+1)]);
    cellsI=CELLS{framenum}; cellsF=CELLS{framenum+1}; 
    %numcellsI=size(cellsI,1); numcellsF=size(cellsF,1);
    Edges=createEDGES_nored(cellsI,cellsF,pars); ALLEDGES{framenum}=Edges;
end
save(outputfile ,'ALLEDGES','pars','-append');


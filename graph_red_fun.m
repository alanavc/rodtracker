function graph_red_fun(filename)
disp(' ')
disp('Reducing graph of transitions...')

load(filename,'ALLEDGESmanual','CELLS','CELLSMATRIX'); 

ALLEDGESmanualred=ALLEDGESmanual;

for ii=1:size(ALLEDGESmanualred,2), %disp(framenum)
    cellsI=CELLS{ii}; cellsF=CELLS{ii+1};
    numcellsI=size(cellsI,1); numcellsF=size(cellsF,1);
    matrixI=CELLSMATRIX{ii}; matrixF=CELLSMATRIX{ii+1};
    Edges=ALLEDGESmanualred{ii};    [Edgestemp,tracked0,tracked1]=reduceEDGES(Edges,numcellsI,numcellsF,zeros(1,numcellsI),zeros(1,numcellsF));
    while size(Edgestemp,1)<size(Edges,1), Edges=Edgestemp;
        [Edgestemp,tracked0,tracked1]=reduceEDGES(Edges,numcellsI,numcellsF,tracked0,tracked1);
    end
    Edges=Edgestemp;
    ALLEDGESmanualred{ii}=Edges;
end

save(filename ,'ALLEDGESmanualred','-append');

disp('DONE!')

function graph_manualcorrection2_fun(filename,framenum)
if nargin==1,framenum=1; end
load(filename,'ALLEDGESmanualred','CELLS','CELLSMATRIX'); 

%Manual Correction plus reduction
while framenum<=size(ALLEDGESmanualred,2), 
    disp(' ');
    disp(['Working on frames ' num2str(framenum) '->' num2str(framenum+1)]);
    cellsI=CELLS{framenum}; cellsF=CELLS{framenum+1};
    numcellsI=size(cellsI,1); numcellsF=size(cellsF,1);
    Edges=ALLEDGESmanualred{framenum};
    
    cellscurrent_with_neighbors=sort(Edges(:,1));
    cellsnext_with_neighbors=sort([ Edges(:,2); Edges(:,3)]);
    cellsnext_with_neighbors(cellsnext_with_neighbors==0)=[];
    
    
    if length(unique(cellscurrent_with_neighbors))==numcellsI && length(unique(cellsnext_with_neighbors))==numcellsF && ...
        isequal(cellscurrent_with_neighbors',1:numcellsI) && isequal(cellsnext_with_neighbors',1:numcellsF)
        framenum=framenum+1; continue;
    end

    if length(unique(cellscurrent_with_neighbors))~=numcellsI
        disp('ERROR: It seems that cells were lost (white). If so, declare it manually.')
    end
    if length(unique(cellsnext_with_neighbors))~=numcellsF
        disp('WARNING: It seems that new cells appeared (yellow). If so, no correction is necessary.')
    end
    if length(unique(cellsnext_with_neighbors))~= length(cellsnext_with_neighbors) || length(unique(cellscurrent_with_neighbors))~=length(cellscurrent_with_neighbors)
        disp('NOTE: More than single transitions were detected (cyan/magenta). Manually track if clusters are large.')
    end
    
    
    matrixI=CELLSMATRIX{framenum}; matrixF=CELLSMATRIX{framenum+1};    
    %f=plotcells2(Edges,cellsI,cellsF);
    [f1,f2]=plotcells6(Edges,matrixI,matrixF,zeros(1,numcellsI),numcellsI,numcellsF);
    figure(f1);
    [n,m]=size(CELLSMATRIX{1});
    %figscale=1;set(f2, 'Position', [0,0,figscale*[m,n]]); set(f1, 'Position', [0,0,figscale*[m,n]]);
    set(f1, 'name',['CURRENT FRAME (' num2str(framenum) '), click cell 1'],'NumberTitle','off');
    set(f2, 'name',['NEXT FRAME (' num2str(framenum+1) '), click cell 1'],'NumberTitle','off');
    disp('rightclick = go back and forth current and next frame');
    disp('leftclick = select cells');
    disp('ENTER = continue');
    but=1; cellindex=1; currentfig=f1;
    manualcellsI=[]; manualcellsJ=[]; manualcellsK=[]; 
    while but==1, [y,x,but]=ginput(1); x=round(x); y=round(y);
        if isempty(y), break; end
        outside=0;if x<=0 || x>n || y<=0 || y>m, outside=1; end
        if but==1, 
            if cellindex==1 && ~outside, manualcellsI(end+1)=matrixI(x,y);
            end
            if cellindex==2 && ~outside, manualcellsJ(end+1)=matrixF(x,y);
            end
            if cellindex==3 && ~outside, manualcellsK(end+1)=matrixF(x,y);
            end
            if cellindex==1 && outside, manualcellsI(end+1)=0; end
            if cellindex==2 && outside, manualcellsJ(end+1)=0; end
            if cellindex==3 && outside, manualcellsK(end+1)=0; end
            cellindex=mod(cellindex,3)+1;
            set(f1, 'name',['INITIAL FRAME (' num2str(framenum) '), click cell ' num2str(cellindex)]);
            set(f2, 'name',['FINAL FRAME (' num2str(framenum+1) '), click cell ' num2str(cellindex)]);
        end
        if but==3 && currentfig==f1, figure(f2); currentfig=f2;
        elseif but==3 && currentfig==f2, figure(f1); currentfig=f1; end
        but=1;
    end
    if isempty(manualcellsI), ALLEDGESmanualred{framenum}=Edges; close(f1); close(f2); framenum=framenum+1; continue; end
    %%remove extra points
    numpoints=min([length(manualcellsI),length(manualcellsJ),length(manualcellsK)]);
    manualcellsI=manualcellsI(1:numpoints); 
    manualcellsJ=manualcellsJ(1:numpoints);
    manualcellsK=manualcellsK(1:numpoints);
    %%remove bad points
    for i=numpoints:-1:1
        if manualcellsI(i)==0 || (manualcellsJ(i)==0 && manualcellsK(i)~=0) || (manualcellsJ(i)~=0 && manualcellsK(i)==0)
            manualcellsI(i)=[];manualcellsJ(i)=[];manualcellsK(i)=[];
        end
    end
    %%add points to edges
    for j=1:length(manualcellsI)
        if manualcellsJ(j)==manualcellsK(j); manualcellsK(j)=0; end
    end
    for i=1:length(manualcellsI)
        celli=manualcellsI(i); pos=find(Edges(:,1)==celli);
        Edges(pos,:)=[];
    end
    for j=1:length(manualcellsJ)
        cellj=manualcellsJ(j); pos=[find(Edges(:,2)==cellj);find(Edges(:,3)==cellj)];
        if cellj~=0, Edges(pos,:)=[]; end
    end
    for k=1:length(manualcellsK)
        cellk=manualcellsK(k); pos=[find(Edges(:,2)==cellk);find(Edges(:,3)==cellk)];
        if cellk~=0, Edges(pos,:)=[]; end
    end
    Edges=[Edges;[manualcellsI' manualcellsJ' manualcellsK']];
    pos0=find(Edges(:,1)==0); Edges(pos0,:)=[];
    [Edgestemp,tracked0,tracked1]=reduceEDGES(Edges,numcellsI,numcellsF,zeros(1,numcellsI),zeros(1,numcellsF));
    while size(Edgestemp,1)<size(Edges,1), Edges=Edgestemp;
        [Edgestemp,tracked0,tracked1]=reduceEDGES(Edges,numcellsI,numcellsF,tracked0,tracked1);
    end
    Edges=Edgestemp;
    ALLEDGESmanualred{framenum}=Edges; close(f1); close(f2);
    save(filename,'ALLEDGESmanualred','-append');
end
save(filename ,'ALLEDGESmanualred','-append');
close all hidden;

disp(' ')
disp('DONE!')

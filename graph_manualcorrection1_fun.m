function graph_manualcorrection1_fun(filename,framenum)
if nargin==1,framenum=1; end
load(filename,'pars','ALLEDGES','CELLS','CELLSMATRIX'); 

%check if there is a file with manual editing
allvars=whos('-file',filename );
if ~ismember('ALLEDGESmanual',{allvars.name}), ALLEDGESmanual=ALLEDGES; 
else ismember('ALLEDGESmanual',{allvars.name}), load(filename,'ALLEDGESmanual'); end
    
while framenum<=size(ALLEDGESmanual,2),
    disp(' ');
    disp(['Working on frames ' num2str(framenum) '->' num2str(framenum+1)]);
    cellsI=CELLS{framenum}; cellsF=CELLS{framenum+1};
    numcellsI=size(cellsI,1); numcellsF=size(cellsF,1);
    Edges=ALLEDGESmanual{framenum};
    
    cellscurrent_with_neighbors=unique(Edges(:,1));
    cellsnext_with_neighbors=unique([ Edges(:,2); Edges(:,3)]);
    if cellsnext_with_neighbors(1)==0, cellsnext_with_neighbors(1)=[]; end
    if length(cellscurrent_with_neighbors)==numcellsI && length(cellsnext_with_neighbors)==numcellsF
        framenum=framenum+1; continue;
    end
    if length(cellscurrent_with_neighbors)<numcellsI
        disp('ERROR: It seems that cells were lost (white). If so, declare it manually.')
    end
    if length(cellsnext_with_neighbors)<numcellsF
        disp('WARNING: It seems that new cells appeared (yellow). If so, no correction is necessary.')
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
            if cellindex==1 && ~outside, manualcellsI(end+1)=matrixI(x,y); end
            if cellindex==2 && ~outside, manualcellsJ(end+1)=matrixF(x,y); end
            if cellindex==3 && ~outside, manualcellsK(end+1)=matrixF(x,y); end
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
    if isempty(manualcellsI), ALLEDGESmanual{framenum}=Edges; close(f1); close(f2); framenum=framenum+1; continue; end
    %%remove extra points
    numpoints=min([length(manualcellsI),length(manualcellsJ),length(manualcellsK)]);
    manualcellsI=manualcellsI(1:numpoints);
    manualcellsJ=manualcellsJ(1:numpoints);
    manualcellsK=manualcellsK(1:numpoints);
    %%remove cells that appeared
    for i=1:numpoints
        if manualcellsI(i)==0 && manualcellsJ(i)~=0 && manualcellsJ(i)==manualcellsK(i)
            cellj=manualcellsJ(i); 
            pos=[]; if ~isempty(Edges), pos=find(Edges(:,1)==celli); end
            Edges(pos,:)=[];
        end
    end
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
        celli=manualcellsI(i); 
        pos=[]; if ~isempty(Edges),  pos=find(Edges(:,1)==celli); end
        Edges(pos,:)=[];
    end
    for j=1:length(manualcellsJ)
        cellj=manualcellsJ(j); 
        pos=[]; if ~isempty(Edges), pos=[find(Edges(:,2)==cellj);find(Edges(:,3)==cellj)]; end
        if cellj~=0, Edges(pos,:)=[]; end
    end
    for k=1:length(manualcellsK)
        cellk=manualcellsK(k); 
        pos=[]; if ~isempty(Edges), pos=[find(Edges(:,2)==cellk);find(Edges(:,3)==cellk)]; end
        if cellk~=0, Edges(pos,:)=[]; end
    end
    Edges=[Edges;[manualcellsI' manualcellsJ' manualcellsK']];
    pos0=[]; if ~isempty(Edges), pos0=find(Edges(:,1)==0); end
    Edges(pos0,:)=[];

    ALLEDGESmanual{framenum}=Edges; close(f1); close(f2);
    save(filename ,'ALLEDGESmanual','-append');
end
save(filename ,'ALLEDGESmanual','-append');
close all hidden;

disp(' ')
disp('DONE!')

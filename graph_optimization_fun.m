function graph_optimization_fun(filename,framenum0)
%framenum0=where to start
disp(' ')
disp('Finding the final transition graph...')

if nargin==1, framenum0=1; end

load(filename,'ALLEDGESmanualred','CELLS','pars'); %pars=pars;

%do not change values of ALLEDGESauto from 1 to framenum0-1
for i=framenum0:size(ALLEDGESmanualred,2)
    ALLEDGESauto{i}=ALLEDGESmanualred{i};
end 


for framenum=framenum0:size(ALLEDGESauto,2),%disp(framenum)
    t0=tic;
    Edges=ALLEDGESauto{framenum}; cellsI=CELLS{framenum}; cellsF=CELLS{framenum+1};
    numcellsI=size(cellsI,1); numcellsF=size(cellsF,1);
    [Edgestemp,tracked0,tracked1]=reduceEDGES(Edges,numcellsI,numcellsF,zeros(1,numcellsI),zeros(1,numcellsF));
    while size(Edgestemp,1)<size(Edges,1), Edges=Edgestemp;
        [Edgestemp,tracked0,tracked1]=reduceEDGES(Edges,numcellsI,numcellsF,tracked0,tracked1);
    end
    UNTRACKED0=find(tracked0==0); %UNTRACKED1=find(tracked1==0);
    %find 'weak' scc
    SCC0={}; SCC1={}; remaining_cells=UNTRACKED0;
    while ~isempty(remaining_cells), 
    scc0=remaining_cells(1); scc1=[]; repeated=0;
    while repeated==0, scc0temp=scc0; scc1temp=scc1;
        for ii=scc0
            indexj=find(Edges(:,1)==ii); 
            jj=unique([Edges(indexj,2)' Edges(indexj,3)']); jj(jj==0)=[];
            scc1temp=[scc1temp jj];
        end
        scc1temp=unique(scc1temp);
        for jj=scc1
            indexi=[find(Edges(:,2)==jj)' find(Edges(:,3)==jj)']; 
            ii=unique(Edges(indexi,1)'); ii(ii==0)=[];
            scc0temp=[scc0temp ii];
        end
        scc0temp=unique(scc0temp);
        if isequal(sort(scc0),sort(scc0temp)) && isequal(sort(scc1),sort(scc1temp)), repeated=1; end
        scc0=scc0temp; scc1=scc1temp;
    end
    SCC0{end+1}=scc0; SCC1{end+1}=scc1;
    remaining_cells=setdiff(remaining_cells,scc0);
    end
    %optimize edges for each scc
    max_cost=0; if isempty(SCC0), cost=0; end
    for iscc=1:length(SCC0)
        UNTRACKED0=SCC0{iscc}; UNTRACKED1=SCC1{iscc};
        NICEEDGES={}; MANYEDGES={Edges};UNTRACKED={UNTRACKED0};
        while ~isempty(MANYEDGES),
            [MANYEDGES,UNTRACKED,TEMPNICEEDGES]=spanconntree(MANYEDGES,UNTRACKED,cellsI,cellsF);
            NICEEDGES=[NICEEDGES(:)',TEMPNICEEDGES(:)'];
        end
        %disp([framenum length(NICEEDGES)]);
        Edges=NICEEDGES{1}; cost=costEdges(Edges,cellsI,cellsF,UNTRACKED0,UNTRACKED1,pars);
        for i=2:length(NICEEDGES)
            if cost<costEdges(NICEEDGES{i},cellsI,cellsF,UNTRACKED0,UNTRACKED1,pars), continue;end
            Edges=NICEEDGES{i}; cost=costEdges(Edges,cellsI,cellsF,UNTRACKED0,UNTRACKED1,pars);
            %disp(cost);
        end
        max_cost=max(cost,max_cost);
    end
    ALLEDGESauto{framenum}=Edges; 
    tend=toc(t0);
    if isempty(SCC0), max_scc=0; else max_scc=max(cellfun(@(x)length(x),SCC0(:))); end
    disp([num2str(framenum) ': max_scc=' num2str(max_scc) ',  dist=' num2str(max_cost) ', time=' num2str(tend)]);
    %
    save(filename,'ALLEDGESauto','-append');
end

disp('DONE!')
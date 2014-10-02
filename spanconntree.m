function [MANYEDGES,UNTRACKED,NICEEDGES]=spanconntree(OLDMANYEDGES,OLDUNTRACKED,cellsI,cellsF)

MANYEDGES={}; UNTRACKED={};NICEEDGES={};
for i=1:length(OLDMANYEDGES)
    [TEMPMANYEDGES,TEMPUNTRACKED]=localspanconntree(OLDMANYEDGES{i},cellsI,cellsF,OLDUNTRACKED{i});
    TEMPTEMPMANYEDGES={}; TEMPTEMPUNTRACKED={}; 
    for j=1:length(TEMPMANYEDGES)
        if isempty(TEMPUNTRACKED{j})
            NICEEDGES{end+1}=TEMPMANYEDGES{j};
        else
            TEMPTEMPMANYEDGES{end+1}=TEMPMANYEDGES{j};
            TEMPTEMPUNTRACKED{end+1}=TEMPUNTRACKED{j};
        end
    end
    %MANYEDGES={MANYEDGES{:},TEMPTEMPMANYEDGES{:}};
    %UNTRACKED={UNTRACKED{:},TEMPTEMPUNTRACKED{:}}; 
    MANYEDGES=[MANYEDGES(:)' TEMPTEMPMANYEDGES(:)'];
    UNTRACKED=[UNTRACKED(:)' TEMPTEMPUNTRACKED(:)'];
end

end




function [MANYEDGES,UNTRACKED]=localspanconntree(Edges,cellsI,cellsF,untracked)
if isempty(untracked), MANYEDGES={Edges};UNTRACKED={untracked};return;end

ui=untracked(1); pos=find(ui==Edges(:,1));
numcellsI=size(cellsI,1); numcellsF=size(cellsF,1);
MANYEDGES={};UNTRACKED={};
for p=pos'
    tempEdges=Edges;
    tempEdges(p,:)=[];
    numicells=length(unique(tempEdges(:,1)));
    numjcells=length(unique([tempEdges(:,2);tempEdges(:,3);0]))-1;
    if numicells==numcellsI %&& numjcells==numcellsF
        [MANYEDGES{end+1},tracked0]=reduceEDGES(tempEdges,numcellsI,numcellsF);
        untracked0temp=find(tracked0==0); 
        untracked0temp(~ismember(untracked0temp,untracked))=[];
        UNTRACKED{end+1}=untracked0temp;
    end
end
end

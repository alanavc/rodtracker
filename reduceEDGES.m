function [Edges,tracked0,tracked1]=reduceEDGES(Edges,numcellsI,numcellsF,tracked0,tracked1)

if nargin<=4, tracked0=zeros(1,numcellsI); tracked1=zeros(1,numcellsF);end

repeated=0;
while repeated==0
    tracked0temp=tracked0; tracked1temp=tracked1;
    for i=1:numcellsI
        pos=find(i==Edges(:,1)); pos0=find(Edges(pos,2)'==0,1);
        if ~isempty(pos0)
            Edges(setdiff(pos,pos(pos0)),:)=[]; tracked0(i)=1;
        end
        if length(pos)==1 && isempty(pos0),  j=Edges(pos,2); k=Edges(pos,3);
            if k==0,
                rep=[find(j==Edges(:,2));find(j==Edges(:,3))];
            else
                rep=[find(j==Edges(:,2));find(j==Edges(:,3));find(k==Edges(:,2));find(k==Edges(:,3))];
            end
            Edges(rep,:)=[]; Edges(end+1,:)=[i j k];
            tracked0(i)=1; tracked1(j)=1;
            if k~=0, tracked1(k)=1;end
        end
    end
    
    for j=1:numcellsF
        pos=[find(j==Edges(:,2));find(j==Edges(:,3))];
        if length(pos)==1, i=Edges(pos,1);
            if j==Edges(pos,2), k=Edges(pos,3); else k=Edges(pos,2);end
            if k==0
                rep=find(i==Edges(:,1));
            else
                rep=[find(i==Edges(:,1)); find(k==Edges(:,2)); find(k==Edges(:,3))];
            end
            Edges(rep,:)=[]; Edges(end+1,:)=[i j k];
            tracked0(i)=1; tracked1(j)=1;
            if k~=0, tracked1(k)=1;end
        end
    end
    if isequal(tracked0temp,tracked0) && isequal(tracked1temp,tracked1), repeated=1; end
end
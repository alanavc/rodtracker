function [f1,f2]=plotcells6(Edges,cellsI,cellsF,tracked0,numcellsI,numcellsF)
mn=size(cellsI);


if nargin==3, tracked0=zeros(1,numcellsI);end

matrixItracked=zeros(mn); matrixFtracked=zeros(mn);
matrixIuntracked=zeros(mn); matrixFuntracked=zeros(mn);
matrixI0tracked=zeros(mn); matrixF0tracked=zeros(mn);

for l=1:size(Edges,1)
    i=Edges(l,1); j=Edges(l,2);k=Edges(l,3);
    if tracked0(i)==1
        matrixItracked(cellsI==i)=1;
        if j~=0, matrixFtracked(cellsF==j)=1; end
        if k~=0, matrixFtracked(cellsF==k)=1; end
    end
end
%plot untracked cells from initial frame
for i=1:numcellsI
    pos=find(i==Edges(:,1));
    if length(pos)>1
        matrixIuntracked(cellsI==i)=1; matrixItracked(cellsI==i)=0;
    end
    if length(pos)==1, matrixItracked(cellsI==i)=1;end
    if isempty(pos), matrixI0tracked(cellsI==i)=1; end
end
%plot untracked cells from final frame
for j=1:numcellsF
    pos=[find(j==Edges(:,2));find(j==Edges(:,3))];
    if length(pos)>1
        matrixFuntracked(cellsF==j)=1; matrixFtracked(cellsF==j)=0;
    end
    if length(pos)==1, matrixFtracked(cellsF==j)=1; end
    if isempty(pos), matrixF0tracked(cellsF==j)=1; end
end

matrixI1=zeros([mn 3]);
matrixI1(:,:,1)=matrixI0tracked;
matrixI1(:,:,2)=max(matrixIuntracked,matrixI0tracked);
matrixI1(:,:,3)=max(matrixItracked,matrixIuntracked).*(1-matrixI0tracked);
%matrixI1(:,:,3)=max(max(matrixItracked,matrixI0tracked),matrixIuntracked);
matrixF1=zeros([mn 3]);
matrixF1(:,:,1)=max(max(matrixFtracked,matrixF0tracked),matrixFuntracked);
matrixF1(:,:,2)=matrixF0tracked;
matrixF1(:,:,3)=matrixFuntracked.*(1-matrixF0tracked);
%matrixF1(:,:,3)=max(matrixFuntracked,matrixF0tracked);

f1=figure; imshow(matrixI1);
f2=figure; imshow(matrixF1);
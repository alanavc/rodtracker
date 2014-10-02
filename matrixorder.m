function MM=matrixorder(ALLEDGES,initialcell,framenum)

[W,cellindex]=traj(ALLEDGES,initialcell,framenum);
newframenum=framenum+length(W)-1;

if newframenum>length(ALLEDGES), MM=W; return; end
pos=find(cellindex==ALLEDGES{newframenum}(:,1));
cellj=ALLEDGES{newframenum}(pos,2);
cellk=ALLEDGES{newframenum}(pos,3);

Mj=[];Mk=[];
if cellj~=0, Mj=matrixorder(ALLEDGES,cellj,newframenum+1); end
if cellk~=0, Mk=matrixorder(ALLEDGES,cellk,newframenum+1); end
if size(Mj,1)==size(Mk,1), MM=[Mj Mk]; end
if size(Mj,1)<size(Mk,1), MM=[[Mj;NaN(size(Mk,1)-size(Mj,1),size(Mj,2))] Mk]; end
if size(Mj,1)>size(Mk,1), MM=[Mj [Mk;NaN(size(Mj,1)-size(Mk,1),size(Mk,2))]]; end
MM=[W NaN(length(W),size(MM,2)); NaN(size(MM,1),1) MM];
end

function [W,cellindex]=traj(ALLEDGES,initialcell,frame)
cellindex=initialcell;
W=cellindex;
for i=frame:length(ALLEDGES)
    pos=find(cellindex==ALLEDGES{i}(:,1));
    cellj=ALLEDGES{i}(pos,2);
    cellk=ALLEDGES{i}(pos,3);
    if cellk~=0 || cellj==0, break;end
    cellindex=cellj;
    W(end+1)=cellindex;
end
W=W';
end
    

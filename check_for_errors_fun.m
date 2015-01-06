function [BAD_FRAMEScurrent,BAD_FRAMESnext]=check_for_errors_fun(filename)
load(filename);

BAD_FRAMEScurrent=[];
BAD_FRAMESnext=[];

for ii=1:size(ALLEDGESmanualred,2), %disp(framenum)
    numcellsI=size(CELLS{ii},1); numcellsF=size(CELLS{ii+1},1);
    Edges=ALLEDGESmanualred{ii};
    for i=1:numcellsI
        pos=find(Edges(:,1)==i,1);
        if isempty(pos), BAD_FRAMEScurrent(end+1)=ii; break; end
    end
    for j=1:numcellsF
        pos=find([Edges(:,2);Edges(:,3)]==j,1);
        if isempty(pos), BAD_FRAMESnext(end+1)=ii; break; end
    end
end

if isempty(BAD_FRAMEScurrent) && isempty(BAD_FRAMESnext)
    disp('NO ERRORS FOUND'); 
end

if ~isempty(BAD_FRAMEScurrent)
    disp('ERROR IN *CURRENT FRAME* ! Some frames contain cells that may have lost cells.'); 
    disp('Use graph_manualcorrection2_fun again.'); 
    disp('FRAMES WITH ERRORS:')
    disp(BAD_FRAMEScurrent);
end

if ~isempty(BAD_FRAMESnext)
    disp('WARNING IN *NEXT FRAME* ! Some frames contain cells that may have new cells.'); 
    disp('Use graph_manualcorrection2_fun again (if necessary).'); 
    disp('FRAMES WITH WARNINGS:')
    disp(BAD_FRAMESnext);
end

function getdata_fun(outputfile,pars0)

load(outputfile); 

if nargin==2, pars=pars0; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
folder=pars.folderGFP;
filebasename=pars.filebasenameGFP;
numdigits=pars.numdigitsGFP;
indexchar=pars.indexcharGFP;
fileext=pars.fileextGFP;
FILENUMS=pars.FILENUMSGFP;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

operating_system='linux';
if strcmp(operating_system,'linux'), sep='/'; end
if strcmp(operating_system,'windows'), sep='\'; end

NUMINITIALCELLS=size(ALLEDGESauto{1},1); 
%% get fluorescence data
expand=0; cutpole=0;

parfor initialcell=1:NUMINITIALCELLS, disp(initialcell)
    Morder=matrixorder(ALLEDGESauto,initialcell,1);
    Morder=[Morder;zeros(length(FILENUMS)-size(Morder,1),size(Morder,2))];
    Mfp=NaN(size(Morder));
    Iorder=labelcells(Morder,num2str(initialcell));
    for filenum=1:length(FILENUMS)
        file_index=num2str(FILENUMS(filenum));
        for i=1:numdigits-length(file_index),file_index=['0' file_index];end
        filename=[folder sep filebasename file_index indexchar '.' fileext];
        F=imread(filename);
        M=CELLSMATRIX{filenum};
        numcells=size(CELLS{filenum},1);
        for cellindex=1:numcells
            Mtemp=M==cellindex;
            if expand>0
                se = strel('disk',expand);
                if cutpole>0
                    [rr,cc] = meshgrid(1:size(M,2),1:size(M,1));
                    P1=CELLS{filenum}(cellindex,[1,2]);
                    P2=CELLS{filenum}(cellindex,[end-1,end]);
                    Mtemp=Mtemp.*((rr-P1(1)).^2+(cc-P1(2)).^2>cutpole^2).*((rr-P2(1)).^2+(cc-P2(2)).^2>cutpole^2);
                end
                Mtemp=imdilate(Mtemp,se);
            end
            Mfp(filenum,cellindex==Morder(filenum,:))=mean(F(Mtemp==1));
        end
    end
    MATRIXFP{initialcell}=Mfp;
    LABELS{initialcell}=Iorder;
end
save(outputfile,'MATRIXFP','LABELS','-append'); 
disp('fluorescence data saved')


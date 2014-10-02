function getdata_back_fun(outputfile,pars)

load(outputfile);

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
    Morder=matrixorder(ALLEDGESauto,initialcell,1);Mfp=NaN(size(Morder));
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
            %looking back one frame vvvvv
            if filenum<length(FILENUMS)
                Edges=ALLEDGESauto{filenum}; pos=find(cellindex==Edges(:,1));
                [m1,m2]=size(CELLSMATRIX{filenum});
                [XX,YY]=meshgrid(1:m2,1:m1);
                if Edges(pos,3)~=0
                    cellindexj=Edges(pos,2);
                    cellindexk=Edges(pos,3);
                    cellsM=CELLSMATRIX{filenum};
                    CELLSpre=CELLS{filenum};
                    CELLSpost=CELLS{filenum+1};
                    celli=CELLSpre(cellindex,:);
                    cellj=CELLSpost(cellindexj,:);
                    cellk=CELLSpost(cellindexk,:);
                    %setting up equation Ax+By=C
                    [~,~,Fjk]=sort_poles(celli,cellj,cellk);
                    v=celli(5:6)-celli(1:2);
                    if Fjk==0
                        divpoint=finddiv_point(celli,cellj,cellk);
                        C=v*divpoint'; POSj=XX*v(1)+YY*v(2)<=C;
                        POSITIONSj=(cellsM==cellindex).*POSj;
                        POSITIONSk=(cellsM==cellindex).*(~POSj);
                    else
                        divpoint=finddiv_point(celli,cellk,cellj);
                        C=v*divpoint'; POSj=XX*v(1)+YY*v(2)>C;
                        POSITIONSj=(cellsM==cellindex).*POSj;
                        POSITIONSk=(cellsM==cellindex).*(~POSj);
                    end
                    mfpj=mean(F(POSITIONSj==1));
                    mfpk=mean(F(POSITIONSk==1));
                    Mfp(filenum,cellindexj==Morder(filenum+1,:))=mfpj;
                    Mfp(filenum,cellindexk==Morder(filenum+1,:))=mfpk;
                    Mfp(filenum,cellindex==Morder(filenum,:))=NaN;
                end
            end
            %Mfp(filenum,cellindex==Morder(filenum,:))=mean(F(Mtemp==1));
            %end looking back one frame ^^^^^
        end
    end
    MATRIXFP{initialcell}=Mfp;
    LABELS{initialcell}=Iorder;
end
save(outputfile,'MATRIXFP','LABELS','-append');


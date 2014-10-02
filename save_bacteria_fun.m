function save_bacteria_fun(pars,outputfile)
%%%%%%%%%%%%% update this
%input folder
folder=pars.folder;
%name of file, number of digits, index (e.g. c1), extension (e.g. tif)
filebasename=pars.filebasename;
numdigits=pars.numdigits;
indexchar=pars.indexchar;
fileext=pars.fileext;
%numbering of files, e.g. FILENUMS=1:62;
FILENUMS=pars.FILENUMS;
%range of colors to be declared as cells
colorofbacteria=pars.colorbacteria;
%minimum number of pixels to count as a cell
minarea=pars.minarea; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

colorofbacteria0=colorofbacteria(1);
operating_system='linux';
if strcmp(operating_system,'linux'), sep='/'; end
if strcmp(operating_system,'windows'), sep='\'; end

parfor j=1:length(FILENUMS), disp(['reading frame ' num2str(j)]);
    filenum=FILENUMS(j);
    file_index=num2str(filenum);
    for i=1:numdigits-length(file_index)
        file_index=['0' file_index];
    end
    filename=[folder sep filebasename file_index indexchar '.' fileext];
    M=imread(filename); %imshow(M==colorofbacteria);
    for c=colorofbacteria, M(M==c)=colorofbacteria0; end
    M=(M==colorofbacteria0);
    Mtemp=bwlabel(M); PROP = regionprops(M,'Area');
    ind = find([PROP.Area] >= minarea);
    M = ismember(Mtemp,ind);
    [CELLSMATRIX{j},numcells] = bwlabel(M,4);
    CELLS{j}=zeros(numcells,6);
    for i=1:numcells
        L=zeros(size(CELLSMATRIX{j})); L(CELLSMATRIX{j}==i)=1;
        stats=regionprops(L,'Centroid');
        rc=contourc(L,[.5,.5]);num_points=rc(2,1);
        a=0;rc1best=[];rc2best=rc1best;
        for k1=1:num_points-1
            for k2=k1+1:num_points
                rc1=rc(:,k1+1)'; rc2=rc(:,k2+1)';
                if norm(rc1-rc2)>a,
                    a=norm(rc1-rc2); rc1best=rc1; rc2best=rc2;
                    
                end
            end
        end
        CELLS{j}(i,:)=[rc1best stats.Centroid rc2best];
    end
end
save(outputfile,'CELLS','CELLSMATRIX','pars');

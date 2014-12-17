function getdata_csvfile_fun(outputfile,csvfile)

load(outputfile,'MATRIXFP'); 

ALLDATA=[];
for i=1:length(MATRIXFP)
    M=MATRIXFP{i};
    [~,n]=size(M);
    ALLDATA(:,end+1:end+n)=M;
end
csvwrite(csvfile,ALLDATA);





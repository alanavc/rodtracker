function Iorder=labelcells(Morder,initiallabel)

Iorder{1,1}=[initiallabel '_']; Iorder{size(Morder,1),size(Morder,2)}=[];
for i=2:size(Morder,1), for j=1:size(Morder,2)
    if ~isnan(Morder(i,j)) && ~isnan(Morder(i-1,j))
        Iorder{i,j}=Iorder{i-1,j};
    end
    if ~isnan(Morder(i,j)) && isnan(Morder(i-1,j))
        if ~isnan(Morder(i-1,j-1)), Iorder{i,j}=[Iorder{i-1,j-1} '0']; 
        else 
            for k=j-1:-1:1, 
                if ~isnan(Morder(i-1,k)), Iorder{i,j}=[Iorder{i-1,k} '1']; end
            end
        end
    end
end; end



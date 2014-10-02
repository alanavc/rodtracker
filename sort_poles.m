function [Fj,Fk,Fjk]=sort_poles(celli,cellj,cellk)

polesi=celli([1,2,end-1,end]);
polesj=cellj([1,2,end-1,end]); centerj=cellj(3:end-2);


oldpolei=polesi([1 2]); newpolei=polesi([end-1,end]);
pole0j=polesj([1 2]); pole1j=polesj([end-1,end]);
if nargin==2
    distij0=norm([oldpolei,newpolei]-[pole0j,pole1j]);
    distij1=norm([oldpolei,newpolei]-[pole1j,pole0j]);
    if distij0>distij1, Fj=1; else Fj=0; end
    Fk=0; Fjk=0;
end

if nargin==3
    polesk=cellk([1,2,end-1,end]); centerk=cellk(3:end-2);
    pole0k=polesk([1 2]); pole1k=polesk([end-1,end]);
    mindist=Inf;
    for flipj=0:1
        for flipk=0:1
            for flipjk=0:1
                if flipj==0, OLD=[pole0j centerj pole1j]; 
                else OLD=[pole1j centerj pole0j]; end
                if flipk==0, NEW=[pole0k centerk pole1k]; 
                else NEW=[pole1k centerk pole0k]; end
                if flipjk==1, temp=OLD; OLD=NEW; NEW=temp; end
                divpoint=finddiv_point(celli,OLD,NEW);
                distij=norm([oldpolei,divpoint]-OLD([1 2 5 6]));
                distik=norm([divpoint,newpolei]-NEW([5 6 1 2]));
                distijk=distij+distik;
                if distijk<mindist, mindist=distijk; Fjk=flipjk; Fj=flipj; Fk=flipk; end
            end
        end
    end
end
end


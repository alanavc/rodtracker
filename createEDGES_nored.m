function Edges=createEDGES_nored(cellsI,cellsF,pars)
maxmove=pars.maxmove;
maxmovediv=pars.maxmovediv;
growth=pars.growth;
framedist=pars.framedist;
errorlength=pars.errorlength;

numcellsI=size(cellsI,1); numcellsF=size(cellsF,1);

Edges=[];
for i=1:numcellsI, %fprintf('%d ', i); fprintf('\n')
    c0=cellsI(i,[3,4]); p0a=cellsI(i,[1,2]); p0b=cellsI(i,[5,6]);
    l0= norm(p0a-c0)+norm(c0-p0b);
    %
    for j=1:numcellsF
        c1=cellsF(j,[3,4]); p1a=cellsF(j,[1,2]); p1b=cellsF(j,[5,6]);
        l1= norm(p1a-c1)+norm(c1-p1b);
        if abs(l1/l0-exp(framedist*growth))<errorlength && norm(c0-c1)<maxmove
            Edges(end+1,:)=[i j 0];
        end
    end
    %
    for j=1:numcellsF-1
        c1=cellsF(j,[3,4]); p1a=cellsF(j,[1,2]); p1b=cellsF(j,[5,6]);
        for k=j+1:numcellsF,
            c2=cellsF(k,[3,4]); p2a=cellsF(k,[1,2]); p2b=cellsF(k,[5,6]);
            l1= norm(p1a-c1)+norm(c1-p1b); l2= norm(p2a-c2)+norm(c2-p2b);
            if abs((l1+l2)/l0-exp(framedist*growth))<errorlength && min([norm(p2a-p1a) norm(p2b-p1a) norm(p2a-p1b) norm(p2b-p1b)])<maxmovediv
                P1=c0-p0a; P2=p0b-c0; s=norm(P1)/(norm(P1)+norm(P2));
                div=l1/(l1+l2); splitpoint1=(div<s)*(p0a+(div/s)*P1)+(div>=s)*(c0+(div-s)/(1-s)*P2);
                div=l2/(l1+l2); splitpoint2=(div<s)*(p0a+(div/s)*P1)+(div>=s)*(c0+(div-s)/(1-s)*P2);
                c01a=(splitpoint1+p0a)/2; c01b=(splitpoint1+p0b)/2;
                c02a=(splitpoint2+p0a)/2; c02b=(splitpoint2+p0b)/2;
                d1=max([norm(c01a-c1) norm(c01b-c2)]);
                d2=max([norm(c02a-c2) norm(c02b-c1)]);
                if d1<maxmove || d2<maxmove
                    Edges(end+1,:)=[i j k];
                end
            end
        end
    end
end
return
for scale=[1.5 2 2.5 3 3.5 4]
    maxmove=scale*pars.maxmove; maxmovediv=scale*pars.maxmovediv;
    for i=1:numcellsI, %fprintf('%d ', i); fprintf('\n')
        if ~isempty(find(i==Edges(:,1),1)), continue; end
        c0=cellsI(i,[3,4]); p0a=cellsI(i,[1,2]); p0b=cellsI(i,[5,6]);
        l0= norm(p0a-c0)+norm(c0-p0b);
        %
        for j=1:numcellsF
            c1=cellsF(j,[3,4]); p1a=cellsF(j,[1,2]); p1b=cellsF(j,[5,6]);
            l1= norm(p1a-c1)+norm(c1-p1b);
            if abs(l1/l0-exp(framedist*growth))<errorlength && norm(c0-c1)<maxmove
                Edges(end+1,:)=[i j 0];
            end
        end
        %
        for j=1:numcellsF-1
            c1=cellsF(j,[3,4]); p1a=cellsF(j,[1,2]); p1b=cellsF(j,[5,6]);
            for k=j+1:numcellsF,
                c2=cellsF(k,[3,4]); p2a=cellsF(k,[1,2]); p2b=cellsF(k,[5,6]);
                l1= norm(p1a-c1)+norm(c1-p1b); l2= norm(p2a-c2)+norm(c2-p2b);
                if abs((l1+l2)/l0-exp(framedist*growth))<errorlength && min([norm(p2a-p1a) norm(p2b-p1a) norm(p2a-p1b) norm(p2b-p1b)])<maxmovediv
                    P1=c0-p0a; P2=p0b-c0; s=norm(P1)/(norm(P1)+norm(P2));
                    div=l1/(l1+l2); splitpoint1=(div<s)*(p0a+(div/s)*P1)+(div>=s)*(c0+(div-s)/(1-s)*P2);
                    div=l2/(l1+l2); splitpoint2=(div<s)*(p0a+(div/s)*P1)+(div>=s)*(c0+(div-s)/(1-s)*P2);
                    c01a=(splitpoint1+p0a)/2; c01b=(splitpoint1+p0b)/2;
                    c02a=(splitpoint2+p0a)/2; c02b=(splitpoint2+p0b)/2;
                    d1=max([norm(c01a-c1) norm(c01b-c2)]);
                    d2=max([norm(c02a-c2) norm(c02b-c1)]);
                    if d1<maxmove || d2<maxmove
                        Edges(end+1,:)=[i j k];
                    end
                end
            end
        end
    end
end

for scale=[1.5 2 2.5 3 3.5 4]
    maxmove=scale*pars.maxmove; maxmovediv=scale*pars.maxmovediv;
    for j=1:numcellsF
        if ~isempty(find(j==[Edges(:,2);Edges(:,3)],1)), continue; end
        c1=cellsF(j,[3,4]); p1a=cellsF(j,[1,2]); p1b=cellsF(j,[5,6]);
        l1= norm(p1a-c1)+norm(c1-p1b);
        for i=1:numcellsI, %fprintf('%d ', i); fprintf('\n')
            c0=cellsI(i,[3,4]); p0a=cellsI(i,[1,2]); p0b=cellsI(i,[5,6]);
            l0= norm(p0a-c0)+norm(c0-p0b);
            if abs(l1/l0-exp(framedist*growth))<errorlength && norm(c0-c1)<maxmove
                Edges(end+1,:)=[i j 0];
            end
        end
        
    end
end

for scale=[1.5 2 2.5 3 3.5 4]
    maxmove=scale*pars.maxmove; maxmovediv=scale*pars.maxmovediv;
    for j=1:numcellsF-1
        if ~isempty(find(j==[Edges(:,2);Edges(:,3)],1)), continue; end
        c1=cellsF(j,[3,4]); p1a=cellsF(j,[1,2]); p1b=cellsF(j,[5,6]);
        for i=1:numcellsI, %fprintf('%d ', i); fprintf('\n')
            c0=cellsI(i,[3,4]); p0a=cellsI(i,[1,2]); p0b=cellsI(i,[5,6]);
            l0= norm(p0a-c0)+norm(c0-p0b);
            for k=j+1:numcellsF,
                c2=cellsF(k,[3,4]); p2a=cellsF(k,[1,2]); p2b=cellsF(k,[5,6]);
                l1= norm(p1a-c1)+norm(c1-p1b); l2= norm(p2a-c2)+norm(c2-p2b);
                if abs((l1+l2)/l0-exp(framedist*growth))<errorlength && min([norm(p2a-p1a) norm(p2b-p1a) norm(p2a-p1b) norm(p2b-p1b)])<maxmovediv
                    P1=c0-p0a; P2=p0b-c0; s=norm(P1)/(norm(P1)+norm(P2));
                    div=l1/(l1+l2); splitpoint1=(div<s)*(p0a+(div/s)*P1)+(div>=s)*(c0+(div-s)/(1-s)*P2);
                    div=l2/(l1+l2); splitpoint2=(div<s)*(p0a+(div/s)*P1)+(div>=s)*(c0+(div-s)/(1-s)*P2);
                    c01a=(splitpoint1+p0a)/2; c01b=(splitpoint1+p0b)/2;
                    c02a=(splitpoint2+p0a)/2; c02b=(splitpoint2+p0b)/2;
                    d1=max([norm(c01a-c1) norm(c01b-c2)]);
                    d2=max([norm(c02a-c2) norm(c02b-c1)]);
                    if d1<maxmove || d2<maxmove
                        Edges(end+1,:)=[i j k];
                    end
                end
            end
        end
    end
end


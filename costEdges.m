function E=costEdges(Edges,cellsI,cellsF,UNTRACKED0,UNTRACKED1,pars)

framedist=pars.framedist;
growth=pars.growth;
numcellsI=size(cellsI,1); numcellsF=size(cellsF,1);
UNTRACKED1=[];

for i=UNTRACKED0
    pos=find(i==Edges(:,1));
    if length(pos)~=1,E=inf;return;end
end

for j=UNTRACKED1
    pos=[find(j==Edges(:,2)) find(j==Edges(:,3))];
    if length(pos)~=1,E=inf;return;end
end

E=0;

for  i=UNTRACKED0
    pos=find(i==Edges(:,1)); j=Edges(pos,2); k=Edges(pos,3);
    c0=cellsI(i,[3,4]); p0a=cellsI(i,[1,2]); p0b=cellsI(i,[5,6]);
    l0= norm(p0a-c0)+norm(c0-p0b);
    c1=cellsF(j,[3,4]); p1a=cellsF(j,[1,2]); p1b=cellsF(j,[5,6]);
    l1= norm(p1a-c1)+norm(c1-p1b);
    if k==0
        sizeerror=abs(l1/l0-exp(framedist*growth));
        moveerror=norm(c0-c1);
        divmoveerror=0;
    end
    if k~=0
        c2=cellsF(k,[3,4]); p2a=cellsF(k,[1,2]); p2b=cellsF(k,[5,6]);
        l1= norm(p1a-c1)+norm(c1-p1b); l2= norm(p2a-c2)+norm(c2-p2b);
        sizeerror=abs((l1+l2)/l0-exp(framedist*growth));
        divmoveerror=min([norm(p2a-p1a) norm(p2b-p1a) norm(p2a-p1b) norm(p2b-p1b)]);
        P1=c0-p0a; P2=p0b-c0; s=norm(P1)/(norm(P1)+norm(P2));
        div=l1/(l1+l2); splitpoint1=(div<s)*(p0a+(div/s)*P1)+(div>=s)*(c0+(div-s)/(1-s)*P2);
        div=l2/(l1+l2); splitpoint2=(div<s)*(p0a+(div/s)*P1)+(div>=s)*(c0+(div-s)/(1-s)*P2);
        c01a=(splitpoint1+p0a)/2; c01b=(splitpoint1+p0b)/2;
        c02a=(splitpoint2+p0a)/2; c02b=(splitpoint2+p0b)/2;
        d1=max([norm(c01a-c1) norm(c01b-c2)]);
        d2=max([norm(c02a-c2) norm(c02b-c1)]);
        moveerror=min([d1,d2]);
    end
    E=E+sizeerror+moveerror+divmoveerror;
end






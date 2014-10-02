function splitpoint=finddiv_point(cell0,cell1,cell2)
c0=cell0([3,4]); p0a=cell0([1,2]); p0b=cell0([end-1,end]);
c1=cell1([3,4]); p1a=cell1([1,2]); p1b=cell1([end-1,end]);
c2=cell2([3,4]); p2a=cell2([1,2]); p2b=cell2([end-1,end]);

l1= norm(p1a-c1)+norm(c1-p1b); l2= norm(p2a-c2)+norm(c2-p2b);
P1=c0-p0a; P2=p0b-c0;
s=norm(P1)/(norm(P1)+norm(P2));

%relative split position and split position
div=l1/(l1+l2); 
splitpoint=(div<s)*(p0a+(div/s)*P1)+(div>=s)*(c0+(div-s)/(1-s)*P2);

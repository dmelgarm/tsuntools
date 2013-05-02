function [xout yout h hu hv eta]=get_point_in_grid(xi,yi,x1,y1,dx,dy,mx,my,data)

%The information contains cell lower left corners NOT centers
xs=x1+(dx/2):dx:x1+(dx/2)+dx*(mx-1)';
ys=y1+(dy/2):dy:y1+(dy/2)+dy*(my-1)';
[xs ys]=meshgrid(xs,ys);
xs=reshape(xs',numel(xs),1);
ys=reshape(ys',numel(ys),1);
d=sqrt((xi-xs).^2+(yi-ys).^2);
[mind nd]=min(d);
h=data(nd,1);
hu=data(nd,2);
hv=data(nd,3);
eta=data(nd,4);
xout=xs(nd);
yout=ys(nd);






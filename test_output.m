function test_output(D,xlow,ylow,dx,dy)

D=cell2mat(D);
i=0;
col=4;
grid=1;
for ky=1:42
    for kx=1:42
        i=i+1;
        d1(i)=D(1,i);
        d2(i)=D(2,i);
        d3(i)=D(3,i);
        d4(i)=D(4,i);
        lon(i)=xlow(grid)+(kx-1)*dx(grid);
        lat(i)=ylow(grid)+(ky-1)*dy(grid);
    end
end
figure
scatter3(lon,lat,d1,[],d1,'s','LineWidth',6)
colorbar
view([0 90])
figure
scatter3(lon,lat,d2,[],d2,'s','LineWidth',6)
colorbar
view([0 90])
figure
scatter3(lon,lat,d3,[],d3,'s','LineWidth',6)
colorbar
view([0 90])
figure
scatter3(lon,lat,d4,[],d4,'s','LineWidth',6)
colorbar
view([0 90])
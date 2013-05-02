function inundation(modelpath,Nframes)

%Get inundation at all points in coastline for all frames
cd([modelpath])
%Load survey data and cut to only desired area
surveypath='/Users/dmelgarm/Research/Data/Tohoku/Inundation/'
[xs ys Hs]=textread([surveypath 'inund_good.dat'],'%f%f%f');
i=find(ys>=36 & ys<=41);
xs=xs(i);
ys=ys(i);
Hs=Hs(i);
%Get inundation (will get irregular grid)
for k=1:Nframes
    display(['Extracting inundation at frame ' num2str(k) ' of ' num2str(Nframes) ' ...'])
    frameno=k-1;
    [xi(:,k) yi(:,k) h(:,k) hu(:,k) hv(:,k) eta(:,k)]=get_inundation(frameno,xs,ys);
end
save('inundation.mat','xi','yi','xs','ys','h','hu','hv','eta')

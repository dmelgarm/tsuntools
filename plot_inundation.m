function plot_inundation(run)

close all
path=['/Volumes/Kanagawa/Tohoku/HiResW_' run];
%cd /Volumes/Elements/Tsunami/RTOTohoku_Gauges_0031/
%cd ~/bin/clawpack-4.6.3/apps/tsunami/RTOTohoku_HiRes_0062/
cd(path)
surveypath='/Users/dmelgarm/Research/Data/Tohoku/Inundation/'
tripath='~/Research/Data/DEMs/'
load inundation.mat

mint=200;  %Only look after this time (when AMR is set)
wet_tol=0.00001;  %Need this much (in m) to cosider the cell inundated

t=0:15:7200;
i=find(t>=mint);
t=t(i);
for k=1:max(size(h))    
    H=h(k,i);
    iwet=find(H<wet_tol); %times when the cellw as NOT inundated
    Eta=eta(k,i);
    Eta(iwet)=NaN;
    H(iwet)=NaN;
    [max_eta(k) ieta]=max(Eta);
    mH=H(ieta);
    tmax(k)=t(ieta);
    if mH>max_eta(k)
        max_H(k)=mH;
    else
        max_H(k)=max_eta(k);
    end
end
[xs ys Hs Rs]=textread([surveypath 'inund_good.dat'],'%f%f%f%f');
is=find(ys>=36 & ys<=41);
xs=xs(is)';
ys=ys(is)';
Hs=Hs(is)';
Rs=Rs(is)';
inan1=find(~isnan(max_eta));
inan2=find(~isnan(Hs));
inan=intersect(inan1,inan2);
ninan=setxor(1:length(ys),inan);
VR=(1-sum((Hs(inan)-max_eta(inan)).^2)/sum(Hs(inan).^2))*100;
display([num2str(length(inan)) ' points out of ' num2str(length(Hs)) ' survey points inundated'])
display(['Variance Reduction = ' num2str(VR) '%'])
deta=max_eta-Hs;
deta=deta(inan);
detaplus=deta(deta>=0);
detaminus=deta(deta<0);



% axes(ha(2))
% deta=(max_eta(inan)-Hs(inan));
% detaplus=deta(deta>=0);
% detaminus=deta(deta<0);
% scatter(detaplus,ys(deta>=0),'MarkerEdgeColor',[30 144 255]/255,'MarkerFaceColor',[30 144 255]/255,'SizeData',16);
% hold on
% scatter(detaminus,ys(deta<0),'MarkerEdgeColor',[255 99 71]/255,'MarkerFaceColor',[255 99 71]/255,'SizeData',16);
% legend('Over-estimated','Under-estimated')
% xlabel('\Delta\eta (m)')
% set(gca,'Position',[0.5 0.1 0.2 0.8])

%Analyze TRI\
cd(tripath)
[lont latt,tri]=textread('tri.xy','%f%f%f');
inund=inan;
noinund=1:length(Hs);
noinund=setxor(inan,noinund);
%Get data for closest point
dthresh=km2deg(0.1);
for k=1:length(Hs)
    d=sqrt((xs(k)-lont).^2+(ys(k)-latt).^2);
    [imin]=find(d<dthresh);
    T(k)=mean(tri(imin));
end
cd(path);
[fwet,xwet] = ksdensity(T(inund),'support',[-0.01 40]);
[fdry,xdry] = ksdensity(T(noinund),'support',[-0.01 40]);
xhist=1.5:3:28.5;
[ndry] = hist(T(noinund),xhist)
[nwet] = hist(T(inund),xhist)
ntotal=nwet+ndry
figure
bar([xhist;xhist]',[(nwet./ntotal)*100;(ndry./ntotal)*100]',0.95,'stacked')
legend('Inundated','Not Inundated','Location','SouthWest')
xlabel('TRI')
ylabel('Percentage')
ylim([0 120])
title([num2str(length(inan)) ' / ' num2str(length(Hs)) ' survey points inundated'])
for k=1:length(xhist)
    text(xhist(k)-1,105,[num2str(ntotal(k))])
end
set(gcf,'Position',[1921 -41 1600 1127])
print(gcf,'inundbar.eps','-dpsc')

%Fill in -9999 runup distances with distance to coast
[xc yc]=textread([surveypath 'survey_gmt_coastlines'],'%f%f');
i=find(Rs==-9999);
for k=1:length(i)
    d=sqrt((xs(i(k))-xc).^2+(ys(i(k))-yc).^2);
    mind=deg2km(min(d))*1000;
    Rs(i(k))=mind;
end
%Plot TRI
% figure
% plot(xdry,fdry,xwet,fwet)
% legend('dry','wet')
% figure
% scatter(T(inund),deta);
% ylabel('Modeled-Observed (m)')
% xlabel('TRI')

%Analyze runup distance

%Alright, Main plot
figure
ha = tight_subplot(1, 3, 0, 0.1, 0.1);
axes(ha(1))
scatter(Hs(inan),ys(inan),'MarkerEdgeColor',[176 196 222]/255,'MarkerFaceColor',[176 196 222]/255,'SizeData',4);
hold on
scatter(max_eta(inan),ys(inan),'MarkerEdgeColor','b','MarkerFaceColor','b','SizeData',4);
scatter(Hs(ninan),ys(ninan),'xr','SizeData',14)
legend('Surveyed','Modeled','Not Inundated','Location','NorthOutside')
legend boxoff
xlabel('Max. \eta (m)')
ylabel('North Latitude (°)')
ylim([36 41])
xlim([0 35])
set(gca,'XTick',[0 10 20 30])
axes(ha(2))
scatter(T(inund),ys(inund),'MarkerEdgeColor',[30 144 255]/255,'MarkerFaceColor',[30 144 255]/255,'SizeData',4)
hold on
scatter(T(noinund),ys(noinund),'MarkerEdgeColor',[255 99 71]/255,'MarkerFaceColor',[255 99 71]/255,'SizeData',4)
legend('Inundated','Not Inundated','Location','NorthOutside')
legend boxoff
xlabel('TRI')
xlim([0 40])
set(gca,'YTickLabel',[])
set(gca,'XTick',[0 10 20 30])
axes(ha(3))
scatter(Rs(inund)/1000,ys(inund),'MarkerEdgeColor',[30 144 255]/255,'MarkerFaceColor',[30 144 255]/255,'SizeData',4)
hold on
scatter(Rs(noinund)/1000,ys(noinund),'MarkerEdgeColor',[255 99 71]/255,'MarkerFaceColor',[255 99 71]/255,'SizeData',4)
set(gca,'YTickLabel',[])
xlabel('Run-up distance (km)')
xlim([0 10])
set(gca,'XTick',[0 2.5 5 7.5 10])
set(gcf,'Position',[1921 -41 1600 1127])
axes(ha(1));
set(gca,'Position',[0.1 0.1 0.26667 0.8])
axes(ha(2))
set(gca,'Position',[0.36667 0.1 0.26667 0.8])
print(gcf,'inundanalysis.eps','-dpsc')

end


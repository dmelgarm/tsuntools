function plot_gauge2

run1='0010';
run2='0037';
run3='0010_0037';
figure
scale=1e-3; %Scale to mm
set(gcf,'Position',[1921 -41 1600 1127]);
ha = tight_subplot(4, 4, [0 0.02], 0.1, 0.1);
% dir=['/Users/dmelgarm/bin/clawpack-4.6.3/apps/tsunami/RTOTohoku_Gauges_' run '/_output'];
%dir=['/Volumes/Kanagawa/Tohoku/HiResW_' run '/_output'];
dir1=['/Volumes/Kanagawa/GFs/GFds_' run1 '/_output'];
dir2=['/Volumes/Kanagawa/GFs/GFds_' run2 '/_output'];
dir3=['/Volumes/Kanagawa/GFs/GFds_' run3 '/_output'];
obsdir='/Users/dmelgarm/Research/Data/Tohoku/Gauges';
num_gauge=16;
%Earthquake origin time
t0=11*86400+5*3600+46*60;
%dt in synthetics
dtsynth=15; %secs
%Station list and correspondences
sta_obs={'TI.AYU','TI.CHO','BY.FUK','BY.IWC','BY.IWN','BY.IWS','TI.MER','BY.MIC','BY.MIN','TI.MYE','TI.MYO','TI.OFU','TI.OKA','TI.ONA','OB.TM1','OB.TM2'};
[sta1 amr a1_1 a2 a3 a4 a5_1]=textread([dir1 '/fort.gauge'],'%f%f%f%f%f%f%f');
[sta2 amr a1_2 a2 a3 a4 a5_2]=textread([dir2 '/fort.gauge'],'%f%f%f%f%f%f%f');
[sta3 amr a1_3 a2 a3 a4 a5_3]=textread([dir3 '/fort.gauge'],'%f%f%f%f%f%f%f');
sta_syn1=unique(sta1(1:num_gauge));
sta_syn2=unique(sta2(1:num_gauge));
sta_syn3=unique(sta3(1:num_gauge));
for k=1:length(sta_obs)
    k
    %Get synthetics
    axes(ha(k))
    i=find(sta1==sta_syn1(k));
    t1=a1_1(i);
    eta1=(a5_1(i))/scale;
    ts1=0:dtsynth:t1(end);
    etas1=interp1(t1,eta1,ts1);
    %etas1=2*etas1;
    %Second result
    i=find(sta2==sta_syn2(k));
    t2=a1_2(i);
    eta2=(a5_2(i))/scale;
    ts2=0:dtsynth:t2(end);
    etas2=interp1(t2,eta2,ts2);
    %Now make linear superposition
    etas1=etas1+etas2;
    %Read third file
    i=find(sta3==sta_syn3(k));
    t3=a1_3(i);
    eta3=(a5_3(i))/scale;
    ts3=0:dtsynth:t3(end);
    etas3=interp1(t3,eta3,ts3);
    %Plot
    %plot(ts1/60,etas1,ts2/60,etas2,'LineWidth',2)
    %plot(ts1/60,etas1-etas2,'LineWidth',2)
    %plot(ts1/60,etas1,ts3/60,etas3,'LineWidth',2)
    plot(ts1/60,etas1-etas3,'LineWidth',2)
    set(gca,'LineWidth',1.5)
    xlim([0 6000/60])
    yl=[min(etas1)*1.1 max(etas1)*1.1];
    ylim(yl)
    yl=ylim;
    text(10,0.8*yl(2),[sta_obs{k}]) 
    if k==1
        %legend('2*(patch10 1m of slip)','patch10 2m of slip')
        %legend('Linear Comb. patch10+patch37','GeoClaw: patch10 & patch37')
        legend('Difference')
    end
    if (k==1 | k ==5 | k==5 | k==9 | k==13)
        ylabel('\eta(mm)')
    end
    if (k==13 | k==14 | k==15 | k==16)
        xlabel('Minutes after OT')
    end
    if (k < 13)
        set(gca,'XTickLabel',[]')
    end
end
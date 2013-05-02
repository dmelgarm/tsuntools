function plot_gauge(run)

figure
scale=1e-3; %Scale to mm
set(gcf,'Position',[1921 -41 1600 1127]);
ha = tight_subplot(4, 4, [0 0.05], 0.1, 0.1);
% dir=['/Users/dmelgarm/bin/clawpack-4.6.3/apps/tsunami/RTOTohoku_Gauges_' run '/_output'];
%dir=['/Volumes/Kanagawa/Tohoku/HiResW_' run '/_output'];
dir=['/Volumes/Kanagawa/GFs/GFss_' run '/_output'];
obsdir='/Users/dmelgarm/Research/Data/Tohoku/Gauges';
num_gauge=16;
%Earthquake origin time
t0=11*86400+5*3600+46*60;
%dt in synthetics
dtsynth=15; %secs
%Station list and correspondences
sta_obs={'TI.AYU','TI.CHO','BY.FUK','BY.IWC','BY.IWN','BY.IWS','TI.MER','BY.MIC','BY.MIN','TI.MYE','TI.MYO','TI.OFU','TI.OKA','TI.ONA','OB.TM1','OB.TM2'};
[sta amr a1 a2 a3 a4 a5]=textread([dir '/fort.gauge'],'%f%f%f%f%f%f%f');
sta_syn=unique(sta(1:num_gauge));
for k=1:length(sta_obs)
    k
    %Get synthetics
    axes(ha(k))
    i=find(sta==sta_syn(k));
    t=a1(i);
    eta=(a5(i))/scale;
    H=a2(i)/scale;
    ts=0:dtsynth:t(end);
    etas=interp1(t,eta,ts);
    %Get observed
    cd(obsdir)
    [day a a hr min sec etao]=textread([sta_obs{k} '.txt'],'%f%f%f%f%f%f%f');
    to=day*86400+hr*3600+min*60+sec;
    to=to-t0;
    %plot(ts/60,etas,to/60,etao,'LineWidth',2)
    plot(ts/60,etas)
    set(gca,'LineWidth',1.5)
    xlim([0 6000/60])
    yl=ylim;
    text(10,0.8*yl(2),[sta_obs{k}]) 
    if k==1
        legend('Modeled','Observed')
    end
    if (k==1 | k ==5 | k==9 | k==13 | k==17)
        ylabel('\eta(mm)')
    end
    if (k==13 | k==14 | k==15 | k==16)
        xlabel('Minutes after OT')
    end
    if (k < 13)
        set(gca,'XTickLabel',[]')
    end
end



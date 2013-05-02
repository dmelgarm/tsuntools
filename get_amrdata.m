function [xout yout Hout]=get_amrdata(frameno)

% DMM 02/2013
%
% Extract amr data from Clawpack fort.qXXX output files, this will amke an
% irregular grid finding at each point the info fromt he finest grid. 

%read frame geometric info
[amr t]=readamrdata(2,frameno,'_output','ascii');
data={amr(:).data};
mx=cell2mat({amr(:).mx});
my=cell2mat({amr(:).my});
dx=cell2mat({amr(:).dx});
dy=cell2mat({amr(:).dy});
x1=cell2mat({amr(:).xlow});
y1=cell2mat({amr(:).ylow});
gridno=cell2mat({amr(:).gridno});
level=cell2mat({amr(:).level});
alev=sort(unique(level),'descend');
maxl=max(level);
minl=min(level);
%Get max and min lats and lons fo each grid
x2=x1+mx.*dx;
y2=y1+my.*dy;
%Read fine grids first
i1=find(level==alev(1));
xout=[];
yout=[];
Hout=[];
for k=1:length(i1)
    j=i1(k);
    xtemp=x1(j):dx(j):(x2(j)-dx(j));
    ytemp=y1(j):dy(j):(y2(j)-dy(j));
    [X Y]=meshgrid(xtemp,ytemp);
    xout=[xout ; reshape(X',numel(X),1)];
    yout=[yout ; reshape(Y',numel(Y),1)];
    Hout=[Hout ; (cell2mat(data(1,j)))'];
end
%read the next levels
pi=i1;  %Previous grids
for k1=2:length(alev)
    xtemp=[];
    ytemp=xtemp;
    i=find(level==alev(k1));
    %Get next level's points grid by grid
    for k2=1:length(i)
        j=i(k2);
        xtemp=[x1(j):dx(j):(x2(j)-dx(j))];
        ytemp=[y1(j):dy(j):(y2(j)-dy(j))];
        [X Y]=meshgrid(xtemp,ytemp);
        xtemp=reshape(X',numel(X),1);
        ytemp=reshape(Y',numel(Y),1);
        htemp=(cell2mat(data(1,j)))';
        %Are points in previous level?
        %Make vector of points in current grid
        Xtemp=repmat(xtemp,1,length(pi));
        Xtemp=reshape(Xtemp',numel(Xtemp),1);
        Ytemp=repmat(ytemp,1,length(pi));
        Ytemp=reshape(Ytemp',numel(Ytemp),1);
        %Make vector of upper and lower bounds (of previous grids)
        X1=repmat(x1(pi),1,length(xtemp));
        X1=reshape(X1',numel(X1),1);
        X2=repmat(x2(pi),1,length(xtemp));
        X2=reshape(X2',numel(X2),1);
        Y1=repmat(y1(pi),1,length(ytemp));
        Y1=reshape(Y1',numel(Y1),1);
        Y2=repmat(y2(pi),1,length(ytemp));
        Y2=reshape(Y2',numel(Y2),1);
        %Which points are NOT in any of the previous grids and should be kept
        keep=find(Xtemp>=X1 & Xtemp<=X2 & Ytemp>=Y1 & Ytemp<=Y2);
        xt=Xtemp(keep);
        yt=Ytemp(keep);
        [new ia ib]=setxor([xt yt],[xtemp ytemp],'rows');
        %Update output variables
        xout=[xout ; new(:,1)];
        yout=[yout ; new(:,2)];
        Htemp=(cell2mat(data(1,j)))';
        Hout=[Hout ; Htemp(ib,:)];
    end
    pi=[pi i]; %update what previous level's grids are
end

%That was kind of painful



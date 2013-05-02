function [xout yout h hu hv eta]=get_inundation(frameno,xi,yi)

% DMM 02/2013
%
% Extract inundation data at specified points from Clawpack amr fort.qXXX
% output files

%read frame geometric info
[amr t]=readamrdata(2,frameno,'_output','ascii');
data={amr(:).data};
mx=cell2mat({amr(:).mx});
my=cell2mat({amr(:).my});
dx=cell2mat({amr(:).dx});
dy=cell2mat({amr(:).dy});
x1=cell2mat({amr(:).xlow});
y1=cell2mat({amr(:).ylow});
x2=x1+mx.*dx;
y2=y1+my.*dy;
gridno=cell2mat({amr(:).gridno});
level=cell2mat({amr(:).level});
alev=sort(unique(level),'descend')
maxl=max(level);
minl=min(level);
N=length(xi);
%Get grid which contains the point
for k=1:N
    possible_grids=find(xi(k)>=x1 & xi(k)<=x2 & yi(k) >= y1 & yi(k) <= y2);
    %Keep highest level one
    [m i]=max(level(possible_grids));
    kg=possible_grids(i);
    %get data
    [xout(k) yout(k) h(k) hu(k) hv(k) eta(k)]=get_point_in_grid(xi(k),yi(k),x1(kg),y1(kg),dx(kg),dy(kg),mx(kg),my(kg),cell2mat(data(:,kg))');
end
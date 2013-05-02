function amr2gmt(Nframes)
for frameno=0:Nframes-1
    if frameno<10
        prefix=['gmt.f000' num2str(frameno)];
        levelname=['level.f000' num2str(frameno) '.out'];
    elseif frameno<100
        prefix=['gmt.f00' num2str(frameno)];
        levelname=['level.f00' num2str(frameno) '.out'];
    elseif frameno<1000
        prefix=['gmt.f0' num2str(frameno)];
        levelname=['level.f0' num2str(frameno) '.out'];
    else
        prefix=['gmt.f' num2str(frameno)];
        levelname=['level.f' num2str(frameno) '.out'];
    end
    %read in single frame data
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
    alev=sort(unique(level),'descend')
    Ngrids=length(gridno);
    %Now iterate over all grids and make an xyz file for everyone of them
    for k=1:Ngrids
        x=x1(k)+(dx(k)/2):dx(k):x1(k)+(dx(k)/2)+dx(k)*(mx(k)-1)';
        y=y1(k)+(dy(k)/2):dy(k):y1(k)+(dy(k)/2)+dy(k)*(my(k)-1)';
%         x=x1(k):dx(k):x1(k)+dx(k)*(mx(k)-1)';
%         y=y1(k):dy(k):y1(k)+dy(k)*(my(k)-1)';
        [X Y]=meshgrid(x,y);
        x=reshape(X',numel(X),1);
        y=reshape(Y',numel(Y),1);
        d=data{1,k};
        H=d(1,:)';
        Hout=(reshape(H,mx(k),my(k)));
        eta=d(4,:);
        etaout=(reshape(eta,mx(k),my(k)));
        if k<10
            Hname=['H.' prefix '.g000' num2str(k) '.grd'];
            etaname=['eta.' prefix '.g000' num2str(k) '.grd'];
        elseif k<100
            Hname=['H.' prefix '.g00' num2str(k) '.grd'];
            etaname=['eta.' prefix '.g00' num2str(k) '.grd'];
        elseif k<1000
            Hname=['H.' prefix '.g0' num2str(k) '.grd'];
            etaname=['eta.' prefix '.g0'  num2str(k) '.grd'];
        else
            Hname=['H.' prefix '.g' num2str(k) '.grd'];
            etaname=['eta.' prefix '.g' num2str(k) '.grd'];
        end
        %figure
        %surface(X',Y',etaout),view([0 90]),colorbar
        %scatter3(x,y,eta,[],eta),view([0 90]),colorbar
        %caxis([-1 1])
        grdwrite2(x,y,Hout',['_output/' Hname])
        grdwrite2(x,y,etaout',['_output/' etaname])
%         out=[x y H];
%         save(['_output/' Hname],'out','-ascii');
%         out=[x y eta];
%         save(['_output/' etaname],'out','-ascii');
    end
    out=level';
    save(['_output/' levelname],'out','-ascii');
end
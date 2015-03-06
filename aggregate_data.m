clear all;
close all;
clc;

fsize = 25;

str = computer;
if (strncmp(str,'PCWIN',5))
    src = 'C:/Users/yzs123/Box Sync/Research';
else if (strncmp(str,'MACI',4))
        src = '/Users/Yuning/Dropbox/Research';
    end
end

for month = 4:10
    COLS = 610;
    ROWS = 394;
    X0 = 254139.13; Y0=4505175.754;
    actual_boundary = load(sprintf('%s/Data/CZO/SSHO_boundary.dat',src));
    xlin=linspace(X0,X0+COLS-1,COLS);
    ylin=linspace(Y0+ROWS-1,Y0,ROWS);
    [Xgrid,Ygrid]=meshgrid(xlin,ylin);
    projectName = {'shp'};
    [NumEle, NumNode, eleind, nodeind, x, y, zmin, zmax, tri] = read_mesh_func_old(projectName);
    data = load(sprintf('2009-%2.2d.dat',month));
    SM=griddata(Xgrid(~isnan(data)),Ygrid(~isnan(data)),data(~isnan(data)),Xgrid,Ygrid,'linear');
    SM(~inpolygon(Xgrid,Ygrid,actual_boundary(:,1),actual_boundary(:,2))) = NaN;
    SM_agrg = zeros(1,NumEle);
    
    for i = 1:NumEle
        SM_agrg(i) = nanmean(SM(inpolygon(Xgrid,Ygrid,x(tri(i,:)),y(tri(i,:)))));
    end
    
    figure;
    subplot(1,2,1);
    SM(~inpolygon(Xgrid,Ygrid,actual_boundary(:,1),actual_boundary(:,2))) = NaN;
    h = surf(Xgrid,Ygrid,zeros(size(Xgrid)),SM,'edgecolor','none'); % interpolated
    newjet = flipud(colormap('jet'));
    colormap(newjet);
    caxis([0.1 0.25]);
    set(h,'edgecolor','none');
    hold on;
    plot(actual_boundary(:,1),actual_boundary(:,2),'k','LineWidth',3);
    set(gca,'xlim',[min(actual_boundary(:,1)) max(actual_boundary(:,1))],'DataAspectRatio',[1 1 1]);
    %set(gca,'DataAspectRatio',[1 1 1]);
    view(0, 90);
    axis off;
    
    subplot(1,2,2);
    x_c = zeros(1,NumEle);
    y_c = zeros(1,NumEle);
    z_max = zeros(1,NumEle);
    SWC = zeros(1,NumEle);
    
    for i =1:NumEle
        z_max(i) = (zmax(tri(i,1))+zmax(tri(i,2))+zmax(tri(i,3)))/3;
        x_c(i) = (x(tri(i,1))+x(tri(i,2))+x(tri(i,3)))/3;
        y_c(i) = (y(tri(i,1))+y(tri(i,2))+y(tri(i,3)))/3;
        SWC(i) = SM_agrg(i);
    end
    
    boundary_node = [10 39 36 49 35 21 141 87 190 193 22 172 176 23 221 24 270 25 240 26 212 27 210 71 75 76 28 29 30 31 32 279 219 ...
        283 33 228 253 34 226 11 12 209 136 154 13 203 177 14 260 250 252 15 16 17 18 206 19 44 45 20 40 10];
    boundary_x = x(boundary_node);
    boundary_y = y(boundary_node);
    
    for i = 1:length(boundary_node)
        [row col] = find(tri==boundary_node(i));
        SWC_boundary(1,i) = mean(SWC(row));
        zmax_boundary(1,i) = mean(z_max(row));
    end
    
    %x_river = zeros(1,NumRiv*10);
    %y_river = zeros(1,NumRiv*10);
    %for i = 1:NumRiv
    %    for j = 1:10
    %        x_river((i-1)*10+j) = x(fromnode(i))+ (x(tonode(i))-x(fromnode(i)))/9*(j-1);
    %        y_river((i-1)*10+j) = y(fromnode(i))+ (y(tonode(i))-y(fromnode(i)))/9*(j-1);
    %    end
    %end
    x = [x_c x(boundary_node)'];% x_river];
    y = [y_c y(boundary_node)'];% y_river];
    SWC = [SWC SWC_boundary];% ThetaS(5)*ones(size(x_river))];
    SMgrid=griddata(x,y,SWC,Xgrid,Ygrid,'linear');
    SMgrid(~inpolygon(Xgrid,Ygrid,boundary_x,boundary_y)) = NaN;
    h = surf(Xgrid,Ygrid,zeros(size(Xgrid)),SMgrid,'edgecolor','none'); % interpolated
    hold on;
    plot(boundary_x, boundary_y,'k','LineWidth',3);
    set(gca,'xlim',[min(actual_boundary(:,1)) max(actual_boundary(:,1))],'DataAspectRatio',[1 1 1]);
    %set(gca,'DataAspectRatio',[1 1 1]);
    newjet = flipud(colormap('jet'));
    colormap(newjet)
    caxis([0.1 0.25]);
    view(0, 90);
    axis off;
    
    filename =sprintf('2009-%2.2d-agrg.dat',month);
    save(filename,'SMgrid','-ASCII');
    
    
    filename =sprintf('2009-%2.2d-agrg-grid.dat',month);
    save(filename,'SM_agrg','-ASCII');
end
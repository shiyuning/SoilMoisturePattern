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

COLS = 610;
ROWS = 394;
X0 = 254139.13; Y0=4505175.754;
TDR = load(sprintf('%s/Data/CZO/TDR.dat',src));
projectName = {'shb'};
actual_boundary = load(sprintf('%s/Data/CZO/SSHO_boundary.dat',src));
[NumRiv, rivind, fromnode tonode] = read_riv_func_old(projectName);
%[KsatH, KsatV, ThetaS, ThetaR, Alpha, Beta, vAreaF, macKsatH, macD] = read_geol_func(projectName);
xlin=linspace(X0,X0+COLS-1,COLS);
ylin=linspace(Y0+ROWS-1,Y0,ROWS);
[Xgrid,Ygrid]=meshgrid(xlin,ylin);

figure('Position',[1 1 1400 950]);
for ind = 1:4
    axes('position',[0.06 0.92-ind/4 0.25 0.35]);
    data = load(sprintf('2009-%2.2d.dat',ind+5));
    %SM=griddata(Xgrid(~isnan(data)),Ygrid(~isnan(data)),data(~isnan(data)),Xgrid,Ygrid,'linear');
    %SM(~inpolygon(Xgrid,Ygrid,actual_boundary(:,1),actual_boundary(:,2))) = NaN;
    h = surf(Xgrid,Ygrid,zeros(size(Xgrid)),data,'edgecolor','none'); % interpolated
    newjet = flipud(colormap('jet'));
    colormap(newjet);
    caxis([0.1 0.25]);
    set(h,'edgecolor','none');
    hold on;
    plot(TDR(:,1),TDR(:,2),'o','MarkerSize',6,'MarkerEdgeColor','k','MarkerFaceColor','g');
    plot(actual_boundary(:,1),actual_boundary(:,2),'k','LineWidth',3);
    set(gca,'xlim',[min(actual_boundary(:,1)) max(actual_boundary(:,1))],'DataAspectRatio',[1 1 1]);
    %set(gca,'DataAspectRatio',[1 1 1]);
    view(0, 90);
    axis off;
    %colorbar;
    
    axes('position',[0.34 0.92-ind/4 0.25 0.35]);
    data = load(sprintf('2009-%2.2d-agrg.dat',ind+5));
    %SM=griddata(Xgrid(~isnan(data)),Ygrid(~isnan(data)),data(~isnan(data)),Xgrid,Ygrid,'linear');
    %SM(~inpolygon(Xgrid,Ygrid,actual_boundary(:,1),actual_boundary(:,2))) = NaN;
    h = surf(Xgrid,Ygrid,zeros(size(Xgrid)),data,'edgecolor','none'); % interpolated
    newjet = flipud(colormap('jet'));
    colormap(newjet);
    caxis([0.1 0.25]);
    set(h,'edgecolor','none');
    hold on;
    plot(TDR(:,1),TDR(:,2),'o','MarkerSize',6,'MarkerEdgeColor','k','MarkerFaceColor','g');
    plot(actual_boundary(:,1),actual_boundary(:,2),'k','LineWidth',3);
    set(gca,'xlim',[min(actual_boundary(:,1)) max(actual_boundary(:,1))],'DataAspectRatio',[1 1 1]);
    %set(gca,'DataAspectRatio',[1 1 1]);
    view(0, 90);
    axis off;
    
    
    axes('position',[0.62 0.92-ind/4 0.25 0.35]);

    [n, dsoil] = read_lsm_func(projectName);
    [NumEle, NumNode, eleind, nodeind, x, y, zmin, zmax, tri] = read_mesh_func(projectName);
    filename = sprintf('%s/Flux-PIHM-2.0/output/%s.smsp2009%2.2d',src,projectName{1},ind+5);
    fmt = ['%d' repmat('%f', 1, n)];
    fid = fopen(filename);
    temp=textscan(fid,fmt,'delimiter',',');
    fclose(fid);
    SM = zeros(size(temp{1},1),n);
    [ele] = temp{1};
    for i = 1:n
        SM(:,i) = temp{i+1};
    end
    x_c = zeros(1,NumEle);
    y_c = zeros(1,NumEle);
    z_max = zeros(1,NumEle);
    SWC = zeros(1,NumEle);
    
    for i =1:NumEle
        z_max(i) = (zmax(tri(i,1))+zmax(tri(i,2))+zmax(tri(i,3)))/3;
        x_c(i) = (x(tri(i,1))+x(tri(i,2))+x(tri(i,3)))/3;
        y_c(i) = (y(tri(i,1))+y(tri(i,2))+y(tri(i,3)))/3;
        SWC(i) = (sum(SM(i,1:4).*dsoil(1:4))+SM(i,5)*(0.6-sum(dsoil(1:4))))/0.6;
        %SWC(i) = SM(i,4);
        %SWC(i) = 
    end
    
    boundary_node = [10 39 36 49 35 21 141 87 190 193 22 172 176 23 221 24 270 25 240 26 212 27 210 71 75 76 28 29 30 31 32 279 219 ...
        283 33 228 253 34 226 11 12 209 136 154 13 203 177 14 260 250 252 15 16 17 18 206 19 44 45 20 40 10];
        %boundary_node = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 328 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61];
    boundary_x = x(boundary_node);
    boundary_y = y(boundary_node);
    
    for i = 1:length(boundary_node)
        [row col] = find(tri==boundary_node(i));
        SWC_boundary(1,i) = mean(SWC(row));
        zmax_boundary(1,i) = mean(z_max(row));
    end
    
    x_river = zeros(1,NumRiv*10);
    y_river = zeros(1,NumRiv*10);
    for i = 1:NumRiv
        for j = 1:10
            x_river((i-1)*10+j) = x(fromnode(i))+ (x(tonode(i))-x(fromnode(i)))/9*(j-1);
            y_river((i-1)*10+j) = y(fromnode(i))+ (y(tonode(i))-y(fromnode(i)))/9*(j-1);
        end
    end
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
end

axes('position',[0 0 1 1]);
text(0.175,0.98,'Measured','HorizontalAlignment','Center','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
text(0.465,0.98,'Measured (aggregated)','HorizontalAlignment','Center','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
text(0.745,0.98,'Flux-PIHM','HorizontalAlignment','Center','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
text(0.01,0.85,'Jun','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
text(0.01,0.6,'Jul','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
text(0.01,0.35,'Aug','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
text(0.01,0.1,'Sep','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
axis off;


%latex_colorbar('Position',[0.93 0.15 0.015 0.6], 'Ticks',0.1:0.05:0.25, 'Caxis',[0.1 0.25],'FontSize',fsize, 'LabelDist',0.6, 'TitleDist',3);

C=colorbar;
set(C,'Position',[0.93 0.15 0.015 0.6],'YAxisLocation','Right','YTick',0.1:0.05:0.25,'YTickLabel','','FontSize',fsize);
axes('Position',get(C,'Position'));
axis off;

text(-0.1,0,'$>=$0.1','HorizontalAlignment','Right','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
text(-0.1,1/3,'0.15','HorizontalAlignment','Right','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
text(-0.1,2/3,'0.2','HorizontalAlignment','Right','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
text(-0.1,3/3,'$<=$0.25','HorizontalAlignment','Right','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
text(2,0.5,'Soil water content (m$^3$ m$^{-3}$)','HorizontalAlignment','center','VerticalAlignment','Middle','Rotation',90,'Interpreter','latex','FontSize',fsize);

%     CB=colorbar('Location','East','Position',[0.7 0.2 0.02 0.6],'FontSize',fsize-5);
%     ylabel(CB,'{Soil saturation} (-)','FontSize',fsize,'FontWeight','Bold');
%     set(CB,'YAxisLocation','Right');
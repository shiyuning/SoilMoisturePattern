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

RTH3_x = [254356.974099 254366.173891 254375.216018];
RTH3_y = [4505358.63484 4505365.87801 4505357.35055];
RTH3_z = [265.1613 266.0571 265.8554];

COLS = 610;
ROWS = 394;
X0 = 254139.13; Y0=4505175.754;
TDR = load(sprintf('%s/Data/CZO/TDR.dat',src));
actual_boundary = load(sprintf('%s/Data/CZO/SSHO_boundary.dat',src));
xlin=linspace(X0,X0+COLS-1,COLS);
ylin=linspace(Y0+ROWS-1,Y0,ROWS);
[Xgrid,Ygrid]=meshgrid(xlin,ylin);

%figure('Position',[1 1 1400 950]);

lmargin = 0.03;
topmargin = -0.02;
width = 0.30;
height = 0.5;
xdist = 0.33;
ydist = 0.5;
figure('Position',[50 50 1800 900]);

axes('position',[lmargin 1 - topmargin-ydist width height]);
data = load('2009-06-agrg.dat');
data1 = load('2009-06-agrg-grid.dat');
h = surf(Xgrid,Ygrid,zeros(size(Xgrid)),data,'edgecolor','none'); % interpolated
newjet = flipud(colormap('jet'));colormap(newjet);
caxis([0.1 0.25]);
set(h,'edgecolor','none');
hold on;
plot(TDR(:,1),TDR(:,2),'o','MarkerSize',6,'MarkerEdgeColor','k','MarkerFaceColor','w');
%plot(RTH3_x, RTH3_y,'^','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','g');
plot(actual_boundary(:,1),actual_boundary(:,2),'k','LineWidth',3);
set(gca,'xlim',[min(actual_boundary(:,1)) max(actual_boundary(:,1))],'DataAspectRatio',[1 1 1]);
text(min(actual_boundary(:,1))+25, max(actual_boundary(:,2))+15, sprintf('STD = $%5.3f$ m$^{3}$ m$^{-3}$', std(data1(~isnan(data1)))), 'FontSize',fsize-3, 'interpreter', 'latex');
%set(gca,'DataAspectRatio',[1 1 1]);
view(0, 90);
axis off;
freezeColors;
latex_colorbar('Position',[lmargin+0.1*width 1-topmargin-height 0.8*width 0.08], 'Ticks',0.1:0.05:0.25, 'Caxis',[0.1 0.25],'FontSize',fsize-3, 'LabelDist',0.6, 'TitleDist',5,'Dir','Horizontal','Title','SWC (m$^3$ m$^{-3}$)');

% data = load('2009-06.dat');
% h = surf(Xgrid,Ygrid,zeros(size(Xgrid)),data,'edgecolor','none'); % interpolated
% newjet = flipud(colormap('jet'));
% colormap(newjet);
% caxis([0.1 0.25]);
% set(h,'edgecolor','none');
% hold on;
% plot(actual_boundary(:,1),actual_boundary(:,2),'k','LineWidth',3);
% set(gca,'xlim',[min(actual_boundary(:,1)) max(actual_boundary(:,1))],'DataAspectRatio',[1 1 1]);
% view(0, 90);
% %title('Measured');
% axis off;
% %colorbar;
% freezeColors;
% latex_colorbar('Position',[lmargin+0.1*width 1-topmargin-height 0.8*width 0.08], 'Ticks',0.1:0.05:0.25, 'Caxis',[0.1 0.25],'FontSize',fsize-3, 'LabelDist',0.6, 'TitleDist',5,'Dir','Horizontal','Title','SWC (m$^3$ m$^{-3}$)');

axes('position',[lmargin+xdist 1-topmargin-ydist width height]);
projectName{1} = 'shp';
[n, dsoil] = read_lsm_func(projectName);
[NumEle, NumNode, eleind, nodeind, x, y, zmin, zmax, tri] = read_mesh_func(projectName);
filename = sprintf('%s/Flux-PIHM-2.0/output/%s.smsp200906',src,projectName{1});
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
boundary_x = x(boundary_node);
boundary_y = y(boundary_node);

for i = 1:length(boundary_node)
    [row col] = find(tri==boundary_node(i));
    SWC_boundary(1,i) = mean(SWC(row));
    zmax_boundary(1,i) = mean(z_max(row));
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
text(min(actual_boundary(:,1))+25, max(actual_boundary(:,2))+15, sprintf('STD = $%5.3f$ m$^{3}$ m$^{-3}$', std(SWC(1:535))), 'FontSize',fsize-3, 'interpreter', 'latex');
view(0, 90);
axis off;
freezeColors;
latex_colorbar('Position',[lmargin+1*xdist+0.1*width 1-topmargin-height 0.8*width 0.08], 'Ticks',0.1:0.05:0.25, 'Caxis',[0.1 0.25],'FontSize',fsize-3, 'LabelDist',0.6, 'TitleDist',5,'Dir','Horizontal','Title','SWC (m$^3$ m$^{-3}$)');

axes('position',[lmargin+2*xdist 1-topmargin-ydist width height]);
projectName{1} = 'sha';
[n, dsoil] = read_lsm_func(projectName);
[NumEle, NumNode, eleind, nodeind, x, y, zmin, zmax, tri] = read_mesh_func(projectName);
filename = sprintf('%s/Flux-PIHM-2.0/output/%s.smsp200906',src,projectName{1});
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
boundary_x = x(boundary_node);
boundary_y = y(boundary_node);

for i = 1:length(boundary_node)
    [row col] = find(tri==boundary_node(i));
    SWC_boundary(1,i) = mean(SWC(row));
    zmax_boundary(1,i) = mean(z_max(row));
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
caxis([0.17 0.23]);
text(min(actual_boundary(:,1))+25, max(actual_boundary(:,2))+15, sprintf('STD = $%5.3f$ m$^{3}$ m$^{-3}$', std(SWC(1:535))), 'FontSize',fsize-3, 'interpreter', 'latex');
view(0, 90);
axis off;
freezeColors;
latex_colorbar('Position',[lmargin+2*xdist+0.1*width 1-topmargin-height 0.8*width 0.08], 'Ticks',0.17:0.02:0.23, 'Caxis',[0.17 0.23],'FontSize',fsize-3, 'LabelDist',0.6, 'TitleDist',5,'Dir','Horizontal','Title','SWC (m$^3$ m$^{-3}$)');

axes('position',[lmargin 1-topmargin-2*ydist width height]);
projectName{1} = 'shc';
[n, dsoil] = read_lsm_func(projectName);
[NumEle, NumNode, eleind, nodeind, x, y, zmin, zmax, tri] = read_mesh_func(projectName);
filename = sprintf('%s/Flux-PIHM-2.0/output/%s.smsp200906',src,projectName{1});
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
boundary_x = x(boundary_node);
boundary_y = y(boundary_node);

for i = 1:length(boundary_node)
    [row col] = find(tri==boundary_node(i));
    SWC_boundary(1,i) = mean(SWC(row));
    zmax_boundary(1,i) = mean(z_max(row));
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
text(min(actual_boundary(:,1))+25, max(actual_boundary(:,2))+15, sprintf('STD = $%5.3f$ m$^{3}$ m$^{-3}$', std(SWC(1:535))), 'FontSize',fsize-3, 'interpreter', 'latex');
view(0, 90);
axis off;
freezeColors;
latex_colorbar('Position',[lmargin+0.1*width 1-topmargin-height-ydist 0.8*width 0.08], 'Ticks',0.1:0.05:0.25, 'Caxis',[0.1 0.25],'FontSize',fsize-3, 'LabelDist',0.6, 'TitleDist',5,'Dir','Horizontal','Title','SWC (m$^3$ m$^{-3}$)');

axes('position',[lmargin+xdist 1-topmargin-2*ydist width height]);
projectName{1} = 'shd';
[n, dsoil] = read_lsm_func(projectName);
[NumEle, NumNode, eleind, nodeind, x, y, zmin, zmax, tri] = read_mesh_func(projectName);
filename = sprintf('%s/Flux-PIHM-2.0/output/%s.smsp200906',src,projectName{1});
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
boundary_x = x(boundary_node);
boundary_y = y(boundary_node);

for i = 1:length(boundary_node)
    [row col] = find(tri==boundary_node(i));
    SWC_boundary(1,i) = mean(SWC(row));
    zmax_boundary(1,i) = mean(z_max(row));
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
caxis([0.18 0.23]);
text(min(actual_boundary(:,1))+25, max(actual_boundary(:,2))+15, sprintf('STD = $%5.3f$ m$^{3}$ m$^{-3}$', std(SWC(1:535))), 'FontSize',fsize-3, 'interpreter', 'latex');
view(0, 90);
axis off;
freezeColors;
latex_colorbar('Position',[lmargin+xdist+0.1*width 1-topmargin-height-ydist 0.8*width 0.08], 'Ticks',0.18:0.01:0.23, 'Caxis',[0.18 0.23],'FontSize',fsize-3, 'LabelDist',0.6, 'TitleDist',5,'Dir','Horizontal','Title','SWC (m$^3$ m$^{-3}$)');

axes('position',[lmargin+2*xdist 1-topmargin-2*ydist width height]);

projectName{1} = 'shb';
[n, dsoil] = read_lsm_func(projectName);
[NumEle, NumNode, eleind, nodeind, x, y, zmin, zmax, tri] = read_mesh_func(projectName);
filename = sprintf('%s/Flux-PIHM-2.0/output/%s.smsp200906',src,projectName{1});
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
boundary_x = x(boundary_node);
boundary_y = y(boundary_node);

for i = 1:length(boundary_node)
    [row col] = find(tri==boundary_node(i));
    SWC_boundary(1,i) = mean(SWC(row));
    zmax_boundary(1,i) = mean(z_max(row));
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
text(min(actual_boundary(:,1))+25, max(actual_boundary(:,2))+15, sprintf('STD = $%5.3f$ m$^{3}$ m$^{-3}$', std(SWC(1:535))), 'FontSize',fsize-3, 'interpreter', 'latex');
view(0, 90);
axis off;
freezeColors;
latex_colorbar('Position',[lmargin+2*xdist+0.1*width 1-topmargin-height-ydist 0.8*width 0.08], 'Ticks',0.1:0.05:0.25, 'Caxis',[0.1 0.25],'FontSize',fsize-3, 'LabelDist',0.6, 'TitleDist',5,'Dir','Horizontal','Title','SWC (m$^3$ m$^{-3}$)');

axes('position',[0 0 1 1]);
text(lmargin,1 - topmargin-0.1*height,'(a) Measured (aggregated)','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
text(lmargin+xdist,1 - topmargin-0.1*height,'(b) Field survey','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
text(lmargin+2*xdist,1 - topmargin-0.1*height,'(c) SSURGO','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
text(lmargin,1 - topmargin-0.1*height-ydist,'(d) 2-m BRD','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
text(lmargin+xdist,1 - topmargin-0.1*height-ydist,'(e) Uniform soil','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
text(lmargin+2*xdist,1 - topmargin-0.1*height-ydist,'(f) NLCD','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);

% text(0.465,0.98,'Measured (upscaled)','HorizontalAlignment','Center','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
% text(0.745,0.98,'Flux-PIHM','HorizontalAlignment','Center','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
% text(0.01,0.85,'Jun','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
% text(0.01,0.6,'Jul','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
% text(0.01,0.35,'Aug','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
% text(0.01,0.1,'Sep','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
axis off;
% 
% 
% 
% C=colorbar;
% set(C,'Position',[0.93 0.15 0.015 0.6],'YAxisLocation','Right','YTick',0.1:0.05:0.25,'YTickLabel','','FontSize',fsize);
% axes('Position',get(C,'Position'));
% axis off;
% 
% text(-0.1,0,'$>=$0.1','HorizontalAlignment','Right','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
% text(-0.1,1/3,'0.15','HorizontalAlignment','Right','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
% text(-0.1,2/3,'0.2','HorizontalAlignment','Right','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
% text(-0.1,3/3,'$<=$0.25','HorizontalAlignment','Right','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
% text(2,0.5,'Soil water content (m$^3$ m$^{-3}$)','HorizontalAlignment','center','VerticalAlignment','Middle','Rotation',90,'Interpreter','latex','FontSize',fsize);
% 
% %     CB=colorbar('Location','East','Position',[0.7 0.2 0.02 0.6],'FontSize',fsize-5);
% %     ylabel(CB,'{Soil saturation} (-)','FontSize',fsize,'FontWeight','Bold');
%     set(CB,'YAxisLocation','Right');
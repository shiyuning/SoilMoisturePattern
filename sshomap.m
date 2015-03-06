clear all; close all;clc;

str = computer;
if (strncmp(str,'PCWIN',5))
    src = 'C:/Users/yzs123/Dropbox/Research';
else if (strncmp(str,'MACI',4))
        src = '/Users/Yuning/Dropbox/Research';
    end
end

projectName{1} = 'shp';
[NumEle, NumNode, eleind, nodeind, x, y, zmin, zmax, tri,nabr] = read_mesh_func(projectName);

[NumRiv, rivind, fromnode, tonode]=read_riv_func(projectName);


%outlet = [254236.24028000000	4505632.24811000000];
%soiltemp_x = [254426.9169 254427.7138 254431.1577 254434.2384 254428.8311];
%soiltemp_y = [4505367.087 4505403.414 4505462.6 4505406.226 4505475.888];
RTH3_x = [254356.974099 254366.173891 254375.216018];
RTH3_y = [4505358.63484 4505365.87801 4505357.35055];
RTH3_z = [265.1613 266.0571 265.8554];
ectower = [254492.82408600000	4505491.54761000000];
outlet = [254213.94182700000	4505406.84737000000];
%outlet = [254236.24028000000	4505632.24811000000];

fid = fopen (sprintf('%s/Data/CZO/TDR.dat',src));
data = textscan(fid, '%s %f %f','headerlines',1,'delimiter','\t');
fclose(fid);
[site_id, TDR(:,1), TDR(:,2)]= data{:};

fsize = 32;
filename=sprintf('%s/Data/CZO/dem.csv',src);
%[point_No Z X Y]=textread(filename,'%d %f %f %f','delimiter',',','headerlines',1);
actual_boundary = load(sprintf('%s/Data/CZO/SSHO_boundary.dat',src));
actual_stream = load(sprintf('%s/Data/CZO/SSHO_stream.dat',src));

xlin=linspace(min(actual_boundary(:,1)),max(actual_boundary(:,1)),1000);
ylin=linspace(min(actual_boundary(:,2)),max(actual_boundary(:,2)),1000);
[Xgrid,Ygrid]=meshgrid(xlin,ylin);
Zgrid = load(sprintf('%s/Flux-PIHM/analy/SSHO.mat',src));
mapinfo=load('usalo.mat');
mapinfohi=load('usahi.mat');
lon0 = -(77.0+54.4/60.0);
lat0 = 40.0+(39.0+87.0/60.0)/60.0;

scrsz = get(0,'ScreenSize');
figure('Position',[50 20 0.8*scrsz(3) scrsz(4)]);
axes('Position',[-0.05 0 1 1]);
h = surf(Xgrid,Ygrid,Zgrid.Zgrid-500,Zgrid.Zgrid); % interpolated
view(0,90);
set(h,'EdgeColor','none');
%hl = camlight('left');
%a = makeColorMap([1 0 0],[1 1 1],[0 0 1],40);
LB = flipud(lbmap(256,'BrownBlue'));
colormap(LB);
caxis([250 310]);
shading interp;
set(gca,'DataAspectRatio',[1 1 1]);
%caxis([256 310]);
%C = colorbar('location','SouthOutside','Position',[0.3 0.15 0.4 0.05],'FontSize',fsize-4);
%xlabel(C,'Surface Elevation (m)','FontSize',fsize);
hold on
th = triplot(tri,x,y,'k-','LineWidth',1);
plot(actual_boundary(:,1),actual_boundary(:,2),'-','Color','k','LineWidth',3);
for i=1:NumRiv
    h(5) = plot([x(fromnode(i)) x(tonode(i))],[y(fromnode(i)) y(tonode(i))],'b','LineWidth',3);
    hold on;
end
h(6) = plot(NaN,NaN,'k^','LineWidth',1,'MarkerSize',25);

%[C, ch] = contour(Xgrid, Ygrid, Zgrid.Zgrid);
%set(ch,'Color',.9*[1 1 1]);
%set(ch,'ShowText','on','TextStep',10)
%text_handle = clabel(C,ch, 260:10:310);
%set(text_handle,'Color',.9*[1 1 1],'Interpreter','latex','FontSize',fsize-10);

% h(1) = plot(RTH3_x, RTH3_y,'o','MarkerSize',14,'MarkerEdgeColor','k','MarkerFaceColor','c');
% hold on;
% h(2) = plot(soiltemp_x, soiltemp_y,'p','MarkerSize',14,'MarkerEdgeColor','k','MarkerFaceColor','r');
% h(3) = plot(ectower(1),ectower(2),'s','MarkerSize',14,'MarkerEdgeColor','k','MarkerFaceColor','g');
% hold on;
% h(4) = plot(outlet(1),outlet(2),'d','MarkerSize',14,'MarkerEdgeColor','k','MarkerFaceColor','m');
% hold on;
% text(RTH3_x(1)-16,RTH3_y(1),'2','Color','w','FontSize',32);
% text(RTH3_x(2)-6,RTH3_y(2)+13,'1','Color','w','FontSize',32);
% text(RTH3_x(3)+5,RTH3_y(3),'3','Color','w','FontSize',32);

h(1) = plot(RTH3_x, RTH3_y,'o','MarkerSize',16,'MarkerEdgeColor','k','MarkerFaceColor','r');
hold on;
%h(NumEle+5) = plot(soiltemp_x, soiltemp_y,'p','MarkerSize',14,'MarkerEdgeColor','k','MarkerFaceColor','r');
hold on;
h(2) = plot(outlet(1),outlet(2),'d','MarkerSize',20,'MarkerEdgeColor','k','MarkerFaceColor','m');
hold on;
h(3) = plot(TDR(:,1),TDR(:,2),'o','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','g');
h(4) = plot(ectower(1),ectower(2),'s','MarkerSize',20,'MarkerEdgeColor','k','MarkerFacecolor','c');

northarrow;
set(gca,'FontSize',fsize-4,'DataAspectRatio',[1 1 1]);
axis off;
latex_colorbar('Position',[0.85 0.25 0.015 0.32], 'Ticks',250:10:310,'Caxis',[250 310],'FontSize',fsize-5, 'Title','Surface elevation (m)','LabelDist',0.6, 'TitleDist',5);
% sh = axes('Position',[0.15 0 0.3 0.2]);
% p=get(gca,'position'); lh=legend(sh,h(1:2),'RTHnet wells 1, 2, and 3','Soil temperature stations');
% set(lh,'position',p,'FontSize',fsize,'Box', 'off','Color', 'none');  axis(sh,'off');
% sh = axes('Position',[0.5 0. 0.3 0.2]);
% p=get(gca,'position'); lh=legend(sh,h(3:4),'Flux tower and weather station','Outlet gauge');
% set(lh,'position',p,'FontSize',fsize,'Box', 'off','Color', 'none');  axis(sh,'off');

%sh = axes('Position',[0.2 0 0.3 0.25]);
%p=get(gca,'position'); lh=legend(sh,h(NumEle:NumEle+3),'Model grid','Actual watershed boundary','Modeled stream path','Actual stream path');
%set(lh,'position',p,'FontSize',fsize,'Box', 'off','Color', 'none','interpreter','latex');
%axis(sh,'off');

sh = axes('Position',[0.35 0.03 0.3 0.25]);
p=get(gca,'position'); lh=legend(sh,h(1:4),'RTHnet wells','Outlet gauge','TDR-tensiometer sites','Weather station and flux tower');
set(lh,'position',p,'FontSize',fsize-5,'Box', 'off','Color', 'none','interpreter','latex');  axis(sh,'off');

sh = axes('Position',[0.65 0.03 0.3 0.25]);
p=get(gca,'position'); lh=legend(sh,h(5:6),'Modeled stream path','Model grid');
set(lh,'position',p,'FontSize',fsize-5,'Box', 'off','Color', 'none','interpreter','latex');  axis(sh,'off');


axes('Position',[0. 0.7 0.3 0.3]);
m_proj('mercator','lon',[-81 -74],'lat',[39.5 42.5]);
m_patch(mapinfohi.statepatch(21).long,mapinfohi.statepatch(21).lat,0.8*[1 1 1]);
hold on;
m_plot(lon0,lat0,'kp','MarkerSize',20,'MarkerFaceColor','k');
hold on;
m_plot(mapinfohi.stateline(21).long,mapinfohi.stateline(21).lat,'k-','LineWidth',2);
set(gca,'DataAspectRatio',[1 1 1]);
%m_plot(mapinfo.uslon,mapinfo.uslat,'k-','LineWidth',2);
%hold on;
%m_plot(mapinfo.gtlakelon,mapinfo.gtlakelat,'b-','LineWidth',2);
%m_grid('tickdir','in','box','fancy','FontSize',fsize-5);
axis off;
m_text(lon0,41.2,'SSHCZO','interpreter','latex','HorizontalAlignment','Center','FontSize',fsize);
%hold off;

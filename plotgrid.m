clear all;
close all;

fsize = 28;

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
ectower = [254492.82408600000	4505491.54761000000];
outlet = [254213.94182700000	4505406.84737000000];
%outlet = [254236.24028000000	4505632.24811000000];

fid = fopen (sprintf('%s/Data/CZO/TDR.dat',src));
data = textscan(fid, '%s %f %f','headerlines',1,'delimiter','\t');
fclose(fid);
[site_id, TDR(:,1), TDR(:,2)]= data{:};

text_pos = [2.5423e5, 4.50549e6];
projectName=textread(sprintf('%s/Flux-PIHM-2.0/input/projectName.txt',src),'%s');

projectName{1} = 'shp';
[NumEle, NumNode, eleind, nodeind, x, y, zmin, zmax, tri,nabr] = read_mesh_func_old(projectName);

[NumRiv, rivind, fromnode, tonode]=read_riv_func_old(projectName);

actual_boundary = load(sprintf('%s/Data/CZO/SSHO_boundary.dat',src));
actual_stream = load(sprintf('%s/Data/CZO/SSHO_stream.dat',src));


for i=1:NumEle
    %z(i,1) = mean([zmax(tri(i,1))-zmin(tri(i,1)),zmax(tri(i,2))-zmin(tri(i,2)),zmax(tri(i,3))-zmin(tri(i,3))]);
    z(i,1) = mean([zmax(tri(i,1)),zmax(tri(i,2)),zmax(tri(i,3))]);
    aquifer(i)=mean([zmax(tri(i,1))-zmin(tri(i,1)),zmax(tri(i,2))-zmin(tri(i,2)),zmax(tri(i,3))-zmin(tri(i,3))]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot grids and river                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


scrsz = get(0,'ScreenSize');
figure('Position',[50 20 0.8*scrsz(3) scrsz(4)]);
axes('Position',[-0.05 0 0.9 1]);
patch(x(tri)',y(tri)',z','EdgeColor','none');

LB = flipud(lbmap(256,'BrownBlue'));
colormap(LB);
caxis([250 310]);
hold on;

triplot(tri,x,y,'k-','LineWidth',1);
%hold on;
%h(NumEle+1)=plot(actual_boundary(:,1),actual_boundary(:,2),'-.','Color',[1 1 1 ]*.3,'LineWidth',3);

hold on;

for i=1:NumRiv
    plot([x(fromnode(i)) x(tonode(i))],[y(fromnode(i)) y(tonode(i))],'b','LineWidth',3);
    hold on;
end
%plot(actual_stream(:,1),actual_stream(:,2),'b-.','LineWidth',3);
hold on;


for i = 1:NumEle
    if (nabr(i,1) == 0)
        plot([x(tri(i,2)) x(tri(i,3))],[y(tri(i,2)) y(tri(i,3))],'k-','LineWidth',1);
    end
    if (nabr(i,2) == 0)
        plot([x(tri(i,3)) x(tri(i,1))],[y(tri(i,3)) y(tri(i,1))],'k-','LineWidth',1);
    end
    if (nabr(i,3) == 0)
        plot([x(tri(i,2)) x(tri(i,1))],[y(tri(i,2)) y(tri(i,1))],'k-','LineWidth',1);
    end
end


%h(1) = plot(RTH3_x, RTH3_y,'^','MarkerSize',16,'MarkerEdgeColor','k','MarkerFaceColor','g');
hold on;
%h(NumEle+5) = plot(soiltemp_x, soiltemp_y,'p','MarkerSize',14,'MarkerEdgeColor','k','MarkerFaceColor','r');
hold on;
h(2) = plot(outlet(1),outlet(2),'d','MarkerSize',20,'MarkerEdgeColor','k','MarkerFaceColor','m');
hold on;
h(3) = plot(TDR(:,1),TDR(:,2),'wo','MarkerSize',10,'MarkerEdgeColor','w','MarkerFaceColor','r');
for i = 1:length(TDR)
    text(TDR(i,1), TDR(i,2), site_id{i},'FontSize',15);
end
%h(NumEle+8) = plot(COSMOS(1), COSMOS(2),'^','MarkerSize',16,'MarkerEdgeColor','k','MarkerFaceColor','b');
h(4) = plot(ectower(1),ectower(2),'s','MarkerSize',20,'MarkerEdgeColor','k','MarkerFacecolor','c');
northarrow;
set(gca,'FontSize',fsize-4,'DataAspectRatio',[1 1 1]);
%text(RTH3_x(1)-16,RTH3_y(1),'2','FontSize',32);
%text(RTH3_x(2)-6,RTH3_y(2)+13,'1','FontSize',32);
%text(RTH3_x(3)+5,RTH3_y(3),'3','FontSize',32);
axis off;
C=colorbar('Position',[0.85 0.45 0.015 0.3]);
set(C,'YAxisLocation','Right','YTick',250:10:310,'YTickLabel','','FontSize',fsize);
axes('Position',get(C,'Position'));
axis off
cbfreeze(C)
text(1.2,0/6,'250','HorizontalAlignment','left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
text(1.2,1/6,'260','HorizontalAlignment','left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
text(1.2,2/6,'270','HorizontalAlignment','left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
text(1.2,3/6,'280','HorizontalAlignment','left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
text(1.2,4/6,'290','HorizontalAlignment','left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
text(1.2,5/6,'300','HorizontalAlignment','left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
text(1.2,6/6,'310','HorizontalAlignment','left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
%text(1.1,13/16,'E','HorizontalAlignment','left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
%text(1.1,15/16,'SE','HorizontalAlignment','left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
text(4.5,0.5,'Surface elevation (m)','HorizontalAlignment','center','VerticalAlignment','Middle','Rotation',90,'Interpreter','latex','FontSize',fsize);

% sh = axes('Position',[0.5 0.05 0.3 0.25]);
% p=get(gca,'position'); lh=legend(sh,h(NumEle:NumEle+3),'Model grid','Actual watershed boundary','Modeled stream path','Actual stream path');
% set(lh,'position',p,'FontSize',fsize,'Box', 'off','Color', 'none','interpreter','latex');
% axis(sh,'off');

sh = axes('Position',[0.5 0.08 0.3 0.25]);
p=get(gca,'position'); lh=legend(sh,h(1:4),'RTHnet wells','Outlet gauge','TDR-Tensiometer sites','Weather station');
set(lh,'position',p,'FontSize',fsize-5,'Box', 'off','Color', 'none','interpreter','latex');  axis(sh,'off');

mapinfo=load('usalo.mat');
mapinfohi=load('usahi.mat');
lon0 = -(77.0+54.4/60.0);
lat0 = 40.0+(39.0+87.0/60.0)/60.0;
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
m_text(-79,41.2,'SSHCZO','interpreter','latex','FontSize',25);
hold off;

%northarrow;
%set(gca,'xlim',[x0-80 x0+480],'ylim',[y0-200 y0+100],'FontSize',fsize,'DataAspectRatio',[1 1 1]);

%sh = axes('Position',[0.7 0 0.3 1]);
%p=get(gca,'position'); lh=legend(sh,h(NumEle:NumEle+6),'Model grid','Actual watershed boundary','Model stream path','Actual stream path',...
%    'RTHnet wells','Flux tower and weather station','Outlet gauge'); set(lh,'position',p,'FontSize',fsize-2,'Box', 'off','Color', 'none');  axis(sh,'off');




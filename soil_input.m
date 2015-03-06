clear all;
close all;clc;

fsize = 22;

str = computer;
if (strncmp(str,'PCWIN',5))
    src = 'C:/Users/yzs123/Dropbox/Research';
else if (strncmp(str,'MACI',4))
        src = '/Users/Yuning/Dropbox/Research';
    end
end



text_pos = [2.5423e5, 4.50549e6];

projectName{1} = 'shp';
[NumEle, NumNode, eleind, nodeind, x, y, zmin, zmax, tri,nabr] = read_mesh_func(projectName);
[soil, geol, lc] = read_att_func(projectName);
soil_1 = find(soil ==1);
soil_2 = find(soil ==2);
soil_3 = find(soil == 3);
soil_4 = find(soil == 4);
soil_5 = find(soil == 5);

deciduous = find(lc ==1 | lc == 4 | lc ==7);
evergreen = find(lc == 2 | lc == 5 | lc == 8);
mixed = find(lc ==3 | lc ==6 | lc ==9);


for i=1:NumEle
    z(i,1) = mean([zmax(tri(i,1)),zmax(tri(i,2)),zmax(tri(i,3))]);
    aquifer(i)=mean([zmax(tri(i,1))-zmin(tri(i,1)),zmax(tri(i,2))-zmin(tri(i,2)),zmax(tri(i,3))-zmin(tri(i,3))]);
end

projectName{1} = 'sha';
[NumEle, NumNode, eleind, nodeind, x, y, zmin, zmax, tri,nabr] = read_mesh_func(projectName);
[soil, geol, lc] = read_att_func(projectName);
SSURGO_soil_1 = find(soil ==1);
SSURGO_soil_2 = find(soil ==2);
SSURGO_soil_3 = find(soil == 4);

projectName{1} = 'shb';
%[NumEle, NumNode, eleind, nodeind, x, y, zmin, zmax, tri,nabr] = read_mesh_func(projectName);
[soil, geol, lc] = read_att_func(projectName);
NLCD_deciduous = find(lc ==1);
NLCD_evergreen = find(lc == 2);
NLCD_mixed = find(lc ==3);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot surface elevation, soil, geology, and landcover         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Position',[1 1 1250 1000]);

top_margin = 0.10;
left_margin = 0.18;
y_interval = 0.16;
x_interval = 0.28;
width = 0.3;
height = 0.25;

axes('Position',[left_margin 1 - top_margin - y_interval width height]);

for i = 1:length(soil_1)
    soil_h(1) = fill(x(tri(soil_1(i),:)),y(tri(soil_1(i),:)),[255/255 250/255 205/255],'EdgeColor','none');
    hold on;
end
for i = 1:length(soil_2)
    soil_h(2) = fill(x(tri(soil_2(i),:)),y(tri(soil_2(i),:)),[244/255 164/255 96/255],'EdgeColor','none');
    hold on;
end
for i = 1:length(soil_3)
    soil_h(3) = fill(x(tri(soil_3(i),:)),y(tri(soil_3(i),:)),[255/255 215/255 0/255],'EdgeColor','none');
    hold on;
end
for i = 1:length(soil_4)
    soil_h(4) = fill(x(tri(soil_4(i),:)),y(tri(soil_4(i),:)),[34/255 139/255 34/255],'EdgeColor','none');
    hold on;
end
for i = 1:length(soil_5)
    soil_h(5) = fill(x(tri(soil_5(i),:)),y(tri(soil_5(i),:)),'b','EdgeColor','none');
    hold on;
end
triplot(tri,x,y,'k-','LineWidth',1);
ylim = [min(y) - 20 max(y)+20];
set(gca,'ylim',ylim,'FontSize',fsize-5,'FontWeight','Bold','DataAspectRatio',[1 1 1]);
axis off;

newjet = flipud(colormap('jet'));


axes('Position',[left_margin+x_interval 1-top_margin-y_interval width height]);
patch(x(tri)',y(tri)',aquifer,'EdgeColor','none');
caxis([1.6 3.2]);
hold on;
triplot(tri,x,y,'k-','LineWidth',1);
set(gca,'ylim',ylim,'FontSize',fsize-5,'DataAspectRatio',[1 1 1]);
axis off;
colormap(newjet);
freezeColors

axes('Position',[left_margin+2*x_interval 1-top_margin-y_interval width height]);
for i = 1:length(deciduous)
    lc_h(1) = fill(x(tri(deciduous(i),:)),y(tri(deciduous(i),:)),[34 139 34]/255,'EdgeColor','none');
    hold on;
end
for i = 1:length(evergreen)
    lc_h(2) = fill(x(tri(evergreen(i),:)),y(tri(evergreen(i),:)),[127 255 0]/255,'EdgeColor','none');
    hold on;
end
for i = 1:length(mixed)
    lc_h(3) = fill(x(tri(mixed(i),:)),y(tri(mixed(i),:)),[122 205 170]/255,'EdgeColor','none');
    hold on;
end
triplot(tri,x,y,'k-','LineWidth',1);
set(gca,'ylim',ylim,'FontSize',fsize-5,'FontWeight','Bold','DataAspectRatio',[1 1 1]);
axis off;

axes('Position',[left_margin 1-top_margin-2*y_interval width height]);
for i = 1:length(SSURGO_soil_1)
    soil_h(1) = fill(x(tri(SSURGO_soil_1(i),:)),y(tri(SSURGO_soil_1(i),:)),[255/255 250/255 205/255],'EdgeColor','none');
    hold on;
end
for i = 1:length(SSURGO_soil_2)
    soil_h(2) = fill(x(tri(SSURGO_soil_2(i),:)),y(tri(SSURGO_soil_2(i),:)),[244/255 164/255 96/255],'EdgeColor','none');
    hold on;
end
for i = 1:length(SSURGO_soil_3)
    soil_h(5) = fill(x(tri(SSURGO_soil_3(i),:)),y(tri(SSURGO_soil_3(i),:)),'b','EdgeColor','none');
    hold on;
end
triplot(tri,x,y,'k-','LineWidth',1);
%xlim = get(gca,'xlim');
set(gca,'ylim',ylim,'FontSize',fsize-5,'FontWeight','Bold','DataAspectRatio',[1 1 1]);
axis off;

axes('Position',[left_margin+x_interval 1-top_margin-2*y_interval width height]);
patch(x(tri)',y(tri)',2*ones(size(aquifer)),'EdgeColor','none');
caxis([1.6 3.2]);
hold on;
triplot(tri,x,y,'k-','LineWidth',1);
set(gca,'ylim',ylim,'FontSize',fsize-5,'DataAspectRatio',[1 1 1]);
axis off;
colormap(newjet);
freezeColors

axes('Position',[left_margin+2*x_interval 1-top_margin-2*y_interval width height]);
for i = 1:length(deciduous)
    lc_h(1) = fill(x(tri(deciduous(i),:)),y(tri(deciduous(i),:)),[34 139 34]/255,'EdgeColor','none');
    hold on;
end
for i = 1:length(evergreen)
    lc_h(2) = fill(x(tri(evergreen(i),:)),y(tri(evergreen(i),:)),[127 255 0]/255,'EdgeColor','none');
    hold on;
end
for i = 1:length(mixed)
    lc_h(3) = fill(x(tri(mixed(i),:)),y(tri(mixed(i),:)),[122 205 170]/255,'EdgeColor','none');
    hold on;
end
triplot(tri,x,y,'k-','LineWidth',1);
set(gca,'ylim',ylim,'FontSize',fsize-5,'FontWeight','Bold','DataAspectRatio',[1 1 1]);
axis off;

axes('Position',[left_margin 1-top_margin-3*y_interval width height]);
for i = 1:length(soil_1)
    soil_h(1) = fill(x(tri(soil_1(i),:)),y(tri(soil_1(i),:)),[255/255 250/255 205/255],'EdgeColor','none');
    hold on;
end
for i = 1:length(soil_2)
    soil_h(2) = fill(x(tri(soil_2(i),:)),y(tri(soil_2(i),:)),[244/255 164/255 96/255],'EdgeColor','none');
    hold on;
end
for i = 1:length(soil_3)
    soil_h(3) = fill(x(tri(soil_3(i),:)),y(tri(soil_3(i),:)),[255/255 215/255 0/255],'EdgeColor','none');
    hold on;
end
for i = 1:length(soil_4)
    soil_h(4) = fill(x(tri(soil_4(i),:)),y(tri(soil_4(i),:)),[34/255 139/255 34/255],'EdgeColor','none');
    hold on;
end
for i = 1:length(soil_5)
    soil_h(5) = fill(x(tri(soil_5(i),:)),y(tri(soil_5(i),:)),'b','EdgeColor','none');
    hold on;
end
triplot(tri,x,y,'k-','LineWidth',1);
%xlim = get(gca,'xlim');
set(gca,'ylim',ylim,'FontSize',fsize-5,'FontWeight','Bold','DataAspectRatio',[1 1 1]);
axis off;

axes('Position',[left_margin+x_interval 1-top_margin-3*y_interval width height]);
patch(x(tri)',y(tri)',2*ones(size(aquifer)),'EdgeColor','none');
caxis([1.6 3.2]);
hold on;
triplot(tri,x,y,'k-','LineWidth',1);
set(gca,'ylim',ylim,'FontSize',fsize-5,'DataAspectRatio',[1 1 1]);
axis off;
colormap(newjet);
freezeColors

axes('Position',[left_margin+2*x_interval 1-top_margin-3*y_interval width height]);
for i = 1:length(deciduous)
    lc_h(1) = fill(x(tri(deciduous(i),:)),y(tri(deciduous(i),:)),[34 139 34]/255,'EdgeColor','none');
    hold on;
end
for i = 1:length(evergreen)
    lc_h(2) = fill(x(tri(evergreen(i),:)),y(tri(evergreen(i),:)),[127 255 0]/255,'EdgeColor','none');
    hold on;
end
for i = 1:length(mixed)
    lc_h(3) = fill(x(tri(mixed(i),:)),y(tri(mixed(i),:)),[122 205 170]/255,'EdgeColor','none');
    hold on;
end
triplot(tri,x,y,'k-','LineWidth',1);
set(gca,'ylim',ylim,'FontSize',fsize-5,'FontWeight','Bold','DataAspectRatio',[1 1 1]);
axis off;



% axes('Position',[0.2 top-4*d 0.4 0.25]);
% for i = 1:NumEle
%         fill(x(tri(i,:)),y(tri(i,:)),[255/255 250/255 205/255],'EdgeColor','none');
%         hold on;
% end
% triplot(tri,x,y,'k-','LineWidth',1);
% %xlim = get(gca,'xlim');
% set(gca,'ylim',ylim,'FontSize',fsize-5,'FontWeight','Bold','DataAspectRatio',[1 1 1]);
% axis off;
%
% axes('Position',[0.6 top-4*d 0.4 0.2]);
% patch(x(tri)',y(tri)',aquifer,'EdgeColor','none');
% caxis([1.6 3.2]);
% hold on;
% triplot(tri,x,y,'k-','LineWidth',1);
% set(gca,'ylim',ylim,'FontSize',fsize-5,'DataAspectRatio',[1 1 1]);
% axis off;
% colormap(newjet);
% freezeColors

axes('Position',[left_margin 1-top_margin-4*y_interval width height]);
patch(x(tri)',y(tri)',2*ones(size(aquifer)),'EdgeColor','none');
caxis([1.6 3.2]);
hold on;
triplot(tri,x,y,'k-','LineWidth',1);
set(gca,'ylim',ylim,'FontSize',fsize-5,'DataAspectRatio',[1 1 1]);
axis off;
colormap(newjet);
freezeColors

axes('Position',[left_margin 1-top_margin-4*y_interval width height]);
for i = 1:NumEle
    fill(x(tri(i,:)),y(tri(i,:)),[255/255 250/255 205/255],'EdgeColor','none');
    hold on;
end
triplot(tri,x,y,'k-','LineWidth',1);
%xlim = get(gca,'xlim');
set(gca,'ylim',ylim,'FontSize',fsize-5,'FontWeight','Bold','DataAspectRatio',[1 1 1]);
axis off;

axes('Position',[left_margin+x_interval 1-top_margin-4*y_interval width height]);
patch(x(tri)',y(tri)',2*ones(size(aquifer)),'EdgeColor','none');
caxis([1.6 3.2]);
hold on;
triplot(tri,x,y,'k-','LineWidth',1);
set(gca,'ylim',ylim,'FontSize',fsize-5,'DataAspectRatio',[1 1 1]);
axis off;
colormap(newjet);
freezeColors


axes('Position',[left_margin+2*x_interval 1-top_margin-4*y_interval width height]);
for i = 1:length(deciduous)
    lc_h(1) = fill(x(tri(deciduous(i),:)),y(tri(deciduous(i),:)),[34 139 34]/255,'EdgeColor','none');
    hold on;
end
for i = 1:length(evergreen)
    lc_h(2) = fill(x(tri(evergreen(i),:)),y(tri(evergreen(i),:)),[127 255 0]/255,'EdgeColor','none');
    hold on;
end
for i = 1:length(mixed)
    lc_h(3) = fill(x(tri(mixed(i),:)),y(tri(mixed(i),:)),[122 205 170]/255,'EdgeColor','none');
    hold on;
end
triplot(tri,x,y,'k-','LineWidth',1);
set(gca,'ylim',ylim,'FontSize',fsize-5,'FontWeight','Bold','DataAspectRatio',[1 1 1]);
axis off;

axes('Position',[left_margin 1 - top_margin - 5*y_interval width height]);

for i = 1:length(soil_1)
    soil_h(1) = fill(x(tri(soil_1(i),:)),y(tri(soil_1(i),:)),[255/255 250/255 205/255],'EdgeColor','none');
    hold on;
end
for i = 1:length(soil_2)
    soil_h(2) = fill(x(tri(soil_2(i),:)),y(tri(soil_2(i),:)),[244/255 164/255 96/255],'EdgeColor','none');
    hold on;
end
for i = 1:length(soil_3)
    soil_h(3) = fill(x(tri(soil_3(i),:)),y(tri(soil_3(i),:)),[255/255 215/255 0/255],'EdgeColor','none');
    hold on;
end
for i = 1:length(soil_4)
    soil_h(4) = fill(x(tri(soil_4(i),:)),y(tri(soil_4(i),:)),[34/255 139/255 34/255],'EdgeColor','none');
    hold on;
end
for i = 1:length(soil_5)
    soil_h(5) = fill(x(tri(soil_5(i),:)),y(tri(soil_5(i),:)),'b','EdgeColor','none');
    hold on;
end
triplot(tri,x,y,'k-','LineWidth',1);
ylim = [min(y) - 20 max(y)+20];
set(gca,'ylim',ylim,'FontSize',fsize-5,'FontWeight','Bold','DataAspectRatio',[1 1 1]);
axis off;

newjet = flipud(colormap('jet'));


axes('Position',[left_margin+x_interval 1-top_margin-5*y_interval width height]);
patch(x(tri)',y(tri)',aquifer,'EdgeColor','none');
caxis([1.6 3.2]);
hold on;
triplot(tri,x,y,'k-','LineWidth',1);
set(gca,'ylim',ylim,'FontSize',fsize-5,'DataAspectRatio',[1 1 1]);
axis off;
colormap(newjet);
freezeColors

latex_colorbar('Position',[0.46 0.01 0.25 0.08], 'Ticks',1.6:0.4:3.2, 'Caxis',[1.6 3.2],'FontSize',fsize-3, 'LabelDist',0.6, 'TitleDist',2, 'Dir','Horizontal');


axes('Position',[left_margin+2*x_interval 1-top_margin-5*y_interval width height]);
for i = 1:length(NLCD_deciduous)
    lc_h(1) = fill(x(tri(NLCD_deciduous(i),:)),y(tri(NLCD_deciduous(i),:)),[34 139 34]/255,'EdgeColor','none');
    hold on;
end
for i = 1:length(NLCD_evergreen)
    lc_h(2) = fill(x(tri(NLCD_evergreen(i),:)),y(tri(NLCD_evergreen(i),:)),[127 255 0]/255,'EdgeColor','none');
    hold on;
end
for i = 1:length(NLCD_mixed)
    lc_h(3) = fill(x(tri(NLCD_mixed(i),:)),y(tri(NLCD_mixed(i),:)),[122 205 170]/255,'EdgeColor','none');
    hold on;
end
triplot(tri,x,y,'k-','LineWidth',1);
set(gca,'ylim',ylim,'FontSize',fsize-5,'FontWeight','Bold','DataAspectRatio',[1 1 1]);
axis off;

% top_margin = 0.10;
% left_margin = 0.18;
% y_interval = 0.16;
% x_interval = 0.28;
% width = 0.3;
% height = 0.25;

sh = axes('Position',[0.2 0.03 0.08 0.08]);
p=get(sh,'position');
lh = legend(sh, soil_h(1:3),'Weikert', 'Berks','Rushtown');
set(lh,'Position',p,'Box','off','interpreter','latex','FontSize',fsize-5);
axis(sh,'off');
sh1 = axes('Position',[0.32 0.03 0.08 0.08]);
p1=get(sh1,'position');
lh1 = legend(sh1, soil_h(4:5),'Blairton','Ernest','Location','SouthEast');
set(lh1,'Position',p1,'Box','off','interpreter','latex','FontSize',fsize-5);
axis(sh1,'off');

sh = axes('Position',[0.8 0.03 0.16 0.08]);
p=get(sh,'position');
lh = legend(sh, lc_h(1:3),'Deciduous', 'Evergreen','Mixed');
set(lh,'Position',p,'Box','off','interpreter','latex','FontSize',fsize-5);
axis(sh,'off');

axes('position',[0 0 1 1]);
text(left_margin-0.35*x_interval,0.98,'Simulation','HorizontalAlignment','Center','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
text(left_margin+0.5*x_interval,0.98,'Soil map','HorizontalAlignment','Center','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
text(left_margin+1.5*x_interval,0.98,'Bedrock depth (m)','HorizontalAlignment','Center','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
text(left_margin+2.5*x_interval,0.98,'Land cover map','HorizontalAlignment','Center','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
%text(0.745,0.98,'Flux-PIHM','HorizontalAlignment','Center','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
text(0.02,1-top_margin-0.2*y_interval,'Field survey','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
text(0.02,1-top_margin-1.2*y_interval,'SSURGO','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
text(0.02,1-top_margin-2.2*y_interval,'2-m BRD','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
text(0.02,1-top_margin-3.2*y_interval,'Uniform soil','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
text(0.02,1-top_margin-4.2*y_interval,'NLCD','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
%text(0.02,top-4.5*d,'Topographic','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
axis off;
axes('position',[0 0 1 1]);
line([0.01 0.98],[0.96 0.96],'Color','k');
set(gca,'xlim',[0 1],'ylim',[0 1]);
axis off;




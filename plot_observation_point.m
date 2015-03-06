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

projectName = {'shp'};
actual_boundary = load(sprintf('%s/Data/CZO/SSHO_boundary.dat',src));
[NumRiv, rivind, fromnode tonode] = read_riv_func_old(projectName);
%[KsatH, KsatV, ThetaS, ThetaR, Alpha, Beta, vAreaF, macKsatH, macD] = read_geol_func(projectName);
xlin=linspace(X0,X0+COLS-1,COLS);
ylin=linspace(Y0+ROWS-1,Y0,ROWS);
[Xgrid,Ygrid]=meshgrid(xlin,ylin);

obs_dates = [datenum(2009,4,26,0,0,0)...
    datenum(2009,5,3,0,0,0) datenum(2009,5,13,0,0,0) datenum(2009,5,21,0,0,0) datenum(2009,5,28,0,0,0)...
    datenum(2009,6,2,0,0,0) datenum(2009,6,24,0,0,0)...
    datenum(2009,7,2,0,0,0)...
    datenum(2009,8,12,0,0,0) datenum(2009,8,14,0,0,0) datenum(2009,8,23,0,0,0) datenum(2009,8,30,0,0,0)...
    datenum(2009,9,4,0,0,0)...
    datenum(2009,10,3,0,0,0) datenum(2009,10,9,0,0,0)
    ];

fid = fopen (sprintf('%s/Data/CZO/TDR.dat',src));
data = textscan(fid, '%s %f %f','headerlines',1,'delimiter','\t');
fclose(fid);
[site_id, TDR(:,1), TDR(:,2)]= data{:};

fid = fopen(sprintf('%s/Data/CZO/SM/MS_70cm.dat',src));
data = textscan(fid, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f','headerlines',1,'delimiter','\t');
fclose(fid);

left_margin = -0.05;
top_margin = 0.05;
width = 0.38;
height = 0.28;
x_int = -0.08;
y_int = -0.08;

% left_margin = -0.1;
% top_margin = 0.05;
% width = 0.7;
% height = 0.38;
% x_int = -0.3;
% y_int = -0.12;

pos = zeros(1,2);

figure('Position',[1 1 1200 950]);
for j = 1:length(obs_dates)
    pos(1) = rem(j, 3);
    if pos(1) == 0
        pos(1) = 3;
    end
    pos(2) = ceil(j/3);
    axes('position',[left_margin + (pos(1) - 1) * (width + x_int) 1 - top_margin - pos(2) * (height + y_int) width height]);
    
    data_interp = load(sprintf('%s/Data/CZO/SM/%s-agrg.dat',src,datestr(obs_dates(j), 'yyyy-mm-dd')))/ 0.7;
    h = surf(Xgrid,Ygrid,zeros(size(Xgrid)),data_interp,'edgecolor','none'); % interpolated
    hold on;
    for i = 1:length(TDR)
        
        if ~isnan(data{j+1}(i))
            x = TDR(i,1);
            y = TDR(i,2);
            r = 14;
            th = 0:pi/50:2*pi;
            xunit = r * cos(th) + x;
            yunit = r * sin(th) + y;
            plot(xunit, yunit, 'k');
            h = fill (xunit,yunit,data{j+1}(i)/0.7);
        end
%         if i == 1
%             disp(data{j+1}(i));
%             disp(pos);
%             disp(y);
%         end
        set(h,'EdgeColor','none');
        hold on;
    end
        %h = plot(xunit, yunit);
        
        %rectangle('Position',TDR(i,1), TDR(i,2), 10, 10, 'Curvature', [1,1]);
        
    
    newjet = flipud(colormap('jet'));
    colormap(newjet);
    caxis([0.1 0.25]);
%    set(h,'edgecolor','none');
    hold on;
    plot(actual_boundary(:,1),actual_boundary(:,2),'k','LineWidth',3);
    %plot(TDR(:,1),TDR(:,2),'o','MarkerSize',6,'MarkerEdgeColor','k','MarkerFaceColor','w');
    set(gca,'xlim',[min(actual_boundary(:,1)) max(actual_boundary(:,1))],'DataAspectRatio',[1 1 1]);
    %set(gca,'DataAspectRatio',[1 1 1]);
    view(0, 90);
    axis off;
    text(X0 + 50, Y0 + 300, datestr(obs_dates(j),'dd mmm'),'FontSize',fsize - 3, 'Interpreter', 'latex');
    
    
end

% axes('position',[0 0 1 1]);
% %text(0.22,0.98,'\bf Measured (aggregated)','HorizontalAlignment','Center','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
% text(0.22,0.98,'\bf Measured','HorizontalAlignment','Center','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
% %text(0.54,0.98,'\bf Field survey simulation','HorizontalAlignment','Center','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
% text(0.54,0.98,'\bf Flux-PIHM','HorizontalAlignment','Center','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
% text(0.91,0.98,'Profile','HorizontalAlignment','Center','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
% text(0.01,0.85,'Jun','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
% text(0.01,0.6,'Jul','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
% text(0.01,0.35,'Aug','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
% text(0.01,0.1,'Sep','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
% axis off;


%latex_colorbar('Position',[0.93 0.15 0.015 0.6], 'Ticks',0.1:0.05:0.25, 'Caxis',[0.1 0.25],'FontSize',fsize, 'LabelDist',0.6, 'TitleDist',3);

C=colorbar;
set(C,'Position',[0.95 0.15 0.015 0.6],'YAxisLocation','Right','YTick',0.1:0.05:0.25,'YTickLabel','','FontSize',fsize);
axes('Position',get(C,'Position'));
axis off;

text(-0.1,0,'$<=$0.10','HorizontalAlignment','Right','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
text(-0.1,1/3,'0.15','HorizontalAlignment','Right','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
text(-0.1,2/3,'0.20','HorizontalAlignment','Right','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
%text(-0.1,3/3,'0.20','HorizontalAlignment','Right','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
text(-0.1,4/4,'$>=$0.25','HorizontalAlignment','Right','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
text(-3.5,0.5,'Soil water content (m$^3$ m$^{-3}$)','HorizontalAlignment','center','VerticalAlignment','Middle','Rotation',90,'Interpreter','latex','FontSize',fsize);

%     CB=colorbar('Location','East','Position',[0.7 0.2 0.02 0.6],'FontSize',fsize-5);
%     ylabel(CB,'{Soil saturation} (-)','FontSize',fsize,'FontWeight','Bold');
%     set(CB,'YAxisLocation','Right');
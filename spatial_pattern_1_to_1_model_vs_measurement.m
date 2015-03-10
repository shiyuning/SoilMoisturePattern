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

projectName = {'shp'};

[NumEle, NumNode, eleind, nodeind, x, y, zmin, zmax, tri] = read_mesh_func_old(projectName);

fid = fopen (sprintf('%s/Data/CZO/TDR.dat',src));
data = textscan(fid, '%s %f %f','headerlines',1,'delimiter','\t');
fclose(fid);
[site_id, TDR(:,1), TDR(:,2)]= data{:};
    
within_grid = nan(length(TDR), 1);

for i = 1 : NumEle
    within_grid(inpolygon(TDR(:, 1), TDR(:, 2), x(tri(i, :)), y(tri(i, :)))) = i;
end
        

obs_dates = [datenum(2009,4,26,0,0,0)...
    datenum(2009,5,3,0,0,0) datenum(2009,5,13,0,0,0) datenum(2009,5,21,0,0,0) datenum(2009,5,28,0,0,0)...
    datenum(2009,6,2,0,0,0) datenum(2009,6,24,0,0,0)...
    datenum(2009,7,2,0,0,0)...
    datenum(2009,8,12,0,0,0) datenum(2009,8,14,0,0,0) datenum(2009,8,23,0,0,0) datenum(2009,8,30,0,0,0)...
    datenum(2009,9,4,0,0,0) ...
    datenum(2009,10,3,0,0,0) datenum(2009,10,9,0,0,0)];


fid = fopen(sprintf('%s/Data/CZO/SM/MS_10cm.dat',src));
data = textscan(fid, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f','headerlines',1,'delimiter','\t');
fclose(fid);


% % left_margin = -0.1;
% % top_margin = 0.05;
% % width = 0.7;
% % height = 0.38;
% % x_int = -0.3;
% % y_int = -0.12;
% % 
left_margin = 0.12;
top_margin = 0.02;
width = 0.17;
height = 0.272;
x_int = 0.00;
y_int = 0.00;
pos = zeros(1,2);

figure('Position', [1 1 1200 750]);

SUBPLOT_PER_ROW = 5;

for j = 1 : length(obs_dates)
    pos(1) = rem(j, SUBPLOT_PER_ROW);
    if pos(1) == 0
        pos(1) = SUBPLOT_PER_ROW;
    end
    pos(2) = ceil(j/SUBPLOT_PER_ROW);
    axes('position',[left_margin + (pos(1) - 1) * (width + x_int) 1 - top_margin - pos(2) * (height + y_int) width height]);
    [n, dsoil] = read_lsm_func_old(projectName);

    filename = sprintf('%s/Flux-PIHM-2.0/output/%s.smsp%s',src,projectName{1},datestr(obs_dates(j),'yyyymmdd'));
    fmt = ['%d' repmat('%f', 1, n)];
    fid = fopen(filename);
    temp=textscan(fid,fmt,'delimiter',',');
    fclose(fid);
    SM = zeros(size(temp{1},1),n);
    [ele] = temp{1};
    for i = 1:n
        SM(:,i) = temp{i+1};
    end
    
    for i = 1 : NumEle
        SWC(i) = SM(i, 1) * 0.0 + SM(i, 2) * 1.0;%(sum(SM(i , 1 : 4) .* dsoil(1 : 4)) + SM(i, 5) * (0.6 - sum(dsoil(1:4)))) / 0.6;
        plot (nanmean(data{j+1}(within_grid == i)), SWC(i), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
        hold on;
    end
    
    line([0 0.4], [0 0.4], 'LineStyle', '--', 'Color', 'k');
    
    set (gca, 'Xlim', [0 0.35], 'ylim', [0 0.35], 'DataAspectRatio', [1 1 1], 'ytick', 0.05:0.05:0.30, 'xtick', 0.1:0.1:0.30, 'FontSize',fsize-8);
    if pos(1) > 1
        set (gca, 'yticklabel','');
    end
    if pos(2) < 3
        set (gca, 'xticklabel', '');
    end
    
    text(0.02, 0.3, datestr(obs_dates(j),'dd mmm'),'FontSize',fsize - 8, 'Interpreter', 'latex', 'HorizontalAlignment', 'Left');

    plotTickLatex2D('ylabeldx',-0.1,'xlabeldy', 0);

    
% % 
% % left_margin = -0.05;
% % top_margin = 0.05;
% % width = 0.38;
% % height = 0.28;
% % x_int = -0.08;
% % y_int = -0.08;
% % 
% % left_margin = -0.1;
% % top_margin = 0.05;
% % width = 0.7;
% % height = 0.38;
% % x_int = -0.3;
% % y_int = -0.12;
% % 
% % pos = zeros(1,2);
% % 
% % figure('Position',[1 1 1200 950]);
% % for j = 1:length(obs_dates)
% %     pos(1) = rem(j, 3);
% %     if pos(1) == 0
% %         pos(1) = 3;
% %     end
% %     pos(2) = ceil(j/3);
% %     axes('position',[left_margin + (pos(1) - 1) * (width + x_int) 1 - top_margin - pos(2) * (height + y_int) width height]);
% %     
% %     data_interp = load(sprintf('%s/Data/CZO/SM/%s-agrg.dat',src,datestr(obs_dates(j), 'yyyy-mm-dd')))/ 0.7;
% %     h = surf(Xgrid,Ygrid,zeros(size(Xgrid)),data_interp,'edgecolor','none'); % interpolated
% %     hold on;
% %     for i = 1:length(TDR)
% %         
% %         if ~isnan(data{j+1}(i))
% %             x = TDR(i,1);
% %             y = TDR(i,2);
% %             r = 14;
% %             th = 0:pi/50:2*pi;
% %             xunit = r * cos(th) + x;
% %             yunit = r * sin(th) + y;
% %             plot(xunit, yunit, 'k');
% %             h = fill (xunit,yunit,data{j+1}(i)/0.7);
% %         end
% %         if i == 1
% %             disp(data{j+1}(i));
% %             disp(pos);
% %             disp(y);
% %         end
% %         set(h,'EdgeColor','none');
% %         hold on;
% %     end
% %         h = plot(xunit, yunit);
% %         
% %         rectangle('Position',TDR(i,1), TDR(i,2), 10, 10, 'Curvature', [1,1]);
% %         
% %     
% %     newjet = flipud(colormap('jet'));
% %     colormap(newjet);
% %     caxis([0.1 0.25]);
% %    set(h,'edgecolor','none');
% %     hold on;
% %     plot(actual_boundary(:,1),actual_boundary(:,2),'k','LineWidth',3);
% %     plot(TDR(:,1),TDR(:,2),'o','MarkerSize',6,'MarkerEdgeColor','k','MarkerFaceColor','w');
% %     set(gca,'xlim',[min(actual_boundary(:,1)) max(actual_boundary(:,1))],'DataAspectRatio',[1 1 1]);
% %     set(gca,'DataAspectRatio',[1 1 1]);
% %     view(0, 90);
% %     axis off;
% %     text(X0 + 50, Y0 + 300, datestr(obs_dates(j),'dd mmm'),'FontSize',fsize - 3, 'Interpreter', 'latex');
% %     
% %     
end

[ax1, h1] = suplabel('Observed SWC (m$^3$ m$^{-3}$)');
[ax2, h2] = suplabel('Simulated SWC (m$^3$ m$^{-3}$)','y');
set(h1, 'FontSize', fsize, 'interpreter', 'latex');
set(h2, 'FontSize', fsize, 'interpreter', 'latex');

% % 
% % axes('position',[0 0 1 1]);
% % %text(0.22,0.98,'\bf Measured (aggregated)','HorizontalAlignment','Center','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
% % text(0.22,0.98,'\bf Measured','HorizontalAlignment','Center','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
% % %text(0.54,0.98,'\bf Field survey simulation','HorizontalAlignment','Center','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
% % text(0.54,0.98,'\bf Flux-PIHM','HorizontalAlignment','Center','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
% % text(0.91,0.98,'Profile','HorizontalAlignment','Center','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
% % text(0.01,0.85,'Jun','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
% % text(0.01,0.6,'Jul','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
% % text(0.01,0.35,'Aug','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
% % text(0.01,0.1,'Sep','HorizontalAlignment','Left','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize);
% % axis off;
% % 
% % 
% % latex_colorbar('Position',[0.93 0.15 0.015 0.6], 'Ticks',0.1:0.05:0.25, 'Caxis',[0.1 0.25],'FontSize',fsize, 'LabelDist',0.6, 'TitleDist',3);
% % 
% % C=colorbar;
% % set(C,'Position',[0.95 0.15 0.015 0.6],'YAxisLocation','Right','YTick',0.1:0.05:0.25,'YTickLabel','','FontSize',fsize);
% % axes('Position',get(C,'Position'));
% % axis off;
% % 
% % text(-0.1,0,'$<=$0.10','HorizontalAlignment','Right','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
% % text(-0.1,1/3,'0.15','HorizontalAlignment','Right','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
% % text(-0.1,2/3,'0.20','HorizontalAlignment','Right','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
% % text(-0.1,3/3,'0.20','HorizontalAlignment','Right','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
% % text(-0.1,4/4,'$>=$0.25','HorizontalAlignment','Right','VerticalAlignment','Middle','Interpreter','latex','FontSize',fsize-5);
% % text(-3.5,0.5,'Soil water content (m$^3$ m$^{-3}$)','HorizontalAlignment','center','VerticalAlignment','Middle','Rotation',90,'Interpreter','latex','FontSize',fsize);
% % 
% %     CB=colorbar('Location','East','Position',[0.7 0.2 0.02 0.6],'FontSize',fsize-5);
% %     ylabel(CB,'{Soil saturation} (-)','FontSize',fsize,'FontWeight','Bold');
%     set(CB,'YAxisLocation','Right');
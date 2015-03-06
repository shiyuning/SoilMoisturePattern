clear all;
close all;
clc;

fsize = 20;

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
obs_dates = [datenum(2009,4,26,0,0,0)...
    datenum(2009,5,3,0,0,0) datenum(2009,5,13,0,0,0) datenum(2009,5,21,0,0,0) datenum(2009,5,28,0,0,0)...
    datenum(2009,6,2,0,0,0) datenum(2009,6,24,0,0,0)...
    datenum(2009,7,2,0,0,0)...
    datenum(2009,8,12,0,0,0) datenum(2009,8,14,0,0,0) datenum(2009,8,23,0,0,0) datenum(2009,8,30,0,0,0)...
    datenum(2009,9,4,0,0,0)...
    datenum(2009,10,3,0,0,0) datenum(2009,10,9,0,0,0)];

%depth = {'10cm','20cm','40cm','60cm','80cm','100cm'};

for j = 1:length(obs_dates)
    temp = zeros(ROWS,COLS,4);
    for i = 1:4
        filename = sprintf('%s/Data/CZO/SM/SM70_map_SM%s.asc', src, datestr(obs_dates(j),'mmddyy'));
        fid = fopen(filename,'r');
        file = textscan(fid,'%f','delimiter',' ','headerlines',6);
        temp(:,:,i) = reshape(file{1,1},COLS,ROWS)';
        fclose(fid);
    end
    temp(temp == -9999 | temp>1) = NaN;
    filename = sprintf('%s/Data/CZO/SM/%s.dat', src, datestr(obs_dates(j), 'yyyy-mm-dd'));
    data = nanmean(temp,3);
    save(filename, 'data', '-ASCII');
    
    actual_boundary = load(sprintf('%s/Data/CZO/SSHO_boundary.dat',src));
    xlin=linspace(X0,X0+COLS-1,COLS);
    ylin=linspace(Y0+ROWS-1,Y0,ROWS);
    [Xgrid,Ygrid]=meshgrid(xlin,ylin);
    SM=griddata(Xgrid(~isnan(data)),Ygrid(~isnan(data)),data(~isnan(data)),Xgrid,Ygrid,'linear');
    SM(~inpolygon(Xgrid,Ygrid,actual_boundary(:,1),actual_boundary(:,2))) = NaN;
    figure;
    h = surf(Xgrid,Ygrid,zeros(size(Xgrid)),SM,'edgecolor','none'); % interpolated
    %h = pcolor(Xgrid,Ygrid,SM); % interpolated
    newjet = flipud(colormap('jet'));
    colormap(newjet);
    caxis([0.1 0.4]);
    set(h,'edgecolor','none');
    hold on;
    plot(actual_boundary(:,1),actual_boundary(:,2),'k','LineWidth',3);
    
    set(gca,'DataAspectRatio',[1 1 1]);
    view(0, 90);
    axis off;
    colorbar;
end
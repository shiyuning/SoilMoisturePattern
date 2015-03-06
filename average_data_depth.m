clear all;
close all;
clc;

fsize = 20;

str = computer;
if (strncmp(str,'PCWIN',5))
    src = 'C:/Users/yzs123/Dropbox/Research';
else if (strncmp(str,'MACI',4))
        src = '/Users/Yuning/Dropbox/Research';
    end
end

COLS = 610;
ROWS = 394;
X0 = 254139.13; Y0=4505175.754;
obs_dates = [datenum(2009,5,3,9,0,0) datenum(2009,5,6,10,0,0) datenum(2009,5,10,10,0,0) datenum(2009,5,11,7,0,0) datenum(2009,5,13,9,0,0) datenum(2009,5,19,10,0,0) datenum(2009,5,21,9,0,0) datenum(2009,5,22,7,0,0)...
    datenum(2009,5,26,10,0,0) datenum(2009,5,28,9,0,0)...
    datenum(2009,6,2,9,0,0) datenum(2009,6,6,7,0,0) datenum(2009,6,11,8,0,0) datenum(2009,6,17,8,0,0) datenum(2009,6,17,10,0,0) datenum(2009,6,23,10,0,0) datenum(2009,6,24,8,0,0) datenum(2009,6,24,9,0,0)...
    datenum(2009,7,1,8,0,0) datenum(2009,7,2,9,0,0) datenum(2009,7,3,7,0,0) datenum(2009,7,8,10,0,0) datenum(2009,7,14,10,0,0) datenum(2009,7,15,8,0,0) datenum(2009,7,20,7,0,0) datenum(2009,7,30,10,0,0)...
    datenum(2009,8,5,8,0,0) datenum(2009,8,12,8,0,0) datenum(2009,8,12,9,0,0) datenum(2009,8,14,9,0,0) datenum(2009,8,23,9,0,0) datenum(2009,8,28,10,0,0) datenum(2009,8,30,9,0,0)...
    datenum(2009,9,4,9,0,0) datenum(2009,9,7,7,0,0) datenum(2009,9,7,8,0,0) datenum(2009,9,11,10,0,0) datenum(2009,9,14,7,0,0) datenum(2009,9,14,8,0,0) datenum(2009,9,21,7,0,0) datenum(2009,9,21,8,0,0) datenum(2009,9,26,10,0,0)];

depth = {'10cm','20cm','40cm','60cm','80cm','100cm'};

for month = 5:9;
    dates = obs_dates(obs_dates>=datenum(2009,month,1,0,0,0) & obs_dates<datenum(2009,month+1,1,0,0,0));
    temp1 = zeros(ROWS,COLS,1);
    temp2 = zeros(ROWS,COLS,length(dates));
    for j = 1:length(dates)
        for i = 1:1
            filename = sprintf('%s/Data/CZO/SM/%s/SM%s.asc',src,depth{i},datestr(dates(j),'mmddHH'));
            fid = fopen(filename,'r');
            file = textscan(fid,'%f','delimiter',' ','headerlines',6);
            temp1(:,:,i) = reshape(file{1,1},COLS,ROWS)';
            fclose(fid);
        end
        temp1(temp1 == -9999 | temp1>1) = NaN;
        temp2(:,:,j) = nanmean(temp1,3);
    end
    
    data = nanmean(temp2,3);
    
    filename =sprintf('2009-%2.2d-%s.dat',month,depth{i});
    save(filename,'data','-ASCII');
    
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
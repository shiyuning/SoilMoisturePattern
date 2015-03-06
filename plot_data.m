clear all;
%close all;
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

actual_boundary = load(sprintf('%s/Data/CZO/SSHO_boundary.dat',src));

depth = {'10cm','20cm','40cm','60cm','80cm','100cm'};

% obs_dates = [datenum(2009,5,3,9,0,0) datenum(2009,5,6,10,0,0) datenum(2009,5,10,10,0,0) datenum(2009,5,11,7,0,0) datenum(2009,5,13,9,0,0) datenum(2009,5,19,10,0,0) datenum(2009,5,21,9,0,0) datenum(2009,5,22,7,0,0)...
    %datenum(2009,5,26,10,0,0) datenum(2009,5,28,9,0,0)];

%for i = 1:1
    filename = sprintf('%s/Data/CZO/SM/10cm/SM060209.asc',src);
    fid = fopen(filename,'r');
    file = textscan(fid,'%f','delimiter',' ','headerlines',6);
    temp = reshape(file{1,1},COLS,ROWS)';
    fclose(fid);
%end
temp(temp == -9999 | temp>1) = NaN;

data = temp;

%data = load('2009-05.dat');

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
caxis([0.1 0.25]);
set(h,'edgecolor','none');
hold on;
plot(actual_boundary(:,1),actual_boundary(:,2),'k','LineWidth',3);

set(gca,'DataAspectRatio',[1 1 1]);
view(0, 90);
axis off;
colorbar;
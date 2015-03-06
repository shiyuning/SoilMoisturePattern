clear all; close all;clc;

str = computer;
if (strncmp(str,'PCWIN',5))
    src = 'C:/Users/yzs123/Box Sync/Research';
else if (strncmp(str,'MACI',4))
        src = '/Users/Yuning/Dropbox/Research';
    end
end

stdate=datenum(2009,5,1,1,0,0);
enddate=datenum(2009,12,1,0,0,0);
fsize = 32;
YES = 1;
NO = 0;

[rthsmtime, rthsm, rthsm_error] = read_rth_sm_func;

RTH3_x = [254356.974099 254366.173891 254375.216018];
RTH3_y = [4505358.63484 4505365.87801 4505357.35055];

COLS = 610;
ROWS = 394;
X0 = 254139.13; Y0=4505175.754;
obs_dates = [datenum(2009,5,3,9,0,0) datenum(2009,5,6,10,0,0) datenum(2009,5,10,10,0,0) datenum(2009,5,11,7,0,0) datenum(2009,5,13,9,0,0) datenum(2009,5,19,10,0,0) datenum(2009,5,21,9,0,0) datenum(2009,5,22,7,0,0)...
    datenum(2009,5,26,10,0,0) datenum(2009,5,28,9,0,0)...
    datenum(2009,6,2,9,0,0) datenum(2009,6,6,7,0,0) datenum(2009,6,11,8,0,0) datenum(2009,6,17,8,0,0) datenum(2009,6,17,10,0,0) datenum(2009,6,23,10,0,0) datenum(2009,6,24,8,0,0) datenum(2009,6,24,9,0,0)...
    datenum(2009,7,1,8,0,0) datenum(2009,7,2,9,0,0) datenum(2009,7,3,7,0,0) datenum(2009,7,8,10,0,0) datenum(2009,7,14,10,0,0) datenum(2009,7,15,8,0,0) datenum(2009,7,20,7,0,0) datenum(2009,7,30,10,0,0)...
    datenum(2009,8,5,8,0,0) datenum(2009,8,12,8,0,0) datenum(2009,8,12,9,0,0) datenum(2009,8,14,9,0,0) datenum(2009,8,23,9,0,0) datenum(2009,8,28,10,0,0) datenum(2009,8,30,9,0,0)...
    datenum(2009,9,4,9,0,0) datenum(2009,9,7,7,0,0) datenum(2009,9,7,8,0,0) datenum(2009,9,11,10,0,0) datenum(2009,9,14,7,0,0) datenum(2009,9,14,8,0,0) datenum(2009,9,21,7,0,0) datenum(2009,9,21,8,0,0) datenum(2009,9,26,10,0,0)];

depth = {'10cm','20cm','40cm','60cm'};

xlin=linspace(X0,X0+COLS-1,COLS);
ylin=linspace(Y0+ROWS-1,Y0,ROWS);
[Xgrid,Ygrid]=meshgrid(xlin,ylin);
xind = Xgrid(inpolygon(Xgrid,Ygrid,RTH3_x,RTH3_y));
yind = Ygrid(inpolygon(Xgrid,Ygrid,RTH3_x,RTH3_y));

actual_boundary = load(sprintf('%s/Data/CZO/SSHO_boundary.dat',src));
data = zeros(size(obs_dates));
for j = 1:length(obs_dates)
    disp(datestr(obs_dates(j)));
    temp1 = zeros(ROWS,COLS,4);
    for i = 1:4
        filename = sprintf('%s/Data/CZO/SM/%s/SM%s.asc',src,depth{i},datestr(obs_dates(j),'mmddHH'));
        fid = fopen(filename,'r');
        file = textscan(fid,'%f','delimiter',' ','headerlines',6);
        temp1(:,:,i) = reshape(file{1,1},COLS,ROWS)';
        fclose(fid);
    end
    
    temp = nanmean(temp1,3);
    
    data(j) = nanmean(temp(inpolygon(Xgrid,Ygrid,RTH3_x,RTH3_y)));

end

plot(rthsmtime, rthsm, obs_dates+4/24, data,'-o');
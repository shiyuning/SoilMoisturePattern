clear all; close all;clc;

str = computer;
if (strncmp(str,'PCWIN',5))
    src = 'C:/Users/yzs123/Box Sync/Research';
else if (strncmp(str,'MACI',4))
        src = '/Users/Yuning/Dropbox/Research';
    end
end

months = {'J','F','M','A','M','J','J','A','S','O','N','D'};

stdate=datenum(2009,5,1,0,0,0);
enddate=datenum(2009,11,1,0,0,0);
plotdays=[datenum(2009,1,1),datenum(2009,2,1),datenum(2009,3,1),datenum(2009,4,1),datenum(2009,5,1),datenum(2009,6,1),...
    datenum(2009,7,1),datenum(2009,8,1),datenum(2009,9,1),datenum(2009,10,1),datenum(2009,11,1),datenum(2009,12,1)];
fsize = 28;

ELE =31;

SSHO_area = 8.417e4;

[rthdischargetime, rthdischarge] = read_rth_discharge_func;
[rthtime, rthwd, rthwd_error] = read_rth_wtd_func;
rthwd(rthtime>=datenum(2009,7,14,16,0,0) & rthtime<=datenum(2009,10,16,12,0,0)) = rthwd(rthtime>=datenum(2009,7,14,16,0,0) & rthtime<=datenum(2009,10,16,12,0,0)) - 0.084;
[rthsmtime, rthsm, rthsm_error] = read_rth_sm_func;
RTHBRD = 2.135;

test_cases = {'shp','sha','shc','shd','shb'};
no_test_cases = 5;
for j = 1:no_test_cases
    projectName{1} = test_cases{j};
    [NumEle, NumNode, eleind, nodeind, x, y, zmin, zmax, tri] = read_mesh_func_old(projectName);
    [n, dsoil] = read_lsm_func_old(projectName);
    BRD = (zmax(tri(ELE,1))+zmax(tri(ELE,2))+zmax(tri(ELE,3))-zmin(tri(ELE,1))-zmin(tri(ELE,2))-zmin(tri(ELE,3)))/3;
    [dischargetime{j}, baseflow, discharge{j}] = read_outlet_func(projectName);
    [smtime{j}, SM{j}] = read_sm_ele_func(projectName, ELE, n);
    [gwtime{j}, HFLX, LFLX, GFLX, TS, et0, et1, et2, GW{j}, unsat, rech, surf, is] = read_ts_ele_func(ELE, projectName);
    gw{j}=BRD-GW{j};
end
%[preptime, prepstr] = read_prep_func(projectName);

Colors = {'k','b',[0 0.5 0],'r','c'};
scrsz = get(0,'ScreenSize');
figure('Position',[1 1 scrsz(4) scrsz(4)]);
subplot(3,1,1);
plot(rthdischargetime,rthdischarge,'o','Color',0.2*[1 1 1],'MarkerSize',6);
hold on;
for j = 1:no_test_cases
    plot(dischargetime{j},discharge{j},'Color',Colors{j},'LineWidth',2);
    obs = rthdischarge(rthdischargetime>=stdate & rthdischargetime<=enddate);
    sim = discharge{j}(dischargetime{j}>=stdate & dischargetime{j}<=enddate);
    NSE = 1-sum((obs - sim).^2)/(sum((obs-mean(obs)).^2))
end
lh = legend('RTHnet','Field Survey','SSURGO','2-m BRD','Uniform soil','NLCD','Location','NorthWest');
set(lh,'interpreter','latex','Location','NorthEast','FontSize',fsize-10);
set(gca,'Xlim',[stdate enddate],'XTick',plotdays,'XTickLabel','','Ylim',[0 2000],'FontSize',fsize-5);
plotTickLatex2D('ylabeldx',0,'xlabeldy',0.02);

% for i = 6:10
%     text(plotdays(i) , -100, months{i},'HorizontalAlignment','Center','FontSize',fsize-2,'interpreter','latex');
% end


ylabel(gca,'$Q$ (m$^3$ day$^{-1}$)','FontSize',fsize,'FontWeight','Bold','interpreter','latex');


subplot(3,1,2);
shadedplot(rthtime,(rthwd+rthwd_error)',(rthwd-rthwd_error)',0.7*[1 1 1]);
hold on;
plot(rthtime,rthwd,'o','Color',0.2*[1 1 1],'MarkerSize',6);
hold on;
for j = 1:no_test_cases
    plot(gwtime{j},gw{j},'Color',Colors{j},'LineWidth',2);
    obs = rthwd(rthtime>=stdate & rthtime<=enddate);
    sim = gw{j}(gwtime{j}>=stdate & gwtime{j}<=enddate);
    RHO = corr(obs,sim)
    RMSE = sqrt(sum((obs-sim).^2)/length(obs))
    
end
set(gca,'Xlim',[stdate enddate],'XTick',plotdays,'XTickLabel',[],'Ylim',[0 2],'FontSize',fsize-5);
plotTickLatex2D('ylabeldx',-0.04,'xlabeldy',0.02);
ylabel('WTD (m)','FontSize',fsize,'FontWeight','Bold','interpreter','latex');
%text(stdate+10,1.8,'(a)','FontSize',fsize,'interpreter','latex');

subplot(3,1,3);
shadedplot(rthtime,(rthsm+rthsm_error)',(rthsm-rthsm_error)',0.7*[1 1 1]);
hold on;
plot(rthsmtime,rthsm,'o','Color',0.2*[1 1 1],'MarkerSize',6);
hold on;
for j = 1:no_test_cases
    unsat = (SM{j}(:,1)*dsoil(1) + SM{j}(:,2)*dsoil(2) + SM{j}(:,3)*dsoil(3) + SM{j}(:,4)*(0.5-sum(dsoil(1:3))))/0.5;
    obs = rthsm(rthtime>=stdate & rthtime<=enddate);
    sim = unsat(smtime{j}>=stdate & smtime{j}<=enddate);
    SMRHO = corr(obs,sim)
    SMRMSE = sqrt(sum((obs-sim).^2)/length(obs))
    
    plot(smtime{j}, unsat,'Color',Colors{j},'LineWidth',2);
end
set(gca,'Xlim',[stdate enddate],'XTick',plotdays,'XTickLabel',' ','Ylim',[0.1 0.4],'FontSize',fsize-5,'Layer','top');
datetick('x','dd mmm','keepticks','keeplimits');
ylabel('SWC (m$^3$ m$^{-3}$)','FontSize',fsize,'FontWeight','Bold','interpreter','latex');
plotTickLatex2D('ylabeldx',-0.02,'xlabeldy',0.02);
%for i = 3:12
%    text(plotdays(i), 0.070, months{i},'HorizontalAlignment','Center','FontSize',fsize-5,'interpreter','latex');
%end

%text(stdate+10,0.45,'(b)','FontSize',fsize,'interpreter','latex');


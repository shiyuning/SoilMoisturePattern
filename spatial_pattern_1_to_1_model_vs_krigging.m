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
TDR = load(sprintf('%s/Data/CZO/TDR.dat',src));
projectName = {'shp'};

[NumEle, NumNode, eleind, nodeind, x, y, zmin, zmax, tri] = read_mesh_func_old(projectName);

[soil, geol, lc] = read_att_func(projectName);
soil_1 = find(soil ==1);
soil_2 = find(soil ==2);
soil_3 = find(soil == 3);
soil_4 = find(soil == 4);
soil_5 = find(soil == 5);
months = {'June','July','August','September'};
scrsz = get(0,'ScreenSize');
figure('Position',[1 1 scrsz(4) scrsz(4)]);
for ind = 1:4
    subplot(2,2,ind);
    data = load(sprintf('2009-%2.2d-agrg-grid.dat',ind+5));
    [n, dsoil] = read_lsm_func_old(projectName);
    [NumEle, NumNode, eleind, nodeind, x, y, zmin, zmax, tri] = read_mesh_func_old(projectName);
    filename = sprintf('%s/Flux-PIHM-2.0/output/%s.smsp2009%2.2d',src,projectName{1},ind+5);
    fmt = ['%d' repmat('%f', 1, n)];
    fid = fopen(filename);
    temp=textscan(fid,fmt,'delimiter',',');
    fclose(fid);
    SM = zeros(size(temp{1},1),n);
    [ele] = temp{1};
    for i = 1:n
        SM(:,i) = temp{i+1};
    end
    x_c = zeros(1,NumEle);
    y_c = zeros(1,NumEle);
    z_max = zeros(1,NumEle);
    SWC = zeros(1,NumEle);
    SWC_nointerp = zeros(1,NumEle);
    
    for i =1:NumEle
        SWC(i) = (sum(SM(i,1:5).*dsoil(1:5)))/sum(dsoil(1:5));
        if any(inpolygon(TDR(:,1), TDR(:,2),x(tri(i,:)),y(tri(i,:))))
            SWC_nointerp(i) = SWC(i);
        else
            SWC_nointerp(i) = NaN;
        end
    end
    %   [255/255 250/255 205/255],'EdgeColor','none');
    % [244/255 164/255 96/255],'EdgeColor','none');
    %[255/255 215/255 0/255],'EdgeColor','none');
    %[34/255 139/255 34/255],'EdgeColor','none');
    %'b'
    
    h(1) = plot(data(soil_1), SWC_nointerp(soil_1),'wo','MarkerSize',10,'MarkerFaceColor',[248/255 187/255 135/255]);
    hold on;
    h(2) = plot(data(soil_2), SWC_nointerp(soil_2), 'wo','MarkerSize',10,'MarkerFaceColor',[238/255 59/255 59/255]);
    h(3) = plot(data(soil_3), SWC_nointerp(soil_3), 'wo','MarkerSize',10,'MarkerFaceColor',[0/255 139/255 139/255]);
    h(4) = plot(data(soil_4), SWC_nointerp(soil_4), 'wo','MarkerSize',10,'MarkerFaceColor',[103/255 204/255 0/255]);
    h(5) = plot(data(soil_5), SWC_nointerp(soil_5), 'wo','MarkerSize',10,'MarkerFaceColor','b');
    line([0 1],[0 1],'LineStyle','--','Color','k');
    plot(data(31), SWC(31),'ws','MarkerSize',12,'MarkerFaceColor','b');
    
%     plot(data(soil_1), SWC_nointerp(soil_1),'k^', 'MarkerFaceColor',[248/255 187/255 135/255]);
%     plot(data(soil_2), SWC_nointerp(soil_2), 'k^','MarkerFaceColor',[238/255 59/255 59/255]);
%     plot(data(soil_3), SWC_nointerp(soil_3), 'k^','MarkerFaceColor',[0/255 139/255 139/255]);
%     plot(data(soil_4), SWC_nointerp(soil_4), 'k^','MarkerFaceColor',[103/255 204/255 0/255]);
%     plot(data(soil_5), SWC_nointerp(soil_5), 'k^','MarkerFaceColor','b');
    
    
    set(gca,'DataAspectRatio',[1 1 1],'xlim',[0.1 0.4],'Xtick',0.1:0.1:0.4,'ylim',[0.1 0.4],'Ytick',0.1:0.1:0.4,'FontSize',fsize);
    title(months{ind},'interpreter','latex');
    plotTickLatex2D('ylabeldx',0,'xlabeldy',0.02);
    %[ax3,h2]=suplabel('super Y label (right)','yy');
    %[ax4,h3]=suplabel('super Title'  ,'t');
    %set(h3,'FontSize',30)
    CORR = corr(data(~isnan(data))', SWC(~isnan(data))');
    BIAS = mean(SWC(~isnan(data)) - data(~isnan(data)));
    RMSE = sqrt(sum((SWC(~isnan(data))-data(~isnan(data))).^2)/length((~isnan(data))));
    
    sim = SWC_nointerp(~isnan(data) & ~isnan(SWC_nointerp));
    obs = data(~isnan(data) & ~isnan(SWC_nointerp));
    CORR_nointerp=corr(sim', obs');
    BIAS_nointerp= mean(sim-obs);
    RMSE_nointerp = sqrt(sum((sim-obs).^2)/length(sim));
%     text(0.12,0.48,sprintf('Bias = $%5.3f$($%5.3f$) m$^{3}$ m$^{-3}$', BIAS, BIAS_nointerp),'interpreter','latex','FontSize',fsize-4,'VerticalAlignment','Middle');
%     text(0.12,0.45,sprintf('$R$ = $%5.3f$($%5.3f$)', CORR, CORR_nointerp),'interpreter','latex','FontSize',fsize-4,'VerticalAlignment','Middle');
%     text(0.12,0.42,sprintf('RMSE = $%5.3f$($%5.3f$) m$^{3}$ m$^{-3}$', RMSE, RMSE_nointerp),'interpreter','latex','FontSize',fsize-4,'VerticalAlignment','Middle');
    text(0.12,0.38,sprintf('Bias = $%5.3f$ m$^{3}$ m$^{-3}$', BIAS_nointerp),'interpreter','latex','FontSize',fsize-4,'VerticalAlignment','Middle');
    text(0.12,0.36,sprintf('$R$ = $%5.3f$', CORR_nointerp),'interpreter','latex','FontSize',fsize-4,'VerticalAlignment','Middle');
    text(0.12,0.34,sprintf('RMSE = $%5.3f$ m$^{3}$ m$^{-3}$', RMSE_nointerp),'interpreter','latex','FontSize',fsize-4,'VerticalAlignment','Middle');
    if (ind == 4)
        lh = legend(h, 'Weikert','Berks','Rushtown','Blairton','Ernest');
        set(lh,'Location','SouthEast','FontSize',fsize-5,'Interpreter','latex');
    end
end

[ax1,h1]=suplabel('Observed SWC (m$^3$ m$^{-3}$)');
[ax2,h2]=suplabel('Simulated SWC (m$^3$ m$^{-3}$)','y');
set(h1,'FontSize',fsize+3,'interpreter','latex');
set(h2,'FontSize',fsize+3,'interpreter','latex');
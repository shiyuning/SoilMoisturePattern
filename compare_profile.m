clear all; close all;clc;

str = computer;
if (strncmp(str,'PCWIN',5))
    src = 'C:/Users/yzs123/Dropbox/Research';
else if (strncmp(str,'MACI',4))
        src = '/Users/Yuning/Dropbox/Research';
    end
end

projectName=textread(sprintf('%s/Flux-PIHM-1.15/input/projectName.txt',src),'%s');
projectName{1} = 'shp';
plot_month = 6:9;
months = {'June','July','August','September'};
Colors = {'b',[0 0.5 0],'r','m'};
fsize = 28;

[n, dsoil] = read_lsm_func(projectName);

z = zeros(1,10);
for i = 1:n
    if i==1
        z(i) = dsoil(i)/2;
    else
        z(i) = z(i-1) + 0.5*(dsoil(i-1)+dsoil(i));
    end
end
z_obs = [0.1 0.2 0.4 0.6 0.8 1];

obs_dates = [datenum(2009,5,3,13,0,0) datenum(2009,5,6,14,0,0) datenum(2009,5,10,14,0,0) datenum(2009,5,11,11,0,0) datenum(2009,5,13,13,0,0) datenum(2009,5,19,14,0,0) datenum(2009,5,21,13,0,0) datenum(2009,5,22,11,0,0)...
    datenum(2009,5,26,14,0,0) datenum(2009,5,28,13,0,0)...
    datenum(2009,6,2,13,0,0) datenum(2009,6,6,11,0,0) datenum(2009,6,11,12,0,0) datenum(2009,6,17,12,0,0) datenum(2009,6,17,14,0,0) datenum(2009,6,23,14,0,0) datenum(2009,6,24,12,0,0) datenum(2009,6,24,13,0,0)...
    datenum(2009,7,1,12,0,0) datenum(2009,7,2,13,0,0) datenum(2009,7,3,11,0,0) datenum(2009,7,8,14,0,0) datenum(2009,7,14,14,0,0) datenum(2009,7,15,12,0,0) datenum(2009,7,20,11,0,0) datenum(2009,7,30,14,0,0)...
    datenum(2009,8,5,12,0,0) datenum(2009,8,12,12,0,0) datenum(2009,8,12,13,0,0) datenum(2009,8,14,13,0,0) datenum(2009,8,23,13,0,0) datenum(2009,8,28,14,0,0) datenum(2009,8,30,13,0,0)...
    datenum(2009,9,4,13,0,0) datenum(2009,9,7,11,0,0) datenum(2009,9,7,12,0,0) datenum(2009,9,11,14,0,0) datenum(2009,9,14,11,0,0) datenum(2009,9,14,12,0,0) datenum(2009,9,21,11,0,0) datenum(2009,9,21,12,0,0) datenum(2009,9,26,14,0,0)];

%obs_dates = obs_dates - 4/24;
[smtime, SM] = read_sm_mean_func(projectName, n);
[smtime1, SM1] = read_sm_mean_func({'shps'}, n);
SM = SM(ismember(smtime, obs_dates),:);
smtime = smtime(ismember(smtime, obs_dates));
SM1 = SM1(ismember(smtime1, obs_dates),:);
smtime1 = smtime1(ismember(smtime1, obs_dates));

figure('Position',[50 50 1000 800]);

lmargin = 0.1;
topmargin = -0.03;
width = 0.28;
height = 0.38;
xdist = 0.34;
ydist = 0.47;
%figure('Position',[50 50 1800 900]);

Position = {[lmargin 1 - topmargin-ydist width height],[lmargin + xdist 1 - topmargin-ydist width height],[lmargin 1 - topmargin-2*ydist width height],[lmargin+xdist 1 - topmargin-2*ydist width height]};

for i = 1:4
    profile_obs = load(sprintf('2009-%2.2d-profile.dat',plot_month(i)));
    stdate=datenum(2009,plot_month(i),1,1,0,0);
    enddate=datenum(2009,plot_month(i)+1,1,0,0,0);
    
    profile = mean(SM(smtime>=stdate & smtime<=enddate,:),1);
    profile1 = mean(SM1(smtime1>=stdate & smtime1<=enddate,:),1);
    %SM(ismember(smtime, obs_dates),:)
    %rrayfun(@(x) find(smtime == x,1,'first'), obs_dates )
    %profile = SM(find(smtime = obs_dates),:)
    %subplot(2,2,i);
    axes('Position',Position{i});
    h(1) = plot(profile(1:6),z(1:6),'bs-','LineWidth',2);
    hold on;
    h(2) = plot(profile1(1:6),z(1:6),'rs-','LineWidth',2);
    h(3) = plot(profile_obs,z_obs,'ko-','LineWidth',2);
    set(gca,'Ydir','reverse','xlim',[00 0.3],'ylim',[0 0.6],'XTick',0:0.1:0.3,'FontSize',fsize-8);
	if (i>2)
        xlabel('SWC (m$^3$ m$^{-3})$','Interpreter','latex');
    else
        set(gca,'XTickLabel','');        
    end
    if (mod(i,2)~=0)
        ylabel('Depth (m)','Interpreter','latex');
    else
        set(gca,'YTickLabel','');
    end
    title(months{i},'interpreter','latex','FontSize',fsize-5);
	plotTickLatex2D('ylabeldx',0,'xlabeldy',-0.02);
end

sh = axes('Position',[0.81 0.75 0.1 0.1]);
p=get(gca,'position'); lh=legend(sh,h,'Old formulation','New formulation','Observation');
set(lh,'position',p,'FontSize',fsize-8,'interpreter','latex');
axis(sh,'off');

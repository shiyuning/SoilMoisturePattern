function plot_fs_soil_map

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

end


arrow_length = 25;
arrow_width = 10;
arrow_tail = 14;
ruler_arrow_dist = 65;

%northarrow1_x(1)=254645;
%northarrow1_y(1)=4505350;

northarrow1_x(1)=254245;
northarrow1_y(1)=4505250;
northarrow1_x(2)=northarrow1_x(1);
northarrow1_y(2)=northarrow1_y(1)-arrow_length;
northarrow1_x(3)=northarrow1_x(2)-arrow_width;
northarrow1_y(3)=northarrow1_y(2)-20;
northarrow1_x(4)=northarrow1_x(1);
northarrow1_y(4)=northarrow1_y(1);
northarrow2_x(1)=northarrow1_x(1);
northarrow2_y(1)=northarrow1_y(1);
northarrow2_x(2)=northarrow1_x(1);
northarrow2_y(2)=northarrow1_y(1)-arrow_length;
northarrow2_y(3)=northarrow1_y(3);
northarrow2_x(3)=northarrow1_x(2)+arrow_width;

%figure;
%northarrowtri=[1 2 3;1 2 4];
%triplot(northarrowtri,northarrowx,northarrowy,'k-','LineWidth',2);
line(northarrow1_x,northarrow1_y,'Color','k','LineWidth',2);
hold on;
fill(northarrow2_x,northarrow2_y,'k');
hold on;

text(northarrow1_x(1),northarrow1_y(1)+12,'N','HorizontalAlign','center','FontSize',fsize-5,'interpreter','latex');

x0 = northarrow1_x(1);
y0 = northarrow1_y(1)-ruler_arrow_dist;

ruler1_x = [x0-50 x0 x0 x0-50];
ruler1_y = [y0 y0 y0+6 y0+6];
ruler2_x = [x0 x0+50 x0+50 x0];
ruler2_y = [y0 y0 y0+6 y0+6];


line(ruler1_x,ruler1_y,'LineWidth',2,'Color','k');
hold on;
fill(ruler1_x,ruler1_y,'k');
line([x0+50,x0+50],[y0,y0+6],'LineWidth',2,'Color','k');
line(ruler2_x,ruler2_y,'LineWidth',2,'Color','k');
%fill(ruler2_x,ruler2_y,'w');
hold on;
line([x0+50,x0+50],[y0+6,y0],'LineWidth',2,'Color','k');
%hold on;


text(x0-50,y0+15,'0','HorizontalAlignment','Center','FontSize',fsize-8,'interpreter','latex');
text(x0,y0+15,'50','HorizontalAlignment','Center','FontSize',fsize-8,'interpreter','latex');
text(x0-50+100,y0+15,'100 m','HorizontalAlignment','Center','FontSize',fsize-8,'interpreter','latex');
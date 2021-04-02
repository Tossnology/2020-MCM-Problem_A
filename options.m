year_time = 365*24;%total hours of a year
vessel_speed = 18.1;%vessel speed (km/h)
mackerel_price = 883.75;%price of mackerel (Pound) 
max_weight = 30;%max weight for a vessel to load

distances_1 = unifrnd(0,108.6,10,50);%random distances from new port positions to fish group for option1

for i = 1:10
    for j = 1:50
        distances_2(i,j) = distance(P(i,:),[Lat_m(2020+j),Lon_m(2020+j)],6371);%Calculate distances base on predicted moving tracks for option2
    end
end

for i = 1:10
    for j = 1:50
        incomes_2(i,j) = 0.5 * year_time * vessel_speed * max_weight * mackerel_price / distances_2(i,j);%get the income of every year of option2
    end
end

for i = 1:10
    for j = 1:50
        incomes_1(i,j) = 0.5 * year_time * vessel_speed * max_weight * mackerel_price / distances_1(i,j);%get the income of every year of option1
    end
end

plot(2021:2040,incomes_2(10,1:20),'LineWidth',2,'Color',[0.93 0.57 0.13]);
title('option1 vs option2 - Eyemouth - income change','Fontname', 'Times New Roman','FontSize',12);
xlabel('time','Fontname', 'Times New Roman','FontSize',12);
 ylabel('income','Fontname', 'Times New Roman','FontSize',12);
 hold on;
plot(2021:2040,incomes_1(10,1:20),'LineWidth',2,'Color',[0.2 0.63 0.79]);
xlabel('time','Fontname', 'Times New Roman','FontSize',12);
 ylabel('income','Fontname', 'Times New Roman','FontSize',12);
 legend('option2','option1')

function result = Lat_m(i) %relationship between mackerel's latitude and time
    p1 = -1.02564110268265e-05;
    p2 =    0.0838756861891964;
    p3 =       -257.214494926180;
    p4 =      350557.892310225;
    p5 =       -179160687.207539;
    
    result = p1*i.^4 + p2*i.^3 + p3*i.^2 + p4*i + p5;
end

function result = Lon_m(i) %relationship between mackerel's lontitude and time
    p1 = 3.31002303239508e-06;
    p2 =    -0.0271224530551578;
    p3 =       83.3267494669017;
    p4 =      -113758.376474619;
    p5 =       58228997.7952488;
    
    result = p1*i.^4 + p2*i.^3 + p3*i.^2 + p4*i + p5;
end


function result = Lat_h(i) %relationship between herring's latitude and time
    p1 = -6.99300851104721e-07;
    p2 =    0.00585781010041642;
    p3 =       -18.3904758421972;
    p4 =      25646.9972197086;
    p5 =       -13405718.3436972;
    
    result = p1*i.^4 + p2*i.^3 + p3*i.^2 + p4*i + p5;
end

function result = Lon_h(i) %relationship between herring's lontitude and time
    p1 = 5.82750624265166e-06;
    p2 =    -0.0474655822679289;
    p3 =       144.974974325811;
    p4 =      -196793.870276591;
    p5 =       100172408.915139;
    
    result = p1*i.^4 + p2*i.^3 + p3*i.^2 + p4*i + p5;
end
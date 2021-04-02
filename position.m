fname_in     = 'C:\Users\46227\Desktop\netcdf\sst.wkmean.1990-present.nc';
% time         = ncread(fname_in,'time');
latitude          = ncread(fname_in,'lat');  % 纬度
longitude          = ncread(fname_in,'lon');  % 经度
r          = ncread(fname_in,'sst');
% 

p = zeros(49,2);
a = 1;
for i = 1:7
    for j = 1:7
        p(a,1) = 163.5 + i*4;
        p(a,2) = 42.5 + j*3;
        a = a+1;
    end
end

sst = zeros(49,length(time));

for i = 1:49
    
longitude_index     = find(longitude ==p(i,1)); % 选出经度在该区域的数据
latitude_index     = find(latitude == p(i,2)); % 选出纬度在该区域的数据
is_r_nan  = isnan(r);       % 返回与r一样大小的向量，判断r的值是否为NaN，是则为1，不是则为0



for j =1 : length(time)
    if(is_r_nan(longitude_index ,latitude_index,j) == 0)        % 不为缺省值才做计算
%         fprintf(out_file_id, '%.3f\t', time(i));
        sst(i,j) = r(longitude_index,latitude_index,j);
    end
end

end
plot(time,sst(2,:));

p167_45 = sst(1,:);
p167_48 = sst(2,:);
p167_51 = sst(3,:);
p167_54 = sst(4,:);
p167_57 = sst(5,:);
p167_60 = sst(6,:);
p167_63 = sst(7,:);

p171_45 = sst(8,:);
p171_48 = sst(9,:);
p171_51 = sst(10,:);
p171_54 = sst(11,:);
p171_57 = sst(12,:);
p171_60 = sst(13,:);
p171_63 = sst(14,:);

p175_45 = sst(15,:);
p175_48 = sst(16,:);
p175_51 = sst(17,:);
p175_54 = sst(18,:);
p175_57 = sst(19,:);
p175_60 = sst(20,:);
p175_63 = sst(21,:);

p179_45 = sst(22,:);
p179_48 = sst(23,:);
p179_51 = sst(24,:);
p179_54 = sst(25,:);
p179_57 = sst(26,:);
p179_60 = sst(27,:);
p179_63 = sst(28,:);

p183_45 = sst(29,:);
p183_48 = sst(30,:);
p183_51 = sst(31,:);
p183_54 = sst(32,:);
p183_57 = sst(33,:);
p183_60 = sst(34,:);
p183_63 = sst(35,:);

p187_45 = sst(36,:);
p187_48 = sst(37,:);
p187_51 = sst(38,:);
p187_54 = sst(39,:);
p187_57 = sst(40,:);
p187_60 = sst(41,:);
p187_63 = sst(42,:);

p191_45 = sst(43,:);
p191_48 = sst(44,:);
p191_51 = sst(45,:);
p191_54 = sst(46,:);
p191_57 = sst(47,:);
p191_60 = sst(48,:);
p191_63 = sst(49,:);
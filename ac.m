
clear;close all
I=imread('scot300.png');
level=graythresh(I);   % ͼ��Ҷȴ���
bw=im2bw(I,level);  % ͼ���ֵ������
I=bw;
%I = imcomplement(I);
global cells;
cells=double(I);
%���� button
plotbutton=uicontrol('style','pushbutton',...
    'string','Run',...
    'fontsize',12,...
    'position',[100,400,50,20],...
    'callback','run=1;');
erasebutton=uicontrol('style','pushbutton',...
    'string','Stop',...
    'fontsize',12,...
    'position',[300,400,50,20],...
    'callback','freeze=1;');
number=uicontrol('style','text',...
    'string','1',...
    'fontsize',12,...
    'position',[20,400,50,20]);
%��ʼ����1��½�أ�0�Ǻ���2����Ⱥ
for i=135:2:165
    for j=105:2:120
        if cells(i,j)==1
            continue
        end
        cells(i,j)=2;
    end
end
%��������
escape = 0.8; %�����ڲ����¶�����ʱ��������ƶ��ĸ���
idle = 0.1; %�����ڶ��¶�����ʱ�ҹ�ĸ���
optimalDegree = 6.6; %����¶�
degreeCubic = ones(7,7) * 6.6; %�¶Ⱦ���
sensitive = 0.1; %������¶ȵ����ж���ֵ
sch=[];
skz=[];
t=1;
[x,y]=size(cells);
run=0;
freeze=0;
stop=0;
times=77522;
while (stop==0)
    if(run==1)
        times
        degreeCubic = updateDegree(times)
        for i=2:x-1
            for j=2:y-1
                if(cells(i,j)~=1 && cells(i,j)~=0)
                    %�����ˮ�¶�û�г�����ֵ������ѡ������ƶ�������ѡ�����¶����˷����ƶ�
                    eindex = abs(degreeCubic(idivide(int32(i),50,'floor') + 2, idivide(int32(j),50,'floor') + 2) - optimalDegree) - 5;  %������ֵת��Ϊ[-5�����
                    sigmoid = 1/(1+exp(-eindex));  %sigmoid������������¶ȵ�ƫ���¶�ֵת��Ϊ0-1�ķ�Χ
                    if (sigmoid < sensitive)
                        if(rand<escape)  %СȺ���ƶ�
                            count = countNeibor(i,j,cells);
                            %�ھ�Խ���ƶ�����Խ��ԽС�ƶ�����ԽС
                            movchance = count / 8 + 0.2;
                            if rand < movchance
                                dx = rand; dy = rand;
                                if(dx<0.3) dx=-1;
                                elseif(dx <0.6) dx = 0;
                                else dx = 1;
                                end
                                if(dy<0.3) dy=-1;
                                elseif(dy <0.6) dy = 0;
                                else dy = 1;
                                end
                                cells(i,j)=0;
                                if cells(i+dx,j+dy) ~= 1 && cells(i+dx,j+dy) ~= 2
                                    cells(i+dx,j+dy)=2;
                                else
                                    cells(i,j)=2;
                                end
                            end
                        end
                    else
                        if(rand<escape)
                        %�����¶��ƶ�,���Ǵ�ʱ����һ����������ƶ�
                        if(rand < idle)
                            dx = rand; dy = rand;
                                if(dx<0.3) dx=-1;
                                elseif(dx <0.6) dx = 0;
                                else dx = 1;
                                end
                                if(dy<0.3) dy=-1;
                                elseif(dy <0.6) dy = 0;
                                else dy = 1;
                                end
                                cells(i,j)=0;
                                if cells(i+dx,j+dy) ~= 1 && cells(i+dx,j+dy) ~= 2
                                    cells(i+dx,j+dy)=2;
                                else
                                    cells(i,j)=2;
                                end
                                continue;
                        end
                        %�������¶������е�����
                        cx = idivide(int32(i),50,'floor') + 2;
                        cy = idivide(int32(j),50,'floor') + 2;
                        [dx,dy] = choseOptimalDegree(cx,cy, optimalDegree, degreeCubic);
                        cells(i,j)=0;
                        if (cells(i+dx,j+dy) ~= 1 && cells(i+dx,j+dy) ~= 2)
                            cells(i+dx,j+dy)=2;
                        else
                            cells(i,j)=2;
                        end
                        end
                    end
                end
            end
        end
        
        ch=0;kzch=0;
        for i=1:x
            for j=1:y
                if(cells(i,j)==2) ch=ch+1;end
                if(cells(i,j)==3) kzch=kzch+1;end
            end
        end
        sch(t)=ch;skz(t)=kzch;
        t=t+1;
        [A,B]=size(cells);
        Area(1:A,1:B,1)=zeros(A,B);
        Area(1:A,1:B,2)=zeros(A,B);
        Area(1:A,1:B,3)=zeros(A,B);
        
        %��ͼ
        for i=1:A
            for j=1:B
                if cells(i,j)==1
                    Area(i,j,:)=[1,1,1];
                elseif cells(i,j)==0
                    Area(i,j,:)= [255, 255, 255];
                elseif cells(i,j)==3
                    Area(i,j,:)= [255,0,0];
                elseif cells(i,j)==2
                    Area(i,j,:)= [255,0,0];
                end
            end
        end
        pause(0.00000000000001);
        Area=uint8(Area);
        imagesc(Area);
        axis equal;
        axis tight;
        %�Ʋ�
        stepnumber=1+str2num(get(number,'string'));
        set(number,'string',num2str(stepnumber));
        times = times+30;
    end
    if freeze==1
        run=0;
        freeze=0;
    end
    drawnow
end

%ѡȡ�������¶ȷ��򣬷���deltaλ��+1-1֮���
function [dx,dy] = choseOptimalDegree(ci,cj,optimaldegree, degreecells)
[sx,sy] = size(degreecells);
minGap = 30;
minx = ci;
miny = cj;
for i=-1:1
    for j=-1:1
        if ((ci+i <1 | ci+i >sx) | (cj+j <1 | cj+j > sy))
            continue
        end
        temp = abs(degreecells(ci+i,cj+j) - optimaldegree);
        if temp < minGap
            minGap = temp;
            minx = i;
            miny = j;
        end
    end
end

dx = minx;
dy = miny;
end

function a=aroundcenter(i,j,cells)
global cells
a=0;
if(cells(i-1,j)==3)  a=1;end
if(cells(i,j-1)==3)  a=1;end
if(cells(i,j+1)==3)  a=1;end
if(cells(i+1,j)==3)  a=1;end
end

%�����Ƿ�����Ⱥ
function result = containNeibor(i,j,cells)
a=0;
if(cells(i-1,j)==2)  a=a+1; end
if(cells(i,j-1)==2)  a=a+1;end
if(cells(i,j+1)==2)  a=a+1;end
if(cells(i+1,j)==2)  a=a+1;end
if(cells(i+1,j+1)==2)  a=a+1;end
if(cells(i+1,j-1)==2)  a=a+1;end
if(cells(i-1,j+1)==2)  a=a+1;end
if(cells(i-1,j-1)==2)  a=a+1;end
if a > 0
    result =1
elseif a ==0
    result = 0
end
end

%������Ⱥ����
function a = countNeibor(i,j,cells)
a=0;
if(cells(i-1,j)==2)  a=a+1; end
if(cells(i,j-1)==2)  a=a+1;end
if(cells(i,j+1)==2)  a=a+1;end
if(cells(i+1,j)==2)  a=a+1;end
if(cells(i+1,j+1)==2)  a=a+1;end
if(cells(i+1,j-1)==2)  a=a+1;end
if(cells(i-1,j+1)==2)  a=a+1;end
if(cells(i-1,j-1)==2)  a=a+1;end
end

%������Ⱥ����
function list = getNeibor(i,j,cells)
l = [];
if(cells(i-1,j)==2)  l = [l [i-1,j]]; end
if(cells(i,j-1)==2)  l = [l [i,j-1]]; end
if(cells(i,j+1)==2)  l = [l [i,j+1]]; end
if(cells(i+1,j)==2)  l = [l [i+1,j]]; end
if(cells(i+1,j+1)==2)  l = [l [i+1,j+1]]; end
if(cells(i+1,j-1)==2)  l = [l [i+1,j-1]]; end
if(cells(i-1,j+1)==2)  l = [l [i-1,j+1]]; end
if(cells(i-1,j-1)==2)  l = [l [i-1,j-1]]; end
list = l;
end

%�����¶Ⱦ���
function cube = updateDegree(times)
    
    cube = ones(7,7) * 40; %�¶Ⱦ���
    
    cube(6,2) = prep171_48(times);
    cube(5,2) = prep171_51(times);
    cube(4,2) = prep171_54(times);
    cube(3,2) = prep171_57(times);
    cube(2,2) = prep171_60(times);
    
    cube(6,3) = prep175_48(times);
    cube(5,3) = prep175_51(times);
    cube(4,3) = prep175_54(times);
    cube(3,3) = prep175_57(times);
    cube(2,3) = prep175_60(times);
    
    cube(4,4) = prep179_54(times);
    cube(3,4) = prep179_57(times);
    cube(2,4) = prep179_60(times);
    
    cube(6,5) = prep183_48(times);
    cube(5,5) = prep183_51(times);
    cube(4,5) = prep183_54(times);
    cube(3,5) = prep183_57(times);
    cube(2,5) = prep183_60(times);
    cube(1,5) = prep183_63(times);
    
    cube(6,6) = prep187_48(times);
    cube(5,6) = prep187_51(times);
    cube(4,6) = prep187_54(times);
    cube(3,6) = prep187_57(times);
    cube(2,6) = prep187_60(times);
    cube(1,6) = prep187_63(times);
end

function Pre = prep171_48(x)
a =      0.8639  ;
       b =      0.2552  ;
       c =       -7.78  ;
       
       a1 =       4.394  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
function Pre = prep171_51(x)
a =   8.474e-12  ;
       b =       2.333  ;
       c =        5.06  ;
       
       a1 =       3.894  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
function Pre = prep171_54(x)
a =   8.748e-12  ;
       b =        2.34  ;
       c =       4.377  ;
       
       a1 =       3.894  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
function Pre = prep171_57(x)
a =   1.513e-11  ;
       b =       2.329  ;
       c =       2.327  ;
       
       a1 =       4.394  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
function Pre = prep171_60(x)
a =   1.287e-11  ;
       b =       2.322  ;
       c =       3.271  ;
       
       a1 =       5.394  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
% 
% 
function Pre = prep175_48(x)
a =   1.007e-11  ;
       b =       2.307  ;
       c =       5.161  ;
       
       a1 =       4.394  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
function Pre = prep175_51(x)
a =   7.181e-12  ;
       b =       2.346  ;
       c =       4.348  ;
       
       a1 =       3.394  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
function Pre = prep175_54(x)
a =   9.176e-12  ;
       b =       2.348  ;
       c =       3.365  ;
       
       a1 =       3.894  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
function Pre = prep175_57(x)
a =   1.289e-11  ;
       b =       2.348  ;
       c =       1.399  ;
       
       a1 =       4.194  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
function Pre = prep175_60(x)
a =   1.219e-11  ;
       b =       2.346  ;
       c =      1.5675  ;
       
       a1 =       4.694  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
% 
% 
function Pre = prep179_54(x)
       a =   1.073e-11  ;
       b =       2.339  ;
       c =       3.136  ;
       
       a1 =       3.694  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
function Pre = prep179_57(x)
       a =   1.305e-11  ;
       b =       2.342  ;
       c =       1.559  ;
       
       a1 =       3.994  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
function Pre = prep179_60(x)
       a =   8.019e-12  ;
       b =       2.507  ;
       c =           -10  ;
       
       a1 =       3.994  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
% 
% 
function Pre = prep183_48(x)
       a =   2.427e-09  ;
       b =       1.801  ;
       c =       6.392  ;
       
       a1 =       3.994  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
function Pre = prep183_51(x)
       a =   7.085e-12  ;
       b =       2.347  ;
       c =       4.667  ;
       
       a1 =       3.594  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
function Pre = prep183_54(x)
       a =   9.229e-12  ;
       b =       2.344  ;
       c =       3.508  ;
       
       a1 =       3.994  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
function Pre = prep183_57(x)
       a =   1.228e-11  ;
       b =       2.342  ;
       c =       2.132  ;
       
       a1 =       3.994  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
function Pre = prep183_60(x)
       a =     2.1e-14  ;
       b =       2.923  ;
       c =           0  ;
       
       a1 =       4.994  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
function Pre = prep183_63(x)
       a =   1.612e-17  ;
       b =       3.534  ;
       c =           0  ;
       
       a1 =       4.994  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
% 
function Pre = prep187_48(x)
       a =   3.737e-12  ;
       b =       2.337  ;
       c =       6.863  ;
       
       a1 =       3.994  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
function Pre = prep187_51(x)
       a =   6.629e-12  ;
       b =       2.345  ;
       c =        5.07  ;
       
       a1 =       2.994  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
function Pre = prep187_54(x)
       a =   7.711e-12  ;
       b =       2.349  ;
       c =       3.587  ;
       
       a1 =       3.594  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
function Pre = prep187_57(x)
       a =   1.072e-11  ;
       b =       2.347  ;
       c =       0.151  ;
       
       a1 =       3.994  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
function Pre = prep187_60(x)
       a =   2.606e-15  ;
       b =       3.094  ;
       c =           -2  ;
       
       a1 =       4.994  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
function Pre = prep187_63(x)
       a =   1.242e-15  ;
       b =       3.138  ;
       c =           -2  ;
       
       a1 =       3.994  ;
       b1 =   0.0172 ;
       c1 =        2.35425 ;
       
       Pre = a1*sin(b1*x+c1) + a*x^b+c;
end
% 
% 
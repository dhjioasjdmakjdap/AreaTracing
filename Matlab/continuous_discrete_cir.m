function [x,y]=continuous_discrete_cir(rx_delay,rx_cir)
% make the discrete cir continuous and then synchronize it in time

L=length(rx_delay);
t_start=0;
t_end=1500/(physconst("lightspeed"));
m=4e7;

d=400;
t_d=(t_end-t_start)/d;
x=t_start:t_d:t_end;
len=length(x);
y=zeros(1,len);


for i=1:L
    index=find((x>=(rx_delay(i)-pi/m))&(x<=(rx_delay(i)+pi/m)));
    sinx_x=sin(m*(x(index)-rx_delay(i)))./(m*(x(index)-rx_delay(i)));
    sinx_x(isnan(sinx_x))=1;
    y(index)=y(index)+rx_cir(i)*sinx_x;

end


end
clc;
clear all;
close all;

L = 4;
dV = 4.5;
aG = 4;
nC= 0.4;
bitLength = 8;

%Pulse train
function [a,b] = pT(Freq,x,r)
div = floor(Freq/x);
b = zeros(1,r);
a = 0;
TP = zeros(1,r);
for i = 1: r
  if(rem(i,div)==0)
  b(1,i)=1;
  a = a+1;
end
end
endfunction

%Bit Matrix
function Bit = bMat(r,b,Th,Data,Cnt)
  cT = 0;
  Bit = zeros(1,Cnt);
  i = 1;
  while(i<=r)
  if(b(1,i)==1)
  cT = cT+1;
  if(Data(i,1)>Th)
  Bit(1,cT)=1;
else Bit(1,cT)=0;
end
end
i = i+1;
end
endfunction

%Distorted input signal with noise
ipSig = L*pi*linspace(0,1,1024)';
[rx cx] = size(ipSig);

dipSig = sin(pi*ipSig)+cos(3*pi*ipSig)+sin(4*pi*ipSig)+cos(pi*ipSig)+sin(5*pi*ipSig);
y = abs(dipSig);
for i = 1:rx
  if(y(i,1)<1)
  y(i,1)=0;
end
end

mySig = y+nC*randn(length(dipSig),1);

subplot(5,1,1);plot(ipSig,mySig);
title("Distorted Signal");
ylabel('Amplitude');xlabel('Time');
line([0 L*pi],[0 0],"linestyle",":","color","r");
axis([0,L*pi,-1,4]);

%Equalizer
eS = zeros(rx,1);
for i = 1:rx
  if(mySig(i,1)<0)
  eS(i,1)=mySig(i,1)*-1;
  mySig(i,1)=mySig(i,1)+eS(i,1);
end
end

subplot(5,1,2); plot(ipSig,eS);
title("Equalising Signal");
ylabel('Amplitude');xlabel('Time');axis([0,L*pi, -1,4]);

%Amplifier
mySig = aG*mySig;
subplot(5,1,3);plot(ipSig,mySig);
strplot=sprintf("Amplified signal with Decison level %d",dV);
title(strplot);
ylabel('Amplitude');xlabel('Time');
line([0 L*pi],[dV,dV],"linestyle",":","color","g");
axis([0, L*pi,-1, 4*aG]);

%Actual bit values
[sig_bitCt,sig_tp]=pT(64,L,rx);
sigBit = bMat(rx,sig_tp,0,y,sig_bitCt)

%Timing Circuit
[d_bitCt,d_tp]=pT(64,L,rx);
subplot(5,1,4);stem(ipSig,d_tp);
title("Timing Signal");
ylabel('Amplitude');xlabel('Time');
axis([0,L*pi,0,1]);

%Decision making
printf("Decision level: %d\n",dV);
outD = bMat(rx,d_tp,dV,mySig,d_bitCt)
subplot(5,1,5);stairs(outD);
title("Regenerated signal");
ylabel('Amplitude');xlabel('Time');
axis([0,d_bitCt,0,1.5]);

%Bit Error rate(BER)
E = 0;
n = d_bitCt;
while(d_bitCt>0)
if(outD(1,d_bitCt)!=sigBit(1,d_bitCt));
E = E+1;
end
d_bitCt = d_bitCt -1;
endwhile

printf("Number of transmitted bit: %d\n",n);
printf("Number of Error Bits: %d\n",E);
printf("Bit Error Rate(BER): %d\n",E/n);

clc;
clear all;
close all;

bn = input("Enter the bit number= ");
sp = input("Enter the sampling period= ");
L  = 2^bn;

%Sampling Process
xn = 0:4*(pi/sp):8*pi;
[rX,cX] = size(xn(:,:));
swave = 10*cos(xn); %sampled signal
subplot(4,1,1); plot(swave); title("Analog Signal-Cosine Wave");
ylabel('Amplitude'); xlabel('Time');

subplot(4,1,2); stem(swave); grid on;
title('Sampled Cosine Wave');
ylabel('Amplitude'); xlabel('Time');

%Quantization Process
aMax = 15; 
aMin = -aMax; 
div = 2*aMax/(2^3-1);
u = aMax+ div;
pdiv = aMin:div:aMax;
qVal = [aMin:div:u];
[iVal,fVal] = quantiz(swave,pdiv,qVal); %Quantized signal

subplot(4,1,3); plot(iVal,"o"); grid on;
title("Quantized Cosine Wave");
ylabel('Amplitude'); xlabel('Time');

iL = length(iVal);
fL = length(fVal);


for i = 1:iL
  if (iVal(i)~=0)
    iVal(i)=iVal(i)-1;
  end
  i=i+1;
end

for i = 1:fL
  if(fVal(i)==aMin-(div/2))
  fVal(i)=aMin+(div/2);
end
end

%Encoding Process
binVal = zeros(iL,bn);

for i = 1:iL
  tVal = iVal(1,i);
  ct = bn;
  while 1<tVal
    tVal = floor(tVal/2);
    binVal(i,ct) = rem(tVal,2);
    ct = ct-1;
  end
  binVal(i,1) = tVal;
end

%Creating Pulse Train
pL = iL * bn;
pT = zeros(1,pL);

t=1;
for i = 1:iL
  ct = 1;
  while ct<=bn
    pT(1,t) =binVal(i,ct);
    t++;
    ct++;
  end
  i++;
endfor

subplot(4,1,4); grid on; stairs(pT);
axis([0 (floor(pL+(pL*0.05))) -0.5 1.5]);
title("PCM Signal");
ylabel('Amplitude'); xlabel('Time');

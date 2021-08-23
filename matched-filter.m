% create random binary source
sizeR = [1 10000];
num1 = 5000;
R = zeros(sizeR);
ix = randperm(numel(R));
ix = ix(1:num1);
R(ix) = 1;
BER1 = zeros(31, 1);
BER2 = zeros(31, 1);
BER3 = zeros(31, 1);
d1 = zeros(length(R)*10,1)
% generate output of pulse shape g(t)
for i=0: length(R) - 1
  if R(i + 1) == 1
      d1(i * 10 + 1: 10 * (i + 1))=1;
  else
      d1(i * 10 + 1: 10 * (i + 1))=-1;
  end
end
for SNR = -10:20
% add random noise to binary source
d = awgn(d1, SNR, 'measured');

% generate first receive filter
h1 = ones(10, 1);
% generate output of receive filter
C1 = conv(h1, d);

% generate second receive filter
h2 = zeros(10, 1);
h2(1) = 10;
% generate output of match filter
C2 = conv(h2, d);

% generate third receive filter
t3 = 0:1: 10 - 1;
h3 = (1.732 / 10) * t3;
% generate output of match filter
C3 = conv(h3, d);

% plot output of first receive filter
% figure(1)
t1 = 0:1: (length(R) + 1) * 10 - 2;
% plot(t1, C1)
title('h(t)= unit energy')
xlabel('time (ms)')
ylabel('recieve filter output')

% plot output of receive filter
% figure(2)
t2 = 0:1: 10 * (length(R) + 1) - 2;
% plot(t2, C2)
title('h(t)= delta(t)')
xlabel('time (ms)')
ylabel('recieve filter output')

% plot output of third receive filter
% figure(3)
% plot(t1, C3)
title('h(t)= triangle shape')
xlabel('time (ms)')
ylabel('recieve filter output')

% sample signal at t=10,20,… (second/10) for each filter
samples = zeros(length(R), 1);
samples2 = zeros(length(R), 1);
samples3 = zeros(length(R), 1);
for i=1: length(R)
samples(i) = C1(i * 10);
samples2(i) = C2(i * 10);
samples3(i) = C3(i * 10);
end

% decode samples and calculate BER% for each filter
decode = zeros(length(R), 1);
decode2 = zeros(length(R), 1);
decode3 = zeros(length(R), 1);
for i=1: length(R)
  
  if samples(i) > 0
      decode(i) = 1;
  end
  if decode(i) ~= R(i)
      BER1(SNR + 11) = BER1(SNR + 11) + 1;
  end
  
  if samples2(i) > 0
      decode2(i) = 1;
  end
  if decode2(i) ~= R(i)
      BER2(SNR + 11) = BER2(SNR + 11) + 1;
  end
  
  if samples3(i) > 0
      decode3(i) = 1;
  end
  if decode3(i) ~= R(i)
      BER3(SNR + 11) = BER3(SNR + 11) + 1;
  end
  
end
BER1(SNR + 11) = BER1(SNR + 11) * 100 / length(R);
BER2(SNR + 11) = BER2(SNR + 11) * 100 / length(R);
BER3(SNR + 11) = BER3(SNR + 11) * 100 / length(R);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % %
end

% plot SNR VS BER
SNR1 = -10:1: 20;
figure(4)
plot(SNR1, BER1, 'color', 'red')
hold on
plot(SNR1, BER2, 'color', 'green')
hold on
plot(SNR1, BER3, 'color', 'blue')
hold off
title('SNR VS BER red: matched filter, green: delta(t), blue: triangle')
xlabel('SNR')
ylabel('BER (%)')
% % % % % % % % % % % % % % % % % % % % % % % % % % % % %

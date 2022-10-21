clc, clear, close all;
%% 参数设置
T = 1;                                                      % 总的持续时间
Fr = 800;                                                   % 信号采样频率
Nr = 700;                                                   % 信号采样点数
Kr = 100;                                                   % 信号的调频率
Bw = 87.5;                                                  % 信号带宽
%% 参数计算
N = Fr*T;                                                   % 总的采样点数
Tr = Nr/Fr;                                                 % 信号持续时间
Delta_tau = 50/Fr;                                          % 偏移参数
%% 变量设置
t_0 = -Tr/2 : Tr/Nr : Tr/2-Tr/Nr;    
t_p = -T/2 : T/N : T/2-T/N;
f = -Fr/2 : Fr/N : Fr/2-Fr/N;
%% 信号生成
s_0_t = zeros(1, N);
s_0_t(50:749) = exp(1j*pi*Kr*t_0.^2);                       % 原始信号
s_p_t = exp(1j*2*pi*Kr*t_p*Delta_tau);                      % 变标方程
%% 信号处理
s_1_t = s_0_t .* s_p_t;                                     % 变标后的信号
%% 匹配滤波
H_f = exp(1j*pi*f.^2/Kr);               
s_2_t = ifft(fftshift(fft(s_0_t, [], 2)) .* H_f, [], 2);
s_3_t = ifft(fftshift(fft(s_1_t, [], 2)) .* H_f, [], 2);
%% 绘制图形
H1 = figure();
set(H1,'position',[100,100,600,600]);  
subplot(411), plot(real(s_0_t)), ylabel('幅度'), title('(a)原始信号实部');
subplot(412), plot(real(s_p_t)), ylabel('幅度'), title('(b)变标方程实部');
subplot(413), plot(real(s_1_t)), ylabel('幅度'), title('(c)变标后的信号实部');
subplot(414), plot(abs(s_2_t), '--'), hold on, plot(abs(s_3_t)), hold off, legend('原始信号', '变标后的信号'), xlabel('时间（采样点）'), ylabel('幅度'), title('(d)压缩后的原始信号和变标信号');
sgtitle('Figure7.3 变标及压缩之后的点目标平移');
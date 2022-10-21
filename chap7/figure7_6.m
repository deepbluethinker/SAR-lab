clc, clear, close all;
%% 参数设置 
N = 512;                                                    % 总的采样点数
Fr = 150;                                                   % 信号采样频率
Nr = 100;                                                   % 信号采样点数
Kr = 100;                                                   % 信号的调频率
%% 参数计算
T = N/Fr;                                                   % 总的持续时间
Tr = Nr/Fr;                                                 % 信号持续时间
alpha = 0.05;                                               % 偏移参数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% alpha = tau_a/tau_b - 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 变量设置
t_0 = -T/2 : T/N : T/2-T/N;
t_1 = -Tr/2 : Tr/Nr : Tr/2-Tr/Nr;
f = -Fr/2 : Fr/N : Fr/2-Fr/N;
%% 信号生成
%  原始信号
s_0_t = zeros(1, N);
s_0_t(6:105) = exp(1j*pi*Kr*t_1.^2);
s_0_t(206:305) = exp(1j*pi*Kr*t_1.^2);
s_0_t(406:505) = exp(1j*pi*Kr*t_1.^2);
%  变标信号
s_p_t = exp(1j*pi*alpha*Kr*t_0.^2);
%% 信号处理
s_1_t = s_0_t .* s_p_t;
%% 匹配滤波
H_f = exp(1j*pi*f.^2/Kr);
s_2_t = ifft(fftshift(fft(s_0_t, [], 2)) .* H_f, [], 2);
s_3_t = ifft(fftshift(fft(s_1_t, [], 2)) .* H_f, [], 2);
%% 绘制图形
H3 = figure();
set(H3,'position',[100,100,600,900]); 
subplot(511), plot(real(s_0_t)), axis([0 512, -1.2 1.2]), ylabel('幅度'), title('(a)原始信号实部');
subplot(512), plot(real(s_p_t)), axis([0 512, -1.2 1.2]), ylabel('幅度'), title('(b)变标方程实部');
subplot(513), plot(real(s_1_t)), axis([0 512, -1.2 1.2]), ylabel('幅度'), title('(c)变标后的信号实部');
subplot(514), plot(abs(s_2_t)), hold on, plot(abs(s_3_t)), hold off, axis([0 512, 0 12]), legend('原始信号', '变标后的信号'), ylabel('幅度'), title('(d)压缩后的原始信号和变标信号');
subplot(515), plot(abs(s_2_t)), hold on, plot(abs(s_3_t)), hold off, axis([428 480, 0 12]), legend('原始信号', '变标后的信号'), xlabel('时间（采样点）'), ylabel('幅度'), title('(e)(d)中右边目标放大后的形式');

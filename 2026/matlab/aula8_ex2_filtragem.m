% =========================================================================
% SEL343 - Processamento Digital de Sinais
% Aula 8: Filtros Digitais do Tipo FIR
% Exemplo 2: Filtragem de Sinal Ruidoso no Tempo e na Frequência
% =========================================================================
clc; clear all; close all;

% 1. Parâmetros de Amostragem e Sinal
fs = 500;                   % Frequência de amostragem (Hz)
t = 0:1/fs:1-1/fs;          % Vetor de tempo (1 segundo, 500 amostras)
N_sinal = length(t);

f1 = 10;                    % Sinal útil de baixa frequência (Hz)
f2 = 120;                   % Interferência senoidal de alta frequência (Hz)

% Sinal limpo (composto por uma fundamental de 10 Hz)
x_clean = sin(2 * pi * f1 * t);

% Sinal corrompido com alta frequência e ruído branco gaussiano
rng('default');             % Define semente randômica para reprodutibilidade
ruido = 0.3 * randn(size(t));
x_noisy = x_clean + 0.5 * cos(2 * pi * f2 * t) + ruido;

% 2. Projeto do Filtro FIR Passa-Baixas
M = 60;                     % Ordem do filtro (número de coeficientes = 61)
fc = 40;                    % Frequência de corte desejada (Hz)
wc = 2 * pi * fc / fs;      % Frequência de corte normalizada (rad/amostra)

k = 0:M;
alpha = M / 2;              % Centro de simetria para garantir fase linear (atraso de grupo)
g = zeros(1, M+1);
for idx = 1:M+1
    ki = k(idx);
    if ki == alpha
        g(idx) = wc / pi;
    else
        g(idx) = sin(wc * (ki - alpha)) / (pi * (ki - alpha));
    end
end

% Aplica a janela de Hamming para suavizar o truncamento de Gibbs
w = hamming(M+1)';
g = g .* w;

% 3. Filtragem do Sinal Ruidoso
% Usando a função filter do MATLAB
y_filtered = filter(g, 1, x_noisy);

% Compensação do atraso de grupo do filtro (atraso = alpha amostras)
% Deslocamos o sinal de saída para a esquerda para alinhar temporalmente com o original
y_filtered_compensated = [y_filtered(alpha+1:end), zeros(1, alpha)];

% 4. Análise Espectral (FFT)
f_fft = (0:N_sinal-1) * (fs / N_sinal);
X_noisy_fft = abs(fft(x_noisy)) / N_sinal;
Y_filtered_fft = abs(fft(y_filtered)) / N_sinal;

% Apenas a primeira metade do espectro (frequências positivas)
half_idx = 1:floor(N_sinal/2);
f_plot = f_fft(half_idx);
X_noisy_plot = 2 * X_noisy_fft(half_idx);
Y_filtered_plot = 2 * Y_filtered_fft(half_idx);

% 5. Geração dos Gráficos e Salvamento de Figuras
% Figura 1: Sinais no Domínio do Tempo
fig1 = figure('Name', 'Filtragem no Tempo', 'Position', [100, 100, 850, 580], 'Color', 'w');

subplot(3,1,1);
plot(t, x_clean, 'Color', '#2b2d42', 'LineWidth', 1.5);
title('Sinal Limpo (Original Fundamental f_1 = 10 Hz)', 'FontSize', 10, 'FontWeight', 'bold', 'Color', '#2b2d42', 'FontName', 'Arial');
xlabel('Tempo (s)', 'FontSize', 8, 'Color', '#2b2d42', 'FontName', 'Arial');
ylabel('Amplitude', 'FontSize', 8, 'Color', '#2b2d42', 'FontName', 'Arial');
ylim([-1.8, 1.8]);
grid on;
ax1 = gca;
set(ax1, 'Color', 'w', 'Box', 'on', 'GridLineStyle', '--', 'GridAlpha', 0.5, 'FontName', 'Arial', 'FontSize', 8);

subplot(3,1,2);
plot(t, x_noisy, 'Color', '#d90429', 'LineWidth', 1.0);
title('Sinal Ruidoso (Entrada: Fundamental + Ruído + Interferência f_2 = 120 Hz)', 'FontSize', 10, 'FontWeight', 'bold', 'Color', '#2b2d42', 'FontName', 'Arial');
xlabel('Tempo (s)', 'FontSize', 8, 'Color', '#2b2d42', 'FontName', 'Arial');
ylabel('Amplitude', 'FontSize', 8, 'Color', '#2b2d42', 'FontName', 'Arial');
ylim([-1.8, 1.8]);
grid on;
ax2 = gca;
set(ax2, 'Color', 'w', 'Box', 'on', 'GridLineStyle', '--', 'GridAlpha', 0.5, 'FontName', 'Arial', 'FontSize', 8);

subplot(3,1,3);
plot(t, y_filtered_compensated, 'Color', '#0077b6', 'LineWidth', 1.5);
title('Sinal Filtrado na Saída (Compensado pelo Atraso do Filtro de 30 Amostras)', 'FontSize', 10, 'FontWeight', 'bold', 'Color', '#2b2d42', 'FontName', 'Arial');
xlabel('Tempo (s)', 'FontSize', 8, 'Color', '#2b2d42', 'FontName', 'Arial');
ylabel('Amplitude', 'FontSize', 8, 'Color', '#2b2d42', 'FontName', 'Arial');
ylim([-1.8, 1.8]);
grid on;
ax3 = gca;
set(ax3, 'Color', 'w', 'Box', 'on', 'GridLineStyle', '--', 'GridAlpha', 0.5, 'FontName', 'Arial', 'FontSize', 8);

exportgraphics(fig1, '../images/aula8_filtering_time.png', 'Resolution', 200);

% Figura 2: Espectro dos Sinais (Domínio da Frequência)
fig2 = figure('Name', 'Filtragem na Frequência', 'Position', [100, 100, 850, 420], 'Color', 'w');
plot(f_plot, X_noisy_plot, 'Color', '#d90429', 'LineWidth', 1.5, 'DisplayName', 'Espectro do Sinal Ruidoso (Entrada)');
hold on;
plot(f_plot, Y_filtered_plot, 'Color', '#0077b6', 'LineWidth', 2, 'DisplayName', 'Espectro do Sinal Filtrado (Saída)');
xline(fc, 'Color', 'black', 'LineStyle', '--', 'LineWidth', 1.2, 'DisplayName', 'Frequência de Corte (40 Hz)');
title('Espectro de Amplitude dos Sinais (Entrada vs Saída)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', '#2b2d42', 'FontName', 'Arial');
xlabel('Frequência (Hz)', 'FontSize', 10, 'Color', '#2b2d42', 'FontName', 'Arial');
ylabel('Amplitude (Magnitude)', 'FontSize', 10, 'Color', '#2b2d42', 'FontName', 'Arial');
xlim([0, fs/2]);
grid on;
ax4 = gca;
set(ax4, 'Color', 'w', 'Box', 'on', 'GridLineStyle', '--', 'GridAlpha', 0.5, 'FontName', 'Arial', 'FontSize', 10);
lgd = legend('Location', 'NorthEast');
set(lgd, 'Color', 'w', 'EdgeColor', '#cbd5e1');

exportgraphics(fig2, '../images/aula8_filtering_freq.png', 'Resolution', 200);

% Figura 3: Mapa de Polos e Zeros do Filtro FIR
fig3 = figure('Name', 'Polos e Zeros', 'Position', [150, 150, 500, 500], 'Color', 'w');

% Preenche a região de estabilidade (dentro do círculo unitário) com rosa claro
theta = linspace(0, 2*pi, 200);
fill(cos(theta), sin(theta), '#f8d7da', 'EdgeColor', 'none', 'DisplayName', '');
hold on;

% Desenha a borda do círculo unitário (linha fina cinza claro)
plot(cos(theta), sin(theta), 'Color', '#cbd5e1', 'LineWidth', 1.5, 'DisplayName', '');

% Desenha eixos internos pretos
plot([-1.1, 1.1], [0, 0], 'Color', '#000000', 'LineWidth', 1.8, 'DisplayName', '');
plot([0, 0], [-1.1, 1.1], 'Color', '#000000', 'LineWidth', 1.8, 'DisplayName', '');

% Calcula raízes e plota zeros e polos
zeros_val = roots(g);
poles_val = zeros(1, M); % 60 polos na origem

plot(real(zeros_val), imag(zeros_val), 'o', 'Color', '#0072bd', 'MarkerSize', 6, 'LineWidth', 1.5, 'DisplayName', 'Zeros');
plot(real(poles_val), imag(poles_val), 'x', 'Color', '#ff0000', 'MarkerSize', 10, 'LineWidth', 3.0, 'DisplayName', 'Polos na Origem (x60)');

title('plano-z', 'FontSize', 12, 'FontWeight', 'bold', 'Color', '#000000', 'FontName', 'Arial');
xlabel('Real', 'FontSize', 11, 'Color', '#000000', 'FontName', 'Arial');
ylabel('Imag', 'FontSize', 11, 'Color', '#000000', 'FontName', 'Arial');

ax5 = gca;
set(ax5, 'Color', 'w', 'Box', 'on', 'TickDir', 'in', ...
    'XLim', [-1.1, 1.1], 'YLim', [-1.1, 1.1], ...
    'XTick', -1:0.5:1, 'YTick', -1:0.2:1, ...
    'FontName', 'Arial', 'FontSize', 9);
axis equal;
grid off;

lgd3 = legend('Location', 'NorthEast');
set(lgd3, 'Color', 'w', 'EdgeColor', '#cbd5e1', 'FontSize', 8);

exportgraphics(fig3, '../images/aula8_fir_poles_zeros.png', 'Resolution', 200);

disp('Exemplo 2 executado com sucesso! Figuras salvas em ../images/');

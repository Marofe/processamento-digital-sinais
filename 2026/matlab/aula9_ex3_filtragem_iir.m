clc; clear all; close all;

% 1. Parâmetros do Sinal e Ruído
fs = 500;                 % Frequência de amostragem (Hz)
t = 0 : 1/fs : 1 - 1/fs;  % Vetor de tempo (1 segundo)
N_sinal = length(t);
f1 = 10;                  % Senóide fundamental (10 Hz)
f2 = 120;                 % Ruído harmônico de alta frequência (120 Hz)

% Sinal limpo
x_clean = sin(2 * pi * f1 * t);

% Sinal ruidoso (fundamental + interferência de alta frequência + ruído gaussiano)
rng(42);                  % Semente para reprodutibilidade
noise = 0.3 * randn(size(t));
x_noisy = x_clean + 0.5 * cos(2 * pi * f2 * t) + noise;

% 2. Projeto do Filtro IIR Butterworth
fc = 40;                  % Frequência de corte (Hz)
order = 4;
[b, a] = butter(order, fc / (fs/2));

% 3. Filtragem Causal (Tempo Real)
y_causal = filter(b, a, x_noisy);

% 4. Filtragem Não-Causal (Fase Zero / Offline)
y_zerophase = filtfilt(b, a, x_noisy);

% --- GRÁFICO 1: Comparação no Domínio do Tempo ---
fig1 = figure('Position', [100, 100, 850, 580]);

subplot(3, 1, 1);
plot(t, x_clean, 'k', 'LineWidth', 1.5);
title('Sinal Limpo (Original Fundamental f_1 = 10 Hz)', 'FontSize', 10, 'FontWeight', 'bold', 'FontName', 'Arial');
ylabel('Amplitude', 'FontSize', 9);
grid on; ax = gca; ax.GridLineStyle = '--'; ax.GridAlpha = 0.5;
ylim([-1.8, 1.8]);

subplot(3, 1, 2);
plot(t, x_noisy, 'Color', [0.85, 0.16, 0.16], 'LineWidth', 1.0);
title('Sinal Ruidoso (Entrada: Fundamental + Ruído + Interferência f_2 = 120 Hz)', 'FontSize', 10, 'FontWeight', 'bold', 'FontName', 'Arial');
ylabel('Amplitude', 'FontSize', 9);
grid on; ax = gca; ax.GridLineStyle = '--'; ax.GridAlpha = 0.5;
ylim([-1.8, 1.8]);

subplot(3, 1, 3);
plot(t, y_causal, 'Color', [0, 0.45, 0.74], 'LineWidth', 1.5); hold on;
plot(t, y_zerophase, 'Color', [0.18, 0.77, 0.71], 'LineWidth', 1.5);
title('Sinais Filtrados na Saída (Butterworth de 4ª Ordem)', 'FontSize', 10, 'FontWeight', 'bold', 'FontName', 'Arial');
xlabel('Tempo (s)', 'FontSize', 9);
ylabel('Amplitude', 'FontSize', 9);
legend('Filtragem Causal (filter - Com Atraso)', 'Filtragem Zero-Fase (filtfilt - Sem Atraso)', 'Location', 'southwest', 'FontSize', 8);
grid on; ax = gca; ax.GridLineStyle = '--'; ax.GridAlpha = 0.5;
ylim([-1.8, 1.8]);

exportgraphics(fig1, '../../images/aula9_iir_filtering_time.png', 'Resolution', 200);
close(fig1);

% --- GRÁFICO 2: Comparação no Domínio da Frequência ---
fig2 = figure('Position', [100, 100, 850, 420]);

% Espectros de amplitude por FFT
X_noisy_fft = abs(fft(x_noisy)) / N_sinal;
Y_causal_fft = abs(fft(y_causal)) / N_sinal;
freqs = (0 : N_sinal-1) * (fs / N_sinal);

% Apenas metade positiva do espectro
half_idx = freqs <= fs/2;
f_plot = freqs(half_idx);
X_noisy_plot = 2 * X_noisy_fft(half_idx);
Y_causal_plot = 2 * Y_causal_fft(half_idx);

plot(f_plot, X_noisy_plot, 'Color', [0.85, 0.16, 0.16], 'LineWidth', 1.5); hold on;
plot(f_plot, Y_causal_plot, 'Color', [0, 0.45, 0.74], 'LineWidth', 2.0);
xline(fc, '--k', 'Frequência de Corte (40 Hz)', 'LabelVerticalAlignment', 'top', 'LabelHorizontalAlignment', 'center', 'FontName', 'Arial');

grid on; ax = gca; ax.GridLineStyle = '--'; ax.GridAlpha = 0.5; ax.FontSize = 10;
ax.FontName = 'Arial'; box on;
xlim([0, fs/2]);
xlabel('Frequência (Hz)', 'FontSize', 11, 'FontName', 'Arial');
ylabel('Amplitude (Magnitude)', 'FontSize', 11, 'FontName', 'Arial');
title('Espectro de Amplitude dos Sinais (Entrada vs Saída)', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Arial');
legend('Espectro do Sinal Ruidoso (Entrada)', 'Espectro do Sinal Filtrado (Saída)', 'Location', 'northeast');

exportgraphics(fig2, '../../images/aula9_iir_filtering_freq.png', 'Resolution', 200);
close(fig2);

disp('Gráficos de filtragem temporal e espectral gerados!');

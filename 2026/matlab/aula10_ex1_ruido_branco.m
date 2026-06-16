clc; clear all; close all;

% 1. Parâmetros do Sinal
fs = 1000;                % Frequência de amostragem (Hz)
t = 0 : 1/fs : 1 - 1/fs;  % Vetor de tempo (1 segundo)
N = length(t);
sigma = 1.5;              % Desvio padrão do ruído branco

% 2. Geração do Ruído Branco Gaussiano
rng(42);                  % Semente para reprodutibilidade
w = sigma * randn(size(t));

% 3. Autocorrelação Estimada
[r, lags] = xcorr(w, 'biased');
lags_ms = (lags / fs) * 1000; % Converter lags para milissegundos

% 4. Densidade Espectral de Potência (PSD) via FFT (Periodograma)
W = fft(w);
PSD = (abs(W).^2) / (N * fs); % Densidade espectral bilateral
freqs = (0 : N-1) * (fs / N);
half_idx = freqs <= fs/2;
f_plot = freqs(half_idx);
PSD_plot = PSD(half_idx);
PSD_plot(2:end-1) = 2 * PSD_plot(2:end-1); % Dobrar para espectro unilateral

% --- GRÁFICO ---
fig = figure('Position', [100, 100, 850, 600]);

% Subplot 1: Domínio do Tempo
subplot(3, 1, 1);
plot(t, w, 'Color', [0.3, 0.3, 0.3], 'LineWidth', 0.8);
title('Sinal de Ruído Branco Gaussiano no Domínio do Tempo', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Arial');
xlabel('Tempo (s)', 'FontSize', 9, 'FontName', 'Arial');
ylabel('Amplitude', 'FontSize', 9, 'FontName', 'Arial');
grid on; ax = gca; ax.GridLineStyle = '--'; ax.GridAlpha = 0.5;
ylim([-5, 5]);

% Subplot 2: Autocorrelação
subplot(3, 1, 2);
plot(lags_ms, r, 'Color', [0, 0.4470, 0.7410], 'LineWidth', 1.5);
title('Função de Autocorrelação Estimada', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Arial');
xlabel('Atraso (ms)', 'FontSize', 9, 'FontName', 'Arial');
ylabel('Autocorrelação', 'FontSize', 9, 'FontName', 'Arial');
grid on; ax = gca; ax.GridLineStyle = '--'; ax.GridAlpha = 0.5;
xlim([-100, 100]); % Zoom nos lags centrais
ylim([-0.5, sigma^2 + 0.5]);

% Subplot 3: Densidade Espectral de Potência (PSD)
subplot(3, 1, 3);
plot(f_plot, 10*log10(PSD_plot), 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 1.0);
title('Densidade Espectral de Potência (PSD) - Espectro Unilateral', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Arial');
xlabel('Frequência (Hz)', 'FontSize', 9, 'FontName', 'Arial');
ylabel('Potência (dB/Hz)', 'FontSize', 9, 'FontName', 'Arial');
grid on; ax = gca; ax.GridLineStyle = '--'; ax.GridAlpha = 0.5;
xlim([0, fs/2]);
ylim([-40, 10]);

exportgraphics(fig, '../../images/aula10_ruido_branco.png', 'Resolution', 200);
close(fig);
disp('Gráfico do ruído branco gerado com sucesso!');

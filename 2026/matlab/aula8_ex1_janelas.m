% =========================================================================
% SEL343 - Processamento Digital de Sinais
% Aula 8: Filtros Digitais do Tipo FIR
% Exemplo 1: Projeto de Filtro Passa-Baixas usando Janelamento
% =========================================================================
clc; clear all; close all;

% Parâmetros do filtro
fs = 1000;          % Frequência de amostragem (Hz)
fc = 150;           % Frequência de corte (Hz)
M = 50;             % Ordem do filtro (número de taps = M + 1)
N = M + 1;          % Comprimento do filtro (número de coeficientes)

% Frequência de corte normalizada (rad/amostra)
wc = 2 * pi * fc / fs;

% 1. Resposta ao impulso ideal (sinc truncada e deslocada para ser causal)
k = 0:M;
alpha = M / 2;      % Atraso de grupo para garantir causalidade e simetria
g_ideal = zeros(1, N);
for idx = 1:N
    ki = k(idx);
    if ki == alpha
        g_ideal(idx) = wc / pi;
    else
        g_ideal(idx) = sin(wc * (ki - alpha)) / (pi * (ki - alpha));
    end
end

% 2. Aplicação das Janelas
w_rect = rectwin(N)';            % Janela Retangular
w_hamming = hamming(N)';        % Janela Hamming
w_blackman = blackman(N)';      % Janela Blackman

g_rect = g_ideal .* w_rect;
g_hamming = g_ideal .* w_hamming;
g_blackman = g_ideal .* w_blackman;

% 3. Resposta em Frequência (usando freqz)
[G_rect, f] = freqz(g_rect, 1, 1024, fs);
[G_hamming, ~] = freqz(g_hamming, 1, 1024, fs);
[G_blackman, ~] = freqz(g_blackman, 1, 1024, fs);

% Magnitudes em dB
mag_rect = 20 * log10(abs(G_rect));
mag_hamming = 20 * log10(abs(G_hamming));
mag_blackman = 20 * log10(abs(G_blackman));

% 4. Visualização dos Resultados
% Figura 1: Resposta ao impulso g[k] (Compara Retangular vs Hamming)
fig1 = figure('Name', 'Resposta ao Impulso', 'Position', [100, 100, 850, 480], 'Color', 'w');

subplot(2,1,1);
g_stem1 = stem(k, g_rect, 'basefmt', 'k-');
set(g_stem1, 'MarkerFaceColor', '#0077b6', 'MarkerEdgeColor', '#0077b6', 'Color', '#0077b6', 'LineWidth', 1.2, 'MarkerSize', 4);
if isprop(g_stem1, 'BaseLine')
    set(g_stem1.BaseLine, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 0.8, 'LineStyle', '-');
end
title('Resposta ao Impulso g[k] - Janela Retangular', 'FontSize', 11, 'FontWeight', 'bold', 'Color', '#2b2d42', 'FontName', 'Arial');
xlabel('Amostra k', 'FontSize', 9, 'Color', '#2b2d42', 'FontName', 'Arial');
ylabel('Amplitude', 'FontSize', 9, 'Color', '#2b2d42', 'FontName', 'Arial');
xlim([-1, M+1]);
grid on;
ax1 = gca;
set(ax1, 'Color', 'w', 'Box', 'on', 'GridLineStyle', '--', 'GridAlpha', 0.5, 'FontName', 'Arial', 'FontSize', 9);

subplot(2,1,2);
g_stem2 = stem(k, g_hamming, 'basefmt', 'k-');
set(g_stem2, 'MarkerFaceColor', '#d90429', 'MarkerEdgeColor', '#d90429', 'Color', '#d90429', 'LineWidth', 1.2, 'MarkerSize', 4);
if isprop(g_stem2, 'BaseLine')
    set(g_stem2.BaseLine, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 0.8, 'LineStyle', '-');
end
title('Resposta ao Impulso g[k] - Janela Hamming', 'FontSize', 11, 'FontWeight', 'bold', 'Color', '#2b2d42', 'FontName', 'Arial');
xlabel('Amostra k', 'FontSize', 9, 'Color', '#2b2d42', 'FontName', 'Arial');
ylabel('Amplitude', 'FontSize', 9, 'Color', '#2b2d42', 'FontName', 'Arial');
xlim([-1, M+1]);
grid on;
ax2 = gca;
set(ax2, 'Color', 'w', 'Box', 'on', 'GridLineStyle', '--', 'GridAlpha', 0.5, 'FontName', 'Arial', 'FontSize', 9);

% Salva a imagem na pasta de imagens para uso nos slides com alta qualidade
exportgraphics(fig1, '../images/aula8_fir_impulse.png', 'Resolution', 200);

% Figura 2: Resposta em Frequência (Magnitude em dB)
fig2 = figure('Name', 'Resposta em Frequência', 'Position', [100, 100, 850, 450], 'Color', 'w');
plot(f, mag_rect, 'Color', '#0077b6', 'LineWidth', 2, 'DisplayName', 'Retangular');
hold on;
plot(f, mag_hamming, 'Color', '#d90429', 'LineWidth', 2, 'DisplayName', 'Hamming');
plot(f, mag_blackman, 'Color', '#2ec4b6', 'LineWidth', 2, 'DisplayName', 'Blackman');
yline(-6, 'Color', 'black', 'LineStyle', '--', 'LineWidth', 1.2, 'DisplayName', '-6 dB (Corte)');
title('Resposta em Frequência - Comparação de Janelas', 'FontSize', 12, 'FontWeight', 'bold', 'Color', '#2b2d42', 'FontName', 'Arial');
xlabel('Frequência (Hz)', 'FontSize', 10, 'Color', '#2b2d42', 'FontName', 'Arial');
ylabel('Magnitude (dB)', 'FontSize', 10, 'Color', '#2b2d42', 'FontName', 'Arial');
ylim([-100, 10]);
xlim([0, fs/2]);
grid on;
ax3 = gca;
set(ax3, 'Color', 'w', 'Box', 'on', 'GridLineStyle', '--', 'GridAlpha', 0.5, 'FontName', 'Arial', 'FontSize', 10);
lgd = legend('Location', 'SouthWest');
set(lgd, 'Color', 'w', 'EdgeColor', '#cbd5e1');

% Salva a imagem
exportgraphics(fig2, '../images/aula8_fir_freq_resp.png', 'Resolution', 200);

disp('Exemplo 1 executado com sucesso! Figuras salvas em ../images/');

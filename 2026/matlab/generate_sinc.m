clc; clear all; close all;

% Parâmetros
wc = 0.25 * pi; % Frequência de corte (0.25*pi)
n = -20:20;     % Vetor de tempo discreto

% Cálculo da função sinc discreta
h = zeros(size(n));
for i = 1:length(n)
    if n(i) == 0
        h(i) = wc / pi;
    else
        h(i) = sin(wc * n(i)) / (pi * n(i));
    end
end

% Criação da figura para exportação
fig = figure('Position', [100, 100, 800, 420], 'Visible', 'off');
s = stem(n, h, 'filled', 'LineWidth', 2.0);

% Ajuste de cores (Estilo MATLAB clássico)
s.Color = [0, 0.4470, 0.7410];
s.MarkerSize = 6;

% Estilização dos eixos
grid on;
ax = gca;
ax.GridLineStyle = '--';
ax.GridAlpha = 0.5;
ax.FontSize = 12;
ax.FontName = 'Arial';
ax.Box = 'on';

% Títulos e legendas
title('Resposta ao Impulso Ideal - Função Sinc Discreta g_d[k]', 'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Arial');
xlabel('Índice da Amostra (k)', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Amplitude g_d[k]', 'FontSize', 12, 'FontName', 'Arial');
xlim([-21, 21]);
ylim([-0.1, 0.3]);

% Salvar em uma pasta ASCII segura temporariamente
output_path = 'C:\Users\engma\.gemini\antigravity-cli\brain\aaf32d08-cb6b-42ba-874d-38315eaacaae\scratch\sinc_discreta.svg';

% Salvar em formato SVG
print(fig, output_path, '-dsvg');
close(fig);
disp('Gráfico da função sinc discreta gerado com sucesso no scratch!');

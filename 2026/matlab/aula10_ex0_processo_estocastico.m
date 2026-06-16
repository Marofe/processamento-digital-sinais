clc; clear all; close all;

% 1. Parâmetros da Simulação
fs = 500;                 % Frequência de amostragem (Hz)
t = 0 : 1/fs : 1.5 - 1/fs; % Vetor de tempo (1.5 segundos)
N = length(t);

% Média do processo estocástico (sinal determinístico variante no tempo)
mu = 10 + 4 * sin(2 * pi * 1.5 * t);

% Desvio padrão constante do ruído
sigma = 1.5;

% 2. Geração de uma Realização do Processo Estocástico
% x(t) = mu(t) + w(t), onde w(t) ~ N(0, sigma^2)
rng(23);                  % Semente para reprodutibilidade
w = sigma * randn(size(t));
x = mu + w;

% Limites de 3-sigma (intervalo de confiança de 99.7%)
upper_bound = mu + 3 * sigma;
lower_bound = mu - 3 * sigma;

% 3. Plotagem dos Resultados
fig = figure('Position', [100, 100, 850, 480]);
hold on;

% Região sombreada representativa da variância (Faixa de 3-sigma)
fill_x = [t, fliplr(t)];
fill_y = [upper_bound, fliplr(lower_bound)];
h_fill = fill(fill_x, fill_y, [0.0, 0.4470, 0.7410], 'EdgeColor', 'none', 'FaceAlpha', 0.12);

% Plotar limites 3-sigma em linhas tracejadas
h_bounds = plot(t, upper_bound, 'Color', [0.0, 0.4470, 0.7410], 'LineStyle', '--', 'LineWidth', 1.2);
plot(t, lower_bound, 'Color', [0.0, 0.4470, 0.7410], 'LineStyle', '--', 'LineWidth', 1.2);

% Plotar a realização ruidosa
h_process = plot(t, x, 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 0.8);

% Plotar a média teórica do processo
h_mean = plot(t, mu, 'k', 'LineWidth', 2.2);

% Configurações adicionais de estilo
title('Ilustração de um Processo Estocástico: Média e Variância 3-Sigma', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Arial');
xlabel('Tempo (s)', 'FontSize', 10, 'FontName', 'Arial');
ylabel('Amplitude', 'FontSize', 10, 'FontName', 'Arial');
grid on; ax = gca; ax.GridLineStyle = ':'; ax.GridAlpha = 0.6; ax.FontSize = 10;
box on;
ylim([2, 18]);

% Legenda clara
legend([h_process, h_mean, h_bounds, h_fill], ...
    {'Processo Ruidoso (Realização x(t))', 'Média Real (\mu(t))', 'Limites \pm3\sigma (Incerteza)', 'Região de Variância 3\sigma (99.7%)'}, ...
    'Location', 'northeast');

exportgraphics(fig, '../../images/aula10_processo_estocastico.png', 'Resolution', 200);
close(fig);
disp('Gráfico de ilustração do processo estocástico gerado com sucesso!');

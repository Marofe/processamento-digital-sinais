clc; clear all; close all;

% 1. Parâmetros da Simulação
fs = 500;                 % Frequência de amostragem (Hz)
t = 0 : 1/fs : 1.5 - 1/fs; % Vetor de tempo (1.5 segundos)
N = length(t);

% Média do processo estocástico (variante no tempo)
mu = 10 + 4 * sin(2 * pi * 1.5 * t);

% Desvio padrão constante do ruído
sigma = 1.5;

% Geração de uma Realização do Processo Estocástico
rng(23);                  % Semente para reprodutibilidade
w = sigma * randn(size(t));
x = mu + w;

% Limites de 3-sigma
upper_bound = mu + 3 * sigma;
lower_bound = mu - 3 * sigma;

% Instantes específicos para colocar as Gaussianas no eixo Z
t_instantes = [0.25, 0.75, 1.25];

% 2. Plotagem em 3D
fig = figure('Position', [100, 100, 900, 550]);
hold on;

% Realização ruidosa no plano Z = 0
plot3(t, x, zeros(size(t)), 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 0.8);

% Média real no plano Z = 0
plot3(t, mu, zeros(size(t)), 'k', 'LineWidth', 2.0);

% Limites de 3-sigma no plano Z = 0
plot3(t, upper_bound, zeros(size(t)), 'Color', [0.0, 0.4470, 0.7410], 'LineStyle', '--', 'LineWidth', 1.0);
plot3(t, lower_bound, zeros(size(t)), 'Color', [0.0, 0.4470, 0.7410], 'LineStyle', '--', 'LineWidth', 1.0);

% Adicionar as Gaussianas 3D transversais (no plano X = t_i)
for i = 1:length(t_instantes)
    ti = t_instantes(i);
    [~, idx] = min(abs(t - ti)); % Índice temporal mais próximo
    mu_i = mu(idx);
    
    % Grade de amplitude em torno de mu_i para desenhar a PDF
    y_grid = linspace(mu_i - 3.5 * sigma, mu_i + 3.5 * sigma, 100);
    
    % Função Densidade de Probabilidade Gaussiana
    z_pdf = (1 / (sqrt(2 * pi) * sigma)) * exp(-(y_grid - mu_i).^2 / (2 * sigma^2));
    
    % Escalar a PDF para melhor visualização tridimensional
    scale_factor = 4.0;
    z_plot = z_pdf * scale_factor;
    
    % Vetor de tempo constante para a posição X
    x_const = ti * ones(size(y_grid));
    
    % Preenchimento transparente sob a Gaussiana
    fill3(x_const, y_grid, z_plot, [0.0, 0.4470, 0.7410], 'FaceAlpha', 0.15, 'EdgeColor', 'none');
    
    % Linha de contorno da Gaussiana
    plot3(x_const, y_grid, z_plot, 'Color', [0.0, 0.4470, 0.7410], 'LineWidth', 1.6);
    
    % Linhas auxiliares de projeção ligando o pico à média
    plot3([ti, ti], [mu_i, mu_i], [0, max(z_plot)], 'k:', 'LineWidth', 1.0);
    plot3([ti, ti], [mu_i - 3*sigma, mu_i + 3*sigma], [0, 0], 'Color', [0, 0.4470, 0.7410], 'LineWidth', 1.0);
end

% Ajustar a visualização e rotação 3D
view(-60, 25);
grid on;
box on;
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.5;
ax.FontSize = 10;

% Títulos e Rótulos dos Eixos
title('Distribuição de Probabilidade Gaussiana ao longo do Processo Estocástico', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Arial');
xlabel('Tempo (s)', 'FontSize', 10, 'FontWeight', 'bold', 'FontName', 'Arial');
ylabel('Amplitude (Processo)', 'FontSize', 10, 'FontWeight', 'bold', 'FontName', 'Arial');
zlabel('Densidade de Probabilidade p(x)', 'FontSize', 10, 'FontWeight', 'bold', 'FontName', 'Arial');

% Ajustes de Limites dos Eixos
xlim([0, 1.5]);
ylim([2, 18]);
zlim([0, 1.2]);

% Legenda explicativa
legend({'Realização Ruidosa x(t)', 'Média Real \mu(t)', 'Limites \pm3\sigma', 'PDF Gaussiana p(x|t)'}, ...
    'Location', 'northeast', 'FontSize', 9);

exportgraphics(fig, '../../images/aula10_processo_estocastico_3d.png', 'Resolution', 200);
close(fig);
disp('Gráfico 3D do processo estocástico com Gaussianas gerado com sucesso!');

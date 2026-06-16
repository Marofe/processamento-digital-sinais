clc; clear all; close all;

% 1. Parâmetros da Gaussiana Normal
mu = 0;
sigma = 1;
x = -4 : 0.01 : 4;
y = (1 / (sqrt(2 * pi) * sigma)) * exp(-(x - mu).^2 / (2 * sigma^2));

% 2. Criação da Figura
fig = figure('Position', [100, 100, 850, 480]);
hold on;

% Preenchimento de regiões com diferentes tons de azul
% Faixa 3-sigma (99.73%)
fill_x3 = x(x >= -3 & x <= 3);
fill_y3 = y(x >= -3 & x <= 3);
fill([fill_x3(1), fill_x3, fill_x3(end)], [0, fill_y3, 0], [0.0, 0.4470, 0.7410], 'FaceAlpha', 0.08, 'EdgeColor', 'none');

% Faixa 2-sigma (95.45%)
fill_x2 = x(x >= -2 & x <= 2);
fill_y2 = y(x >= -2 & x <= 2);
fill([fill_x2(1), fill_x2, fill_x2(end)], [0, fill_y2, 0], [0.0, 0.4470, 0.7410], 'FaceAlpha', 0.15, 'EdgeColor', 'none');

% Faixa 1-sigma (68.27%)
fill_x1 = x(x >= -1 & x <= 1);
fill_y1 = y(x >= -1 & x <= 1);
fill([fill_x1(1), fill_x1, fill_x1(end)], [0, fill_y1, 0], [0.0, 0.4470, 0.7410], 'FaceAlpha', 0.25, 'EdgeColor', 'none');

% Linha principal da PDF Gaussiana
plot(x, y, 'k', 'LineWidth', 2.0);

% Linhas verticais para demarcar os desvios padrões
sigma_pts = [-3, -2, -1, 0, 1, 2, 3];
for pt = sigma_pts
    [~, idx] = min(abs(x - pt));
    plot([pt, pt], [0, y(idx)], 'k:', 'LineWidth', 0.8);
end

% 3. Adicionar colchetes horizontais para indicar porcentagens
% Colchete 1-sigma (68.27%) em y = 0.22
plot([-1, 1], [0.22, 0.22], 'k-', 'LineWidth', 1.2);
plot([-1, -1], [0.20, 0.24], 'k-', 'LineWidth', 1.2);
plot([1, 1], [0.20, 0.24], 'k-', 'LineWidth', 1.2);
text(0, 0.24, '68.27%', 'HorizontalAlignment', 'center', 'FontSize', 10, 'FontWeight', 'bold', 'FontName', 'Arial');

% Colchete 2-sigma (95.45%) em y = 0.12
plot([-2, 2], [0.12, 0.12], 'k-', 'LineWidth', 1.2);
plot([-2, -2], [0.10, 0.14], 'k-', 'LineWidth', 1.2);
plot([2, 2], [0.10, 0.14], 'k-', 'LineWidth', 1.2);
text(0, 0.14, '95.45%', 'HorizontalAlignment', 'center', 'FontSize', 10, 'FontWeight', 'bold', 'FontName', 'Arial');

% Colchete 3-sigma (99.73%) em y = 0.03
plot([-3, 3], [0.03, 0.03], 'k-', 'LineWidth', 1.2);
plot([-3, -3], [0.01, 0.05], 'k-', 'LineWidth', 1.2);
plot([3, 3], [0.01, 0.05], 'k-', 'LineWidth', 1.2);
text(0, 0.05, '99.73%', 'HorizontalAlignment', 'center', 'FontSize', 10, 'FontWeight', 'bold', 'FontName', 'Arial');

% Ajustes nos rótulos do eixo X (usando letras gregas)
set(gca, 'XTick', sigma_pts);
set(gca, 'XTickLabel', {'\mu-3\sigma', '\mu-2\sigma', '\mu-\sigma', '\mu', '\mu+\sigma', '\mu+2\sigma', '\mu+3\sigma'});

% Estilização Geral
title('Regra Empírica da Distribuição Normal (Gaussiana)', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Arial');
xlabel('Desvios Padrão (\sigma) em torno da Média (\mu)', 'FontSize', 10, 'FontName', 'Arial');
ylabel('Densidade de Probabilidade f(x)', 'FontSize', 10, 'FontName', 'Arial');
grid on; ax = gca; ax.GridLineStyle = ':'; ax.GridAlpha = 0.5; ax.FontSize = 10;
box on;
xlim([-4, 4]);
ylim([0, 0.45]);

exportgraphics(fig, '../../images/aula10_gaussiana_sigmas.png', 'Resolution', 200);
close(fig);
disp('Gráfico da regra empírica da Gaussiana gerado com sucesso!');

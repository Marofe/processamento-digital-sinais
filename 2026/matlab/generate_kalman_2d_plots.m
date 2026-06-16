clc; clear all; close all;

% Parâmetros para k = 1
mu_pred = 20.0; sigma_pred = 1.5;
mu_meas = 24.0; sigma_meas = 1.2;
mu_post = 22.4; sigma_post = 0.94;

x = 14:0.05:30;

% PDFs
y_pred = (1 / (sqrt(2*pi)*sigma_pred)) * exp(-(x - mu_pred).^2 / (2*sigma_pred^2));
y_meas = (1 / (sqrt(2*pi)*sigma_meas)) * exp(-(x - mu_meas).^2 / (2*sigma_meas^2));
y_post = (1 / (sqrt(2*pi)*sigma_post)) * exp(-(x - mu_post).^2 / (2*sigma_post^2));

% ----------------- PLOT 1: PREDIÇÃO -----------------
fig1 = figure('Position', [100, 100, 800, 400]);
hold on;
fill([x(1), x, x(end)], [0, y_pred, 0], [0.0, 0.4470, 0.7410], 'FaceAlpha', 0.15, 'EdgeColor', 'none');
plot(x, y_pred, 'Color', [0.0, 0.4470, 0.7410], 'LineWidth', 2.0);
plot([mu_pred, mu_pred], [0, max(y_pred)], 'Color', [0.0, 0.4470, 0.7410], 'LineStyle', ':', 'LineWidth', 1.2);
title('Filtro de Kalman 2D: Etapa de Predição (Prior)', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Arial');
xlabel('Estado x (Temperatura °C)', 'FontSize', 10, 'FontName', 'Arial');
ylabel('Densidade de Probabilidade p(x)', 'FontSize', 10, 'FontName', 'Arial');
legend('Predição p(x_{k+1}|y_0...y_k)', 'Location', 'best');
xlim([14, 30]); ylim([0, 0.45]);
grid on; ax = gca; ax.GridLineStyle = '--'; ax.GridAlpha = 0.5; box on;
exportgraphics(fig1, '../../images/aula10_kalman_2d_1_predicao.png', 'Resolution', 200);
close(fig1);

% ----------------- PLOT 2: MEDIÇÃO -----------------
fig2 = figure('Position', [100, 100, 800, 400]);
hold on;
% Predição
fill([x(1), x, x(end)], [0, y_pred, 0], [0.0, 0.4470, 0.7410], 'FaceAlpha', 0.05, 'EdgeColor', 'none');
plot(x, y_pred, 'Color', [0.0, 0.4470, 0.7410], 'LineWidth', 1.2, 'LineStyle', '--');
% Medição
fill([x(1), x, x(end)], [0, y_meas, 0], [0.8500, 0.3250, 0.0980], 'FaceAlpha', 0.15, 'EdgeColor', 'none');
plot(x, y_meas, 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 2.0);
plot([mu_meas, mu_meas], [0, max(y_meas)], 'Color', [0.8500, 0.3250, 0.0980], 'LineStyle', ':', 'LineWidth', 1.2);
title('Filtro de Kalman 2D: Introdução da Medição (Likelihood)', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Arial');
xlabel('Estado x (Temperatura °C)', 'FontSize', 10, 'FontName', 'Arial');
ylabel('Densidade de Probabilidade p(x)', 'FontSize', 10, 'FontName', 'Arial');
legend('Predição (anterior)', 'Medição p(y_{k+1}|x_{k+1})', 'Location', 'best');
xlim([14, 30]); ylim([0, 0.45]);
grid on; ax = gca; ax.GridLineStyle = '--'; ax.GridAlpha = 0.5; box on;
exportgraphics(fig2, '../../images/aula10_kalman_2d_2_medicao.png', 'Resolution', 200);
close(fig2);

% ----------------- PLOT 3: POSTERIORI -----------------
fig3 = figure('Position', [100, 100, 800, 400]);
hold on;
% Predição
fill([x(1), x, x(end)], [0, y_pred, 0], [0.0, 0.4470, 0.7410], 'FaceAlpha', 0.05, 'EdgeColor', 'none');
plot(x, y_pred, 'Color', [0.0, 0.4470, 0.7410], 'LineWidth', 1.2, 'LineStyle', '--');
% Medição
fill([x(1), x, x(end)], [0, y_meas, 0], [0.8500, 0.3250, 0.0980], 'FaceAlpha', 0.05, 'EdgeColor', 'none');
plot(x, y_meas, 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 1.2, 'LineStyle', '--');
% Posteriori
fill([x(1), x, x(end)], [0, y_post, 0], [0.4660, 0.6740, 0.1880], 'FaceAlpha', 0.20, 'EdgeColor', 'none');
plot(x, y_post, 'Color', [0.4660, 0.6740, 0.1880], 'LineWidth', 2.2);
plot([mu_post, mu_post], [0, max(y_post)], 'Color', [0.4660, 0.6740, 0.1880], 'LineStyle', ':', 'LineWidth', 1.2);
title('Filtro de Kalman 2D: Etapa de Correção (Posterior)', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Arial');
xlabel('Estado x (Temperatura °C)', 'FontSize', 10, 'FontName', 'Arial');
ylabel('Densidade de Probabilidade p(x)', 'FontSize', 10, 'FontName', 'Arial');
legend('Predição (Prior)', 'Medição (Likelihood)', 'Posteriori p(x_{k+1}|y_0...y_{k+1})', 'Location', 'best');
xlim([14, 30]); ylim([0, 0.45]);
grid on; ax = gca; ax.GridLineStyle = '--'; ax.GridAlpha = 0.5; box on;
exportgraphics(fig3, '../../images/aula10_kalman_2d_3_posteriori.png', 'Resolution', 200);
close(fig3);

disp('Plots 2D do Filtro de Kalman gerados com sucesso!');

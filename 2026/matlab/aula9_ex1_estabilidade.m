clc; clear all; close all;

% Parâmetros comuns
N = 50;              % Número de amostras para simulação
n = 0:N-1;           % Vetor de tempo discreto
x = [1, zeros(1, N-1)]; % Impulso unitário delta[k]

% Caso 1: Filtro Estável (Polo em z = 0.8)
b1 = [1];
a1 = [1, -0.8];      % y[k] = 0.8*y[k-1] + x[k]
y1 = filter(b1, a1, x);

% Caso 2: Filtro Marginalmente Estável (Polo em z = 1.0)
b2 = [1];
a2 = [1, -1.0];      % y[k] = 1.0*y[k-1] + x[k]
y2 = filter(b2, a2, x);

% Caso 3: Filtro Instável (Polo em z = 1.05)
b3 = [1];
a3 = [1, -1.05];     % y[k] = 1.05*y[k-1] + x[k]
y3 = filter(b3, a3, x);

% --- PLOT 1: Resposta ao Impulso Comparativa ---
fig1 = figure('Position', [100, 100, 850, 480]);

subplot(3, 1, 1);
s1 = stem(n, y1, 'filled', 'LineWidth', 1.5);
s1.Color = [0, 0.4470, 0.7410]; % Azul
title('Resposta ao Impulso: Sistema Estável (Polo em z = 0.8)', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Arial');
ylabel('y_1[k]', 'FontSize', 10, 'FontName', 'Arial');
grid on;
ax = gca; ax.GridLineStyle = '--'; ax.GridAlpha = 0.5; ax.FontSize = 10;
ylim([-0.2, 1.2]);

subplot(3, 1, 2);
s2 = stem(n, y2, 'filled', 'LineWidth', 1.5);
s2.Color = [0.9290, 0.6940, 0.1250]; % Amarelo/Laranja
title('Resposta ao Impulso: Sistema Marginalmente Estável (Polo em z = 1.0)', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Arial');
ylabel('y_2[k]', 'FontSize', 10, 'FontName', 'Arial');
grid on;
ax = gca; ax.GridLineStyle = '--'; ax.GridAlpha = 0.5; ax.FontSize = 10;
ylim([-0.2, 1.2]);

subplot(3, 1, 3);
s3 = stem(n, y3, 'filled', 'LineWidth', 1.5);
s3.Color = [0.8500, 0.3250, 0.0980]; % Laranja Escuro / Vermelho
title('Resposta ao Impulso: Sistema Instável (Polo em z = 1.05)', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Arial');
xlabel('Amostras (k)', 'FontSize', 10, 'FontName', 'Arial');
ylabel('y_3[k]', 'FontSize', 10, 'FontName', 'Arial');
grid on;
ax = gca; ax.GridLineStyle = '--'; ax.GridAlpha = 0.5; ax.FontSize = 10;

% Exportar gráfico de resposta ao impulso
exportgraphics(fig1, '../../images/aula9_iir_stability_comparison.png', 'Resolution', 200);
close(fig1);

% --- PLOT 2: Mapas de Polos e Zeros ---
fig2 = figure('Position', [100, 100, 850, 320]);

plot_zplane(b1, a1, 'Estável (Polo em 0.8)', 1);
plot_zplane(b2, a2, 'Marginal (Polo em 1.0)', 2);
plot_zplane(b3, a3, 'Instável (Polo em 1.05)', 3);

% Exportar mapas de polos e zeros
exportgraphics(fig2, '../../images/aula9_iir_poles_zeros.png', 'Resolution', 200);
close(fig2);

disp('Gráficos de estabilidade e plano Z gerados com sucesso!');

% --- Função Local para o Plano Z ---
function plot_zplane(b, a, title_str, subplot_idx)
    subplot(1, 3, subplot_idx);
    hold on;
    % Círculo Unitário
    theta = linspace(0, 2*pi, 100);
    fill(cos(theta), sin(theta), [0.97, 0.97, 0.97], 'EdgeColor', [0.8, 0.8, 0.8], 'LineWidth', 1.0);
    plot([-1.5, 1.5], [0, 0], 'k--', 'LineWidth', 0.8);
    plot([0, 0], [-1.5, 1.5], 'k--', 'LineWidth', 0.8);
    % Polos e Zeros
    [z, p, ~] = tf2zp(b, a);
    plot(real(z), imag(z), 'o', 'Color', [0, 0.4470, 0.7410], 'LineWidth', 1.5, 'MarkerSize', 8);
    plot(real(p), imag(p), 'x', 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 2.0, 'MarkerSize', 10);
    title(title_str, 'FontSize', 10, 'FontWeight', 'bold', 'FontName', 'Arial');
    xlabel('Real', 'FontSize', 9); ylabel('Imag', 'FontSize', 9);
    grid on; box on;
    xlim([-1.5, 1.5]); ylim([-1.5, 1.5]);
    axis square;
    ax = gca; ax.GridLineStyle = ':'; ax.FontSize = 9;
end

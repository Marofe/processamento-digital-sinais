clc; clear all; close all;

% Parâmetros do sinal
fs = 1000;              % Frequência de amostragem (Hz)
t = 0:1/fs:1;           % Vetor de tempo (1 segundo)
f1 = 5;                 % Frequência da senóide fundamental (Hz)
f2 = 120;               % Frequência da interferência de alta frequência (Hz)

% Sinal limpo (senóide fundamental)
x_clean = sin(2*pi*f1*t);

% Sinal ruidoso (fundamental + interferência + ruído gaussiano)
rng(42);                % Define semente para reprodutibilidade do ruído
noise = 0.25 * randn(size(t));
x_noisy = x_clean + 0.4*cos(2*pi*f2*t) + noise;

% Ordens do filtro de média móvel (comprimento da janela P)
P1 = 5;
P2 = 21;
P3 = 81;

% Coeficientes dos filtros (b_i = 1/P)
b1 = ones(1, P1) / P1;
b2 = ones(1, P2) / P2;
b3 = ones(1, P3) / P3;

% Filtragem (saídas y[k])
y1 = filter(b1, 1, x_noisy);
y2 = filter(b2, 1, x_noisy);
y3 = filter(b3, 1, x_noisy);

% Geração do gráfico
figure('Position', [100, 100, 850, 480]);
plot(t, x_noisy, 'Color', [0.7, 0.7, 0.7], 'LineWidth', 1.0); hold on;
plot(t, y1, 'Color', [0.18, 0.77, 0.71], 'LineWidth', 1.5); % Verde/Ciano (#2ec4b6)
plot(t, y2, 'Color', [0.0, 0.47, 0.71], 'LineWidth', 2.0);  % Azul (#0077b6)
plot(t, y3, 'Color', [0.85, 0.02, 0.16], 'LineWidth', 2.0);  % Vermelho (#d90429)

title('Filtro de Média Móvel em Sinais Ruidosos', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Tempo (s)', 'FontSize', 10);
ylabel('Amplitude', 'FontSize', 10);
grid on;
ax = gca;
ax.GridLineStyle = '--';
ax.GridAlpha = 0.5;

legend('Sinal Ruidoso (Entrada)', ...
       ['Média Móvel (P = ' num2str(P1) ')'], ...
       ['Média Móvel (P = ' num2str(P2) ')'], ...
       ['Média Móvel (P = ' num2str(P3) ')'], ...
       'Location', 'southwest', 'FontSize', 9);

ylim([-2.0, 2.0]);
xlim([0, 1.0]);

% Exporta imagem para a pasta de imagens
exportgraphics(gcf, '../../images/aula8_moving_average.png', 'Resolution', 200);

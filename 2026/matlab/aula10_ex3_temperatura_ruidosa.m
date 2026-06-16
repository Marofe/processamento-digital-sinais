clc; clear all; close all;

% 1. Parâmetros da Simulação (Exemplo: Sensor de Temperatura)
N = 100;                  % Instantes de tempo (amostras)
Q = 0.02;                 % Variância do ruído de processo (variação real da temperatura)
R = 2.0;                  % Variância do ruído de medição (precisão do sensor de temperatura)

% 2. Geração dos Sinais Reais (Modelo de Espaço de Estados)
rng(5);                   % Semente para reprodutibilidade
w = sqrt(Q) * randn(N, 1); % Ruído de processo
v = sqrt(R) * randn(N, 1); % Ruído de medição

x = zeros(N, 1);
y = zeros(N, 1);

% Temperatura real inicial: 25 °C
x(1) = 25.0;
y(1) = x(1) + v(1);

for k = 2:N
    x(k) = x(k-1) + w(k);  % Deriva térmica lenta
    y(k) = x(k) + v(k);    % Medição corrompida por ruído
end

% 3. Plotagem dos Resultados (Sem o filtro de Kalman)
fig = figure('Position', [100, 100, 850, 380]);

plot(1:N, x, 'k', 'LineWidth', 1.8); hold on;
plot(1:N, y, 'x', 'Color', [0.8500, 0.3250, 0.0980], 'MarkerSize', 5);
title('Sensor de Temperatura com Ruído de Medição', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Arial');
xlabel('Amostra K', 'FontSize', 10, 'FontName', 'Arial');
ylabel('Temperatura (°C)', 'FontSize', 10, 'FontName', 'Arial');
legend('Temperatura Real (x)', 'Medição Ruidosa (Sensor)', 'Location', 'best');
grid on; ax = gca; ax.GridLineStyle = '--'; ax.GridAlpha = 0.5; ax.FontSize = 10;
box on;

exportgraphics(fig, '../../images/aula10_temperatura_ruidosa.png', 'Resolution', 200);
close(fig);
disp('Gráfico da temperatura real e ruidosa gerado com sucesso!');

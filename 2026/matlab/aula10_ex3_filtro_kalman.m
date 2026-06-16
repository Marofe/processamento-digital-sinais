clc; clear all; close all;

% 1. Parâmetros da Simulação (Exemplo: Sensor de Temperatura)
N = 100;                  % Instantes de tempo (amostras)
Q = 0.02;                 % Variância do ruído de processo (variação real da temperatura)
R = 2.0;                  % Variância do ruído de medição (precisão do sensor de temperatura)

% 2. Geração dos Sinais Reais (Modelo de Espaço de Estados)
% Estado real x_k: temperatura real
% Medição y_k: leitura do sensor ruidoso
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

% 3. Implementação do Filtro de Kalman Discreto (Escalar)
x_est = zeros(N, 1);      % Estimativa da temperatura \hat{x}_{k|k}
P_est = zeros(N, 1);      % Covariância do erro P_{k|k}
K_gain = zeros(N, 1);     % Ganho de Kalman K_k

% Condições iniciais do filtro (Inicia com estimativa errada de 15 °C)
x_est(1) = 15.0;          
P_est(1) = 25.0;          % Alta covariância inicial (incerteza alta)

for k = 2:N
    % --- ETAPA 1: PREDIÇÃO ---
    x_pred = x_est(k-1);         % \hat{x}_{k|k-1} = \hat{x}_{k-1|k-1}
    P_pred = P_est(k-1) + Q;     % P_{k|k-1} = P_{k-1|k-1} + Q
    
    % --- ETAPA 2: CORREÇÃO ---
    % Ganho de Kalman K_k
    K_gain(k) = P_pred / (P_pred + R);
    
    % Atualização da estimativa de estado com a leitura do sensor y(k)
    x_est(k) = x_pred + K_gain(k) * (y(k) - x_pred);
    
    % Atualização da covariância do erro
    P_est(k) = (1 - K_gain(k)) * P_pred;
end

% 4. Plotagem dos Resultados
fig = figure('Position', [100, 100, 850, 380]);

% Rastreamento da Temperatura (Medição vs Filtro)
plot(1:N, x, 'k', 'LineWidth', 1.8); hold on;
plot(1:N, y, 'x', 'Color', [0.8500, 0.3250, 0.0980], 'MarkerSize', 5);
plot(1:N, x_est, 'Color', [0, 0.4470, 0.7410], 'LineWidth', 1.8);
title('Filtragem de Sensor de Temperatura com Filtro de Kalman', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Arial');
xlabel('Amostra K', 'FontSize', 10, 'FontName', 'Arial');
ylabel('Temperatura (°C)', 'FontSize', 10, 'FontName', 'Arial');
legend('Temperatura Real (x)', 'Medição Ruidosa (Sensor)', 'Estimativa de Kalman (\hat{x})', 'Location', 'best');
grid on; ax = gca; ax.GridLineStyle = '--'; ax.GridAlpha = 0.5; ax.FontSize = 10;
box on;

exportgraphics(fig, '../../images/aula10_filtro_kalman.png', 'Resolution', 200);
close(fig);
disp('Gráfico do Filtro de Kalman para Sensor de Temperatura gerado com sucesso!');

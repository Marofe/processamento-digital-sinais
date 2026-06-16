clc; clear all; close all;

% 1. Parâmetros do Sinal
fs = 500;                 % Frequência de amostragem (Hz)
t = 0 : 1/fs : 1 - 1/fs;  % Vetor de tempo (1 segundo)
N = length(t);

% Sinal desejado s[n] (soma de senoides de baixa frequência)
s = sin(2 * pi * 4 * t) + 0.5 * sin(2 * pi * 10 * t);

% Ruído branco v[n] com desvio padrão sigma_v
sigma_v = 0.6;
rng(42);                  % Semente para reprodutibilidade
v = sigma_v * randn(size(t));

% Sinal ruidoso x[n]
x = s + v;

% 2. Projeto do Filtro de Wiener FIR
M = 20;                   % Ordem do filtro (número de coeficientes = M + 1)

% Estimação da autocorrelação do sinal limpo s[n]
[r_s, lags] = xcorr(s, M, 'biased');
r_ss = r_s(M+1:end).';    % Vetor de autocorrelação [R_ss(0), ..., R_ss(M)]

% Matriz de autocorrelação Toeplitz de s[n]
R_ss = toeplitz(r_ss);

% Matriz de autocorrelação do sinal ruidoso x[n]
R_xx = R_ss + (sigma_v^2) * eye(M + 1);

% Vetor de correlação cruzada r_xs (como v é independente, r_xs = r_ss)
r_xs = r_ss;

% Resolver o sistema Wiener-Hopf: R_xx * h = r_xs
h = R_xx \ r_xs;

% 3. Filtragem do Sinal Ruidoso
y = filter(h, 1, x);

% Compensar o atraso de grupo do filtro (aprox M/2 amostras)
delay = round(M/2);
y_aligned = [y(delay+1:end), zeros(1, delay)];

% 4. Plotagem dos Resultados
fig = figure('Position', [100, 100, 850, 580]);

subplot(3, 1, 1);
plot(t, s, 'k', 'LineWidth', 1.5);
title('Sinal Original Limpo s[n] (4 Hz + 10 Hz)', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Arial');
ylabel('Amplitude', 'FontSize', 9);
grid on; ax = gca; ax.GridLineStyle = '--'; ax.GridAlpha = 0.5;
ylim([-2.2, 2.2]);

subplot(3, 1, 2);
plot(t, x, 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 1.0);
title('Sinal Corrompido por Ruído Branco x[n] = s[n] + v[n]', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Arial');
ylabel('Amplitude', 'FontSize', 9);
grid on; ax = gca; ax.GridLineStyle = '--'; ax.GridAlpha = 0.5;
ylim([-2.2, 2.2]);

subplot(3, 1, 3);
plot(t, s, 'k--', 'LineWidth', 1.0); hold on;
plot(t, y_aligned, 'Color', [0, 0.4470, 0.7410], 'LineWidth', 1.5);
title('Saída do Filtro de Wiener FIR (Ordem M = 20, Compensado)', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Arial');
xlabel('Tempo (s)', 'FontSize', 10, 'FontName', 'Arial');
ylabel('Amplitude', 'FontSize', 9);
legend('Sinal Original', 'Sinal Filtrado', 'Location', 'southwest');
grid on; ax = gca; ax.GridLineStyle = '--'; ax.GridAlpha = 0.5;
ylim([-2.2, 2.2]);

exportgraphics(fig, '../../images/aula10_filtro_wiener.png', 'Resolution', 200);
close(fig);
disp('Gráfico do Filtro de Wiener gerado com sucesso!');

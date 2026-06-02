clc; clear all; close all;

% Parâmetros comuns
wc = 0.25 * pi; % Frequência de corte
w_ideal = [0, wc, wc, pi];
mag_ideal = [1, 1, 0, 0];

% ================= CÁLCULO PARA M = 20 =================
M_20 = 20; alpha_20 = M_20 / 2;
n_20 = 0:M_20; g_20 = zeros(size(n_20));
for i = 1:length(n_20)
    val = n_20(i);
    if val == alpha_20, g_20(i) = wc / pi;
    else, g_20(i) = sin(wc * (val - alpha_20)) / (pi * (val - alpha_20)); end
end
[H_20, w] = freqz(g_20, 1, 1024);
mag_20 = abs(H_20);
phase_20 = unwrap(angle(H_20));

% ================= CÁLCULO PARA M = 30 =================
M_30 = 30; alpha_30 = M_30 / 2;
n_30 = 0:M_30; g_30 = zeros(size(n_30));
for i = 1:length(n_30)
    val = n_30(i);
    if val == alpha_30, g_30(i) = wc / pi;
    else, g_30(i) = sin(wc * (val - alpha_30)) / (pi * (val - alpha_30)); end
end
[H_30, ~] = freqz(g_30, 1, 1024);
mag_30 = abs(H_30);
phase_30 = unwrap(angle(H_30));

% ================= CÁLCULO PARA M = 40 =================
M_40 = 40; alpha_40 = M_40 / 2;
n_40 = 0:M_40; g_40 = zeros(size(n_40));
for i = 1:length(n_40)
    val = n_40(i);
    if val == alpha_40, g_40(i) = wc / pi;
    else, g_40(i) = sin(wc * (val - alpha_40)) / (pi * (val - alpha_40)); end
end
[H_40, ~] = freqz(g_40, 1, 1024);
mag_40 = abs(H_40);
phase_40 = unwrap(angle(H_40));

% ================= PLOT COMPARATIVO LADO A LADO =================
fig = figure('Position', [100, 100, 1100, 420], 'Visible', 'off');

% Cores padrão do MATLAB (R2014b em diante)
c1 = [0, 0.4470, 0.7410];      % Azul
c2 = [0.8500, 0.3250, 0.0980];  % Laranja/Vermelho
c3 = [0.9290, 0.6940, 0.1250];  % Amarelo/Dourado

% 1. Painel da Esquerda: Magnitude
subplot(1, 2, 1);
plot(w, mag_20, 'LineWidth', 1.8, 'Color', c1);
hold on;
plot(w, mag_30, 'LineWidth', 1.8, 'Color', c2);
plot(w, mag_40, 'LineWidth', 1.8, 'Color', c3);
plot(w_ideal, mag_ideal, 'k--', 'LineWidth', 1.5); % Filtro Ideal
grid on;
ax1 = gca;
ax1.GridLineStyle = '--'; ax1.GridAlpha = 0.5; ax1.FontSize = 11; ax1.FontName = 'Arial'; ax1.Box = 'on';
ax1.XTick = [0, 0.25*pi, 0.5*pi, 0.75*pi, pi];
ax1.XTickLabel = {'0', '0.25\pi (\omega_c)', '0.5\pi', '0.75\pi', '\pi'};

title('Resposta em Magnitude |G(e^{j\omega})|', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Arial');
xlabel('Frequência Angular \omega (rad/amostra)', 'FontSize', 11, 'FontName', 'Arial');
ylabel('Magnitude', 'FontSize', 11, 'FontName', 'Arial');
ylim([-0.1, 1.2]); xlim([0, pi]);
legend('M = 20', 'M = 30', 'M = 40', 'Filtro Ideal', 'Location', 'northeast');

% 2. Painel da Direita: Fase
subplot(1, 2, 2);
plot(w, phase_20, 'LineWidth', 1.8, 'Color', c1);
hold on;
plot(w, phase_30, 'LineWidth', 1.8, 'Color', c2);
plot(w, phase_40, 'LineWidth', 1.8, 'Color', c3);
grid on;
ax2 = gca;
ax2.GridLineStyle = '--'; ax2.GridAlpha = 0.5; ax2.FontSize = 11; ax2.FontName = 'Arial'; ax2.Box = 'on';
ax2.XTick = [0, 0.25*pi, 0.5*pi, 0.75*pi, pi];
ax2.XTickLabel = {'0', '0.25\pi', '0.5\pi', '0.75\pi', '\pi'};

title('Resposta de Fase \angle G(e^{j\omega})', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Arial');
xlabel('Frequência Angular \omega (rad/amostra)', 'FontSize', 11, 'FontName', 'Arial');
ylabel('Fase (rad)', 'FontSize', 11, 'FontName', 'Arial');
xlim([0, pi]);
legend('M = 20', 'M = 30', 'M = 40', 'Location', 'southwest');

% Salvar no scratch
output_path = 'C:\Users\engma\.gemini\antigravity-cli\brain\aaf32d08-cb6b-42ba-874d-38315eaacaae\scratch\sinc_fourier_response_comparison.svg';
print(fig, output_path, '-dsvg');
close(fig);

disp('Gráfico comparativo (MATLAB default colors) gerado com sucesso!');

clc; clear all; close all;

% Parâmetros comuns
M = 30;
alpha = M / 2; % 15 amostras de atraso
wc = 0.25 * pi; % Frequência de corte

% Filtro ideal para referência
w_ideal = [0, wc, wc, pi];
mag_ideal = [1, 1, 0, 0];

% 1. Filtro com Janela Retangular (Truncamento Simples)
n = 0:M;
g_rect = zeros(size(n));
for i = 1:length(n)
    val = n(i);
    if val == alpha
        g_rect(i) = wc / pi;
    else
        g_rect(i) = sin(wc * (val - alpha)) / (pi * (val - alpha));
    end
end

% 2. Filtro com Janela de Hamming
w_ham = hamming(M + 1)';
g_hamming = g_rect .* w_ham;

% Resposta em frequência
[H_rect, w] = freqz(g_rect, 1, 1024);
[H_hamming, ~] = freqz(g_hamming, 1, 1024);

mag_rect = abs(H_rect);
mag_hamming = abs(H_hamming);

phase_rect = unwrap(angle(H_rect));
phase_hamming = unwrap(angle(H_hamming));

% ================= PLOT COMPARATIVO =================
fig = figure('Position', [100, 100, 1100, 420], 'Visible', 'off');

% Cores padrão do MATLAB
c1 = [0, 0.4470, 0.7410];      % Azul
c2 = [0.8500, 0.3250, 0.0980];  % Laranja/Vermelho

% 1. Magnitude
subplot(1, 2, 1);
plot(w, mag_rect, 'LineWidth', 1.8, 'Color', c1);
hold on;
plot(w, mag_hamming, 'LineWidth', 1.8, 'Color', c2);
plot(w_ideal, mag_ideal, 'k--', 'LineWidth', 1.5);
grid on;
ax1 = gca;
ax1.GridLineStyle = '--'; ax1.GridAlpha = 0.5; ax1.FontSize = 11; ax1.FontName = 'Arial'; ax1.Box = 'on';
ax1.XTick = [0, 0.25*pi, 0.5*pi, 0.75*pi, pi];
ax1.XTickLabel = {'0', '0.25\pi (\omega_c)', '0.5\pi', '0.75\pi', '\pi'};

title('Resposta em Magnitude |G(e^{j\omega})|', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Arial');
xlabel('Frequência Angular \omega (rad/amostra)', 'FontSize', 11, 'FontName', 'Arial');
ylabel('Magnitude', 'FontSize', 11, 'FontName', 'Arial');
ylim([-0.1, 1.2]); xlim([0, pi]);
legend('Janela Retangular', 'Janela de Hamming', 'Filtro Ideal', 'Location', 'northeast');

% 2. Fase
subplot(1, 2, 2);
plot(w, phase_rect, 'LineWidth', 2.2, 'Color', c1);
hold on;
plot(w, phase_hamming, '--', 'LineWidth', 1.8, 'Color', c2); % Linha tracejada para mostrar sobreposição
grid on;
ax2 = gca;
ax2.GridLineStyle = '--'; ax2.GridAlpha = 0.5; ax2.FontSize = 11; ax2.FontName = 'Arial'; ax2.Box = 'on';
ax2.XTick = [0, 0.25*pi, 0.5*pi, 0.75*pi, pi];
ax2.XTickLabel = {'0', '0.25\pi', '0.5\pi', '0.75\pi', '\pi'};

title('Resposta de Fase \angle G(e^{j\omega})', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Arial');
xlabel('Frequência Angular \omega (rad/amostra)', 'FontSize', 11, 'FontName', 'Arial');
ylabel('Fase (rad)', 'FontSize', 11, 'FontName', 'Arial');
xlim([0, pi]);
legend('Janela Retangular', 'Janela de Hamming', 'Location', 'southwest');

% Salvar em pasta ASCII segura
output_path = 'C:\Users\engma\.gemini\antigravity-cli\brain\aaf32d08-cb6b-42ba-874d-38315eaacaae\scratch\sinc_fourier_hamming_comparison.svg';
print(fig, output_path, '-dsvg');
close(fig);

disp('Gráfico comparativo Hamming vs Retangular gerado com sucesso!');

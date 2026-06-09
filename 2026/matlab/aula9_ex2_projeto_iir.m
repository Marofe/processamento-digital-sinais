clc; clear all; close all;

% Especificações do Filtro
fs = 1000;             % Frequência de amostragem (Hz)
fp = 100;              % Limite da banda passante (Hz)
fst = 150;             % Limite da banda de rejeição (Hz)
Rp = 1;                % Ondulação máxima na banda passante (dB)
Rs = 40;               % Atenuação mínima na banda de rejeição (dB)

% Frequências normalizadas de Nyquist (entre 0 e 1)
wp = fp / (fs/2);
ws = fst / (fs/2);

% 1. Determinação da ordem e frequência natural para cada filtro
[n_butt, wn_butt] = buttord(wp, ws, Rp, Rs);
[n_cheb1, wn_cheb1] = cheb1ord(wp, ws, Rp, Rs);
[n_cheb2, wn_cheb2] = cheb2ord(wp, ws, Rp, Rs);
[n_ellip, wn_ellip] = ellipord(wp, ws, Rp, Rs);

% Exibir ordens calculadas no console
fprintf('Ordens dos filtros calculadas para as especificações:\n');
fprintf('Butterworth: %d\n', n_butt);
fprintf('Chebyshev I: %d\n', n_cheb1);
fprintf('Chebyshev II: %d\n', n_cheb2);
fprintf('Elíptico: %d\n', n_ellip);

% 2. Projeto dos filtros (coeficientes da função de transferência)
[b_butt, a_butt] = butter(n_butt, wn_butt);
[b_cheb1, a_cheb1] = cheby1(n_cheb1, Rp, wn_cheb1);
[b_cheb2, a_cheb2] = cheby2(n_cheb2, Rs, wn_cheb2);
[b_ellip, a_ellip] = ellip(n_ellip, Rp, Rs, wn_ellip);

% 3. Resposta em frequência
N_pts = 2048;
[H_butt, f]   = freqz(b_butt, a_butt, N_pts, fs);
[H_cheb1, ~]  = freqz(b_cheb1, a_cheb1, N_pts, fs);
[H_cheb2, ~]  = freqz(b_cheb2, a_cheb2, N_pts, fs);
[H_ellip, ~]  = freqz(b_ellip, a_ellip, N_pts, fs);

% Magnitudes em dB
mag_butt   = 20 * log10(abs(H_butt) + 1e-10);
mag_cheb1  = 20 * log10(abs(H_cheb1) + 1e-10);
mag_cheb2  = 20 * log10(abs(H_cheb2) + 1e-10);
mag_ellip  = 20 * log10(abs(H_ellip) + 1e-10);

% --- GRÁFICO 1: Comparação Geral de Magnitude e Zoom na Banda Passante ---
fig1 = figure('Position', [100, 100, 950, 520]);

% Magnitude Completa (dB)
subplot(1, 2, 1);
plot(f, mag_butt, 'Color', [0, 0.4470, 0.7410], 'LineWidth', 2.0); hold on;
plot(f, mag_cheb1, 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 2.0);
plot(f, mag_cheb2, 'Color', [0.9290, 0.6940, 0.1250], 'LineWidth', 2.0);
plot(f, mag_ellip, 'Color', [0.4980, 0.1840, 0.5560], 'LineWidth', 2.0);

% Detalhes estéticos
grid on; ax = gca; ax.GridLineStyle = '--'; ax.GridAlpha = 0.5; ax.FontSize = 10;
ax.FontName = 'Arial'; box on;
xlim([0, 300]); ylim([-80, 5]);
xlabel('Frequência (Hz)', 'FontSize', 11, 'FontName', 'Arial');
ylabel('Magnitude (dB)', 'FontSize', 11, 'FontName', 'Arial');
title('Resposta em Frequência (Comparação)', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Arial');

legend({['Butterworth (Ordem ' num2str(n_butt) ')'], ...
        ['Chebyshev I (Ordem ' num2str(n_cheb1) ')'], ...
        ['Chebyshev II (Ordem ' num2str(n_cheb2) ')'], ...
        ['Elíptico (Ordem ' num2str(n_ellip) ')']}, ...
        'Location', 'southwest', 'FontSize', 9);

% Zoom na Banda Passante
subplot(1, 2, 2);
plot(f, mag_butt, 'Color', [0, 0.4470, 0.7410], 'LineWidth', 2.0); hold on;
plot(f, mag_cheb1, 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 2.0);
plot(f, mag_cheb2, 'Color', [0.9290, 0.6940, 0.1250], 'LineWidth', 2.0);
plot(f, mag_ellip, 'Color', [0.4980, 0.1840, 0.5560], 'LineWidth', 2.0);

grid on; ax = gca; ax.GridLineStyle = '--'; ax.GridAlpha = 0.5; ax.FontSize = 10;
ax.FontName = 'Arial'; box on;
xlim([0, 110]); ylim([-2, 0.5]);
xlabel('Frequência (Hz)', 'FontSize', 11, 'FontName', 'Arial');
ylabel('Magnitude (dB)', 'FontSize', 11, 'FontName', 'Arial');
title('Zoom na Banda Passante (Ondulações)', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Arial');

% Exportar imagem
exportgraphics(fig1, '../../images/aula9_iir_comparison_types.png', 'Resolution', 200);
close(fig1);

% --- GRÁFICO 2: Polos e Zeros Comparação ---
fig2 = figure('Position', [100, 100, 950, 260]);

plot_zplane(b_butt, a_butt, 'Butterworth Poles/Zeros', 1);
plot_zplane(b_cheb1, a_cheb1, 'Chebyshev I Poles/Zeros', 2);
plot_zplane(b_cheb2, a_cheb2, 'Chebyshev II Poles/Zeros', 3);
plot_zplane(b_ellip, a_ellip, 'Elliptic Poles/Zeros', 4);

% Exportar imagem
exportgraphics(fig2, '../../images/aula9_iir_comparison_poles.png', 'Resolution', 200);
close(fig2);

disp('Gráficos de comparação de tipos de filtros IIR gerados!');

% --- Função Local para o Plano Z ---
function plot_zplane(b, a, title_str, col_idx)
    subplot(1, 4, col_idx);
    hold on;
    theta = linspace(0, 2*pi, 100);
    fill(cos(theta), sin(theta), [0.97, 0.97, 0.97], 'EdgeColor', [0.8, 0.8, 0.8]);
    plot([-1.2, 1.2], [0, 0], 'k--', 'LineWidth', 0.6);
    plot([0, 0], [-1.2, 1.2], 'k--', 'LineWidth', 0.6);
    [z, p, ~] = tf2zp(b, a);
    plot(real(z), imag(z), 'o', 'Color', [0, 0.4470, 0.7410], 'LineWidth', 1.2, 'MarkerSize', 6);
    plot(real(p), imag(p), 'x', 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 1.5, 'MarkerSize', 8);
    title(title_str, 'FontSize', 9, 'FontWeight', 'bold', 'FontName', 'Arial');
    grid on; box on;
    xlim([-1.2, 1.2]); ylim([-1.2, 1.2]);
    axis square;
    ax = gca; ax.GridLineStyle = ':'; ax.FontSize = 8;
end

clc; clear all; close all;

% Frequency vector (linear for clear visualization of frequencies)
w = linspace(0.01, 15, 1000); % Start slightly above 0 to avoid log10(0)

% Cutoff frequency for highpass
wc = 5;

% Frequency response calculations
% Lowpass prototype G(s) = 1 / (s + 1)
glp = 1 ./ (1j * w + 1);

% Highpass filter H(s) = s / (s + wc)
ghp = (1j * w) ./ (1j * w + wc);

% Plotting
fig = figure('Position', [100, 100, 800, 600]);

% Magnitude Plot (dB)
subplot(2,1,1);
plot(w, 20*log10(abs(glp)), 'LineWidth', 2.5, 'Color', [0, 0.4470, 0.7410]); hold on;
plot(w, 20*log10(abs(ghp)), 'LineWidth', 2.5, 'Color', [0.8500, 0.3250, 0.0980]);
grid on;
title('Resposta em Magnitude (dB) - Conversão Passa-Baixas para Passa-Altas', 'FontSize', 14);
ylabel('Magnitude (dB)', 'FontSize', 11);
xlabel('Frequência \omega (rad/s)', 'FontSize', 11);
legend('Protótipo Passa-Baixas (\omega_c = 1 rad/s)', 'Passa-Altas Obtido (\omega_c = 5 rad/s)', 'FontSize', 10);
ylim([-30, 2]);
xlim([0, 15]);

% Cutoff frequency indicators (at -3 dB) with HandleVisibility off
y_cut = -3;
yline(y_cut, '--k', 'Limiar de -3 dB', 'LabelHorizontalAlignment', 'left', 'FontSize', 9, 'HandleVisibility', 'off');
plot([1, 1], [-30, y_cut], ':b', 'LineWidth', 1.2, 'HandleVisibility', 'off');
plot([wc, wc], [-30, y_cut], ':r', 'LineWidth', 1.2, 'HandleVisibility', 'off');
plot(1, y_cut, 'o', 'MarkerFaceColor', 'b', 'MarkerSize', 6, 'HandleVisibility', 'off');
plot(wc, y_cut, 'o', 'MarkerFaceColor', 'r', 'MarkerSize', 6, 'HandleVisibility', 'off');

% Phase Plot (Degrees)
subplot(2,1,2);
plot(w, (180/pi)*angle(glp), 'LineWidth', 2.5, 'Color', [0, 0.4470, 0.7410]); hold on;
plot(w, (180/pi)*angle(ghp), 'LineWidth', 2.5, 'Color', [0.8500, 0.3250, 0.0980]);
grid on;
title('Resposta de Fase', 'FontSize', 14);
ylabel('Fase (graus)', 'FontSize', 11);
xlabel('Frequência \omega (rad/s)', 'FontSize', 11);
legend('Protótipo Passa-Baixas (\omega_c = 1 rad/s)', 'Passa-Altas Obtido (\omega_c = 5 rad/s)', 'FontSize', 10);
ylim([-95, 95]);
xlim([0, 15]);

% Phase indicators at cutoff frequencies with HandleVisibility off
plot([1, 1], [-95, -45], ':b', 'LineWidth', 1.2, 'HandleVisibility', 'off');
plot([wc, wc], [-95, 45], ':r', 'LineWidth', 1.2, 'HandleVisibility', 'off');
plot(1, -45, 'o', 'MarkerFaceColor', 'b', 'MarkerSize', 6, 'HandleVisibility', 'off');
plot(wc, 45, 'o', 'MarkerFaceColor', 'r', 'MarkerSize', 6, 'HandleVisibility', 'off');

saveas(fig, '../../images/resposta_filtro_passa_altas.png');
close(fig);

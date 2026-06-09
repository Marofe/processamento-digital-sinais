clc; clear all; close all;

% Frequency vector (linear for clear visualization of low frequencies 1 and 5)
w = linspace(0.01, 15, 1000); % Start slightly above 0 to avoid log10(0) issues

% Cutoff frequencies
wc1 = 1;
wc5 = 5;

% Frequency response calculations
% G(s) = wc / (s + wc) => G(jw) = wc / (jw + wc)
h1 = wc1 ./ (1j * w + wc1);
h5 = wc5 ./ (1j * w + wc5);

% Plotting
fig = figure('Position', [100, 100, 800, 600]);

% Magnitude Plot (dB)
subplot(2,1,1);
plot(w, 20*log10(abs(h1)), 'LineWidth', 2.5, 'Color', [0, 0.4470, 0.7410]); hold on;
plot(w, 20*log10(abs(h5)), 'LineWidth', 2.5, 'Color', [0.8500, 0.3250, 0.0980]);
grid on;
title('Resposta em Magnitude (dB) de Filtros de 1ª Ordem', 'FontSize', 14);
ylabel('Magnitude (dB)', 'FontSize', 11);
xlabel('Frequência \omega (rad/s)', 'FontSize', 11);
legend('\omega_c = 1 rad/s (Protótipo)', '\omega_c = 5 rad/s', 'FontSize', 10);
ylim([-30, 2]);
xlim([0, 15]);

% Cutoff frequency indicators (at -3 dB) with HandleVisibility off
y_cut = -3;
yline(y_cut, '--k', 'Limiar de -3 dB', 'LabelHorizontalAlignment', 'left', 'FontSize', 9, 'HandleVisibility', 'off');
plot([wc1, wc1], [-30, y_cut], ':b', 'LineWidth', 1.2, 'HandleVisibility', 'off');
plot([wc5, wc5], [-30, y_cut], ':r', 'LineWidth', 1.2, 'HandleVisibility', 'off');
plot(wc1, y_cut, 'o', 'MarkerFaceColor', 'b', 'MarkerSize', 6, 'HandleVisibility', 'off');
plot(wc5, y_cut, 'o', 'MarkerFaceColor', 'r', 'MarkerSize', 6, 'HandleVisibility', 'off');

% Phase Plot (Degrees)
subplot(2,1,2);
plot(w, (180/pi)*angle(h1), 'LineWidth', 2.5, 'Color', [0, 0.4470, 0.7410]); hold on;
plot(w, (180/pi)*angle(h5), 'LineWidth', 2.5, 'Color', [0.8500, 0.3250, 0.0980]);
grid on;
title('Resposta de Fase', 'FontSize', 14);
ylabel('Fase (graus)', 'FontSize', 11);
xlabel('Frequência \omega (rad/s)', 'FontSize', 11);
legend('\omega_c = 1 rad/s (Protótipo)', '\omega_c = 5 rad/s', 'FontSize', 10);
ylim([-90, 5]);
xlim([0, 15]);

% Phase indicators at cutoff frequency (-45 degrees) with HandleVisibility off
yline(-45, '--k', '-45^{\circ}', 'LabelHorizontalAlignment', 'left', 'FontSize', 9, 'HandleVisibility', 'off');
plot([wc1, wc1], [-90, -45], ':b', 'LineWidth', 1.2, 'HandleVisibility', 'off');
plot([wc5, wc5], [-90, -45], ':r', 'LineWidth', 1.2, 'HandleVisibility', 'off');
plot(wc1, -45, 'o', 'MarkerFaceColor', 'b', 'MarkerSize', 6, 'HandleVisibility', 'off');
plot(wc5, -45, 'o', 'MarkerFaceColor', 'r', 'MarkerSize', 6, 'HandleVisibility', 'off');

saveas(fig, '../../images/resposta_filtro_prototipo.png');
close(fig);

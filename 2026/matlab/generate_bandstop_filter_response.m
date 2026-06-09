clc; clear all; close all;

% Frequency vector
w = linspace(0.01, 15, 1000);

% Cutoff frequencies
wl = 2;
wh = 8;
W = wh - wl;
w0 = sqrt(wl * wh);

% Frequency response of prototype lowpass G(s) = 1 / (s + 1)
glp = 1 ./ (1j * w + 1);

% Frequency response of bandstop H(s) = (s^2 + w0^2) / (s^2 + sW + w0^2)
s = 1j * w;
gbs = (s.^2 + w0^2) ./ (s.^2 + s * W + w0^2);

% Plotting
fig = figure('Position', [100, 100, 800, 600]);

% Magnitude Plot (dB)
subplot(2,1,1);
plot(w, 20*log10(abs(glp)), 'LineWidth', 2.5, 'Color', [0, 0.4470, 0.7410]); hold on;
plot(w, 20*log10(abs(gbs)), 'LineWidth', 2.5, 'Color', [0.8500, 0.3250, 0.0980]);
grid on;
title('Resposta em Magnitude (dB) - Conversão Passa-Baixas para Rejeita-Faixa', 'FontSize', 14);
ylabel('Magnitude (dB)', 'FontSize', 11);
xlabel('Frequência \omega (rad/s)', 'FontSize', 11);
legend('Protótipo Passa-Baixas', 'Rejeita-Faixa Obtido (\omega_l=2, \omega_h=8)', 'FontSize', 10);
ylim([-60, 2]);
xlim([0, 15]);

% Cutoff frequency indicators (at -3 dB) with HandleVisibility off
y_cut = -3;
yline(y_cut, '--k', 'Limiar de -3 dB', 'LabelHorizontalAlignment', 'left', 'FontSize', 9, 'HandleVisibility', 'off');
plot([wl, wl], [-60, y_cut], ':k', 'LineWidth', 1.2, 'HandleVisibility', 'off');
plot([wh, wh], [-60, y_cut], ':k', 'LineWidth', 1.2, 'HandleVisibility', 'off');
plot([w0, w0], [-60, -60], '--r', 'LineWidth', 1.2, 'HandleVisibility', 'off');
plot(wl, y_cut, 'o', 'MarkerFaceColor', 'r', 'MarkerSize', 6, 'HandleVisibility', 'off');
plot(wh, y_cut, 'o', 'MarkerFaceColor', 'r', 'MarkerSize', 6, 'HandleVisibility', 'off');
text(w0, -45, '\omega_0 = 4 rad/s (Rejeição Máxima)', 'HorizontalAlignment', 'left', 'Color', 'r', 'FontSize', 10);
text(wl, -55, '\omega_l = 2', 'HorizontalAlignment', 'center', 'FontSize', 10);
text(wh, -55, '\omega_h = 8', 'HorizontalAlignment', 'center', 'FontSize', 10);

% Phase Plot (Degrees)
subplot(2,1,2);
plot(w, (180/pi)*angle(glp), 'LineWidth', 2.5, 'Color', [0, 0.4470, 0.7410]); hold on;
plot(w, (180/pi)*angle(gbs), 'LineWidth', 2.5, 'Color', [0.8500, 0.3250, 0.0980]);
grid on;
title('Resposta de Fase', 'FontSize', 14);
ylabel('Fase (graus)', 'FontSize', 11);
xlabel('Frequência \omega (rad/s)', 'FontSize', 11);
legend('Protótipo Passa-Baixas', 'Rejeita-Faixa Obtido', 'FontSize', 10);
ylim([-95, 95]);
xlim([0, 15]);

% Phase indicators at cutoff frequencies with HandleVisibility off
plot([wl, wl], [-95, -45], ':k', 'LineWidth', 1.2, 'HandleVisibility', 'off');
plot([wh, wh], [-95, 45], ':k', 'LineWidth', 1.2, 'HandleVisibility', 'off');
plot([w0, w0], [-95, 95], '--r', 'LineWidth', 1.2, 'HandleVisibility', 'off');
plot(wl, -45, 'o', 'MarkerFaceColor', 'r', 'MarkerSize', 6, 'HandleVisibility', 'off');
plot(wh, 45, 'o', 'MarkerFaceColor', 'r', 'MarkerSize', 6, 'HandleVisibility', 'off');

saveas(fig, '../../images/resposta_filtro_rejeita_faixa.png');
close(fig);

clc; clear all; close all;

% Specifications
N = 5;            % Order
Wc = 1000;        % Cutoff frequency (rad/s)
Rp = 1;           % Passband ripple in dB
Rs = 40;          % Stopband attenuation in dB
w = linspace(0, 3000, 2000); % Frequency vector in rad/s

% 1. Butterworth
[b_but, a_but] = butter(N, Wc, 's');
h_but = freqs(b_but, a_but, w);

% 2. Chebyshev Type I
[b_c1, a_c1] = cheby1(N, Rp, Wc, 's');
h_c1 = freqs(b_c1, a_c1, w);

% 3. Chebyshev Type II
[b_c2, a_c2] = cheby2(N, Rs, Wc, 's');
h_c2 = freqs(b_c2, a_c2, w);

% 4. Elliptic
[b_el, a_el] = ellip(N, Rp, Rs, Wc, 's');
h_el = freqs(b_el, a_el, w);

% We will generate figures with subplots (1: Magnitude in dB, 2: Phase in degrees)

% Figure 1: Butterworth
fig1 = figure('Position', [100, 100, 800, 600]);
subplot(2,1,1);
plot(w, 20*log10(abs(h_but)), 'LineWidth', 2.5, 'Color', [0.0, 0.45, 0.74]);
grid on;
title('Filtro Butterworth Analógico (N=5)', 'FontSize', 14);
ylabel('Magnitude (dB)', 'FontSize', 11);
ylim([-60, 5]);
xlim([0, 3000]);
xline(Wc, '--r', '\omega_c = 1000 rad/s', 'LabelVerticalAlignment', 'bottom', 'LineWidth', 1.2, 'FontSize', 9);

subplot(2,1,2);
plot(w, (180/pi)*unwrap(angle(h_but)), 'LineWidth', 2.5, 'Color', [0.0, 0.45, 0.74]);
grid on;
xlabel('Frequência \omega (rad/s)', 'FontSize', 11);
ylabel('Fase (graus)', 'FontSize', 11);
xlim([0, 3000]);
xline(Wc, '--r', '\omega_c = 1000 rad/s', 'LabelVerticalAlignment', 'bottom', 'LineWidth', 1.2, 'FontSize', 9);
saveas(fig1, '../../images/resposta_butterworth.png');

% Figure 2: Chebyshev I
fig2 = figure('Position', [100, 100, 800, 600]);
subplot(2,1,1);
plot(w, 20*log10(abs(h_c1)), 'LineWidth', 2.5, 'Color', [0.85, 0.33, 0.1]);
grid on;
title('Filtro Chebyshev Tipo I Analógico (N=5)', 'FontSize', 14);
ylabel('Magnitude (dB)', 'FontSize', 11);
ylim([-60, 5]);
xlim([0, 3000]);
xline(Wc, '--r', '\omega_c = 1000 rad/s', 'LabelVerticalAlignment', 'bottom', 'LineWidth', 1.2, 'FontSize', 9);

subplot(2,1,2);
plot(w, (180/pi)*unwrap(angle(h_c1)), 'LineWidth', 2.5, 'Color', [0.85, 0.33, 0.1]);
grid on;
xlabel('Frequência \omega (rad/s)', 'FontSize', 11);
ylabel('Fase (graus)', 'FontSize', 11);
xlim([0, 3000]);
xline(Wc, '--r', '\omega_c = 1000 rad/s', 'LabelVerticalAlignment', 'bottom', 'LineWidth', 1.2, 'FontSize', 9);
saveas(fig2, '../../images/resposta_chebyshev1.png');

% Figure 3: Chebyshev II
fig3 = figure('Position', [100, 100, 800, 600]);
subplot(2,1,1);
plot(w, 20*log10(abs(h_c2)), 'LineWidth', 2.5, 'Color', [0.93, 0.69, 0.13]);
grid on;
title('Filtro Chebyshev Tipo II Analógico (N=5)', 'FontSize', 14);
ylabel('Magnitude (dB)', 'FontSize', 11);
ylim([-60, 5]);
xlim([0, 3000]);
xline(Wc, '--r', '\omega_c = 1000 rad/s', 'LabelVerticalAlignment', 'bottom', 'LineWidth', 1.2, 'FontSize', 9);

subplot(2,1,2);
plot(w, (180/pi)*unwrap(angle(h_c2)), 'LineWidth', 2.5, 'Color', [0.93, 0.69, 0.13]);
grid on;
xlabel('Frequência \omega (rad/s)', 'FontSize', 11);
ylabel('Fase (graus)', 'FontSize', 11);
xlim([0, 3000]);
xline(Wc, '--r', '\omega_c = 1000 rad/s', 'LabelVerticalAlignment', 'bottom', 'LineWidth', 1.2, 'FontSize', 9);
saveas(fig3, '../../images/resposta_chebyshev2.png');

% Figure 4: Elliptic
fig4 = figure('Position', [100, 100, 800, 600]);
subplot(2,1,1);
plot(w, 20*log10(abs(h_el)), 'LineWidth', 2.5, 'Color', [0.49, 0.18, 0.56]);
grid on;
title('Filtro Elíptico Analógico (N=5)', 'FontSize', 14);
ylabel('Magnitude (dB)', 'FontSize', 11);
ylim([-60, 5]);
xlim([0, 3000]);
xline(Wc, '--r', '\omega_c = 1000 rad/s', 'LabelVerticalAlignment', 'bottom', 'LineWidth', 1.2, 'FontSize', 9);

subplot(2,1,2);
plot(w, (180/pi)*unwrap(angle(h_el)), 'LineWidth', 2.5, 'Color', [0.49, 0.18, 0.56]);
grid on;
xlabel('Frequência \omega (rad/s)', 'FontSize', 11);
ylabel('Fase (graus)', 'FontSize', 11);
xlim([0, 3000]);
xline(Wc, '--r', '\omega_c = 1000 rad/s', 'LabelVerticalAlignment', 'bottom', 'LineWidth', 1.2, 'FontSize', 9);
saveas(fig4, '../../images/resposta_eliptico.png');

% Figure 5: Comparativa (Sobreposta)
fig5 = figure('Position', [100, 100, 800, 600]);
subplot(2,1,1);
plot(w, 20*log10(abs(h_but)), 'LineWidth', 2, 'Color', [0.0, 0.45, 0.74]); hold on;
plot(w, 20*log10(abs(h_c1)), 'LineWidth', 2, 'Color', [0.85, 0.33, 0.1]);
plot(w, 20*log10(abs(h_c2)), 'LineWidth', 2, 'Color', [0.93, 0.69, 0.13]);
plot(w, 20*log10(abs(h_el)), 'LineWidth', 2, 'Color', [0.49, 0.18, 0.56]);
grid on;
title('Comparação dos Filtros Analógicos (N=5)', 'FontSize', 14);
ylabel('Magnitude (dB)', 'FontSize', 11);
ylim([-60, 5]);
xlim([0, 3000]);
xline(Wc, '--r', '\omega_c = 1000 rad/s', 'LabelVerticalAlignment', 'bottom', 'LineWidth', 1.2, 'FontSize', 9);
legend('Butterworth', 'Chebyshev Tipo I', 'Chebyshev Tipo II', 'Elíptico', 'Location', 'southwest');

subplot(2,1,2);
plot(w, (180/pi)*unwrap(angle(h_but)), 'LineWidth', 2, 'Color', [0.0, 0.45, 0.74]); hold on;
plot(w, (180/pi)*unwrap(angle(h_c1)), 'LineWidth', 2, 'Color', [0.85, 0.33, 0.1]);
plot(w, (180/pi)*unwrap(angle(h_c2)), 'LineWidth', 2, 'Color', [0.93, 0.69, 0.13]);
plot(w, (180/pi)*unwrap(angle(h_el)), 'LineWidth', 2, 'Color', [0.49, 0.18, 0.56]);
grid on;
xlabel('Frequência \omega (rad/s)', 'FontSize', 11);
ylabel('Fase (graus)', 'FontSize', 11);
xlim([0, 3000]);
xline(Wc, '--r', '\omega_c = 1000 rad/s', 'LabelVerticalAlignment', 'bottom', 'LineWidth', 1.2, 'FontSize', 9);
legend('Butterworth', 'Chebyshev Tipo I', 'Chebyshev Tipo II', 'Elíptico', 'Location', 'southwest');
saveas(fig5, '../../images/resposta_comparativa.png');

close all;

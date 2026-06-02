clc; clear all; close all;

% Parâmetros comuns
wc = 0.25 * pi; % Frequência de corte
M = 30;         % Ordem do filtro (M = 30)
alpha = M / 2;  % Deslocamento (15 amostras)

% ================= 1. SINC TRUNCADA (VERMELHA, CENTRADA EM 0) =================
n1 = -20:20;
h_trunc = zeros(size(n1));
for i = 1:length(n1)
    val = n1(i);
    if abs(val) <= alpha
        if val == 0
            h_trunc(i) = wc / pi;
        else
            h_trunc(i) = sin(wc * val) / (pi * val);
        end
    else
        h_trunc(i) = 0; % Truncamento (fora de [-15, 15])
    end
end

fig1 = figure('Position', [100, 100, 800, 420], 'Visible', 'off');
s1 = stem(n1, h_trunc, 'filled', 'LineWidth', 2.0);
s1.Color = [0.8500, 0.1600, 0.1600]; % Vermelho
s1.MarkerSize = 6;
grid on;
ax1 = gca;
ax1.GridLineStyle = '--';
ax1.GridAlpha = 0.5;
ax1.FontSize = 12;
ax1.FontName = 'Arial';
ax1.Box = 'on';

title('Aproximação de Ordem M = 30 - Resposta Truncada g_{trunc}[k]', 'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Arial');
xlabel('Índice da Amostra (k)', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Amplitude g_{trunc}[k]', 'FontSize', 12, 'FontName', 'Arial');
xlim([-21, 21]);
ylim([-0.1, 0.3]);

% Linhas indicando os limites de truncamento
hold on;
plot([-15, -15], [-0.1, 0.3], 'k--', 'LineWidth', 1.2);
plot([15, 15], [-0.1, 0.3], 'k--', 'LineWidth', 1.2);
text(-14.5, 0.27, 'k = -15', 'Color', 'black', 'FontSize', 10, 'FontName', 'Arial');
text(11.5, 0.27, 'k = 15', 'Color', 'black', 'FontSize', 10, 'FontName', 'Arial');
hold off;

% Salvar no scratch
output_path1 = 'C:\Users\engma\.gemini\antigravity-cli\brain\aaf32d08-cb6b-42ba-874d-38315eaacaae\scratch\sinc_truncada.svg';
print(fig1, output_path1, '-dsvg');
close(fig1);


% ================= 2. SINC TRUNCADA E DESLOCADA (CAUSAL - VERDE BANDEIRA) =================
n2 = -5:35;
h_causal = zeros(size(n2));
for i = 1:length(n2)
    val = n2(i);
    % Deslocado de 15 amostras: o suporte agora é de 0 a 30
    if val >= 0 && val <= M
        if val == alpha
            h_causal(i) = wc / pi;
        else
            h_causal(i) = sin(wc * (val - alpha)) / (pi * (val - alpha));
        end
    else
        h_causal(i) = 0; % Nulo para k < 0 e k > 30 (causal e finito)
    end
end

fig2 = figure('Position', [100, 100, 800, 420], 'Visible', 'off');
s2 = stem(n2, h_causal, 'filled', 'LineWidth', 2.0);
s2.Color = [0.0, 0.5000, 0.0]; % Verde Bandeira solicitado
s2.MarkerSize = 6;
grid on;
ax2 = gca;
ax2.GridLineStyle = '--';
ax2.GridAlpha = 0.5;
ax2.FontSize = 12;
ax2.FontName = 'Arial';
ax2.Box = 'on';

title('Filtro Causal e Finito de Ordem M = 30 - Resposta ao Impulso g[k]', 'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Arial');
xlabel('Índice da Amostra (k)', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Amplitude g[k]', 'FontSize', 12, 'FontName', 'Arial');
xlim([-6, 36]);
ylim([-0.1, 0.3]);

% Evidenciar o deslocamento temporal:
hold on;
% 1. Linha vertical no antigo pico (k = 0)
plot([0, 0], [-0.1, 0.3], 'r--', 'LineWidth', 1.2);
text(-4.5, 0.27, 'k = 0 (Antigo Pico)', 'Color', 'r', 'FontSize', 10, 'FontName', 'Arial');

% 2. Linha vertical no novo pico (k = 15)
plot([15, 15], [-0.1, 0.3], 'b--', 'LineWidth', 1.2);
text(15.5, 0.27, 'k = 15 (Novo Pico)', 'Color', 'b', 'FontSize', 10, 'FontName', 'Arial');

% 3. Desenhar a seta indicadora de deslocamento (de 0 para 15 na altura y = 0.22)
% Corpo da seta
plot([0, 15], [0.22, 0.22], 'k-', 'LineWidth', 1.5);
% Ponta da seta no k = 15
plot([14.0, 15, 14.0], [0.225, 0.22, 0.215], 'k-', 'LineWidth', 1.5);
% Ponta da seta no k = 0 (seta dupla para mostrar a distância)
plot([1.0, 0, 1.0], [0.225, 0.22, 0.215], 'k-', 'LineWidth', 1.5);
% Texto explicativo da seta
text(7.5, 0.235, 'Atraso \alpha = M/2 = 15 amostras', 'HorizontalAlignment', 'center', 'FontSize', 10, 'FontWeight', 'bold', 'FontName', 'Arial', 'Color', [0.2, 0.2, 0.2]);

% 4. Destaque para região causal (k >= 0) em Verde Bandeira
plot([0, 30], [-0.05, -0.05], 'Color', [0.0, 0.5000, 0.0], 'LineWidth', 2.0);
text(15, -0.075, 'Região de Suporte Causal (0 ≤ k ≤ 30)', 'Color', [0.0, 0.4000, 0.0], 'FontSize', 9.5, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'FontName', 'Arial');

hold off;

% Salvar no scratch
output_path2 = 'C:\Users\engma\.gemini\antigravity-cli\brain\aaf32d08-cb6b-42ba-874d-38315eaacaae\scratch\sinc_deslocada.svg';
print(fig2, output_path2, '-dsvg');
close(fig2);

disp('Gráficos da sinc truncada e deslocada (verde bandeira) gerados com sucesso!');

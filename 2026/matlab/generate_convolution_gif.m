clc; clear all; close all;

% Configurar gerador de números aleatórios para reprodutibilidade
rng(42);

% Parâmetros do sinal
fs = 10;                % Frequência de amostragem
t = 0 : 1/fs : 10;      % Tempo de 0 a 10s (101 amostras)
Lx = length(t);

% Sinal de entrada: sin(2t) + cos(5t) + ruído gaussiano (randn)
x = sin(2*t) + cos(5*t) + randn(size(t));

% Parâmetros do filtro (sinc causal truncada de ordem M=30)
M = 30;
alpha = M / 2;          % Atraso de 15 amostras
wc = 0.25 * pi;         % Frequência de corte

n_filter = 0:M;
g = zeros(size(n_filter));
for i = 1:length(n_filter)
    val = n_filter(i);
    if val == alpha
        g(i) = wc / pi;
    else
        g(i) = sin(wc * (val - alpha)) / (pi * (val - alpha));
    end
end

% Convolução
y = conv(x, g);
Ly = length(y);

% Preparar figura de tamanho médio para um único plot
fig = figure('Position', [100, 100, 850, 450], 'Visible', 'off');

% Salvar em uma pasta ASCII segura temporariamente
gif_path = 'C:\Users\engma\.gemini\antigravity-cli\brain\aaf32d08-cb6b-42ba-874d-38315eaacaae\scratch\convolucao_sinc.gif';

% Loop da convolução passo a passo
frame_delay = 0.08; % Atraso entre frames no GIF (segundos)
step_size = 1;

first_frame = true;
for k = 1 : step_size : Ly
    cla;
    
    % Inicializar vetores para handles e labels da legenda
    handles = [];
    labels = {};
    
    % Identificar a região ativa do filtro no tempo m
    m_start = max(1, k - M);
    m_end = min(Lx, k);
    
    % 1. Sombrear a área do filtro deslizante no fundo (antes dos plots principais)
    if ~isempty(m_start:m_end)
        fill([m_start m_end m_end m_start], [-3.5 -3.5 3.5 3.5], [0.0, 0.5000, 0.0], ...
             'FaceAlpha', 0.05, 'EdgeColor', 'none', 'HandleVisibility', 'off');
        hold on;
    end
    
    % 2. Plot do sinal de entrada original em azul claro
    h1 = stem(1:Lx, x, 'Color', [0.75, 0.85, 0.95], 'LineWidth', 0.8, 'MarkerSize', 4);
    handles = [handles, h1];
    labels = [labels, {'Entrada x[m]'}];
    hold on;
    
    % 3. Plot das amostras da entrada que estão no interior do filtro (azul escuro)
    if ~isempty(m_start:m_end)
        h2 = stem(m_start:m_end, x(m_start:m_end), 'filled', 'Color', [0, 0.4470, 0.7410], 'LineWidth', 1.5, 'MarkerSize', 5);
        handles = [handles, h2];
        labels = [labels, {'Entrada Sob o Filtro'}];
    end
    
    % 4. Plot do filtro g[k-m] (escalado por 6 para visibilidade) em verde bandeira
    g_sliding = zeros(1, Lx + M);
    for m = m_start:m_end
        filter_idx = M - (k - m) + 1;
        if filter_idx >= 1 && filter_idx <= length(g)
            g_sliding(m) = g(filter_idx);
        end
    end
    
    if any(g_sliding)
        h3 = stem(1:(Lx+M), g_sliding * 6, 'Color', [0.0, 0.5000, 0.0], 'LineWidth', 1.5, 'MarkerSize', 5, 'Marker', 'x');
        handles = [handles, h3];
        labels = [labels, {'Filtro Deslizante g[k-m] (\times6)'}];
    end
    
    % 5. Plot da saída filtrada y[k] em vermelho (plota o histórico acumulado até k-1)
    if k > 1
        h4 = stem(1:k-1, y(1:k-1), 'filled', 'Color', [0.8500, 0.1600, 0.1600], 'LineWidth', 1.2, 'MarkerSize', 4);
        handles = [handles, h4];
        labels = [labels, {'Saída Filtrada y[m]'}];
    end
    
    % Destacar a amostra de saída y[k] que está sendo gerada nesse instante em vermelho (maior)
    h5 = stem(k, y(k), 'filled', 'Color', [0.8500, 0.1600, 0.1600], 'LineWidth', 2.0, 'MarkerSize', 7);
    handles = [handles, h5];
    labels = [labels, {'Ponto Atual y[k]'}];
    
    % Configurações dos eixos do gráfico único
    grid on;
    ax = gca;
    ax.GridLineStyle = '--'; ax.GridAlpha = 0.4;
    ax.FontSize = 11; ax.FontName = 'Arial';
    ax.Box = 'on';
    ylim([-3.5, 3.5]);
    xlim([1, Lx + M]);
    
    title('Simulação da Convolução no Tempo Discreto', 'FontSize', 13, 'FontWeight', 'bold', 'FontName', 'Arial');
    ylabel('Amplitude do Sinal / Coeficientes do Filtro (\times6)', 'FontSize', 11, 'FontName', 'Arial');
    xlabel('Instantes de Tempo (Amostras)', 'FontSize', 11, 'FontName', 'Arial');
    
    % Legenda descritiva associando explicitamente os handles corretos
    legend(handles, labels, 'Location', 'northeast');
    
    hold off;
    
    % Capturar frame e salvar no GIF
    drawnow;
    frame = getframe(fig);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);
    
    if first_frame
        imwrite(imind, cm, gif_path, 'gif', 'Loopcount', inf, 'DelayTime', frame_delay);
        first_frame = false;
    else
        imwrite(imind, cm, gif_path, 'gif', 'WriteMode', 'append', 'DelayTime', frame_delay);
    end
end

close(fig);
disp('GIF animado da convolução (legenda corrigida) gerado com sucesso no scratch!');

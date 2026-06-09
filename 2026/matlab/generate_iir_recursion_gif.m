clc; clear all; close all;

% Configuração para reprodutibilidade
rng(42);

% 1. Parâmetros do Sinal
fs = 10;                % Frequência de amostragem (Hz)
t = 0 : 1/fs : 10;      % Tempo de 0 a 10s (101 amostras)
Lx = length(t);

% Sinal de entrada: senóide lenta + componente de alta frequência + ruído leve
x = sin(0.6*t) + 0.4*cos(3.5*t) + 0.1*randn(size(t));

% 2. Projeto do Filtro IIR de 1ª ordem (Butterworth passa-baixas com fc = 0.15 * Nyquist)
% Equação de diferenças: y[k] = b0*x[k] + b1*x[k-1] - a1*y[k-1]
[b, a] = butter(1, 0.15);
b0 = b(1); b1 = b(2);
a1 = a(2); % O coeficiente a(1) é sempre 1.0

% Inicializar sinal de saída
y = zeros(size(x));
for k = 2:Lx
    y(k) = b0*x(k) + b1*x(k-1) - a1*y(k-1);
end

% 3. Configuração da Figura para Animação
fig = figure('Position', [100, 100, 850, 480], 'Visible', 'off');

% Caminho do GIF de saída
gif_path = '../../images/recursao_iir.gif';
frame_delay = 0.12; % Atraso entre frames no GIF (segundos)

first_frame = true;

% Loop passo a passo
for k = 2:Lx
    cla;
    
    % Inicializar handles e labels para a legenda
    handles = [];
    labels = {};
    
    % 1. Sombreador de janela ativa no tempo
    fill([k-1 k k k-1], [-2.2 -2.2 2.2 2.2], [0.95, 0.95, 0.95], ...
         'FaceAlpha', 0.6, 'EdgeColor', [0.8, 0.8, 0.8], 'LineStyle', ':', 'HandleVisibility', 'off');
    hold on;
    
    % 2. Plot do sinal de entrada original em azul claro
    h1 = stem(1:Lx, x, 'Color', [0.75, 0.85, 0.95], 'LineWidth', 0.8, 'MarkerSize', 4);
    handles = [handles, h1];
    labels = [labels, {'Entrada x[m]'}];
    
    % 3. Plot do histórico da saída filtrada em vermelho claro
    if k > 2
        h2 = stem(1:k-2, y(1:k-2), 'Color', [0.95, 0.75, 0.75], 'LineWidth', 0.8, 'MarkerSize', 4);
        handles = [handles, h2];
        labels = [labels, {'Histórico da Saída y[m]'}];
    end
    
    % 4. Destacar termos sob o cálculo recursivo atual
    % Amostras de entrada envolvidas: x[k] e x[k-1]
    h3 = stem([k-1, k], [x(k-1), x(k)], 'filled', 'Color', [0, 0.4470, 0.7410], 'LineWidth', 2.0, 'MarkerSize', 6);
    handles = [handles, h3];
    labels = [labels, {'Amostras de Entrada Ativas'}];
    
    % Amostra de saída anterior (realimentação): y[k-1]
    h4 = stem(k-1, y(k-1), 'filled', 'Marker', 'square', 'Color', [0.9290, 0.6940, 0.1250], 'LineWidth', 2.0, 'MarkerSize', 7);
    handles = [handles, h4];
    labels = [labels, {'Saída Anterior y[k-1] (Feedback)'}];
    
    % Ponto de saída calculado nesse instante: y[k]
    h5 = stem(k, y(k), 'filled', 'Color', [0.8500, 0.1600, 0.1600], 'LineWidth', 2.5, 'MarkerSize', 8);
    handles = [handles, h5];
    labels = [labels, {'Saída Atual Calculada y[k]'}];
    
    % 5. Configuração dos Eixos
    grid on;
    ax = gca;
    ax.GridLineStyle = '--'; ax.GridAlpha = 0.4;
    ax.FontSize = 11; ax.FontName = 'Arial';
    ax.Box = 'on';
    ylim([-2.2, 2.2]);
    xlim([1, Lx]);
    
    title('Funcionamento Recursivo do Filtro IIR (Ordem 1)', 'FontSize', 13, 'FontWeight', 'bold', 'FontName', 'Arial');
    ylabel('Amplitude do Sinal', 'FontSize', 11, 'FontName', 'Arial');
    xlabel('Amostras (k)', 'FontSize', 11, 'FontName', 'Arial');
    
    % Escrever a equação em tempo real
    eq_text = sprintf('y[%d] = %.3f x[%d] + %.3f x[%d] - (%.3f) y[%d]\n', ...
                      k, b0, k, b1, k-1, a1, k-1);
    val_text = sprintf('y[%d] = %.3f(%.2f) + %.3f(%.2f) - (%.3f)(%.2f) = %.3f', ...
                       k, b0, x(k), b1, x(k-1), a1, y(k-1), y(k));
    
    text(2, 1.8, {eq_text, val_text}, 'FontSize', 10, 'FontName', 'Courier', ...
         'BackgroundColor', [1 1 1 0.9], 'EdgeColor', [0.7 0.7 0.7], 'Margin', 6);
    
    % Legenda descritiva
    legend(handles, labels, 'Location', 'southeast');
    
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
disp('GIF animado da recursão do filtro IIR gerado com sucesso!');

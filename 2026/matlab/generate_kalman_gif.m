clc; clear all; close all;

% 1. Parâmetros das Gaussianas do Filtro de Kalman (k = 1 a 5)
mu_pred =  [20.0, 23.4, 25.4, 24.6, 25.6];
sigma_pred = [1.5,  1.2,  1.1,  1.0,  0.9];

mu_meas =  [24.0, 27.0, 24.0, 26.5, 25.0];
sigma_meas = [1.2,  1.1,  1.0,  0.9,  0.8];

mu_post =  [22.4, 25.4, 24.6, 25.6, 25.3];
sigma_post = [0.94, 0.81, 0.74, 0.67, 0.60];

% Trajetória estimada (k = 0 a 5)
t_traj = [0, 1, 2, 3, 4, 5];
y_traj = [18.0, mu_post];

% Configuração da imagem de saída do GIF
filename = '../../images/kalman_filter_update.gif';
scale_factor = 4.0; % Fator de escala para visualização do Z (PDF)

% 2. Preparação da Figura
fig = figure('Position', [100, 100, 1000, 680], 'Color', 'white');

% Contagem total de frames: 5 passos * 4 sub-frames por passo = 20 frames
frame_count = 1;

for k = 1:5
    for phase = 1:4
        clf;
        hold on;
        
        % Configurar o espaço 3D
        view(-48, 26);
        grid on; box on;
        xlim([0, 5.5]);
        ylim([14, 31]);
        zlim([0, 2.5]);
        set(gca, 'XTick', 0:5);
        xlabel('Tempo (k)', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Arial');
        ylabel('Temperatura (°C)', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Arial');
        zlabel('Densidade de Probabilidade p(x)', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Arial');
        title('Funcionamento do Filtro de Kalman ao Longo do Tempo', 'FontSize', 13, 'FontWeight', 'bold', 'FontName', 'Arial');
        
        % Ponto de origem na calha (k = 0, temp = 18)
        plot3(0, 18.0, 0, 'ko', 'MarkerSize', 7, 'MarkerFaceColor', 'k');
        
        % --- DESENHAR TRAJETÓRIA PASSADA (PERSISTENTE) ---
        % Desenhar os pontos já consolidados no plano Z=0
        % Para o passo k:
        % Se phase < 4, nós desenhamos pontos até k-1 e a linha até k-1.
        % Se phase == 4, nós desenhamos pontos até k e a linha até k.
        limit_point = k - 1;
        if phase == 4
            limit_point = k;
        end
        
        % Desenhar pontos da trajetória
        for j = 1:limit_point
            plot3(t_traj(j+1), y_traj(j+1), 0, 'Color', [0.4660, 0.6740, 0.1880], 'Marker', 'o', 'MarkerSize', 7, 'MarkerFaceColor', [0.4660, 0.6740, 0.1880]);
        end
        
        % Desenhar linhas da trajetória
        if limit_point >= 1
            plot3(t_traj(1:limit_point+1), y_traj(1:limit_point+1), zeros(1, limit_point+1), 'Color', [0.2, 0.2, 0.2], 'LineWidth', 2.0);
        end
        
        % --- DESENHAR GAUSSIANAS DO PASSO ATUAL k (NÃO PERSISTEM AS ANTERIORES) ---
        
        % 1. Predição (sempre desenhada em azul)
        if phase >= 1
            y_grid = linspace(mu_pred(k) - 3.5*sigma_pred(k), mu_pred(k) + 3.5*sigma_pred(k), 100);
            z_pdf = scale_factor * (1 / (sqrt(2*pi)*sigma_pred(k))) * exp(-(y_grid - mu_pred(k)).^2 / (2*sigma_pred(k)^2));
            fill3(k*ones(size(y_grid)), y_grid, z_pdf, [0.0, 0.4470, 0.7410], 'FaceAlpha', 0.15, 'EdgeColor', 'none');
            plot3(k*ones(size(y_grid)), y_grid, z_pdf, 'Color', [0.0, 0.4470, 0.7410], 'LineWidth', 1.8);
            plot3([k, k], [mu_pred(k), mu_pred(k)], [0, max(z_pdf)], 'Color', [0.0, 0.4470, 0.7410], 'LineStyle', ':', 'LineWidth', 1.0);
            text(k, mu_pred(k), max(z_pdf) + 0.1, 'Predição', 'Color', [0.0, 0.4470, 0.7410], 'FontSize', 9, 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
        end
        
        % 2. Medição (desenhada em vermelho)
        if phase >= 2
            y_grid = linspace(mu_meas(k) - 3.5*sigma_meas(k), mu_meas(k) + 3.5*sigma_meas(k), 100);
            z_pdf = scale_factor * (1 / (sqrt(2*pi)*sigma_meas(k))) * exp(-(y_grid - mu_meas(k)).^2 / (2*sigma_meas(k)^2));
            fill3(k*ones(size(y_grid)), y_grid, z_pdf, [0.8500, 0.3250, 0.0980], 'FaceAlpha', 0.12, 'EdgeColor', 'none');
            plot3(k*ones(size(y_grid)), y_grid, z_pdf, 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 1.8);
            plot3([k, k], [mu_meas(k), mu_meas(k)], [0, max(z_pdf)], 'Color', [0.8500, 0.3250, 0.0980], 'LineStyle', ':', 'LineWidth', 1.0);
            text(k, mu_meas(k), max(z_pdf) + 0.1, 'Medição', 'Color', [0.8500, 0.3250, 0.0980], 'FontSize', 9, 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
        end
        
        % 3. Posteriori (desenhada em verde)
        if phase >= 3
            y_grid = linspace(mu_post(k) - 3.5*sigma_post(k), mu_post(k) + 3.5*sigma_post(k), 100);
            z_pdf = scale_factor * (1 / (sqrt(2*pi)*sigma_post(k))) * exp(-(y_grid - mu_post(k)).^2 / (2*sigma_post(k)^2));
            fill3(k*ones(size(y_grid)), y_grid, z_pdf, [0.4660, 0.6740, 0.1880], 'FaceAlpha', 0.2, 'EdgeColor', 'none');
            plot3(k*ones(size(y_grid)), y_grid, z_pdf, 'Color', [0.4660, 0.6740, 0.1880], 'LineWidth', 2.0);
            plot3([k, k], [mu_post(k), mu_post(k)], [0, max(z_pdf)], 'Color', [0.4660, 0.6740, 0.1880], 'LineStyle', ':', 'LineWidth', 1.0);
            text(k, mu_post(k), max(z_pdf) + 0.15, 'Posteriori', 'Color', [0.4660, 0.6740, 0.1880], 'FontSize', 9, 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
        end
        
        % Capturar frame para gerar o GIF animado
        drawnow;
        frame = getframe(fig);
        im = frame2im(frame);
        [imind, cm] = rgb2ind(im, 256);
        
        % Gravar no arquivo GIF
        if frame_count == 1
            imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 1.2);
        else
            imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 1.2);
        end
        
        frame_count = frame_count + 1;
    end
end

close(fig);
disp('GIF animado do Filtro de Kalman atualizado com sucesso!');

import os
import numpy as np
import matplotlib.pyplot as plt
from scipy import signal

# Define paths
img_dir = r"G:\My Drive\Disciplinas\Graduação\SEL343 - Processamento Digital de Sinais\slides\images"
os.makedirs(img_dir, exist_ok=True)

# Set common style for slides
plt.rcParams['font.sans-serif'] = 'Arial'
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['figure.facecolor'] = 'white'
plt.rcParams['axes.facecolor'] = 'white'

# ----------------- PLOT 1 & 2: Example 1 (FIR Window Design) -----------------
fs1 = 1000
fc1 = 150
M1 = 50
N1 = M1 + 1
wc1 = 2 * np.pi * fc1 / fs1
alpha1 = M1 / 2

k1 = np.arange(N1)
# Ideal impulse response (causal and symmetric)
g_ideal = np.zeros(N1)
for i in range(N1):
    ki = k1[i]
    if ki == alpha1:
        g_ideal[i] = wc1 / np.pi
    else:
        g_ideal[i] = np.sin(wc1 * (ki - alpha1)) / (np.pi * (ki - alpha1))

# Windows
w_rect = np.ones(N1)
w_hamming = np.hamming(N1)
w_blackman = np.blackman(N1)

g_rect = g_ideal * w_rect
g_hamming = g_ideal * w_hamming
g_blackman = g_ideal * w_blackman

# Frequency responses
w_freq, G_rect = signal.freqz(g_rect, 1, worN=1024, fs=fs1)
_, G_hamming = signal.freqz(g_hamming, 1, worN=1024, fs=fs1)
_, G_blackman = signal.freqz(g_blackman, 1, worN=1024, fs=fs1)

mag_rect = 20 * np.log10(np.abs(G_rect) + 1e-10)
mag_hamming = 20 * np.log10(np.abs(G_hamming) + 1e-10)
mag_blackman = 20 * np.log10(np.abs(G_blackman) + 1e-10)

# Save Plot 1: Impulse response g[k]
plt.figure(figsize=(8.5, 4.8))
plt.subplot(2, 1, 1)
markerline, stemlines, baseline = plt.stem(k1, g_rect, basefmt="k-")
plt.setp(markerline, 'markerfacecolor', '#0077b6', 'markeredgecolor', '#0077b6', 'markersize', 4)
plt.setp(stemlines, 'color', '#0077b6', 'linewidth', 1.2)
plt.setp(baseline, 'color', 'gray', 'linewidth', 0.8)
plt.title('Resposta ao Impulso g[k] - Janela Retangular', fontsize=11, fontweight='bold', color='#2b2d42')
plt.xlabel('Amostra k', fontsize=9)
plt.ylabel('Amplitude', fontsize=9)
plt.grid(True, linestyle='--', alpha=0.5)
plt.xlim(-1, M1 + 1)

plt.subplot(2, 1, 2)
markerline, stemlines, baseline = plt.stem(k1, g_hamming, basefmt="k-")
plt.setp(markerline, 'markerfacecolor', '#d90429', 'markeredgecolor', '#d90429', 'markersize', 4)
plt.setp(stemlines, 'color', '#d90429', 'linewidth', 1.2)
plt.setp(baseline, 'color', 'gray', 'linewidth', 0.8)
plt.title('Resposta ao Impulso g[k] - Janela Hamming', fontsize=11, fontweight='bold', color='#2b2d42')
plt.xlabel('Amostra k', fontsize=9)
plt.ylabel('Amplitude', fontsize=9)
plt.grid(True, linestyle='--', alpha=0.5)
plt.xlim(-1, M1 + 1)
plt.tight_layout()
plt.savefig(os.path.join(img_dir, 'aula8_fir_impulse.png'), dpi=200, bbox_inches='tight')
plt.close()

# Save Plot 2: Frequency response comparison
plt.figure(figsize=(8.5, 4.5))
plt.plot(w_freq, mag_rect, color='#0077b6', linewidth=2, label='Retangular')
plt.plot(w_freq, mag_hamming, color='#d90429', linewidth=2, label='Hamming')
plt.plot(w_freq, mag_blackman, color='#2ec4b6', linewidth=2, label='Blackman')
plt.axhline(-6, color='black', linestyle='--', linewidth=1.2, label='-6 dB (Corte)')
plt.title('Resposta em Frequência - Comparação de Janelas', fontsize=12, fontweight='bold', color='#2b2d42')
plt.xlabel('Frequência (Hz)', fontsize=10)
plt.ylabel('Magnitude (dB)', fontsize=10)
plt.grid(True, linestyle='--', alpha=0.5)
plt.legend(loc='lower left', framealpha=0.9)
plt.ylim(-100, 10)
plt.xlim(0, fs1 / 2)
plt.tight_layout()
plt.savefig(os.path.join(img_dir, 'aula8_fir_freq_resp.png'), dpi=200, bbox_inches='tight')
plt.close()


# ----------------- PLOT 3, 4 & 5: Example 2 (Filtering Simulation) -----------------
fs2 = 500
t = np.arange(0, 1, 1/fs2)
N_sinal = len(t)
f1 = 10
f2 = 120

# Clean signal
x_clean = np.sin(2 * np.pi * f1 * t)

# Noisy signal
np.random.seed(42)
noise = 0.3 * np.random.randn(N_sinal)
x_noisy = x_clean + 0.5 * np.cos(2 * np.pi * f2 * t) + noise

# Filter design
M2 = 60
fc2 = 40
wc2 = 2 * np.pi * fc2 / fs2
alpha2 = M2 / 2

k2 = np.arange(M2 + 1)
g2 = np.zeros(M2 + 1)
for i in range(M2 + 1):
    ki = k2[i]
    if ki == alpha2:
        g2[i] = wc2 / np.pi
    else:
        g2[i] = np.sin(wc2 * (ki - alpha2)) / (np.pi * (ki - alpha2))

g2 = g2 * np.hamming(M2 + 1)

# Apply filter
y_filtered = signal.lfilter(g2, 1, x_noisy)

# Compensate delay (shift left by alpha)
y_filtered_compensated = np.zeros(N_sinal)
y_filtered_compensated[:-int(alpha2)] = y_filtered[int(alpha2):]

# FFT Spectrum
X_noisy_fft = np.abs(np.fft.fft(x_noisy)) / N_sinal
Y_filtered_fft = np.abs(np.fft.fft(y_filtered)) / N_sinal
freqs = np.fft.fftfreq(N_sinal, 1/fs2)

half_idx = freqs >= 0
f_plot = freqs[half_idx]
X_noisy_plot = 2 * X_noisy_fft[half_idx]
Y_filtered_plot = 2 * Y_filtered_fft[half_idx]

# Save Plot 3: Time domain signals
plt.figure(figsize=(8.5, 5.8))
plt.subplot(3, 1, 1)
plt.plot(t, x_clean, color='#2b2d42', linewidth=1.5)
plt.title('Sinal Limpo (Original Fundamental f_1 = 10 Hz)', fontsize=10, fontweight='bold', color='#2b2d42')
plt.xlabel('Tempo (s)', fontsize=8)
plt.ylabel('Amplitude', fontsize=8)
plt.grid(True, linestyle='--', alpha=0.5)
plt.ylim(-1.8, 1.8)

plt.subplot(3, 1, 2)
plt.plot(t, x_noisy, color='#d90429', linewidth=1.0)
plt.title('Sinal Ruidoso (Entrada: Fundamental + Ruído + Interferência f_2 = 120 Hz)', fontsize=10, fontweight='bold', color='#2b2d42')
plt.xlabel('Tempo (s)', fontsize=8)
plt.ylabel('Amplitude', fontsize=8)
plt.grid(True, linestyle='--', alpha=0.5)
plt.ylim(-1.8, 1.8)

plt.subplot(3, 1, 3)
plt.plot(t, y_filtered_compensated, color='#0077b6', linewidth=1.5)
plt.title('Sinal Filtrado na Saída (Compensado pelo Atraso do Filtro de 30 Amostras)', fontsize=10, fontweight='bold', color='#2b2d42')
plt.xlabel('Tempo (s)', fontsize=8)
plt.ylabel('Amplitude', fontsize=8)
plt.grid(True, linestyle='--', alpha=0.5)
plt.ylim(-1.8, 1.8)

plt.tight_layout()
plt.savefig(os.path.join(img_dir, 'aula8_filtering_time.png'), dpi=200, bbox_inches='tight')
plt.close()

# Save Plot 4: Spectrum comparison
plt.figure(figsize=(8.5, 4.2))
plt.plot(f_plot, X_noisy_plot, color='#d90429', linewidth=1.5, label='Espectro do Sinal Ruidoso (Entrada)')
plt.plot(f_plot, Y_filtered_plot, color='#0077b6', linewidth=2, label='Espectro do Sinal Filtrado (Saída)')
plt.axvline(fc2, color='black', linestyle='--', linewidth=1.2, label='Frequência de Corte (40 Hz)')
plt.title('Espectro de Amplitude dos Sinais (Entrada vs Saída)', fontsize=12, fontweight='bold', color='#2b2d42')
plt.xlabel('Frequência (Hz)', fontsize=10)
plt.ylabel('Amplitude (Magnitude)', fontsize=10)
plt.grid(True, linestyle='--', alpha=0.5)
plt.legend(loc='upper right', framealpha=0.9)
plt.xlim(0, fs2 / 2)
plt.tight_layout()
plt.savefig(os.path.join(img_dir, 'aula8_filtering_freq.png'), dpi=200, bbox_inches='tight')
plt.close()

# Save Plot 5: Pole-Zero map
fig, ax = plt.subplots(figsize=(5, 5))
# Shaded unit circle matching the pink/light-red stability region in "estabilidade_z.png"
theta = np.linspace(0, 2*np.pi, 200)
# Fill the stable region (inside unit circle) with soft reddish-pink color
ax.fill(np.cos(theta), np.sin(theta), color='#f8d7da', zorder=1)
# Draw unit circle boundary (thin grey line matching "estabilidade_z.png")
ax.plot(np.cos(theta), np.sin(theta), color='#cbd5e1', linewidth=1.5, zorder=2)

# Solid thick dark black axes inside the circle matching "estabilidade_z.png"
ax.plot([-1.1, 1.1], [0, 0], color='#000000', linewidth=1.8, zorder=3)
ax.plot([0, 0], [-1.1, 1.1], color='#000000', linewidth=1.8, zorder=3)

# Zeros and poles calculation
zeros = np.roots(g2)
poles = np.zeros(M2) # 60 poles at origin

# Plot zeros as blue circles ('o') and poles as bold red crosses ('x') matching "estabilidade_z.png" style
ax.scatter(np.real(zeros), np.imag(zeros), s=40, facecolors='none', edgecolors='#0072bd', marker='o', linewidths=1.5, zorder=4, label='Zeros')
ax.scatter(np.real(poles), np.imag(poles), s=90, color='#ff0000', marker='x', linewidths=3.0, zorder=5, label='Polos na Origem (x60)')

# Box layout matching MATLAB default style (inward ticks, solid outer lines)
ax.set_title('plano-z', fontsize=12, fontweight='bold', color='#000000', pad=10)
ax.set_xlabel('Real', fontsize=11, color='#000000')
ax.set_ylabel('Imag', fontsize=11, color='#000000')
ax.tick_params(direction='in', top=True, right=True, labelsize=9)
ax.set_aspect('equal')
ax.set_xlim(-1.1, 1.1)
ax.set_ylim(-1.1, 1.1)
ax.set_xticks([-1, -0.5, 0, 0.5, 1])
ax.set_yticks([-1, -0.8, -0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6, 0.8, 1])
ax.legend(loc='upper right', fontsize=8, framealpha=0.9)
plt.tight_layout()
plt.savefig(os.path.join(img_dir, 'aula8_fir_poles_zeros.png'), dpi=200, bbox_inches='tight')
plt.close()


# ----------------- PLOT 6: Example 3 (Moving Average Filter) -----------------
fs3 = 1000
t3 = np.arange(0, 1 + 1/fs3, 1/fs3)
f1_3 = 5
f2_3 = 120

# Clean signal
x_clean3 = np.sin(2 * np.pi * f1_3 * t3)

# Noisy signal
np.random.seed(42)
noise3 = 0.25 * np.random.randn(len(t3))
x_noisy3 = x_clean3 + 0.4 * np.cos(2 * np.pi * f2_3 * t3) + noise3

P1, P2, P3 = 5, 21, 81

# Filters
b1 = np.ones(P1) / P1
b2 = np.ones(P2) / P2
b3 = np.ones(P3) / P3

# lfilter applies filter in Python (same as MATLAB filter)
y1_py = signal.lfilter(b1, 1, x_noisy3)
y2_py = signal.lfilter(b2, 1, x_noisy3)
y3_py = signal.lfilter(b3, 1, x_noisy3)

# Geração do gráfico
plt.figure(figsize=(8.5, 4.8))
plt.plot(t3, x_noisy3, color='#cbd5e1', linewidth=1.0, label='Sinal Ruidoso (Entrada)')
plt.plot(t3, y1_py, color='#2ec4b6', linewidth=1.5, label=f'Média Móvel (P = {P1})')
plt.plot(t3, y2_py, color='#0077b6', linewidth=2.0, label=f'Média Móvel (P = {P2})')
plt.plot(t3, y3_py, color='#d90429', linewidth=2.0, label=f'Média Móvel (P = {P3})')

plt.title('Filtro de Média Móvel em Sinais Ruidosos', fontsize=12, fontweight='bold', color='#2b2d42')
plt.xlabel('Tempo (s)', fontsize=10)
plt.ylabel('Amplitude', fontsize=10)
plt.grid(True, linestyle='--', alpha=0.5)
plt.legend(loc='lower left', framealpha=0.9, fontsize=9)
plt.ylim(-2.0, 2.0)
plt.xlim(0, 1.0)
plt.tight_layout()
plt.savefig(os.path.join(img_dir, 'aula8_moving_average.png'), dpi=200, bbox_inches='tight')
plt.close()

print("Figures successfully generated!")

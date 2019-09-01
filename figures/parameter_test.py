import os

import matplotlib.pyplot as plt
import numpy as np
from skimage import exposure
from skimage.io import imread

from tools.toolbox import normalize


def im_with_histogram(image, axes, bins=256):
    image = image
    ax_img, ax_hist = axes

    # Display image
    ax_img.imshow(image, cmap='gray')
    ax_img.set_axis_off()

    # Display histogram
    ax_hist.hist(image.ravel(), bins=bins, histtype='step', color='black')
    ax_hist.ticklabel_format(axis='y', style='scientific', scilimits=(0, 0))
    ax_hist.set_xlabel('Intensität', fontsize=28)
    ax_hist.set_xlim(-10, 260)
    ax_hist.set_xticks(np.linspace(0, 255, 4))
    ax_hist.set_yticks([])

    ax_hist.tick_params(axis='both', labelsize=22)

    return ax_img, ax_hist


def parameter_test(inpath, outpath):
    im = imread(inpath)

    im1 = normalize(exposure.adjust_gamma(im, gain=0.01, gamma=2))
    im1_1 = normalize(exposure.adjust_gamma(im, gain=0.1, gamma=2))
    im2 = normalize(exposure.adjust_gamma(im, gain=1, gamma=2))
    im2_1 = normalize(exposure.adjust_gamma(im, gain=5, gamma=2))
    im3 = normalize(exposure.adjust_gamma(im, gain=10, gamma=2))

    im4 = normalize(exposure.adjust_log(im, gain=0.005))
    im4_1 = normalize(exposure.adjust_log(im, gain=0.01))
    im5 = normalize(exposure.adjust_log(im, gain=1))
    im5_1 = normalize(exposure.adjust_log(im, gain=5))
    im6 = normalize(exposure.adjust_log(im, gain=10))

    fig = plt.figure(figsize=(25, 10))
    axes = np.zeros((2, 6), dtype=np.object)
    axes[0, 0] = fig.add_subplot(2, 6, 1)
    for i in range(1, 6):
        axes[0, i] = fig.add_subplot(2, 6, 1 + i)
    for i in range(0, 6):
        axes[1, i] = fig.add_subplot(2, 6, 7 + i)

    ax_img, ax_hist = im_with_histogram(im, axes[:, 0])
    ax_img.set_title('Original', fontsize=26)

    y_min, y_max = ax_hist.get_ylim()
    ax_hist.set_ylabel('Pixelanzahl', fontsize=26)
    ax_hist.set_yticks(np.linspace(0, y_max, 5))

    ax_img, ax_hist = im_with_histogram(im1, axes[:, 1])
    ax_img.set_title('Gamma(k=0.01, $\gamma$=2)', fontsize=26)

    ax_img, ax_hist = im_with_histogram(im1_1, axes[:, 2])
    ax_img.set_title('Gamma(k=0.1, $\gamma$=2)', fontsize=26)

    ax_img, ax_hist = im_with_histogram(im2, axes[:, 3])
    ax_img.set_title('Gamma(k=1, $\gamma$=2)', fontsize=26)

    ax_img, ax_hist = im_with_histogram(im2_1, axes[:, 4])
    ax_img.set_title('Gamma(k=5, $\gamma$=2)', fontsize=26)

    ax_img, ax_hist = im_with_histogram(im3, axes[:, 5])
    ax_img.set_title('Gamma(k=10, $\gamma$=2)', fontsize=26)

    plt.tight_layout()
    plt.savefig(os.path.join(outpath, 'gamma_paras.pdf'))
    plt.show()

    fig = plt.figure(figsize=(25, 10))
    axes = np.zeros((2, 6), dtype=np.object)
    axes[0, 0] = fig.add_subplot(2, 6, 1)
    for i in range(1, 6):
        axes[0, i] = fig.add_subplot(2, 6, 1 + i)
    for i in range(0, 6):
        axes[1, i] = fig.add_subplot(2, 6, 7 + i)

    ax_img, ax_hist = im_with_histogram(im, axes[:, 0])
    ax_img.set_title('Original', fontsize=26)

    y_min, y_max = ax_hist.get_ylim()
    ax_hist.set_ylabel('Pixelanzahl', fontsize=26)
    ax_hist.set_yticks(np.linspace(0, y_max, 5))

    ax_img, ax_hist = im_with_histogram(im4, axes[:, 1])
    ax_img.set_title('Log(n=0.005)', fontsize=26)

    ax_img, ax_hist = im_with_histogram(im4_1, axes[:, 2])
    ax_img.set_title('Log(n=0.01)', fontsize=26)

    ax_img, ax_hist = im_with_histogram(im5, axes[:, 3])
    ax_img.set_title('Log(n=1)', fontsize=26)

    ax_img, ax_hist = im_with_histogram(im5_1, axes[:, 4])
    ax_img.set_title('Log(n=5)', fontsize=26)

    ax_img, ax_hist = im_with_histogram(im6, axes[:, 5])
    ax_img.set_title('Log(n=10)', fontsize=26)

    plt.tight_layout()
    plt.savefig(os.path.join(outpath, 'log_paras.pdf'))
    plt.show()


if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser()

    parser.add_argument('--inpath', help='input-file which is a growth-cone image')
    parser.add_argument('--outpath', help='output-path for the image')

    a = parser.parse_args()

    parameter_test(a.inpath, a.outpath)

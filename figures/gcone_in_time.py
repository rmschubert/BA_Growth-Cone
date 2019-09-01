import os

import matplotlib.pyplot as plt
import numpy as np

from tools.toolbox import normalize, read_stack


def im_with_histogram(image, axes, bins=256):
    image = image
    ax_img, ax_hist = axes

    ax_img.imshow(image, cmap='gray')
    ax_img.set_axis_off()

    ax_hist.hist(image.ravel(), bins=bins, histtype='step', color='black')
    ax_hist.ticklabel_format(axis='y', style='scientific', scilimits=(0, 0))
    ax_hist.set_xlabel('Intensität')
    ax_hist.set_xlim(0, 255)
    ax_hist.set_yticks([])

    return ax_img, ax_hist


def gcone_in_time(inpath, outpath):

    """
    :param inpath: filepath of a cropped stack
    :param outpath: output-path for the image

    Creates an figure where the first, fifth, tenth and fifteenth frame of a cropped stack is shown with their
    histograms.
    """

    stack = read_stack(inpath)

    im1 = normalize(stack[0])
    im2 = normalize(stack[4])
    im3 = normalize(stack[9])
    im4 = normalize(stack[14])

    duration = len(stack) / 7
    time_of_frame = duration / 178
    durim2 = time_of_frame * 5
    durim3 = time_of_frame * 10
    durim4 = time_of_frame * 15

    fig = plt.figure(figsize=(11, 5))
    axes = np.zeros((2, 4), dtype=np.object)
    axes[0, 0] = fig.add_subplot(2, 4, 1)
    for i in range(1, 4):
        axes[0, i] = fig.add_subplot(2, 4, 1 + i, sharex=axes[0, 0], sharey=axes[0, 0])
    for i in range(0, 4):
        axes[1, i] = fig.add_subplot(2, 4, 5 + i)

    ax_img, ax_hist = im_with_histogram(im1, axes[:, 0])
    ax_img.set_title('erstes Bild (t = 0s)')

    y_min, y_max = ax_hist.get_ylim()
    ax_hist.set_ylabel('Pixelanzahl')
    ax_hist.set_yticks(np.linspace(0, y_max, 5))

    ax_img, ax_hist = im_with_histogram(im2, axes[:, 1])
    ax_img.set_title('fünftes Bild (t = {}s)'.format("{:.2f}".format(durim2)))

    ax_img, ax_hist = im_with_histogram(im3, axes[:, 2])
    ax_img.set_title('zehntes Bild (t = {}s)'.format("{:.2f}".format(durim3)))

    ax_img, ax_hist = im_with_histogram(im4, axes[:, 3])
    ax_img.set_title('fünfzehntes Bild (t = {}s)'.format("{:.2f}".format(durim4)))

    plt.tight_layout()
    plt.savefig(os.path.join(outpath, 'gcone_timelapse.png'))
    plt.show()


if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser()

    parser.add_argument('--inpath', help='filepath of a cropped gcone-stack')
    parser.add_argument('--outpath', help='output-path where the figure will be saved')

    a = parser.parse_args()

    gcone_in_time(a.inpath, a.outpath)


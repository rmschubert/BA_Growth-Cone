import glob
import os

import skimage.io as skio
from scipy.signal import medfilt
from skimage import exposure as ex
from skimage.filters import threshold_otsu

from tools.toolbox import normalize, get_name, save


def gen_classics(path_originals, outpath):

    """
    :param path_originals: path to directory containing the growth-cone images
    :param outpath: output-path where the images manipulated with the classic methods will be saved

    Creates directories named by the growth-cone images. Each directory then contains subdirectories named after the
    applied classic method.
    There are 11 images created for each method, where the power-law transformation and the logarithmic transformation
    each have an individual parameter intervall.

    For further informations about the methods and extensions consult the belonging sites:
    https://docs.scipy.org/doc/scipy/reference/generated/scipy.signal.medfilt.html
    https://scikit-image.org/docs/dev/api/skimage.exposure.html
    https://scikit-image.org/docs/dev/api/skimage.filters.html#skimage.filters.threshold_otsu
    """

    gcone_files = glob.glob(os.path.join(path_originals, '*.png'))

    for i, gcone_file in enumerate(gcone_files):

        gcone_image = skio.imread(gcone_file)[:, :, 0]

        gamma, gamma_otsu, gamma_med = gen_gamma(gcone_image)
        log, log_otsu, log_med = gen_log(gcone_image)

        name = get_name(gcone_file)
        root = os.path.join(outpath, name)
        if not os.path.exists(root):
            os.mkdir(root)

        for k in range(len(gamma)):

            save(os.path.join(root, 'gamma'), '%s-ga.png' % k, gamma[k])
            save(os.path.join(root, 'gamma-ots'), '%s-ga-ots.png' % k, gamma_otsu[k])
            save(os.path.join(root, 'gamma-med'), '%s-ga-med.png' % k, gamma_med[k])
            save(os.path.join(root, 'log'), '%s-log.png' % k, log[k])
            save(os.path.join(root, 'log-ots'), '%s-lo-ots.png' % k, log_otsu[k])
            save(os.path.join(root, 'log-med'), '%s-lo-med.png' % k, log_med[k])


def gen_gamma(image):

    images_gamma, images_otsu, images_medfilt = [], [], []

    start_gamma = 0.01
    step_gamma = 0.001
    for i in range(11):
        p = start_gamma + i*step_gamma

        im_gamma = ex.adjust_gamma(image, gain=p, gamma=2)

        thresh = threshold_otsu(im_gamma)
        im_gamma_otsu = (im_gamma > thresh) * 1
        im_gamma_medfilt = medfilt(im_gamma)

        im_gamma = normalize(im_gamma)
        im_gamma_otsu = normalize(im_gamma_otsu)
        im_gamma_medfilt = normalize(im_gamma_medfilt)

        images_gamma.append(im_gamma.astype(int))
        images_otsu.append(im_gamma_otsu.astype(int))
        images_medfilt.append(im_gamma_medfilt.astype(int))

    return images_gamma, images_otsu, images_medfilt


def gen_log(image):
    images_log, images_otsu, images_medfilt = [], [], []

    start_log = 0.006
    step_log = 0.001

    for i in range(11):
        p = start_log + i * step_log

        im_log = ex.adjust_log(image, p)

        thresh = threshold_otsu(im_log)
        im_log_otsu = (im_log > thresh) * 1
        im_log_medfilt = medfilt(im_log)

        im_log = normalize(im_log)
        im_log_otsu = normalize(im_log_otsu)
        im_log_medfilt = normalize(im_log_medfilt)

        images_log.append(im_log.astype(int))
        images_otsu.append(im_log_otsu.astype(int))
        images_medfilt.append(im_log_medfilt.astype(int))

    return images_log, images_otsu, images_medfilt


if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser()

    parser.add_argument('-originals')
    parser.add_argument('-output')

    paras = parser.parse_args()

    outpath = paras.output
    if not os.path.exists(outpath):
        os.mkdir(outpath)

    gen_classics(paras.originals, outpath)

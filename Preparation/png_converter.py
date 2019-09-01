import os
import glob

import numpy as np
from skimage.io import imread
from skimage.color import gray2rgb

from tools.toolbox import read_stack, normalize, get_name, save


def convert(inpath, outpath, binary, is_stack, partner_dir):

    """

    :param inpath: input-path to either the images or filepath to a stack (file(s) must be tif-format)
    :param outpath: output-path where the images will be saved
    :param binary: if True the input and output is binary
    :param is_stack: if True the input-path must be filepath to the stack
    :param partner_dir: Neccessary if the input is a stack. the name of output image will be the name of the
    corresponding image in the partner directory. this is needed if you want to convert labels in a given stack. the
    network needs the same filenames to combine image and label.

    Creates 8-bit images in range 0-255 in .png-format from tif-format file(s). The output will be rgb-file
    because the network requires images with 3 channels.

    Further informations for the rgb-conversion here:
    https://scikit-image.org/docs/dev/api/skimage.color.html#skimage.color.gray2rgb

    """

    if is_stack:
        images = read_stack(inpath)
        partners = []
        if partner_dir is not None and any(File.endswith('.png') for File in os.listdir(partner_dir)):
            partners = glob.glob(os.path.join(partner_dir, '*.png'))
        elif partner_dir is not None and any(File.endswith('.tif') for File in os.listdir(partner_dir)):
            partners = glob.glob(os.path.join(partner_dir, '*.tif'))
        else:
            print('unknown extension, please use .png or .tif for partner-directory')

        for i, image in enumerate(images):

            im = image
            im_norm = normalize(im)
            im_norm = np.asarray(im_norm, dtype=np.uint8)
            im_norm = (im_norm > 0) * 255 if binary else im_norm
            im_norm = gray2rgb(im_norm)

            partner_name = get_name(partners[i])
            n = partner_name + '.png'

            p = os.path.join(outpath, n)
            save(p, n, im_norm)

    else:
        filepath = os.path.join(inpath, '*.tif')
        images = glob.glob(filepath)

        for image in images:

            im = imread(image)

            im_norm = normalize(im)
            im_norm = np.asarray(im_norm, dtype=np.uint8)
            im_norm = (im_norm > 0) * 255 if binary else im_norm
            im_norm = gray2rgb(im_norm)

            name = get_name(image)
            n = name + '.png'

            p = os.path.join(outpath, n)
            save(p, n, im_norm)


if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser(description='convert tiff-files to png')

    parser.add_argument('--inpath', help='directory containing the images')
    parser.add_argument('--outpath', help='output directory')
    parser.add_argument('--is_label', type=bool, default=False, help='if True the output will be binary (0 or 255)')
    parser.add_argument('--is_stack', type=bool, default=False, help='if True input-path must be filepath of a stack')
    parser.add_argument('--partner_dir', help='required if you having stack as an input. the names of the output-images '
                                              'will be the names of the corresponding partner-directory.')

    a = parser.parse_args()

    convert(a.inpath, a.outpath, a.is_label, a.is_stack, a.partner_dir)


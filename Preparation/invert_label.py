import os
import glob
import argparse

from skimage.io import imread
import numpy as np

from tools.toolbox import save


def invert_label(inpath, pathout):

    """

    :param inpath: input-path containing the labels to be inverted
    :param pathout: output-path for the inverted labels

    """

    imgs = glob.glob(inpath)

    for path in imgs:
        img = imread(path)
        name = os.path.basename(path)

        img = np.invert(img)

        save(os.path.join(pathout), name, img)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()

    parser.add_argument('-pathin')
    parser.add_argument('-pathout')

    a = parser.parse_args()

    if not os.path.exists(a.pathout):
        os.mkdir(a.pathout)

    invert_label(a.pathin, a.pathout)

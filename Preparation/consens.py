import os
import glob

import numpy as np
from skimage.io import imread, imsave
from skimage.morphology import skeletonize
from skimage.draw import circle
from scipy.ndimage.filters import convolve


def read(inpath):

    paths = []

    for dir in os.listdir(inpath):
        p = os.path.join(inpath, dir)
        if os.path.isdir(p):
            paths.append(os.path.join(os.getcwd(), p))
    o = []

    for path in paths:
        k = glob.glob(os.path.join(path, '*'))
        o.append(k)
    return o


def skeleton(paths):

    la_1 = paths[0]
    la_2 = paths[1]
    la_3 = paths[2]

    skeletons = []

    for k in range(len(la_1)):
        im1 = imread(la_1[k])
        im2 = imread(la_2[k])
        im3 = imread(la_3[k])

        con1 = np.logical_and(im1, im2)
        con2 = np.logical_and(con1, im3)

        skel = (skeletonize(con2 > 0)) * 1
        skeletons.append(skel)
    return skeletons


def circ():

    ker = np.zeros((4, 4), dtype=np.uint8)
    rr, cc = circle(1.5, 1.5, 2, ker.shape)

    ker[rr, cc] = 1
    return ker


def conv(data, paths, outpath):

    kernel = circ()

    for i, file in enumerate(paths[0]):
        name = os.path.basename(file)

        consens = (convolve(data[i], kernel)) * 65535
        consens = np.asarray(consens, dtype=np.uint16)

        p_out = os.path.join(outpath, 'consens_tiff', name)
        if not os.path.exists(os.path.join(outpath, 'consens_tiff')):
            os.mkdir(os.path.join(outpath, 'consens_tiff'))

        imsave(p_out, consens)


def consensus(inpath, outpath):

    """

    :param inpath: input-path containing 3 directories with label-images
    :param outpath: output-path where the consensus will be saved

    First the intersection of all three annotations is made. Then the intersection is skeletonized. The skeletons are
    then convolved with a circle-shaped kernel to produce labels which are similar to the annotation used for the
    intersection.

    You'll find further informations for the skeletonization and kernel here:
    https://scikit-image.org/docs/dev/auto_examples/edges/plot_skeleton.html
    https://scikit-image.org/docs/dev/api/skimage.draw.html

    and for the used convolution here:
    https://docs.scipy.org/doc/scipy/reference/generated/scipy.signal.convolve.html

    """

    paths = read(inpath)
    skeletons = skeleton(paths)

    if not os.path.exists(outpath):
        os.mkdir(outpath)

    conv(data=skeletons, paths=paths, outpath=outpath)


if __name__ == '__main__':

    import argparse

    parser = argparse.ArgumentParser(description='create consensus of different labeled stacks in tiff-format')

    parser.add_argument('--inpath', required=True, help='Parent directory containing the 3(!) directories '
                                                        'with the labels')
    parser.add_argument('--outpath', required=True, help='Output-path for the consensus.')
    a = parser.parse_args()

    consensus(a.inpath, a.outpath)



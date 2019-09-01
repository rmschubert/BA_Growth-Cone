import os

import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle as rect

from tools.toolbox import read_csv, read_stack


def gcone_map(stack_path, outpath, coords_path, frame=0, size=64):

    """
    :param stack_path: path to original (not cropped) stack containing multiple growth-cones
    :param outpath: output-path where the image is saved
    :param coords_path: corresponding coordninate-file to the stack
    :param frame: desired frame which will be used, default is 0
    :param size: desired size used to build the rectangle (dimension of rectangle is 2*size x 2*size), default is 64

    Creates a map of the cropped growth-cones from a given stack by coordinates.
    """

    stack = read_stack(stack_path)
    im = stack[frame]
    coords = read_csv(coords_path)

    plt.imshow(im, cmap='gray')
    plt.axis('off')

    for i, (x, y) in enumerate(coords):
        new_xy = (x - size, y - size)
        rectangle = rect(new_xy, size*2, size*2, fill=False)
        plt.gca().add_patch(rectangle)

    name = 'gcone_map.png'
    plt.savefig(os.path.join(outpath, name))


if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument('--stack', help='path to original (not cropped) stack containing multiple growth-cones')
    parser.add_argument('--out_img', help='output-path where the image is saved')
    parser.add_argument('--coords', help='corresponding coordninate-file to the stack')
    parser.add_argument('--frame', type=int, help='desired frame which will be used, default is 0')
    parser.add_argument('--dim', type=int, help='desired size used to build the rectangle '
                                                '(dimension of rectangle is 2*size x 2*size), default is 64')

    a = parser.parse_args()

    if not os.path.exists(a.out_img):
        os.mkdir(a.out_img)

    gcone_map(a.stack, a.out_img, a.coords, a.frame, a.dim)

import os

from skimage.io import imsave, imread
import numpy as np
from scipy.spatial.distance import cdist
from skimage.morphology import skeletonize


def read_stack(inpath):
    stack = imread(inpath)
    return stack


def read_csv(csv_path):
    coords = np.genfromtxt(csv_path, delimiter=',')
    coords = np.asarray(coords, dtype=np.uint16)
    return coords


def get_name(inpath):
    name = os.path.basename(inpath)
    basename, _ = name.split('.')
    return basename


def get_stack_list(inpath):
    stks = []
    for file in os.listdir(inpath):
        if os.path.isfile(os.path.join(inpath, file)):
            name = os.path.basename(file)
            p = os.path.join(inpath, name)
            f = imread(p)
            stks.append(f)
    return stks


def save(outpath, name, file):

    if not os.path.exists(outpath):
        os.mkdir(outpath)
    imsave(os.path.join(outpath, name), file)


def normalize(image):
    norm_image = ((image - np.min(image)) / (np.max(image) - np.min(image))) * 255

    return norm_image


def precision(img, label, inv):
    img = img[:, :, 0] if len(img.shape) == 3 else img
    label = label[:, :, 0] if len(label.shape) == 3 else label

    if inv is True:
        img = np.logical_not(img)
        label = np.logical_not(label)

    comparison = np.logical_and(img, label)
    tp = np.sum(comparison)
    fp = np.sum(np.logical_and(np.logical_not(comparison), img))
    prec = 0 if (tp + fp) == 0 else tp / (tp + fp)

    return prec


def recall(img, label, inv):
    img = img[:, :, 0] if len(img.shape) == 3 else img
    label = label[:, :, 0] if len(label.shape) == 3 else label

    if inv:
        img = np.logical_not(img)
        label = np.logical_not(label)

    comparison = np.logical_and(img, label)
    tp = np.sum(comparison)
    fn = np.sum(np.logical_and(np.logical_not(comparison), label))
    rec = 0 if (tp + fn) == 0 else tp / (tp + fn)

    return rec


def jaccard_index(img, label, inv):
    img = img[:, :, 0] if len(img.shape) == 3 else img
    label = label[:, :, 0] if len(label.shape) == 3 else label

    if inv:
        img = np.logical_not(img)
        label = np.logical_not(label)

    comparison = np.logical_and(img, label)
    tp = np.sum(comparison)
    fp = np.sum(np.logical_and(np.logical_not(label), img))
    fn = np.sum(np.logical_and(label, np.logical_not(img)))
    ji = 0 if (tp + fp + fn) == 0 else tp / (tp + fp + fn)

    return ji


def imagefiles_to_points(filename_1, filename_2, inv, filter, threshold=127):
    """
    Adapted and modified based on the repository of Dr. Torsten Bullmann:
    https://github.com/tbullmann/mean_shortest_distance


    Read a image file, if not grayscale average all (color) channels
    and return a list with the pixels above threshold.
    :param filename: should contain an image
    :param threshold: whats true is above that threshold
    :param filter: additional filter to be applied, default is from skimage.morphology.skeletonize because it
    might be better to compare the "mid lines" in case of long, thin structures such as membranes or axons.
    Otherwise simply use filter=None
    :return: an N x 2 array with the pixel coordinates of the label
    """

    image_1 = imread(filename_1)
    image_2 = imread(filename_2)
    grayscale_image_1 = image_1.sum(axis=2)/3 if len(image_1.shape) > 2 else image_1
    grayscale_image_2 = image_2.sum(axis=2)/3 if len(image_2.shape) > 2 else image_2

    if not inv:
        pic_a = grayscale_image_1 > threshold
        pic_b = grayscale_image_2 > threshold
    else:
        pic_a = grayscale_image_1 < threshold
        pic_b = grayscale_image_2 < threshold

    if filter:
        pic_a = skeletonize(pic_a)
        pic_b = skeletonize(pic_b)

    if np.array(np.where(pic_a)).size == 0 or np.array(np.where(pic_b)).size == 0:
        return grayscale_image_1, grayscale_image_2
    else:
        return np.transpose(np.array(np.where(pic_a))), np.transpose(np.array(np.where(pic_b)))
        # cdist wants it the other way :-)


def shortest_distance(A_points, B_points):
    """
    Adapted and modified based on the repository of Dr. Torsten Bullmann:
    https://github.com/tbullmann/mean_shortest_distance


    Calculate distances between all points in A and all points in B
    and return the shortest distances from any point in A to some point in B.
    :param A_points: array containing the coordinates of points of A
    :param B_points: array containing the coordinates of points of B
    :return: vector of distances, one for each point A
    """
    from_A_to_B = cdist(A_points, B_points).min(axis=1)
    return from_A_to_B

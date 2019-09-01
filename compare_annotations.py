import os
import glob
import csv

from skimage.io import imread

from tools.toolbox import precision, recall, jaccard_index


def compare_annotators_to_consens(root, consens_path, output):

    """
    :param root: root-directory containing the directories of the annotators
    :param consens_path: path to the directory containing the consensus labels
    :param output: output-path where the csv-file will be saved

    Creates a csv-file containing the comparison of the annotators against the consensus.
    """

    consens_label = glob.glob(os.path.join(consens_path, '*.png'))

    with open(os.path.join(output, 'annotation_comparison.csv'), 'w') as f:
        stat_writer = csv.writer(f, delimiter=',')
        stat_writer.writerow(['Annotator', 'Image_number', 'Precision', 'Recall', 'JI'])

        for dir in os.listdir(root):

            h, t = os.path.split(dir)
            name = 'Annotator%s' % t
            for i, imgpath in enumerate(glob.glob(os.path.join(dir, '*.png'))):

                img = imread(imgpath)
                label = imread(consens_label[i])

                prec = precision(img, label, inv=False)
                rec = recall(img, label, inv=False)
                ji = jaccard_index(img, label, inv=False)

                prec = '%0.4f' % prec
                rec = '%0.4f' % rec
                ji = '%0.4f' % ji

                stat_writer.writerow([name, i, prec, rec, ji])


if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser()

    parser.add_argument('-root')
    parser.add_argument('-labelroot')
    parser.add_argument('-outpath')

    a = parser.parse_args()

    if not os.path.exists(a.outpath):
        os.mkdir(a.outpath)

    compare_annotators_to_consens(a.root, a.labelroot, a.outpath)



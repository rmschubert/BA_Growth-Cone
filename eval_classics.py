import re
import os
import glob
import itertools
import csv

import numpy as np
from skimage.io import imread

from tools.toolbox import precision, recall, jaccard_index, imagefiles_to_points, shortest_distance


def sort_by_method_and_imagename(root):

    """
    Sorts the root-directory containing the directories of the images by the classic method and by the image.
    """

    gamma, gamma_med, gamma_ots, log, log_med, log_ots = [], [], [], [], [], []

    for dir, subdir, filenames in os.walk(root):
        if len(filenames) != 0:
            h, t = os.path.split(dir)
            if t == 'gamma':
                gamma.append([os.path.join(dir, ''.join(r)) for r in
                              sorted([[''.join(x) for _, x in itertools.groupby(v, key=str.isdigit)]
                                      for v in filenames], key=lambda v: (int(v[0])))])
            elif t == 'gamma-med':
                gamma_med.append([os.path.join(dir, ''.join(r)) for r in
                                  sorted([[''.join(x) for _, x in itertools.groupby(v, key=str.isdigit)]
                                          for v in filenames], key=lambda v: (int(v[0])))])
            elif t == 'gamma-ots':
                gamma_ots.append([os.path.join(dir, ''.join(r)) for r in
                                  sorted([[''.join(x) for _, x in itertools.groupby(v, key=str.isdigit)]
                                          for v in filenames], key=lambda v: (int(v[0])))])
            elif t == 'log':
                log.append([os.path.join(dir, ''.join(r)) for r in
                            sorted([[''.join(x) for _, x in itertools.groupby(v, key=str.isdigit)]
                                    for v in filenames], key=lambda v: (int(v[0])))])
            elif t == 'log-med':
                log_med.append([os.path.join(dir, ''.join(r)) for r in
                                sorted([[''.join(x) for _, x in itertools.groupby(v, key=str.isdigit)]
                                        for v in filenames], key=lambda v: (int(v[0])))])
            elif t == 'log-ots':
                log_ots.append([os.path.join(dir, ''.join(r)) for r in
                                sorted([[''.join(x) for _, x in itertools.groupby(v, key=str.isdigit)]
                                        for v in filenames], key=lambda v: (int(v[0])))])

    return gamma, gamma_med, gamma_ots, log, log_med, log_ots


def parameter_mean_stats(root, label_path, inv, output):
    """
    :param root: root-path to the directories containing the manipulated images
    :param label_path: path to the label
    :param inv: if given the input labelpath must contain inverted labels
    :param output: output-path where the csv-file will be saved

    Creates an csv-file containing the mean-performance for the parameters.
    """

    labels = glob.glob(os.path.join(label_path, '*.png'))

    gamma, gamma_med, gamma_ots, log, log_med, log_ots = sort_by_method_and_imagename(root)

    methods = [(gamma, 'gamma'), (gamma_med, 'gamma-med'), (gamma_ots, 'gamma-ots'), (log, 'log'),
               (log_med, 'log-med'), (log_ots, 'log-ots')]

    filename = 'parameter_stats_inv.csv' if inv else 'parameter_stats.csv'
    with open(os.path.join(output, filename), 'w') as s:
        stat_writer = csv.writer(s, delimiter=',')
        stat_writer.writerow(['Parameter', 'Method', 'Precision', 'Recall', 'Jaccard_Index', 'MSD'])

        for n, (list_container, name) in enumerate(methods):
            for i in range(11):
                tmp_preds = []
                for filelist in list_container:
                    tmp_preds.append(filelist[i])
                pred_with_label = list(zip(tmp_preds, labels))

                tmp_precision, tmp_recall, tmp_ji, tmp_msd = [], [], [], []
                for k, (pred_path, lab_path) in enumerate(pred_with_label):
                    pred = imread(pred_path)
                    lab = imread(lab_path)
                    tmp_precision.append(precision(pred, lab, inv))
                    tmp_recall.append(recall(pred, lab, inv))
                    tmp_ji.append(jaccard_index(pred, lab, inv))
                    if inv:
                        threshold = 255
                    else:
                        threshold = 0

                    lab_points, pred_points = imagefiles_to_points(lab_path, pred_path, inv=inv,
                                                                   filter=True, threshold=threshold)
                    tmp_msd.append(np.mean(shortest_distance(lab_points, pred_points)))

                if re.match('gamma.*', name):
                    p = 0.01 + i * 0.001
                    print(i * 0.001)
                else:
                    p = 0.006 + i * 0.001

                parameter = '%0.3f' % p
                prec = '%0.4f' % (np.mean(tmp_precision))
                rec = '%0.4f' % (np.mean(tmp_recall))
                ji = '%0.4f' % (np.mean(tmp_ji))
                msd = '%0.4f' % (np.mean(tmp_msd))

                stat_writer.writerow([parameter, name, prec, rec, ji, msd])


def method_mean_stats(root, label_path, inv, output):
    """
    :param root: root-path to the directories containing the manipulated images
    :param label_path: path to the label
    :param inv: if given the input labelpath must contain inverted labels
    :param output: output-path where the csv-file will be saved

    Creates an csv-file containing the mean-performance for the methods.
    """

    labels = glob.glob(os.path.join(label_path, '*.png'))

    gamma, gamma_med, gamma_ots, log, log_med, log_ots = sort_by_method_and_imagename(root)

    methods = [(gamma, 'gamma'), (gamma_med, 'gamma-med'), (gamma_ots, 'gamma-ots'), (log, 'log'),
               (log_med, 'log-med'), (log_ots, 'log-ots')]

    filename = 'method_stats_inv.csv' if inv else 'method_stats.csv'

    with open(os.path.join(output, filename), 'w') as s:
        stat_writer = csv.writer(s, delimiter=',')
        stat_writer.writerow(
            ['Method', 'Precision_M', 'Precision_S', 'Recall_M', 'Recall_S', 'Jaccard_Index_M',
             'Jaccard_index_S', 'MSD_M', 'MSD_S'])

        for n, (list_container, name) in enumerate(methods):
            method_precision, method_recall, method_ji, method_msd = [], [], [], []

            for i in range(11):
                tmp_preds = []
                for filelist in list_container:
                    tmp_preds.append(filelist[i])
                pred_with_label = list(zip(tmp_preds, labels))

                tmp_precision, tmp_recall, tmp_ji, tmp_msd = [], [], [], []
                for k, (pred_path, lab_path) in enumerate(pred_with_label):
                    pred = imread(pred_path)
                    lab = imread(lab_path)

                    tmp_precision.append(precision(pred, lab, inv))
                    tmp_recall.append(recall(pred, lab, inv))
                    tmp_ji.append(jaccard_index(pred, lab, inv))
                    if inv:
                        threshold = 255
                    else:
                        threshold = 0

                    lab_points, pred_points = imagefiles_to_points(lab_path, pred_path, inv=inv,
                                                                   filter=True, threshold=threshold)
                    tmp_msd.append(np.mean(shortest_distance(lab_points, pred_points)))

                method_precision.append(np.mean(tmp_precision))
                method_recall.append(np.mean(tmp_recall))
                method_ji.append(np.mean(tmp_ji))
                method_msd.append(np.mean(tmp_msd))

            mean_precision = '%0.4f' % (np.mean(method_precision))
            std_precision = '%0.4f' % (np.std(method_precision))
            mean_recall = '%0.4f' % (np.mean(method_recall))
            std_recall = '%0.4f' % (np.std(method_recall))
            mean_ji = '%0.4f' % (np.mean(method_ji))
            std_ji = '%0.4f' % (np.std(method_ji))
            mean_msd = '%0.4f' % (np.mean(method_msd))
            std_msd = '%0.4f' % (np.std(method_msd))

            stat_writer.writerow([name, mean_precision, std_precision, mean_recall, std_recall,
                                  mean_ji, std_ji, mean_msd, std_msd])


def all_stats(root, label_root):
    """
    :param root: root-path to the directories containing the manipulated images
    :param label_root: root-path to all label of all annotators

    Creates an csv-file containing the performance of all by the classic methods generated images, compared to all
    annotations.
    """

    methods = ['gamma', 'gamma-med', 'gamma-ots', 'log', 'log-med', 'log-ots']
    filename = 'all_stats.csv'

    with open(filename, 'w') as n:
        stat_writer = csv.writer(n, delimiter=',')
        stat_writer.writerow(['Annotator', 'Typ', 'Methode', 'Präzision', 'Recall', 'JI', 'MSD'])
        for dir in os.listdir(root):
            for method in methods:
                for annotator in ['consens', 'anno1', 'anno2', 'anno3']:
                    for type in ['normal', 'inverted']:
                        clas_path = os.path.join(root, dir, method, '*.png')
                        classics = glob.glob(clas_path)
                        name = '%s.png' % dir
                        lab_path = os.path.join(label_root, annotator, type, name)
                        label = imread(lab_path)
                        if type == 'inverted':
                            inv = True
                            threshold = 255
                        else:
                            inv = False
                            threshold = 0

                        for classic_path in classics:
                            pred = imread(classic_path)

                            prec = precision(pred, label, inv)
                            rec = recall(pred, label, inv)
                            ji = jaccard_index(pred, label, inv)
                            lab_points, pred_points = imagefiles_to_points(lab_path, classic_path, inv,
                                                                           filter=True, threshold=threshold)
                            msd = np.mean(shortest_distance(lab_points, pred_points))

                            prec_s = '%0.4f' % prec
                            rec_s = '%0.4f' % rec
                            ji_s = '%0.4f' % ji
                            msd_s = '%0.4f' % msd

                            stat_writer.writerow([annotator, type, method, prec_s, rec_s, ji_s, msd_s])


if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser()

    parser.add_argument('--root', help='root for the directories containing the manipulated images')
    parser.add_argument('--label', help='path to the labels. if mode is "all" give the root directory containing all'
                                        'annotations')
    parser.add_argument('--inverted', choices=['True', 'False'], help='set True if the label-path contains inverted'
                                                                      ' label. not neccessary if mode is "all"')
    parser.add_argument('--mode', required=True, choices=['parameter', 'method', 'all'],
                        help='"parameter" creates csv-file containing'
                             'the mean performance of the parameters,'
                             '"method" creates csv-file containing '
                             'the mean performance of the methods,'
                             '"all" creates csv-file containing the'
                             'performance of all images produced by'
                             'the classic methods compared to all'
                             'annotations')

    parser.add_argument('--output', help='output-path where the csv-file will be saved')

    a = parser.parse_args()

    if a.inverted == 'True':
        inverted = True
    else:
        inverted = False

    if not os.path.exists(a.output):
        os.mkdir(a.output)

    if a.mode == 'parameter':
        parameter_mean_stats(a.root, a.label, inverted, a.output)
    elif a.mode == 'method':
        method_mean_stats(a.root, a.label, inverted, a.output)
    else:
        all_stats(a.root, a.label)



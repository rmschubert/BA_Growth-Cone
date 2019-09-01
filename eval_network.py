import os
import glob
import csv

import numpy as np
from skimage.io import imread

from tools.toolbox import precision, recall, jaccard_index, imagefiles_to_points, shortest_distance


def get_stats(root, output):

    """
    :param root: root-directory containing the test or training results
    :param output: output-path where the csv-files will be saved

    Creates a directory structure equal to the training/test structure with csv-files for the number of filter and
    epochs. Also there will be a csv-file created which summarizes the results for all filter and epochs in the corres-
    ponding subdirectory.
    """

    for annotator in ['consens', 'anno1', 'anno2', 'anno3']:
        for architecture in ['GAN', 'No-Gan']:
            for type in ['normal', 'inverted']:
                all_precision, all_recall, all_jacind, all_MSD = [], [], [], []
                for filter in ['8', '16', '32']:
                    for epochs in ['100', '200', '400']:
                        mean_precision, mean_recall, mean_jacind, mean_MSD = [], [], [], []

                        for i in ['1', '2', '3']:
                            if type == 'inverted':
                                inv = True
                            else:
                                inv = False

                            dir_name = '%s_%s_%s' % (filter, epochs, i)
                            tmp_path = os.path.join(root, annotator, architecture, type, dir_name, 'images')
                            tmp_predicts = glob.glob(os.path.join(tmp_path, '*outputs.png'))
                            tmp_labels = glob.glob(os.path.join(tmp_path, '*targets.png'))
                            preds_with_labels = list(zip(tmp_predicts, tmp_labels))

                            tmp_precision = []
                            tmp_recall = []
                            tmp_jacind = []
                            tmp_MSD = []
                            for k, (pred_path, label_path) in enumerate(preds_with_labels):
                                pred = imread(pred_path)
                                label = imread(label_path)
                                tmp_precision.append(precision(pred, label, inv))
                                tmp_recall.append(recall(pred, label, inv))
                                tmp_jacind.append(jaccard_index(pred, label, inv))
                                if inv:
                                    threshold = 255
                                else:
                                    threshold = 0
                                points_a, points_b = imagefiles_to_points(label_path, pred_path, inv=inv,
                                                                          threshold=threshold, filter=True)
                                tmp_MSD.append(np.mean(shortest_distance(points_a, points_b)))

                            mean_precision.append(np.mean(tmp_precision))
                            mean_recall.append(np.mean(tmp_recall))
                            mean_jacind.append(np.mean(tmp_jacind))
                            mean_MSD.append(np.mean(tmp_MSD))

                        filename = '%s_%s.csv' % (filter, epochs)
                        os.makedirs(os.path.join(output, annotator, architecture, type), exist_ok=True)
                        filepath = os.path.join(output, annotator, architecture, type, filename)

                        with open(filepath, 'w') as w:
                            writer = csv.writer(w, delimiter=',')
                            writer.writerow(['Precision_M', 'Precision_S', 'Recall_M', 'Recall_S', 'Jac_ind_M',
                                             'Jac_ind_S', 'MSD_M', 'MSD_S'])
                            prec_m = '%0.4f' % (np.mean(mean_precision))
                            rec_m = '%0.4f' % (np.mean(mean_recall))
                            ji_m = '%0.4f' % (np.mean(mean_jacind))
                            prec_s = '%0.4f' % (np.std(mean_precision))
                            rec_s = '%0.4f' % (np.std(mean_recall))
                            ji_s = '%0.4f' % (np.std(mean_jacind))
                            msd_m = '%0.4f' % (np.mean(mean_MSD))
                            msd_s = '%0.4f' % (np.std(mean_MSD))

                            all_precision.append(np.mean(mean_precision))
                            all_recall.append(np.mean(mean_recall))
                            all_jacind.append(np.mean(mean_jacind))
                            all_MSD.append(np.mean(mean_MSD))

                            writer.writerow([prec_m, prec_s, rec_m, rec_s, ji_m, ji_s, msd_m, msd_s])

                all_name = 'mean_all.csv'
                all_path = os.path.join(output, annotator, architecture, type, all_name)
                with open(all_path, 'w') as d:
                    all_writer = csv.writer(d, delimiter=',')
                    all_writer.writerow(
                        ['Precision_M', 'Precision_S', 'Recall_M', 'Recall_S', 'Jac_ind_M', 'Jac_ind_S', 'ad_RAND_M',
                         'ad_RAND_S', 'MSD_M', 'MSD_S'])
                    mean_precision_all = '%0.4f' % (np.mean(all_precision))
                    mean_recall_all = '%0.4f' % (np.mean(all_recall))
                    mean_ji_all = '%0.4f' % (np.mean(all_jacind))
                    mean_msd_all = '%0.4f' % (np.mean(all_MSD))
                    std_precision_all = '%0.4f' % (np.std(all_precision))
                    std_recall_all = '%0.4f' % (np.std(all_recall))
                    std_ji_all = '%0.4f' % (np.std(all_jacind))
                    std_msd_all = '%0.4f' % (np.std(all_MSD))

                    all_writer.writerow(
                        [mean_precision_all, std_precision_all, mean_recall_all, std_recall_all, mean_ji_all,
                         std_ji_all, mean_msd_all, std_msd_all])


def all_stats(root, outpath):

    """
    :param root: root-directory containing the test or training results
    :param output: output-path where the csv-file will be saved

    Creates an csv-file for all images which where predicted.
    """

    filename = os.path.join(outpath, 'all_stats.csv')

    with open(filename, 'w') as w:
        stat_writer = csv.writer(w, delimiter=',')
        stat_writer.writerow(['Annotator', 'Typ', 'Filter', 'Epochen', 'GAN', 'Nr', 'Präzision', 'Recall', 'MSD', 'JI'])
        for a in ['consens', 'anno1', 'anno2', 'anno3']:
            for g in ['GAN', 'No-Gan']:
                for t in ['normal', 'inverted']:
                    for f in ['8', '16', '32']:
                        for e in ['100', '200', '400']:
                            for i in ['1', '2', '3']:
                                if t == 'inverted':
                                    inv = True
                                    threshold = 255
                                else:
                                    inv = False
                                    threshold = 0

                                dir_name = '%s_%s_%s' % (f, e, i)
                                tmp_path = os.path.join(root, a, g, t, dir_name, 'images')
                                predictions = glob.glob(os.path.join(tmp_path, '*outputs.png'))
                                label = glob.glob(os.path.join(tmp_path, '*targets.png'))
                                predictions_and_label = list(zip(predictions, label))

                                for n, (pred_path, label_path) in enumerate(predictions_and_label):
                                    pred = imread(pred_path)
                                    lab = imread(label_path)

                                    prec = precision(pred, lab, inv)
                                    rec = recall(pred, lab, inv)
                                    lab_points, pred_points = imagefiles_to_points(label_path, pred_path, inv,
                                                                                   filter=True, threshold=threshold)
                                    msd = np.mean(shortest_distance(lab_points, pred_points))
                                    ji = jaccard_index(pred, lab, inv)

                                    prec_s = '%0.4f' % prec
                                    rec_s = '%0.4f' % rec
                                    msd_s = '%0.4f' % msd
                                    ji_s = '%0.4f' % ji

                                    if g == 'GAN':
                                        gan = 'yes'
                                    else:
                                        gan = 'no'
                                    row = [a, t, f, e, gan, i, prec_s, rec_s, msd_s, ji_s]
                                    stat_writer.writerow(row)


if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser()

    parser.add_argument('--root', help='root-directory containing the test or training results')
    parser.add_argument('--output', help='output-path where the csv-file(s) will be saved')
    parser.add_argument('--mode', required=True, choices=['summary', 'all'], help='choose "summary" to create csv-files'
                                                                                  'which summarize the performance of'
                                                                                  'the number of filter and epochs'
                                                                                  '(keeps directory structure)'
                                                                                  'choose "all" to create a csv-file '
                                                                                  'for all predicted images')

    a = parser.parse_args()

    if a.mode == 'summary':
        get_stats(a.root, a.output)
    else:
        all_stats(a.root, a.output)

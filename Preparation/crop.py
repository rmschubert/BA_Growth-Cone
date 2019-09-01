import os

from skimage.io import imsave

from tools.toolbox import get_name, read_stack, read_csv


def errors(data_name, outpath, err_values):

    err_id = data_name + '-error.txt'
    err_path = os.path.join(outpath, err_id)
    if err_values:
        err_file = open(err_path, 'w')
        for err in err_values:
            err_file.write(err)
        err_file.close()


def crop(stack_path, coordinate_path, size, output_path, position):

    """

    :param stack_path: filepath to the stack
    :param coordinate_path: filepath to the csv-file with the coordinates of the associated stack
    :param size: desired output size of the cropped stacks
    :param output_path: path where the stacks or the images will be saved
    :param position: desired frame-number of the stack. if given the output will be images of cropped stacks

    Creates cropped stacks OR images of cropped stacks. Dimension of the output is doubled by given size.
    Example:
    given size = 64
    dimension of output = 128x128

    Produces also an error.txt where the coordinates associated with an error, plus the shape and the
    filename is stored. If there are no errors no error.txt will be created.

    """

    stack = read_stack(stack_path)
    name = get_name(stack_path)
    coordinates = read_csv(coordinate_path)

    if not os.path.exists(output_path):
        os.mkdir(output_path)

    errs = []
    for i, (x, y) in enumerate(coordinates):
        cropped = stack[:, y - size:y + size, x - size:x + size]

        if position is not None:

            img = cropped[position]

            imgname = '%s-%03d-%s.tif' % (name, i, position)
            imgpath = os.path.join(output_path, imgname)

            try:
                imsave(imgpath, img)
            except ValueError:
                print("wrong size or wrong position statement")
        else:

            filename = '%s-%03d.tif' % (name, i)
            err_c = str((x, y)) + ' ' + filename + '\n'
            filepath = os.path.join(output_path, filename)
            for k in range(1, 3):
                if cropped.shape[k] in range(1, size*2):
                    err_val = 'wrong shape: ' + str(cropped.shape) + ' for ' + err_c
                    errs.append(err_val)
            try:
                imsave(filepath, cropped)
            except ValueError:
                err_val = 'cannot crop across borders ' + err_c
                errs.append(err_val)
                print('cannot crop across borders', (x, y), filename)

    errors(data_name=name, outpath=output_path, err_values=errs)


if __name__ == '__main__':

    import argparse
    parser = argparse.ArgumentParser(description='crop from stacks')

    parser.add_argument('--stack_path', help='filepath of the stack')
    parser.add_argument('--coords_path', help='filepath of the csv-file containing the coordinates, associated with '
                                              'the stack')
    parser.add_argument('--pos', type=int, help='Position of desired frame, if given the output will be images of the cropped stacks')
    parser.add_argument('--size', type=int, help='cropping window size. Example: given is 64 output will be 128x128')
    parser.add_argument('--outpath', help='The outpath for the files.')

    a = parser.parse_args()

    crop(stack_path=a.stack_path, coordinate_path=a.coords_path, size=a.size, output_path=a.outpath, position=a.pos)



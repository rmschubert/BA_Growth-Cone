## Hello and welcome to the repository of my bachelor-thesis

The thesis is about segmenting neuronal growth-cones in phase-contrast time-lapse recordings.
In this repository you'll find the Python- and R-code, which I used to process and evaluate my data.

### What's going on
To segment neuronal growth-cones one can use classic methods (such as Thresholding) or you can follow the trend
of using artificial intelligence i.e. neural networks. I tested some classic methods including the power-law
transformation and the logarithmic transformation.

See these links and paper for further information:\
__Links__
- [[Power-law and log-transformation]](https://scikit-image.org/docs/dev/api/skimage.exposure.html)
- [[Otsu-Threshold]](https://scikit-image.org/docs/dev/auto_examples/segmentation/plot_thresholding.html)
- [[Medianfilter]](https://docs.scipy.org/doc/scipy/reference/generated/scipy.signal.medfilt.html)

__Paper__
- [[Maini & Aggarwal 2010]](https://arxiv.org/ftp/arxiv/papers/1003/1003.4053.pdf)
- [[Bedi & Khandelwal 2013]](https://pdfs.semanticscholar.org/8e87/ea9bbe53ba39dd917a57d943c3ee9faebd55.pdf)

Furthermore I tested the __pix2pix__-model a (generating adverserial network) GAN proposed by 
([Isola et al. 2016 ](https://arxiv.org/pdf/1611.07004v1.pdf)).

Please also visit the repository containing the source code I used to train and test the model:\
[[Torsten Bullmann]](https://github.com/tbullmann/imagetranslation-tensorflow) 




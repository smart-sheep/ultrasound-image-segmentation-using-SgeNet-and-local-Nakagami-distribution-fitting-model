The code of the article "Cui W, Meng D, Lu K, et al. Automatic segmentation of ultrasound images using SegNet and local Nakagami distribution fitting model[J]. Biomedical Signal Processing and Control, 2023, 81: 104431."
The link of the article: https://doi.org/10.1016/j.bspc.2022.104431
Detailed steps of "LNDF" code use:
First, use "Tophi0.m" to convert the rough segmentation result into an initialization level set function.
Then, use "LNDFmain.m" to complete fine segmentation.

We show an example in the file, which can be run directly.
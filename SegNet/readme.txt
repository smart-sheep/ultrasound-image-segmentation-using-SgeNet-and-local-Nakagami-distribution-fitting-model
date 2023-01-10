The code of the article "Cui W, Meng D, Lu K, et al. Automatic segmentation of ultrasound images using SegNet and local Nakagami distribution fitting model[J]. Biomedical Signal Processing and Control, 2023, 81: 104431."
The link of the article: https://doi.org/10.1016/j.bspc.2022.104431
Detailed steps of "SegNet" code use:
First, prepare the dataset：
The ultrasonic image of the training data set corresponds to the marking results one by one, and they are placed in "images" and "labels" in "train" respectively. 
Similarly, validation sets and test sets are placed in corresponding folders. The location of all folders needs to be adjusted in the code. 

Then, train the model with "train_Segnet.m" , and use "Segnet_Seg.m" for segmentation.

The segmentation results need to be saved in a folder and converted using "ToBinaryResults. m". Folder name needs to be marked in code.


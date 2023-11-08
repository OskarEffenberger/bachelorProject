# [DeepMicro on Mgnify Bioms Galaxy Workflow](https://usegalaxy.eu/u/johannes.effenberger/w/copy-of-mgnify-ml-normalization)
## What it does
Takes Taxonimic assignments for Bioms from the [MGnify](https://www.ebi.ac.uk/metagenomics) Database and feeds them into a [DeepMicro Tool](https://usegalaxy.eu/?tool_id=toolshed.g2.bx.psu.edu%2Frepos%2Fiuc%2Fdeepmicro%2Fdeepmicro%2F1.4%2Bgalaxy1&version=latest), resulting in classification on a Biom level.
## Inputs
* 2 Bioms Strings from Mgnify (eg. **root:Engineered** or **root:Environmental:Aquatic:Freshwater:Drinking water:Chlorinated**), a list of possible bioms can be found [here](https://www.ebi.ac.uk/metagenomics/browse/biomes/).
* A jupyter notebook #ADD LINK, which saves Taxonomic assignmensts in 'outputs/collection'
* Max Samples, an integer limiting for how many samples the Notebook tries to find assignments. This input exists to reduce datasize and runtime for Bioms with large quantities of samples.
* A normalization method out of {Softmax,relative Abundance, Sigmoid, CSS, TMM,RLE}
* 8 Boolean paremeters, one for each Taxonomic level. (On False: all assignments for this Taxonomic level get filterd out)

!atleast one of the 8 Boolean parameters have to be true, otherwise the workflow will crash.

## Outputs
Results of the workflow are outputs from the [DeepMicro Tool](https://usegalaxy.eu/?tool_id=toolshed.g2.bx.psu.edu%2Frepos%2Fiuc%2Fdeepmicro%2Fdeepmicro%2F1.4%2Bgalaxy1&version=latest).
==> Table with the following header:  
'{Encoding}_{classifier}, AUC, ACC, Recall, Precision, F1_score, time-end, runtime(sec), classfication time(sec), best hyper-parameter'  
and matching values.
## Notebook
Annotation is inside the notebook.
## Filtering
Each filtering on a taxonimic level is made independent of other taxonomic levels.  
e.g.  
If superkingdom aswell as order are true:  
**sk__Bacteria;k__;p__;c__Candidatus_Babeliae;o__Candidatus_Babeliales;f__Candidatus_Babeliaceae**  
will count towards **sk__Bacteria** and **o__Candidatus_Babeliales**

## Normalization
After filtering and merging the assignment tables for each biom get normalized, to allow classification in regards to assignment distrebution and preventing classification in regards to the total cunt of assignments. For that diffrent normalization methods can be used.
* Relative Abundance
* Softmax normalization, to prevent overflow errors when we have large assignment values we first calculate relative abundance, and multiply the results of that by 100 before we use softmax normalization.
* Sigmoid normalization, after calculating sigmoid normalization we divide by 2 and add .5 to move our output range from [-1,1] to [0,1]
* CSS
* TMM
* RLE

! TMM and RLE are calculated using the [Limma Tool](https://usegalaxy.eu/?tool_id=toolshed.g2.bx.psu.edu%2Frepos%2Fiuc%2Flimma_voom%2Flimma_voom%2F3.50.1%2Bgalaxy0&version=latest) on Galaxy, resulting in longer calculation times.

## Example?

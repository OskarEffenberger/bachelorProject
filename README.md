# [DeepMicro on Mgnify Bioms Galaxy Workflow](https://usegalaxy.eu/u/johannes.effenberger/w/copy-of-mgnify-ml-normalization)
Link to Workflow : https://usegalaxy.eu/u/johannes.effenberger/w/copy-of-mgnify-ml-normalization
## What it does
![Image](https://github.com/OskarEffenberger/bachelorProject/blob/main/graphs/MgnifyMLAbstract_Fill.png)
Takes Taxonimic assignments for Bioms from the [MGnify](https://www.ebi.ac.uk/metagenomics) Database and feeds them into a [DeepMicro Tool](https://usegalaxy.eu/?tool_id=toolshed.g2.bx.psu.edu%2Frepos%2Fiuc%2Fdeepmicro%2Fdeepmicro%2F1.4%2Bgalaxy1&version=latest), resulting in classification on a Biom level.
## Inputs
* 2 Bioms Strings from Mgnify (eg. **root:Engineered** or **root:Environmental:Aquatic:Freshwater:Drinking water:Chlorinated**), a list of possible bioms can be found [here](https://www.ebi.ac.uk/metagenomics/browse/biomes/).
* A jupyter notebook [Get_analysis.ipynb](https://github.com/OskarEffenberger/bachelorProject/blob/main/notebooks/Get_analysis.ipynb) , which saves Taxonomic assignmensts in 'outputs/collection'
* Max Samples, an integer limiting for how many samples the Notebook tries to find assignments. This input exists to reduce datasize and runtime for Bioms with large quantities of samples.
* A normalization method out of {Softmax,relative Abundance, Sigmoid, CSS, TMM,RLE}
* 8 Boolean paremeters, one for each Taxonomic level. (On False: all assignments for this Taxonomic level get filterd out)

!atleast one of the 8 Boolean parameters have to be true, otherwise the workflow will crash.

## Outputs
Results of the workflow are outputs from the [DeepMicro Tool](https://usegalaxy.eu/?tool_id=toolshed.g2.bx.psu.edu%2Frepos%2Fiuc%2Fdeepmicro%2Fdeepmicro%2F1.4%2Bgalaxy1&version=latest).
==> Table with the following header:  
'{Encoding}_{classifier}, AUC, ACC, Recall, Precision, F1_score, time-end, runtime(sec), classfication time(sec), best hyper-parameter'  
and matching values.
# Subworkflows
### GetDataFromMgnifyAndJoin
![Image](https://github.com/OskarEffenberger/bachelorProject/blob/main/graphs/GetDataFromMgnifyAndJoinGraph.png)
Uses the [Interactive JupyTool and notebook](https://usegalaxy.eu/root?tool_id=interactive_tool_jupyter_notebook) tool comined with [Get_analysis.ipynb](https://github.com/OskarEffenberger/bachelorProject/blob/main/notebooks/Get_analysis.ipynb) to retrive Taxonomic assignments from Mgnify. Those are Then grouped according to the Boolean paramets for each Taxonomic level and Merged into one Table per biom in the end.
#### Input
* 2 Biom Identifier fom Mgnify
* [Get_analysis.ipynb](https://github.com/OskarEffenberger/bachelorProject/blob/main/notebooks/Get_analysis.ipynb) as notebook
* An integer setting a maximum number of samples (To allow usage of large bioms without downloading 50000 samples)
* Booleans, dictating on which taxinomic level the reads get grouped
#### Output
* 2 Tables (.tsv) with reads for each samples in the given Biom (row 1: Analysis-Accession, column 1: taxonomic type)
# Notebooks
### Get Analysis
[Get_analysis.ipynb](https://github.com/OskarEffenberger/bachelorProject/blob/main/notebooks/Get_analysis.ipynb)
![Image](https://github.com/OskarEffenberger/bachelorProject/blob/main/graphs/Get_Analysis_Notebook_Graph.png)
#### Input
A Biom identifier from Mgnify.

A maximim number of samples. (interger)
#### Output
Collection with Taxonomic assignments for each sample
### Get Analysis For Study
[Get_analysis_for_study.ipynb](https://github.com/OskarEffenberger/bachelorProject/blob/main/notebooks/Get_analysis_for_study.ipynb)
Gets Taxonomic assignments from Mgnify for 2 given Bioms and merges them into 2 Tabes. One for each Biom. These Tables are grouped by Taxonomic levels across the whole biom.
![Image](https://github.com/OskarEffenberger/bachelorProject/blob/main/graphs/Get_Analysis_Notebook_Graph.png)
#### Input
A Study Accession from Mgnify
#### Output
Collection with Taxonomic assignments for each sample of the given Study

# Normalization Workflow
Link to Workflow : https://usegalaxy.eu/u/johannes.effenberger/w/normalization
# INSERT GRAPH
This workflow noramlizes a given Table. 
## Normalization Methods
* Relative Abundance
* Softmax normalization, to prevent overflow errors when we have large assignment values we first calculate relative abundance, and multiply the results of that by 100 before we use softmax normalization.
* Sigmoid normalization, after calculating sigmoid normalization we divide by 2 and add .5 to move our output range from [-1,1] to [0,1]
* CSS
* TMM
* RLE
! TMM and RLE are calculated using the [Limma Tool](https://usegalaxy.eu/?tool_id=toolshed.g2.bx.psu.edu%2Frepos%2Fiuc%2Flimma_voom%2Flimma_voom%2F3.50.1%2Bgalaxy0&version=latest) on Galaxy, resulting in longer calculation times.
## Example?

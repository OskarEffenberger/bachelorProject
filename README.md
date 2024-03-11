# [DeepMicro on Mgnify Bioms Galaxy Workflow](https://usegalaxy.eu/u/johannes.effenberger/w/copy-of-mgnify-ml-normalization)
Link to workflow : https://usegalaxy.eu/u/johannes.effenberger/w/copy-of-mgnify-ml-normalization
## What it does
Abstract Graph
![Image](https://github.com/OskarEffenberger/bachelorProject/blob/main/graphs/MgnifyMLAbstract_Fill.png)
Detailed Graph
![Image](https://github.com/OskarEffenberger/bachelorProject/blob/main/graphs/CompleteWorkflowGraph.png)
Takes taxonimic assignments for biomes from the [MGnify](https://www.ebi.ac.uk/metagenomics) database and feeds them into a [DeepMicro Tool](https://usegalaxy.eu/?tool_id=toolshed.g2.bx.psu.edu%2Frepos%2Fiuc%2Fdeepmicro%2Fdeepmicro%2F1.4%2Bgalaxy1&version=latest), resulting in classification on a biome level.
## Inputs
* 2 biome strings from MGnify (eg. **root:Engineered** or **root:Environmental:Aquatic:Freshwater:Drinking water:Chlorinated**), a list of possible biomes can be found [here](https://www.ebi.ac.uk/metagenomics/browse/biomes/).
* A jupyter notebook [Galaxy_Get_analysis.ipynb](https://github.com/OskarEffenberger/bachelorProject/blob/main/notebooks/Galaxy_Get_analysis.ipynb) , which collects taxonomic assignmensts from MGnify
* A jupyter notebook [Galaxy_MergeTaxonomyByRank.ipynb](https://github.com/OskarEffenberger/bachelorProject/blob/main/notebooks/Galaxy_MergeTaxonomyByRank.ipynb) , which merges the taxonomic assignments of a all samples in a biome into a single table, filtered by given taxonomic rank.
* A taxonomic level on which [Galaxy_MergeTaxonomyByRank.ipynb](https://github.com/OskarEffenberger/bachelorProject/blob/main/notebooks/Galaxy_MergeTaxonomyByRank.ipynb) merges the assignments.
* Max Samples, an integer limiting for how many samples the notebook requests for each biome from the MGnify-API. This input exists to reduce datasize and runtime for biomes with large quantities of samples.
* A normalization method out of {Softmax,relative Abundance, Sigmoid, CSS, TMM,RLE}


## Outputs
Results of the workflow are outputs from the [DeepMicro Tool](https://usegalaxy.eu/?tool_id=toolshed.g2.bx.psu.edu%2Frepos%2Fiuc%2Fdeepmicro%2Fdeepmicro%2F1.4%2Bgalaxy1&version=latest).

Table with the following header:  
'{Encoding}_{classifier}, AUC, ACC, Recall, Precision, F1_score, time-end, runtime(sec), classfication time(sec), best hyper-parameter'  

And results of the different subworkflows wich are stored in the history.
# Subworkflows
### GetDataFromMgnifyAndJoin
![Image](https://github.com/OskarEffenberger/bachelorProject/blob/main/graphs/GetDataFromMgnifyAndJoinGraph.png)
Uses the [Interactive JupyTool and notebook](https://usegalaxy.eu/root?tool_id=interactive_tool_jupyter_notebook) tool comined with [Galaxy_Get_analysis.ipynb](https://github.com/OskarEffenberger/bachelorProject/blob/main/notebooks/Galaxy_Get_analysis.ipynb) to retrive taxonomic assignments from MGnify. Those are then grouped according to the pre defined taxonomic rank and merged into one table per biom through the usage of [Galaxy_MergeTaxonomyByRank.ipynb](https://github.com/OskarEffenberger/bachelorProject/blob/main/notebooks/Galaxy_MergeTaxonomyByRank.ipynb).
#### Input
* 2 biome identifier fom MGnify
* [Galaxy_Get_analysis.ipynb](https://github.com/OskarEffenberger/bachelorProject/blob/main/notebooks/Galaxy_Get_analysis.ipynb) as notebook
* [Galaxy_MergeTaxonomyByRank.ipynb](https://github.com/OskarEffenberger/bachelorProject/blob/main/notebooks/Galaxy_MergeTaxonomyByRank.ipynb) as notebook
* An integer setting a maximum number of samples (to allow usage of large bioms without downloading all samples of the biome)
* A taxonomic level on which the counts are grouped
#### Output
* 2 tables (.tsv), one for each biome with reads for each sample in the given biomes (row 1: Analysis-Accession, column 1: taxa)
### Normalization Subworkflow
Informations to normalization: [go to normalization workflow Section](#normalization-workflow)
# Notebooks
### Get Analysis
[Galaxy_Get_analysis.ipynb](https://github.com/OskarEffenberger/bachelorProject/blob/main/notebooks/Galaxy_Get_analysis.ipynb)
![Image](https://github.com/OskarEffenberger/bachelorProject/blob/main/graphs/Get_Analysis_Notebook_Graph.png)
Gets taxonomic assignments from MGnify for the given biome
#### Input
A biome identifier from MGnify.

A maximim number of samples. (interger)
#### Output
A collection with taxonomic assignments for each sample
### Get Analysis For Study
[Galaxy_Get_analysis_for_study.ipynb](https://github.com/OskarEffenberger/bachelorProject/blob/main/notebooks/Galaxy_Get_analysis_for_study.ipynb)
![Image](https://github.com/OskarEffenberger/bachelorProject/blob/main/graphs/Get_Analysis_For_Study_Notebook_Graph.png)
Gets taxonomic assignments from MGnify for all Samples of one Study.
#### Input
A study accession from MGnify
#### Output
Collection with taxonomic assignments for each sample of the given study

# Normalization Workflow
Link to workflow : https://usegalaxy.eu/u/johannes.effenberger/w/normalization
![Image](https://github.com/OskarEffenberger/bachelorProject/blob/main/graphs/FullNormalizationWF.png)
This workflow normalizes a given table using one of the following normalization methods 
## Normalization Methods
* Relative abundance
* Softmax normalization, to prevent overflow errors when we have large assignment values we first use relative abundance to normalize the table, and multiply the results of that by 100 before we apply softmax normalization.
* Sigmoid normalization, similar to softmax normalization, uses a table, normalized with relative abundance, as input to prevent overflow errors in calcualtion. After calculating sigmoid normalization we divide by 2 and add .5 to move our output range from [-1,1] to [0,1]
* CSS
* TMM
* RLE

! TMM and RLE are calculated using the [Limma Tool](https://usegalaxy.eu/?tool_id=toolshed.g2.bx.psu.edu%2Frepos%2Fiuc%2Flimma_voom%2Flimma_voom%2F3.50.1%2Bgalaxy0&version=latest) on Galaxy, resulting in longer calculation times.
## Exampledata and Run for the Workflow
Step 1

![Image](https://github.com/OskarEffenberger/bachelorProject/blob/main/picturesForGit/image_required_notebooks.png)

Load the [Galaxy_Get_analysis.ipynb](https://github.com/OskarEffenberger/bachelorProject/blob/main/notebooks/Galaxy_Get_analysis.ipynb) and [Galaxy_MergeTaxonomyByRank.ipynb](https://github.com/OskarEffenberger/bachelorProject/blob/main/notebooks/Galaxy_MergeTaxonomyByRank.ipynb) notebook into Galaxy

Step 2:

![Image](https://github.com/OskarEffenberger/bachelorProject/blob/main/picturesForGit/image_start_WF.png)

When starting the workflow select [Galaxy_Get_analysis.ipynb](https://github.com/OskarEffenberger/bachelorProject/blob/main/notebooks/Galaxy_Get_analysis.ipynb) as Get Data Notebook and [Galaxy_MergeTaxonomyByRank.ipynb](https://github.com/OskarEffenberger/bachelorProject/blob/main/notebooks/Galaxy_MergeTaxonomyByRank.ipynb) as Merge Taxonomy Notebook.

Step 3:

![Image](https://github.com/OskarEffenberger/bachelorProject/blob/main/picturesForGit/image_raw_and_merged_counts.png)

The Jupytool output collections are the taxonomic assignments for each sample (output from [Galaxy_Get_analysis.ipynb](https://github.com/OskarEffenberger/bachelorProject/blob/main/notebooks/Galaxy_Get_analysis.ipynb))
and the countTable are all merged reads for one biome (name of file changed depending on selected taxonomic level)


[Example Data 3 Jupytool Output Collection](https://github.com/OskarEffenberger/bachelorProject/tree/main/data/ExampleRunData/3%20JupyTool%20output%20collection)


[Example Data 6 Jupytool Output Collection](https://github.com/OskarEffenberger/bachelorProject/tree/main/data/ExampleRunData/6%20JupyTool%20output%20collection)


[Example Data 513 counttable](https://github.com/OskarEffenberger/bachelorProject/blob/main/data/ExampleRunData/Galaxy513-%5BcountTable%5D.tsv)


[Example Data 992 counttable](https://github.com/OskarEffenberger/bachelorProject/blob/main/data/ExampleRunData/Galaxy992-%5BcountTable%5D.tsv)


Step 4:

![Image](https://github.com/OskarEffenberger/bachelorProject/blob/main/picturesForGit/image_normalized_counts.png)

In normalized tables are the normalized count tables for both biomes. 


[Example Data Normalized Tables](https://github.com/OskarEffenberger/bachelorProject/tree/main/data/ExampleRunData/1170%20Normalized%20Table)

Step 5:

![Image](https://github.com/OskarEffenberger/bachelorProject/blob/main/picturesForGit/image_output_WF.png)

Output of the workflow is the result of the DeepMicro tool.


[Example Data DeepMicro Output](https://github.com/OskarEffenberger/bachelorProject/blob/main/data/ExampleRunData/Galaxy1195-%5BDeepMicro_on_data_1193_and_data_1194__Results%5D.tabular)

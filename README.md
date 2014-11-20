RODTRACKER

Tools to track rod-shaped cells 
====

### Input: Files with segmented cells

### Output: csv file with lineage trajectory


### COLOR CODING:

yellow=cell that apparently dissapeared (from current frame) or appeared (in next frame)

cyan=cell in current frame with more than 1 candidate (perhaps 2 daughter cells) in the next frame

blue=cell in current frame with exactly 1 candidate (perhaps 2 daughter cells) in the next frame

magenta=cell in next frame with more than 1 candidate in the current frame

red=cell in next frame with exactly 1 candidate in the current frame


### INSTRUCTIONS:

1. Set up the correct parameter values

2. Run read_data_fun to load data in matlab

3. Run graph_manualcorrection1_fun to do manual correction of cells (yellow cells only). 
You can switch between the current and next frame with "right click"

* To manually declare the lineage of a cell click on a cell in the "current frame"; then click on 
the two daughter cells (or twice in the same cell if it did not divide) in the "next frame".

* After a manual correction press ENTER to save it.

* If there are no more yellow cells in the current frame press ENTER to continue to next frame

4. Run graph_red_fun to do trivial corrections

5. Run graph_manualcorrection2_fun to check that there are no yellow cells in any current frame. 
Manually correct (as in step 3) if necessary.

6. Run graph_optimization_fun to get the most likely movement of cells

7. Run getdata_fun to get fluorescence data in mat file

8. Run getdata_csvfile_fun to save data in csv format


### FORMAT OF CSV FILE:

The csv file will have the lineage trajectories in the following tree format.

|       |        |         |         |        |         |         | 
| ----- | ------ | ------- | ------- | ------ | ------- | ------- | 
| cell1 |        |         |         |        |         |         | 
| cell1 |        |         |         |        |         |         |        
| cell1 |        |         |         |        |         |         |
|       | cell11 |         |         | cell12 |         |         |
|       | cell11 |         |         | cell12 |         |         |
|       | cell11 |         |         | cell12 |         |         |
|       | cell11 |         |         | cell12 |         |         |
|       |        | cell111 | cell112 | cell12 |         |         |
|       |        | cell111 | cell112 | cell12 |         |         |
|       |        | cell111 | cell112 |        | cell121 | cell122 | 
|       |        | cell111 | cell112 |        | cell121 | cell122 | 



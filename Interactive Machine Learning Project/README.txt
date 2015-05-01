Predict Interstitial Lung Tissue.
Define: ROI-region of interest

Contains:
3 - iPython Notebook files
1 - Example Image in .mat (MATLAB - opens in code)

Run:
1. ROI Selector
--Left mouse key drag to draw a red rectangle over Interstitial Lung Tissue
--Right mouse key drag to draw a green rectangle over healthy lung tissue

2. Classifiers
--Run all to select classifier with best accuracy
(or change code to select favorite classifier, currently on Logistic Regression)

3. Show Results New Selections
--Imports model and makes prediction on new image
--You can select new ROIs to add to classifier
--Red squares are clusters of yes prediction
--Yellow squares are mainly false positives (select these with RMK)

To Do:
Implement Feedback to Classifier
Use a better metric than Accuracy
Should be good for other images/ROIs

Most of the classification code was was scikit - learn.org,
The rest was cobble together by myself and my partner (who wishes to be anonymous)

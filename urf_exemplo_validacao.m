% Copyright (c) Philipp Wagner. All rights reserved.
% Licensed under the BSD license. See LICENSE file in the project root for full license information.

% load function files from subfolders aswell
addpath (genpath ('.'));

% load data
[X y width height names] = urf_readImages('/home/cleversonahum/ufpa-reconhecimento-face/att_faces/');

% Learn Eigenfaces with 100 components
eigenfaces_train = @(X,y) urf_eigenfaces(X,y,30);
eigenfaces_test = @(model, Xtest) urf_eigenfacesPredict(model, Xtest, 1);

% a 10-fold cross validation (per fold=0, debug=1)
cv1 = KFoldCV(X,y,10,eigenfaces_train, eigenfaces_test, 0, 1);
% tpr = tp / (tp+fp)
tpr_eigenfaces = cv1(1)/(cv1(1)+cv1(2));
fprintf(1,'TPR_{Eigenfaces}=%.2f%%\n', tpr_eigenfaces*100.0);
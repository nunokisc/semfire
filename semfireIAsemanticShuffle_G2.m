function semfireIAsemanticShuffle_G2(perc)

numdirs = size(dir('testImgDir/*.png'),1);
if numdirs > 0
    delete 'testImgDir/*.png';
end
numdirs = size(dir('testLabelDir/*.png'),1);
if numdirs > 0
    delete 'testLabelDir/*.png';
end
numdirs = size(dir('trainImgDir/*.png'),1);
if numdirs > 0
    delete 'trainImgDir/*.png';
end
numdirs = size(dir('trainLabelDir/*.png'),1);
if numdirs > 0
    delete 'trainLabelDir/*.png';
end

percToTest = perc;
imgDir = 'imgDir/';
imgs = imageDatastore(imgDir);
numImgs = numel(imgs.Files)
labelDir = 'labelDir/';
labels = imageDatastore(labelDir);
numLabels = numel(labels.Files)
if numImgs == numLabels
    imgsToTest = {};
    labelsToTest = {};
    imgsToTrain = {};
    labelsToTrain = {};
    count = 1;
    firstPosition = randi([1 numImgs - (numImgs * percToTest / 100)],1)
    lastPosition = (firstPosition + numImgs * percToTest / 100) - 1
    for c = firstPosition:lastPosition
        imgsToTest{c+1-firstPosition, 1} = imgs.Files{c};
        labelsToTest{c+1-firstPosition, 1} = labels.Files{c};
        copyfile(imgs.Files{c}, 'testImgDir/');
        copyfile(labels.Files{c}, 'testLabelDir/');
    end
    for c = 1:firstPosition-1
        imgsToTrain{count,1} = imgs.Files{c};
        labelsToTrain{count,1} = labels.Files{c};
        copyfile(imgs.Files{c}, 'trainImgDir/');
        copyfile(labels.Files{c}, 'trainLabelDir/');
        count = count + 1;
    end
    for c = lastPosition+1:numImgs
        imgsToTrain{count,1} = imgs.Files{c};
        labelsToTrain{count,1} = labels.Files{c};
        copyfile(imgs.Files{c}, 'trainImgDir/');
        copyfile(labels.Files{c}, 'trainLabelDir/');
        count = count + 1;
    end
end
end
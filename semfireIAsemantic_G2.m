doTraining = false;
perTest = 20;

if doTraining 
    %Mistura imagens e escolhe precentagem para teste e o resto para treino
    semfireIAsemanticShuffle_G2(perTest);
end

labelIDs = { ...
    
    % "Fuel"
    [
    255 255 255
    ]
    
    % "NotFuel" 
    [
    0 0 0
    ]
    };
classes = [
    "Fuel"
    "NotFuel"
    ];

trainImgDir = 'trainImgDir/';
imds = imageDatastore(trainImgDir);

trainLabelDir = 'trainLabelDir/';
pxds = pixelLabelDatastore(trainLabelDir,classes,labelIDs);
tbl = countEachLabel(pxds);
frequency = tbl.PixelCount/sum(tbl.PixelCount);

imdsTrain = imds;
numTrainingImages = numel(imdsTrain.Files)

imageSize = [360 480 3];
numClasses = numel(classes);
lgraph = segnetLayers(imageSize,numClasses,'vgg16');

imageFreq = tbl.PixelCount ./ tbl.ImagePixelCount;
classWeights = median(imageFreq) ./ imageFreq

pxLayer = pixelClassificationLayer('Name','labels','ClassNames',tbl.Name,'ClassWeights',classWeights);

lgraph = removeLayers(lgraph,'pixelLabels');
lgraph = addLayers(lgraph, pxLayer);
lgraph = connectLayers(lgraph,'softmax','labels');

options = trainingOptions('sgdm', ...
    'Momentum',0.9, ...
    'InitialLearnRate',1e-3, ...
    'L2Regularization',0.0005, ...
    'MaxEpochs',100, ...  
    'MiniBatchSize',3, ...
    'Shuffle','every-epoch', ...
    'VerboseFrequency',2);

pximds = pixelLabelImageDatastore(imds,pxds);


if doTraining    
    [net, info] = trainNetwork(pximds,lgraph,options);
else
    load('workspace_data/net_trained.mat');
    
    semfireIAeval_G2(classes,labelIDs,net);
end

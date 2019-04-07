function semfireIAeval_G2(classes,labelIDs,net)
    testImgDir = 'testImgDir/';
    imds = imageDatastore(testImgDir);

    testLabelDir = 'testLabelDir/';
    pxdsTest = pixelLabelDatastore(testLabelDir,classes,labelIDs);
    tblTest = countEachLabel(pxdsTest);
    frequencyTest = tblTest.PixelCount/sum(tblTest.PixelCount);
    imdsTest = imds;
    numTestingImages = numel(imdsTest.Files)
        cmap = classesColorMap();
        % Test Network on One Image
        I = read(imdsTest);
        C = semanticseg(I, net);
        B = labeloverlay(I,C,'Colormap',cmap,'Transparency',0.4);
        figure(1);
        imshow(B);
        title('Imagem processada pela network');
        pixelLabelColorbar(cmap, classes);
        expectedResult = read(pxdsTest);
        actual = uint8(C);
        expected = uint8(expectedResult);
        figure(2);
        imshowpair(actual, expected);
        title('Imagem da network sobre o expectavel');
        iou = jaccard(C, expectedResult);
        table(classes,iou)
        figure(3);
        imgExpectedOverlay = labeloverlay(I,expected,'Colormap',cmap,'Transparency',0.4);
        imshow(imgExpectedOverlay);
        title('Imagem do dataset');

    % Evaluate Trained Network
    pxdsResults = semanticseg(imdsTest,net,'WriteLocation',tempdir,'Verbose',false);

    metrics = evaluateSemanticSegmentation(pxdsResults,pxdsTest,'Verbose',false);

    metrics.ImageMetrics
    
    metrics.DataSetMetrics

    metrics.ClassMetrics
end
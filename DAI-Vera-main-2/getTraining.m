function trainedNetwork = getTraining(imdsTrain, imdsValid, option)

    if (strcmp(option, 'CNN') || strcmp(option, ''))
        trainedNetwork = getTrainingByCNN(imdsTrain, imdsValid);
    elseif (strcmp(option, 'UNET'))
        trainedNetwork = getTrainingByUNet(imdsTrain, imdsValid);
    end
    
end

function trainedNetwork = getTrainingByCNN(imdsTrain, imdsValid)
    layers = [
        imageInputLayer([512 512 1])

        convolution2dLayer(3,8,'Padding','same')
        batchNormalizationLayer
        reluLayer

        maxPooling2dLayer(2,'Stride',2)

        convolution2dLayer(3,16,'Padding','same')
        batchNormalizationLayer
        reluLayer

        maxPooling2dLayer(2,'Stride',2)

        convolution2dLayer(3,32,'Padding','same')
        batchNormalizationLayer
        reluLayer

        fullyConnectedLayer(2)
        softmaxLayer
        classificationLayer];

    options = trainingOptions('sgdm', ...
        'InitialLearnRate',0.01, ...
        'MaxEpochs',4, ...
        'Shuffle','every-epoch', ...
        'ValidationData',imdsValid, ...
        'ValidationFrequency',30, ...
        'Verbose',false, ...
        'Plots','training-progress');

    trainedNetwork = trainNetwork(imdsTrain,layers,options);
end

function trainedNetwork = getTrainingByUNet(imdsTrain, imdsValid)

    imageSize = [512 512];    % get original imagesize from imds
    numClasses = 5;                 % get actual num of classes from input
    encoderDepth = 1;               % can be left open or as an option
    % lgraph = unet3dLayers(imageSize,numClasses,'EncoderDepth',encoderDepth,'NumFirstEncoderFilters',16);
    % lgraph = unetLayers(imageSize,numClasses,'NumFirstEncoderFilters',16);
    lgraph = unetLayers(imageSize, numClasses);

    options = trainingOptions('sgdm', ...
            'InitialLearnRate',0.01, ...
            'MaxEpochs',4, ...
            'Shuffle','every-epoch', ...
            'ValidationData',imdsValid, ...
            'ValidationFrequency',30, ...
            'Verbose',false, ...
            'Plots','training-progress');
        
    trainedNetwork = trainNetwork(imdsTrain,lgraph,options);
end
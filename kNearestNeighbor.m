function [testaccuracy,trainaccuracy] = kNearestNeighbor(wpbcx,wpbcy, n, k)
accuracyTest = zeros(n,1);
accuracyTrain = zeros(n,1);
for i = 1:n
   [accuracyTest(i),accuracyTrain(i)] = kNearest(wpbcx,wpbcy,n,i,k);
end
testaccuracy = sum(accuracyTest)/n;
trainaccuracy = sum(accuracyTrain)/n;
end

function [accuracyTest,accuracyTrain] = kNearest(wbpcx,wbpcy,n,binIndex, k)

[trainSet, testSet] = splitData(wbpcx, n, binIndex);
[trainY, testY] = splitData(wbpcy, n, binIndex);
trainNum = size(trainSet, 1);
testNum = size(testSet, 1);
distanceMatrix = zeros(testNum, trainNum);
distanceMatrixTrain = zeros(trainNum, trainNum);

for i = 1:testNum
    a = testSet(i,:);
    for j = 1:trainNum
        b = trainSet(j,:);
        distanceMatrix(i,j) = euclideanDistance(a,b);
    end
end

for i = 1:trainNum
    a = trainSet(i,:);
    for j = 1:trainNum
        b = trainSet(j,:);
        distanceMatrixTrain(i,j) = euclideanDistance(a,b);
    end
end

estimateTestY = recognizeClass(distanceMatrix,trainY, k);
accuracyTest = getAccuracy(testY, estimateTestY);

estimateTestYTrain = recognizeClass(distanceMatrixTrain,trainY, k);
accuracyTrain = getAccuracy(trainY, estimateTestYTrain);
end

function estimateTestY = recognizeClass(distanceMatrix,trainY, k)

[dummySortedDistance, index] = sort(distanceMatrix,2);
kIndex = index( : , 1:k);
possibleTestY = trainY(kIndex);

estimateTestY = round(sum(possibleTestY, 2)/k);

for i = 1: size(estimateTestY,1)
    if(estimateTestY(i) == 0.5)
        estimateTestY(i) = possibleTestY(i,1);
    end
end
end

%n-folder cv 
function [trainSet, testSet] = splitData(originalSet, n, binIndex)

ratio = 1/n;
sampleNum = size(originalSet,1);
testingNum = floor(sampleNum*ratio);

testingStart = (binIndex-1)*testingNum + 1;
testingEnd = binIndex*testingNum;

trainSet = originalSet;
trainSet(testingStart:testingEnd,:) = [];
testSet = originalSet(testingStart:testingEnd,:);

end

function accuracy = getAccuracy(realY, estimateY)
accuracy = sum(realY==estimateY)/size(realY,1);
end

function distance = euclideanDistance(a, b)
distance = sqrt((a-b)*(a-b)');
end
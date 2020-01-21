close all;
clearvars -except images depths
id = 202;

rgb = images(:,:,:,id);
figure; imshow(rgb);

Lab = rgb2lab(rgb);
[rows, cols] = size(Lab,1,2);
X = reshape(Lab,[rows*cols,3]);

normX = normalize(X);
transX = transpose(normX);
bandwidth= .3;

[clustCentP1,point2clusterP1,cluster2dataCellP1] = HGMeanShiftCluster(transX,bandwidth,'gaussian');

tempX = X;
for vals = 1:length(cluster2dataCellP1)
    mRed = mean(X(cluster2dataCellP1{vals},1));
    mGreen = mean(X(cluster2dataCellP1{vals},2));
    mBlue = mean(X(cluster2dataCellP1{vals},3));
    for writeClustMean=1:length(cluster2dataCellP1{vals})
        tempX(cluster2dataCellP1{vals}(writeClustMean),1)= mRed;
        tempX(cluster2dataCellP1{vals}(writeClustMean),2)= mGreen;
        tempX(cluster2dataCellP1{vals}(writeClustMean),3)= mBlue;
    end
end

for D = 1:3
    for C=1:cols
        for R=1:rows
            output(R,C,D) = double(tempX(R+(C-1)*rows,D));
        end
    end
end

convert = lab2rgb(output);
figure; imshow(convert);
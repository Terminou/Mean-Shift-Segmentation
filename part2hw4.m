close all;
clearvars -except images depths
id = 171;
dep = double(depths(:,:,id));
rgb = images(:,:,:,id);
figure; imshow(rgb);
figure; imshow(dep, []);

Lab = rgb2lab(rgb);
Lab = cat(3,Lab,dep);

[rows, cols] = size(Lab,1,2);
X = reshape(Lab,[rows*cols,4]);

normX = normalize(X);
transX = transpose(normX);
bandwidth= .5;

[clustCentP2,point2clusterP2,cluster2dataCellP2] = HGMeanShiftCluster(transX,bandwidth,'gaussian');

tempX = X;
for vals = 1:length(cluster2dataCellP2)
    mRed = mean(X(cluster2dataCellP2{vals},1));
    mGreen = mean(X(cluster2dataCellP2{vals},2));
    mBlue = mean(X(cluster2dataCellP2{vals},3));
    for writeClustMean=1:length(cluster2dataCellP2{vals})
        tempX(cluster2dataCellP2{vals}(writeClustMean),1)= mRed;
        tempX(cluster2dataCellP2{vals}(writeClustMean),2)= mGreen;
        tempX(cluster2dataCellP2{vals}(writeClustMean),3)= mBlue;
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
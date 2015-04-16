function hm_kmeans( flip_imgur, masque, num_clust, iters )
%Performs a k-means clustering on the image
%   Recieves image and mask as input, applies the mask.
%   Assigns num_clust amount of centroids. Then iterates through
%   the update state iter number of times.
if masque ~= -1
    % Change the masking from -1 to 0
    mask_idx = masque==-1;
    masque(mask_idx)=0;

    % Apply the mask to all slices in img
    masked_flip_imgur = masque .* flip_imgur(:,:,1);
    for s = 2:(length(flip_imgur(1,1,:)))
        masked_flip_imgur = cat(3,masked_flip_imgur,masque .* flip_imgur(:,:,s));
    end

    % Flip the image to the proper orientation
    imgur = fliplr(masked_flip_imgur);
else
    imgur = flip_imgur;
end

% Get the mean along the 3rd dimension (i.e. X/Y)
means = mean(imgur, 3);

%% Assignment
% Establish arrays
% centroids:    to hold the value of the centroids (cluster
%               center points)
% c_indices:    Get the index values of the centroids
% SoS:          Holds the sum of Squares values for each centroid
centroids    = zeros(1, num_clust);
c_indices    = zeros(1, num_clust, 'uint16');
SoS          = [];

% Work on only the brain regions
tru_idx = means~=0;
brain_means = means(tru_idx);

% Get the size of the brain_means array for use as a parameter
[length_means, other] = size(brain_means(:));

% Randomly generate the initial centroids
for s = 1:num_clust
    
    while c_indices(s)==0 || ~any(c_indices(s)==c_indices)
        c_indices(s) = randi([1 length_means],1,1);
    end
    
    centroids(s) = brain_means(c_indices(s));
    
end

% Calculate the sum of squares to determine how 'close' each point is
% for initial assignment
% Access each individual SoS(:,index)
for s = 1:num_clust
    SoS = cat(2,SoS,(brain_means - centroids(s)).^2);
end

% cluster_sets: The set of each cluster
cluster_sets = zeros(length(SoS), num_clust);

% Assign each point to a cluster_set
for s = 1:length(SoS)
    [test_var,idx] = min(SoS(s,:));
    cluster_sets(s, idx) = brain_means(s);
end

% Define the sections
Sections = [];
for s = 1:num_clust
    Sections = cat(3,Sections,means);
    temp = Sections(:,:,s);
    temp(tru_idx) = cluster_sets(:,s);
    Sections(:,:,s) = temp;
end

%% Start the Loop
% The number of iterations, including the initial one
for s = 2:iters
    % Re-calculate the new centroids based on the clusters
    for s = 1:num_clust
        temp = cluster_sets(:,s);
        temp_idx = temp~=0;
        centroids(s) = mean(temp(temp_idx));
    end

    % Establish arrays
    SoS          = [];

    % Calculate the sum of squares to determine how 'close' each point is
    % for initial assignment
    % Note: to access each individual SoS(:,index)
    for s = 1:num_clust
        SoS = cat(2,SoS,(brain_means - centroids(s)).^2);
    end

    % cluster_sets: The set of each cluster
    cluster_sets = zeros(length(SoS), num_clust);

    % Assign each point to a cluster_set
    for s = 1:length(SoS)
        [test_var,idx] = min(SoS(s,:));
        cluster_sets(s, idx) = brain_means(s);
    end

    % Define the sections
    Sections = [];
    [r, c] = size(tru_idx);
    for s = 1:num_clust
        Sections = cat(3,Sections,means);
        temp = Sections(:,:,s);
        temp(tru_idx) = cluster_sets(:,s);
        Sections(:,:,s) = temp;
    end
    
end

%% Display the results
% 'a' moves the cluster forward, 'd' moves the cluster back
% 'q' quits the figure
f = figure;
h = imshow(means, [], 'InitialMag', 'fit');
red = cat(3, ones(size(means)), zeros(size(means)), zeros(size(means)));
hold on;
h = imshow(red);
hold off;
s = 1;
title(num2str(s))
set(h, 'AlphaData', Sections(:,:,s));
k=0;
while ~k
    k=waitforbuttonpress;
    if strcmp(get(gcf,'currentcharacter'),'d');
        s=s+1;
        if s > num_clust
            s = 1;
        end
        set(h, 'AlphaData', Sections(:,:,s));
    end
    if strcmp(get(gcf,'currentcharacter'),'a');
        s=s-1;
        if s == 0
            s = num_clust;
        end
        set(h, 'AlphaData', Sections(:,:,s));
    end
    if ~strcmp(get(gcf,'currentcharacter'),'q');
        k=0;
    end
    title(num2str(s))
end

close

end



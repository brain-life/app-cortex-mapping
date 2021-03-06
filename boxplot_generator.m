function boxplot_generator(subj)

format long g;

dataDir = ['/N/dc2/projects/lifebid/Concussion/concussion_real/' ...
           'cortex_mapping_test/' subj '/label'];
outDir = fullfile(dataDir,'images');
statsDir = fullfile(dataDir,'stats');
mkdir(statsDir);
mkdir(outDir);
       
ROIs = {'bankssts','caudalanteriorcingulate','caudalmiddlefrontal',...
        'cuneus','entorhinal','fusiform','inferiorparietal',...
        'inferiortemporal','isthmuscingulate','lateraloccipital',...
        'lateralorbitofrontal','lingual','medialorbitofrontal',...
        'middletemporal','parahippocampal','paracentral','parsopercularis',...
        'parsorbitalis','parstriangularis','pericalcarine','postcentral',...
        'posteriorcingulate','precentral','precuneus','rostralanteriorcingulate',...
        'rostralmiddlefrontal','superiorfrontal','superiorparietal',...
        'superiortemporal','supramarginal','frontalpole','temporalpole',...
        'transversetemporal','insula'};

metric = [];
metric.name = {'fa','md','rd','ad','icvf','od','isovf'};
hemi = {'lh','rh'};
pgNum = [1 2];
for ii = 1:length(hemi)
    data.hemi{ii}.name = hemi{ii};
end

for ii = 1:length(ROIs)
    for ll = 1:length(hemi)
        y{1,ii} = ii - .35;
        y{2,ii} = ii + .1;
        box{ll,ii} = [y{ll,ii} (y{ll,ii} + .3)];
    end
end
        
for ii = 1:length(ROIs)
    for jj = 1:length(metric.name)
        for ll = 1:length(hemi)
            data.hemi{ll}.file{jj,ii} = dlmread([dataDir '/' metric.name{jj} '/' hemi{ll} '.' ROIs{ii} '.label.txt']);
            data.hemi{ll}.metric{jj,ii} = data.hemi{ll}.file{jj,ii}(:,5);
            data.hemi{ll}.percentile{jj,ii} = prctile(data.hemi{ll}.metric{jj,ii},[25 50 75],1);
            data.hemi{ll}.IQR(jj,ii) = data.hemi{ll}.percentile{jj,ii}(3) - data.hemi{ll}.percentile{jj,ii}(1);
            data.hemi{ll}.IQR_max(jj) = max(data.hemi{ll}.IQR(jj,:));
            data.hemi{ll}.whisker_upper{jj,ii} = data.hemi{ll}.percentile{jj,ii}(3) + 1.5*(data.hemi{ll}.IQR(jj,ii));
            data.hemi{ll}.whisker_lower{jj,ii} = data.hemi{ll}.percentile{jj,ii}(1) - 1.5*(data.hemi{ll}.IQR(jj,ii));
            if data.hemi{ll}.whisker_lower{jj,ii} <= 0
                data.hemi{ll}.whisker_lower{jj,ii} = 0;
            end
            data.hemi{ll}.outlier_upper{jj,ii} = data.hemi{ll}.metric{jj,ii}(data.hemi{ll}.metric{jj,ii} > data.hemi{ll}.whisker_upper{jj,ii});
            data.hemi{ll}.n_outlier_upper{jj,ii} = length(data.hemi{ll}.outlier_upper{jj,ii});
            data.hemi{ll}.outlier_lower{jj,ii} = data.hemi{ll}.metric{jj,ii}(data.hemi{ll}.metric{jj,ii} < data.hemi{ll}.whisker_lower{jj,ii});
            data.hemi{ll}.n_outlier_lower{jj,ii} = length(data.hemi{ll}.outlier_lower{jj,ii});
            data.hemi{ll}.mean{jj,ii} = mean(data.hemi{ll}.metric{jj,ii});
            data.hemi{ll}.median{jj,ii} = data.hemi{ll}.percentile{jj,ii}(2);
            data.hemi{ll}.x_median{jj,ii} = data.hemi{ll}.median{jj,ii} * ones(length(1:2));
            data.hemi{ll}.y_mid{jj,ii} = mean(box{ll,ii}) * ones(length(1:2));
            data.hemi{ll}.x_top{jj,ii} = [data.hemi{ll}.percentile{jj,ii}(3) data.hemi{ll}.whisker_upper{jj,ii}];
            data.hemi{ll}.x_bottom{jj,ii} = [data.hemi{ll}.percentile{jj,ii}(1) data.hemi{ll}.whisker_lower{jj,ii}];
            data.hemi{ll}.y_mid_outliers_above{jj,ii} = mean(box{ll,ii}) * ones(data.hemi{ll}.n_outlier_upper{jj,ii});
            data.hemi{ll}.y_mid_outliers_below{jj,ii} = mean(box{ll,ii}) * ones(data.hemi{ll}.n_outlier_lower{jj,ii});
            data.hemi{ll}.max_outlier{jj,ii} = max(data.hemi{ll}.outlier_upper{jj,ii});
            data.hemi{ll}.min_outlier{jj,ii} = min(data.hemi{ll}.outlier_lower{jj,ii});
            data.hemi{ll}.max_whisker{jj,ii} = max(data.hemi{ll}.whisker_upper{jj,ii});
            data.hemi{ll}.min_whisker{jj,ii} = min(data.hemi{ll}.whisker_lower{jj,ii});            
            data.outdir = outDir;
        end
    end
end

for ii = 1:length(ROIs)
    for ll = 1:length(hemi)
        data.hemi{ll}.metric_count(ii) = length(data.hemi{ll}.metric{1,ii});
    end
end

for ll = 1:length(hemi)
    data.hemi{ll}.metric_count_max = max(data.hemi{ll}.metric_count);
end

for jj = 1:length(metric.name)
    data.IQR_max(jj) = max([data.hemi{1}.IQR_max(jj) data.hemi{2}.IQR_max(jj)]);
end

data.metric_count_max = max([data.hemi{1}.metric_count_max data.hemi{2}.metric_count_max]);

%% Plot generation
for jj = 1:length(metric.name)
    max_lh_outlier(jj) = max([data.hemi{1}.max_outlier{jj,:}]);
    max_rh_outlier(jj) = max([data.hemi{2}.max_outlier{jj,:}]);
    max_lh_whisker(jj) = max([data.hemi{1}.max_whisker{jj,:}]);
    max_rh_whisker(jj) = max([data.hemi{2}.max_whisker{jj,:}]);
    max_outlier(jj) = max([max_lh_outlier(jj) max_rh_outlier(jj)]);
    max_outlier(jj) = round(max_outlier(jj),1);
    max_whisker(jj) = max([max_lh_whisker(jj) max_rh_whisker(jj)]);
    max_whisker(jj) = round(max_whisker(jj),1);
    if max_outlier(jj) > max_whisker(jj)
        xlim(jj,:) = [0 (max_outlier(jj) + 0.1)];
    else
        xlim(jj,:) = [0 (max_whisker(jj) + 0.1)];
    end
    boxPlotsROI(data,ROIs,jj,xlim,y,box);
end

for jj = 1:length(metric.name)
    for nn = 1:length(pgNum)
        histogramROI_generator(data,pgNum(nn),ROIs,jj,xlim)
    end
end

%% Save stats file
save(fullfile(statsDir,sprintf('%s_stats.mat',subj)),'data','xlim','y','box','max_lh_outlier','max_lh_whisker','max_rh_outlier','max_rh_whisker','max_outlier','max_whisker','-v7.3');

clear();
end

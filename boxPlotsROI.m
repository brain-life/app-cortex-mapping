function boxPlotsROI(data,ROIs,metric,xlim,y,box)

name = {'FA','MD','RD','AD','ICVF','OD','ISOVF'};
h.tpfig = figure('name',sprintf('ROI-%s',name{metric}),'color','w','visible','on','pos',[10 10 2500 2500]);
hold on;
set(gca,'ylim',[0 35],'Ytick',1:length(ROIs),'Yticklabel',ROIs,'xlim',xlim,'fontsize',20);

Title_plot = title(strcat(sprintf('ROI-%s',name{metric})),'Interpreter','none');
ylabel('ROI');
xlh = ylabel(sprintf(name{metric}));
xticks('auto');
%tickangle(45);

hold on;
for ii = 1:length(ROIs)
    for ll = 1:length(1:2)
        rec_lh = rectangle('position',[data.hemi{1}.percentile{metric,ii}(1) y{1,ii}  (data.hemi{1}.percentile{metric,ii}(3) - data.hemi{1}.percentile{metric,ii}(1)) .3],'edgecolor','g');
        rec_rh = rectangle('position',[data.hemi{2}.percentile{metric,ii}(1) y{2,ii}  (data.hemi{2}.percentile{metric,ii}(3) - data.hemi{2}.percentile{metric,ii}(1)) .3],'edgecolor','b');
        plot(data.hemi{ll}.x_median{metric,ii},box{ll,ii},'color','r');
        plot(data.hemi{ll}.x_top{metric,ii}, data.hemi{ll}.y_mid{metric,ii},'k--.');
        plot(data.hemi{ll}.x_bottom{metric,ii},data.hemi{ll}.y_mid{metric,ii},'k--.');
        plot(data.hemi{ll}.outlier_upper{metric,ii},data.hemi{ll}.y_mid_outliers_above{metric,ii},'rx');
        plot(data.hemi{ll}.outlier_lower{metric,ii},data.hemi{ll}.y_mid_outliers_below{metric,ii},'rx');
    end
end

z = zeros(2, 1);
z(1) = plot(NaN,NaN,'sg');
z(2) = plot(NaN,NaN,'sb');
h_legend = legend(z, 'LH','RH','Location','Northeast');
set(h_legend,'FontSize',20);
hold off;
saveas(h.tpfig,fullfile(data.outdir,sprintf('%s_rois',name{metric})),'png');
close(h.tpfig);
clear('h.tpfig');

function histogramROI_generator(data,pgNum,ROIs,metric_num,xlim)

%% Plot location specifications
fig = figure('units','points','position',[0 0 2000 800]);
bottom = 734.25;
left = 50;
w = 900;
h = 45;
%nbins(jj) =  round(range([xlim(jj,:)] / (2 * data.IQR_max(jj) / data.metric_count_max^(1/3))));
nbins = [72    45    48    51    40    58    31];

switch metric_num
    case 1
        linspa = linspace(0,1,nbins(1));
    case 2
        linspa = linspace(0,3,nbins(2));
    case 3
        linspa = linspace(0,3,nbins(3));
    case 4
        linspa = linspace(0,3.5,nbins(4));
    case 5
        linspa = linspace(0,1.5,nbins(5));
    case 6
        linspa = linspace(0,1.5,nbins(6));
    otherwise
        linspa = linspace(0,1.5,nbins(7));
end

%% Set indexes for lh and rh
odd = {1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33};
even = {2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34};
name = {'FA','MD','RD','AD','ICVF','OD','ISOVF'};
    
%% Odd plots (lh)
if pgNum == 1
    for ii = 1:length(odd)
        x{ii} = subplot(17,2,odd{ii});
        [counts{ii},centers{ii}] = hist(data.hemi{1}.metric{metric_num,ii},linspa);
        max_tick(ii) = roundn(max(counts{ii}),2) + 100;
        bar(centers{ii},counts{ii},'barwidth',1,'facecolor','g');
        ca{ii} = gca;
        if ii == 17
            set(ca{ii},'ylim',[0 max_tick(ii)]);
        else
        set(ca{ii},'ylim',[0 max_tick(ii)],'ytick',[(max_tick(ii)/2) max_tick(ii)]);
        end
    end
    
    for ii = 1:length(odd)
        if ii == 17
            set(ca{ii},'units','points','position',[left (bottom - (h * (ii - 1))) w h],'xlim',xlim(metric_num,:));
        else
        set(ca{ii},'units','points','position',[left (bottom - (h * (ii - 1))) w h],'xlim',xlim(metric_num,:),'xtick',[]);
        end
        legend(ca{ii},sprintf('lh %s',ROIs{ii}));
    end
end

if pgNum == 2
    for ii = 1:length(odd)
        x{ii} = subplot(17,2,odd{ii});
        [counts{ii},centers{ii}] = hist(data.hemi{1}.metric{metric_num,(17 + ii)},linspa);
        max_tick(ii) = roundn(max(counts{ii}),2) + 100;
        bar(centers{ii},counts{ii},'barwidth',1,'facecolor','g');
        ca{ii} = gca;
        if ii == 17
            set(ca{ii},'ylim',[0 max_tick(ii)]);
        else
        set(ca{ii},'ylim',[0 max_tick(ii)],'ytick',[(max_tick(ii)/2) max_tick(ii)]);
        end
    end
    
    for ii = 1:length(odd)
        if ii == 17
            set(ca{ii},'units','points','position',[left (bottom - (h * (ii - 1))) w h],'xlim',xlim(metric_num,:));
        else
        set(ca{ii},'units','points','position',[left (bottom - (h * (ii - 1))) w h],'xlim',xlim(metric_num,:),'xtick',[]);
        end
        legend(ca{ii},sprintf('lh %s',ROIs{(17 + ii)}));
    end
end

clear('ca','x','max_tick','counts','centers');

%% Even (rh)
if pgNum == 1
    for ii = 1:length(even)
        x{ii} = subplot(17,2,even{ii});
        [counts{ii},centers{ii}] = hist(data.hemi{2}.metric{metric_num,ii},linspa);
        max_tick(ii) = roundn(max(counts{ii}),2) + 100;
        bar(centers{ii},counts{ii},'barwidth',1);
        ca{ii} = gca;
        if ii == 17
            set(ca{ii},'ylim',[0 max_tick(ii)]);
        else
            set(ca{ii},'ylim',[0 max_tick(ii)],'ytick',[(max_tick(ii)/2) max_tick(ii)]);
        end
    end
    
    for ii = 1:length(odd)
        if ii == 17
            set(ca{ii},'units','points','position',[(left + w + 30) (bottom - (h * (ii - 1))) w h],'xlim',xlim(metric_num,:));
        else
            set(ca{ii},'units','points','position',[(left + w + 30) (bottom - (h * (ii - 1))) w h],'xlim',xlim(metric_num,:),'xtick',[]);
        end
        legend(ca{ii},sprintf('rh %s',ROIs{ii}));
    end
end

if pgNum == 2
    for ii = 1:length(even)
        x{ii} = subplot(17,2,even{ii});
        [counts{ii},centers{ii}] = hist(data.hemi{2}.metric{metric_num,(17 + ii)},linspa);
        max_tick(ii) = roundn(max(counts{ii}),2) + 100;
        bar(centers{ii},counts{ii},'barwidth',1);
        ca{ii} = gca;
        if ii == 17
            set(ca{ii},'ylim',[0 max_tick(ii)]);
        else
            set(ca{ii},'ylim',[0 max_tick(ii)],'ytick',[(max_tick(ii)/2) max_tick(ii)]);
        end
    end
    
    for ii = 1:length(odd)
        if ii == 17
            set(ca{ii},'units','points','position',[(left + w + 30) (bottom - (h * (ii - 1))) w h],'xlim',xlim(metric_num,:));
        else
            set(ca{ii},'units','points','position',[(left + w + 30) (bottom - (h * (ii - 1))) w h],'xlim',xlim(metric_num,:),'xtick',[]);
        end
        legend(ca{ii},sprintf('rh %s',ROIs{(17 + ii)}));
    end
end

clear('ca','x','max_tick','counts','centers');

p = mtit(strcat(sprintf('%s %s',name{metric_num},num2str(pgNum))),'fontsize',15);

saveas(fig,fullfile(data.outdir,sprintf('hist_%s_rois_%s',name{metric_num},num2str(pgNum))),'png');
close(fig);
end

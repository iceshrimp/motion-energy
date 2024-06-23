%% 根据d_prime对trial进行分类
d_range = 0:0.5:4;
d_range(1) = -0.5;

whole.Hit = cell(length(d_range)-1,1);
whole.CR = cell(length(d_range)-1,1);
whole.Miss = cell(length(d_range)-1,1);
whole.FA = cell(length(d_range)-1,1);

path = 'E:\学习工作\Zhao Lab\脑网络项目\运动检测\20240615';%换电脑后注意修改盘符
cd (path)
file_train = dir('*result.mat'); % 遍历该文件夹下所有文件夹
file_num = length(file_train);
%%
for yy = 1:file_num
    clearvars -except file_num file_train path yy d_range whole
    load([path,'\',file_train(yy).name]);

    Hit.d_prime_index = cell(length(d_range)-1,1);
    CR.d_prime_index = cell(length(d_range)-1,1);
    Miss.d_prime_index = cell(length(d_range)-1,1);
    FA.d_prime_index = cell(length(d_range)-1,1);

    for d = 1:length(Hit.d_prime_index)
        temp_index =  find(trial.Hit(:,end) >= d_range(d) & trial.Hit(:,end) < d_range(d+1));
        Hit.d_prime_index{d} = temp_index;
        whole.Hit{d} = [whole.Hit{d};trial.Hit(Hit.d_prime_index{d},1:end-1)];%whole.xxx第一列储存各d_prime分组的trial运动能量信息
    end
    %调用svd信息的时候使用trial.Hit(Hit.d_prime_index{d},1:end-1);
    for d = 1:length(CR.d_prime_index)
        temp_index =  find(trial.CR(:,end) >= d_range(d) & trial.CR(:,end) < d_range(d+1));
        CR.d_prime_index{d} = temp_index;
        whole.CR{d} = [whole.CR{d};trial.CR(CR.d_prime_index{d},1:end-1)];
    end
    
    if isempty(trial.Miss)
        continue
    else
        for d = 1:length(Miss.d_prime_index)
            temp_index =  find(trial.Miss(:,end) >= d_range(d) & trial.Miss(:,end) < d_range(d+1));
            Miss.d_prime_index{d} = temp_index;
            whole.Miss{d} = [whole.Miss{d};trial.Miss(Miss.d_prime_index{d},1:end-1)];
        end
    end

    for d = 1:length(FA.d_prime_index)
        temp_index =  find(trial.FA(:,end) >= d_range(d) & trial.FA(:,end) < d_range(d+1));
        FA.d_prime_index{d} = temp_index;
        whole.FA{d} = [whole.FA{d};trial.FA(FA.d_prime_index{d},1:end-1)];
    end

end
%% 【废弃，不要用！】大循环部分结束，接下来对得到的whole数据进行处理：求平均、分bin、求方差
% for d = 1:8 %或用 length(d_range)-1
%     whole.Hit{d,2} = nanmean(whole.Hit{d});%whole.xxx第二列储存运动能量的平均值，按帧计算，使用nanmean避免Nan数据的干扰
%     whole.Hit{d,3} = reshape(whole.Hit{d,2},[16,length(whole.Hit{d,2})/16]);%whole.xxx第三列将运动能量的平均值分为16*40的矩阵，即16个200ms time bin
%     whole.Hit{d,4} = mean(whole.Hit{d,3},2)';%whole.xxx第四列为第三列内容按行求平均值后转置，得到16个time bin各自的平均运动能量
%     whole.Hit{1,5}(d,:) = normalize(whole.Hit{d,4});%whole.xxx第五列将第四列内容归一化后储存在一起，便于做图
%     
%     whole.CR{d,2} = nanmean(whole.CR{d});
%     whole.CR{d,3} = reshape(whole.CR{d,2},[16,length(whole.CR{d,2})/16]);
%     whole.CR{d,4} = mean(whole.CR{d,3},2)';whole.CR{1,5}(d,:) = normalize(whole.CR{d,4});
%     
%     whole.Miss{d,2} = nanmean(whole.Miss{d});
%     whole.Miss{d,3} = reshape(whole.Miss{d,2},[16,length(whole.Miss{d,2})/16]);
%     whole.Miss{d,4} = mean(whole.Miss{d,3},2)';whole.Miss{1,5}(d,:) = normalize(whole.Miss{d,4});
%     
%     whole.FA{d,2} = nanmean(whole.FA{d});
%     whole.FA{d,3} = reshape(whole.FA{d,2},[16,length(whole.FA{d,2})/16]);
%     whole.FA{d,4} = mean(whole.FA{d,3},2)';whole.FA{1,5}(d,:) = normalize(whole.FA{d,4});
%     
% end
%save('grouping_trials_by_d_prime.mat',"whole","-mat");保存信息用

%% 大循环部分结束，接下来对得到的whole数据进行处理：求平均、分bin
for d = 1:8
    whole.Hit{d,2} = nanmean(whole.Hit{d});%whole.xxx第二列储存运动能量的平均值，按帧计算，使用nanmean避免Nan数据的干扰
    whole.Hit{d,3} = reshape(whole.Hit{d,2},[length(whole.Hit{d,2})/16,16]);%whole.xxx第三列将运动能量的平均值分为40*16的矩阵，即16个200ms time bin列
    whole.Hit{d,4} = mean(whole.Hit{d,3},1);%whole.xxx第四列为第三列内容按列求平均值，得到16个time bin各自的平均运动能量
    whole.Hit{1,5}(d,:) = normalize(whole.Hit{d,4});%whole.xxx第五列将第四列内容归一化后储存在一起，便于做图

    whole.CR{d,2} = nanmean(whole.CR{d});
    whole.CR{d,3} = reshape(whole.CR{d,2},[length(whole.CR{d,2})/16,16]);
    whole.CR{d,4} = mean(whole.CR{d,3},1);
    whole.CR{1,5}(d,:) = normalize(whole.CR{d,4});

    whole.Miss{d,2} = nanmean(whole.Miss{d});
    whole.Miss{d,3} = reshape(whole.Miss{d,2},[length(whole.Miss{d,2})/16,16]);
    whole.Miss{d,4} = mean(whole.Miss{d,3},1);
    whole.Miss{1,5}(d,:) = normalize(whole.Miss{d,4});
    
    whole.FA{d,2} = nanmean(whole.FA{d});
    whole.FA{d,3} = reshape(whole.FA{d,2},[length(whole.FA{d,2})/16,16]);
    whole.FA{d,4} = mean(whole.FA{d,3},1);
    whole.FA{1,5}(d,:) = normalize(whole.FA{d,4});
end
save('grouping_trials_by_d_prime_20240616.mat',"whole","-mat");%保存信息用
%% 做图
% xname = num2cell(-0.3:0.2:2.7);
% yname = {'0-0.5','0.5-1','1-1.5','1.5-2','2-2.5','2.5-3','3-3.5','3.5-4'};
% xlabel='Time from visual stim on(sec)';
% ylabel='d-prime';
% 
% figure()
% hit = heatmap(xname, yname, whole.Hit{1,5});
% hit.CellLabelColor = 'none';colormap(gca, 'parula');
% hit.xlabel(xlabel);hit.ylabel(ylabel);hit.Title='Hit';
% 
% figure()
% cr = heatmap(xname, yname, whole.CR{1,5});
% cr.CellLabelColor = 'none';colormap(gca, 'parula');
% cr.xlabel(xlabel);cr.ylabel(ylabel);cr.Title='CR';
% 
% figure()
% miss = heatmap(xname, yname, whole.Miss{1,5});
% miss.CellLabelColor = 'none';colormap(gca, 'parula');
% miss.xlabel(xlabel);miss.ylabel(ylabel);miss.Title='Miss';
% 
% figure()
% fa = heatmap(xname, yname, whole.FA{1,5});
% fa.CellLabelColor = 'none';colormap(gca, 'parula');
% fa.xlabel(xlabel);fa.ylabel(ylabel);fa.Title='FA';
%% imagesc做图
% xname = num2cell(-400:200:2800);
yname = {'0-0.5','0.5-1','1-1.5','1.5-2','2-2.5','2.5-3','3-3.5','3.5-4'};
% xlabel='Time from visual stim on(sec)';
% ylabel='d-prime';

figure()
hit = imagesc(whole.Hit{1,5});
colorbar;colormap('parula');
xlabel('Time from visual stim on(ms)');ylabel('d-prime');
yticklabels(yname);xticks([2 6 14]);xticklabels({'-200-0','600-800','2200-2400'});xtickangle(45);
title('Hit');

figure()
cr = imagesc(whole.CR{1,5});
colorbar;colormap('parula');
xlabel('Time from visual stim on(ms)');ylabel('d-prime');
yticklabels(yname);xticks([2 6 14]);xticklabels({'-200-0','600-800','2200-2400'});xtickangle(45);
title('CR');

figure()
miss = imagesc(whole.Miss{1,5});
colorbar;colormap('parula');
xlabel('Time from visual stim on(ms)');ylabel('d-prime');
yticklabels(yname);xticks([2 6 14]);xticklabels({'-200-0','600-800','2200-2400'});xtickangle(45);
title('Miss');

figure()
fa = imagesc(whole.FA{1,5});
colorbar;colormap('parula');
xlabel('Time from visual stim on(ms)');ylabel('d-prime');
yticklabels(yname);xticks([2 6 14]);xticklabels({'-200-0','600-800','2200-2400'});xtickangle(45);
title('FA');

% hit = heatmap(xname, yname, whole.Hit{1,5});
% hit.CellLabelColor = 'none';colormap(gca, 'parula');
% hit.xlabel(xlabel);hit.ylabel(ylabel);hit.Title='Hit';
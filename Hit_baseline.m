% load('G:\motion energy 20240620\20240615\grouping_trials_by_d_prime_20240616.mat')
miss = whole.Miss;
hit = load('D:\fcc_done\20240620 motion-baseline\Hit_treated.mat');

%% 数据生成-准备工作
d_range = 0:0.5:4;
d_range(1) = -0.5;

whole.Hit = cell(length(d_range)-1,1);
whole.CR = cell(length(d_range)-1,1);
whole.Miss = cell(length(d_range)-1,1);
whole.FA = cell(length(d_range)-1,1);

path = 'D:\fcc_done\20240620 motion-baseline\result 20240620\rebulid for hit';%换电脑后注意修改盘符
cd (path)
file_train = dir('*trial.mat'); % 遍历该文件夹下所有文件夹
file_num = length(file_train);
%% 数据生成-whole
for yy = 1:file_num
    clearvars -except file_num file_train path yy d_range whole
    load([path,'\',file_train(yy).name]);

    Hit.d_prime_index = cell(length(d_range)-1,1);
    CR.d_prime_index = cell(length(d_range)-1,1);
    Miss.d_prime_index = cell(length(d_range)-1,1);
    FA.d_prime_index = cell(length(d_range)-1,1);

    for d = 1:length(Hit.d_prime_index)
        temp_index =  find(trial.Hit(:,641) >= d_range(d) & trial.Hit(:,641) < d_range(d+1));
        Hit.d_prime_index{d} = temp_index;
        whole.Hit{d} = [whole.Hit{d};trial.Hit(Hit.d_prime_index{d},:)];%whole.xxx第一列储存各d_prime分组的trial运动能量信息
    end

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

%% 测试部分
temp_hit_2 = hit{1,1};
temp_hit_2(:,77:85) = nan;temp_hit_2(:,237:245) = nan;
baseline1 = mean(mean(temp_hit_2(:,86:95))) - mean(mean(temp_hit_2(:,1:75)));
% baseline2 = mean(mean(temp_hit_2(:,541:640))) - mean(mean(temp_hit_2(:,1:75)));
% baseline2 = nanmean(nanmean(miss{1,1}(:,300:600))) - mean(mean(temp_hit_2(:,1:75)));
baseline2 = nanmean(nanmean(miss{1,1}(:,300:600))) - nanmean(nanmean(miss{1,1}(:,1:75)));
temp_hit_2(:,86:236) = temp_hit_2(:,86:236) - baseline1;
for num_of_trial = 1:size(hit{1,1},1)
    temp_hit_2(num_of_trial,246:temp_hit_2(num_of_trial,642)) = temp_hit_2(num_of_trial,246:temp_hit_2(num_of_trial,642)) - baseline1;
%     temp_hit_2(num_of_trial,temp_hit_2(num_of_trial,642) + 1:640) = temp_hit_2(num_of_trial,temp_hit_2(num_of_trial,642) + 1:640) - 
end
temp_hit_mean = nanmean(temp_hit_2(:,1:640));
figure;plot(temp_hit_mean)

%% 去除反应时间过长的trial(>500)
hit = whole.Hit;
for d = 1:8
    hit{d}(hit{d}(:,642)>640,:) = [];
end
for d = 1:8
    hit{d}(hit{d}(:,642)>500,:) = [];
end
%% 正式代码
% load('D:\fcc_done\20240620 motion-baseline\Hit_treated.mat'); %先导入hit或定义hit
% hit = whole.Hit;

for d = 1:8
    hit{d}(hit{d}(:,642)>640,:) = [];% 去除反应时间过长的trial(>640)
end
for d = 1:8
    temp_hit = hit{d,1};
    temp_hit(:,77:85) = nan;temp_hit(:,237:245) = nan;
    
    baseline_gray = nanmean(nanmean(temp_hit(:,1:75))); %使用baseline_gray作为全局基线
    baseline1 = mean(mean(temp_hit(:,86:95))) - baseline_gray; %baseline1为屏幕亮起造成的亮度升高
%     baseline2 = nanmean(nanmean(temp_hit(:,541:640)));
    temp_hit(:,1:76) = temp_hit(:,1:76) - baseline_gray;
    temp_hit(:,86:236) = temp_hit(:,86:236) - baseline1;

    for num_of_trial = 1:size(hit{d,1},1)
        temp_hit(num_of_trial,246:temp_hit(num_of_trial,642)) = ...
            temp_hit(num_of_trial,246:temp_hit(num_of_trial,642)) - baseline1;
    end
    temp_hit(:,86:640) = temp_hit(:,86:640) - baseline_gray;
    hit{d,2} = nanmean(temp_hit(:,1:640));
    hit{d,3} = reshape(hit{d,2},[40,16]);
    hit{d,4} = nanmean(hit{d,3},1);
    hit{1,5}(d,:) = hit{d,4};
end
%%
figure;imagesc(hit{1,5})
colorbar;colormap('parula');
yname = {'0-0.5','0.5-1','1-1.5','1.5-2','2-2.5','2.5-3','3-3.5','3.5-4'};
xlabel('Time from visual stim on(ms)');ylabel('d-prime');yticklabels(yname);
xticks([2 6 14]);xticklabels({'-200-0','600-800','2200-2400'});xtickangle(45);
title('Hit trials motion energy');

figure;hold on
for d = 1:8
    plot(hit{1,5}(d,:))
end
legend('d-prime 0-0.5','d-prime 0.5-1','d-prime 1-1.5','d-prime 1.5-2',...
    'd-prime 2-2.5','d-prime 2.5-3','d-prime 3-3.5','d-prime 3.5-4')
xlabel('Time from visual stim on(ms)');ylabel('motion energy');title('Hit trials motion energy');
xticks([2 6 14]);xticklabels({'-200-0','600-800','2200-2400'});xtickangle(45);
hold off
%%
figure;hold on
for d = 1:8
    plot(hit{d,2})
end
legend('d-prime 0-0.5','d-prime 0.5-1','d-prime 1-1.5','d-prime 1.5-2',...
    'd-prime 2-2.5','d-prime 2.5-3','d-prime 3-3.5','d-prime 3.5-4')
xlabel('Time from visual stim on(ms)');ylabel('motion energy');title('Hit trials motion energy');
xticks([80 240 560]);xticklabels({'0','800','2400'});
hold off
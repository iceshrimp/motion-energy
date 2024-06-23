%%将识别出的所有trial，按照trial类型进行分类保存，
%%并且在最后一列添加d_prime信息
%%该脚本调用D_prime.m，数据来源继承自check_trialnum_2.m
%%该脚本并不生成新的mat文件，在已有result文件中新添"trial"

path = 'D:\fcc_done\20240620 motion-baseline\result 20240620';
cd (path)
file_train_0620 = dir('*result.mat'); % 遍历该文件夹下所有文件夹
file_num_0620 = length(file_train_0620);
%%
for pp = 5:file_num_0620
%     clearvars -except file_num file_train path kk
    % data_path = [path,'\',file_train(kk).name];
    load([path,'\',file_train_0620(pp).name]);

    motion_path = ['F:\MV-CA016-10UC (00K64848132)\',file_train_0620(pp).name(1:12)];
    cd(motion_path)
    motion_file_path = dir('*proc.mat');
    load(motion_file_path.name,"motion_1");

    %对motion energy降噪
    motion_1_copy = motion_1;
    TF = isoutlier(motion_1);
    motion_1_copy(TF) = nan;%变化异常的点改为nan
    motion_1 = fillmissing(motion_1_copy,"movmean",20);
    clearvars TF motion_1_copy

    clearvars -except file_num_0620 file_train_0620 path pp motion_1 log timepoints_frame
%     clearvars trial
    cd (path)
    D_prime();%先计算d_prime
    trial.match = [log.res_vector',timepoints_frame(:,1),d_prime];
    trial.Hit = [];
    trial.CR = [];
    trial.Miss = [];
    trial.FA = [];
    for trialnum = 1:length(log.res_vector')
        if trial.match(trialnum,2) == 0 
            continue
        end
        if isnan(trial.match(trialnum,2) )
            continue
        end
        if trial.match(trialnum,1) == 1
            trial.Hit = [trial.Hit;motion_1(trial.match(trialnum,2)-80:trial.match(trialnum,2)+559),...
                trial.match(trialnum,3),82+timepoints_frame(trialnum,2)-timepoints_frame(trialnum,1)];
            %取视觉信号出现前400ms，后2800ms，共计640帧
%             trial.Hit(end,641) = trial.match(trialnum,3);
        elseif trial.match(trialnum,1) == 2
            trial.CR = [trial.CR;motion_1(trial.match(trialnum,2)-80:trial.match(trialnum,2)+559),...
                trial.match(trialnum,3)];
        elseif trial.match(trialnum,1) == -1
            trial.Miss = [trial.Miss;motion_1(trial.match(trialnum,2)-80:trial.match(trialnum,2)+559),...
                trial.match(trialnum,3)];
        elseif trial.match(trialnum,1) == -2
            trial.FA = [trial.FA;motion_1(trial.match(trialnum,2)-80:trial.match(trialnum,2)+559),...
                trial.match(trialnum,3)];
        end
    end
    
    trial.match(find(trial.match(:,2) == 0),:) = [];%将所有识别错误的trial从trial.match中删除
    trial.framepoints = timepoints_frame;
    % 查找包含 NaN 值的行
    rowsWithNaN = any(isnan(trial.match), 2);
    % 删除包含 NaN 值的行
    trial.match_fixed = trial.match(~rowsWithNaN, :);
    trial.framepoints_fixed = trial.framepoints(~rowsWithNaN, :);

%     trial.Hit(:,641) = trial.match(find(trial.match == 1),3);%将d_prime写入对应的trial的第641列
%     trial.CR(:,641) = trial.match(find(trial.match == 2),3);
%     trial.Miss(:,641) = trial.match(find(trial.match == -1),3);
%     trial.FA(:,641) = trial.match(find(trial.match == -2),3);
   
    save ([path,'\rebulid for hit\',file_train_0620(pp).name(1:12),'-trial'], "trial")
    
end
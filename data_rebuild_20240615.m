path = 'G:\MV-CA016-10UC (00K64848132)\code\fcc_done\result';
cd (path)
file_train = dir('*#*'); % 遍历该文件夹下所有文件夹
file_train(1:4,:) = [];
ftrain_num = length(file_train);
for filenum = 1:ftrain_num
    clearvars -except path file_train ftrain_num filenum
    motion_path = ['G:\MV-CA016-10UC (00K64848132)\',file_train(filenum).name(1:12)];
    cd(motion_path)
    motion_file_path = dir('*proc.mat');
    load(motion_file_path.name,"motion_1");
    trial_result_path = [path,'\',file_train(filenum).name];
    load(trial_result_path,'trial');
%对motion energy降噪
    motion_1_copy = motion_1;
    TF = isoutlier(motion_1);
    motion_1_copy(TF) = nan;%变化异常的点改为nan
    motion = fillmissing(motion_1_copy,"movmean",20);
    clearvars TF motion_1_copy
%根据trial.match提取motion energy
    trial.Hit = [];numHit = 1;
    trial.CR = [];numCR = 1;
    trial.Miss = [];numMiss = 1;
    trial.FA = [];numFA = 1;
    for trialnum = 1:length(trial.match)
        if trial.match(trialnum,2) == 0
            continue
        end
        if trial.match(trialnum,1) == 1
            %取视觉信号出现前400ms，后2800ms，共计640帧，前80，后560
            for framenum = 1:640
                trial.Hit(numHit,framenum) = motion(trial.match(trialnum,2)-80+framenum-1);
            end
            trial.Hit(numHit,641) = trial.match(trialnum,3);
            numHit = numHit+1;
        elseif trial.match(trialnum,1) == 2
            for framenum = 1:640
                trial.CR(numCR,framenum) = motion(trial.match(trialnum,2)-80+framenum-1);
            end
            trial.CR(numCR,641) = trial.match(trialnum,3);
            numCR = numCR+1;
        elseif trial.match(trialnum,1) == -1
            for framenum = 1:640
                trial.Miss(numMiss,framenum) = motion(trial.match(trialnum,2)-80+framenum-1);
            end
            trial.Miss(numMiss,641) = trial.match(trialnum,3);
            numMiss = numMiss+1;
        elseif trial.match(trialnum,1) == -2
            for framenum = 1:640
                trial.FA(numFA,framenum) = motion(trial.match(trialnum,2)-80+framenum-1);
            end
            trial.FA(numFA,641) = trial.match(trialnum,3);
            numFA = numFA+1;
        end
    end
    
    savepath = ['E:\学习工作\Zhao Lab\脑网络项目\运动检测\20240615\',file_train(filenum).name];
    save(savepath,"trial","motion_path");

%     figure;plot(mean_cr,"Color","r","LineWidth",1);title("high-performance CR mean-motion-energy")
%     line([80,80],[800,1700],'linestyle','--');
%     line([240,240],[800,1700],'linestyle','--');
% 
%     figure;plot(mean_hit,"Color","r","LineWidth",1);title("high-performance Hit mean-motion-energy")
%     line([80,80],[800,1700],'linestyle','--');
%     line([240,240],[800,1700],'linestyle','--');
end
%%

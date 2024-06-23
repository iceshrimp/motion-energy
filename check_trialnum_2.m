%%该脚本用来检查通过亮度变化计算出的trial数与行为数据记录的trial数之间的差值
%%内置了show_function用来进行亮度检测划分trial，需保存数据时修改61行

load('G:\motion energy 20240620\运动检测\date_list.mat');%视情况可能需要把路径盘符改一下
load('G:\motion energy 20240620\运动检测\filelist.mat');
num_list = [];
data_num = 1;
for mouse = 68:69
    for date = 7:26
        light_file = ['G:\motion energy 20240620\运动检测\lighten and svd','\',num2str(date_list(date,2)),'_#',num2str(mouse),'.mat'];
        behavior_file = ['G:\motion energy 20240620\运动检测\Video mouse 68 69','\C57#0',num2str(mouse),'-d',num2str(date,'%03d'),'-P11GNG_S3_GoNoGo_Ardu.mat'];
        load(light_file);
        load(behavior_file);
%% show_function        
        %ave_lighten = mean(lighten)+5000;%平均数算法 注意这里加了5000！
        ave_lighten = median(lighten)+1500;%中位数算法
        timepoints_frame = [];
        trial = 1;
        for num = 2:length(lighten)
            if lighten(num,1) > ave_lighten
                if lighten(num-1) > ave_lighten
                    continue
                else timepoints_frame(trial,1) = num;%保存亮起来的第一帧
                end
            else
                if lighten(num-1) > ave_lighten
                   timepoints_frame(trial,2) = num-1;%保存亮起来的最后一帧，而不是暗下去的第一帧
                   trial = trial + 1;       
                else continue
                end
            end
        end
        
        if timepoints_frame(end,2) == 0
           timepoints_frame(end,:) = [];%删除没有拍摄完的最后一个trial（如果有的话）
        end
        if timepoints_frame(1,1) == 0
           timepoints_frame(1,:) = [];
        end
        
        for ii = 1:length(timepoints_frame)
            intrial_mean_lighten = mean(lighten(timepoints_frame(ii,1):timepoints_frame(ii,2)));
            for xx = timepoints_frame(ii,1):timepoints_frame(ii,2)
                if lighten(xx) > intrial_mean_lighten
                    timepoints_frame(ii,3) = xx;
                    break
                end
            end
        end
        timepoints_frame(:,4)=timepoints_frame(:,3)-timepoints_frame(:,1);
        timepoints_frame(timepoints_frame(:,4)<140,:) = nan;
        trial_num = length(timepoints_frame);
%% 继续
        num_list(data_num,1) = trial_num;%第一列为通过亮度变化计算出的trial数
        num_list(data_num,2) = numel(log.res_vector);%第二列为行为数据记录的trial数
        num_list(data_num,3) = numel(log.res_vector)-trial_num;
        num_list(data_num,4) = date;
        num_list(data_num,5) = date_list(date,2);
        num_list(data_num,6) = mouse;
        data_num = data_num+1;
        save(['D:\fcc_done\20240620 motion-baseline\result 20240620\',num2str(date_list(date,2)),'_#',num2str(mouse),'-result.mat'])
        %如需保存数据，将上面这行取消注释
        clear lighten y1 y2 log trial_num timepoints_frame ave_lighten num ii
    end
    
end
save('D:\fcc_done\20240620 motion-baseline\result 20240620\numlist.mat',"num_list");
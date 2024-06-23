clear

frameHeight = 144;
frameWidth_68 = 193;
frameWidth_69 = 195;

SVD_CR_68 = load("\\10.10.49.201\CCFeng\运动检测_68#69#\202401SVD数据存档\cr_#68-SVD.mat","U","V");
SVD_CR_69 = load("\\10.10.49.201\CCFeng\运动检测_68#69#\202401SVD数据存档\cr_#69-SVD.mat","U","V");

SVD_HIT_68 = load("\\10.10.49.201\CCFeng\运动检测_68#69#\202401SVD数据存档\hit_#68-SVD.mat","U","V");
SVD_HIT_69 = load("\\10.10.49.201\CCFeng\运动检测_68#69#\202401SVD数据存档\hit_#69-SVD.mat","U","V");

save("C:\fcctemp\svd_data_for_motion.mat")
%%
CR_68_U = SVD_CR_68.U(:,1:100);
CR_68_V = SVD_CR_68.V(:,1:100);
CR_69_U = SVD_CR_69.U(:,1:100);
CR_69_V = SVD_CR_69.V(:,1:100);

HIT_68_U = SVD_HIT_68.U(:,1:100);
HIT_68_V = SVD_HIT_68.V(:,1:100);
HIT_69_U = SVD_HIT_69.U(:,1:100);
HIT_69_V = SVD_HIT_69.V(:,1:100);

%% 查找合适的空间组分
for comp = 1:10
    ccc = reshape(CR_69_U(:,comp),[frameHeight,frameWidth_69]);
    figure;imagesc(ccc);title(['CR #69 dim=' num2str(comp)])
end

%%
for comp = 1:10
    ccc = reshape(HIT_69_U(:,comp),[frameHeight,frameWidth_69]);
    figure;imagesc(ccc);title(['Hit #69 dim=' num2str(comp)])
end
%%
for dim = [3,5,7]
    reshapedlight = reshape(CR_69_V(:,dim), 640, 70);
    %figure;plot(reshapedlight(:,1))
    figure; hold on
    for vv = 1:70
        plot(reshapedlight(:,vv))  
    end
    title(['CR #69 dim=' num2str(dim)])
    meanreshaped = mean(reshapedlight,2);
    plot(meanreshaped,'r','LineWidth',3)
    hold off
end
%%
for dim = [2,6,8]
    reshapedlight = reshape(HIT_69_V(:,dim), 640, 80);
    %figure;plot(reshapedlight(:,1))
    figure; hold on
    for vv = 1:80
        plot(reshapedlight(:,vv))  
    end
    title(['HIT #69 dim=' num2str(dim)])
    meanreshaped = mean(reshapedlight,2);
    plot(meanreshaped,'r','LineWidth',3)
    hold off
end
%% cr-68
yname = {'0-1','1-2','2-3','3-4'};
for dim = [2,4,6]
    reshapedlight = reshape(CR_68_V(:,dim), 640, 80);
    figure; hold on
    
    mean_dprime_1 = mean(reshapedlight(:,1:20),2);
    mean_dprime_2 = mean(reshapedlight(:,21:40),2);
    mean_dprime_3 = mean(reshapedlight(:,41:60),2);
    mean_dprime_4 = mean(reshapedlight(:,61:80),2);

    plot(mean_dprime_1)
    plot(mean_dprime_2)
    plot(mean_dprime_3)
    plot(mean_dprime_4)
    legend('d-prime 0-1','d-prime 1-2','d-prime 2-3','d-prime 3-4')
    title(['CR #68 dim=' num2str(dim)])
    hold off

    figure; 
    
    mean_dprime_1_bin = normalize(mean(reshape(mean_dprime_1,32,20),2)) ;
    mean_dprime_2_bin = normalize(mean(reshape(mean_dprime_2,32,20),2));
    mean_dprime_3_bin = normalize(mean(reshape(mean_dprime_3,32,20),2));
    mean_dprime_4_bin = normalize(mean(reshape(mean_dprime_4,32,20),2));
    mean_dprime_bin = [mean_dprime_1_bin';mean_dprime_2_bin';mean_dprime_3_bin';mean_dprime_4_bin'];
    imagesc(mean_dprime_bin)

    title(['CR #68 dim=' num2str(dim)])
    colorbar;colormap('parula');
    xlabel('Time from visual stim on(ms)');ylabel('d-prime group');
    yticks([1 2 3 4]);yticklabels(yname);xticks([4 12 28]);xticklabels({'-100-0','700-800','2300-2400'});xtickangle(45);
end
%% cr-69
yname = {'0-1','1-2','2-3','3-4'};
for dim = [3,5,7]
    reshapedlight = reshape(CR_69_V(:,dim), 640, 70);
    figure; hold on
    
    mean_dprime_1 = mean(reshapedlight(:,1:10),2);
    mean_dprime_2 = mean(reshapedlight(:,11:30),2);
    mean_dprime_3 = mean(reshapedlight(:,31:50),2);
    mean_dprime_4 = mean(reshapedlight(:,51:70),2);

    plot(mean_dprime_1)
    plot(mean_dprime_2)
    plot(mean_dprime_3)
    plot(mean_dprime_4)
    legend('d-prime 0-1','d-prime 1-2','d-prime 2-3','d-prime 3-4')
    title(['CR #69 dim=' num2str(dim)])
    hold off

    figure; 
    
    mean_dprime_1_bin = normalize(mean(reshape(mean_dprime_1,32,20),2)) ;
    mean_dprime_2_bin = normalize(mean(reshape(mean_dprime_2,32,20),2));
    mean_dprime_3_bin = normalize(mean(reshape(mean_dprime_3,32,20),2));
    mean_dprime_4_bin = normalize(mean(reshape(mean_dprime_4,32,20),2));
    mean_dprime_bin = [mean_dprime_1_bin';mean_dprime_2_bin';mean_dprime_3_bin';mean_dprime_4_bin'];
    imagesc(mean_dprime_bin)
%         plot(mean_dprime_1_bin)
%         plot(mean_dprime_2_bin)
%         plot(mean_dprime_3_bin)
%         plot(mean_dprime_4_bin)
%         legend('d-prime 0-1','d-prime 1-2','d-prime 2-3','d-prime 3-4')
    title(['CR #69 dim=' num2str(dim)])
    colorbar;colormap('parula');
    xlabel('Time from visual stim on(ms)');ylabel('d-prime group');
    yticks([1 2 3 4]);yticklabels(yname);xticks([4 12 28]);xticklabels({'-100-0','700-800','2300-2400'});xtickangle(45);
end
%% hit-68
yname = {'0-1','1-2','2-3','3-4'};
for dim = [3,4,6]
    reshapedlight = reshape(HIT_68_V(:,dim), 640, 80);
    figure; hold on
    
    mean_dprime_1 = mean(reshapedlight(:,1:20),2);
    mean_dprime_2 = mean(reshapedlight(:,21:40),2);
    mean_dprime_3 = mean(reshapedlight(:,41:60),2);
    mean_dprime_4 = mean(reshapedlight(:,61:80),2);

    plot(mean_dprime_1)
    plot(mean_dprime_2)
    plot(mean_dprime_3)
    plot(mean_dprime_4)
    legend('d-prime 0-1','d-prime 1-2','d-prime 2-3','d-prime 3-4')
    title(['HIT #68 dim=' num2str(dim)])
    hold off

    figure; 
    
    mean_dprime_1_bin = normalize(mean(reshape(mean_dprime_1,32,20),2)) ;
    mean_dprime_2_bin = normalize(mean(reshape(mean_dprime_2,32,20),2));
    mean_dprime_3_bin = normalize(mean(reshape(mean_dprime_3,32,20),2));
    mean_dprime_4_bin = normalize(mean(reshape(mean_dprime_4,32,20),2));
    mean_dprime_bin = [mean_dprime_1_bin';mean_dprime_2_bin';mean_dprime_3_bin';mean_dprime_4_bin'];
    imagesc(mean_dprime_bin)

    title(['HIT #68 dim=' num2str(dim)])
    colorbar;colormap('parula');
    xlabel('Time from visual stim on(ms)');ylabel('d-prime group');
    yticks([1 2 3 4]);yticklabels(yname);xticks([4 12 28]);xticklabels({'-100-0','700-800','2300-2400'});xtickangle(45);
end
%% hit-69
yname = {'0-1','1-2','2-3','3-4'};
for dim = [2,6,8]
    reshapedlight = reshape(HIT_69_V(:,dim), 640, 80);
    figure; hold on
    
    mean_dprime_1 = mean(reshapedlight(:,1:20),2);
    mean_dprime_2 = mean(reshapedlight(:,21:40),2);
    mean_dprime_3 = mean(reshapedlight(:,41:60),2);
    mean_dprime_4 = mean(reshapedlight(:,61:80),2);

    plot(mean_dprime_1)
    plot(mean_dprime_2)
    plot(mean_dprime_3)
    plot(mean_dprime_4)
    legend('d-prime 0-1','d-prime 1-2','d-prime 2-3','d-prime 3-4')
    title(['HIT #69 dim=' num2str(dim)])
    hold off

    figure; 
    
    mean_dprime_1_bin = normalize(mean(reshape(mean_dprime_1,32,20),2)) ;
    mean_dprime_2_bin = normalize(mean(reshape(mean_dprime_2,32,20),2));
    mean_dprime_3_bin = normalize(mean(reshape(mean_dprime_3,32,20),2));
    mean_dprime_4_bin = normalize(mean(reshape(mean_dprime_4,32,20),2));
    mean_dprime_bin = [mean_dprime_1_bin';mean_dprime_2_bin';mean_dprime_3_bin';mean_dprime_4_bin'];
    imagesc(mean_dprime_bin)

    title(['HIT #69 dim=' num2str(dim)])
    colorbar;colormap('parula');
    xlabel('Time from visual stim on(ms)');ylabel('d-prime group');
    yticks([1 2 3 4]);yticklabels(yname);xticks([4 12 28]);xticklabels({'-100-0','700-800','2300-2400'});xtickangle(45);
end
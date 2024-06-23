load('G:\motion energy 20240620\20240615\grouping_trials_by_d_prime_20240616.mat')
cr = whole.CR;
%% 测试部分
temp_cr_2 = cr{1,1};
temp_cr_2(:,77:85) = nan;temp_cr_2(:,237:245) = nan;
baseline1 = mean(mean(temp_cr_2(:,86:95))) - mean(mean(temp_cr_2(:,1:75)));
baseline2 = mean(mean(temp_cr_2(:,541:640))) - mean(mean(temp_cr_2(:,1:75)));
temp_cr_2(:,86:236) = temp_cr_2(:,86:236) - baseline1;
temp_cr_2(:,246:640) = temp_cr_2(:,246:640) - baseline2;

cr{1,2} = nanmean(temp_cr_2);

%% 正式代码
% cr = whole.CR;
load('D:\fcc_done\20240620 motion-baseline\CR_treated.mat')
for d = 1:8
    temp_cr = cr{d,1};
    temp_cr(:,77:85) = nan;temp_cr(:,237:245) = nan;
    baseline1 = nanmean(nanmean(temp_cr(:,86:95)));
    baseline2 = nanmean(nanmean(temp_cr(:,541:640)));
    temp_cr(:,1:76) = temp_cr(:,1:76) - nanmean(nanmean(temp_cr(:,1:75)));
    temp_cr(:,86:236) = temp_cr(:,86:236) - baseline1;
    temp_cr(:,246:640) = temp_cr(:,246:640) - baseline2;

    cr{d,2} = nanmean(temp_cr);
    cr{d,3} = reshape(cr{d,2},[40,16]);
    cr{d,4} = nanmean(cr{d,3},1);
    cr{1,5}(d,:) = cr{d,4};
end
%cr{2,5} = normalize(cr{1,5},2);

%%
figure;imagesc(cr{1,5})
colorbar;colormap('parula');
yname = {'0-0.5','0.5-1','1-1.5','1.5-2','2-2.5','2.5-3','3-3.5','3.5-4'};
xlabel('Time from visual stim on(ms)');ylabel('d-prime');title('CR trials motion energy');
yticklabels(yname);xticks([2 6 14]);xticklabels({'-200-0','600-800','2200-2400'});xtickangle(45);

figure;hold on
for d = 1:8
    plot(cr{1,5}(d,:))
end
legend('d-prime 0-0.5','d-prime 0.5-1','d-prime 1-1.5','d-prime 1.5-2',...
    'd-prime 2-2.5','d-prime 2.5-3','d-prime 3-3.5','d-prime 3.5-4')

xlabel('Time from visual stim on(ms)');ylabel('motion energy');title('CR trials motion energy');
xticks([2 6 14]);xticklabels({'-200-0','600-800','2200-2400'});xtickangle(45);
hold off
%%
figure;hold on
for d = 1:8
    plot(cr{d,2})
end
legend('d-prime 0-0.5','d-prime 0.5-1','d-prime 1-1.5','d-prime 1.5-2',...
    'd-prime 2-2.5','d-prime 2.5-3','d-prime 3-3.5','d-prime 3.5-4')
xlabel('Time from visual stim on(ms)');ylabel('motion energy');title('CR trials motion energy');
xticks([80 240 560]);xticklabels({'0','800','2400'});
hold off
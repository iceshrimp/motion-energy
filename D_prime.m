d_range = 0:0.5:4;
d_range(1) = -0.5;
d_abandon = 20;
d_calc_range = 10;
effective_range = 1:find(log.res_vector == 1 | log.res_vector == -2, 1, 'last' );
d_prime = nan(length(log.res_vector),1);
% get d-prime for each trial
for trial_num = 1:length(log.res_vector)
    if trial_num <= d_calc_range
        temp_res = log.res_vector(1:trial_num+d_calc_range);
    elseif trial_num+d_calc_range > length(effective_range)
        temp_res = log.res_vector(trial_num-d_calc_range:length(effective_range));
    else
        temp_res = log.res_vector(trial_num-d_calc_range:trial_num+d_calc_range);
    end
    
    hit = length(find(temp_res == 1))/(length(find(abs(temp_res) == 1)));
    fa = length(find(temp_res == -2))/(length(find(abs(temp_res) == 2)));
    if hit > 0.99
        hit = 0.99;
    elseif hit < 0.01
        hit = 0.01;
    end
    if fa > 0.99
        fa = 0.99;
    elseif fa < 0.01
        fa = 0.01;
    end
    d_prime(trial_num) = norminv(hit)-norminv(fa);
end
d_prime_index = cell(length(d_range)-1,1);

for d = 1:length(d_prime_index)
    temp_index =  find(d_prime >= d_range(d) & d_prime < d_range(d+1));
    temp_index(temp_index < d_abandon) = [];
    d_prime_index{d} = temp_index;
end
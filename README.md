# motion-energy
存储小鼠motion energy相关代码

1. check_trialnum_2 检查通过亮度变化计算出的trial数与行为数据记录的trial数之间的差值，根据情况修改各个result文件中的timepoints_frame，以实现trial数匹配再进行下一步工作。
2. trial_match20240620 将识别出的所有trial，按照trial类型进行分类保存，并且在最后一列添加d_prime信息，hit trial后额外添加一列“82+timepoints_frame(trialnum,2)-timepoints_frame(trialnum,1)”，以记录从-80帧开始到小鼠舔水屏幕变暗的帧数。
3. Hit_baseline 创建whole数据，并可以对Hit trial进行处理
4. CR trial使用CR_baseline处理。

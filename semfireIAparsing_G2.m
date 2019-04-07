function [ir_sd_rect,rgb_sd_rect] = semfireIAparsing_G2(ir_num,rgb_num)

bagselect = rosbag('semfireIA_G2.bag');
bSel = select(bagselect,'Topic','/camera/ir_sd_rect');
bSel1 = select(bagselect,'Topic','/camera/rgb_sd_rect');
ir_sd_rect = readMessages(bSel,ir_num);
rgb_sd_rect = readMessages(bSel1,rgb_num);

end
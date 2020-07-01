figure();
for cond_i = 1:length(conditions)
   subplot(2,3,cond_i); plot(squeeze(nanmean(power(1:23,cond_i,:,:),1))');set(gca,'XTick',1:1000:length(times),'XTickLabel',times(1:1000:length(times)))
   hold on; line(1:length(times),zeros(1,length(times)),'Color',[0 0 0])
end
figure();
for cond_i = 1:length(conditions)
   subplot(2,3,cond_i); plot(squeeze(nanmean(power(24:size(power,1),cond_i,:,:),1))');set(gca,'XTick',1:1000:length(times),'XTickLabel',times(1:1000:length(times)))
   hold on; line(1:length(times),zeros(1,length(times)),'Color',[0 0 0])
end

figure();
for cond_i = 1:length(conditions)
   subplot(2,3,cond_i); plot(squeeze(nanmean(nanmean(power(1:23,cond_i,:,:),1),3))','--b');set(gca,'XTick',1:1000:length(times),'XTickLabel',times(1:1000:length(times)));
   hold on; plot(squeeze(nanmean(nanmean(power(24:size(power,1),cond_i,:,:),1),3))','--r');set(gca,'XTick',1:1000:length(times),'XTickLabel',times(1:1000:length(times)))
   line(1:length(times),zeros(1,length(times)),'Color',[0 0 0]);
   if cond_i == length(conditions)
       legend('YOUNG','OLD')
   end
end
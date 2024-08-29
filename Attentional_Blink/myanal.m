function myanal(dataName)
% 20160525.

% filename1 = [dataName,'.mat'];
% load(filename1);
load(dataName,'Data','subject');

subID = subject.name;
data = Data.record;
clear Data subject screenRect pic_dur;

%%% data: 1:trial number.  2:T1 position   3:T2 position(lag).
%%% 4:T1 target;  5:T2 target;   6:T1 response;   7:T2 response.

%%%%%% compute T1 correct ratio
Lag = unique(data(:,3));
onec = size(data,1)/length(Lag);   %trials of one condition.
for i = 1:length(Lag)
    %ignoring order factor.
    tmp4(i) = length(find(data(:,3)==Lag(i) & data(:,4)==data(:,6))) + length(find(data(:,3)==Lag(i) & data(:,4)==data(:,7) & data(:,6)~=data(:,7)));    %correct T1. 
    tmp5(i) = length(find(data(:,3)==Lag(i) & data(:,5)==data(:,7))) + length(find(data(:,3)==Lag(i) & data(:,5)==data(:,6) & data(:,6)~=data(:,7)));    %correct T2. 
    tmp6(i) = length(find(data(:,3)==Lag(i) & data(:,4)==data(:,6) & data(:,5)==data(:,7))) + length(find(data(:,3)==Lag(i) & data(:,4)==data(:,7) & data(:,5)==data(:,6)));    %correct T1&T2. 
    T1nonorder(i) = tmp4(i)/onec*100;   % compute accuracy of T1nonorder.
    T2nonorder(i) = tmp5(i)/onec*100;   % compute accuracy of T2nonorder.
    T1onT2nonorder(i) = tmp6(i)/tmp5(i)*100;   % compute accuracy of T1nonorder based on the right response of T2nonorder.
    T2onT1nonorder(i) = tmp6(i)/tmp4(i)*100;   % compute accuracy of T2nonorder based on the right response of T1nonorder.                       
end
outfile = [dataName(1:end-11), 'result.mat'];
save(outfile,'subID', 'T1nonorder','T2nonorder', 'T1onT2nonorder','T2onT1nonorder');


figure(1);
set(gcf,'Position',[100,100,500,450]);
title('Accuracy of T1 & T2|T1');
hold on;
axis([0 Lag(end)+1 0 100]);
xlabel('Lag');
ylabel('Accuracy');
plot(Lag,T1nonorder,'g');  % accuracy of T1nonorder;
plot(Lag,T2onT1nonorder,'r');  % accuracy of T2nonorder;
legend('T1','T2|T1', 'Location', 'SouthEast');
hold off;



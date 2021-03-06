function test=SampleMGC(P)
% Find the smooth regions in the p-value map, by considering the
% largest monotonically decreasing or increasing scales along
% the row or column p-values, but allowing small p-value increase or
% decrease as specified by tau. 
[m,n]=size(P);
P2=P(2:end,2:end);
st=max(10*norm(P2(P2<0),'fro')/sqrt(length(P2(P2<0))),0.035);
%st=max(3*norm(P2(2:end,2:end),'fro')/sqrt((m-1)*(n-1)),0.03)
% (prctile(P2(P2>0),95))/st
% (prctile(P2(P2>0),90))/st
% (prctile(P2(P2>-1),80))/st
tmp=(P2>st);
if mean(mean(tmp))>1/min(m,n)
    warning('off','all');
    tmp=bwareafilt(tmp,1);
end
if mean(mean(tmp))<1/min(m,n)
%     tmp=bwareafilt(tmp,1);
    test=P(end);
else
%     test=max(max(P2));
t1=max(median(P2,1));
t2=max(median(P2,2));
test=max([t1,t2]);
% test=prctile(P(P>0),90);
%     cc=[];
% %     lm=ceil(0.01*m);
% %     ln=ceil(0.01*n);
%     lm=1;
%     ln=1;
% %      [k,l]=find(P==max(max(P)));
%     [k,l]=find(P>=prctile(P(P<2),99));
%     test=max(max(P));
%     test=0;
%     for i=1:length(k)      
%         ki=k(i);
%         li=l(i);
% 
%         left=max(2,li-ln);
%         right=min(n,li+ln);
%         upper=max(2,ki-lm);
%         down=min(m,ki+lm);
%         tmp=P(upper:down,left:right);
%         tmp=median(tmp(tmp<1));
%         if tmp>test
%             test=tmp;
%         end
%     end
end
function [p,indAll,t]=MGCScaleVerify(P,alpha)
% % An auxiliary function to verify and estimate the MGC optimal scale based
% % on the p-values of all local correlations
if nargin<2
    alpha=0.05;
end

% end
[m,n]=size(P);
p=P(end);

indAll=m*n;
pc=mean(mean(P<p))*100;
if pc<=10
    prc=pc;
else
    prc=10:10:90;
    prc=[prc';pc;mean(mean(P<alpha))*100];
    prc=sort(prc,'ascend');
%     prc=mean(mean(P<(alpha-0.001)))*100;
end
warning ('off','all');
for j=1:length(prc)
    alpha=prctile(P(P<1), prc(j));
    try
       CC=(P<=alpha);
       CC=ValidateRow(CC);
       CC=ValidateRow(CC')';       
    catch
        CC=zeros(m,n);
    end
    mm=sum(sum(CC))/(m-1)/(n-1);
    thres=max([prc(j)*0.3/100;0.1]);
    mm2=sum(CC)/(n-1);
    mm3=sum(CC,2)/(m-1);
    if mm>thres
        indAll=(CC==1);
        p=alpha;
        break;
    end
end

if (p<0.05 && P(end)>0.05)
    mm
    mm2
    mm3
    thres
    p
    P(end)
end

function CC2=ValidateRow(CC)
[m,n]=size(CC);
nn=max(ceil(0.025*m),2);
nn2=max(ceil(0.025*n),2);
CC2=(zeros(m,n)==1);
i=2;
while i<=m
    is=max(2,i-nn);
    ie=min(m,i+nn);
    tmp=find(sum(CC(is:ie,:),1)<ie-is+1);
    tmp=[1;tmp';n+1];
    tmp2=diff(tmp);
    ind=find(tmp2>=max(nn2*2,max(tmp2)),1,'last');
    i=i+1;
    if ~isempty(ind)
    for t=1:length(ind) 
        j=ind(t);
        CC2(is:ie,tmp(j)+1:tmp(j+1)-1)=1;
    end
    i=ie+1;
    end
end
CC2=bwareafilt(CC2,1);    
% 
% function pdiff=V2(P,alpha)
% [m,n]=size(P);
% pdiff=zeros(m,n-2);
% for i=2:m
%     tt=P(i,2:end);
%     ttd=diff(tt);
%     tt=tt(2:end);
% %               if  (min(tt)<alpha)
% %     pdiff(i,:)=(ttd<=0) & (tt<alpha);
%                 pdiff(i,:)=(tt<alpha);
% %                end
% end
% pdiff=(pdiff==1);
% % 
% % function [CC]=Validate(P)
% % pc=mean(mean(P<p))*100;
% % if pc<=10
% %     prc=pc;
% % else
% %     prc=5:5:50;
% %     prc=[prc';pc;mean(mean(P<(alpha-0.001)))*100];
% %     prc=sort(prc,'ascend');
% % %     prc=mean(mean(P<(alpha-0.001)))*100;
% % end
% % 
% % prc=5:5:50;
% % [m,n]=size(P);
% % p=P(end);
% % CC=zeros(m,n);
% % for j=1:length(prc)
% %     alpha=prctile(P(P<1), prc(j));
% % %     if alpha*j>p
% % %         break;
% % %     end
% %    nn=ceil(0.025*n);
% % %     nn=ceil(0.05*n);
% % %        nn=1;
% %      
% %      pdiff=zeros(m-2,n);
% %      for i=2:n
% %          tt=P(2:end,i);
% %            ttd=diff(tt);
% %               tt=tt(2:end);
% % %           if  (min(tt)<alpha)
% %               pdiff(:,i)=(ttd<=0) & (tt<alpha);
% % %             pdiff(:,i)=(tt<alpha);
% % %            end
% %      end
% % 
% %      warning ('off','all');
% %      try
% %          CC=bwareafilt(pdiff==1,1);
% % %          CC=ValidateRow(CC);
% % %          CC=ValidateRow(CC');
% % %          CC=bwareafilt(CC,1);
% %      catch
% %          CC=zeros(m,n);
% %      end
% %      
% %      mm=sum(sum(CC))/(m-1)/(n-1)
% %      thres=max([prc(j)*0.5/100;1/n]);
% %      if mm>thres
% %          %         sum(sum(CC))/(m-1)/(n-1)/prc(j)*100
% %          indAll=(CC==1);
% %          p=alpha;
% %          break;
% %      end
% % 
% %     
% % %      pp=zeros(n,1);
% % % %      sind=zeros(n,2);
% % %      for i=2:n
% % %          is=max(2,i-nn);
% % %          ie=min(n,i+nn);
% % %          tmp=sum(pdiff(:,is:ie),2);
% % %          tmp=find(tmp<ie-is+1);
% % %          tmp=[1;tmp;m+1];
% % %          tmp2=diff(tmp);
% % %          %ind=find(tmp2==max(tmp2),1,'last');
% % %          jm=max(tmp2);
% % % %          j=find(tmp2==jm,1,'last');
% % %          
% % %          %     if sum(P(tmp(j+1)-1,i-1:i+1)<alpha)==3
% % %          pp(i)=(jm-1)/(m-2);
% % % %          sind(i,:)=[tmp(j)+1, tmp(j+1)-1];
% % %          %     end
% % %          %      else
% % %          %           sind(i,:)=[1,1];
% % %          %      end
% % %      end
% %      
% % %      figure
% % %      plot(pp)
% % % max(pp)
% %      %thres=max(0.45,min(pp(n), mean(pp(2:n)))+3*std(pp(2:n)));
% %      %thres=max(0.3,min(mean(pp(n))+3*std(pp(2:n)), mean(pp(2:n))+3*std(pp(2:n))));
% % %      figure 
% % %      plot(pp)
% % %      thres=max(0.2,min(pp(n), mean(pp(2:n)))+3*std(pp(2:n)));
% % %      if max(pp)>=thres
% % %          p=alpha;
% % %          break;
% % %      end
% % end
% % % max(pp)
% % %
% % 
% % % [mm,i]=max(pp);
% % % % i
% % % % figure
% % % % plot(pp);
% % % %thres=0.4;
% % % thres=min([0.5, mean(pp(2:n))+4*std(pp(2:n))]);%,max(pp)]);
% % % % mm
% % % % thres
% % % p=1;
% % % if mm>thres
% % % %     mm
% % % %     thres
% % %     i=find(pp>thres);
% % %     p=1;
% % %     for t=1:length(i)
% % %         j=i(t);
% % %          pt=min(min(P(sind(j,1):sind(j,2),j)))/pp(j);
% % %          p=min(p,pt);
% % %     end
% % % % else
% % % %     if mm>0.2
% % % %     %p=min(P(end));%,median(P(P<1)));
% % % %     %j=n;
% % % %     %p=min(P(sind(j,1):sind(j,2),j))/pp(j);
% % % %     end
% % % end
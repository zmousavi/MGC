function [p1,p2,p3, p4,p5,p6,p7,p1All,p2All,p3All]=CorrPermDistTest(C,D,rep,titlechar,option)
% Author: Cencheng Shen
% Permutation Tests for identifying dependency.
% The output are the p-values of MGC by dcorr/mcorr/Mantel, and global dcorr/mcorr/Mantel/HHG.

% Parameters:
% C & D should be two n*n distance matrices,
% rep1 specifies the number of independent samples for optimal scale estimation
% in MGC; if 0, the estimation step is skipped.
% rep2 specifies the number of random permutations to use for the permutation test,
% alpha specifies the type 1 error level,
% option specifies whether each test statistic is calculated or not,
% neighborhood can be specified beforehand so as to skip the optimal scale
% estimation.
if nargin<4
    titlechar='RealData';
end
if nargin<5
    option=[1,2,3,4]; % Default option. Setting any to 0 to disable the calculation of MGC by dcorr/mcorr/Mantel, global dcorr/mcorr/Mantel, HHG, in order; set the first three
end

% Global Correlations
[p1All]=PermutationTest(C,D,rep,option(1));
[p2All]=PermutationTest(C,D,rep,option(2));
[p3All]=PermutationTest(C,D,rep,option(3));
[p1,ind1]=verify(p1All);[p2,ind2]=verify(p2All);[p3,ind3]=verify(p3All);
p4=p1All(end);p5=p2All(end);p6=p3All(end);
[p7]=PermutationTest(C,D,rep,option(4));

% if p2<0.05 || p5<0.05
%     p2
%     p5
% end
pre1='../../Data/';
filename=strcat(pre1,'CorrPermDistTestType',titlechar);
save(filename,'titlechar','rep','option','p1All','p2All','p3All','p4','p5','p6','p7','p1','p2','p3','ind1','ind2','ind3');

function [p1,ind]=verify(p1All)
alpha=0.05;
thres=0.85;
if p1All==1;
    p1=1;
    ind=[];
    return;
end
n=size(p1All,1);
power1=(p1All<alpha);
pCol=mean(power1(2:end,1:end),1);
pRow=mean(power1(1:end,2:end),2);
k=find(pRow>thres);
l=find(pCol>thres);
col=false;

if length(k)<length(l)
    p1All=p1All';
    pRow=pCol;
    k=l;
    col=true;
end
if length(k)<n/20;% || mean(a(indK))>length(indK)
    ind=[];
    p1=1;
    if pRow(n)>thres || sum(pRow>pRow(n))==0
        ind=n^2;
        p1=p1All(ind);
    end
    return;
end
% figure
% plot(1:n,pCol,'b-',1:n,pRow,'r:')

k=find(pRow==max(pRow));
ind=find(p1All(k,:)==min(min(p1All(k,:))),1,'last');
[k1,l]=ind2sub([length(k),n],ind);
k=k(k1);
p1=p1All(k,l);
if col==true
    tmp=l;
    l=k;
    k=tmp;
end
ind=sub2ind([n,n],k,l);


function [p1,ind]=verify3(p1All)
% alpha=0.06;
thres=0.1;
if p1All==1;
    p1=1;
    ind=[];
    return;
end
n=size(p1All,1);
% power1=(p1All<alpha);
pCol=mean(p1All(2:end,1:end),1);
pRow=mean(p1All(1:end,2:end),2);

% figure
% plot(1:n,pCol,'b-',1:n,pRow,'r:')

if min(pRow)>min(pCol)
    p1All=p1All';
    pRow=pCol;
    pCol=pRow;
end
% [~,~,a]=unique(1-pRow);
% k=find(a==1,1,'last');
k=find(pRow<thres);
k
if length(k)<n/10;% || mean(a(indK))>length(indK)
    ind=[];
    p1=1;
    if pRow(n)<thres || sum(pRow<pRow(n))==0
        ind=n^2;
        p1=p1All(ind);
    end
    return;
end
k=k(end);
l=find(p1All(k,:)==min(p1All(k,:)),1,'last');
p1=p1All(k,l);
if min(pRow)>min(pCol)
    tmp=l;
    l=k;
    k=tmp;
end
ind=sub2ind([n,n],k,l);

function  [p1]=PermutationTest(C,D,rep,option)
% This is an auxiliary function of the main function to calculate the p-values of
% all local tests of dcorr/mcorr/Mantel, the p-value of HHG in the
% permutation test.
if nargin<4
    option=1;  % Default option. Set to 1/2/3/4 for local dcorr/mcorr/Mantel, or HHG.
end

n=size(C,1);
if option==0
    p1=1;
    return;
end

% Calculate the observed test statistics for the given data sets
if option~=4
    p1=zeros(n,n);
    cut1=LocalGraphCorr(C,D,option);
    dCor1=zeros(n,n,rep);  % Default option. Set to 1/2/3/4 for local dcorr/mcorr/Mantel, or HHG.
else
    p1=0;
    cut1=HHG(C,D);
    dCor1=0;
end

% Now Permute the second dataset for rep times, and calculate the p-values
for r=1:rep
    % Use random permutations;
    per=randperm(n);
    DN=D(per,per);
    CN=C;
    if option<4
        dCorTmp=LocalGraphCorr(CN,DN,option);
        dCor1(:,:,r)=dCorTmp;
    else
        dCorTmp=HHG(CN,DN);
        dCor1(r)=dCorTmp;
    end
    p1=p1+(dCorTmp<cut1)/rep;
end
% Output the p-value
p1=1-p1;
if option~=4
    p1(1,:)=1;p1(:,1)=1; % Set the p-values of rank 0 to maximum.
end
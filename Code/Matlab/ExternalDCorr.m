%Locally linear dependent
n=7;
x=-1:2/(n-1):1;
y=x.^2;
x=unifrnd(1,2,1,n);
x=[-x,x];
y=abs(x);
%x=unifrnd(-1,1,1,n);
%y=x;
optionModi=1;
C=squareform(pdist(x'));
P=squareform(pdist(y'));
per=perms(1:n);
t1=LocalGraphCorr(C, P, optionModi);
pv=zeros(n,n);
for i=1:size(per,1);
    t2=LocalGraphCorr(C, P(per(i,:),per(i,:)), optionModi);
    pv=pv+(t1>t2);
end
pv=1-pv/size(per,1);
%%%ind trial
clear
load('BrainCP') 
n=10;
alpha=0.05; rep2=1000;repp=1000;
dim=1;type=20;
power=zeros(7,1);
p=zeros(7,1);
for i=1:rep2;
      x=random('norm',0,1,n,dim);
      y=random('norm',0,1,n,dim);
%        %y=x.^2;
%     %[x, y]=CorrSampleGenerator(type,n,dim,1,0);
%     %y=mvnrnd(zeros(n,dim),eye(dim),n);
%     distC=squareform(pdist(x));
%     distPInd=squareform(pdist(y));
%     [power1,power2,power3]=CorrPermDistTest(distC,distPInd,repp,0,'BrainIndTmp');
%     neighbor=zeros(3,1);
%     neighbor(1)=verifyNeighbors(1-power1);neighbor(2)=verifyNeighbors(1-power2);neighbor(3)=verifyNeighbors(1-power3);
%     x=random('norm',0,1,n,dim);
%     %y=random('norm',0,1,n,dim);
%     distC=squareform(pdist(x));
%     %distPInd=squareform(pdist(y));
%     [p(1),p(2),p(3),p(4),p(5),p(6),p(7)]=CorrPermDistTest(distC,distPInd,0,repp,'BrainCxPInd',neighbor);
%     for j=1:7
%         if p(j)<alpha
%             power(j)=power(j)+1/rep2;
%         end
%     end
   
    distC=squareform(pdist(x));
    distPInd=squareform(pdist(y));
    [p(1),p(2),p(3),p(4),p(5),p(6),p(7)]=CorrPermDistTest(distC,distPInd,repp,repp,'BrainCxPInd');
    for j=1:7
        if p(j)<alpha
            power(j)=power(j)+1/rep2;
        end
    end
end

%%Sims
%Ind
n=100; dim=1; lim=20; rep1=2000;rep2=10000;
CorrIndTest(1,n,dim,lim,rep1,rep2);
CorrIndTest(2,n,dim,lim,rep1,rep2);
CorrIndTest(3,n,dim,lim,rep1,rep2);
CorrIndTest(4,n,dim,lim,rep1,rep2);
CorrIndTest(5,n,dim,lim,rep1,rep2);
CorrIndTest(6,n,dim,lim,rep1,rep2);
CorrIndTest(7,n,dim,lim,rep1,rep2);
CorrIndTest(8,n,dim,lim,rep1,rep2);
CorrIndTest(9,n,dim,lim,rep1,rep2);
CorrIndTest(10,n,dim,lim,rep1,rep2);

n=100; dim=1; lim=20; rep1=2000;rep2=10000;
CorrIndTest(11,n,dim,lim,rep1,rep2);
CorrIndTest(12,n,dim,lim,rep1,rep2);
CorrIndTest(13,n,dim,lim,rep1,rep2);
CorrIndTest(14,n,dim,lim,rep1,rep2);
CorrIndTest(15,n,dim,lim,rep1,rep2);
CorrIndTest(16,n,dim,lim,rep1,rep2);
CorrIndTest(17,n,dim,lim,rep1,rep2);
CorrIndTest(18,n,dim,lim,rep1,rep2);
CorrIndTest(19,n,dim,lim,rep1,rep2);
CorrIndTest(20,n,dim,lim,rep1,rep2);



%IndDim
n=100; dim=1000; lim=20; rep1=2000;rep2=10000;
CorrIndTestDim(1,n,dim,lim,rep1,rep2);
CorrIndTestDim(2,n,dim,lim,rep1,rep2);
CorrIndTestDim(3,n,dim,lim,rep1,rep2);
CorrIndTestDim(4,n,dim,lim,rep1,rep2);
dim=10;lim=10;
CorrIndTestDim(5,n,dim,lim,rep1,rep2);
dim=40;lim=20;
CorrIndTestDim(6,n,dim,lim,rep1,rep2);
CorrIndTestDim(7,n,dim,lim,rep1,rep2);
CorrIndTestDim(8,n,dim,lim,rep1,rep2);
dim=40;lim=20;
CorrIndTestDim(9,n,dim,lim,rep1,rep2);
dim=100;
CorrIndTestDim(10,n,dim,lim,rep1,rep2);

n=100; dim=100; lim=20; rep1=2000;rep2=10000;
CorrIndTestDim(11,n,dim,lim,rep1,rep2);
dim=20;
CorrIndTestDim(12,n,dim,lim,rep1,rep2);
dim=10;lim=10;
CorrIndTestDim(13,n,dim,lim,rep1,rep2);
dim=20;lim=20;
CorrIndTestDim(14,n,dim,lim,rep1,rep2);
CorrIndTestDim(15,n,dim,lim,rep1,rep2);
CorrIndTestDim(16,n,dim,lim,rep1,rep2);
dim=20;
CorrIndTestDim(17,n,dim,lim,rep1,rep2);
dim=100;
CorrIndTestDim(18,n,dim,lim,rep1,rep2);
dim=100;
CorrIndTestDim(19,n,dim,lim,rep1,rep2);
CorrIndTestDim(20,n,dim,lim,rep1,rep2);

%%%%
clear
load('ccidiff-Tmat-org')
n=109; lim=1; rep1=1; rep2=2000;
CorrPermDistTest(C1,T1,rep2,rep2,'CT');

%%%use dcorr to find the optimal neighborhood size
clear
load('BrainCP') 
n=42; lim=1; rep1=2000; rep2=10000;
[p1,p2,p3,~,~,~,~,neighbor]=CorrPermDistTest(distC,distP,rep1,rep2,'BrainCxP');
% mean(p1(neighbor1))
% mean(p2(neighbor2))

%%%
clear
load('BrainHippoShape')
n=114;lim=1; rep1=2000;rep2=10000;alpha=0.05;
y=squareform(pdist(Label));
%y=(y>0)+1;
y=y+1;
for i=1:n
    y(i,i)=0;
end
%estimate optimal scale interchangeably
[power1,power2,power3]=CorrPermDistTest(LMLS,y,rep1,0,'BrainTmp');
neighbor=zeros(3,1);
neighbor(1)=verifyNeighbors(1-power1);neighbor(2)=verifyNeighbors(1-power2);neighbor(3)=verifyNeighbors(1-power3);
CorrPermDistTest(LMRS,y,0,rep2,'BrainLMRxYJ',neighbor);

[power1,power2,power3]=CorrPermDistTest(LMRS,y,rep1,0,'BrainTmp');
neighbor=zeros(3,1);
neighbor(1)=verifyNeighbors(1-power1);neighbor(2)=verifyNeighbors(1-power2);neighbor(3)=verifyNeighbors(1-power3);
CorrPermDistTest(LMLS,y,0,rep2,'BrainLMLxYJ',neighbor);
%estimate optimal scale separately
[p1,p2,p3,~,~,~,~,neighbor]=CorrPermDistTest(LMLS,y,rep1,rep2,'BrainLMLxY');
[p1,p2,p3,~,~,~,~,neighbor]=CorrPermDistTest(LMRS,y,rep1,rep2, 'BrainLMRxY');
CorrPermDistTest(LMLS,LMRS,rep1,rep2,'BrainLMLxLMR');
%%%ind trial
rep1=100;rep2=100;powerL=zeros(7,1);powerR=zeros(7,1);
for i=1:rep2;
    yind=unifrnd(0,3,n,1);
    yind=squareform(pdist(ceil(yind)));
    [power1,power2,power3]=CorrPermDistTest(LMLS,yind,rep1,0,'BrainIndTmp');
    neighbor=zeros(3,1);
    neighbor(1)=verifyNeighbors(1-power1);neighbor(2)=verifyNeighbors(1-power2);neighbor(3)=verifyNeighbors(1-power3);
    [p(1),p(2),p(3),p(4),p(5),p(6),p(7)]=CorrPermDistTest(LMRS,yind,0,rep1,'BrainLMRxYIndJ',neighbor);
    for j=1:7
        if p(j)<alpha
            powerR(j)=powerR(j)+1/rep2;
        end
    end
    
    [power1,power2,power3]=CorrPermDistTest(LMRS,yind,rep1,0,'BrainIndTmp');
    neighbor=zeros(3,1);
    neighbor(1)=verifyNeighbors(1-power1);neighbor(2)=verifyNeighbors(1-power2);neighbor(3)=verifyNeighbors(1-power3);
    [p(1),p(2),p(3),p(4),p(5),p(6),p(7)]=CorrPermDistTest(LMLS,yind,0,rep1,'BrainLMLxYIndJ',neighbor);
    for j=1:7
        if p(j)<alpha
            powerL(j)=powerL(j)+1/rep2;
        end
    end
end
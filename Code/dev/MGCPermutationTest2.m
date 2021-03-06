function  [p,pAll,test,testAll,indAll]=MGCPermutationTest2(A,B,rep,option)
% Author: Cencheng Shen
% This function tests independent between two data sets, using MGC by a random permutation test.
%
% The inputs are:
% two n*n distance matrices A & B,
% a parameter rep to specify the number of random permutations,
% an option to specify which global test to use, set to 1,2,3 for dcorr / mcorr / Mantel.
%
% The outputs are:
% the estimated MGC p-value, the p-values of all local tests, 
% the estimated MGC test statistic, all local test statistics, and the estimated optimal scale. 

if nargin<3
    rep=1000; % use 1000 random permutations by default
end
if nargin<4
    option=2;  % use mcorr by default
end
n=size(A,1);

% calculate all local correlations between the two data sets
testAll=LocalCorr(A,B,option);
p=zeros(21,1);
% calculate the local correlations under permutation, to yield the p-values of all observed local correlations
for r1=1:21
    per1=randperm(n);
    if r1==21
        per1=1:n;
    end
    B2=B(per1,per1);
    for r=1:100;
        % use random permutations on the second data set
        per=randperm(n);
        BN=B2(per,per);
        tmp=LocalCorr(A,BN,option);
        if r==1
            pAll=(tmp>=testAll)/rep;
        else
            pAll=pAll+(tmp>=testAll)/rep;
        end
    end
    % verify and estimate the MGC optimal scale
    [p(r1),indAll]=MGCScaleVerify(pAll,100);
    %p=pAll(ind);
    test=testAll(indAll(end));
end
p=sum(p(1:20)<p(21))/20;
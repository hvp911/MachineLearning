function [actest, actrain] = plotGenerator(wpbcx,wpbcy,n,K)
actest = zeros(K,1);
actrain = zeros(K, 1);
for i = 1:K
    [actest(i),actrain(i)] = kNearestNeighbor(wpbcx,wpbcy, n, i);
end
plot(actest,'b');
hold on;
plot(actrain,'m');
legend('testing accuracy','training accuracy');
hold off;
end
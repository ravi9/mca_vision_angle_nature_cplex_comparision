close all;
%%
metrics = csvread('metrics_90.csv');

figure, plot(metrics(:,2), metrics(:,4), 'b*'); hold on;
plot(metrics(:,2), metrics(:,5), 'ko'); hold off;

% Create xlabel
xlabel('Number of edge segments without sparsification','FontSize',16);
ylabel('Time taken in seconds','FontSize',16);


%%
figure, plot(metrics(:,2), metrics(:,6), 'k*');

%%
metrics = csvread('metrics_95.csv');
figure, plot(metrics(:,2), metrics(:,4), 'b*'); hold on;
plot(metrics(:,2), metrics(:,5), 'go'); hold off;
xlabel('Number of edge segments without sparsification','FontSize',16);
ylabel('Time taken in seconds','FontSize',16);

%%
figure, plot(metrics(:,2), metrics(:,6), 'g*');

%%

metrics = csvread('metrics_98.csv');
figure, plot(metrics(:,2), metrics(:,4), 'b*'); hold on;
plot(metrics(:,2), metrics(:,5), 'ro'); hold off;
xlabel('Number of edge segments without sparsification','FontSize',16);
ylabel('Time taken in seconds','FontSize',16);

%%
figure, plot(metrics(:,2), metrics(:,6), 'r*');


clc;

% 定义状态空间大小

% 构造一个带有振荡特性的转移概率矩阵
% P = [
%     0.0  0.5  0.5  0.0;
%     0.9  0.0  0.1  0.0;
%     0.5  0.1  0.1  0.3;
%     0.0  0.3  0.5  0.2;
% ];
% P = [0.70 0.20 0.10; 0.15 0.75 0.10; 0.05 0.15 0.80];

% % 随机生成一个 n x n 的矩阵
n = 4;
A = rand(n);
P = A ./ sum(A, 2);

% 计算转移概率矩阵的特征值和特征向量
[V, D] = eig(P');

% 显示结果
disp('转移概率矩阵 P:');
disp(P);

disp('特征值 D:');
disp(diag(D));

disp('特征向量矩阵 V:');
disp(V);

stable_vector = V(:, abs(diag(D) - 1) < 1e-10);
if sum(stable_vector) < 0
    stable_vector = - stable_vector;
end
stable_vector = stable_vector / sum(stable_vector);
disp('对应特征值1的特征向量（稳态分布）:');
disp(stable_vector');

% 初始化一个初始分布
% initial_distribution = [1 0 0 0];
initial_distribution = rand(1, size(P,1));
initial_distribution = initial_distribution / sum(initial_distribution);

% 显示初始分布
disp('初始分布:');
disp(initial_distribution);

% 定义乘法次数
num_iterations = 200;

% 保存每一步的人口分布
population_over_time = zeros(num_iterations + 1, size(P, 1));
population_over_time(1, :) = initial_distribution;

% 通过多次乘法来计算每一步的人口分布
for i = 2:num_iterations+1
    population_over_time(i, :) = population_over_time(i-1, :) * P;
end

% 显示最终分布
final_distribution = population_over_time(end, :);
disp('经过多次乘法后的最终分布:');
disp(final_distribution);

% 可视化人口变化
figure;
plot(0:num_iterations, population_over_time, '-');
xlabel('Iterations');
ylabel('Population Distribution');
legend({'City 1', 'City 2', 'City 3', 'City 4'}, 'Location', 'Best');
title('Population Distribution Over Time in 4 Cities');
ylim([0,1/2]);
% grid on;

% P^n
P^100
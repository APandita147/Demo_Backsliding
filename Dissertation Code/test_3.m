clc;
clear;

% Set parameters
alpha_t_1 = rand*0.5 + 0.5; % randomize alpha_t_1 between 0.5 and 1
theta = rand*(1-(-1)) - 1; % randomize theta between -1 and 1
d = 0.5;
time_period = 10;

% Define function for optimization
fun = @(x) -(1 + alpha_t_1*(d*(x - 1))^2)^(-(theta/x));

% Initialize vectors to store parameter values
g_theta_values = zeros(1, time_period);
alpha_t_values = zeros(1, time_period+1);
theta_values = zeros(1, time_period+1);
s_values = zeros(1, time_period);

% Set initial values for theta, alpha_t, and s
theta_values(1) = theta;
alpha_t_values(1) = alpha_t_1;
s_values(1) = theta/g_theta_values(1);

% Run iterations
for t = 1:time_period
    % Optimize g_theta using fminunc
    if theta <= 0
        g_theta = fminunc(fun, 0.1);
    else
        g_theta = 0;
    end
    
    % Update s and alpha_t
    s_values(t) = theta/g_theta;
    alpha_t_values(t+1) = ((2*alpha_t_values(t) + s_values(t))/2) - (d*(g_theta - 1))^2;
    
    % Store parameter values
    g_theta_values(t) = g_theta;
    theta_values(t+1) = rand*(1-(-1)) - 1;
end

% Print summary table
summary_table = table(theta_values(1:end-1)', g_theta_values', alpha_t_values(1:end-1)', s_values', 'VariableNames', {'theta', 'g_theta', 'alpha_t', 's'});
disp(summary_table);

% Plot parameter values over time
figure;
subplot(2,2,1);
plot(0:time_period, theta_values, '-o');
xlabel('Time');
ylabel('theta');
title('Theta over time');

subplot(2,2,2);
plot(1:time_period, g_theta_values, '-o');
xlabel('Time');
ylabel('g_theta');
title('g_theta over time');

subplot(2,2,3);
plot(0:time_period, alpha_t_values, '-o');
xlabel('Time');
ylabel('alpha_t');
title('Alpha_t over time');

subplot(2,2,4);
plot(1:time_period, s_values, '-o');
xlabel('Time');
ylabel('s');
title('s over time');

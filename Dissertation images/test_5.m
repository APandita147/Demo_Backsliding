clc;
clear;

% Set the number of time periods
T = 100;

% Initialize the vectors
alpha_t_1 = 0.5 + 0.5*rand(); % alpha_t-1 belongs to [0,1] 
% theta belongs to [-1,1]
d = 1:-0.01:0; % d starts from 1 and decreases by 0.01 every time period
alpha_t = nan(T,1);% alpha_t vector to store the results
g_theta = nan(T,1); % g_theta vector to store the results
s = nan(T,1); % s vector to store the results
d_vals = nan(T,1); % d vector to store the results
theta_vals = nan(T,1); % theta vector to store the results
alpha_t_1_vals = nan(T,1); % alpha_t-1 vector to store the results

% Loop over time periods
for t = 1:T
    theta_vals(t) = 2*rand - 1; %theta belongs to [-1,1]
    % Calculate s
    if theta_vals(t) >= 0
        g_theta(t) = 1;
        s(t) = theta_vals(t);
    elseif theta_vals(t) < 0
         % Define the objective function for fminunc
        fun = @(g_theta) -((2*alpha_t_1(t)+theta_vals(t)/g_theta)/2-(d(t)*(g_theta-1))^2);
        % Maximize the function with respect to g_theta using fminunc
        g_theta(t) = fminunc(fun, 1);
        s(t) = theta_vals(t)/g_theta(t);
    end
    
    % Update alpha_t using the formula
    alpha_t(t) = (2*alpha_t_1(t)+s(t))/2-(d(t)*(g_theta(t)-1))^2;
    
    % Update alpha_t_1 for the next time period
    alpha_t(t) = max(0, min(1, alpha_t(t)));
    alpha_t_1(t+1) = alpha_t(t);
    % Store the values for the summary table
    d_vals(t) = d(t);
    theta_vals(t) = theta_vals(t);
    alpha_t_1_vals(t) = alpha_t_1(t);
    alpha_t_vals(t) = alpha_t(t);
    g_theta_vals(t) = g_theta(t);
end

% Create a figure for alpha_t and d
figure;
yyaxis left;
plot(1:T, alpha_t_vals, 'LineWidth', 1.5);
ylabel('\alpha_t');
ylim([0, 1]);
yyaxis right;
plot(1:T, d_vals, 'LineWidth', 1.5);
ylabel('d');
xlabel('Time Period');
ylim([0, 1]);

% Create a figure for g_theta
figure;
plot(1:T, g_theta_vals, 'LineWidth', 1.5);
xlabel('Time Period');
ylabel('g_{\theta}');
ylim([0, 2]);

% Create a table from the results
results_table = table(d_vals, theta_vals, alpha_t_1_vals, alpha_t, g_theta);

% Save the table to an Excel file
writetable(results_table, 'results_0.01.xlsx');
clc;
clear;

% Set the number of iterations
num_iterations = 5000;

% Initialize the vectors to store the results for all iterations
num_periods = nan(num_iterations,1);
end_periods = nan(num_iterations,1);

for iter = 1:num_iterations
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
        
        % Stop the simulation if alpha_t goes below 0.5
        if alpha_t(t) < 0.5
            num_periods(iter) = t;
            end_periods(iter) = alpha_t(t);
            break;
        end
    end
end

% Create an Excel file with the summary table
T = table(d_vals, theta_vals, alpha_t_1_vals, alpha_t, g_theta, 'VariableNames', {'d', 'theta', 'alpha_t_1', 'alpha_t', 'g_theta'});
writetable(T, 'summary.xlsx')

% Create a histogram of the number of iterations that end at each time period
histogram(num_periods, 'Normalization', 'probability');
xlabel('Number of time periods before stopping');
ylabel('Frequency');
title('Distribution of iterations before stopping')

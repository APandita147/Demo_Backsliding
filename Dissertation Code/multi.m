clc;
clear;

% Set the number of time periods
T = 100;
num_iterations = 100;

% Initialize the vectors
alpha_t_1 = 0.5 + 0.5*rand(num_iterations, 1); % alpha_t-1 belongs to [0,1]
% theta belongs to [-1,1]
d = 1:-0.01:0; % d starts from 1 and decreases by 0.01 every time period
alpha_t = nan(num_iterations, T); % alpha_t vector to store the results
g_theta = nan(num_iterations, T); % g_theta vector to store the results
s = nan(num_iterations, T); % s vector to store the results
d_vals = nan(num_iterations, T); % d vector to store the results
theta_vals = nan(num_iterations, T); % theta vector to store the results
alpha_t_1_vals = nan(num_iterations, T); % alpha_t-1 vector to store the results

% Loop over iterations
for i = 1:num_iterations
    alpha_t_1_current = alpha_t_1(i);
    
    % Loop over time periods
    for t = 1:T
        theta_vals(i, t) = 2*rand - 1; %theta belongs to [-1,1]
        % Calculate s
        if theta_vals(i, t) >= 0
            g_theta(i, t) = 1;
            s(i, t) = theta_vals(i, t);
        elseif theta_vals(i, t) < 0
            % Define the objective function for fminunc
            fun = @(g_theta) -((2*alpha_t_1_current+theta_vals(i, t)/g_theta)/2-(d(t)*(g_theta-1))^2);
            % Maximize the function with respect to g_theta using fminunc
            g_theta(i, t) = fminunc(fun, 1);
            s(i, t) = theta_vals(i, t)/g_theta(i, t);
        end

        % Update alpha_t using the formula
        alpha_t(i, t) = (2*alpha_t_1_current+s(i, t))/2-(d(t)*(g_theta(i, t)-1))^2;

        % Update alpha_t_1 for the next time period
        alpha_t_1_current = max(0, min(1, alpha_t(i, t)));
        alpha_t_1_vals(i, t) = alpha_t_1_current;
        % Store the values for the summary table
        d_vals(i, t) = d(t);
        theta_vals(i, t) = theta_vals(i, t);
        alpha_t_vals(i, t) = alpha_t(i, t);
        g_theta_vals(i, t) = g_theta(i, t);

        % Stop the iteration if alpha_t goes below 0.5
        if alpha_t_1_current < 0.5
            break;
        end
    end
end

% Count how many iterations end at each time period
count = sum(alpha_t_1_vals < 0.5);
% Create a bar graph to show the results
figure;
bar(1:T, count, 'LineWidth', 1.5);
ylabel('Number of iterations');
xlabel('Time period');

% Create a figure for alpha_t and d
figure;
yyaxis left;
plot(1:T, alpha_t_vals, 'LineWidth', 1.5);
ylabel('\alpha_t');
ylim([0, 1]);
yyaxis right;
plot

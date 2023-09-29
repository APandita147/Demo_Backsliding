% Set number of simulations
num_sims = 10;

% Initialize arrays to store results
time_periods = [];
alpha_ts = [];

% Loop through simulations
for sim = 1:num_sims
    % Parameters
    d = 1; % level of democratization
    alpha_t_1 = 0.5+rand*0.5; % Affinity of the Government in previous period
    time_period = 1; % time period
    
    % Store parameter names and values in arrays
    parameter_names = {'d', 'alpha_t_1', 'time_period', 'theta', 'g_theta', 's', 'alpha_t'};
    parameter_values = [d, alpha_t_1, time_period, 0, 0, 0, alpha_t_1];
    
    % Create Excel file to store parameter values and results
    filename = sprintf('parameters_results_%d.xlsx', sim);
    header_row = {'Parameter', 'Value'};
    xlswrite(filename, header_row, 'Sheet1', 'A1:B1');
    for i = 1:length(parameter_names)
        xlswrite(filename, [parameter_names{i}, parameter_values(i)], 'Sheet1', sprintf('A%d:B%d', i+1, i+1));
    end
    result_header = {'Time Period', 'Alpha_t'};
    xlswrite(filename, result_header, 'Sheet1', 'D1:E1');
    
    % Loop through time periods until alpha_t falls below 0.5
    while parameter_values(end) >= 0.5
        % Update democratization level
        d = d - 0.01;

        % Generate random value for theta between -1 and 1
        theta = 2*rand()-1;

        % Calculate g_theta based on theta
        if theta >= 0
            g_theta = 0;
        else
            g_theta = (abs(theta)/(4*d))^(1/(2*d+1));
        end

        % Calculate s based on theta and g_theta
        if g_theta == 0
            s = theta;
        else
            s = theta/g_theta;
        end

        % Calculate alpha_t based on alpha_t_1, s, and d
        alpha_t = ((2*alpha_t_1 + s)/2) - (g_theta)^(2*d);
        alpha_t = max(min(alpha_t, 1), 0); % limit alpha_t between 0 and 1

        % Update values for next iteration
        time_period = time_period + 1;
        alpha_t_1 = alpha_t;
        parameter_values = [d, alpha_t_1, time_period, theta, g_theta, s, alpha_t];

        % Append parameter values and results to Excel file
        xlswrite(filename, parameter_values, 'Sheet1', sprintf('A%d:G%d', time_period+1, time_period+1));
        xlswrite(filename, [time_period, alpha_t], 'Sheet1', sprintf('D%d:E%d', time_period+1, time_period+1));
    end
    
    % Store time periods and alpha_t values for summary table and plot
    time_periods(:,sim) = [1:time_period-1]';
    alpha_ts(:,sim) = [parameter_values(2:end-1)]';
end

% Plot results for all simulations
figure;
plot(time_periods, alpha_ts, 'LineWidth', 1.5);
xlabel('Time Period');
ylabel('Alpha_t');

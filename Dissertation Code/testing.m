% Parameters
d = 1; % level of democratization
alpha_t_1 = 0.5+rand*0.5; % Affinity of the Government in previous period
max_time_period = 10; % Maximum number of time periods
alpha_t = ((2*alpha_t_1 + s)/2) - (d(g_theta - 1))^2;
% Initialize arrays to store parameter values and time periods
parameter_values = zeros(max_time_period, 7);
time_periods = 1:max_time_period;

% Store initial parameter values
parameter_values(1,:) = [d, alpha_t_1, 1, 0, 0, 0, alpha_t_1];

% Loop through time periods until alpha_t falls below 0.5 or maximum number of time periods is reached
for time_period = 2:max_time_period
    % Update democratization level
    d = d - 0.1;
    d = max(d,0);

    % Generate random value for theta between -1 and 1
    theta = 2*rand()-1;
    
    % Calculate g_theta based on theta
    if theta >= 0
        g_theta = 0;
    else
        g_theta = ;
    end
    
    % Calculate s based on theta and g_theta
    if g_theta == 0
        s = theta;
    else
        s = theta/abs(g_theta+theta);
    end
    
    % Calculate alpha_t based on alpha_t_1, s, and d
    alpha_t = ((2*alpha_t_1 + s)/2) - (g_theta)^(2*d);
    alpha_t = max(min(alpha_t, 1), 0); % limit alpha_t between 0 and 1
    
    % Store parameter values for current time period
    parameter_values(time_period,:) = [d, alpha_t_1, time_period, theta, g_theta, s, alpha_t];
    
       
    % Update alpha_t_1 for next iteration
    alpha_t_1 = alpha_t;
end

% Trim excess rows from parameter_values array
parameter_values = parameter_values(1:time_period,:);

% Create Excel file to store parameter values
filename = 'parameters_final.xlsx';
header_row = {'Parameter', 'Value'};
xlswrite(filename, header_row, 'Sheet1', 'A1:B1');
for i = 1:7
    xlswrite(filename, [parameter_names{i}, parameter_values(1,i)], 'Sheet1', sprintf('A%d:B%d', i+1, i+1));
end
for i = 2:size(parameter_values,1)
    xlswrite(filename, parameter_values(i,:), 'Sheet1', sprintf('A%d:G%d', i+1, i+1));
end

% Plot alpha_t values over time
plot(parameter_values(:,3), parameter_values(:,7));
title('Affinity of Government over Time');
xlabel('Time Period');
ylabel('Affinity of Government');

% Save plot as image file
print('affinity_plot.png', '-dpng');

% Display summary table of parameter values in command window
disp('Summary of parameter values:');
disp(array2table(parameter_values, 'VariableNames', parameter_names));

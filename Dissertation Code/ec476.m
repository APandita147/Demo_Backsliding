% Parameters
d = 1; % level of democratization
alpha_t_1 = 0.5+rand*0.5; % Affinity of the Government in previous period
time_period = 1; % time period

% Store parameter names and values in arrays
parameter_names = {'d', 'alpha_t_1', 'time_period', 'theta', 'g_theta', 's', 'alpha_t'};
parameter_values = [d, alpha_t_1, time_period, 0, 0, 0, alpha_t_1];

% Create Excel file to store parameter values
filename = 'parameters_final.xlsx';
header_row = {'Parameter', 'Value'};
xlswrite(filename, header_row, 'Sheet1', 'A1:B1');
for i = 1:length(parameter_names)
    xlswrite(filename, [parameter_names{i}, parameter_values(i)], 'Sheet1', sprintf('A%d:B%d', i+1, i+1));
end

% Loop through time periods until alpha_t falls below 0.5
while parameter_values(end) >= 0.5 %Question: Maybe we can accomodate some sort of margin, or do without this condition?
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
    
    % Append parameter values to Excel file
    xlswrite(filename, parameter_values, 'Sheet1', sprintf('A%d:G%d', time_period+1, time_period+1));
end

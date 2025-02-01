function [x_pooled,s_pooled,mswd,p_value,CI,twse]=pooled_stat(data)

% Input data: n rows with sample means and standard deviations

% Extract sample means and standard deviations
x_sample = data(:, 1); % Sample means
s_sample = data(:, 2); % Standard deviations

% Calculate weights
weights = 1 ./ (s_sample .^ 2);

% Pooled weighted mean
x_pooled = sum(x_sample .* weights) / sum(weights);

% Numerator and denominator for pooled standard error and MSWD
numerator = sum(weights) * sum(weights .* (x_sample - x_pooled).^2);
denominator = (sum(weights)^2) - sum(weights.^2);

% Pooled standard error
s_pooled = sqrt((1 / length(x_sample)) * (numerator / denominator));

numerator2 = sum(weights) * sum(weights.^2 .* (x_sample - x_pooled).^2);
% MSWD
mswd = numerator2 / denominator;

% Compute chi-squared statistic
chi_squared = sum(((x_sample - x_pooled).^2) ./ (s_sample .^ 2));

% Degrees of freedom
f = length(x_sample) - 1;

% Probability of fit (p-value) using chi-squared cumulative distribution
p_value = 1 - chi2cdf(chi_squared, f);

% Compute t-critical value for 95% confidence
alpha = 0.05;
t_critical = tinv(1 - alpha/2, f);

% Confidence interval
CI = t_critical * s_pooled;

% Compute TWSE
average_variance = mean(s_sample.^2);
combined_error = sqrt(s_pooled^2 + average_variance);
twse = t_critical * combined_error;

% Display results
fprintf('Pooled Weighted Mean: %.4f\n', x_pooled);
fprintf('Pooled Standard Error: %.4f\n', s_pooled);
fprintf('MSWD: %.4f\n', mswd);
fprintf('P-Value (Probability of Fit): %.4f\n', p_value);
fprintf('C.I. Error: %.4f\n', CI);
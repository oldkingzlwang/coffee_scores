clear;clc;
data=readmatrix("判定方法.xlsx","Sheet","总结");
price = data(:,10);
wzl_total=data(:,11);
wzl_1sd=data(:,12);
wbx_total=data(:,14);
wbx_1sd=data(:,15);
total=data(:,17);
total_1sd=data(:,18);
x=80:1:100;

Ethiopia_wzl=wzl_total(1:21);
Ethiopia_wbx=wbx_total(1:21);
Panama_wzl=wzl_total(22:47);
Panama_wbx=wbx_total(22:47);
Columbia_wzl=wzl_total(48:58);
Columbia_wbx=wbx_total(48:58);
KR_wzl=wzl_total(59:62);
KR_wbx=wbx_total(59:62);
CA_wzl=wzl_total(63:70);
CA_wbx=wbx_total(63:70);
SA_wzl=wzl_total(71:78);
SA_wbx=wbx_total(71:78);
Asia_wzl=wzl_total(79:84);
Asia_wbx=wbx_total(79:84);

% 调整箱型图的位置：组内靠近，组间有间距
positions = [];
group_spacing = 2; % 组间距离
for i = 1:7
    positions = [positions, i * group_spacing + [-0.25, 0.25]];
end

% 绘制箱型图
figure;hold on
boxplot(Ethiopia_wzl, 'Positions', positions(1), 'Notch','on','Colors', 'r','Symbol','x','Widths',0.4);
boxplot(Ethiopia_wbx, 'Positions', positions(2), 'Notch','on','Colors', 'b','Symbol','x','Widths',0.4);
boxplot(Panama_wzl, 'Positions', positions(3),  'Notch','on','Colors', 'r','Symbol','x','Widths',0.4);
boxplot(Panama_wbx, 'Positions', positions(4),  'Notch','on','Colors', 'b','Symbol','x','Widths',0.4);
boxplot(Columbia_wzl, 'Positions', positions(5), 'Notch','on','Colors', 'r','Symbol','x','Widths',0.4);
boxplot(Columbia_wbx, 'Positions', positions(6), 'Notch','on','Colors', 'b','Symbol','x','Widths',0.4);
boxplot(KR_wzl, 'Positions', positions(7), 'Notch','on','Colors', 'r','Symbol','x','Widths',0.4);
boxplot(KR_wbx, 'Positions', positions(8), 'Notch','on','Colors', 'b','Symbol','x','Widths',0.4);
boxplot(CA_wzl, 'Positions', positions(9),  'Notch','on','Colors', 'r','Symbol','x','Widths',0.4);
boxplot(CA_wbx, 'Positions', positions(10), 'Notch','on','Colors', 'b','Symbol','x','Widths',0.4);
boxplot(SA_wzl, 'Positions', positions(11),  'Notch','on','Colors', 'r','Symbol','x','Widths',0.4);
boxplot(SA_wbx, 'Positions', positions(12), 'Notch','on','Colors', 'b','Symbol','x','Widths',0.4);
boxplot(Asia_wzl, 'Positions', positions(13), 'Notch','on','Colors', 'r','Symbol','x','Widths',0.4);
boxplot(Asia_wbx, 'Positions', positions(14), 'Notch','on','Colors', 'b','Symbol','x','Widths',0.4);
hold off
xlim([1 15])
ylim([86 97])
set(gca, 'XTick', mean(reshape(positions, 2, [])), 'XTickLabel', ...
    {'Ethiopia', 'Panama', 'Columbia', 'Kenya & Rwanda', 'Central America', 'South America', 'Asia'});

% 添加图形说明
%xlabel('组');
ylabel('Scores');
set(gca, 'Box', 'on', 'xcolor','k','ycolor','k',...
         'FontName', 'Calibri', 'FontSize', 12,...
         'LineWidth', .5, ...
         'XGrid', 'off', 'YGrid', 'off', ...                            
         'TickDir', 'out', 'TickLength', [.01 .01])

% 启用网格
grid on;

% 只显示与 X 轴平行的网格线
set(gca, 'GridLineStyle', '--'); % 设置网格线样式（可选）
set(gca, 'XGrid', 'off', 'YGrid', 'on'); % 关闭X方向网格，仅保留Y方向网格

figureUnits = 'centimeters';
figureHandle = get(groot,'CurrentFigure');
figW = 1000;
figH = 600;
set(figureHandle,'PaperUnits',figureUnits);
set(figureHandle,'Position',[100 100 figW figH]);
set(gca, 'LooseInset', get(gca, 'TightInset')); 
set(gcf, 'PaperPositionMode', 'auto');
figureHandle.Renderer='Painters';
fileout = '4.3';
% exportgraphics(gcf,[fileout,'.pdf'], 'ContentType', 'vector');
print(figureHandle,[fileout,'.png'],'-dpng','-r900');

result=[round(median(Ethiopia_wzl),1),round(quantile(Ethiopia_wzl,[0.25 0.75]),1);
round(median(Ethiopia_wbx),1),round(quantile(Ethiopia_wbx,[0.25 0.75]),1);
round(median(Panama_wzl),1),round(quantile(Panama_wzl,[0.25 0.75]),1);
round(median(Panama_wbx),1),round(quantile(Panama_wbx,[0.25 0.75]),1);
round(median(Columbia_wzl),1),round(quantile(Columbia_wzl,[0.25 0.75]),1);
round(median(Columbia_wbx),1),round(quantile(Columbia_wbx,[0.25 0.75]),1);
round(median(KR_wzl),1),round(quantile(KR_wzl,[0.25 0.75]),1);
round(median(KR_wbx),1),round(quantile(KR_wbx,[0.25 0.75]),1);
round(median(CA_wzl),1),round(quantile(CA_wzl,[0.25 0.75]),1);
round(median(CA_wbx),1),round(quantile(CA_wbx,[0.25 0.75]),1);
round(median(SA_wzl),1),round(quantile(SA_wzl,[0.25 0.75]),1);
round(median(SA_wbx),1),round(quantile(SA_wbx,[0.25 0.75]),1);
round(median(Asia_wzl),1),round(quantile(Asia_wzl,[0.25 0.75]),1);
round(median(Asia_wbx),1),round(quantile(Asia_wbx,[0.25 0.75]),1)];

fprintf('---------------------\n')
fprintf('Mann-Whitney U Test of Ethiopia:\n');
[p_med, ~] = ranksum(Ethiopia_wbx, Ethiopia_wzl);
if p_med < 0.05
    disp('The generated dataset and original dataset differ significantly.')
else
    disp('No significant difference between generated dataset and original dataset.')
end

% Conduct a two-sample t-test
fprintf('Two-sample t-test of Ethiopia:\n');
[~, p_mean] = ttest2(Ethiopia_wzl, Ethiopia_wbx);
if p_mean < 0.05
    disp('Means of the two datasets differ significantly.')
else
    disp('No significant difference in means of the two datasets.')
end

fprintf('---------------------\n')
fprintf('Mann-Whitney U Test of Panama:\n');
[p_med, ~] = ranksum(Panama_wzl, Panama_wbx);
if p_med < 0.05
    disp('The generated dataset and original dataset differ significantly.')
else
    disp('No significant difference between generated dataset and original dataset.')
end

% Conduct a two-sample t-test
fprintf('Two-sample t-test of Panama:\n');
[~, p_mean] = ttest2(Panama_wzl, Panama_wbx);
if p_mean < 0.05
    disp('Means of the two datasets differ significantly.')
else
    disp('No significant difference in means of the two datasets.')
end

fprintf('---------------------\n')
fprintf('Mann-Whitney U Test of Columbia:\n');
[p_med, ~] = ranksum(Columbia_wzl, Columbia_wbx);
if p_med < 0.05
    disp('The generated dataset and original dataset differ significantly.')
else
    disp('No significant difference between generated dataset and original dataset.')
end

% Conduct a two-sample t-test
fprintf('Two-sample t-test of Columbia:\n');
[~, p_mean] = ttest2(Columbia_wzl, Columbia_wbx);
if p_mean < 0.05
    disp('Means of the two datasets differ significantly.')
else
    disp('No significant difference in means of the two datasets.')
end

fprintf('---------------------\n')
fprintf('Mann-Whitney U Test of Kenya & Rwanda:\n');
[p_med, ~] = ranksum(KR_wzl, KR_wbx);
if p_med < 0.05
    disp('The generated dataset and original dataset differ significantly.')
else
    disp('No significant difference between generated dataset and original dataset.')
end

% Conduct a two-sample t-test
fprintf('Two-sample t-test of Kenya & Rwanda:\n');
[~, p_mean] = ttest2(KR_wzl, KR_wbx);
if p_mean < 0.05
    disp('Means of the two datasets differ significantly.')
else
    disp('No significant difference in means of the two datasets.')
end

fprintf('---------------------\n')
fprintf('Mann-Whitney U Test of Central America:\n');
[p_med, ~] = ranksum(CA_wzl, CA_wbx);
if p_med < 0.05
    disp('The generated dataset and original dataset differ significantly.')
else
    disp('No significant difference between generated dataset and original dataset.')
end

% Conduct a two-sample t-test
fprintf('Two-sample t-test of Central America:\n');
[~, p_mean] = ttest2(CA_wzl, CA_wbx);
if p_mean < 0.05
    disp('Means of the two datasets differ significantly.')
else
    disp('No significant difference in means of the two datasets.')
end

fprintf('---------------------\n')
fprintf('Mann-Whitney U Test of South America:\n');
[p_med, ~] = ranksum(SA_wzl, SA_wbx);
if p_med < 0.05
    disp('The generated dataset and original dataset differ significantly.')
else
    disp('No significant difference between generated dataset and original dataset.')
end

% Conduct a two-sample t-test
fprintf('Two-sample t-test of South America:\n');
[~, p_mean] = ttest2(SA_wzl, SA_wbx);
if p_mean < 0.05
    disp('Means of the two datasets differ significantly.')
else
    disp('No significant difference in means of the two datasets.')
end

fprintf('---------------------\n')
fprintf('Mann-Whitney U Test of Asia:\n');
[p_med, ~] = ranksum(Asia_wzl, Asia_wbx);
if p_med < 0.05
    disp('The generated dataset and original dataset differ significantly.')
else
    disp('No significant difference between generated dataset and original dataset.')
end

% Conduct a two-sample t-test
fprintf('Two-sample t-test of Asia:\n');
[~, p_mean] = ttest2(Asia_wzl, Asia_wbx);
if p_mean < 0.05
    disp('Means of the two datasets differ significantly.')
else
    disp('No significant difference in means of the two datasets.')
end
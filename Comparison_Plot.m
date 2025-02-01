clear;clc;
data=readmatrix("判定方法.xlsx","Sheet","总结");
price = data(:,10);
wzl_total=data(:,11);
wzl_1sd=data(:,12);
wbx_total=data(:,14);
wbx_1sd=data(:,15);
total=data(:,17);
total_1sd=data(:,18);

%% 绘制王氏和汪氏标准的QQ图和分布拟合图（图4.1）

fprintf('---------------------\n')
fprintf('检验汪氏分数是否服从正态分布:\n');

% 检验正态性
[h, p] = kstest((wbx_total - mean(wbx_total)) / std(wbx_total));
if h == 0
    fprintf('数据可能服从正态分布 (p = %.4f).\n', p);
else
    fprintf('数据不服从正态分布 (p = %.4f).\n', p);
end

fprintf('---------------------\n')
fprintf('检验王氏分数是否服从 t 位置尺度分布，并输出拟合参数:\n');

pd = fitdist(wzl_total, 'tLocationScale');
fprintf('位置参数 (mu): %.4f\n', pd.mu);
fprintf('尺度参数 (sigma): %.4f\n', pd.sigma);
fprintf('自由度参数 (nu): %.4f\n', pd.nu);
[h, p] = adtest(wzl_total, 'Distribution', pd);

% 输出结果
if h == 0
    fprintf('数据符合 t 位置尺度分布 (p = %.4f).\n', p);
else
    fprintf('数据不符合 t 位置尺度分布 (p = %.4f).\n', p);
end

figure;
tiledlayout(2,2,'TileSpacing','compact','Padding','compact');
% 图a: wbx_total 的 QQ 图
nexttile;
h1 = qqplot(wbx_total);
set(h1(1),'Marker','+','MarkerEdgeColor','k','MarkerSize',10);
set(h1(2),'Color','none')
set(h1(3),'LineWidth',1.5,'LineStyle','--')
title('a. QQ Plot of Baoxin Wang''s scores');
xlabel('Standard normal quantile');
ylabel('Quantile of the input sample');
set(gca, 'Box', 'on', 'xcolor','k','ycolor','k',...
         'FontName', 'Calibri', 'FontSize', 12,...
         'LineWidth', .5, ...
         'XGrid', 'off', 'YGrid', 'off', ...                            
         'TickDir', 'out', 'TickLength', [.01 .01])
lg1 = legend('Baoxin Wang''s scores','','Standard normal distribution','Location','southeast');
set(lg1, 'FontName',  'Calibri', 'FontSize', 12)

% 图b: wzl_total 的 QQ 图
nexttile;
h2 = qqplot(wzl_total);
set(h2(1),'Marker','+','MarkerEdgeColor','k','MarkerSize',10);
set(h2(2),'Color','none')
set(h2(3),'LineWidth',1.5,'LineStyle','--')
title('b. QQ Plot of Zilong Wang''s scores');
xlabel('Standard normal quantile');
ylabel('Quantile of the input sample');
set(gca, 'Box', 'on', 'xcolor','k','ycolor','k',...
         'FontName', 'Calibri', 'FontSize', 12,...
         'LineWidth', .5, ...
         'XGrid', 'off', 'YGrid', 'off', ...                            
         'TickDir', 'out', 'TickLength', [.01 .01])
lg2 = legend('Zilong Wang''s scores','','Standard normal distribution','Location','southeast');
set(lg2, 'FontName',  'Calibri', 'FontSize', 12)

% 图c: wbx_total 的直方图 + 正态分布拟合
nexttile;
histogram(wbx_total,20, 'Normalization', 'pdf', 'EdgeColor', 'none');
hold on;
pd_normal = fitdist(wbx_total, 'Normal'); % 拟合正态分布
x = linspace(min(wbx_total), max(wbx_total), 100);
plot(x, pdf(pd_normal, x), 'r-', 'LineWidth', 2);
hold off;
title('c. Histogram of Baoxin Wang''s scores with Normal Fit');
xlabel('Baoxin Wang''s standard scores');
ylabel('Density');
lgd1=legend('Histogram', 'Normal Fit');
set(gca, 'Box', 'on', 'xcolor','k','ycolor','k',...
         'FontName', 'Calibri', 'FontSize', 12,...
         'LineWidth', .5, ...
         'XGrid', 'off', 'YGrid', 'off', ...                            
         'TickDir', 'out', 'TickLength', [.01 .01])
set(lgd1, 'FontName',  'Calibri', 'FontSize', 12)

% 图d: wzl_total 的直方图 + t 位置尺度分布拟合
nexttile;
histogram(wzl_total,20, 'Normalization', 'pdf', 'EdgeColor', 'none');
hold on;
pd_t = fitdist(wzl_total, 'tLocationScale'); % 拟合 t 位置尺度分布
x = linspace(min(wzl_total), max(wzl_total), 100);
plot(x, pdf(pd_t, x), 'r-', 'LineWidth', 2);
hold off;
title('d. Histogram of Zilong Wang''s scores with t-Location-Scale Fit');
xlabel('Zilong Wang''s standard scores');
ylabel('Density');
lgd2=legend('Histogram', 't-Location-Scale Fit','Location','northwest');
set(gca, 'Box', 'on', 'xcolor','k','ycolor','k',...
         'FontName', 'Calibri', 'FontSize', 12,...
         'LineWidth', .5, ...
         'XGrid', 'off', 'YGrid', 'off', ...                            
         'TickDir', 'out', 'TickLength', [.01 .01])
set(lgd2, 'FontName',  'Calibri', 'FontSize', 12)

% 调整子图间距
set(gcf, 'Position', [100, 100, 1200, 800]); % 使图窗更大

figureUnits = 'centimeters';
figureHandle = get(groot,'CurrentFigure');
set(gcf, 'PaperPositionMode', 'auto');
figureHandle.Renderer='Painters';
fileout = '4.1';
% exportgraphics(gcf,[fileout,'.pdf'], 'ContentType', 'vector');
print(figureHandle,[fileout,'.png'],'-dpng','-r900');

close all

%% 绘制王氏和汪氏标准的散点-频率分布图（图4.2）

x=80:1:100;

%C=TheColor('sci',206,'map',7);

C=[0.647058823529412	0	0.129411764705882
0.929411764705882	0.333333333333333	0.309803921568627
1	0.745098039215686	0.498039215686275
1	1	0.749019607843137
0.737254901960784	0.980392156862745	1
0.380392156862745	0.772549019607843	1
0.149019607843137	0.298039215686275	1];

figure('Units','normalized','Position',[0.2 0.2 0.6 0.6]);

mainAxes = axes('Position',[0.13,0.13,0.6,0.6]);
hold on
p0=plot(x,x,'Color','k','LineStyle','--','LineWidth',0.75);
p1=errorbar(wzl_total(1:21),wbx_total(1:21),wbx_1sd(1:21),wbx_1sd(1:21),wzl_1sd(1:21),wzl_1sd(1:21),...
    'LineStyle','none','Marker','o','MarkerSize',8,'MarkerEdgeColor','k','MarkerFaceColor',C(1,:),...
    'CapSize',0,'Color',C(1,:)); % Ethiopia
p2=errorbar(wzl_total(22:47),wbx_total(22:47),wbx_1sd(22:47),wbx_1sd(22:47),wzl_1sd(22:47),wzl_1sd(22:47),...
    'LineStyle','none','Marker','o','MarkerSize',8,'MarkerEdgeColor','k','MarkerFaceColor',C(2,:),...
    'CapSize',0,'Color',C(2,:)); % Panama
p3=errorbar(wzl_total(48:58),wbx_total(48:58),wbx_1sd(48:58),wbx_1sd(48:58),wzl_1sd(48:58),wzl_1sd(48:58),...
    'LineStyle','none','Marker','o','MarkerSize',8,'MarkerEdgeColor','k','MarkerFaceColor',C(3,:),...
    'CapSize',0,'Color',C(3,:)); % Columbia
p4=errorbar(wzl_total(59:62),wbx_total(59:62),wbx_1sd(59:62),wbx_1sd(59:62),wzl_1sd(59:62),wzl_1sd(59:62),...
    'LineStyle','none','Marker','o','MarkerSize',8,'MarkerEdgeColor','k','MarkerFaceColor',C(4,:),...
    'CapSize',0,'Color',C(4,:)); % Kenya & Rwanda
p5=errorbar(wzl_total(63:70),wbx_total(63:70),wbx_1sd(63:70),wbx_1sd(63:70),wzl_1sd(63:70),wzl_1sd(63:70),...
    'LineStyle','none','Marker','o','MarkerSize',8,'MarkerEdgeColor','k','MarkerFaceColor',C(5,:),...
    'CapSize',0,'Color',C(5,:)); % Central America
p6=errorbar(wzl_total(71:78),wbx_total(71:78),wbx_1sd(71:78),wbx_1sd(71:78),wzl_1sd(71:78),wzl_1sd(71:78),...
    'LineStyle','none','Marker','o','MarkerSize',8,'MarkerEdgeColor','k','MarkerFaceColor',C(6,:),...
    'CapSize',0,'Color',C(6,:)); % South America
p7=errorbar(wzl_total(79:84),wbx_total(79:84),wbx_1sd(79:84),wbx_1sd(79:84),wzl_1sd(79:84),wzl_1sd(79:84),...
    'LineStyle','none','Marker','o','MarkerSize',8,'MarkerEdgeColor','k','MarkerFaceColor',C(7,:),...
    'CapSize',0,'Color',C(7,:)); % Asia

hold off

lgd=legend('1:1 Line','Ethiopia','Panama','Columbia','Kenya & Rwanda',...
    'Central America','South America','Asia',...
    'Location', 'northwest');

xlim([80 100]);xlabel('Zilong Wang''s standard scores');
ylim([86 98]);ylabel('Baoxin Wang''s standard scores');
set(gca, 'Box', 'on', 'xcolor','k','ycolor','k',...
         'FontName', 'Calibri', 'FontSize', 12,...
         'LineWidth', .5, ...
         'XGrid', 'off', 'YGrid', 'off', ...                            
         'TickDir', 'out', 'TickLength', [.01 .01])
set(lgd, 'FontName',  'Calibri', 'FontSize', 12)

% 上侧直方图坐标区
histAxesX = axes('Position',[0.13,0.76,0.6,0.2]);
histogram(wzl_total, 10,'Normalization','pdf','FaceColor',[0.8,0.8,0.8]);
set(histAxesX, 'XTickLabel',[], 'XTick',[], 'YTick',[]);
box on;

% 右侧直方图坐标区
histAxesY = axes('Position',[0.76, 0.13, 0.2,0.6]);
histogram(wbx_total, 10,'Orientation','horizontal', ...
          'Normalization','pdf','FaceColor',[0.8,0.8,0.8]);
set(histAxesY, 'XTickLabel',[], 'XTick',[], 'YTick',[]);
box on;

% 同步坐标轴范围
linkaxes([mainAxes, histAxesX],'x');
linkaxes([mainAxes, histAxesY],'y');

figureUnits = 'centimeters';
figureHandle = get(groot,'CurrentFigure');
figW = 700;
figH = 700;
set(figureHandle,'PaperUnits',figureUnits);
set(figureHandle,'Position',[100 100 figW figH]);
set(gca, 'LooseInset', get(gca, 'TightInset')); 
set(gcf, 'PaperPositionMode', 'auto');
figureHandle.Renderer='Painters';
fileout = '4.2';
% exportgraphics(gcf,[fileout,'.pdf'], 'ContentType', 'vector');
print(figureHandle,[fileout,'.png'],'-dpng','-r900');

fprintf('---------------------\n')
fprintf('Mann-Whitney U Test of Total:\n');
[p_med, ~] = ranksum(wzl_total, wbx_total);
if p_med < 0.05
    disp('The generated dataset and original dataset differ significantly.')
else
    disp('No significant difference between generated dataset and original dataset.')
end

% Conduct a two-sample t-test
fprintf('Two-sample t-test of Total:\n');
[~, p_mean] = ttest2(wzl_total, wbx_total);
if p_mean < 0.05
    disp('Means of the two datasets differ significantly.')
else
    disp('No significant difference in means of the two datasets.')
end

close all
clear; clc;

% 1. 构建示例数据
parent_data = readtable("判定方法.xlsx", "Sheet", "总结",'VariableNamingRule','preserve');
nation = parent_data.("国家");
shop = parent_data.("生产商");
item = parent_data.("名称");
price = parent_data.("百克价格");  % 成本型指标
perf = parent_data.("总分");   % 效益型指标
uncer = parent_data.("标准差_2");  % 成本型指标（性能的不确定度）
data = table(item, price, perf, uncer, nation, shop);

% 2. 对价格、性能和不确定度进行对数归一化
data_norm = zeros(height(data), 3);

for j = 1:3
    colData = data{:, j+1};
    colData(colData <= 0) = 1e-2;    % 保证对数运算内不为0
    log_colData = log(colData);  % 对数变换

    if j == 1 || j == 3  % 成本型指标（价格和性能不确定度）
        % 对成本型指标进行归一化后取反，值越小越好
        data_norm(:, j) = (max(log_colData) - log_colData) / (max(log_colData) - min(log_colData));
    else  % 效益型指标（性能）
        % 对效益型指标进行归一化，值越大越好
        data_norm(:, j) = (log_colData - min(log_colData)) / (max(log_colData) - min(log_colData));
    end
end

% 3. 定义权重搜索范围
step = 0.01;  % 每次权重增加的步长
weight_range = 0:step:1;  % 权重范围 [0, 1]
best_weights = [0, 0, 0];  % 用于存储最优权重
min_loss = Inf;  % 初始化最小损失值

% 网格搜索权重
for w1 = weight_range
    for w2 = weight_range
        w3 = 1 - w1 - w2;  % 自动计算 w3，确保权重总和为 1
        if w3 < 0  % 如果 w3 小于 0，跳过无效组合
            continue;
        end

        weights = [w1, w2, w3];

        % 加权标准化
        data_weighted = data_norm .* weights;

        % 计算性价比
        ideal_solution = max(data_weighted, [], 1);  % 理想解
        negative_solution = min(data_weighted, [], 1);  % 负理想解
        D_plus = sqrt(sum((data_weighted - ideal_solution).^2, 2));
        D_minus = sqrt(sum((data_weighted - negative_solution).^2, 2));
        CC = D_minus ./ (D_plus + D_minus);

        % 计算性价比与各指标的相关性
        corr_price = corr(CC, data_norm(:,1));  % 性价比与价格的相关性
        corr_perf = corr(CC, data_norm(:,2));  % 性价比与性能的相关性
        corr_uncer = corr(CC, data_norm(:,3)); % 性价比与不确定度的相关性

        % 优化目标：使相关性差异最小
        loss = std([corr_price, corr_perf, corr_uncer]);  % 标准差最小化
        if loss < min_loss
            min_loss = loss;
            best_weights = weights;  % 更新最优权重
        end
    end
end

% 4. 输出最优权重
disp('最优权重:');
disp(best_weights);

% 使用最优权重重新计算性价比
data_weighted = data_norm .* best_weights;
ideal_solution = max(data_weighted, [], 1);
negative_solution = min(data_weighted, [], 1);
D_plus = sqrt(sum((data_weighted - ideal_solution).^2, 2));
D_minus = sqrt(sum((data_weighted - negative_solution).^2, 2));
CC = D_minus ./ (D_plus + D_minus);

% 输出性价比结果
data.CC = CC;
[~, idx] = sort(data.CC, 'descend');
sortedData = data(idx,:);
disp('优化后排序结果:');
disp(sortedData);

% 导出排序结果
writetable(sortedData,'性价比.xlsx');

figure
hold on
% histogram(data_norm(:,1),10);
% histogram(data_norm(:,2),10);
% histogram(data_norm(:,3),10);
[S,AX,BigAx,H,HAx] = plotmatrix([1-data_norm(:,1),data_norm(:,2),1-data_norm(:,3)]);

hold off
set([AX(1,1),AX(1,2),AX(1,3),AX(2,1),AX(2,2),AX(2,3),AX(3,1),AX(3,2),AX(3,3)], ...
    'Box', 'on', 'xcolor','k','ycolor','k',...
    'FontName', 'Calibri', 'FontSize', 10,...
    'LineWidth', .5, ...                          
    'TickDir', 'in', 'TickLength', [.01 .01])
xlabel(AX(3,1),'Price','FontSize',12,'FontName','Calibri')
xlabel(AX(3,2),'Performance','FontSize',12,'FontName','Calibri')
xlabel(AX(3,3),'Uncertainty','FontSize',12,'FontName','Calibri')
ylabel(AX(1,1),'Price','FontSize',12,'FontName','Calibri')
ylabel(AX(2,1),'Performance','FontSize',12,'FontName','Calibri')
ylabel(AX(3,1),'Uncertainty','FontSize',12,'FontName','Calibri')

% AX是一个n x n的坐标区句柄矩阵，这里n=3
n = size(AX,1);

% 删除上三角子图(行<列)
for i = 1:n
    for j = i+1:n
        delete(AX(i,j));  % 移除上三角对应的axes
    end
end

%% 导出图片
figureUnits = 'centimeters';
figureHandle = get(groot,'CurrentFigure');
figW = 850;
figH = 800;
set(figureHandle,'PaperUnits',figureUnits);
set(figureHandle,'Position',[100 100 figW figH]);
%set(gca, 'LooseInset', get(gca, 'TightInset')); 
set(gcf, 'PaperPositionMode', 'auto');
figureHandle.Renderer='Painters';
fileout = '4.4';
% exportgraphics(gcf,[fileout,'.pdf'], 'ContentType', 'vector');
print(figureHandle,[fileout,'.png'],'-dpng','-r900');

%% 按产区分类
nation_Ethiopia = sortedData(strcmp(sortedData.nation, '埃塞俄比亚'), :);
nation_Panama = sortedData(strcmp(sortedData.nation, '巴拿马'), :);
nation_Columbia = sortedData(strcmp(sortedData.nation, '哥伦比亚'), :);
nation_KR = sortedData(strcmp(sortedData.nation, '肯尼亚') | ...
    strcmp(sortedData.nation, '卢旺达'), :);
nation_CA = sortedData(strcmp(sortedData.nation, '危地马拉') | ...
    strcmp(sortedData.nation, '洪都拉斯') | ...
    strcmp(sortedData.nation, '萨尔瓦多') | ...
    strcmp(sortedData.nation, '尼加拉瓜') | ...
    strcmp(sortedData.nation, '墨西哥'), :);
nation_SA = sortedData(strcmp(sortedData.nation, '玻利维亚') | ...
    strcmp(sortedData.nation, '厄瓜多尔') | ...
    strcmp(sortedData.nation, '秘鲁') | ...
    strcmp(sortedData.nation, '巴西'), :);
nation_Asia = sortedData(strcmp(sortedData.nation, '中国云南') | ...
    strcmp(sortedData.nation, '中国台湾') | ...
    strcmp(sortedData.nation, '马来西亚') | ...
    strcmp(sortedData.nation, '巴布亚新几内亚'), :);

[x_Ethi,s_Ethi,mswd_Ethi,~,CI_Ethi,~]=pooled_stat([nation_Ethiopia.perf,nation_Ethiopia.uncer]);
[x_Pana,s_Pana,mswd_Pana,~,CI_Pana,~]=pooled_stat([nation_Panama.perf,nation_Panama.uncer]);
[x_Colu,s_Colu,mswd_Colu,~,CI_Colu,~]=pooled_stat([nation_Columbia.perf,nation_Columbia.uncer]);
[x_KR,s_KR,mswd_KR,~,CI_KR,~]=pooled_stat([nation_KR.perf,nation_KR.uncer]);
[x_CA,s_CA,mswd_CA,~,CI_CA,~]=pooled_stat([nation_CA.perf,nation_CA.uncer]);
[x_SA,s_SA,mswd_SA,~,CI_SA,~]=pooled_stat([nation_SA.perf,nation_SA.uncer]);
[x_Asia,s_Asia,mswd_Asia,~,CI_Asia,~]=pooled_stat([nation_Asia.perf,nation_Asia.uncer]);

CC_Ethi = round(mean(nation_Ethiopia.CC),2); CC_Ethi_std = round(std(nation_Ethiopia.CC),2); 
CC_Pana = round(mean(nation_Panama.CC),2); CC_Pana_std = round(std(nation_Panama.CC),2);
CC_Colu = round(mean(nation_Columbia.CC),2); CC_Colu_std = round(std(nation_Columbia.CC),2);
CC_KR = round(mean(nation_KR.CC),2); CC_KR_std = round(std(nation_KR.CC),2);
CC_CA = round(mean(nation_CA.CC),2); CC_CA_std = round(std(nation_CA.CC),2);
CC_SA = round(mean(nation_SA.CC),2); CC_SA_std = round(std(nation_SA.CC),2);
CC_Asia = round(mean(nation_Asia.CC),2); CC_Asia_std = round(std(nation_Asia.CC),2); 

T_score = table(["埃塞俄比亚"; "巴拿马"; "哥伦比亚"; "肯尼亚/卢旺达"; "中美洲"; "南美洲"; "亚洲"],...
          round([x_Ethi; x_Pana; x_Colu; x_KR; x_CA; x_SA; x_Asia],2), ...
          round([CI_Ethi; CI_Pana; CI_Colu; CI_KR; CI_CA; CI_SA; CI_Asia],2), ...
          round([mswd_Ethi; mswd_Pana; mswd_Colu; mswd_KR; mswd_CA; mswd_SA; mswd_Asia],2), ...
          round([CC_Ethi; CC_Pana; CC_Colu; CC_KR; CC_CA; CC_SA; CC_Asia],2), ...
          round([CC_Ethi_std; CC_Pana_std; CC_Colu_std; CC_KR_std; CC_CA_std; CC_SA_std; CC_Asia_std],2), ...
          'VariableNames', {'国家或地区', '杯测分数合并加权平均', '95%置信区间', 'MSWD', ...
          '性价比', '1SD'});

%% 按商家分类

shop_apollo = sortedData(strcmp(sortedData.shop, 'Apollon''s Gold'), :);
shop_CCRA = sortedData(strcmp(sortedData.shop, 'CCRA'), :);
shop_CHG = sortedData(strcmp(sortedData.shop, 'CHG'), :);
shop_circulor = sortedData(strcmp(sortedData.shop, 'Coffea Circulor'), :);
shop_grandcru = sortedData(strcmp(sortedData.shop, 'GrandCru'), :);
shop_chuwu = sortedData(strcmp(sortedData.shop, '初吾咖啡'), :);
shop_qicheng = sortedData(strcmp(sortedData.shop, '啟程拓殖'), :);
shop_miao = sortedData(strcmp(sortedData.shop, '喵小雅'), :);
shop_talasu = sortedData(strcmp(sortedData.shop, '塔拉苏咖啡馆'), :);
shop_jinli = sortedData(strcmp(sortedData.shop, '尽力而为'), :);
shop_hongqiu = sortedData(strcmp(sortedData.shop, '红球咖啡'), :);
shop_dawenxi = sortedData(strcmp(sortedData.shop, '达文西咖啡'), :);

[x_apollo,s_apollo,mswd_apollo,~,CI_apollo,~]=pooled_stat([shop_apollo.perf,shop_apollo.uncer]);
[x_CCRA,s_CCRA,mswd_CCRA,~,CI_CCRA,~]=pooled_stat([shop_CCRA.perf,shop_CCRA.uncer]);
[x_CHG,s_CHG,mswd_CHG,~,CI_CHG,~]=pooled_stat([shop_CHG.perf,shop_CHG.uncer]);
[x_circulor, s_circulor, mswd_circulor, ~, CI_circulor, ~] = pooled_stat([shop_circulor.perf, shop_circulor.uncer]);
[x_grandcru, s_grandcru, mswd_grandcru, ~, CI_grandcru, ~] = pooled_stat([shop_grandcru.perf, shop_grandcru.uncer]);
[x_chuwu, s_chuwu, mswd_chuwu, ~, CI_chuwu, ~] = pooled_stat([shop_chuwu.perf, shop_chuwu.uncer]);
[x_qicheng, s_qicheng, mswd_qicheng, ~, CI_qicheng, ~] = pooled_stat([shop_qicheng.perf, shop_qicheng.uncer]);
[x_miao, s_miao, mswd_miao, ~, CI_miao, ~] = pooled_stat([shop_miao.perf, shop_miao.uncer]);
[x_talasu, s_talasu, mswd_talasu, ~, CI_talasu, ~] = pooled_stat([shop_talasu.perf, shop_talasu.uncer]);
[x_jinli, s_jinli, mswd_jinli, ~, CI_jinli, ~] = pooled_stat([shop_jinli.perf, shop_jinli.uncer]);
[x_hongqiu, s_hongqiu, mswd_hongqiu, ~, CI_hongqiu, ~] = pooled_stat([shop_hongqiu.perf, shop_hongqiu.uncer]);
[x_dawenxi, s_dawenxi, mswd_dawenxi, ~, CI_dawenxi, ~] = pooled_stat([shop_dawenxi.perf, shop_dawenxi.uncer]);

CC_apollo = mean(shop_apollo.CC); CC_apollo_std = std(shop_apollo.CC); 
CC_CCRA = mean(shop_CCRA.CC); CC_CCRA_std = std(shop_CCRA.CC); 
CC_CHG = mean(shop_CHG.CC); CC_CHG_std = std(shop_CHG.CC); 
CC_circulor = mean(shop_circulor.CC); CC_circulor_std = std(shop_circulor.CC); 
CC_grandcru = mean(shop_grandcru.CC); CC_grandcru_std = std(shop_grandcru.CC); 
CC_chuwu = mean(shop_chuwu.CC); CC_chuwu_std = std(shop_chuwu.CC); 
CC_qicheng = mean(shop_qicheng.CC); CC_qicheng_std = std(shop_qicheng.CC); 
CC_miao = mean(shop_miao.CC); CC_miao_std = std(shop_miao.CC); 
CC_talasu = mean(shop_talasu.CC); CC_talasu_std = std(shop_talasu.CC); 
CC_jinli = mean(shop_jinli.CC); CC_jinli_std = std(shop_jinli.CC); 
CC_hongqiu = mean(shop_hongqiu.CC); CC_hongqiu_std = std(shop_hongqiu.CC); 
CC_dawenxi = mean(shop_dawenxi.CC); CC_dawenxi_std = std(shop_dawenxi.CC); 

T_shop = table(["Apollon''s Gold"; "CCRA"; "CHG"; "Coffea Circulor"; "GrandCru";...
    "初吾咖啡"; "啟程拓殖"; "喵小雅"; "塔拉苏咖啡馆"; "尽力而为"; "红球咖啡"; "达文西咖啡"],...
          round([x_apollo; x_CCRA; x_CHG; x_circulor; x_grandcru; x_chuwu;...
          x_qicheng; x_miao; x_talasu; x_jinli; x_hongqiu; x_dawenxi], 2), ...
          round([CI_apollo; CI_CCRA; CI_CHG; CI_circulor; CI_grandcru; ...
          CI_chuwu; CI_qicheng; CI_miao; CI_talasu; CI_jinli; CI_hongqiu; CI_dawenxi], 2), ...
          round([mswd_apollo; mswd_CCRA; mswd_CHG; mswd_circulor; mswd_grandcru; ...
          mswd_chuwu; mswd_qicheng; mswd_miao; mswd_talasu; mswd_jinli; mswd_hongqiu; mswd_dawenxi], 2), ...
          round([CC_apollo; CC_CCRA; CC_CHG; CC_circulor; CC_grandcru; CC_chuwu; ...
          CC_qicheng; CC_miao; CC_talasu; CC_jinli; CC_hongqiu; CC_dawenxi], 2), ...
          round([CC_apollo_std; CC_CCRA_std; CC_CHG_std; CC_circulor_std; CC_grandcru_std; ...
          CC_chuwu_std; CC_qicheng_std; CC_miao_std; CC_talasu_std; CC_jinli_std; CC_hongqiu_std; CC_dawenxi_std], 2), ...
          'VariableNames', {'国家或地区', '杯测分数合并加权平均', '95%置信区间', 'MSWD', ...
          '性价比', '1SD'});

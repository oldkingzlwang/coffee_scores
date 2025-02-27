# 第三季咖啡评鉴杯测数据与代码
中文代码库，包含公众号文章《咖啡评鉴（第三期）总结》的原始数据和源代码。

This repository is organized in Chinese, including the original data and source codes of the official account article "Summary of Coffee Evaluation (Volume 3rd)".

本套代码包含三个独立的m文件：`Box_Plot.m`、`Comparison_Plot.m`和`Cost_Performance_Model.m`，分别用于生成推送中的统计图4.3、4.1和4.2，以及4.4。此外，还会自动进行统计检验和分析，并在命令行中输出相应内容。此外，函数`pooled_stat.m`在上述m文件中被调用，以进行推送中第3.1.3节所述的合并加权平均值及其误差计算的步骤。以下是三个函数的详细含义和使用方法。

This code package consists of three independent MATLAB `.m` files: `Box_Plot.m`, `Comparison_Plot.m`, and `Cost_Performance_Model.m`, which are used to generate the statistical plots 4.3, 4.1/4.2, and 4.4 from the analysis, respectively. Additionally, the code automatically performs statistical tests and analyses, outputting the corresponding results in the command window. Furthermore, the function `pooled_stat.m` is called within the aforementioned `.m` files to execute the steps for calculating the pooled weighted mean and its associated error, as described in Section 3.1.3 of the Wechat article. Below is a detailed explanation of the purpose and usage of each function.



[TOC]

### **Box_Plot.m 使用说明**

#### **1. 文件简介**

`Box_Plot.m` 是一个用于分析和可视化不同咖啡产区评分分布的 MATLAB 脚本。该脚本读取评分数据，基于 **箱线图（Box Plot）** 展示 **七大咖啡产区**（埃塞俄比亚、巴拿马、哥伦比亚、肯尼亚和卢旺达、中美洲、南美洲、亚洲）在 **汪氏评分体系（wbx）** 和 **王氏评分体系（wzl）** 下的评分分布，同时进行统计检验（Mann-Whitney U 检验和双样本 t 检验），分析两种评分体系的评分是否存在显著性差异。

------

#### **2. 输入数据**

- **数据文件**：`判定方法.xlsx`
- **数据表**：`总结`
- 数据格式：
  - 第 10 列（`price`）：价格信息
  - 第 11 列（`wzl_total`）：王氏评分
  - 第 12 列（`wzl_1sd`）：王氏评分标准差
  - 第 14 列（`wbx_total`）：汪氏评分
  - 第 15 列（`wbx_1sd`）：汪氏评分标准差
  - 第 17 列（`total`）：综合评分
  - 第 18 列（`total_1sd`）：综合评分标准差

------

#### **3. 输出结果**

##### **（1）数据可视化**

- **箱线图（Box Plot）**：
  - **横轴（X 轴）**：七大咖啡产区
  - **纵轴（Y 轴）**：评分（Scores）
  - 颜色区分：
    - **红色（r）**：王氏评分体系（wzl）
    - **蓝色（b）**：汪氏评分体系（wbx）
  - 统计信息：
    - **中位数**（箱体中间线）
    - **25% - 75% 四分位范围**（箱体）
    - **离群值**（"×" 标记）
    - **最大值与最小值**（去除离群值后）
- **输出图片**
  - `4.3.png`（对应推送中的图4.3）
  - 可选：向量格式 `4.3.pdf`（如需启用 `exportgraphics`）

##### **（2）统计检验**

- **Mann-Whitney U 检验**
  - 非参数检验，用于判断王氏评分与汪氏评分在同一产区内是否有显著统计学差异。
  - p 值 **< 0.05**：两种评分体系在该产区评分显著不同。
  - p 值 **≥ 0.05**：无显著差异，说明评分体系在该产区内一致性较强。
- **双样本 t 检验**
  - 用于比较两个评分体系的均值是否存在显著差异。
  - p 值 **< 0.05**：两组评分均值存在显著统计学差异。
  - p 值 **≥ 0.05**：无显著差异。
- **统计检验范围**包括埃塞俄比亚、巴拿马、哥伦比亚、肯尼亚/卢旺达、中美洲、南美洲和亚洲这七个产区。

------

#### **4. 注意事项**

1. 确保 `判定方法.xlsx` 存在于 MATLAB 当前工作目录下。
2. 确保数据表 `总结` 包含所有必需列。
3. 运行完成后，在 MATLAB 命令窗口中查看统计检验的结果。
4. `4.3.png` 图像将保存到当前工作目录中。

------



### **Comparison_Plot.m 使用说明**

#### **1. 文件简介**

`Comparison_Plot.m` 用于分析和比较两种评分体系（王氏评分体系 Baoxin Wang 和汪氏评分体系 Zilong Wang）的数据分布特性，并进行统计检验。该脚本生成以下主要分析图表：

- **QQ 图（Quantile-Quantile Plot）**：用于检查两种评分体系是否符合特定的概率分布。
- **分布拟合直方图**：用于比较王氏和汪氏评分的概率密度分布，并拟合相应的统计模型。
- **散点图 + 误差条 + 直方图（Comparison Scatter Plot with Histograms）**：用于直观展示两种评分体系在不同产区的评分趋势，并结合误差条（1σ 标准差）分析分布特性。
- **统计检验**（Mann-Whitney U 检验 & 双样本 t 检验）：用于判断两种评分体系的统计差异性。

------

#### **2. 输入数据**

- **数据文件**：`判定方法.xlsx`
- **数据表**：`总结`
- 数据格式：
  - **第 10 列**（`price`）：价格信息
  - **第 11 列**（`wzl_total`）：王氏评分总分
  - **第 12 列**（`wzl_1sd`）：王氏评分 1σ 标准差
  - **第 14 列**（`wbx_total`）：汪氏评分总分
  - **第 15 列**（`wbx_1sd`）：汪氏评分 1σ 标准差
  - **第 17 列**（`total`）：总评分
  - **第 18 列**（`total_1sd`）：总评分 1σ 标准差

------

#### **3. 输出结果**

##### **（1）数据可视化**

**QQ 图与分布拟合（图 4.1）**

- **QQ 图**
  - **a. 汪氏评分 QQ 图**（Baoxin Wang’s scores）
  - **b. 王氏评分 QQ 图**（Zilong Wang’s scores）
  - **用于检查数据是否符合正态分布或 t 位置尺度分布**
- **直方图与分布拟合**
  - **c. 汪氏评分的正态分布拟合直方图**
  - **d. 王氏评分的 t 位置尺度分布拟合直方图**

**文件输出**：

- `4.1.png`（对应推送中的图4.1）
- 可选：向量格式 `4.1.pdf`（如需启用 `exportgraphics`）

------

**散点图 + 误差条 + 直方图（图 4.2）**

- **主散点图**
  - 横轴：王氏评分
  - 纵轴：汪氏评分
  - 误差条：1σ 标准差（横向和纵向）
  - **黑色虚线**表示 1:1 参考线（如果两者评分完全一致，则数据点应落在该线附近）
  - **不同颜色标记不同产区**（埃塞俄比亚、巴拿马、哥伦比亚、肯尼亚 & 卢旺达、中美洲、南美洲、亚洲）
- **直方图**
  - **上方直方图**：王氏评分分布
  - **右侧直方图**：汪氏评分分布

**文件输出**：

- `4.2.png`（对应推送中的图4.2）
- 可选：向量格式 `4.2.pdf`（如需启用 `exportgraphics`）

------

##### **（2）统计检验**

- **Mann-Whitney U 检验**
  - 非参数检验，用于判断王氏评分与汪氏评分是否存在显著统计学差异。
  - **p < 0.05**：两者评分分布显著不同。
  - **p ≥ 0.05**：无显著差异，表明两者评分体系具有较高的一致性。
- **双样本 t 检验**
  - 用于比较王氏评分和汪氏评分的均值是否存在显著差异。
  - **p < 0.05**：两者均值存在显著统计学差异。
  - **p ≥ 0.05**：无显著差异，说明两者评分均值接近。

**统计检验范围**：

- **总体评分**
- **七大产区评分对比**

------

#### **4. 注意事项**

1. 确保 `判定方法.xlsx` 存在于 MATLAB 当前工作目录下。
2. 确保数据表 `总结` 包含所有必需列。
3. MATLAB 命令窗口输出 **统计检验结果**。
4. `4.1.png` 和 `4.2.png` 图像将保存到当前工作目录中。

------



### **Cost_Performance_Model.m 使用说明**

#### **1. 文件简介**

`Cost_Performance_Model.m` 是一个 MATLAB 脚本，旨在**计算咖啡的性价比（Cost-Performance Ratio, CP）**，并对不同**产区**及**烘焙商**的咖啡进行**系统性排名**。脚本基于**对数归一化**、**TOPSIS 方法** 和 **网格搜索优化权重**，综合考虑**价格、杯测分数（品质）、评分不确定性** 三个维度，从而建立更科学的精品咖啡性价比评估体系。

------

#### **2. 输入数据**

- **数据文件**：`判定方法.xlsx`
- **数据表**：`总结`
- **数据格式**：
  - **国家（nation）**：咖啡产区
  - **生产商（shop）**：烘焙商名称
  - **名称（item）**：咖啡品名
  - **百克价格（price）**：咖啡价格（成本型指标，越低越好）
  - **总分（perf）**：杯测评分（效益型指标，越高越好）
  - **标准差_2（uncer）**：评分标准差（不确定性，成本型指标，越低越好）

------

#### **3. 输出结果**

##### **（1）性价比计算**

- **使用 TOPSIS 方法计算性价比**（CC 值，越高越好）。
- **进行网格搜索**，优化**价格、性能、性能不确定度**的权重组合，使得性价比对各指标的相关性更均衡。
- 输出最优权重：
  - **价格（Price）**
  - **杯测分数（Performance）**
  - **评分不确定度（Uncertainty）**
- **最终性价比排名**，导出为 `性价比.xlsx`。

------

##### **（2）数据可视化**

- **图 4.4**：性价比三大指标（价格、杯测分数、不确定度）的相关性矩阵散点图 + 分布直方图。
- 输出图像：
  - `4.4.png`（对应推送中的图4.4）
  - 可选 `4.4.pdf`（如需启用 `exportgraphics`）

------

##### **（3）按产区分类**

- 计算各产区综合评分和性价比：
  - **杯测分数合并加权平均**
  - **95% 置信区间**
  - **MSWD**（Mean Square Weighted Deviation，加权均方差）
  - **性价比均值及标准差**
- 支持的产区：
  - **埃塞俄比亚（Ethiopia）**
  - **巴拿马（Panama）**
  - **哥伦比亚（Columbia）**
  - **肯尼亚 & 卢旺达（Kenya & Rwanda）**
  - **中美洲（Central America，包括危地马拉、洪都拉斯、萨尔瓦多、尼加拉瓜、墨西哥）**
  - **南美洲（South America，包括玻利维亚、厄瓜多尔、秘鲁、巴西）**
  - **亚洲（Asia，包括中国云南、中国台湾、马来西亚、巴布亚新几内亚）**
- **最终结果**存储于 `T_score` 变量。

------

##### **（4）按烘焙商分类**

- 计算各烘焙商综合评分和性价比：
  - **杯测分数合并加权平均**
  - **95% 置信区间**
  - **MSWD**
  - **性价比均值及标准差**
- 支持的烘焙商：
  - **Apollon's Gold**
  - **CCRA**
  - **CHG**
  - **Coffea Circulor**
  - **GrandCru**
  - **初吾咖啡（Chuwu Coffee）**
  - **啟程拓殖**
  - **喵小雅**
  - **塔拉苏咖啡馆**
  - **尽力而为**
  - **红球咖啡**
  - **达文西咖啡**
- **最终结果**存储于 `T_shop` 变量。

------

#### **4. 注意事项**

1. `判定方法.xlsx` 需放置于 MATLAB **当前工作目录**。
2. 确保 `总结` 表格包含所有必需数据列。
3. MATLAB命令窗口显示最优权重比和优化后咖啡性价比排名。

------



### **联系作者**

如果您在运行这些代码时有任何问题，请联系作者（老王）的邮箱：wzl123492@gmail.com。Good luck!

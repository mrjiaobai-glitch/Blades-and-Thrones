刀锋与王座（v0.4.0，兼容 EU5 1.4.0）
EU5 机制扩展 mod：把"军队"做成第四大政治力量——军饷、军队忠诚、军事危机、夺舍灾变、
军政府、无地军团国、士兵阶层特权、三态军事转化面板、政治影响力（1.4 资源）接入，
围绕"军队-王室-阶层"三角博弈。

================================================================================
【文档地图】按任务取文档；每个文档只在它该被读的时候读
================================================================================
- README.txt（本文）      任何任务的入口：结构、约定、坑速查、调试、索引
- 心得.txt                改代码/设计机制前必读：设计哲学、踩坑 1-57 详情、
                          事件写法规范、测试方法、存档分析法（AI 世界诊断）
- 平衡性数据表_BalanceSheet.txt  涉及数值时：全部数值中英对照，数值唯一事实源
- 开发路线图_Roadmap.txt         规划开发方向时：三阶段计划（修 bug→1.4 适配→无地国线）
  （注：路线图与平衡表为内部文档，不随公开仓库发布——GitHub 仓库中缺失属有意安排；
    数值与规划的本地权威版本始终在工作目录）
- 代码本身 = 最终事实源（文件路径见【目录结构】）；EU5 语法参考 = 官方 wiki
  （eu5.paradoxwikis.com，本 mod 实测验证过的关键点已沉淀进【已知坑速查】）

【改代码流程】三步，逐步完成：
1. 扫坑：读心得.txt 第七章踩坑 1-57，重点 43/50/51/53/55/56/57（四大老坑：
   country_has_estate 恒真 / 军队国碎国 / num_forts 量级 / 易变 potential 自动撤销；
   2026-10 三新坑：is_subject_type 恒真 / 跨版本复制降级 / 单位行动漏类型过滤）
   → 完成：能说出本次改动相关的坑编号
2. 对值：改动涉及的每个数值对照平衡性数据表_BalanceSheet.txt 的当前值
   → 完成：所有改动数值都已核对
3. 修 BOM：复制 D:\小程序\修复BOM.ps1 到 mod 根运行（扫描全部 yml/txt 补回
   UTF-8 BOM——编辑工具会抹掉 BOM）；跑完删除脚本（上传创意工坊时 mod 目录
   不得带 .ps1/.py 工具文件）
   → 完成：脚本输出"补回 BOM 0 个"

================================================================================
【目录结构】in_game/ 与 main_menu/ 与游戏本体同构，同名同路径文件覆盖原版
================================================================================
in_game/common/
- script_values/blades_and_thrones_values.txt   ★数值中枢：军饷/忠诚/危机/价格中枢
- on_action/zzz_blades_and_thrones_monthly_pay.txt ★月度脉冲：发饷/欠饷/危机/团练/无地通行
- scripted_effects/blades_and_thrones_effects.txt  ★夺舍灾变效果（叛军/内战/结算）
- scripted_effects/blades_and_thrones_conversion_effects.txt ★转化系统效果
- estates/zzz_..._soldiers_estate.txt   ★士兵阶层定义（1.4：政治力量已迁 pop_types）
- pop_types/zzz_..._soldiers.txt   ★士兵 POP（REPLACE_OR_CREATE，power_per_pop=0.5）
- estate_privileges/zzz_..._privileges.txt ★士兵阶层 10 个特权
- government_reforms/  ★军政府 + 无地国（流亡者/四海为家/food_access）改革
- disasters/  ★夺舍 + 政变两个灾难
- auto_modifiers/  ★时代联动（era_doctrine）+ 忠诚/士气等常驻修正 +
  coup_settlement.txt（夺权结算三分拆分：正统/忠诚缩放红利 + 结局旗标，2026-10）
- generic_actions/zzz_..._conversion.txt  ★转化行动（收编/组建/遣散/出租/立足地）
- generic_actions/zzz_..._estate_actions.txt  ★请士兵平叛（PI 30）+ extraordinary_taxes
  士兵分支补齐（REPLACE_OR_CREATE，2026-10 以 1.4 为底重建——见踩坑 56）
- prices/zzz_..._prices.txt  ★军事转化政治影响力定价（8 项 20/25/50；遣散/退伍/
  收编佣兵免费——2026-10-06 方案 B）
- generic_action_ai_lists/blades_and_thrones_list.txt ★AI 四角色列表（常规国/无地
  军团/军团宗主/定居地宗主，12 行动全登记；2026-10 拆除 is_subject_type 双保险全锁）
- customizable_localization/  ★动态国名 + 危机化装文案
- casus_belli/  ★驱逐/复国/立足地 CB
- events/  ★11 个事件文件（映射见下）
- gui/  ★转化面板（entry 按钮 + panel 窗口）
main_menu/
- common/static_modifiers/  ★全部自定义修正定义
- common/modifier_type_definitions/  ★修正类型（显示用）
- localization/  ★中英 yml（UTF-8 BOM）
其他：.metadata/metadata.json（版本注册，写精确版本 "1.4.0"）、
平衡性数据表_BalanceSheet.txt、心得.txt、开发路线图_Roadmap.txt、
创意工坊描述.txt（注：更新日志_Changelog.txt 尚未建立，勿引用）

⚠️ loc 双镜像：in_game/localization/ 与 main_menu/localization/ 各一份 yml，
键集必须完全一致；游戏以 main_menu 侧为主——只改一侧会"键存在但读不到"
（显示 raw key）。改任何 loc 键必须两侧同步。

================================================================================
【命名约定】
================================================================================
- 变量前缀 blades_and_thrones_*；夺舍/军团链沿用 mercenary_mutiny_*（历史遗留，勿改）
- 士兵阶层 zzz_rebalanced_nepal_mercenary_soldiers_estate（历史遗留名，勿改）
- *_display 变量 = 供 GUI/事件显示的值（每月脉冲刷新；脚本值频繁调用先存变量）
- 事件选项一律 loc 键（事件ID.a/b/c），不写裸中文
- GUI 读变量：[Player.MakeScope.GetVariable('xxx').GetValue|V0]
- GUI 数值比较：GreaterThan_float(FixedPointToFloat(...GetValue), '(float)0')

================================================================================
【已知坑速查】一行一条；详情 = 心得.txt 踩坑编号
================================================================================
- yml/txt 必须 UTF-8 BOM；编辑工具会抹掉 → 改完跑 BOM 脚本（流程第 3 步）
- ai_chance 用 EU5 语法 factor/modifier；EU4 的 value/if/limit/add 解析级联失败
- effect 迭代器用 every_*；any_* 只在 trigger 用
- generic action 的 effect 顶层作用域不是 country → 国家级效果包 scope:actor
- cancel_subject：宗主作用域执行、附庸作参数（overlord ?= { cancel_subject = prev }）
- 事件 desc 条件段用 first_valid/triggered_desc（不是 if/else_if）
- add_pop 的 size 不能依赖 actor 预置变量（UI 预览不执行 set_variable）
- total_sub_unit_strength 是触发器；国家兵力用 army_size
- 士兵阶层 power 上升 = 政治风险（喂政变/危机），不是纯收益
- AI 侵略修正 < 原版 aggressiveness 1.0（避免失控）
- yml 键必须缩进在语言头（l_simp_chinese:/l_english:）下方；顶格 → 整文件解析失败
- 事件 outcome 只写 neutral（good/bad 无效，报解析错误）
- setup 国家引用事件流改革的 potential 必须显式放行 setup tag（has_or_had_tag = BLT）
- EU5 开局 1337.1.1：birth_date 与 ruler_term start_date 必须 ≤ 1337
- 角色名 key 绝不复用原版（name_jiang3 = "蒋"）；原版 loc 优先，引用原版 key 最稳
- setup 角色文件用 05_ 前缀（先于 countries 加载，ruler 引用才有效）
- starting_technology_level = N → 研究所有 ≤N 的 advance；欧洲主流 3
- 运粮队 = auxiliary 类别（food_storage_per_strength=3000），a_camp_followers 起
- change_variable 前必须 set_variable 初始化（否则每月刷脚本错误）
- 脚本值用 root.名字；变量用 var:名字 / scope:X.var:名字
- 战争月数只在 at_war = no 时由月度脉冲清理（多战争勿在 on_ending_war 清理）
- local_manpower 1 = 1000 人力（0.001 才是 1）；数值类修正先查 modifier 定义
- "蚊子腿"修正（1%/0.001 级）删掉，别让说明变复杂
- 新增阶层必须接入经济界面满意度阈值（REPLACE_OR_CREATE 两文件，士兵阶层先例）
- 建筑岗位陷阱：soldiers 岗位会被晋升填满成"阶层永动机"→ 岗位给农民（团练所先例）
- error.log 噪音（原版固有，可无视）：TARGET_BUILDING/DESTROY_BUILDING_EFFECT/
  flag not in chooser/pdxinput_context；查日志用关键词过滤 script/trigger/effect/
  unknown/localiz
- random_subject 定位特定附庸不可靠 → 用宗主身上的国家引用变量
  （var:xxx ?= { save_scope_as = ... }，random_subject 仅兜底）
- change_variable 只认 add/subtract/multiply/divide/modulo（误用报
  "Invalid operation type in execution"）
- 计数变量初始化与使用同 scope；选项 hidden_effect 内先
  if NOT has_variable → set_variable value = 0 再 change_variable（幂等防御）
- loc 键前缀：<名>_relation/_desc、cb_<名>+_desc、AUTO_MODIFIER_NAME_<名>、
  STATIC_MODIFIER_NAME_<名>+_DESC、wargoal war_name 独立键
- REPLACE_OR_CREATE 覆写原版条目逐字段保留原版内容（只改需要改的字段）；
  **复制必须以当前版本为底，改完与原版逐行 diff，差异行数=意图改动行数**（踩坑 56）
- error.log 归属甄别：先看 "Script location:" 行（mod/1644/原版）再动手
- 【2026-08 三大坑】
  * country_has_estate 对 EU5 所有国家恒为真 → 判"阶层实质存在"用
    "estate_power(estate_type:xxx)" > 0（坑 43）
  * 军队国（type=army）军队全灭 → 引擎硬编码碎国（on_shatter_country）→
    AI 军队国禁用遣散/组建/出租军团（坑 51）
  * num_forts = "有防御的城市数"（大国 30-50 座）→ 金额权重按此量级
    （军饷堡垒权重 0.05，坑 50）
- 【2026-10 三新坑】
  * is_subject_type = <mod 自定义类型> 对独立国疑似恒真 → 守卫严禁
    NOT{is_subject_type=mod类型}（恒假翻转锁死整条 AI 列表两个月，坑 55）；
    只在 any_subject 等真附庸作用域内使用；碎国守卫用 country_type = army 单臂
  * 选单位行动（looking_for_a = unit）的 visible 必须写 is_army/is_navy——
    实测 27 艘船被"遣散"成士兵 POP，全程零报错（坑 57）
  * 覆写/复制原版块必须从当前版本复制 + 逐行 diff：1.3.11 的
    REPLACE_OR_CREATE 复制把 1.4 的 price/estate_interaction_action 全丢了
    = 静默降级（坑 56）
- 进度条量程与变量维度一致：*_display 有 0-1（|V0% 显示）也有 0-100 两种——
  配 max 前先查；忠诚条需 Multiply_float(×100)，危机条直连
- 行动按钮 tooltip 标准写法：datacontext=[GetGenericAction('x')] +
  tooltipwidget={using=generic_action_tooltip}；手写 ContextualTooltipType 会
  绕过引擎"不可用原因"块；tooltip 标题用 #T xxx #!；事件底部信息栏不渲染 \n
  （长文要缩短，不是换行）

================================================================================
【事件文件 → 内容映射】
================================================================================
- blades_and_thrones_events.txt          夺舍灾变主链（test.1 调试菜单 / test.7-12 哗变与军团）
- blades_and_thrones_loyalty_events.txt  忠诚/哗变/政变/军政府抉择（loyalty.1-4）
- blades_and_thrones_war_events.txt      战争反馈（war.1/2 + war.99 调试）
- blades_and_thrones_landless_events.txt 无地国（landless.1 安家/2 洗劫/3 复国）
- blades_and_thrones_company_events.txt  军团性质抉择（company.1）
- blades_and_thrones_lease_events.txt    出租报价（lease.1）
- blades_and_thrones_conversion_events.txt 转化菜单（conversion.1）
- blades_and_thrones_intel_events.txt    情报汇总（intel.1/99）
- blades_and_thrones_militia_events.txt  团练调试（militia.99）
- blades_and_thrones_veterans_events.txt 老兵返乡链（veterans.1-3）
- blades_and_thrones_regency_events.txt  士兵摄政（regency.1/2，on_action random_events 触发）
（junta_events.txt 已随 2026-07 军政府重构删除，勿引用）
共 11 个事件文件 / 41 个事件（2026-09 复核）。namespace 与文件名一一对应，
调试事件统一 .99 + orphan = yes——示例：intel.99 / militia.99 / war.99。

================================================================================
【调试入口】（全部经控制台）
================================================================================
- event mercenary_mutiny_test.1   主调试菜单：a 数值 / b 夺舍叛军 / c 推胜利 /
  d 模拟夺舍 / f 建军团国 / g-i 危机 90/100/清零 / j 索饷 / k 切换扮演 / l 转化菜单 / m 强制政变
- event mercenary_mutiny_test.3 <吞并国TAG>  吞并转换测试（AI 端自动执行）
- event blades_and_thrones_loyalty.3  政变处理（→ 5 年后 loyalty.4 军政府抉择）
- event blades_and_thrones_war.99 / intel.99 / militia.99
- event mercenary_mutiny_test.13  彩蛋国 BLT 调试

================================================================================
【灾难因果链】夺舍→哗变→政变→军政府；螺旋而非四套独立掷骰子
================================================================================
- 主线：佣兵依赖→军事危机→夺舍灾变→军人自恃（12月）→忠诚请愿（loyalty.1）
  →哗变（loyalty.8）→军人怨恨（24月）→政变阈值放宽→军事政变→军政府（5年）
  →核心抉择（还政/制度化/铁腕）→复辟余波（12月）→再哗变风险
- 哗变 loyalty.8（月度脉冲触发）：忠诚<0.3 且士兵满意度<0.4、无灾难进行中
  （互斥防堆叠）、12月冷却；三选项：加饷安抚/强硬镇压（军人怨恨：
  政变阈值 0.15→0.25）/放任
- 接续变量（阈值放宽源）：blades_and_thrones_soldiers_emboldened（镇压后 12月）、
  blades_and_thrones_restoration_unrest（还政后 12月；抉择一生一次）
- 政变 can_start OR：忠诚<0.15 或（军人怨恨且忠诚<0.25）或强制标记
- 政变需接纳"职业军队"思潮——1337 开局早期不会发生

【AI 人格】（性格→路径；形态切换不改性格）
- ai_trusted_company 王室军团（忠顺）：宗主感化军团时获得
- ai_warlord 军阀（好战）：流亡者"在此扎根"转正后蜕变
- ai_mercenary_company 佣兵团（逐利）：军团出生默认人格
- 应用：claim_foothold 的 ai_will_do 按性格加权（军阀+80/佣兵+20/王室军团-40）；
  company.1 性质抉择按性格定宗主信任度

【价格中枢】（script_values/blades_and_thrones_values.txt 集中管理）
- 组建军团费率 0.5 + 最低价 200；收编赎买 0.1/千人；夺舍赎买 500/1000
- 原则：金币花费全走脚本值；AI 判断门槛（gold >= X）与机制系数留在原处

================================================================================
【彩蛋国 BLT（自由军团）速查】
================================================================================
- 定位：无地军队国（type=army），首都德化-九江（CHI 领土），共和国+oligarchic_elective，
  统治者蒋（name_jiang3，原版 key），全 100 属性
- setup：main_menu/setup/start/zzz_blades_and_thrones.txt（国家+建筑+军队）
  + 05_zzz_..._characters.txt（统治者角色）+ in_game/setup/countries/zzz_..._txt（国家定义）
- 开局：1000 金/50 威望/全球视野/starting_technology_level=3/两改革
  （无地军团+四海为家，各带 +1 改革槽）/5 步兵+4 运粮队/CHI 领土军团人力池
- 生存："四海为家"月度脉冲自动建通行权+购粮权；on_game_start 建 CHI→BLT food_access
- 完整经验（命名/日期/改革槽/potential 坑）：心得.txt 第六章

================================================================================
【机制索引】数值唯一事实源 = 平衡性数据表_BalanceSheet.txt；代码即事实源
================================================================================
- 军事危机/夺舍灾变：平衡表 三四；script_values 中枢；disasters/..._disaster.txt；
  events 主文件（结算阈值 125%/75% 三分支）
- 不忠附庸（索饷 240/300/420/600、拒两次独立）：平衡表 十二；company_pulse
  （monthly_pay.txt）；索饷链见 events 主文件
- 转化面板（9 按钮：收编/组建/遣散/退伍/出租/立足地/定居/指派统治者/藩地）：
  generic_actions/conversion.txt + conversion_effects.txt + gui/ 两个文件
  （面板带忠诚/危机进度条 + 全行 tooltip + 三组分组头，2026-10 美化）；
  AI = generic_action_ai_lists 四角色列表（2026-10 拆双保险全锁，坑 55；
  选单位行动含 is_army 过滤，坑 57）
- 政治影响力（1.4 资源）：阶层侧 = 10 特权负产出修正；行动侧 = prices/ 8 项
  + 平叛 30（平衡表十三）；夺权结算三分拆分 = auto_modifiers/coup_settlement
  （正统/忠诚缩放终身分红 + 结局旗标）；满意度均衡基础行已改名"[country|e]基础值"
  与原版显示统一
- 吞并转军团国/流亡者：on_action/zzz_annex_to_army_country.txt（AI 15% 概率）
- 无地国玩法（通行/驱逐CB/安家/复国/掠夺/立足地/四海为家/人力）：government_reforms/
  （exiles + food_access）+ landless_passage_pulse + landless_events.txt
- 士兵阶层/军饷/欠饷：平衡表 一二五六；estates + privileges + auto_modifiers；
  军饷公式见 script_values（堡垒权重 0.05）
- 团练自治/团练所：平衡表 十一；militia_pulse + militia_events.txt
- 军制法律/时代联动：平衡表 七；laws/zzz_..._military_doctrine.txt + era_doctrine
- 出租军团：平衡表 十；lease_army（conversion.txt）+ lease_events.txt
- 政变/军政府：平衡表 八；military_coup.txt + loyalty_events.txt + military_junta.txt
- 战争反馈/情报汇总：war_feedback.txt + war_events.txt + intel_events.txt
- 老兵返乡：war_pulse（monthly_pay.txt）+ veterans_events.txt

================================================================================
【闪退排查】
================================================================================
- 不要在游戏运行中从启动器启用/切换模组；先完全关闭游戏和启动器
- 不读旧档，新开档测试
- 仍崩溃且日志出现 "Arena AudioArena size is too small" → Steam 启动选项加
  -nosounds 无音频模式确认是否能进游戏

刀锋与王座模组

佣兵、常备军与国家政治联动。

================================================================================
【AI 代理速查】读这一节即可掌握模组全貌（省 token 用）
================================================================================
【一句话】EU5 1.3.11 的机制扩展 mod：把"军队"做成第四大政治力量——军饷、
军事危机、夺舍灾变、军政府、无地军团国、士兵阶层特权，全部围绕
"军队-王室-阶层"三角博弈。

【目录结构】
- in_game/  游戏内数据根（与游戏本体 in_game/ 同构，同名文件覆盖原版）
  - common/script_values/blades_and_thrones_values.txt   ★核心数值中枢（军饷/忠诚/危机/威胁/时代缩放全部在此）
  - common/on_action/zzz_blades_and_thrones_monthly_pay.txt   ★月度脉冲（发饷/欠饷/危机累计/团练/无地国通行）
  - common/scripted_effects/blades_and_thrones_effects.txt    ★夺舍灾变核心效果（建叛军/开内战/结算）
  - common/scripted_effects/blades_and_thrones_conversion_effects.txt ★转化系统效果（收编/组建/遣散/赎买）
  - common/estate_privileges/zzz_blades_and_thrones_soldiers_estate_privileges.txt ★士兵阶层 10 个特权
  - common/estates/zzz_blades_and_thrones_soldiers_estate.txt  ★士兵阶层定义（power_per_pop=0.5）
  - common/government_reforms/blades_and_thrones_military_junta.txt ★军政府改革（含 AI 好战修正）
  - common/disasters/  ★三个灾难：夺舍(blades_and_thrones_disaster.txt)/政变/军政府
  - common/auto_modifiers/  ★时代联动(era_doctrine)+忠诚/士气等常驻修正
  - common/generic_actions/zzz_blades_and_thrones_conversion.txt ★转化通用行动（含出租军团/夺取立足地）
  - common/customizable_localization/country_name_construction.txt ★流亡者动态国名（整体覆盖原版/1644
    文件 + 流亡者条目插在 fallback 前；配套 archduke/eyalet/charter_company loc 键在两侧 yml 尾部）
  - common/customizable_localization/zzz_blades_and_thrones_flavor.txt ★危机化装分档文案
  - common/casus_belli/ ★驱逐/复国/夺取立足地 CB
  - events/ ★10 个事件文件（见下）
  - gui/ ★转化面板（entry 按钮 + panel 窗口）
- main_menu/  主菜单数据根（localization 主要在 main_menu 侧加载、modifier 定义）
  - common/static_modifiers/  ★所有自定义修正定义
  - common/modifier_type_definitions/  ★修正类型（显示用）
  - localization/  ★中英 yml（需 UTF-8 BOM！）
    ⚠️ loc 是双份维护：in_game/localization/ 与 main_menu/localization/ 各有一份
    镜像 yml（键集必须完全一致）。游戏实际加载以 main_menu 侧为主——只改一侧
    会导致"键存在但游戏读不到"（实测：新增键只加 in_game 侧 → 动态国名失效、
    建筑名显示键名）。改任何 loc 键必须两侧同步改。
- 平衡性数据表_BalanceSheet.txt  ★全部数值中英对照
- 心得.txt  ★开发心得全集（定位/历程/设计哲学/彩蛋国 setup 经验/踩坑/测试/方向）

【彩蛋国 BLT（自由军团）速查】
- setup：main_menu/setup/start/zzz_blades_and_thrones.txt（国家+建筑+军队）
  + 05_zzz_blades_and_thrones_characters.txt（统治者角色，05 前缀保证先加载）
  + in_game/setup/countries/zzz_blades_and_thrones.txt（国家定义）
- 定位：无地军队国家（type=army），首都德化-九江（CHI 领土，外国资本），
  共和国 + oligarchic_elective，统治者蒋（name_jiang3，原版 key），全 100 属性
- 开局：1000 金/50 威望、全球视野（全部 region）、starting_technology_level = 3、
  2 个改革（无地军团 + 四海为家，各带 +1 改革槽）、5 支步兵 + 4 支运粮队
  （a_camp_followers）、CHI 领土军团人力池（外国建筑，就业岗位造士兵 POP）
- 生存机制："四海为家"改革月度脉冲自动建通行权（military access）+ 驻留地
  购粮权（food access）；on_game_start 建 CHI→BLT food_access 长关系
- 调试：event mercenary_mutiny_test.13
- 完整经验（命名/日期/改革槽/potential 坑）：见心得.txt 第六章

【事件文件 → 内容映射】
- blades_and_thrones_events.txt     夺舍灾变主链（test.1 调试菜单/test.7-12 哗变与军团事件）
- blades_and_thrones_loyalty_events.txt 忠诚/政变/军政府路线（loyalty.1-7）
- blades_and_thrones_junta_events.txt  军政府支持/派系（junta.1-2 + junta.99 调试）
- blades_and_thrones_war_events.txt   战争反馈（war.1/2 + war.99 调试）
- blades_and_thrones_landless_events.txt 无地国（landless.1 安家/2 洗劫/3 复国）
- blades_and_thrones_company_events.txt 军团性质抉择（company.1）
- blades_and_thrones_lease_events.txt 出租报价（lease.1）
- blades_and_thrones_conversion_events.txt 转化菜单（conversion.1）
- blades_and_thrones_intel_events.txt 情报汇总（intel.1/99）
- blades_and_thrones_militia_events.txt 团练调试（militia.99）

【关键命名约定】
- 变量前缀：blades_and_thrones_*（mod 通用）、mercenary_mutiny_*（夺舍/军团链，沿用旧命名）
- 士兵阶层：zzz_rebalanced_nepal_mercenary_soldiers_estate（历史遗留名，勿改）
- display 变量：*_display = 供 GUI/事件显示的值（每月脉冲刷新）
- 事件选项：一律 loc 键（事件ID.a/b/c），不写裸中文
- 游戏内 GUI 读变量：[Player.MakeScope.GetVariable('xxx').GetValue|V0]
- GUI 数值比较：GreaterThan_float(FixedPointToFloat(...GetValue), '(float)0')

【已知坑（改代码前必读）】
- yml 必须 UTF-8 BOM（编辑后需恢复）。common 的 txt 原版全部带 BOM，
  无 BOM 会被引擎警告 "should be in utf8-bom encoding (will try to use it anyways)"——
  大多能解析（"try" 成功），但这是侥幸，含中文注释的文件有解析失败风险；
  新建/编辑 txt 后也应恢复 BOM（原版惯例，见 country_name_construction.txt）。
- 【一键修 BOM】编辑工具会抹掉 BOM——每次改完代码后跑：
  powershell -ExecutionPolicy Bypass -File 修复BOM.ps1（mod 根目录，扫描全部
  yml/txt 幂等补回；实测一次补回 66 个缺 BOM 文件，脚本错误显著减少）
- ai_chance 用 EU5 语法 factor/modifier，不是 EU4 的 value/if/limit/add（会导致解析级联失败）
- effect 位置迭代器用 every_*，any_* 只在 trigger 用
- generic action 的 effect 顶层作用域不是 country——国家级效果要包 scope:actor = {...}
- cancel_subject 方向：宗主作用域执行、附庸作参数（overlord ?= { cancel_subject = prev }）
- 事件 desc 条件段用 first_valid/triggered_desc，不是 if/else_if
- add_pop 的 size 不能依赖 actor 预置变量（UI 预览不执行 set_variable）——用每 sub_unit 直接 add_pop
- total_sub_unit_strength 是触发器不是脚本值——国家兵力用 army_size
- 士兵阶层 power 上升=政治风险（喂给政变/危机），不是纯收益
- 军人 AI 修正数值须低于原版"高侵略"规则（aggressiveness 1.0），避免失控
- yml 的键必须缩进在语言头（l_simp_chinese: / l_english:）下方；顶格键会让整个文件解析失败，事件选项全部显示原始键名
- 事件 outcome 只写 neutral（good/bad 在本版本 EAudioEventOutcome 枚举无效，会报解析错误）
- 【已修复 BUG】彩蛋国 BLT 开局只保留"四海为家"改革、丢"无地军团"：
  表面看是"政府改革槽不够"（基础槽只有 1，country_base_values 里的
  government_reform_slots = 1），但真根因是 setup 授予改革会检查 potential——
  mercenary_mutiny_exiles_reform 的 potential 要求 has_variable =
  mercenary_mutiny_exiles_country / mercenary_mutiny_original_exile_marker
  （流亡者事件变量），BLT 是 setup 直接创建的国家没有这些变量 → 改革被静默丢弃。
  修复：potential 的 OR 增加 has_or_had_tag = BLT（仿原版威尼斯
  council_of_forty 的 has_or_had_tag = VEN 先例）；另给四海为家改革
  country_modifier 加 government_reform_slots = 1 双保险（两个改革都自带
  +1 槽，确保共存且为将来第三个改革留余地）。教训：setup 国家引用事件流
  改革的 potential 时，必须显式放行 setup tag（has_or_had_tag）。
- setup 角色/日期三连坑（彩蛋国 BLT 教训，详见心得.txt 第六章）：
  * EU5 开局是 1337.1.1 不是 1444——角色 birth_date 与 ruler_term 的
    start_date 都必须 ≤ 1337（出生 1300 → 开局 37 岁）。
  * 角色名 key 绝不复用原版已占用的：原版 name_jiang = "江"、name_jiang3 = "蒋"
    （同音字用数字序号区分）；原版 loc 优先于 mod loc（后加载不覆盖）——
    直接引用原版 key（如 name_jiang3）最稳，loc 由原版提供。
  * setup 角色文件用 05_ 前缀（先于 countries 加载，ruler 引用才有效）。
- 初始革新：国家 setup 里 starting_technology_level = N → 自动研究所有
  starting_technology_level <= N 的 advance（仅传统时代革新有该字段）；
  原版欧洲主流 = 3，原版无国家用 4。BLT 已设 3。
- 军队辎重：运粮队 = auxiliary 类别（food_storage_per_strength = 3000），
  传统时代单位 a_camp_followers（后续升级 a_supply_carts → a_supply_convoy
  → a_baggage_train → a_wagon_train → a_logistics_corps）；BLT 开局已带 4 支。
- 政府改革槽机制：基础槽 1；槽位 = government_reform_slots modifier 累加
  （改革/法律/革新都能 +1）。原版威尼斯 setup 3 改革（槽 2）正常——
  setup 不受槽硬限制，potential 才是过滤器（见上面 BUG）。
- change_variable 前必须先 set_variable 初始化变量；直接改不存在的变量会每月刷脚本错误
- 脚本值 vs 变量（本 mod 已验证）：脚本值（script_value）用 root.脚本值名，如
  root.army_size / root.mercenary_mutiny_monthly_pay_cost，正常工作（全 mod 15+ 处）；
  变量（set_variable 创建的）用 var:变量名，跨作用域读变量用 scope:X.var:变量名。
  "Badly read script value" 只发生在 root.后面跟的是触发器/不存在的名字时
  （如 root.total_sub_unit_strength——那是触发器不是脚本值）。
- 多场战争时不要在 on_ending_war 里无条件清理战争月数；只在 at_war = no 时由月度脉冲清理，否则结束一场战争会把总战争月数清零
- 单位陷阱：local_manpower 的 1 = 1000 人力，0.001 才是 1 人力；不能按百分比直觉理解
  数值类修正的单位，改数值前先查该 modifier 的定义
- "蚊子腿"修正不如删掉：1%、0.001 这类玩家感知不到的数值会让说明和判断变复杂
- 新增阶层必须接入"经济界面收税自动化满意度阈值"：原版 current_target_satisfaction
  （script_values/economy_satisfaction_target.txt）与 9 个调节 ScriptedGUI
  （scripted_guis/economy_satisfaction_target.txt：taxing_setup + subtract/add/set 八键）
  都硬编码只认 7 个原版阶层（nobles/clergy/burghers/peasants/tribes/cossacks/dhimmi）。
  新增阶层不在列表 → 读取永远走 else 返回 0.5（显示正常但调节无反应 = "无法调整满意度阈值"）。
  修复：REPLACE_OR_CREATE 覆盖这两个条目，给士兵阶层加 else_if 分支
  （文件：script_values/zzz_blades_and_thrones_satisfaction_target.txt 与
  scripted_guis/zzz_blades_and_thrones_satisfaction_target.txt）。
  兼容性要点：用 REPLACE_OR_CREATE + 独立文件名做条目级合并（不整文件覆盖），
  避免影响同文件其他条目（auto_coin_minting_enabled/toggle_auto_coin_minting），
  并让其他新增阶层 mod / 原版更新的冲突面最小化（仅单条目冲突，引擎无法追加 else_if）。
  变量名约定：每个阶层一个 *_target 变量（如 zzz_rebalanced_nepal_mercenary_soldiers_estate_target）。
- 团练所/自定义建筑岗位陷阱：employment_size 岗位会以最高晋升权重（SOLDIERS=40）
  吸引农民晋升填岗，形成"士兵阶层永动机"——只要岗位空着，退伍/返乡削减的士兵 POP
  会被自动补回，抵消 mod 核心循环的"阶层回落"环节。岗位空缺 → 晋升填充由引擎驱动（
  LONG_TIME_TO_FILL_EMPLOYEES_FROM_PROMOTES），无建筑级开关可关。
  规避写法（团练所现用，方向 A）：不给士兵岗位（pop_type = soldiers），改雇农民
  （pop_type = peasants，参照原版 peasants_training_grounds），岗位规模
  estate_manpower_employment = 0.1。EU5 建筑必须有 employment_size 才能生效
  （原版 453 个建筑全部带岗位，无岗位建筑实测不产生效果）——"不给岗位"不可行，
  把岗位给农民既让建筑生效，又不制造士兵 POP。
- error.log 已知噪音（非 mod 问题，可无视）：打开阶层面板期间会持续刷
  "TARGET_BUILDING/TARGET_BUILDING_TYPE returned nullptr" 与
  "Data error in loc string 'DESTROY_BUILDING_EFFECT'/'THIRD_DESTROY_BUILDING_EFFECT'"
  ——这是原版 perform_reduction（削弱）按钮效果预览的固有缺陷（其 destroy_building
  效果 loc 引用 chooser 里不存在的 building 参数），每帧对 11 个按钮渲染预览即刷几条，
  面板关闭即停；不影响任何功能。同样可无视的还有 interaction_target.cpp 的
  "flag not in chooser"（点击阶层 action 时的固有噪音）与 pdxinput_context 的
  "Could not push stack context"（UI 导航噪音）。查日志时用关键词过滤
  （script/trigger/effect/unknown/localiz）只看真正的脚本错误。
- random_subject 的 limit 里用 has_variable 定位特定附庸不可靠（vanilla 44 处
  random_subject 用例无一用此组合；实测索饷/独立事件找不到军团国 → 付钱/拒绝
  全部无效、独立事件弹出却不独立）。定位"已知的特定附庸"用宗主身上保存的
  国家引用变量（set_variable value = 国家 scope），事件 immediate 里
  var:xxx ?= { save_scope_as = ... }，random_subject 仅兜底。
- change_variable 只认 add/subtract/multiply/divide/modulo 操作符，
  value 是 set_variable 的键——误用报 "Invalid operation type in execution"
  且统计永不生效（年度军费账单教训，9 处全挂、金额恒为 0）。
- 计数变量的初始化必须与使用侧同 scope：索饷拒绝计数在宗主侧递增，初始化
  也要放宗主侧（自立效果的 root 块）——放错侧会刷 "Failed to fetch variable
  ... due to not being set"（实测 2070 条）且计数从未成功。tooltip 用
  [Root.GetVariable('xxx').GetValue|V0] 显示计数进度（"已拒绝 X/2 次"）。
- loc 键前缀速查（漏一个就显示 raw key）：自定义外交关系 <名>_relation +
  <名>_relation_desc（模板 food_access_relation）；CB 用 cb_<名> + cb_<名>_desc；
  auto_modifier 用 AUTO_MODIFIER_NAME_<名>；static_modifier 用
  STATIC_MODIFIER_NAME_<名> + _DESC；wargoal 的 war_name 是独立 loc 键
  （EXPEL_LANDLESS_WAR_NAME 等）。不需要 loc（别浪费时间）：modifier 类型名
  （modifier_type_definitions，引擎处理）、rebel demand 名（vanilla 全无）。
- REPLACE_OR_CREATE 覆写原版条目必须逐字段保留原版内容（soldiers pop_type
  教训：has_cap / estate 关联 / literacy_impact 全保留，只改需要改的字段）。
- EU5 文件夹式 mod 不用 .mod 文件：注册靠 mod 目录内 .metadata/metadata.json
  （name/id/version/tags/supported_game_version，建议 "1.*" 防版本警告）+
  playsets.json 的 path 引用（EU4 的 descriptor.mod 认知已过时）。
- error.log 归属甄别：TARGET_COUNTRY.GetName（约 288 条）是 1644 的事件
  bug（约 70 个文件错误上下文引用），GREAT_POWER_HIGHEST_RANK_COUNTRY_INFO /
  NOT_GIVING_SCRIPTED_RELATION_TRIGGER 是原版层——先看 "Script location:"
  行归属（mod/1644/原版）再动手。

【官方 Wiki 要点】（来源：eu5.paradoxwikis.com，Mod files load order / On actions /
Event modding / Action modding / Localization / Script value 页面，1.3.11 时代已实测验证）
- 文件覆盖体系：INJECT:/REPLACE: 及其 _OR_CREATE 变体只能用于文件"顶层块"。
  多文件同目标时的处理顺序：INJECT_OR_CREATE → REPLACE_OR_CREATE → TRY_INJECT →
  TRY_REPLACE → INJECT → REPLACE；同操作类型才按文件名加载顺序决胜。
  关键限制（wiki 原文）："INJECT: Appends the injected script at the end of an
  existing entry"——INJECT 内容**追加到目标条目末尾**。对顺序敏感的块（如
  country_name_construction 国名模板：按 text 顺序第一个 trigger 通过的生效），
  INJECT 追加的条目排在原文件所有条目之后；若原文件末尾有 fallback 条目，
  追加内容**永远轮不到**（实测动态国名失效）。国名模板扩展必须整体覆盖文件、
  把新条目插在 fallback 之前（1644 同款做法，见 mod 的 country_name_construction.txt）。
- On actions（common/on_action）：允许向同名块"追加" on_actions / events /
  random_events（官方示例即 mod 一直在用的 monthly_country_pulse 追加 on_actions），
  但禁止替换原版块的 trigger/effect（会报错并覆盖原版效果）。
  random_events 用 chance_to_happen 控制评估概率（原版摄政脉冲 = 20）、
  chance_of_no_event 可做条件脚本值、sample_count 调性能与触发率。
- 事件（Event modding）：
  * 事件 ID 必须 namespace.integer（0 < integer < 10000），否则事件互相覆盖。
  * 事件不能用 REPLACE:/INJECT: 修改！改原版事件的唯一途径：新事件文件用
    0000_ 前缀（ascii 早于原版文件）+ 声明原版 namespace + 复制并修改目标事件；
    会产生无害的 "Duplicated event ID" 报错。事件内用到的文件内 scripted effect
    也要一并复制（改名或展开）。
  * fire_only_once = yes：触发后自动设 <事件名>_fire_only_once 变量防重复
    （比手写变量干净）。
  * orphan = yes：仅控制台可触发的事件专用，避免"无来源"报错。
  * hidden = yes：选项按 AI 权重立即执行（无弹窗）。
  * interface_lock = no：关闭事件强制暂停。
  * weight_multiplier（MTTH 语法 base/factor/add）可调 random_events 列表权重。
  * dynamic_historical_event（tag + from/to 日期 + monthly_chance）做历史事件，
    必须配 fire_only_once。
  * category = situation_event / io_event / disaster_event 决定图标与图形。
  * title/desc 可用 first_valid + triggered_desc 做条件文本（本 mod 已用）。
- Generic actions（Action modding）：
  * loc 必需 <key> 与 <key>_desc。
  * 消息系统必需：在 gui 文件定义 PERFORM_<key>_ACTION 消息类型（log/onmap/
    popup/idle/option/pausepopup/message_category，见原版 main_menu/gui/
    messagetypes.txt），loc 补 PERFORM_<key>_ACTION_SETUP/TITLE/DESC/LOG/
    BTN1/BTN2/BTN3/MAP（HEADER=$MESSENGER$、EFFECTS=$EFFECT$ 可引用通用）。
    缺消息类型 = 动作执行无通知反馈（功能不受影响）。
  * cooldown 的 type 是共享字符串（同名即共享冷却），时长用脚本值 years/months/days。
  * select_trigger 支持 visible / show_if / show_why_not_visible /
    show_why_not_enabled / none_available_msg_key。
  * ai_tick_frequency 可写条件脚本值（按状态切换 AI 评估频率）。
  * generic_action_ai_lists 是 AI 优化专用（potential 先于 actions 评估）。
  * GUI 集成：action_button 组件 + left_click_and_hold_action/parameter，
    或全局函数 PerformGenericAction()。
- 本地化（Localization）：
  * yml 必须 UTF-8 BOM，否则整个文件被游戏忽略；文件名须 _l_<语言> 结尾。
  * 加载顺序为反字母序（Z→A）；文件名以 a/0 开头 = 最后应用。
  * 覆盖原版 key 的推荐做法：/<语言>/replace/ 子文件夹里的 yml（replace 的 key
    优先于一切同 key）。
  * $key$ 复用、#R/#G/#E/#V/#F 等颜色（#! 结束）、#bold/#italic、
    @图标!（@gold! @legitimacy! @trigger_no! @time! 等）文本图标。
  * [数据函数] 用 | 管道格式化（如 |V0、|=、|+、|-）。
- 脚本值（Script value）：
  * 每次使用都重新计算——GUI/本地化里频繁调用的值先存变量再显示（本 mod 的
    *_display 变量即此原则）。
  * 最多 5 位小数；值不能依赖自身（禁止循环）。
  * 运算符线性求值（从左到右、从上到下，无 PEMDAS）：value/add/subtract/
    multiply/divide/modulo/max/min/round/ceiling/floor/round_to/fixed_range/
    integer_range/pow/abs。
  * 迭代器：every_/ordered_ 可用，random_ 禁止；除法等汇总运算要放在迭代器
    块外（块内会对每个元素执行）。
  * save_temporary_value_as 是脚本值专用的临时值保存（效果/触发里用
    save_temporary_scope_value_as）。
  * 运算符可用 desc = loc_key 在进度条/外交接受度里显示数值说明。
  * @ value：文件内常量（@x = 数字/公式/字符串），公式 @[...] 遵循 PEMDAS，
    与脚本值（线性）不同。
- 阶层（Estate modding / Estates 页面）：
  * 定义结构：color / power_per_pop / tax_per_pop / rival / alliance /
    revolt_court_language（court_language / common_language /
    liturgical_language）/ characters_have_dynasty（always/sometimes/never）/
    can_spawn_random_characters / can_generate_mercenary_leaders /
    use_diminutive / bank（能否贷款）/ ruler（仅 crown）/ priority_for_dynasty_head
    （王朝首领优先从该阶层选，仅 nobles 用）/ opinion 块。
  * modifier 块：satisfaction 按 (满意度-阈值) 缩放；high_power 在相对权力
    高于 LOW_POWER_THRESHOLD 时生效；low_power 低于时生效；power 块按权力缩放
    （原版仅 crown 使用 ruler = yes，普通阶层不用）。
  * opinion 块必须包含完整意见链（原版 7 阶层全有）：BASE（opinion×0.05）、
    HERETIC -5 / HEATHEN -10（dominant_religion 判定）、SAME_COMMON_LANGUAGE +5、
    RIVAL -20、SAME_ESTATE_CULTURE +20 / ACCEPTED +10 / TOLERATED +5（else_if 链）、
    SAME_ESTATE_RELIGION +20。loc key 全部用原版 ESTATE_OPINION_*（政府页自带）。
    本 mod 士兵阶层最初只有 BASE——已按 cossacks（同为无产军事社群）模式补全。
  * 机制阈值（引擎通用，新增阶层自动继承）：权力 < 25% = 缩放加成（主要是
    max_tax 提升）；权力 > 25% = 不同加成 + max_tax 降低 + 社会价值移动；
    满意度 > 50% = 国家加成、< 50% = 惩罚；< 25% = 无法征募该阶层征召兵；
    < 1% = 无法收该阶层税；贿赂 = 满意度 +10%（不提高均衡值）；基础满意度
    均衡 = 30%；阶层建造建筑概率 = 满意度 - 50%。
  * 特权授予/撤销公式（引擎硬编码）：授予 = 该阶层 +3×特权均衡满意度、
    其他阶层 -1.5×，消耗 5 政府点数；撤销 = -3× 且额外 -25%，稳定代价 =
    400 × 阶层相对权力（三教再 -10 正义）。——设计特权成本时按此尺度。
  * power 计算链：每地点各 POP 数 × power_per_pop → 叠加 local 修正 →
    再叠加 national 修正（正统/特权/改革）。给阶层加"按 POP 数"或"按权力"
    的修正时记住这条链（local 先于 national）。
  * 原版字段画像（对照基线）：bank = yes 有 nobles/clergy/burghers/peasants/
    dhimmi，tribes/cossacks 无；can_spawn_random_characters 只有 crown 显式 no；
    power_per_pop 最高平民档 = cossacks 0.5；tax_per_pop 平民档 1（农民/迪米）；
    士兵阶层现状（0.5/1、无 bank、never 家族、diminutive、可出佣兵队长）与
    tribes/cossacks 定位一致。
  * 特权字段：estate / country_modifier 必需；potential（时代/条件门槛）、
    can_revoke、allow（前置特权解锁链，如 has_unlocked_estate_privilege_trigger）、
    content_priority（100-900 步进，仅国家专属/特殊特权用，普通特权不写）。
    can_revoke 语义 = 条件满足时【可以】撤销（原版 burghers 王权 >= 0.5 同款）；
    "权力超过 X 后不可撤销"要写 NOT = { ... > X }。曾把 royal_hand 写反
    （士兵权力越高反而越可撤销），已修复。
  * 原版特权数值尺度：权力常见 0.2-0.5、强特权 1.0、极端 2.0-5.0；
    discipline 0.025-0.05；army_maintenance_efficiency 0.15-0.25；
    monthly_rebel_growth 仅 -0.001~-0.0002（常驻修正，勿按事件尺度写大值）；
    monthly_legitimacy -0.05~-0.02；target_satisfaction 主流 medium（+5% 均衡，
    授予即 +15% 满意度），large（+10%）用于强特权，small 用于跨阶层惩罚
    （-2.5%）。特权授予公式（引擎硬编码）：该阶层 +3×均衡、其他阶层 -1.5×，
    消耗 5 政府点数；撤销 -3× 且额外 -25%，稳定代价 = 400 × 相对权力。

【开发历程与设计心得】
- 已整体移入独立文件：心得.txt（定位/历程/设计哲学/平衡与 AI 适配/彩蛋国 setup 经验/
  事件写法规范/踩坑/测试/方向，改代码前先读它）。README 只保留速查级信息。

【调试入口】
- event mercenary_mutiny_test.1   主调试菜单（危机/叛军/夺舍/切换/转化）
- event blades_and_thrones_junta.99  军政府掌控力调试
- event blades_and_thrones_war.99  战争反馈调试
- event blades_and_thrones_intel.99  手动情报汇总
- event blades_and_thrones_militia.99  团练一键流程

【灾难因果链】（夺舍→哗变→政变→军政府，非四套独立掷骰子）
- 链主线：佣兵依赖→军事危机→夺舍灾变→结局后军人自恃（12月）→忠诚请愿
  （loyalty.1）→哗变（loyalty.8）→军人怨恨（24月）→政变阈值放宽→军事政变→
  军政府→还政→复辟余波（12月）→再哗变风险。螺旋而非堆叠。
- 哗变 loyalty.8（新增，月度脉冲触发）：忠诚<0.3 且士兵满意度<0.4，无灾难进行中
  （互斥防堆叠），12月冷却。三选项：加饷安抚（6倍月军饷，稳定/正统小损）/
  强硬镇压（满意度大降+军人怨恨：政变阈值 0.15→0.25）/放任（忠诚稳定继续恶化）。
- 阈值放宽的接续变量（忠诚<0.4 即可哗变）：blades_and_thrones_soldiers_emboldened
  （夺舍镇压后军人自恃功高 12月）、blades_and_thrones_restoration_unrest
  （军政府还政后军人被夺权不甘 12月）。
- 政变 can_start 的 OR 分支：忠诚<0.15 或（军人怨恨且忠诚<0.25）或强制标记。

【事件写法规范】（已按创意工坊「1644」模组改造完毕）
- 全部 47 个事件 ID 行已带 #中文注释；重大事件已加 major = yes + 原版插图；
  一次性事件（test.12 扮演机会）已用 fire_only_once；夺舍爆发/政变/兵变之夜
  三个旗舰事件已加 historical_info 历史背景。详见心得.txt 踩坑 15。

【AI 人格】（性格→路径：性格驱动行为，行为导致形态；形态切换不改性格）
- 3 个专属人格：
  * ai_mercenary_company（佣兵团）：逐利机会主义——军团出生默认人格
    （外派/夺舍自立/吞并转流亡者均为此性格）
  * ai_warlord（军阀）：好战割据——流亡者"在此扎根"转正后蜕变为军阀
  * ai_trusted_company（代管军团）：忠顺纪律——宗主选择"忠诚远征"/"转代管"
    感化军团时获得
- AI 决策按性格加权：claim_foothold（夺取立足地）ai_will_do 中军阀 +80 /
  佣兵 +20 / 代管 -40；company.1 性质抉择按军团性格决定宗主信任度。
- 形态切换（军阀化/削藩）不改性格——性格是自变量，路径是结果。

【价格中枢】（script_values/blades_and_thrones_values.txt 集中管理）
- 组建军团费率 0.5 + 最低价 200（blades_and_thrones_found_company_cost/_min_cost）
- 收编赎买单价 0.1/千人（blades_and_thrones_reinstate_buyout_rate）
- 夺舍镇压赎买 500 / 中期赎买 1000（mutiny_buyout_cost_early/_mid）
- 原则：金币花费全部走脚本值（原版 price 块只支持固定价，本 mod 花费多为
  动态公式故用脚本值中枢）；AI 判断门槛（gold >= X）与机制系数（换算率）
  不属于价格，留在原处。
================================================================================

1. 在启动器中启用本模组。
2. 进入游戏后打开控制台，输入：
   event mercenary_mutiny_test.1
3. 调试菜单选项：
   a. 显示当前佣兵公司和兵力、国家总人口。
   b. 手动生成“雇佣兵夺舍”叛军。
   c. 把叛军进度推到胜利。
   d. 直接模拟夺舍效果。
   g. 军事危机值设为 90（数个月内必定触发）。
   h. 军事危机值设为 100（次月必定触发夺舍）。
   i. 军事危机值清零。

吞并转军团国测试：
   event mercenary_mutiny_test.1
   选择 f 可以只测试“创建佣兵军团国并转移佣兵”——军团国会成为不忠诚的附属国。
   选择 j 可以立即触发“佣兵军团索饷”事件。
   选择 k 可以直接切换到佣兵军团国扮演。
   event mercenary_mutiny_test.3 <吞并国TAG>
   事件会在吞并国 AI 端自动执行，随后向玩家目标弹出选择事件。
   注意：AI 路径随机选人类玩家时会排除触发国自己（NOT this = prev）。
   如果事件流程仍然失败，可用下面的直接切换选项定位问题：
   event mercenary_mutiny_test.3
   在玩家视角选择“转换并直接切换玩家”。（两条路径互斥：AI 触发走
   immediate 自动流程；玩家自己触发只弹本事件，选 b 直接转换切换。）

自动触发逻辑：
- 军事危机值（0-100，月度结算）：佣兵威胁比率（佣兵兵力 ÷ 国家可控军力）越高涨得越快（比率 1→+1.0/月，1.5→+1.5，2→+2.0，3→+3.0，4+→+4）；低军队忠诚（<0.35 额外 +0.5，<0.2 再 +0.5）、低士兵满意度（<0.5 额外 +0.25）、战时（+0.25）都会加剧；军队健康时（比率 <0.75 消退 1.5/月，<1 消退 0.75/月）缓慢恢复。
- 危机值满 100 → “雇佣兵夺舍”灾变必定触发（确定性惩罚，不再依赖低概率抽奖）；原有小概率随机爆发保留。
- 灾变爆发时危机值清零；结算后仍为 10 年冷却。
- 危机值显示在“军事情报汇总”和“军事转化面板”中，玩家可提前看到威胁积累并应对（裁撤佣兵、扩编常备军、提升士兵满意度）。
- 当国家全部雇佣兵兵力超过国家可控军力时，“雇佣兵夺舍”灾变才有机会开始；兵力越悬殊，月度触发概率越高，但整体仍很低。
- 国家可控军力按当前自有陆军计算（军队总兵力扣除雇佣兵），并由士兵阶层力量和满意度修正；满意度越高，压制能力越强。
- 灾变持续期间，如果佣兵兵力仍明显高于国家可控军力，叛军进度会增长；反之会消退。
- 灾变开始时佣兵所在地点所在的整片区域会爆发骚乱（人口转向叛军），生成“雇佣兵夺舍”叛军并记录初始兵力；若无法定位佣兵，则回退到首都；若佣兵位于国外（如被租出给外国客户），骚乱转化同样回退到首都执行。此时先弹出处理事件，内战尚未爆发。
- 叛军进度条随力量对比逐月变化（佣兵仍占优则增长，被压制则消退），进度满 100 时内战才爆发——佣兵脱离国家转为叛军部队，叛军国家成立，玩家可以实际围剿；进度被压制到 0（如裁撤全部佣兵）则以“佣兵团被剿灭”收场，但代价是：没有稳定度奖励、士兵阶层满意度下降、军事危机残留 50（10 年冷却结束后佣兵依赖会更快再次引爆）。
- 灾变开始时和灾变中期会弹出处理事件，玩家可以选择镇压、支付赎金或放任劫掠。
- 结算时按灾变开始时的佣兵初始兵力与国家可控军力快照比较：
  * 超过 125%：佣兵团夺舍原国，原国残部变为“流亡者”（与吞并时生成的流亡军团是同一类存在——夺舍本质上是一种特殊的吞并），佣兵会转成新国家的正规军。
  * 处于 75% 到 125%：佣兵团成为无地军团国。
  * 低于 75% 或叛军被镇压：佣兵团被剿灭。
- 每次结算会弹出结果事件，并为原国或新佣兵国施加 10 年余波修正；结算后灾变有 10 年冷却。

不忠诚附属国（佣兵自立门户）：
- 结算“佣兵团成为无地军团国”时，军团国不再完全独立，而是成为国家的“不忠诚附属国”（名义臣属）：忠诚度约 20（-30 修正），拒绝一切宗主行动（征召、进贡），宗主获得原版“讨伐不忠附属国”战争借口；与外敌交战时他们可能加入独立战争倒戈；永远不会被吞并。
- 每隔数月，佣兵军团国会索要巨额军饷（约两年军饷，下限 300 金币）：
  * 支付：花掉军饷，军事危机 -10，军团国安分五年（忠诚回升）。
  * 拒绝：军事危机 +5，他们记恨在心；累计拒绝两次后，他们撕毁臣属条约宣布完全独立（军事危机 +20）。
- 安抚五年后失效，军团国恢复不忠，索饷事件会再次出现——佣兵只认钱。
- 玩家也可以随时主动解除臣属关系，或任其独立；无法通过吞并收编。
- 玩家可以在多个节点选择“扮演出走的佣兵团”：分裂结局事件中率领军团自立门户（此时仍是名义臣属）、独立事件中跟随出走、或军团国以其他方式独立后弹出的扮演机会（仅一次）。切换后原国家交由 AI 接管。

三态转化系统（军事转化面板）：
- 主要入口：屏幕底部、地图模式选择栏左侧的常驻圆形按钮（军事转化面板，位于顶栏图层，可拖动）——点击打开面板，五个转化按钮直接启动对应的通用行动（带完整的目标选择流程：部队/佣兵/军团/地点）。实现机制参考喜儿修改器：topbar 图层浮动窗口 + GetVariableSystem 显隐 + 按钮 left_action 执行通用行动（GUI 文件 in_game/gui/blades_and_thrones_entry.gui 与 _panel.gui，注册表 in_game/gui/scripted_widgets/）。
- 备用入口：军事情报汇总事件中的“军事转化菜单”选项；调试菜单“打开军事转化菜单”（event mercenary_mutiny_test.1 → 选项 l）。
- 五个转化：
  * 收编佣兵：选择一支已雇佣的佣兵公司，整编为常备军（费用按兵力计算，最多扣到当前金币），军事危机 -20，佣兵威胁一劳永逸地消除。
  * 组建军团：选择一支常备军，组建为无地军团国（你的附属国，名为“佣兵自由团”），随后选择“忠诚远征军团”（高忠诚、正常进贡、不会索饷闹独立）或“放任自立”（不忠附属国：索饷、闹独立、可倒戈、可扮演）。
  * 收编军团：选择一支佣兵军团国，命令其部队归队整编。
  * 遣散军队：选择一支常备军，解散为士兵人口（增强士兵阶层）。
  * 退伍安置：选择一个地点，把当地的士兵人口转业为农民（削弱士兵阶层、安抚农民阶层）。
- 核心循环：征兵打仗 → 战后遣散（士兵阶层崛起）→ 退伍安置（阶层回落）→ 需要时再征兵；佣兵和军团国是“外包/外派”形态，军事危机系统惩罚过度依赖雇佣兵。

AI 适配：
- 夺舍灾变没有玩家门槛，AI 国家同样会因佣兵依赖触发灾变；灾变事件（哗变/蔓延/士兵哗变）的选项均已配置 ai_chance：AI 有钱就花钱消灾、军力占优就镇压、几乎不会放任劫掠或接管。
- AI 会主动使用五个转化：
  * 收编佣兵：佣兵威胁比率≥1.5 或军事危机≥50 且金币充足时（危机管理）。
  * 组建军团：军事危机≥70 且和平时外派部队（危机减压）；军团性质选择事件 AI 默认选忠诚（70%），"亲自统领军团"选项已加玩家门槛防止 AI 误切换。
  * 收编军团：战时召回外派部队（+120），平时慢慢归拢（+30）。
  * 遣散军队：仅和平 + 佣兵威胁低 + 国库紧张（经济驱动，避免 AI 自毁武装）。
  * 退伍安置：仅士兵满意度高 + 和平时（裁军是"好政策"，避免掏空士兵阶层）。
- 指派军团统治者对 AI 无战略价值且涉及双重选择流程，保持玩家专属。
- 军事政变与军人集团统治灾难有玩家门槛，AI 不会触发。

吞并转军团国：
- 玩家被吞并：只要有常备军或雇佣兵残部，必生成无地军团国（原设计）。
- AI 被吞并（2024-08 全面放开 AI）：残军 ≥ 5 单位且 15% 概率生成流亡者——
  防刷屏门槛（AI 互吞频繁，无门槛会满世界流亡者）；有门槛则观察者模式
  也能看到流亡军团游荡。这支流亡军团名为“流亡者”。
- 夺舍灾变（AI 也会触发，160 年观察者实测 5+ 次）：叛军胜利后按兵力阈值
  三分支（夺舍流亡/和解自立/佣兵剿灭）——AI 内战消耗后通常兵力不足走“剿灭”。
- AI 全面放开（2024-08）：AI 宗主也会被不忠军团索饷（选项按财政/危机加权的
  ai_chance 决策，拒绝两次 → 独立自由军团）；AI 和平期有闲置兵力 + 财政时
  会组建外派军团（已有军团附庸则不再组建，防膨胀）；收编佣兵/收编军团
  原有 AI 权重保持。流浪通行/升级/扩军脉冲本就对 AI 生效。
- 夺舍结局同理：旧国残部即“流亡者”，玩家可在结果事件中选择“统率流亡者”继续扮演旧王朝。
- 随部队转移的将领、海军将领会进入该军团国。
- 已雇佣的佣兵会按之前逻辑转换为该军团国的正规兵。
- 吞并前，属于吞并国歧视文化（非主体、未接纳、未容忍文化）的宫廷角色会转入该军团国；吞并完成后，原版仍未转移走的同类角色也会再被兜底转移。
- 被吞并时会弹出事件选择接受败亡，或切换到无地军团国继续游戏。
- 无地军团国会获得“无地军团”政府改革，并可在外国城镇建造“军团人力池”外国建筑；该建筑占用当地士兵人口，每月为军团国提供5人力。
- 无地军团国的人力机制（应对“常备军维护需要人力”）：EU5 中常备军的每月维护费是金钱+商品，但补充（reinforce，每月最多恢复 25% 强度）与招募都消耗人力池——无地国没有领土 POP，月度人力为 0，人力池（附庸修正 max_manpower）只是上限，没有流入等于空池，军队打残后永远无法补充。故人力流入全部走建筑（manpower_to_building_owner，原版兵营机制，先例：神罗皇帝军械库 0.005/月）：人力池 +5/月、军团港 +2/月、合同大厅 +1/月，合计约 8 人力/月（0.001 = 1 人力，见“已知坑”）。设计取舍：不写 add_manpower 月度脉冲、宗主补贴不含人力分成、藩镇无补贴人力——军团国军队是“消耗品”，打光了靠据点涓流慢慢回流，要快速补员只能安家占地走正常国家路径。
- 无地军团国身份（两身份方案）：①“佣兵军团”——主动外派军团与夺舍灾变和解自立的佣兵集团统一同名（外派者可免费“收编军团”归队；和解自立者需“赎买”——按兵力付费（每千人 100 金）一次性买断雇佣合同，或选择索饷安抚/驱逐）；一旦撕毁臣属条约独立，自动改名为“自由军团”（Free Company，不受君主束缚）；②“流亡者”——被吞并或被夺舍的国家残部（可扮演、可复国、可安家）。
- 无地国玩法（流亡者/军团国）：① 流浪通行——所有国家自动向无地国开放边境（不占外交槽，由月度脉冲自动维护），可在国境间自由移动；② 驱逐 CB——驻扎国可对无地国宣战“驱逐无地军团”（destroy_army 战争目标）；③ 安家路线——宗主可赐地（军团国走原版“赐地给附庸”，流亡者走转化菜单“赐予定居地”），获得第一块土地后自动“安家立业”转正（结束流亡身份、转为正常领土国家，获得“老兵治国”修正）；④ 复国目标——流亡者铭记故都，可对占据故都者宣战“光复故都”（take_capital），夺回后“复国者”修正+正统大增；⑤ 掠夺经济——无地国掠夺量 +25%（叠加原版 +33%），驻扎他国时月度小概率触发“纵兵劫掠/约束军纪”抉择；⑥ 夺取立足地（转化菜单）——流亡者可选定一块土地：有主地（异教/异文化）立即自动宣战征服（征服者模式），无主地（如新大陆）直接占领建立据点（殖民模式）；佣兵军团国只能宣战有主地（不能殖民荒地），且征服前自动脱离宗主、背负“背信弃义”恶名（声望-、宗主好感-30）——商团背叛雇佣契约去当领主的代价。
- “四海为家”政府改革（彩蛋国自由军团专属，原“购粮权”）：把无地国流浪通行机制并入改革本身——拥有该改革的国家，每月自动与外交范围内所有非交战国家建立通行关系（mod 自定义隐藏关系 blades_and_thrones_landless_passage，含 military access + food access，5 年续期），同时军队驻留的每个有主地点自动向地主建立购粮关系（food access，10 年续期）。走到哪都有粮、有路。
- 新增“士兵”阶层：只由士兵 POP 支持，提供陆军传统、兵员和部队补充相关效果。
- 陆军、海军、堡垒维护费越高，士兵阶层的满意度目标越高；维护归零时会产生对应惩罚。
- 军饷与维护费是两笔独立支出：维护费用于补给与装备（原版机制），军饷是国库每月按编制发放给士兵阶层的固定现金俸禄（常备军每千人每月 5 金 + 每座堡垒每月 1 金，与维护滑条无关）。下调维护费能省钱，但军饷照付；相关金额在“当前月份军饷”修正中实时显示。
- 欠饷机制：国库不足以支付当月军饷时进入欠饷——欠饷月数累积（上限 24 个月），士兵阶层满意度每月下降，军队忠诚每欠饷一月 -0.2%（补饷后逐月回落）。欠饷压低满意度会间接推高“士兵哗变”事件与政变风险。
- 士兵阶层满意度低时，“雇佣兵夺舍”的触发概率和叛军进度都会提高；满意度高时则会降低。
- 已雇佣佣兵相对国家可控军力越强，士兵阶层的满意度均衡越低。
- 新增士兵阶层特权“团练自治”与专属建筑“团练所”：授予特权后，士兵阶层可在各地营建团练所，作为地方军事据点（本地士兵阶层力量 +5%、人力 +5%、征召规模 +10%），代价是本地士兵食物消费 +10%。团练所维护走原生阶层建筑机制（阶层财政承担；阶层建筑不消费 goods，这是原生约束，勿给阶层建筑配商品维护）。原生阶层 AI 不会建造自定义建筑（硬编码启发式只覆盖原生建筑），故 mod 用月度脉冲模拟阶层自建：玩家授予特权且阶层金币 ≥50 时，每月 20% 概率在随机可建地点营建一座，建造费 50 金由阶层财政承担；AI 国家同样会建（若其授予了该特权），但每月仅 5% 概率且要求士兵阶层满意度 ≥0.5，节奏远慢于玩家。玩家注资可加速，撤销特权即停。设计要点：团练所岗位给农民（pop_type = peasants + estate_manpower_employment = 0.1，参照原版 peasants_training_grounds）——EU5 建筑必须有 employment_size 才生效（无岗位实测无效），但岗位若给士兵会以 SOLDIERS=40 晋升权重吸引农民填岗，形成"士兵阶层永动机"，永久抵消退伍安置/老兵返乡的阶层回落环节；雇农民则建筑生效又不直接制造士兵 POP。"士兵阶层力量"修正来自军事据点的象征与控制力，而非雇佣士兵。撤销特权后不再新建，既有团练所留存。调试一键流程：event blades_and_thrones_militia.99（授权+注资500金+首都强建团练所，或单独授权/强建/撤销）。
- 新增“军制与国家”法律：常备军国家、雇佣兵联盟、混合军制、征召军制。
- 军制政策会直接影响军队忠诚和政变概率：常备军国高忠诚更稳、低忠诚更危险；雇佣兵联盟降低士兵政变风险但提高佣兵夺舍风险。
- AI 会按战争状态、财政、军队规模和阶层力量选择军制政策：战时倾向常备军，财政紧张时倾向雇佣兵或征召军制。
- 军制时代联动（军事革命时间叙事）：黄金时代覆盖传统/文艺复兴/地理大发现（约 200 年）——征召军制与佣兵联盟强化、常备军维护效率下降；宗教改革（16 世纪）为过渡期（双方效果各半，对应印刷术与识字军官团的渐进扩散）；专制主义与革命时代常备军与混合军制达峰、征召与佣兵深度过时。由自动修正按 current_age 缩放（见 in_game/common/auto_modifiers/zzz_blades_and_thrones_era_doctrine.txt）。
- 新增军队忠诚值：显示在“军事情报汇总”与“军事转化面板”中；高忠诚强化王室，低忠诚会触发加饷事件和军事政变。
- 新增军事转化“出租军团”（转化菜单第 7 项）：把常备军挂牌租给外交范围内不敌对我们的国家（租期 24 个月，对方按市场价雇佣，到期自动归还），目标国收到报价通知、租不租由对方判断。作为外交杠杆：① 帮助潜在盟友——租给并肩作战者双方好感加深（“并肩作战的战友”）；② 抑制敌国——租给正在与我方敌人交战的国家会招致敌方阵营反感（“资助我们的敌人”），且厌恶我们的国家买不到兵。AI 出租判断：闲置兵力+缺钱+对方好感≥50 时倾向出租，不租邻国（避免资助扩张目标），偏好并肩作战者与正在打我方敌人的国家，拒绝租给与敌方结盟者。租出部队可被“收编佣兵”诏安回来。
- 军事政变中“接受军人接管”会让国家获得“军政府”政府改革，而不是只施加临时修正。该改革以政变变量门控：正常游玩不出现在改革面板（不能直接选取），只能通过军事政变获得；还政时移除。
- 军事政变与军政府灾难对 AI 国家同样开放：AI 会按自身状态抉择（军队强势/士兵不满时倾向接受军人接管，王室强势时镇压；军政府期间会花钱买稳定、镇压异见、卷入派系斗争，高稳定时还政、低稳定时二次夺权或崩溃）。AI 军政府同样会制度化/还政，不会卡死在军政府状态。
- “军政府统治”灾难会持续监测稳定度，并触发站稳脚跟、内部分裂和还政王室三条路线；高稳定度时可主动和平还政或军政共治，低稳定度时则被迫还政。被迫和平还政没有永久奖励，但不会留下长期灾难冷却，并允许军事政变路线在数年后再次出现。
- 站稳脚跟时选择“制度化军人统治”可获得永久增益并结束灾难；“维持现状”则继续后续路线。
- 灾难期间会周期性弹出支持事件，玩家可以花费金钱、稳定度或合法性换取军政府掌控力。
- 稳定度处于 46-74 时会周期性出现“军内派系斗争”，玩家可支持强硬派、温和派或押注一方。
- 调试军政府掌控力：event blades_and_thrones_junta.99
- 战争反馈：进攻与防守分开结算。防守胜利获得更高正统性与军政府掌控力奖励；进攻胜利声望更高，但军政府掌控力奖励较低。防守战败对军政府掌控力惩罚更重；进攻战败留下的“战败耻辱”对军队忠诚影响更大。战争持续超过24个月后，军政府掌控力每月下降；长期战争中进攻方从18个月开始、防守方从36个月开始承受士兵满意度下降。
- 调试战争反馈：event blades_and_thrones_war.99
- 军事情报汇总：每6个月为人类玩家弹出一份报告，显示本月军饷、军队忠诚、士兵满意度、佣兵威胁、军政府掌控力、战争持续月数与军事危机；军事转化面板顶部同样显示这份报告。
- 手动查看军事情报：event blades_and_thrones_intel.99
- 事件文案叙事化：哗变（兵变之夜）、忠诚（四档区间文案）、军政府（宫墙军团旗/军官分裂/墙倒人推/体面还政）、战争（凯旋/败军）、无地国（安营扎寨/粮尽之日/还都）、军团（命运抉择）、出租（出售武力）均为欧式编年史口吻；军事危机在转化面板与情报汇总中按四档显示叙述行（customizable_localization 分块）。
- 事件选项小甜头：政变/军政府/无地国等关键选项附赠少量正统性、稳定度、威望（如 +2.5 正统、+5 稳定、+5 威望）。
- 老兵返乡（战后裁军抉择）：和平 + 有士兵POP 时触发（12 月冷却），触发条件为
  "战争刚结束 OR 士兵规模过剩（士兵POP>1000 且常备军<士兵POP一半）"。三选项：
  ① 发放遣散费（花费 = 士兵规模×0.05，下限 20 金）→ 削减 30% 士兵POP，满意度+稳定+；
  ② 欠饷遣散 → 削减 30% 士兵POP，得"老兵不满"修正 3 年（人力-5%、士兵叛乱+、忠诚受压）；
  ③ 保留精锐 → 士兵POP不动，得"精锐老兵"修正 10 年（陆军传统+0.05/月、纪律+2.5%、
  士气+5%），维护费+5%。①② 均附带"退伍过渡期"修正 2 年（士兵期望 -10%——余下超编
  士兵数月内陆续失业归田，模拟自然回流）。
- 老兵后续链：
  · 老兵骚动（veterans.2）：欠饷遣散 + 士兵满意度<40% → 补发遣散费（200金移除不满）/
    派兵镇压（移除不满但得"镇压余波"2年：人力-5%、叛乱+、正统-0.01/月）/
    不予理会（不满延续）。
  · 精锐归宿（veterans.3）：保留精锐 + 和平 → 并入常备军（"精锐制度化"20年：
    陆军传统+0.03/月、纪律+1.5%、维护效率+3%）/ 保留编制（2年后再议）/
    解散精锐（移除修正、省维护、稳定+）。
- 时代阶段化（A 组）：
  · 特权时代缩放：国家佣兵合同早期额外 -5% 雇佣溢价、+5% 佣兵维护；晚期 +5% 溢价
    （auto_modifier 按 era_early/late_scale 缩放）。
  · 危机阈值时代化：早期（传统/文艺复兴/地理大发现）危机每月额外消退 0.3（佣兵依赖
    是常态）；晚期（专制/革命）每月额外积累 0.5（佣兵依赖是时代错位）。
- 选项命名规范：全部事件选项均使用 loc 键（事件ID.a/b/c），不再直接写中文文本。
- 新增特权“王室之手”：提升王室与士兵阶层力量并压制其他阶层；士兵满意度低于 50% 时，王室之手会失控并增加士兵叛乱风险。
- 夺舍灾变期间，若“王室之手”存在且士兵满意度低于 50%，可能触发“士兵哗变”事件。

【开发心得】
- 已整体移入独立文件：心得.txt（含彩蛋国 setup 经验与最新踩坑，改代码前先读它）。

兵力和 POP 的换算系数：
common/script_values/blades_and_thrones_values.txt
当前 mercenary_mutiny_pop_conversion_ratio = 1.0。
如果实测后需要调整，只改这一个数值即可。

平衡性数据表（中英双语，含军饷/忠诚/危机/夺舍/特权/时代联动/军政府/出租/团练全部数值）：
平衡性数据表_BalanceSheet.txt

开发心得（定位/历程/设计哲学/踩坑/测试/方向，适合改代码前通读）：
心得.txt

闪退排查：
- 不要在游戏运行中从启动器启用或切换模组；先完全关闭游戏和启动器，再启用本模组。
- 不要用旧存档继续测试；先开一场新游戏。
- 如果仍然在加载时崩溃，日志里出现 “Arena AudioArena size is too small”，可以在 Steam 的 EU5 启动选项中加 `-nosounds` 再试一次，先用无音频模式确认是否能进入游戏。

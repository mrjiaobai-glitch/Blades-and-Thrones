# Building Types 字段速查（本 mod 用）
# 参考：创意工坊 3659311464「1644」building_types/readme.txt + EU5 Wiki Building modding
#
# ATTRIBUTES
# - build_time: <scripted value> 建造时间（如 medium_soldier_building）
# - employment_size: <float/scripted value> 岗位规模。1 = 1000 人。
#   注意：建筑必须有 employment_size 才会生效（原版 453 建筑全带岗位，
#   无岗位建筑实测不产生任何效果）——"不给岗位"不可行。
# - pop_type: <pop type> 建筑雇佣的 POP 类型。
#   岗位陷阱：pop_type = soldiers 时空缺岗位会以 SOLDIERS=40 晋升权重吸引
#   农民晋升填岗，形成"士兵阶层永动机"，永久抵消退伍安置/老兵返乡的阶层回落
#   环节。规避：要么岗位给农民（pop_type = peasants，团练所方案），要么给
#   极小岗位值（如 0.05 ≈ 50 人，军团港/合同大厅方案）。
# - is_foreign: <yes/no> 是否外国建筑（可建在别国领土）。
#   foreign 建筑的 modifier 归建筑所有者还是所在地：
#   · modifier 里的普通 modifier（如 local_*）→ 所在地（地主）受益
#   · *_to_building_owner / *_from_building / building_owner_* 变体 → 建筑所有者
#   · foreign_country_modifier = { } → 建筑所有者的国家级修正
#   军团国建筑（人力池/合同大厅/军团港）收益必须用后两类，否则白建。
# - is_special: <yes/no> 特殊建筑（无需求/独立显示）
# - stronger_power_projection: <yes/no> 外国建筑需比地主更强的力量投射
# - need_good_relation: <yes/no> 外国建筑需与地主关系良好
# - want_foreign_pop_created: <yes/no> 是否希望在地主领土生成 POP
# - max_levels: <scripted integer> 最大等级
# - category: <building category> 建筑类别（military_category/naval_category/estate_category）
# - forbidden_for_estates: <yes/no> 禁止阶层建造
# - <location rank>: <yes/no> 可建的城镇等级（rural_settlement/town/city/megalopolis）
# - location_potential: <trigger> 能否在该地点建（root = location，"可见"检查）
#   · is_coastal = yes：沿海（比 is_port 宽松，军团港用）
# - country_potential: <trigger> 能否由该国建（root = country，"可见"检查）
#   · 军团国建筑统一 has_reform = government_reform:mercenary_mutiny_exiles_reform
# - allow: <trigger> 建造启用检查（root = location）
# - remove_if: <trigger> 自动拆除条件（root = building）
# - modifier: <modifier> 作用于地点的修正（乘以建筑等级与 goods access）
# - raw_modifier: <modifier> 作用于地点的修正（不缩放）
# - foreign_country_modifier: <modifier> 作用于建筑所有者的国家级修正
# - capital_modifier / capital_country_modifier: 首都专用修正（本 mod 未用）
# - possible_production_methods: <production methods> 维护生产方式槽
# - unique_production_methods: 建筑内直接定义的生产方式（本 mod 未用）
# - construction_demand: <goods demand> 建造需求
# - on_built = { <effects> } / on_destroyed = { <effects> }（本 mod 未用）
# - obsolete: <building type> 使旧建筑过时（本 mod 未用）
# - price / destroy_price: 建造/拆除价格（本 mod 用 construction_demand 体系）
# - custom_tags = { <strings> }（本 mod 未用）
# - AI_ignore_available_worker_flag / important_for_AI：AI 建造意愿控制
#   （心得：原生阶层 AI 不建自定义建筑，需月度脉冲模拟或 important_for_AI）
#
# 本 mod 建筑索引（文件：blades_and_thrones_buildings.txt）
# · mercenary_mutiny_manpower_pool   佣兵人力池（foreign，军团国，+5 人力/月）
# · mercenary_mutiny_contract_hall   佣兵合同大厅（foreign，军团国，+1 金/月 + 1 人力/月 + 贸易容量 0.5）
# · mercenary_mutiny_company_port    军团港（foreign，军团国，沿海，+2 人力/月，港口/水手/贸易）
# · blades_and_thrones_militia_training_ground  团练所（estate，士兵阶层自建，岗位给农民）
#
# 无地军团国人力机制（应对"常备军维护需要人力"）：无地国无领土 POP → 月度人力为 0，
# 人力池（subject_modifier max_manpower）只是上限，必须有流入才能补充损耗/招募。
# 流入全部走建筑 manpower_to_building_owner（vanilla 兵营机制，原版先例
# hre_imperial_armory_foreign = 0.005/月；单位 0.001 = 1 人力/月）：
#   人力池 0.005 + 军团港 0.002 + 合同大厅 0.001 ≈ 8 人力/月（象征性涓流）。
# 设计取舍（用户拍板）：不写 add_manpower 月度脉冲，宗主补贴不含人力分成；
# 藩镇无补贴人力。军团国军队是"消耗品"——打光了要等据点涓流慢慢回流。
# AI 扩军脉冲保持 manpower > 0 门槛（涓流下几乎不触发）：游戏开局 1337 年，
# 中世纪中期的常备军本就该是小规模精锐，涓流式补员与时代规模相称；
# 要快速补员只能安家占地走正常国家路径。
#
# 本 mod 建筑命名规范：mercenary_mutiny_*（军团国链）/ blades_and_thrones_*（通用/阶层）
# loc 键：<建筑名> + <建筑名>_desc；阶层建筑另配 <建筑名>_stats_tt（特权 tooltip 用）

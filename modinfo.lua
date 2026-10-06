local EN = true
if locale == "zh" or locale == "zhr" then
    EN = false
end

name = EN and "Drop object copy" or "掉落物复制";
description = EN and [[Gathering, chopping, mining and digging always yield extra resources. The multiplier is customizable.]] or [[采集、砍树、挖矿、挖掘必定获得额外物资，倍数可自定义。]];
author = "Salt510";
version = "2026.0";

-- 兼容性
api_version = 10
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

-- 客户端/服务器兼容性
client_only_mod = false
all_clients_require_mod = true
server_only_mod = false

-- 服务器标签
server_filter_tags = {
    "utility",
    "tweak",
    "salt510",
    "掉落物复制",
    "Drop object copy",
}

-- 图标
icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- 配置选项
configuration_options = {
    {
        name = "drop_multiplier",
        label = EN and "Drop Multiplier" or "掉落倍数",
        hover = EN and "Total drops multiplier for gathering. 1x means disabled." or "采集时物资的总倍数。选 1x 等于关闭。",
        options = {
            {description = "1x", data = 1},
            {description = "2x", data = 2},
            {description = "3x", data = 3},
            {description = "4x", data = 4},
            {description = "5x", data = 5}
        },
        default = 3,
    }
}
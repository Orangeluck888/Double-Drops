GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

local MULTIPLIER = GetModConfigData("drop_multiplier") or 2

local function SpawnExtra(prefab, x, y, z, count)
    for _ = 1, count do
        local item = SpawnPrefab(prefab)
        if item then
            local ox = math.random() * 4 - 2   -- -2 ~ 2
            local oz = math.random() * 4 - 2   -- -2 ~ 2
            item.Transform:SetPosition(x + ox, y, z + oz)
        end
    end
end

local function HookAction(action, get_prefab, use_scan)
    local old_fn = action.fn
    action.fn = function(act)
        local target = act.target
        local doer = act.doer

        local x, y, z = 0, 0, 0
        if target then
            x, y, z = target.Transform:GetWorldPosition()
        end

        local result = old_fn(act)
        if not result or not doer then return result end

        local extra = MULTIPLIER - 1
        if extra <= 0 then return result end

        if use_scan then
            doer:DoTaskInTime(0.1, function()
                local items = TheSim:FindEntities(x, y, z, 3, nil, { "INLIMBO" })
                for _, ent in ipairs(items) do
                    if ent:IsValid() and ent.prefab and ent.components.inventoryitem
                        and not ent.components.inventoryitem:IsHeld() then
                        local px, py, pz = doer.Transform:GetWorldPosition()
                        SpawnExtra(ent.prefab, px, py, pz, extra)
                    end
                end
            end)
        else
            local prefab = get_prefab(target)
            if prefab then
                SpawnExtra(prefab, x, y, z, extra)
            end
        end

        return result
    end
end

if MULTIPLIER > 1 then
    -- 采集
    HookAction(ACTIONS.HARVEST, function(t)
        if t.components.crop then return t.components.crop.product end
        if t.components.harvestable then return t.components.harvestable.product end
        if t.components.stewer then return t.components.stewer.product end
    end, false)

    -- 采摘
    HookAction(ACTIONS.PICK, function(t)
        if t.components.pickable then return t.components.pickable.product end
    end, false)

    -- 挖掘、砍伐、采矿（扫描掉落物）
    HookAction(ACTIONS.DIG,  nil, true)
    HookAction(ACTIONS.CHOP, nil, true)
    HookAction(ACTIONS.MINE, nil, true)
end
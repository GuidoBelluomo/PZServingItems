local ServingItems = ServingItems;

ServingItems.GetItemTypes = {}

function ServingItems.GetItemTypes.EmptyPlates(scriptItems)
    local scriptManager = getScriptManager();
    for k, _ in pairs(ServingItems.EmptyPlates) do
        scriptItems:add(scriptManager:FindItem(k));
    end
end

function ServingItems.GetItemTypes.PlateableItems(scriptItems)
    local scriptManager = getScriptManager();
    for k, _ in pairs(ServingItems.PlateableItems) do
        scriptItems:add(scriptManager:FindItem(k));
    end
end

function ServingItems.CanDoNPlates(recipe, player, ingredient)
    local needed = recipe:getResult():getCount();
    local inv = player:getInventory():getItems();
    local have = 0;

    for i = 0, inv:size() - 1 do
        local item = inv:get(i)
        -- If the current item yields a match in the empty plates table then we know it's an empty plate
        if ServingItems.EmptyPlates[item:getFullType()] then
            have = have + 1;
            if have >= needed then
                return true;
            end
        end
    end

    return false;
end

function ServingItems.OnEatFromPlate(item, character)
    local baseHunger = item:getBaseHunger();
    local hungerChange = item:getHungChange();
    local modData = item:getModData();
    local foodWeight = modData.foodWeight;
    local emptySourceWeight = modData.emptySourceWeight;

    local currentPercentage = hungerChange / baseHunger; -- Only way to calculate this, it seems.

    item:setWeight(emptySourceWeight + (foodWeight * currentPercentage));
    item:setActualWeight(emptySourceWeight + (foodWeight * currentPercentage));
end

function ServingItems.EmptyPlate(items, result, player)
    for i=0,items:size() - 1 do
        local item = ServingItems:GetItemInstance(items:get(i):getReplaceOnUse());
        player:getInventory():AddItem(item:getFullType());
    end
end

local function SplitIntoNPlates(splitCount, items, result, player)
    local plateableItems = ServingItems:FilterPlateableItems(items);
    local inventory = player:getInventory();
    local emptyPlates = ServingItems:FilterEmptyPlates(inventory:getItems(), splitCount);

    for _, sourceItem in ipairs(plateableItems) do
        local emptySource = sourceItem:getReplaceOnUse();
        for i=1, splitCount do -- It seems like adding the item manually by recreating it is the only way, as multiple result items don't seem to do well with setName and mod data
            local emptyPlate = table.remove(emptyPlates)
            local newPlate = ServingItems:CreateFullPlateFromEmptyPlate(emptyPlate);
            ServingItems:InitPlateFromSource(sourceItem, emptySource, newPlate, emptyPlate, splitCount);
            inventory:Remove(emptyPlate);
            inventory:AddItem(newPlate);
        end

        if (emptySource) then
            local newItem = inventory:AddItem(emptySource);
            newItem:setCondition(sourceItem:getCondition())
        end
    end
end

local maxSplitting = 4;
for splitCount=1,maxSplitting do
    _G["ServingItems.PutIn" .. splitCount .. "Plates"] = function (...)
        SplitIntoNPlates(splitCount, ...)
    end
end
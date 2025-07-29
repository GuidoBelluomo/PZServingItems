-- Initialize a separate table to expose globally, it will only be populated with what's needed globally
local ServingItemsGlobal = {};
_G["ServingItems"] = ServingItemsGlobal;
local ServingItems = {};

-- Replace default empty plate icons
local function SetItemParam(name, param, value)
    local scriptManager = getScriptManager();
    local item = scriptManager:getItem(name);
    item:DoParam(param .. " = " .. value);
end
SetItemParam("Base.PlateBlue","Icon","PlateBlue");
SetItemParam("Base.PlateOrange","Icon","PlateOrange");
SetItemParam("Base.PlateFancy","Icon","PlateFancy");


-- Hashmap-like structure to quickly lookup plateable items
ServingItems.PlateableItems = {
    ["Base.PieWholeRaw"] = true,
    ["Base.Pie"] = true,
    ["Base.CakeRaw"] = true,
    ["Base.GriddlePanFriedVegetables"] = true,
    ["Base.PanFriedVegetables"] = true,
    ["Base.PanFriedVegetables2"] = true,
    ["Base.Sandwich"] = true,
    ["Base.BurgerRecipe"] = true,
    ["farming.Salad"] = true,
    ["Base.FruitSalad"] = true,
    ["Base.WaterSaucepanRice"] = true,
    ["Base.OmeletteRecipe"] = true,
    ["Base.PieWholeRaw"] = true,
    ["Base.PieWholeRawSweet"] = true,
    ["Base.PieWholeRawSweet"] = true,
}

-- Item instance cache, pre-cached with full plate instances. It'll expand as needed.
ServingItems.ItemInstances = {
    ["ServingItems.FullPlate"] = InventoryItemFactory.CreateItem("ServingItems.FullPlate"),
    ["ServingItems.FullPlateBlue"] = InventoryItemFactory.CreateItem("ServingItems.FullPlateBlue"),
    ["ServingItems.FullPlateOrange"] = InventoryItemFactory.CreateItem("ServingItems.FullPlateOrange"),
    ["ServingItems.FullPlateFancy"] = InventoryItemFactory.CreateItem("ServingItems.FullPlateFancy"),
}

-- Store the respective full version of every base plate for easy lookup
ServingItems.FullsplitCounterparts = {
    ["Base.Plate"] = "ServingItems.FullPlate",
    ["Base.PlateBlue"] = "ServingItems.FullPlateBlue",
    ["Base.PlateOrange"] = "ServingItems.FullPlateOrange",
    ["Base.PlateFancy"] = "ServingItems.FullPlateFancy",
}

ServingItemsGlobal.GetItemTypes = {}

function ServingItemsGlobal.GetItemTypes.EmptyPlates(scriptItems)
    -- The FullsplitCounterparts variable name might be confusing, but the keys of that table contain the empty plates
    local scriptManager = getScriptManager();
    for k, _ in pairs(ServingItems.FullsplitCounterparts) do
        scriptItems:add(scriptManager:FindItem(k));
    end
end

function ServingItemsGlobal.GetItemTypes.PlateableItems(scriptItems)
    local scriptManager = getScriptManager();
    for k, _ in pairs(ServingItems.PlateableItems) do
        scriptItems:add(scriptManager:FindItem(k));
    end
end

function ServingItemsGlobal.CanDoNPlates(recipe, player, ingredient)
    local needed = recipe:getResult():getCount();
    local inv = player:getInventory():getItems();
    local have = 0;

    for i = 0, inv:size() - 1 do
        local item = inv:get(i)
        if ServingItems.FullsplitCounterparts[item:getFullType()] then
            have = have + 1;
            if have >= needed then
                return true;
            end
        end
    end

    return false;
end

function ServingItems:GetItemInstance(name)
    if not string.find(name, ".", 1, true) then
        name = "Base." .. name;
    end

    local item = self.ItemInstances[name];
    if item ~= nil then
        return item;
    else
        item = InventoryItemFactory.CreateItem(name);
        self.ItemInstances[name] = item;
        return item;
    end
end

function ServingItems:NameCalcFunction(name, emptyPlate)
    -- We gotta remove the Raw, Rotten, Fresh etc. suffixes, add the container's name, and just let the game re-add them based on item data 
    return ({string.gsub(name, "%s*%b()%s*", "")})[1] .. " (" .. emptyPlate:getName() .. ")";
end

function ServingItems:FilterPlateableItems(items)
    local plateableItems = {};
    for i=0,items:size() - 1 do
        local item = items:get(i);
        local itemType = item:getFullType();
        if ServingItems.PlateableItems[itemType] ~= nil then
            plateableItems[#plateableItems + 1] = item;
        end
    end

    return plateableItems;
end

function ServingItems:FilterEmptyPlates(items, max)
    local emptyPlates = {};
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if ServingItems.FullsplitCounterparts[item:getFullType()] then
            emptyPlates[#emptyPlates + 1] = item
            if #emptyPlates >= max then
                break;
            end
        end
    end

    return emptyPlates;
end

function ServingItems:ApplySourceFoodMetadataToPlate(source, emptySource, plate, emptyPlate, splitCount)
        plate:setBaseHunger(source:getBaseHunger()/ splitCount);
        plate:setHungChange(source:getBaseHunger()/ splitCount);
        plate:setThirstChange(source:getThirstChange()/ splitCount);
        plate:setBoredomChange(source:getBoredomChange()/ splitCount);
        plate:setUnhappyChange(source:getUnhappyChange()/ splitCount);
        plate:setCarbohydrates(source:getCarbohydrates()/ splitCount);
        plate:setLipids(source:getLipids()/ splitCount);
        plate:setProteins(source:getProteins()/ splitCount);
        plate:setCalories(source:getCalories()/ splitCount);
        plate:setReduceFoodSickness(source:getReduceFoodSickness()/ splitCount);
        plate:setFluReduction(source:getFluReduction()/ splitCount);
        plate:setPainReduction(source:getPainReduction()/ splitCount);
        plate:setPoisonPower(source:getPoisonPower()/ splitCount);
        plate:setTaintedWater(source:isTaintedWater());
        plate:setRotten(source:isRotten());
        plate:setBurnt(source:isBurnt());
        plate:setAge(source:getAge());
        plate:setCooked(source:isCooked());
        plate:setIsCookable(source:isIsCookable());
        plate:setCookingTime(source:getCookingTime());
        plate:setMinutesToCook(source:getMinutesToCook()/ splitCount);
        plate:setMinutesToBurn(source:getMinutesToBurn()/ splitCount);
        plate:setOffAge(source:getOffAge());
        plate:setOffAgeMax(source:getOffAgeMax());
        plate:setLastAged(source:getLastAged());
        plate:setFrozen(source:isFrozen());
        plate:setCanBeFrozen(source:canBeFrozen());
        plate:setFreezingTime(source:getFreezingTime());
        plate:setRottenTime(source:getRottenTime());
        plate:setCompostTime(source:getCompostTime());
        plate:setBadInMicrowave(source:isBadInMicrowave());
        plate:setBadCold(source:isBadCold());
        plate:setGoodHot(source:isGoodHot());
        plate:setHeat(source:getHeat());
        plate:setbDangerousUncooked(source:isbDangerousUncooked());
        plate:setLastCookMinute(source:getLastCookMinute());
        plate:setSpice(source:isSpice());
        plate:setPoisonDetectionLevel(source:getPoisonDetectionLevel());
        plate:setPoisonLevelForRecipe(source:getPoisonLevelForRecipe());
        plate:setUseForPoison(source:getUseForPoison());
        plate:setFoodType(source:getFoodType());
        plate:setCustomEatSound(source:getCustomEatSound());
        plate:setChef(source:getChef());
        plate:setHerbalistType(source:getHerbalistType());
        plate:setName(ServingItems:NameCalcFunction(source:getName(), emptyPlate));
        local emptySourceWeight = 0;
        if emptySource then
            emptySourceWeight = ServingItems:GetItemInstance(emptyItem):getWeight();
        end
        
        -- Some food items seemed to weigh less than their base item, math.abs is my "fix". Technically this is incorrect, but I don't like the idea of food weighing 0 or even negative.
        local foodWeight = math.abs((source:getWeight() - emptySourceWeight) / splitCount);

        plate:setWeight(emptySourceWeight + foodWeight);
        plate:setActualWeight(emptySourceWeight + foodWeight);
        local modData = plate:getModData();
        modData.emptySourceWeight = emptySourceWeight;
        modData.foodWeight = foodWeight;


end

function ServingItems:CreateFullPlateFromEmptyPlate(emptyPlate)
    local fullPlateType = ServingItems.FullsplitCounterparts[emptyPlate:getFullType()];
    return InventoryItemFactory.CreateItem(fullPlateType);
end

local maxSplitting = 5;
for splitCount=1,maxSplitting do
    _G["PutIn" .. splitCount .. "ServingItems_OnCreate"] = function (items, result, player)
        local plateableItems = ServingItems:FilterPlateableItems(items);
        local inventory = player:getInventory();
        local emptyPlates = ServingItems:FilterEmptyPlates(inventory:getItems(), splitCount);


        for _, sourceItem in ipairs(plateableItems) do
            local emptySource = sourceItem:getReplaceOnUse();
            for i=1, splitCount do -- It seems like adding the item manually by recreating it is the only way, as multiple result items don't seem to do well with setName and mod data
                local emptyPlate = table.remove(emptyPlates)
                local newPlate = ServingItems:CreateFullPlateFromEmptyPlate(emptyPlate);
                ServingItems:ApplySourceFoodMetadataToPlate(sourceItem, emptySource, newPlate, emptyPlate, splitCount);
                inventory:Remove(emptyPlate);
                inventory:AddItem(newPlate);
            end

            if (emptySource) then
                inventory:AddItem(emptySource);
            end
        end
    end
end

function ServingItems_OnEat(item, character)
    local baseHunger = item:getBaseHunger();
    local hungerChange = item:getHungChange();
    local modData = item:getModData();
    local foodWeight = modData.foodWeight;
    local emptySourceWeight = modData.emptySourceWeight;

    local currentPercentage = hungerChange / baseHunger; -- Only way to calculate this, it seems.

    item:setWeight(emptySourceWeight + (foodWeight * currentPercentage));
    item:setActualWeight(emptySourceWeight + (foodWeight * currentPercentage));
end

function EmptyServingItem_OnCreate(items, result, player)
    for i=0,items:size() - 1 do
        local item = ServingItems:GetItemInstance(items:get(i):getReplaceOnUse());
        player:getInventory():AddItem(item:getFullType());
    end
end
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
ServingItems.FullPlateCounterparts = {
    ["Base.Plate"] = "ServingItems.FullPlate",
    ["Base.PlateBlue"] = "ServingItems.FullPlateBlue",
    ["Base.PlateOrange"] = "ServingItems.FullPlateOrange",
    ["Base.PlateFancy"] = "ServingItems.FullPlateFancy",
}

ServingItemsGlobal.GetItemTypes = {}

function ServingItemsGlobal.GetItemTypes.EmptyPlates(scriptItems)
    -- The FullPlateCounterparts variable name might be confusing, but the keys of that table contain the empty plates
    local scriptManager = getScriptManager();
    for k, _ in pairs(ServingItems.FullPlateCounterparts) do
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
        if ServingItems.FullPlateCounterparts[item:getFullType()] then
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
        if ServingItems.FullPlateCounterparts[item:getFullType()] then
            emptyPlates[#emptyPlates + 1] = item
            if #emptyPlates >= max then
                break;
            end
        end
    end

    return emptyPlates;
end

function ServingItems:ApplySourceValuesToPlate(source, plate, splitCount)
        result:setBaseHunger(item:getBaseHunger()/ splitCount);
        result:setHungChange(item:getBaseHunger()/ splitCount);
        result:setThirstChange(item:getThirstChange()/ splitCount);
        result:setBoredomChange(item:getBoredomChange()/ splitCount);
        result:setUnhappyChange(item:getUnhappyChange()/ splitCount);
        result:setCarbohydrates(item:getCarbohydrates()/ splitCount);
        result:setLipids(item:getLipids()/ splitCount);
        result:setProteins(item:getProteins()/ splitCount);
        result:setCalories(item:getCalories()/ splitCount);
        result:setReduceFoodSickness(item:getReduceFoodSickness()/ splitCount);
        result:setFluReduction(item:getFluReduction()/ splitCount);
        result:setPainReduction(item:getPainReduction()/ splitCount);
        result:setPoisonPower(item:getPoisonPower()/ splitCount);
        result:setTaintedWater(item:isTaintedWater());
        result:setRotten(item:isRotten());
        result:setBurnt(item:isBurnt());
        result:setAge(item:getAge());
        result:setCooked(item:isCooked());
        result:setIsCookable(item:isIsCookable());
        result:setCookingTime(item:getCookingTime());
        result:setMinutesToCook(item:getMinutesToCook()/ splitCount);
        result:setMinutesToBurn(item:getMinutesToBurn()/ splitCount);
        result:setOffAge(item:getOffAge());
        result:setOffAgeMax(item:getOffAgeMax());
        result:setLastAged(item:getLastAged());
        result:setFrozen(item:isFrozen());
        result:setCanBeFrozen(item:canBeFrozen());
        result:setFreezingTime(item:getFreezingTime());
        result:setRottenTime(item:getRottenTime());
        result:setCompostTime(item:getCompostTime());
        result:setBadInMicrowave(item:isBadInMicrowave());
        result:setBadCold(item:isBadCold());
        result:setGoodHot(item:isGoodHot());
        result:setHeat(item:getHeat());
        result:setbDangerousUncooked(item:isbDangerousUncooked());
        result:setLastCookMinute(item:getLastCookMinute());
        result:setSpice(item:isSpice());
        result:setPoisonDetectionLevel(item:getPoisonDetectionLevel());
        result:setPoisonLevelForRecipe(item:getPoisonLevelForRecipe());
        result:setUseForPoison(item:getUseForPoison());
        result:setFoodType(item:getFoodType());
        result:setCustomEatSound(item:getCustomEatSound());
        result:setChef(item:getChef());
        result:setHerbalistType(item:getHerbalistType());

        local emptyItemWeight = 0;
        local emptyItemWeight = plate:getWeight();
        local ingredientWeight = source:getWeight();
        if emptyItem then
            emptyItemWeight = ServingItems:GetItemInstance(emptyItem):getWeight();
        end
        
        -- Some food items seemed to weigh less than their base item, math.abs is my "fix". Technically this is incorrect, but I don't like the idea of food weighing 0 or even negative.
        local foodWeight = math.abs((ingredientWeight - emptyItemWeight) / splitCount);

        plate:setWeight(emptyItemWeight + foodWeight);
        plate:setActualWeight(emptyItemWeight + foodWeight);
        local modData = plate:getModData();
        modData.emptyItemWeight = emptyItemWeight;
        modData.foodWeight = foodWeight;
end

function ServingItems:CreateFullPlateFromEmptyPlate(emptyPlate)
    local fullPlateType = ServingItems.FullPlateCounterparts[emptyPlate:getFullType()];
    newPlate = InventoryItemFactory.CreateItem(fullPlateType);
end

local maxSplitting = 5;
for i=1,maxSplitting do
    _G["PutIn"..i.."ServingItems_OnCreate"] = function (items, result, player)
        local plateableItems = ServingItems:FilterPlateableItems(items);
        local inventory = player:getInventory();
        local emptyPlates = ServingItems:FilterEmptyPlates(inventory:getItems());


        for _, sourceItem in ipairs(plateableItems) do
            local emptyItem = sourceItem:getReplaceOnUse();
            for k=1, i do -- It seems like adding the item manually by recreating it is the only way, as multiple result items don't do well with setName and mod data
                local emptyPlate = table.remove(plates)
                local newPlate = ServingItems:CreateFullPlateFromEmptyPlate(emptyPlate);
                ServingItems:ApplySourceValuesToPlate(sourceItem, newPlate, i);
                newPlate:setName(ServingItems:NameCalcFunction(sourceItem:getName(), emptyPlate));
                inventory:Remove(emptyPlate);
                inventory:AddItem(newPlate);
            end

            if (emptyItem) then
                inventory:AddItem(emptyItem);
            end
        end
    end
end

function ServingItems_OnEat(item, character)
    local baseHunger = item:getBaseHunger();
    local hungerChange = item:getHungChange();
    local modData = item:getModData();
    local foodWeight = modData.foodWeight;
    local emptyItemWeight = modData.emptyItemWeight;

    local currentPercentage = hungerChange / baseHunger; -- Only way to calculate this, it seems.

    item:setWeight(emptyItemWeight + (foodWeight * currentPercentage));
    item:setActualWeight(emptyItemWeight + (foodWeight * currentPercentage));
end

function EmptyServingItem_OnCreate(items, result, player)
    for i=0,items:size() - 1 do
        local item = ServingItems:GetItemInstance(items:get(i):getReplaceOnUse());
        player:getInventory():AddItem(item:getFullType());
    end
end
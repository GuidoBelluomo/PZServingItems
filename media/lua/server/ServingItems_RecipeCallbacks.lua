local ServingItems = {};
-- Hashmap-like structure
ServingItems.PlateableItems = {
    ["Base.PieWholeRaw"] = true,
    ["Base.CakeRaw"] = true,
    ["Base.PanFriedVegetables"] = true,
    ["Base.PanFriedVegetables2"] = true,
    ["Base.Sandwich"] = true,
    ["Base.BurgerRecipe"] = true,
    ["farming.Salad"] = true,
    ["Base.FruitSalad"] = true,
    ["Base.WaterSaucepanRice"] = true,
}

ServingItems.ItemInstances = {
    ["ServingItems.FullPlate"] = InventoryItemFactory.CreateItem("ServingItems.FullPlate"),
    ["ServingItems.FullPlateBlue"] = InventoryItemFactory.CreateItem("ServingItems.FullPlate"),
    ["ServingItems.FullPlateOrange"] = InventoryItemFactory.CreateItem("ServingItems.FullPlate"),
    ["ServingItems.FullPlateFancy"] = InventoryItemFactory.CreateItem("ServingItems.FullPlate"),
}

ServingItems:GetItemInstance(name) {
    if (~string.find(name, ".")) then
        name = "Base." .. name
    end

    local item = self.ItemInstances[name]
    if item ~= nil then
        return item
    else
        item = InventoryItemFactory.CreateItem(name)
        self.ItemInstances[name] = item
        return item
    end
}

ServingItems.RecipeSuffixes = {
    ["ServingItems.FullPlate"] = "in a Plate",
    ["ServingItems.FullPlateBlue"] = "in a Plate",
    ["ServingItems.FullPlateOrange"] = "in a Plate",
    ["ServingItems.FullPlateFancy"] = "in a Plate",
}

ServingItems.EmptyCounterparts = {
    ["ServingItems.FullPlate"] = "Base.Plate",
    ["ServingItems.FullPlateBlue"] = "Base.PlateBlue",
    ["ServingItems.FullPlateOrange"] = "Base.PlateOrange",
    ["ServingItems.FullPlateFancy"] = "Base.PlateFancy",
}

ServingItems.NameCalcFunctions = {
    ["PieWholeRaw"] = function(name, type)
        return ({string.gsub(name, "%s*%b()%s*", "")})[1] .. " (" .. ServingItems.ItemInstances[type]:getName() .. ")";
    end,

    ["Pie"] = function(name, type)
        return ({string.gsub(name, "%s*%b()%s*", "")})[1] .. " (" .. ServingItems.ItemInstances[type]:getName() .. ")";
    end,

    ["CakeRaw"] = function(name, type)
        return ({string.gsub(name, "%s*%b()%s*", "")})[1] .. " (" .. ServingItems.ItemInstances[type]:getName() .. ")";
    end,

    ["PanFriedVegetables"] = function(name, type)
        return ({string.gsub(name, "%s*%b()%s*", "")})[1] .. " (" .. ServingItems.ItemInstances[type]:getName() .. ")";
    end,

    ["PanFriedVegetables2"] = function(name, type)
        return ({string.gsub(name, "%s*%b()%s*", "")})[1] .. " (" .. ServingItems.ItemInstances[type]:getName() .. ")";
    end,

    ["Sandwich"] = function(name, type)
        return ({string.gsub(name, "%s*%b()%s*", "")})[1] .. " (" .. ServingItems.ItemInstances[type]:getName() .. ")";
    end,

    ["BurgerRecipe"] = function(name, type)
        return ({string.gsub(name, "%s*%b()%s*", "")})[1] .. " (" .. ServingItems.ItemInstances[type]:getName() .. ")";
    end,

    ["Salad"] = function(name, type)
        return ({string.gsub(name, "%s*%b()%s*", "")})[1] .. " (" .. ServingItems.ItemInstances[type]:getName() .. ")";
    end,

    ["FruitSalad"] = function(name, type)
        return ({string.gsub(name, "%s*%b()%s*", "")})[1]  .. " (" .. ServingItems.ItemInstances[type]:getName() .. ")";
    end,
}

local maxSplitting = 5;
for i=1,maxSplitting do
    _G["PutIn"..i.."ServingItems_OnCreate"] = function (items, result, player)
        local resultType = result:getFullType();
        for j=0,items:size() - 1 do
            local item = items:get(j);
            local itemType = item:getType();
            local canSplit = ServingItems.PlateableItems[itemType] ~= nil;
            local baseItem = item::getReplaceOnUse();
            if canSplit then
                for k=1, i do -- It seems like adding the item manually by recreating it is the only way, as multiple result items don't do well with setName and mod data
                    result = InventoryItemFactory.CreateItem(resultType);
                    result:setBaseHunger(item:getBaseHunger() / i);
                    result:setHungChange(item:getBaseHunger() / i);
                    result:setThirstChange(item:getThirstChange() / i);
                    result:setBoredomChange(item:getBoredomChange() / i);
                    result:setUnhappyChange(item:getUnhappyChange() / i);
                    result:setCarbohydrates(item:getCarbohydrates() / i);
                    result:setLipids(item:getLipids() / i);
                    result:setProteins(item:getProteins() / i);
                    result:setCalories(item:getCalories() / i);
                    result:setReduceFoodSickness(item:getReduceFoodSickness() / i);
                    result:setFluReduction(item:getFluReduction() / i);
                    result:setPainReduction(item:getPainReduction() / i);
                    result:setPoisonPower(item:getPoisonPower() / i);
                    result:setTaintedWater(item:isTaintedWater());
                    result:setRotten(item:isRotten());
                    result:setBurnt(item:isBurnt());
                    result:setAge(item:getAge());
                    result:setCooked(item:isCooked());
                    result:setIsCookable(item:isIsCookable());
                    result:setCookingTime(item:getCookingTime());
                    result:setMinutesToCook(item:getMinutesToCook());
                    result:setMinutesToBurn(item:getMinutesToBurn());
                    result:setOffAge(item:getOffAge());
                    result:setOffAgeMax(item:getOffAgeMax());
                    result:setAge(item:getAge());
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
                    result:setName(ServingItems.NameCalcFunctions[itemType](item:getName(), resultType));
    
                    --[[
                    result:setSpices(item:getSpices());
    
                    local extraItems = item:getExtraItems() // Not a KahluaTable
                    for k, v in pairs(extraItems) do
                        result:addExtraItem(v);
                    end
                    ]]--
    
                    local baseItemWeight = 0;
                    local emptyItemWeight = result:getWeight();
                    local ingredientWeight = item:getWeight();
                    if baseItem then
                        baseItemWeight = ServingItems:GetItemInstance(baseItem):getWeight();
                    end
                    
                    local foodWeight = math.abs((ingredientWeight - baseItemWeight) / i); -- Some food items weigh less than their base item, this is my "fix"
    
                    result:setWeight(emptyItemWeight + foodWeight);
                    result:setActualWeight(emptyItemWeight + foodWeight);
                    local modData = result:getModData();
                    modData.emptyItemWeight = emptyItemWeight;
                    modData.foodWeight = foodWeight;

                    player:getInventory():AddItem(result);
                end

                if (baseItem) then
                    player:getInventory():AddItem(baseItem);
                end

                break;
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
    local type = items:get(0):getFullType();
    player:getInventory():AddItem(ServingItems.EmptyCounterparts[type]);
end
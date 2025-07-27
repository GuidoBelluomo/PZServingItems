ServingItems = {};
-- Hashmap-like structure
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
}

ServingItems.ItemInstances = {
    ["ServingItems.FullPlate"] = InventoryItemFactory.CreateItem("ServingItems.FullPlate"),
    ["ServingItems.FullPlateBlue"] = InventoryItemFactory.CreateItem("ServingItems.FullPlateBlue"),
    ["ServingItems.FullPlateOrange"] = InventoryItemFactory.CreateItem("ServingItems.FullPlateOrange"),
    ["ServingItems.FullPlateFancy"] = InventoryItemFactory.CreateItem("ServingItems.FullPlateFancy"),
}

ServingItems.FullPlateCounterparts = {
    ["Base.Plate"] = "ServingItems.FullPlate",
    ["Base.PlateBlue"] = "ServingItems.FullPlateBlue",
    ["Base.PlateOrange"] = "ServingItems.FullPlateOrange",
    ["Base.PlateFancy"] = "ServingItems.FullPlateFancy",
}

ServingItems.GetItemTypes = {}
function ServingItems.GetItemTypes.EmptyPlates(scriptItems)
    local scriptManager = getScriptManager()
    for k, _ in pairs(ServingItems.FullPlateCounterparts) do
        scriptItems:add(scriptManager:FindItem(k))
    end
end

function ServingItems.CanDoNPlates(recipe, player, ingredient)
    local needed = recipe:getResult():getCount()
    local inv = player:getInventory():getItems()
    local have = 0

    for i = 0, inv:size()-1 do
        local item = inv:get(i)
        if ServingItems.FullPlateCounterparts[item:getFullType()] then
            have = have + 1
            if have >= needed then
                return true
            end
        end
    end

    return false
end

function ServingItems:GetItemInstance(name)
    if not string.find(name, ".", 1, true) then
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
end

ServingItems.RecipeSuffixes = {
    ["ServingItems.FullPlate"] = "in a Plate",
    ["ServingItems.FullPlateBlue"] = "in a Plate",
    ["ServingItems.FullPlateOrange"] = "in a Plate",
    ["ServingItems.FullPlateFancy"] = "in a Plate",
}

function ServingItems:NameCalcFunction(name, type)
    -- We gotta remove the Raw, Rotten, Fresh etc. suffixes, add the container's name, and just let the game re-add them based on item data 
    return ({string.gsub(name, "%s*%b()%s*", "")})[1] .. " (" .. ServingItems.ItemInstances[type]:getName() .. ")";
end

local maxSplitting = 5;
for i=1,maxSplitting do
    _G["PutIn"..i.."ServingItems_OnCreate"] = function (items, result, player)
        local splittableItems = {}
        local plates = {}

        for j=0,items:size() - 1 do
            local item = items:get(j);
            local itemType = item:getFullType();
            local isSplittable = ServingItems.PlateableItems[itemType] ~= nil;
            if isSplittable then
                splittableItems[#splittableItems + 1] = item
            end
        end
        
        local inventory = player:getInventory()
        local inventoryItems = inventory:getItems()
        for j = 0, inventoryItems:size()-1 do
            local item = inventoryItems:get(j)
            if ServingItems.FullPlateCounterparts[item:getFullType()] then
                plates[#plates + 1] = item
                if #plates >= i then
                    break
                end
            end
        end

        for _, item in ipairs(splittableItems) do
            local baseItem = item:getReplaceOnUse();
            for k=1, i do -- It seems like adding the item manually by recreating it is the only way, as multiple result items don't do well with setName and mod data
                local emptyPlate = table.remove(plates)
                local fullPlateType = ServingItems.FullPlateCounterparts[emptyPlate:getFullType()];
                result = InventoryItemFactory.CreateItem(fullPlateType);
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
                result:setName(ServingItems:NameCalcFunction(item:getName(), fullPlateType));

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
                
                inventory:Remove(emptyPlate);
                inventory:AddItem(result);
            end

            if (baseItem) then
                inventory:AddItem(baseItem);
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
        local item = ServingItems:GetItemInstance(items:get(i):getReplaceOnUse())
        player:getInventory():AddItem(item:getFullType());
    end
end
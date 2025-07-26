local ServingItems = {};
ServingItems.RecipeBaseItems = {
    -- ["PotOfSoup"] = "Base.Pot",
    -- ["PotOfSoupRecipe"] = "Base.Pot",
    ["WaterPotRice"] = "Base.Pot",
    ["PastaPot"] = "Base.Pot",
    ["RicePot"] = "Base.Pot",
    -- ["PotOfStew"] = "Base.Pot",
    ["RicePan"] = "Base.Saucepan",
    ["PastaPan"] = "Base.Saucepan",
    ["PieWholeRaw"] = "Base.BakingPan",
    ["CakeRaw"] = "Base.BakingPan",
    ["PanFriedVegetables"] = "Base.Pan",
    ["PanFriedVegetables2"] = "Base.RoastingPan",
    ["Sandwich"] = false,
    ["BurgerRecipe"] = false,
    ["Salad"] = "Base.Bowl",
    ["FruitSalad"] = "Base.Bowl",
    ["WaterSaucepanPasta"] = "Base.Saucepan",
    ["WaterSaucepanRice"] = "Base.Saucepan",
    ["WaterPotPasta"] = "Base.Pot"
}

ServingItems.ItemInstances = {
    ["Base.Pot"] = InventoryItemFactory.CreateItem("Base.Pot"),
    ["Base.Saucepan"] = InventoryItemFactory.CreateItem("Base.Saucepan"),
    ["Base.BakingPan"] = InventoryItemFactory.CreateItem("Base.BakingPan"),
    ["Base.Pan"] = InventoryItemFactory.CreateItem("Base.Pan"),
    ["Base.RoastingPan"] = InventoryItemFactory.CreateItem("Base.RoastingPan"),
    ["Base.Bowl"] = InventoryItemFactory.CreateItem("Base.Bowl"),
    ["Base.Plate"] = InventoryItemFactory.CreateItem("Base.Plate"),
    ["ServingItems.WoodenBowl"] = InventoryItemFactory.CreateItem("ServingItems.WoodenBowl"),
    ["ServingItems.ServingTray"] = InventoryItemFactory.CreateItem("ServingItems.ServingTray"),
    ["ServingItems.FullPlate"] = InventoryItemFactory.CreateItem("ServingItems.FullPlate"),
    ["ServingItems.FullWoodenBowl"] = InventoryItemFactory.CreateItem("ServingItems.FullWoodenBowl"),
    ["ServingItems.FullServingTray"] = InventoryItemFactory.CreateItem("ServingItems.FullServingTray")
}

ServingItems.RecipeSuffixes = {
    ["ServingItems.FullPlate"] = "in a Plate",
    -- ["ServingItems.FullWoodenBowl"] = "in a Wooden Bowl",
    ["ServingItems.FullServingTray"] = "on a Serving Tray"
}

ServingItems.EmptyCounterparts = {
    ["ServingItems.FullPlate"] = "Base.Plate",
    -- ["ServingItems.FullWoodenBowl"] = "ServingItems.WoodenBowl",
    ["ServingItems.FullServingTray"] = "ServingItems.ServingTray"
}

ServingItems.NameCalcFunctions = {
    ["WaterPotRice"] = function(name, type)
        return getItemText("Rice " .. ServingItems.RecipeSuffixes[type]);
    end,

    ["PastaPot"] = function(name, type)
        return ({string.gsub(name, "%s*%b()%s*", "")})[1] .. " (" .. ServingItems.ItemInstances[type]:getName() .. ")";
    end,

    ["RicePot"] = function(name, type)
        return ({string.gsub(name, "%s*%b()%s*", "")})[1] .. " (" .. ServingItems.ItemInstances[type]:getName() .. ")";
    end,

    ["RicePan"] = function(name, type)
        return ({string.gsub(name, "%s*%b()%s*", "")})[1] .. " (" .. ServingItems.ItemInstances[type]:getName() .. ")";
    end,

    ["PastaPan"] = function(name, type)
        return ({string.gsub(name, "%s*%b()%s*", "")})[1] .. " (" .. ServingItems.ItemInstances[type]:getName() .. ")";
    end,

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

    ["WaterSaucepanPasta"] = function(name, type)
        return getItemText("Pasta " .. ServingItems.RecipeSuffixes[type]);
    end,

    ["WaterSaucepanRice"] = function(name, type)
        return getItemText("Rice " .. ServingItems.RecipeSuffixes[type]);
    end,

    ["WaterPotPasta"] = function(name, type)
        return getItemText("Pasta " .. ServingItems.RecipeSuffixes[type]);
    end
}

local maxSplitting = 5;
for i=1,maxSplitting do
    _G["PutIn"..i.."ServingItems_OnCreate"] = function (items, result, player)
        local resultType = result:getFullType();
        for j=0,items:size() - 1 do
            local item = items:get(j);
            local itemType = item:getType();
            local baseItemID = ServingItems.RecipeBaseItems[itemType];
            if baseItemID ~= nil then
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
                    if baseItemID ~= false then
                        baseItemWeight = ServingItems.ItemInstances[baseItemID]:getWeight();
                    end
                    
                    local foodWeight = math.abs((ingredientWeight - baseItemWeight) / i); -- Some food items weigh less than their base item, this is my "fix"
    
                    result:setWeight(emptyItemWeight + foodWeight);
                    result:setActualWeight(emptyItemWeight + foodWeight);
                    local modData = result:getModData();
                    modData.emptyItemWeight = emptyItemWeight;
                    modData.foodWeight = foodWeight;

                    player:getInventory():AddItem(result);
                end

                if (baseItemID ~= false) then
                    player:getInventory():AddItem(baseItemID);
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
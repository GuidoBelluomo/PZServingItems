local ServingItems = ServingItems;

ServingItems.SplitOptions = {1, 2, 4}

-- Hashmap-like structure to quickly lookup plateable items
ServingItems.PlateableItems = {
    ["Base.PieWholeRaw"] = true,
    ["Base.PiePrep"] = true,
    ["Base.CakeRaw"] = true,
    ["Base.GriddlePanFriedVegetables"] = true,
    ["Base.PanFriedVegetables"] = true,
    ["Base.PanFriedVegetables2"] = true,
    ["Base.Sandwich"] = true,
    ["Base.OmeletteRecipe"] = true,
    ["Base.PieWholeRaw"] = true,
    ["Base.PieWholeRawSweet"] = true,
};

-- Store the respective full version of every base plate for easy lookup
ServingItems.EmptyToFullPlateMap = {
    ["Base.Plate"] = "ServingItems.FullPlate",
    ["Base.PlateBlue"] = "ServingItems.FullPlateBlue",
    ["Base.PlateOrange"] = "ServingItems.FullPlateOrange",
    ["Base.PlateFancy"] = "ServingItems.FullPlateFancy",
};

-- Initialize empty plates map based on EmptyToFullPlateMap
ServingItems.EmptyPlates = {}
for k, _ in pairs(ServingItems.EmptyToFullPlateMap) do
    ServingItems.EmptyPlates[k] = true;
end

ServingItems.TransferrableItemData = {
    {["value"] = "BaseHunger", ["getter"] = "getBaseHunger", ["split"] = true},
    {["value"] = "HungChange", ["getter"] = "getHungChange", ["split"] = true},
    {["value"] = "ThirstChange", ["getter"] = "getThirstChange", ["split"] = true},
    {["value"] = "BoredomChange", ["getter"] = "getBoredomChange", ["split"] = true},
    {["value"] = "UnhappyChange", ["getter"] = "getUnhappyChange", ["split"] = true},
    {["value"] = "StressChange", ["getter"] = "getStressChange", ["split"] = true},
    {["value"] = "FatigueChange", ["getter"] = "getFatigueChange", ["split"] = true},
    {["value"] = "EndChange", ["getter"] = "getEndChange", ["split"] = true},
    {["value"] = "ReduceInfectionPower", ["getter"] = "getReduceInfectionPower", ["split"] = true},
    {["value"] = "Carbohydrates", ["getter"] = "getCarbohydrates", ["split"] = true},
    {["value"] = "Lipids", ["getter"] = "getLipids", ["split"] = true},
    {["value"] = "Proteins", ["getter"] = "getProteins", ["split"] = true},
    {["value"] = "Calories", ["getter"] = "getCalories", ["split"] = true},
    {["value"] = "ReduceFoodSickness", ["getter"] = "getReduceFoodSickness", ["split"] = true},
    {["value"] = "FluReduction", ["getter"] = "getFluReduction", ["split"] = true},
    {["value"] = "PainReduction", ["getter"] = "getPainReduction", ["split"] = true},
    {["value"] = "PoisonPower", ["getter"] = "getPoisonPower", ["split"] = true},
    {["value"] = "AlcoholPower", ["getter"] = "getAlcoholPower", ["split"] = true},
    {["value"] = "MinutesToCook", ["getter"] = "getMinutesToCook", ["split"] = true},
    {["value"] = "MinutesToBurn", ["getter"] = "getMinutesToBurn", ["split"] = true},
    {["value"] = "Alcoholic", ["getter"] = "isAlcoholic", ["split"] = false},
    {["value"] = "TaintedWater", ["getter"] = "isTaintedWater", ["split"] = false},
    {["value"] = "Rotten", ["getter"] = "isRotten", ["split"] = false},
    {["value"] = "Burnt", ["getter"] = "isBurnt", ["split"] = false},
    {["value"] = "Age", ["getter"] = "getAge", ["split"] = false},
    {["value"] = "Cooked", ["getter"] = "isCooked", ["split"] = false},
    {["value"] = "IsCookable", ["getter"] = "isIsCookable", ["split"] = false},
    {["value"] = "CookingTime", ["getter"] = "getCookingTime", ["split"] = false},
    {["value"] = "OffAge", ["getter"] = "getOffAge", ["split"] = false},
    {["value"] = "OffAgeMax", ["getter"] = "getOffAgeMax", ["split"] = false},
    {["value"] = "LastAged", ["getter"] = "getLastAged", ["split"] = false},
    {["value"] = "Frozen", ["getter"] = "isFrozen", ["split"] = false},
    {["value"] = "CanBeFrozen", ["getter"] = "canBeFrozen", ["split"] = false},
    {["value"] = "FreezingTime", ["getter"] = "getFreezingTime", ["split"] = false},
    {["value"] = "RottenTime", ["getter"] = "getRottenTime", ["split"] = false},
    {["value"] = "CompostTime", ["getter"] = "getCompostTime", ["split"] = false},
    {["value"] = "BadInMicrowave", ["getter"] = "isBadInMicrowave", ["split"] = false},
    {["value"] = "BadCold", ["getter"] = "isBadCold", ["split"] = false},
    {["value"] = "GoodHot", ["getter"] = "isGoodHot", ["split"] = false},
    {["value"] = "Heat", ["getter"] = "getHeat", ["split"] = false},
    {["value"] = "bDangerousUncooked", ["getter"] = "isbDangerousUncooked", ["split"] = false},
    {["value"] = "LastCookMinute", ["getter"] = "getLastCookMinute", ["split"] = false},
    {["value"] = "Spice", ["getter"] = "isSpice", ["split"] = false},
    {["value"] = "PoisonDetectionLevel", ["getter"] = "getPoisonDetectionLevel", ["split"] = false},
    {["value"] = "PoisonLevelForRecipe", ["getter"] = "getPoisonLevelForRecipe", ["split"] = false},
    {["value"] = "UseForPoison", ["getter"] = "getUseForPoison", ["split"] = false},
    {["value"] = "FoodType", ["getter"] = "getFoodType", ["split"] = false},
    {["value"] = "CustomEatSound", ["getter"] = "getCustomEatSound", ["split"] = false},
    {["value"] = "Chef", ["getter"] = "getChef", ["split"] = false},
    {["value"] = "HerbalistType", ["getter"] = "getHerbalistType", ["split"] = false},
};
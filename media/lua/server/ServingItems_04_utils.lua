local ServingItems = ServingItems;

function ServingItems:NameCalcFunction(name, emptyPlate)
    -- We must remove the Raw, Rotten, Fresh etc. suffixes, add the container's name, and just let the game re-add them based on item data 
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
        if ServingItems.EmptyToFullPlateMap[item:getFullType()] then
            emptyPlates[#emptyPlates + 1] = item
            if #emptyPlates >= max then
                break;
            end
        end
    end

    return emptyPlates;
end

function ServingItems:CreateFullPlateFromEmptyPlate(emptyPlate)
    local fullPlateType = ServingItems.EmptyToFullPlateMap[emptyPlate:getFullType()];
    return InventoryItemFactory.CreateItem(fullPlateType);
end

local function applyTransferrableDataToPlate(source, plate)
    for _, entry in ipairs(ServingItems.TransferrableItemData) do
        local getter = source[entry.getter];
        local setter = plate["set" .. entry.value];
        
        local value = getter(source);
        if entry.split then value = value / splitCount end;
        setter(plate, value);
    end
end

function ServingItems:InitPlateFromSource(source, emptySource, plate, emptyPlate, splitCount)
    applyTransferrableDataToPlate(source, plate)
    plate:setName(ServingItems:NameCalcFunction(source:getName(), emptyPlate));
    plate:setCustomName(true)
    local emptySourceWeight = 0;
    if emptySource then
        emptySourceWeight = ServingItems:GetItemInstance(emptySource):getWeight();
    end
    
    -- Some food items seemed to weigh less than their base item, math.abs is my "fix". Technically this is incorrect, but I don't like the idea of food weighing 0 or even negative.
    local foodWeight = math.abs((source:getWeight() - emptySourceWeight) / splitCount);

    plate:setWeight(emptySourceWeight + foodWeight);
    plate:setActualWeight(emptySourceWeight + foodWeight);
    local modData = plate:getModData();
    modData.emptySourceWeight = emptySourceWeight;
    modData.foodWeight = foodWeight;
end
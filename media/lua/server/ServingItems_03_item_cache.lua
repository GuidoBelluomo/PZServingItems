local ServingItems = ServingItems;

-- Item instance cache, pre-cached with full plate instances. It'll expand as needed.
ServingItems.ItemInstances = {
    ["ServingItems.FullPlate"] = InventoryItemFactory.CreateItem("ServingItems.FullPlate"),
    ["ServingItems.FullPlateBlue"] = InventoryItemFactory.CreateItem("ServingItems.FullPlateBlue"),
    ["ServingItems.FullPlateOrange"] = InventoryItemFactory.CreateItem("ServingItems.FullPlateOrange"),
    ["ServingItems.FullPlateFancy"] = InventoryItemFactory.CreateItem("ServingItems.FullPlateFancy"),
}

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

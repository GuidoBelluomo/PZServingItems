-- Initialize module table
ServingItems = {};

-- Replace default empty plate icons
local function SetItemParam(name, param, value)
    local scriptManager = getScriptManager();
    local item = scriptManager:getItem(name);
    item:DoParam(param .. " = " .. value);
end
SetItemParam("Base.PlateBlue","Icon","PlateBlue");
SetItemParam("Base.PlateOrange","Icon","PlateOrange");
SetItemParam("Base.PlateFancy","Icon","PlateFancy");

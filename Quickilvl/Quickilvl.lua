local slots = {
    "HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot",
    "WristSlot", "HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot",
    "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot",
    "MainHandSlot", "SecondaryHandSlot"
}

local function CalculateAverageItemLevel()
    local totalItemLevel = 0
    local itemCount = 0

    -- Loop through each equipment slot
    for _, slotName in ipairs(slots) do
        local slotId = GetInventorySlotInfo(slotName)
        local itemLink = GetInventoryItemLink("target", slotId)

        if itemLink then
            local _, _, itemQuality, itemLevel = GetItemInfo(itemLink)
            if itemLevel then
                totalItemLevel = totalItemLevel + itemLevel
                itemCount = itemCount + 1
            end
        end
    end

    -- Calculate the average item level
    if itemCount > 0 then
        local averageItemLevel = totalItemLevel / itemCount

        if InspectPaperDollFrame and InspectPaperDollFrame.ViewButton then
            -- Create the item level text if it doesn't exist
            if not InspectPaperDollFrame.itemLevelText then
                InspectPaperDollFrame.itemLevelText = InspectPaperDollFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                InspectPaperDollFrame.itemLevelText:SetPoint("TOPLEFT", InspectPaperDollFrame.ViewButton, "TOPRIGHT", 10, 0)
            end

            -- Update the item level text
            InspectPaperDollFrame.itemLevelText:SetText(string.format("%.2f", averageItemLevel))
        end
    else
        print("No items found to calculate item level.")
    end
end

-- Hook into the inspection event to calculate item level when inspecting
local frame = CreateFrame("Frame")
frame:RegisterEvent("INSPECT_READY")
frame:SetScript("OnEvent", function(self, event, ...)
    CalculateAverageItemLevel()
end)


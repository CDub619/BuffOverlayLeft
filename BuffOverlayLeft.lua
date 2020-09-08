--On Git HUb
local overlays = {}
local buffs = {}

local prioritySpellList = { --The higher on the list, the higher priority the buff has.
--**Drinking**--

185710, --Sugar-Crusted Fish Feast
"Food",
"Drink",
"Food & Drink",
"Refreshment",

--**Immunity Raid**--

8178, --Grounding Totem Effect
213915, --Mass Spell Reflection

--**Healer CDs Given**--

199448, --Blessing of Sacrifice (100%)
1022, --Blessing of Protection
204018, --Blessing of Spellwarding
6940, --Blessing of Sacrifice (30%)
31821, --Aura Mastery
33206, --Pain Suppression
81782, --Power Word: Barrier
47788, --Guardian Spirit
64843, --Divine Hymn
247563, --Nature's Grasp (Has Stacks)
102342, --Ironbark
157982, --Tranquility (Has Stacks)
98007, --Spirit Link Totem
201633, --Earthen Shield
116849, --Life Cocoon
296230, --(Vitality Conduit)
287568, --(Trinket Ward)
295271, --(Trinket Void Stone)
266018, --(Trinket Voodoo Totem)(Has Stacks)

--**Class AOE Healing CDs**--

207498, --Ancestral Protection
209426, --Darkness
145629, --Anti-Magic Zone
97463, --Rallying Cry
236696, --Thorns(Friendly and Enemy spellId)

--** Healer CDs Given w/ Short CD**--
102351, --Cenarion Ward
102352, --Cenarion Ward
279793, --Grove Tending
295384, --Concentrated Flame (Essence)
303698, --Luminous Jellyweed
204293, --Spirit Link
974, --Earth Shield (Has Stacks)

--**Major Class CDs**--
--**Beneficial Casting Buffs **--
--**Freedoms/Root Break Given**--
--**Speed Given**--
--**Class Speed**--

--**Passive Buffs Given**--

289318, --Mark of the Wild
203538, --Greater Blessing of Kings
203539, --Greater Blessing of Wisdom
288509, --Shadow Resistance Aura
}

local units = {
['raid1'] = true,
['raid2'] = true,
['raid3'] = true,
['raid4'] = true,
['raid5'] = true,
['raid6'] = true,
['raid7'] = true,
['raid8'] = true,
['raid9'] = true,
['raid10'] = true,
['raid11'] = true,
['raid12'] = true,
['raid13'] = true,
['raid14'] = true,
['raid15'] = true,
['raid16'] = true,
['raid17'] = true,
['raid18'] = true,
['raid19'] = true,
['raid20'] = true,
['raid21'] = true,
['raid22'] = true,
['raid22'] = true,
['raid23'] = true,
['raid24'] = true,
['raid25'] = true,
['raid26'] = true,
['raid27'] = true,
['raid28'] = true,
['raid29'] = true,
['raid30'] = true,
['raid31'] = true,
['raid32'] = true,
['raid33'] = true,
['raid34'] = true,
['raid35'] = true,
['raid36'] = true,
['raid37'] = true,
['raid38'] = true,
['raid39'] = true,
['raid40'] = true,
['party1'] = true,
['party2'] = true,
['party3'] = true,
['party4'] = true,
['party5'] = true,
['player'] = true,
}

for k, v in ipairs(prioritySpellList) do
	buffs[v] = k
end

hooksecurefunc("CompactUnitFrame_UpdateBuffs", function(self)
	if self:IsForbidden() or not self:IsVisible() or not self.buffFrames then
		return
	end

	local unit, index, buff = self.displayedUnit, index, buff
	for i = 1, 32 do --BUFF_MAX_DISPLAY
		if units[unit] then
		local buffName, _, _, _, _, _, _, _, _, spellId = UnitAura(unit, i,"HELPFUL")
	  --print(unit, i, "|", buffName, "|", spellId)
	   	if spellId then
				 if buffs[buffName] then
						buffs[spellId] = buffs[buffName]
				 end
					if buffs[spellId] then
						if not buff or buffs[spellId] < buffs[buff] then
							buff = spellId
							index = i
						end
				  end
			else
				break
		end
 	   else
		  break
	 end
	end

	local overlay = overlays[self]
	if not overlay then
		if not index then
			return
		end
		overlay = CreateFrame("Button", "$parentBuffOverlayLeft", self, "CompactAuraTemplate")
		overlay:ClearAllPoints()
		overlay:SetPoint("TOPLEFT", self, "TOPLEFT", 2, -1.5)
		overlay:SetAlpha(1)
		overlay:EnableMouse(false)
		overlay:RegisterForClicks()
		overlays[self] = overlay
	end

	if index then
		overlay:SetSize(self.buffFrames[1]:GetSize())
		overlay:SetScale(1.15)
		CompactUnitFrame_UtilSetBuff(overlay, index, UnitBuff(unit, index))
	end
	overlay:SetShown(index and true or false)
end)

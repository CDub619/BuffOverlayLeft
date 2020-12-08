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
305497, --Thorns(Friendly and Enemy spellId)

--** Healer CDs Given w/ Short CD**--
102351, --Cenarion Ward
102352, --Cenarion Ward
279793, --Grove Tending
295384, --Concentrated Flame (Essence)
327710, --Benevolent Faerie CD Reduction (Night Fae Priest)
327694, --Benevolent Faerie 10% DMG Reduction (Night Fae Priest)
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

for k, v in ipairs(prioritySpellList) do
	buffs[v] = k
end

hooksecurefunc("CompactUnitFrame_UpdateAuras", function(self)
	if self:IsForbidden() or not self:IsVisible() or not self.buffFrames then
		return
	end

	local BenevolentDmg, BenevolentCD, BenevolentBoth

	local unit, index, buff = self.displayedUnit, index, buff
	for i = 1, 32 do --BUFF_MAX_DISPLAY
		local buffName, _, _, _, _, _, _, _, _, spellId = UnitBuff(unit, i,"HELPFUL")

		if spellId == 327710 then
			BenevolentCD = i
		end
		if spellId == 327694 then
			BenevolentDmg = i
		end
		if BenevolentDmg and BenevolentCD then
			BenevolentBoth = true
		end

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

		if BenevolentBoth then
			if index == BenevolentBoth or index == BenevolentCD then
			overlay.icon:SetDesaturated(1) --Destaurate Icon
			overlay.icon:SetVertexColor(.1, 1, 0); -- Lighter Green Set
			else
			overlay.icon:SetDesaturated(nil)
			overlay.icon:SetVertexColor(1, 1, 1);
			end
		elseif BenevolentCD then
			if index == BenevolentCD then
			overlay.icon:SetDesaturated(1) --Destaurate Icon
			overlay.icon:SetVertexColor(0, .75, 1); -- Light Blue or Turquoise
			else
			overlay.icon:SetDesaturated(nil)
			overlay.icon:SetVertexColor(1, 1, 1);
			end
		elseif BenevolentDmg then
			if index == BenevolentDmg then
			overlay.icon:SetDesaturated(1) --Destaurate Icon
			overlay.icon:SetVertexColor(1, 1, 0); -- Yellow Set
			else
			overlay.icon:SetDesaturated(nil)
			overlay.icon:SetVertexColor(1, 1, 1);
			end
		else
			overlay.icon:SetDesaturated(nil)
			overlay.icon:SetVertexColor(1, 1, 1);
		end

		--overlay.icon:SetVertexColor(0, 0, 1); -- Blue Set
		--overlay.icon:SetVertexColor(0, 1, 0); -- Green Set
		--overlay.icon:SetVertexColor(1, 0, 1); -- Purple

	end
	overlay:SetShown(index and true or false)
end)

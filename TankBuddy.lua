--[[
- Classic Tank Buddy v3.0.1
- Author: bjornenalfa
- Contact: https://github.com/bjornenalfa
-
- Based on:
-   Extended Tank Buddy
-   Author: sahne123
-   Contact: https://github.com/sahne123
-
- Based on:
-   Tank Buddy 2.0.1
-   Author: Kolthor from Doomhammer EU
-   Contact: http://www.curse-gaming.com | USER NAME: Kolthor
-
- Based on:
-	Taunt Buddy v1.33
-	Author: Artun Subasi
-	Kane from Magtherion EU (retired)
-	Contact: http://www.curse-gaming.com | USER NAME: Kane
--]]


-- Globals
TBSettingsCharRealm = UnitName("player") .. "@" .. GetRealmName();
TB_Channels = {
	{ "CTRaid", TB_GUI_Channel_Ctraid, "MS " },
	{ "RaidWarning", TB_GUI_Channel_RaidWarning, "RAID_WARNING" },
	{ "Raid", TB_GUI_Channel_Raid, "RAID" },
	{ "Party", TB_GUI_Channel_Party, "PARTY" },
	{ "Yell", TB_GUI_Channel_Yell, "YELL" },
	{ "Say", TB_GUI_Channel_Say, "SAY" },
	{ "Custom", TB_GUI_Channel_Custom, "CHANNEL" }
};
TB_Modes = {
	{ "Raid", TB_GUI_Raid },
	{ "Party", TB_GUI_Party },
	{ "Alone", TB_GUI_Alone }
};
TB_intellectfound = false
TB_intellectfound1 = false
TB_spiritfound = false
TB_spiritfound1 = false
TB_spiritfound2 = false
TB_debug = false

local function starts_with(str, start)
   return str:sub(1, #start) == start
end

local function ends_with(str, ending)
   return ending == "" or str:sub(-#ending) == ending
end

function TB_OnLoad()
	_, englishClass = UnitClass("player");
	if (englishClass == "WARRIOR") then
		TB_Tabs = {
			{ TB_GUI_General, "Interface\\Icons\\Spell_Shadow_SoulGem"},
			{ TB_GUI_Taunt, "Interface\\Icons\\Spell_Nature_Reincarnation" },
			{ TB_GUI_MB, "Interface\\Icons\\Ability_Warrior_PunishingBlow" },
			{ TB_GUI_LS, "Interface\\Icons\\Spell_Holy_AshesToAshes" },
			{ TB_GUI_SW, "Interface\\Icons\\Ability_Warrior_ShieldWall" },
      { TB_GUI_CS, "Interface\\Icons\\Ability_BullRush" },
			{ TB_GUI_DW, "Interface\\Icons\\Spell_Shadow_DeathPact" },
			{ TB_GUI_LG, "Interface\\Icons\\INV_Misc_Gem_Pearl_05" }
		};
		TB_TankForm = 2;	--Defensive stance has Shapeshiftform number 2
		SalvDefensiveBearText:SetText(TB_GUI_SalvationDefensive);
	elseif (englishClass == "DRUID") then
		TB_Tabs = {
			{ TB_GUI_General, "Interface\\Icons\\Spell_Shadow_SoulGem"},
			{ TB_GUI_Growl, "Interface\\Icons\\Ability_Physical_Taunt" },
      { TB_GUI_CR, "Interface\\Icons\\Ability_Druid_ChallangingRoar" }
		};
		TB_TankForm = 1;	--Bear form has Shapeshiftform number 1
		SalvDefensiveBearText:SetText(TB_GUI_SalvationBear);
	else
		TB_Tabs = {
			{ TB_GUI_General, "Interface\\Icons\\Spell_Shadow_SoulGem"}
		};
		TB_TankForm = nil;
		TB_DefensiveBearCheckButton:Hide();
		SalvDefensiveBearText:Hide();
	end
	NUM_TB_TABS = getn(TB_Tabs);
	MAX_TB_TABS = 8;
	
	TankBuddyFrame:RegisterEvent("VARIABLES_LOADED");					-- Jump to event function when variables are loaded
	
	SLASH_TBSLASH1 = "/tankbuddy";								-- /tankbuddy
	SLASH_TBSLASH2 = "/tb";									-- /tb
	SlashCmdList["TBSLASH"] = TB_SlashCommandHandler;					-- List of slash commands

	TB_SetTab(1);			--Set default tab
	
	for i = 1, NUM_TB_TABS, 1 do
		getglobal("TB_Tab" .. i).tooltiptext = TB_Tabs[i][1];
		getglobal("TB_Tab" .. i):SetNormalTexture(TB_Tabs[i][2]);
	end
	
	for i = 1, MAX_TB_TABS, 1 do
		if ( i > NUM_TB_TABS ) then
			getglobal("TB_Tab" .. i):Hide();
		else
			getglobal("TB_Tab" .. i):Show();
		end
	end

	TB_DefensiveBearCheckButton:Disable();		--The "only in Defensive Stance/Bear Form"-checkbox is disabled until "Remove salvation" is checked
	TB_ButtonPaste:Disable();		--The paste-button is disabled until the copy-button has been clicked
end

function TB_Tab_OnClick(id, self)
	if ( not id ) then
		id = self:GetID();
	end
	TB_SetTab(id);
end

function TB_SetTab(id)
	if (not TankBuddyFrame.selectedTab) then
		getglobal("TB_Tab" .. id):SetChecked(1);
	else
		getglobal("TB_Tab" .. TankBuddyFrame.selectedTab):SetChecked(nil);
		if (TankBuddyFrame.selectedTab ~= 1) then
			TBSettings[TBSettingsCharRealm].Announcements[TB_Tabs[TankBuddyFrame.selectedTab][1]]["Text"] = TB_EditboxText:GetText();
		end
	end
	if (id == 1) then
		TB_OtherOptions:Hide();
		TB_GeneralOptions:Show();
	else
		TB_OtherOptions:Show();
		TB_GeneralOptions:Hide();
		
		TB_EditboxText:SetText(TBSettings[TBSettingsCharRealm].Announcements[TB_Tabs[id][1]]["Text"]);
		TB_SetTextText:SetText(TB_GUI_EnterNewText[TB_Tabs[id][1]]);
	end

	TankBuddyFrame.selectedTab = id;
	HeaderText:SetText(TB_Tabs[id][1]);
	if (TBSettings) then
		TB_SetChannels();
	end
end

function TB_SetChannels()
	if (TankBuddyFrame.selectedTab ~= 1) then
		for i = 1, getn(TB_Modes), 1 do
			for j = 1, getn(TB_Channels), 1 do
				if (getglobal("TB_" .. TB_Modes[i][1] .. TB_Channels[j][1] .. "CheckButton")) then
					local Checked = TBSettings[TBSettingsCharRealm].Announcements[TB_Tabs[TankBuddyFrame.selectedTab][1]][TB_Modes[i][2]][TB_Channels[j][2]];
					getglobal("TB_" .. TB_Modes[i][1] .. TB_Channels[j][1] .. "CheckButton"):SetChecked(Checked);
				end
			end
		end
	end
end

function TB_Channels_OnClick(self)
	for i = 1, getn(TB_Modes), 1 do
		for j = 1, getn(TB_Channels), 1 do
			if (self:GetName() == "TB_" .. TB_Modes[i][1] .. TB_Channels[j][1] .. "CheckButton") then
				local Checked = self:GetChecked();
				TBSettings[TBSettingsCharRealm].Announcements[TB_Tabs[TankBuddyFrame.selectedTab][1]][TB_Modes[i][2]][TB_Channels[j][2]] = Checked;
				if (TB_Channels[j][1] == "Custom") then
					if (Checked) then
						TB_SetCustomChannel(i);
					else
						TB_CustomChannelFrame:Hide();
					end
				end
			end
		end
	end
end

function TB_OnEvent(event)
 	local TBAbility = "";
	-- Execute this function whenever you get a string in the self damage spells section, or when variables are loaded.
	if(event == "COMBAT_LOG_EVENT_UNFILTERED") then
    local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags, destFlags2, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12 = CombatLogGetCurrentEventInfo()
    
    if (sourceName ~= UnitName("player")) then
      return
    end
    
    if TB_debug then
      print(CombatLogGetCurrentEventInfo())
    end
    
    if not starts_with(subevent, "SPELL") then
      return
    end
    
    local spellName = a2
    
    if ends_with(subevent, "_MISSED") then
      if (englishClass == "WARRIOR") then
        if (spellName == TB_tauntName) then 									-- Checks if your taunt was resisted
          TBAbility = TB_GUI_Taunt;
        elseif (spellName == TB_mbName) then			-- Checks if the name is "Mocking Blow"
          TBAbility = TB_GUI_MB;
        end
        
      elseif (englishClass == "DRUID") then
        if (spellName == TB_growlName) then 									-- Checks if your taunt was resisted
          TBAbility = TB_GUI_Growl;
        end
      end
    
    elseif ends_with(subevent, "_AURA_APPLIED") then
      if (englishClass == "WARRIOR") then
        if (spellName == TB_swName) then
          TBAbility = TB_GUI_SW
        elseif (spellName == TB_lsName) then
          TBAbility = TB_GUI_LS
        elseif (spellName == TB_dwName) then
          TBAbility = TB_GUI_DW
        elseif (spellName == TB_lgName) then
          TBAbility = TB_GUI_LG
        end
      end
    
    elseif ends_with(subevent, "_CAST_SUCCESS") then
      if (englishClass == "WARRIOR") then
        if (spellName == TB_csName) then 									-- Checks if it is challenging shout
          TBAbility = TB_GUI_CS;
        end
        
      elseif (englishClass == "DRUID") then
        if (spellName == TB_crName) then 									-- Checks if it is challenging roar
          TBAbility = TB_GUI_CR;
        end
      end
    end
    
		
    
    --[[ -- TODO: AURAS
      if(TBSettings[TBSettingsCharRealm].MakeMeStupidStatus) then
              if arg1 == TB_intel or arg1 == TB_intel1 then
                  TB_intellectfound = true
              elseif arg1 == TB_intel2 then
                  TB_intellectfound1 = true
              elseif arg1 == TB_spiritline then
                  TB_spiritfound = true
              elseif arg1 == TB_spiritline1 then
                  TB_spiritfound1 = true
              elseif arg1 == TB_spiritline2 then
                  TB_spiritfound2 = true
              end
      end
    ]]
		
	--[[elseif (event == "UNIT_AURA" or event == "UPDATE_SHAPESHIFT_FORMS") then
		if (TBSettings[TBSettingsCharRealm].MakeMeStupidStatus) then
            if (TB_intellectfound) then
                CancelPlayerBuff(TB_PlayerBuffByTexture(TB_intellect));
                TB_Sendmsg(TB_output_intellect);
                TB_intellectfound = false
            elseif (TB_intellectfound1) then
                CancelPlayerBuff(TB_PlayerBuffByTexture(TB_intellect1));
                TB_Sendmsg(TB_output_intellect);
                TB_intellectfound1 = false
            elseif (TB_spiritfound) then
                CancelPlayerBuff(TB_PlayerBuffByTexture(TB_spirit));
                TB_Sendmsg(TB_output_spirit);
                TB_spiritfound = false
            elseif (TB_spiritfound1) then
                CancelPlayerBuff(TB_PlayerBuffByTexture(TB_spirit1));
                TB_Sendmsg(TB_output_spirit);
                TB_spiritfound1 = false
            elseif (TB_spiritfound2) then
                CancelPlayerBuff(TB_PlayerBuffByTexture(TB_spirit2));
                TB_Sendmsg(TB_output_spirit);
                TB_spiritfound2 = false
            end
        end

		if (TB_PlayerBuff(TB_salvation)) then		--Look for a buff with "Salvation" in it
			if (TBSettings[TBSettingsCharRealm].Salvstatus) then
				if (TBSettings[TBSettingsCharRealm].SalvDefensiveBearstatus) then
					local _, active, _, _ = GetShapeshiftFormInfo(TB_TankForm);
					if (active) then
						CancelUnitBuff("player", TB_PlayerBuff(TB_salvation));					--Cancel it
            --CancelUnitBuff("player", "Blessing of Salvation");					--Cancel it
            --CancelUnitBuff("player", "Greater Blessing of Salvation");					--Cancel it
						TB_Sendmsg(TB_output_salvation);
					end
				else
					CancelUnitBuff("player", TB_PlayerBuff(TB_salvation));					--Cancel it
          --CancelUnitBuff("player", "Blessing of Salvation");					--Cancel it
          --CancelUnitBuff("player", "Greater Blessing of Salvation");					--Cancel it
					TB_Sendmsg(TB_output_salvation);
				end
			end
		end]]

	elseif (event == "VARIABLES_LOADED") then
		-- load each option, set default if not there
		if ( not TBSettings ) then
	 		TBSettings = {};
		end
		if (not TBSettings[TBSettingsCharRealm]) then
	 		TBSettings[TBSettingsCharRealm] = {};
		end

		if (not TBSettings[TBSettingsCharRealm].Announcements) then
			TBSettings[TBSettingsCharRealm].Announcements = {};
		end

		for i = 2, NUM_TB_TABS, 1 do
			if (not TBSettings[TBSettingsCharRealm].Announcements[TB_Tabs[i][1]]) then
				TBSettings[TBSettingsCharRealm].Announcements[TB_Tabs[i][1]] = {};
			end
			if (not TBSettings[TBSettingsCharRealm].Announcements[TB_Tabs[i][1]]["Text"]) then
				TBSettings[TBSettingsCharRealm].Announcements[TB_Tabs[i][1]]["Text"] = 1;						--Used later to see if it exists
			end
			if (not TBSettings[TBSettingsCharRealm].Announcements[TB_Tabs[i][1]][TB_GUI_Raid]) then
				TBSettings[TBSettingsCharRealm].Announcements[TB_Tabs[i][1]][TB_GUI_Raid] = {};
			end
			if (not TBSettings[TBSettingsCharRealm].Announcements[TB_Tabs[i][1]][TB_GUI_Party]) then
				TBSettings[TBSettingsCharRealm].Announcements[TB_Tabs[i][1]][TB_GUI_Party] = {};
			end
			if (not TBSettings[TBSettingsCharRealm].Announcements[TB_Tabs[i][1]][TB_GUI_Alone]) then
				TBSettings[TBSettingsCharRealm].Announcements[TB_Tabs[i][1]][TB_GUI_Alone] = {};
			end
		end
		
		if (TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_Taunt]) then
			if (TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_Taunt]["Text"] == 1) then
				TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_Taunt]["Text"] = TB_defaultText_t;			-- Default value for text_t
			end
		end
		if (TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_MB]) then
			if (TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_MB]["Text"] == 1) then
				TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_MB]["Text"] = TB_defaultText_mb;				-- Default value for text_mb
			end
		end
		if (TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_LS]) then
			if (TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_LS]["Text"] == 1) then
				TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_LS]["Text"] = TB_defaultText_ls;				-- Default value for text_ls
			end
		end
		if (TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_SW]) then
			if (TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_SW]["Text"] == 1) then
				TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_SW]["Text"] = TB_defaultText_sw;				-- Default value for text_sw
			end
		end
    if (TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_CS]) then
			if (TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_CS]["Text"] == 1) then
				TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_CS]["Text"] = TB_defaultText_cs;				-- Default value for text_cs
			end
		end
		if (TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_DW]) then
			if (TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_DW]["Text"] == 1) then
				TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_DW]["Text"] = TB_defaultText_dw;				-- Default value for text_dw
			end
		end
		if (TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_LG]) then
			if (TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_LG]["Text"] == 1) then
				TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_LG]["Text"] = TB_defaultText_lg;				-- Default value for text_lg
			end
		end
		if (TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_Growl]) then
			if (TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_Growl]["Text"] == 1) then
				TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_Growl]["Text"] = TB_defaultText_g;				-- Default value for text_g
			end
		end
    if (TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_CR]) then
			if (TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_CR]["Text"] == 1) then
				TBSettings[TBSettingsCharRealm].Announcements[TB_GUI_CR]["Text"] = TB_defaultText_cr;				-- Default value for text_cr
			end
		end
			
		if (not TBSettings[TBSettingsCharRealm].status) then
			TBSettings[TBSettingsCharRealm].status = 1;													-- Default value is 1 for status
		end

		--TB_Sendmsg("Tank Buddy " .. TB_version .. TB_output_startup);			-- Tank Buddy loading message
		if (TBSettings[TBSettingsCharRealm].status == 1) then
			TB_register();								-- Registers the event of self spell damage on startup
		else
			TB_CheckButton:SetChecked(0);
		end
		
		TB_DefensiveBearCheckButton:SetChecked(TBSettings[TBSettingsCharRealm].SalvDefensiveBearstatus);
		TB_EnableSalvationCheckButton:SetChecked(TBSettings[TBSettingsCharRealm].Salvstatus);
		TB_EnableMakeMeStupidCheckButton:SetChecked(TBSettings[TBSettingsCharRealm].MakeMeStupidStatus);
		if (TBSettings[TBSettingsCharRealm].Salvstatus) then
			TB_DefensiveBearCheckButton:Enable();
		end
	end
	
	if (TBAbility and TBAbility ~= "") then
		TB_Announce(TBAbility);
	end
end

-- Split text into a list consisting of the strings in text,
-- separated by strings matching delimiter (which may be a pattern). 
-- example: TB_strsplit(",%s*", "Anna, Bob, Charlie,Dolores")
function TB_strsplit(delimiter, text)
  local list = {}
  local pos = 1
  if string.find("", delimiter, 1) then -- this would result in endless loops
    error("delimiter matches empty string!")
  end
  while 1 do
    local first, last = string.find(text, delimiter, pos)
    if first then -- found?
      tinsert(list, strsub(text, pos, first-1))
      pos = last+1
    else
      tinsert(list, strsub(text, pos))
      break
    end
  end
  return list
end

-- SLASH COMMAND HANDLER --
function TB_SlashCommandHandler( msg )
	local command = string.lower(msg);

	-- Console command: /TB ON --
	if (command == TB_cmd_on) then
		if (TBSettings[TBSettingsCharRealm].status == 1) then						-- Checks if Tank Buddy is already enabled
			TB_Sendmsg(TB_output_alreadyOn);
		else										-- If not enabled..
			TB_Sendmsg(TB_output_on);
			TBSettings[TBSettingsCharRealm].status = 1;							-- Enables Tank Buddy
			TB_register();
			TB_CheckButton:SetChecked(1);
		end

	-- Console command: /TB OFF --
	elseif (command == TB_cmd_off) then
		if (TBSettings[TBSettingsCharRealm].status == 0) then						-- Checks if Tank Buddy is already disabled
			TB_Sendmsg(TB_output_alreadyOff);			
		else										-- if not disabled..
			TB_Sendmsg(TB_output_off);				
			TBSettings[TBSettingsCharRealm].status = 0;							-- Disables Tank Buddy
			TB_unregister();
			TB_CheckButton:SetChecked(0);
		end
  
  elseif command == TB_cmd_debug then
    TB_debug = not TB_debug
    if TB_debug then
      TB_Sendmsg(TB_output_debug_on)
    else
      TB_Sendmsg(TB_output_debug_off)
    end


	-- Console Command: /TB --
	elseif (command == "") then
		TankBuddyFrame:Show();

	-- Console Command: Unknown command or syntax error --
	else
		TankBuddyFrame:Show();
	end
end
-- END OF SLASH COMMAND HANDLER --

function TB_Test()
	TBSettings[TBSettingsCharRealm].Announcements[TB_Tabs[TankBuddyFrame.selectedTab][1]]["Text"] = TB_EditboxText:GetText();
	TB_Announce(TB_Tabs[TankBuddyFrame.selectedTab][1], 1);
end

function TB_Announce(TBAbility, TBTest)
	if (TBAbility) then
		local TBText = TBSettings[TBSettingsCharRealm].Announcements[TBAbility]["Text"];
		if (TBAbility == TB_GUI_Taunt or TBAbility == TB_GUI_MB or TBAbility == TB_GUI_Growl) then
			if (TBText) then
				if (UnitName("target")) then
					Icon = "";
					if GetRaidTargetIndex("target")==1 then Icon = " {rt1} "; end
					if GetRaidTargetIndex("target")==2 then Icon = " {rt2} "; end
					if GetRaidTargetIndex("target")==3 then Icon = " {rt3} "; end
					if GetRaidTargetIndex("target")==4 then Icon = " {rt4} "; end
					if GetRaidTargetIndex("target")==5 then Icon = " {rt5} "; end
					if GetRaidTargetIndex("target")==6 then Icon = " {rt6} "; end
					if GetRaidTargetIndex("target")==7 then Icon = " {rt7} "; end
					if GetRaidTargetIndex("target")==8 then Icon = " {rt8} "; end

					TBText = string.gsub(TBText, "$tn", Icon .. UnitName("target") .. Icon);
				else
					TBText = string.gsub(TBText, "$tn", "<no target>");
				end
				if (UnitLevel("target")<0) then
					TBText = string.gsub(TBText, "$tl", "??");
				else
					TBText = string.gsub(TBText, "$tl", UnitLevel("target"));
				end
				if (UnitCreatureType("target")) then
					TBText = string.gsub(TBText, "$tt", UnitCreatureType("target"));
				else
					TBText = string.gsub(TBText, "$tt", "Unknown");
				end
			end
		elseif (TBAbility == TB_GUI_SW) then
			TBText = string.gsub(TBSettings[TBSettingsCharRealm].Announcements[TBAbility]["Text"], "$sec", TB_GetSWDuration());
		elseif (TBAbility == TB_GUI_DW) then
			TBText = string.gsub(TBSettings[TBSettingsCharRealm].Announcements[TBAbility]["Text"], "$sec", "30");
		elseif (TBAbility == TB_GUI_LS) then
			TBText = string.gsub(TBSettings[TBSettingsCharRealm].Announcements[TBAbility]["Text"], "$sec", "20");
			TBText = string.gsub(TBSettings[TBSettingsCharRealm].Announcements[TBAbility]["Text"], "$hp", math.floor((UnitHealthMax("player")/130)*30));
		elseif (TBAbility == TB_GUI_LG) then
			TBText = string.gsub(TBSettings[TBSettingsCharRealm].Announcements[TBAbility]["Text"], "$sec", "20");
			TBText = string.gsub(TBSettings[TBSettingsCharRealm].Announcements[TBAbility]["Text"], "$hp", math.floor((UnitHealthMax("player")/115)*15));
		elseif (TBAbility == TB_GUI_CS or TBAbility == TB_GUI_CR) then
				TBText = string.gsub(TBSettings[TBSettingsCharRealm].Announcements[TBAbility]["Text"], "$sec", "6");
		end
		
		if (TBTest) then
			TBText = "TEST " .. TBText .. " TEST";
		end

		local TB_grp = TB_GUI_Alone;
		if  GetNumSubgroupMembers() > 0 then
			if (UnitInRaid("player")) then
				TB_grp = TB_GUI_Raid;
			elseif (UnitInParty("player")) then
				TB_grp = TB_GUI_Party;
			end
		end
		for i = 1, getn(TB_Channels), 1 do
			if (TBSettings[TBSettingsCharRealm].Announcements[TBAbility][TB_grp][TB_Channels[i][2]]) then
				-- Channel option: CTRAID --
				if (TB_Channels[i][3] == "MS ") then
					if (IsAddOnLoaded("CT_RaidAssist")) then
						CT_RA_AddMessage("MS " .. TBText);		-- Announcement in CT raid channel (if you can)
					end
				-- Channel option: CHANNEL --
				elseif (TB_Channels[i][3] == "CHANNEL") then
					local TB_CustChannels = TB_strsplit("%s+",TBSettings[TBSettingsCharRealm].Announcements[TBAbility][TB_grp].Channels);
					for j = 1, getn(TB_CustChannels), 1 do
						local TB_channelId, TB_channelName = GetChannelName(TB_CustChannels[j]);
						if (TB_channelId > 0) then						-- Checks if you are still in that channel
							SendChatMessage(TBText, "CHANNEL", nil, TB_channelId);
						end
					end
				-- Everything else --
				else
					SendChatMessage(TBText, TB_Channels[i][3]); -- Announcement in say, yell, party, raid or raid_warning channels
				end
			end
		end
	end
end

function TB_register()
	TankBuddyFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
end

function TB_unregister()
	TankBuddyFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
end

function TB_Sendmsg(msg)
	if(DEFAULT_CHAT_FRAME) then
		DEFAULT_CHAT_FRAME:AddMessage(msg, 0.0, 1.0, 0.0, 1.0);
	end	
end

function TB_GetSWDuration()
	--nameTalent, iconPath, tier, column, currentRank, maxRank, isExceptional, meetsPrereq = GetTalentInfo(tabIndex, talentIndex);
	local SW_dur = 10; --Default duration
	local _, _, _, _, currRank, _ = GetTalentInfo(3,13); --Get rank of Improved Shield Wall
	if (currRank == 1) then
		SW_dur = SW_dur + 3;						--Rank 1 gives 3 seconds extra
	elseif (currRank == 2) then
		SW_dur = SW_dur + 5;						--Rank 2 gives 5 seconds extra (total)
	end
	_, _, _, _, currRank, _ = GetTalentInfo(1,18);			--Get rank of Improved Disciplines (New in 2.0)
	if (currRank > 0) then
		SW_dur = SW_dur + (2*currRank);			--Each rank gives 2 seconds extra
	end
	return SW_dur;
end

function TB_toggleStatus()
	if (TBSettings[TBSettingsCharRealm].status == 0) then
		TBSettings[TBSettingsCharRealm].status = 1;
		TB_register();
	else
		TBSettings[TBSettingsCharRealm].status = 0;
		TB_unregister();
	end
end

function TB_SetCustomChannel(i)
	TB_CustomChannelFrame:Show();
	TB_ButtonCloseCustom:SetID(i);
	if (TBSettings[TBSettingsCharRealm].Announcements[TB_Tabs[TankBuddyFrame.selectedTab][1]][TB_Modes[i][2]].Channels) then
		TB_EditboxCustom:SetText(TBSettings[TBSettingsCharRealm].Announcements[TB_Tabs[TankBuddyFrame.selectedTab][1]][TB_Modes[i][2]].Channels);
	else
		TB_EditboxCustom:SetText("");
	end
end

function TB_CloseCustomChannel()
	TB_CustomChannelFrame:Hide();
	if (string.find(TB_EditboxCustom:GetText(), "(%w+)")) then
		TBSettings[TBSettingsCharRealm].Announcements[TB_Tabs[TankBuddyFrame.selectedTab][1]][TB_Modes[self:GetID()][2]].Channels = TB_EditboxCustom:GetText();
	end
end

function TB_Copy()
	TB_Clipboard = {};
	for i = 1, getn(TB_Modes), 1 do
		TB_Clipboard[TB_Modes[i][1]] = {};
		for j = 1, getn(TB_Channels), 1 do
			TB_Clipboard[TB_Modes[i][1]][TB_Channels[j][1]] = TBSettings[TBSettingsCharRealm].Announcements[TB_Tabs[TankBuddyFrame.selectedTab][1]][TB_Modes[i][2]][TB_Channels[j][2]];
		end
		TB_Clipboard[TB_Modes[i][1]]["Channels"] = TBSettings[TBSettingsCharRealm].Announcements[TB_Tabs[TankBuddyFrame.selectedTab][1]][TB_Modes[i][2]].Channels;
	end
	TB_ButtonPaste:Enable();
end

function TB_Paste()
	if(TB_Clipboard) then
		for i = 1, getn(TB_Modes), 1 do
			for j = 1, getn(TB_Channels), 1 do
				if (getglobal("TB_" .. TB_Modes[i][1] .. TB_Channels[j][1] .. "CheckButton")) then
					TBSettings[TBSettingsCharRealm].Announcements[TB_Tabs[TankBuddyFrame.selectedTab][1]][TB_Modes[i][2]][TB_Channels[j][2]] = TB_Clipboard[TB_Modes[i][1]][TB_Channels[j][1]];
				end
			end
			TBSettings[TBSettingsCharRealm].Announcements[TB_Tabs[TankBuddyFrame.selectedTab][1]][TB_Modes[i][2]].Channels = TB_Clipboard[TB_Modes[i][1]]["Channels"];
		end
	end
	TB_SetChannels();
end

function TB_Close()
	TankBuddyFrame:Hide();
	TB_Clipboard = nil;				--Empty clipboard to save memory
	TB_ButtonPaste:Disable();		--Disable paste-button since clipboard is empty
	if (TankBuddyFrame.selectedTab ~= 1) then
		TBSettings[TBSettingsCharRealm].Announcements[TB_Tabs[TankBuddyFrame.selectedTab][1]]["Text"] = TB_EditboxText:GetText();
	end
end

function TB_PlayerBuff(buff)
	local i = 1;
	local j = 0;
	while (UnitBuff("player", i) or UnitDebuff("player", i)) do
		if (UnitDebuff("player", i)) then
			j = j + 1;
		end
		if (UnitBuff("player", i)) then
			if (string.find(UnitBuff("player", i), buff)) then
				return i + j;
			end
		end
		i = i + 1;
	end
end

function TB_PlayerBuffByTexture(buff)
	local i, j = 0;
	if (not GetPlayerBuffTexture(i)) then
		i = 1;
	end
	while (GetPlayerBuffTexture(i)) do
		if (string.find(GetPlayerBuffTexture(i), buff)) then
			j = i;
		end
		i = i + 1;
	end
	if j then return j end
end

function TB_toggleMakeMeStupidStatus(self)
    TBSettings[TBSettingsCharRealm].MakeMeStupidStatus = self:GetChecked();
end

function TB_toggleSalvStatus(self)
	if (self:GetName() == "TB_EnableSalvationCheckButton") then
		TBSettings[TBSettingsCharRealm].Salvstatus = self:GetChecked();
		if (TBSettings[TBSettingsCharRealm].Salvstatus) then	--If you want salvation removed
			if (TB_TankForm) then		-- and you're a druid or a warrior
				TB_DefensiveBearCheckButton:Enable();
			end
		else
			TB_DefensiveBearCheckButton:Disable();
		end
	elseif (self:GetName() == "TB_DefensiveBearCheckButton") then
		TBSettings[TBSettingsCharRealm].SalvDefensiveBearstatus = self:GetChecked();
		if (TBSettings[TBSettingsCharRealm].SalvDefensiveBearstatus) then
			TankBuddyFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORMS");
		else
			TankBuddyFrame:UnregisterEvent("UPDATE_SHAPESHIFT_FORMS");
		end
	end
end
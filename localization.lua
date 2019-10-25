--
-- Localization file for Classic Tank Buddy v3.0.1
--

--
-- English by Artun Subasi, Kolthor and bjornenalfa
--

TB_version = "v3.0";

TB_GUI_EnableTankBuddy = "Enable Tank Buddy";
TB_GUI_Raid = "Raid";
TB_GUI_Party = "Party";
TB_GUI_Alone = "Alone";
TB_GUI_AnnouncementChannel = "Announcement Channel";
TB_GUI_AnnouncementTexts = "Announcement Texts";
TB_GUI_SetCustomChannel = "Set Custom Channel";
TB_GUI_EnterChannelName = "Enter channel name or number:";
TB_GUI_Close = "Close";
TB_GUI_Test = "Test";
TB_GUI_Copy = "Copy";
TB_GUI_Paste = "Paste";
TB_GUI_General = "General";
TB_GUI_Taunt = "Taunt";
TB_GUI_MB = "Mocking Blow";
TB_GUI_LS = "Last Stand";
TB_GUI_SW = "Shield Wall";
TB_GUI_DW = "Death Wish";
TB_GUI_LG = "Lifegiving Gem";
TB_GUI_CS = "Challenging Shout";
TB_GUI_Growl = "Growl";
TB_GUI_CR = "Challenging Roar";
TB_GUI_EnterNewText = {
	[TB_GUI_Taunt] = "Enter new announcement text for resisted taunts:",
	[TB_GUI_MB] = "Enter new announcement text for failed mocking blows:",
	[TB_GUI_LS] = "Enter new announcement text for using last stand:",
	[TB_GUI_SW] = "Enter new announcement text for using shield wall:",
	[TB_GUI_DW] = "Enter new announcement text for using death wish:",
	[TB_GUI_LG] = "Enter new announcement text for using lifegiving gem:",
  [TB_GUI_CS] = "Enter new announcement text for using challenging shout:",
	[TB_GUI_Growl] = "Enter new announcement text for resisted growls:",
  [TB_GUI_CR] = "Enter new announcement text for using challenging roar:"
}
TB_GUI_EnableSalvation = "Remove salvation.";
TB_GUI_EnableMakeMeStupid = "Remove int and spirit.";
TB_GUI_SalvationDefensive = "Only in defensive stance";
TB_GUI_SalvationBear = "Only in bear form";
TB_GUI_HelpText = "Thank you for using Tank Buddy, formerly known as Taunt Buddy.\nTaunt Buddy was originally created by Artun Subasi, but since he stopped development, Kolthor from Doomhammer EU took over.\n\nThis is a classic port by bjornenalfa of an extended version from sahne123 based on modifications from stesve. It announces raid icons on taunt resists and has an option for Death Wish.\n\nTo the right there are a number of tabs, depending on your class. Each tab has options for announcement message, and channels to announce to under given circumstances.\n\nHelp:\n\nThe leftmost column of checkboxes controls which channels to send the announcement message to, if you are in a raid. The middle column, if you are in a party, and the rightmost column, if you are alone.\nIf you check any of the \"Custom\"-boxes, a window will appear where you can type in the custom channel(s), either by channel name or number. To specify more than one channel, seperate with a space.\nWhen you have selected some channels, you can click the \"Copy\"-button to copy your selection, and then click another tab, and click the \"Paste\"-button to use the same selection there.\nNote! This will overwrite any custom channels you might have typed, with the ones from the copied source.\nYou can specify a message in the editbox at the bottom, and use the variables listed below:\n\nTaunt, Growl and Mocking Blow:\n$tn: Target Name (Same as %t)\n$tl: Target Level\n$tt: Target Type (Humanoid, Beast, Demon etc.)\n\nShield Wall, Last Stand and Lifegiving Gem:\n$sec: Duration of ability in seconds\n\nLast Stand and Lifegiving Gem:\n$hp: Amount of hitpoints gained by the ability.";

TB_GUI_Channel_Ctraid = "CTRaid";
TB_GUI_Channel_RaidWarning = "Raid Warning";
TB_GUI_Channel_Raid = "Raid";
TB_GUI_Channel_Party = "Party";
TB_GUI_Channel_Yell = "Yell";
TB_GUI_Channel_Say = "Say";
TB_GUI_Channel_Custom = "Custom";

TB_defaultText_g = "- My Growl has been resisted by $tn -";
TB_defaultText_t = "- My Taunt has been resisted by $tn -";
TB_defaultText_mb = "- My Mocking Blow failed against $tn -";
TB_defaultText_ls = "- I activated Last Stand! In 20 seconds I will lose $hpHP! -";
TB_defaultText_sw = "- I activated Shield Wall and will be taking 75% less damage for $sec seconds! -";
TB_defaultText_dw = "- I activated Death Wish and will be taking more damage for 30 seconds! -";
TB_defaultText_lg = "- I activated Lifegiving Gem! In 20 seconds I will lose $hpHP! -";
TB_defaultText_cs = "- I activated Challenging Shout! I will need a lot of healing for $sec seconds! -";
TB_defaultText_cr = "- I activated Challenging Roar! I will need a lot of healing for $sec seconds! -";

TB_tauntLine = "Your Taunt was resisted by (%w+)";
TB_tauntName = "Taunt"
TB_growlLine = "Your Growl was resisted by (%w+)";
TB_growlName = "Growl"
TB_mbHitLine = "Your Mocking Blow (.+) for (.+)";
TB_mbName = "Mocking Blow"
TB_mb = "(.*)Mocking Blow(.*)";
TB_ls = "You gain Last Stand.";
TB_lsName = "Last Stand"
TB_sw = "You gain Shield Wall.";
TB_swName = "Shield Wall"
TB_dw = "You are afflicted by Death Wish.";
TB_dwName = "Death Wish"
TB_lg = "You gain Gift of Life.";
TB_lgName = "Gift of Life" -- Guess
TB_csName = "Challenging Shout"
TB_crName = "Challenging Roar"
TB_salvation = "Salvation";
TB_intel = "You gain Intellect.";
TB_intel1 = "You gain Arcane Intellect.";
TB_intel2 = "You gain Arcane Brilliance.";
TB_spiritline = "You gain Spirit.";
TB_spiritline1 = "You gain Divine Spirit.";
TB_spiritline2 = "You gain Prayer of Spirit.";
TB_intellect = "MagicalSentry";
TB_intellect1 = "ArcaneIntellect";
TB_spirit = "BurningSpirit";
TB_spirit1 = "DivineSpirit";
TB_spirit2 = "PrayerofSpirit";

TB_output_salvation = "Salvation removed";
TB_output_intellect = "Removed Intellect.";
TB_output_spirit = "Removed Spirit.";
TB_output_startup = " loaded. Type /TB for options.";
TB_output_alreadyOff = "Tank Buddy is already disabled.";
TB_output_alreadyOn = "Tank Buddy is already enabled.";
TB_output_off = "Tank Buddy off.";
TB_output_on = "Tank Buddy on.";

TB_output_debug_off = "Tank Buddy debug off.";
TB_output_debug_on = "Tank Buddy debug on.";

TB_cmd_on = "on";
TB_cmd_off = "off";
TB_cmd_debug = "debug";
--[[
Title: CombatTutorial
Author(s): WangTian
Company: ParaEnging Co.
Date: 2011/8/22
use the lib:
------------------------------------------------------------
script/apps/Aries/Login/Tutorial/CombatTutorial.teen.lua
-- Added by Xizhi: F12 and testing only the movement part repeatedly without rebooting. 
local CombatTutorial = commonlib.gettable("MyCompany.Aries.Quest.NPCs.CombatTutorial");
CombatTutorial.BeginMovementTraining()

-- start from first tutorial
NPL.load("(gl)script/apps/Aries/Login/Tutorial/CombatTutorial.teen.lua", true);
MyCompany.Aries.Quest.NPCs.CombatTutorial.main();
------------------------------------------------------------
]]

NPL.load("(gl)script/apps/Aries/Quest/main.lua");
NPL.load("(gl)script/apps/Aries/Quest/NPC.lua");
NPL.load("(gl)script/apps/Aries/Combat/main.lua");
NPL.load("(gl)script/apps/Aries/Combat/MsgHandler.lua");
NPL.load("(gl)script/ide/UIAnim/UIAnimManager.lua");
NPL.load("(gl)script/apps/Aries/Desktop/GUIHelper/ArrowPointer.lua");
NPL.load("(gl)script/apps/Aries/Desktop/TargetArea.lua");
NPL.load("(gl)script/apps/Aries/Scene/AutoCameraController.lua");
NPL.load("(gl)script/apps/Aries/Desktop/Areas/BattleChatArea.lua");

local BattleChatArea = commonlib.gettable("MyCompany.Aries.Combat.UI.BattleChatArea");
local Quest = MyCompany.Aries.Quest;
local GameObject = MyCompany.Aries.Quest.GameObject;
local NPC = MyCompany.Aries.Quest.NPC;

local CombatTutorial = commonlib.gettable("MyCompany.Aries.Quest.NPCs.CombatTutorial");
-- whether to use key mouse movement tutorial, otherwise it will use pure mouse movement tutorial like before.  
CombatTutorial.bUseKeyMouseMovementTutorial = true;

local MsgHandler = commonlib.gettable("MyCompany.Aries.Combat.MsgHandler");

local ArrowPointer = commonlib.gettable("MyCompany.Aries.Desktop.GUIHelper.ArrowPointer");

local ItemManager = System.Item.ItemManager;
local hasGSItem = ItemManager.IfOwnGSItem;
local equipGSItem = ItemManager.IfEquipGSItem;



local dragon_position = {20024.52,2.07,20031.63}; -- {20053.48,2.02,20011.47};
local foster_position = {20053.48,-10000,20011.47};
local dragon_facing = -0.6; -- -1.6;
local dragon_scaling = 2.2;
local user_position = {20031.13,2.07,20037.56}; -- {20056.67,2.06,20018.16};
local user_facing = 2.6; -- 1.35;

local arena_position = {20055.33,2.37,20041.18};
local arena_position_str = "20055.33,2.37,20041.18";

local mob1_position = {20055.33,2.37,20041.18};
local mob1_facing = -2.170608997345;

local mob2_position = {20055.33,2.37,20041.18};
local mob2_facing = 2.0867621898651;

local init_camera_setting = {14.01,0.23,2.43};

local mob1_name = "蓝色噬灵鼠";
local mob2_name = "红色噬灵鼠";
local mob_asset = "character/v5/10mobs/HaqiTown/GreenDevouringRat/GreenDevouringRat.x";
local mob_asset_2 = "character/v5/10mobs/HaqiTown/RedDevouringRat/RedDevouringRat.x";
local mob_id_base = 51000;
local mob_level = 1;
local mob_scale = 1;

local user_nid = System.App.profiles.ProfileManager.GetNID();

local arena_id = 2001;




local function GetArenaValue(mob1_hp, mob2_hp, user_hp, mob1_pips, mob2_pips, user_pips, self_ward)
	return arena_id..",pve,"..arena_position_str..",1{[true,"..(mob_id_base+1)..",5,"..mob1_name..",fire,"..mob_asset..","..mob_scale..","..mob1_hp..",600,"..mob_level..",0,0#####][true,"..(mob_id_base+2)..",6,"..mob2_name..",fire,"..mob_asset_2..","..mob_scale..","..mob2_hp..",600,"..mob_level..",0,0#####]}{[false,"..user_nid..",1,life,"..user_hp..",300,1,0,0##"..(self_ward or "").."##][][][]}{0,0,0,0,0,0,0,0,}{0,0,0,0,0,0,0,0,}{}{}{}";
end

local empty_arena_value = arena_id..",pve,"..arena_position_str..",1{[true,"..(mob_id_base+1)..",5,"..mob1_name..",fire,"..mob_asset..","..mob_scale..",0,600,"..mob_level..",0,0#####][true,"..(mob_id_base+2)..",6,"..mob2_name..",fire,"..mob_asset_2..","..mob_scale..",0,600,"..mob_level..",0,0#####]}{[][][][]}{0,0,0,0,0,0,0,0,}{0,0,0,0,0,0,0,0,}{}{}{}";
local init_arena_value = arena_id..",pve,"..arena_position_str..",0{[true,"..(mob_id_base+1)..",5,"..mob1_name..",fire,"..mob_asset..","..mob_scale..",600,600,"..mob_level..",0,0#####][true,"..(mob_id_base+2)..",6,"..mob2_name..",fire,"..mob_asset_2..","..mob_scale..",0,600,"..mob_level..",0,0#####]}{[false,"..user_nid..",1,life,300,300,1,0,0####][][][]}{0,0,0,0,0,0,0,0,}{0,0,0,0,0,0,0,0,}{}{}{}";

local pre_round1_arena_value = GetArenaValue(600, 0, 300, 0, 0, 0);
local mid_round1_arena_value = GetArenaValue(260, 0, 300, 0, 0, 0);
local post_round1_arena_value = GetArenaValue(340, 0, 140, 0, 0, 0);

local pre_round2_arena_value = GetArenaValue(340, 0, 140, 0, 0, 0);
local mid_round2_arena_value = GetArenaValue(120, 0, 140, 0, 0, 0, 27);
local post_round2_arena_value = GetArenaValue(120, 0, 90, 0, 0, 0);

local pre_round3_arena_value = GetArenaValue(120, 0, 90, 0, 0, 0);
local mid_round3_arena_value = GetArenaValue(120, 0, 300, 0, 0, 0);
local post_round3_arena_value = GetArenaValue(120, 600, 300, 0, 0, 0);

local pre_round4_arena_value = GetArenaValue(120, 600, 300, 0, 0, 0);
local mid_round4_arena_value = GetArenaValue(0, 280, 300, 0, 0, 0);
local post_round4_arena_value = GetArenaValue(0, 280, 180, 0, 0, 0);

local pre_round5_arena_value = GetArenaValue(0, 280, 180, 0, 0, 0);
local mid_round5_arena_value = GetArenaValue(0, 0, 300, 0, 0, 0);
local post_round5_arena_value = GetArenaValue(0, 0, 300, 0, 0, 0);

local stage = -1;

local callback_finished = nil;

-- CombatTutorial.main
-- main entrance of the tutorial line
function CombatTutorial.main(callback)
	-- keep callback reference
	callback_finished = callback;

	MyCompany.Aries.Pet.Init();
	--AudioEngine.CreateGet("Area_SunnyBeach"):play();

	-- start UI animation framework.
	NPL.load("(gl)script/ide/UIAnim/UIAnimManager.lua");
	UIAnimManager.Init();
	ArrowPointer.Init();
	NPL.load("(gl)script/apps/Aries/Desktop/EXPArea.lua");
	MyCompany.Aries.Desktop.EXPArea.Init();
	
	NPL.load("(gl)script/kids/3DMapSystemUI/Desktop/autotips.lua");
	autotips.Show(false);

	
	-- hide all desktop areas
	MyCompany.Aries.Desktop.HideAllAreas();
	-- show exp and hp bar
	NPL.load("(gl)script/apps/Aries/Desktop/EXPArea.lua");
	MyCompany.Aries.Desktop.EXPArea.Show(false);
	
	local Pet = commonlib.gettable("MyCompany.Aries.Pet");
	local player
	if(Pet.GetRealPlayer) then
		player = Pet.GetRealPlayer();
	else
		player = ParaScene.GetPlayer();
	end

	UIAnimManager.PlayCustomAnimation(1000, function(elapsedTime)
		if(elapsedTime == 1000) then
			local ItemManager = System.Item.ItemManager;
			ItemManager.RefreshMyself();
		end
	end);

	-- set init user position and facing
	player:SetPosition(user_position[1], user_position[2], user_position[3]);
	player:SetFacing(user_facing);

	if(MyCompany.Aries.Tutorial.CombatTutorialMain.skip_combat_tutorial) then
		player:SetFacing(user_facing+3.14);
		player:SetPosition(20057.56,2.08,20043.65);
		-- block user input
		ParaScene.GetAttributeObject():SetField("BlockInput", true);
		ParaCamera.GetAttributeObject():SetField("BlockInput", true);
		CombatTutorial.main_cont();
	else
		-- init dragon npc
		local params = {
			position = dragon_position,
			assetfile_char = "character/v6/01human/MagicMentor_Lendi/MagicMentor_Lendi.x",
			facing = dragon_facing,
			scaling = dragon_scaling,
			isdummy = true,
			main_script = "script/apps/Aries/Login/Tutorial/CombatTutorial.teen.lua",
			main_function = "MyCompany.Aries.Quest.NPCs.CombatTutorial.main_dragon();",
			selected_page = "script/apps/Aries/Desktop/SelectionResponse/CommonNPC_Empty.html",
			predialog_function = "MyCompany.Aries.Quest.NPCs.CombatTutorial.PreDialog_dragon",
		};
		NPC.CreateNPCCharacter(39002, params);

		-- init dragon npc
		local params = {
			position = foster_position,
			assetfile_char = "character/v5/01human/CaptainFoster/CaptainFoster.x",
			facing = dragon_facing,
			scaling = 3,
			isdummy = true,
		};
		NPC.CreateNPCCharacter(39003, params);
	
		--使用新的动画格式
		NPL.load("(gl)script/ide/MotionEx/MotionXmlToTable.lua");
		local MotionXmlToTable = commonlib.gettable("MotionEx.MotionXmlToTable");
		MotionXmlToTable.Play("config/Aries/StaticMovies/AriesTutorialTeen_Show.xml",1,nil,function()
			CombatTutorial.main_cont();
		end)

		-- block user input
		ParaScene.GetAttributeObject():SetField("BlockInput", false);
		ParaCamera.GetAttributeObject():SetField("BlockInput", false);
	end
end

function CombatTutorial.main_dragon()
end
function CombatTutorial.PreDialog_dragon()
	UIAnimManager.PlayCustomAnimation(50, function(elapsedTime)
		if(elapsedTime == 50) then
			--CombatTutorial.main_cont2();
			
			-- NOTE 2012/10/16: directly goto pip tutorial
			if(callback_pip_tutorial) then
				callback_pip_tutorial();
				callback_pip_tutorial = nil;
			end
		end
	end);
	--kill timer
	if(CombatTutorial.arrow_timer) then
		CombatTutorial.arrow_timer:Change();
	end

	-- stop a special dragon ogg audio
	local asset_file = "Audio/Haqi/CombatTutorialTeen/BasicInstructions_6.ogg";
	if(asset_file) then
		local audio_src = AudioEngine.CreateGet(asset_file)
		audio_src.file = asset_file;
		audio_src:stop(); -- stop
		audio_src:release();
	end

	return false;
end

function CombatTutorial.StartTalkToDragonHook()
	NPL.load("(gl)script/apps/Aries/Desktop/TargetArea.lua");
	MyCompany.Aries.Desktop.TargetArea.Init();
	MyCompany.Aries.Desktop.TargetArea.Show(true);
	
	CombatTutorial.arrow_timer = CombatTutorial.arrow_timer or commonlib.Timer:new({callbackFunc = function()
		local npcChar = NPC.GetNpcCharacterFromIDAndInstance(39002);
		if(npcChar and npcChar:IsValid()) then
			-- and the arrow pointer
			local fromX, fromY, fromZ = ParaScene.GetPlayer():GetPosition();
			fromY = fromY + 1;
			local toX, toY, toZ = npcChar:GetPosition();
			toY = toY + 1;
			local asset = ParaAsset.LoadParaX("", "character/common/pointer/pointer.x");
			ParaScene.FireMissile(asset, 10, fromX, fromY, fromZ, toX, toY, toZ);
		end
	end});
	CombatTutorial.arrow_timer:Change(200, 200);
end

function CombatTutorial.main_cont()
	if(MyCompany.Aries.Tutorial.CombatTutorialMain.skip_combat_tutorial) then
		--ParaCamera.SetLookAtPos(user_position[1], user_position[2] + 2, user_position[3])
		ParaCamera.SetLookAtPos(20057.56, 4.08, 20043.65);
		-- set init camera position
		local att = ParaCamera.GetAttributeObject();
		local temp_init_camera_setting = {14.01,0.33,-0.68};
		att:SetField("CameraObjectDistance", temp_init_camera_setting[1]);
		att:SetField("CameraLiftupAngle", temp_init_camera_setting[2]);
		att:SetField("CameraRotY", temp_init_camera_setting[3]);

		-- init state machine
		stage = 20;
		CombatTutorial.ProcessNextStage();
	else
		local Pet = commonlib.gettable("MyCompany.Aries.Pet");
		local player
		if(Pet.GetRealPlayer) then
			player = Pet.GetRealPlayer();
		else
			player = ParaScene.GetPlayer();
		end

		-- set init user position and facing
		player:SetPosition(user_position[1], user_position[2], user_position[3]);
		player:SetFacing(user_facing);

		ParaCamera.SetLookAtPos(user_position[1], user_position[2] + 2, user_position[3])
	
		-- set init camera position
		local att = ParaCamera.GetAttributeObject();
		att:SetField("CameraObjectDistance", init_camera_setting[1]);
		att:SetField("CameraLiftupAngle", init_camera_setting[2]);
		att:SetField("CameraRotY", init_camera_setting[3]);
	
		-- init state machine
		stage = -1;
	
		ParaScene.GetAttributeObject():SetField("BlockInput", true);
		ParaCamera.GetAttributeObject():SetField("BlockInput", true);
	
		CombatTutorial.ShowDialog("script/apps/Aries/Login/Tutorial/CombatTutorial_dialog.teen.html?start_state=19");
	end
end

-- by LiXizhi: begin the movement tutorial page
function CombatTutorial.BeginMovementTraining()
	ParaScene.GetAttributeObject():SetField("BlockInput", false);
	ParaCamera.GetAttributeObject():SetField("BlockInput", false);
	
	local nid_str = tostring(System.App.profiles.ProfileManager.GetNID());
	local avatar = ParaScene.GetCharacter(nid_str);
	if(avatar and avatar:IsValid()) then
		avatar:ToCharacter():SetFocus();
	end

	-- hide all desktop areas
	MyCompany.Aries.Desktop.HideAllAreas();

	CombatTutorial.ShowDialog("script/apps/Aries/Login/Tutorial/CombatTutorial_movement.teen.html", 50);
		
	MyCompany.Aries.AutoCameraController:Init();
	MyCompany.Aries.AutoCameraController:MakeEnable(true); 
end

-- by LiXizhi: end the movement tutorial page
function CombatTutorial.EndMovementTraining()
	if(CombatTutorial.bUseKeyMouseMovementTutorial) then
		local Desktop = MyCompany.Aries.Desktop;
		Desktop.GUIHelper.ArrowPointer.HideAllArrows();
		MyCompany.Aries.AutoCameraController:MakeEnable(false); 
	end
	
	CommonCtrl.os.hook.UnhookWindowsHook({hookName="MouseTutorial.OnKeyHook", hookType = CommonCtrl.os.hook.HookType.WH_CALLWNDPROC})
end

-- set callback_finished
function CombatTutorial.Set_callback_pip_tutorial(func)
	callback_pip_tutorial = func;
end

-- call this function to skip the tutorial.
function CombatTutorial.SkipTutorial()
	local text = "你确定要跳过新手教程么？";
	if(System.options.IsMobilePlatform) then
		text = text.."如果没有键盘, 可以直接跳过本教程";
	end
	_guihelper.MessageBox(text, function(res)
		if(res and res == _guihelper.DialogResult.Yes) then
			CombatTutorial.EndMovementTraining();
			CombatTutorial.ShowDialog();
			CombatTutorial.PreDialog_dragon();
		end
	end, _guihelper.MessageBoxButtons.YesNo);
end

function CombatTutorial.SkipCombatTutorial_imp()
	CombatTutorial.EndMovementTraining();
	CombatTutorial.ShowDialog();
	stage = 20;
	CombatTutorial.ProcessNextStage()
end

function CombatTutorial.SkipCombatTutorial()
	_guihelper.MessageBox("精彩的战斗教程即将开始，青龙将介绍每个系别魔法卡牌的使用. 你确定要跳过战斗教学么？", function(res)
		if(res and res == _guihelper.DialogResult.Yes) then
			CombatTutorial.SkipCombatTutorial_imp();
		end
	end, _guihelper.MessageBoxButtons.YesNo);
end


function CombatTutorial.main_cont2()

	-- init dragon npc
	local params = {
		position = mob1_position,
		assetfile_char = mob_asset,
		facing = mob1_facing,
		scaling = 1,
		isdummy = true,
	};
	local ratChar = NPC.CreateNPCCharacter(30563, params);
	if(ratChar and ratChar:IsValid()) then
		ratChar:SetVisible(false);
	end

	ParaScene.GetAttributeObject():SetField("BlockInput", true);
	ParaCamera.GetAttributeObject():SetField("BlockInput", true);
	-- start
	CombatTutorial.Start();
end

-- start the tutorial line
function CombatTutorial.Start()
	-- NPL.load("(gl)script/apps/Aries/Pet/main.lua");
	
	-- confirm the ccs string
	local ItemManager = System.Item.ItemManager;
	ItemManager.RefreshMyself();

	
	if(MyCompany.Aries.Tutorial.CombatTutorialMain.skip_combat_tutorial) then
		CombatTutorial.SkipCombatTutorial_imp();
	else
		-- show the dialog
		CombatTutorial.ShowDialog("script/apps/Aries/Login/Tutorial/CombatTutorial_dialog.teen.html");
	end
	
	NPL.load("(gl)script/apps/Aries/Desktop/EXPArea.lua");
	MyCompany.Aries.Desktop.EXPArea.Show(false);
	MyCompany.Aries.Desktop.EXPArea.LockShow();
	-- lock user input
	ParaScene.GetAttributeObject():SetField("BlockInput", true);
	ParaCamera.GetAttributeObject():SetField("BlockInput", true);
end

-- finish the tutorial line
function CombatTutorial.Finish()
	stage = -1;
	NPL.load("(gl)script/apps/Aries/Desktop/EXPArea.lua");
	MyCompany.Aries.Desktop.EXPArea.UnlockShow();
	ParaScene.GetAttributeObject():SetField("BlockInput", false);
	ParaCamera.GetAttributeObject():SetField("BlockInput", false);
	
	--AudioEngine.CreateGet("Area_FireCavern"):stop();
	
	-- this fixed a bug that auto camera is disabled.
	MyCompany.Aries.AutoCameraController:MakeEnable(true);

	-- show all desktop areas
	MyCompany.Aries.Desktop.ShowAllAreas();

	if(callback_finished) then
		callback_finished();
		callback_finished = nil;
	end
end

-- is in combat tutorial
function CombatTutorial.IsInTutorial()
	return (stage >= 0);
end

local audio_state_mapping = {
	[1] = "Audio/Haqi/CombatTutorial/Dialog_state1.ogg",
	[2] = "Audio/Haqi/CombatTutorial/Dialog_state2.ogg",
	[3] = "Audio/Haqi/CombatTutorial/Dialog_state3.ogg",
	[4] = "Audio/Haqi/CombatTutorial/Dialog_state4.ogg",
	[5] = "Audio/Haqi/CombatTutorial/Dialog_state5.ogg",
	[6] = "Audio/Haqi/CombatTutorial/Dialog_state6.ogg",
	[7] = "Audio/Haqi/CombatTutorial/Dialog_state7.ogg",
	[8] = "Audio/Haqi/CombatTutorial/Dialog_state8.ogg",
	[9] = "Audio/Haqi/CombatTutorial/Dialog_state9.ogg",
	[10] = "Audio/Haqi/CombatTutorial/Dialog_state10.ogg",
	[11] = "Audio/Haqi/CombatTutorial/Dialog_state11.ogg",
	[12] = "Audio/Haqi/CombatTutorial/Dialog_state12.ogg",
	[13] = nil,
	[14] = "Audio/Haqi/CombatTutorial/Dialog_state14.ogg",
	[15] = "Audio/Haqi/CombatTutorial/Dialog_state15.ogg",
	[16] = "Audio/Haqi/CombatTutorial/Dialog_state16.ogg",
	[17] = "Audio/Haqi/CombatTutorial/Dialog_state17.ogg",
	[19] = "Audio/Haqi/CombatTutorial/Dialog_state19.ogg",
};
function CombatTutorial.PlayDialogAudio(state)
	local asset_file = audio_state_mapping[state];
	if(asset_file) then
		local audio_src = AudioEngine.CreateGet(asset_file)
		audio_src.file = asset_file;
		audio_src:play(); -- then play with default. 
	end
end
function CombatTutorial.StopDialogAudio(state)
	local asset_file = audio_state_mapping[state];
	if(asset_file) then
		local audio_src = AudioEngine.CreateGet(asset_file)
		audio_src.file = asset_file;
		audio_src:stop(); -- then play with default. 
		audio_src:release();
	end
end

-- CombatTutorial.ProcessNextStage
-- on each stage finish proceed to the next stage
-- NOTE: it passes all params to the stage handler
-- NOTE: each stage handles all assets need cleaned or created
function CombatTutorial.ProcessNextStage(...)
	stage = stage + 1;

	if(CombatTutorial["Handler_Stage"..stage]) then
		CombatTutorial["Handler_Stage"..stage](...)
	else
		-- finish if no tutorial stage is available
		CombatTutorial.Finish();
	end
end

function CombatTutorial.ShowTip(url)
	-- show the dialog
	System.App.Commands.Call("File.MCMLWindowFrame", {
		url = url, 
		name = "Tutorial_Tip", 
		app_key = (MyCompany.Aries.app or MyCompany.Taurus.app).app_key, 
		isShowTitleBar = false,
		--refresh = true,
		refreshEvenSameURLIfFrameExist = true,
		allowDrag = false,
		style = CommonCtrl.WindowFrame.ContainerStyle,
		zorder = 100,
		isTopLevel = false,
		directPosition = true,
			align = "_ct",
			x = -480,					
			y = 30,
			width = 960,
			height = 230,
					
		DestroyOnClose = true,
		cancelShowAnimation = true,
	});
end

function CombatTutorial.HideTip()
	-- show the dialog
	System.App.Commands.Call("File.MCMLWindowFrame", {
		url = url, 
		name = "Tutorial_Tip", 
		app_key = (MyCompany.Aries.app or MyCompany.Taurus.app).app_key, 
		bShow = false,
	});
end

-- @param url: 
-- @param delay_time: the number of milliseconds to delay
function CombatTutorial.ShowDialog(url, delay_time)
	if(delay_time) then
		UIAnimManager.PlayCustomAnimation(delay_time, function(elapsedTime)
			if(elapsedTime == delay_time) then
				CombatTutorial.ShowDialog(url);
			end
		end);
	end
	if(url) then
		-- show the dialog
		System.App.Commands.Call("File.MCMLWindowFrame", {
			url = url, 
			name = "Tutorial_Dialog", 
			app_key = (MyCompany.Aries.app or MyCompany.Taurus.app).app_key, 
			isShowTitleBar = false,
			--refresh = true,
			refreshEvenSameURLIfFrameExist = true,
			allowDrag = false,
			style = CommonCtrl.WindowFrame.ContainerStyle,
			zorder = 2,
			directPosition = true,
				align = "_mb",
				x = 0,
				y = 0,
				width = 0,
				height = 135,
					
			DestroyOnClose = true,
			cancelShowAnimation = true,
		});
	else
		System.App.Commands.Call("File.MCMLWindowFrame", {name="Tutorial_Dialog", 
			app_key = MyCompany.Aries.app.app_key, 
			bShow = false,bDestroy = true,});
	end
end

-- handler stage 0
function CombatTutorial.Handler_Stage0(...)
	-- show the dialog
	-- wait till 3 seconds to proceed next step
	UIAnimManager.PlayCustomAnimation(50, function(elapsedTime)
		if(elapsedTime == 50) then
			CombatTutorial.ShowDialog("script/apps/Aries/Login/Tutorial/CombatTutorial_dialog.teen.html?npc_id=30563&start_state=6");
		end
	end);
end

-- handler stage 1: init fight and show HP potion intro dialog
function CombatTutorial.Handler_Stage1(...)
	--ParaScene.GetAttributeObject():SetField("BlockInput", false);
	--ParaCamera.GetAttributeObject():SetField("BlockInput", false);
	
	-- delete stub npc
	NPC.DeleteNPCCharacter(30563);
	
	AudioEngine.CreateGet("Area_SunnyBeach"):stop();
	--AudioEngine.CreateGet("Area_FireCavern"):play();
	MsgHandler.OnArenaNormalUpdate_by_key_value("arena_"..arena_id, init_arena_value);
	
	
	NPL.load("(gl)script/apps/Aries/Desktop/EXPArea.lua");
	MyCompany.Aries.Desktop.EXPArea.Show(false);
	
	-- wait till 3 seconds to proceed next step
	UIAnimManager.PlayCustomAnimation(3000, function(elapsedTime)
		if(elapsedTime == 3000) then
			NPL.load("(gl)script/apps/Aries/Desktop/EXPArea.lua");
			MyCompany.Aries.Desktop.EXPArea.Show(false);
			CombatTutorial.ProcessNextStage();
		end
	end);
end

-- handler stage 3: show the round 1 card picker and tip
function CombatTutorial.Handler_Stage2(...)
	-- card picker handler
	MsgHandler.OnShowPick(1, "pve", 0, false, "false,"..tostring(user_nid)..";", "true,"..tostring(mob_id_base + 1)..";", "1+true+0+Storm_SingleAttack_Level6+1", nil, "", "", "", function()
		-- wait till 0.5 seconds to proceed next step
		UIAnimManager.PlayCustomAnimation(500, function(elapsedTime)
			if(elapsedTime == 500) then
				-- process next stage
				CombatTutorial.ProcessNextStage(); -- continute to stage 5, stage 4 in an immediate process
				CombatTutorial.ProcessNextStage(); -- continute to stage 5, stage 4 in an immediate process
			end
		end);
		-- to stop the network traffic
		return false;
	end, nil, function()
		CombatTutorial.HideTip();
	end);
	MsgHandler.OnArenaNormalUpdate_by_key_value("arena_"..arena_id, pre_round1_arena_value);
	CombatTutorial.ShowTip("script/apps/Aries/Login/Tutorial/CombatTutorial_dialog.teen.html?start_state=8");
	ArrowPointer.ShowArrow(9842, 2, "_ct", -360, -180, 64, 64);
end

-- handler stage 4: show the round 1 card picker arrow
function CombatTutorial.Handler_Stage3(...)
	--ArrowPointer.ShowArrow(9842, 2, "_ct", -360, -180, 64, 64);


	-- TODO: 鼠标左键点击卡片，就可以发动这个魔法

	---- wait till 2 seconds to hide the arrow
	--UIAnimManager.PlayCustomAnimation(2000, function(elapsedTime)
		--if(elapsedTime == 2000) then
			---- hide arrow
			--ArrowPointer.HideArrow(9842);
		--end
	--end);
end

-- handler stage 5: play round 1
function CombatTutorial.Handler_Stage4(...)
	local value = "1?"..user_nid..",?";
	local sequence = {
		"update_arena:arena_"..arena_id.."+"..pre_round1_arena_value,
		"movearrow:"..arena_id.."+1+1",
		"Storm_SingleAttack_Level6:Storm_SingleAttack_Level6,"..arena_id..",1,false,"..user_nid..",1,true,"..(mob_id_base + 1)..",5,340,0########",
		"update_arena:arena_"..arena_id.."+"..mid_round1_arena_value,
		"movearrow:"..arena_id.."+1+5",
		"speak:"..arena_id..",true,"..(mob_id_base + 1).."[哎哟，不错嘛，有两下子！]";
		"Death_SingleAttackWithLifeTap_Level2:Death_SingleAttackWithLifeTap_Level2,"..arena_id..",5,true,"..(mob_id_base + 1)..",5,false,"..user_nid..",1,160,80########",
		"update_arena:arena_"..arena_id.."+"..post_round1_arena_value,
	};
	local _, seq;
	for _, seq in ipairs(sequence) do
		value = value.."<"..seq..">";
	end
	
	MsgHandler.OnPlayTurn(value, function()
		--ArrowPointer.ShowArrow(9841, 2, "_lb", 14, -290, 64, 64);
		CombatTutorial.ShowTip("script/apps/Aries/Login/Tutorial/CombatTutorial_dialog.teen.html?start_state=7");
		-- process next stage
		--CombatTutorial.ProcessNextStage(); -- continute to stage 5, stage 4 in an immediate process
		-- to stop the network traffic
		return false;
	end);
end

-- handler stage 2: hide the HP potion pointer
function CombatTutorial.Handler_Stage5(...)
	-- hide arrow
	ArrowPointer.HideArrow(9841);
	-- wait till 0.5 seconds to proceed next step
	UIAnimManager.PlayCustomAnimation(50, function(elapsedTime)
		if(elapsedTime == 50) then
			-- process next stage
			CombatTutorial.ProcessNextStage();
		end
	end);
end

-- handler stage 6: show the round 2 card picker and tip
function CombatTutorial.Handler_Stage6(...)
	-- card picker handler
	MsgHandler.OnShowPick(2, "pve", 0, false, "false,"..tostring(user_nid)..";", "true,"..tostring(mob_id_base + 1)..";", "1+true+0+Ice_GlobalShield+1", nil, "", "", "", function()
		-- wait till 0.5 seconds to proceed next step
		UIAnimManager.PlayCustomAnimation(500, function(elapsedTime)
			if(elapsedTime == 500) then
				-- process next stage
				CombatTutorial.ProcessNextStage(); -- continute to stage 5, stage 4 in an immediate process
				CombatTutorial.ProcessNextStage(); -- continute to stage 5, stage 4 in an immediate process
			end
		end);
		-- to stop the network traffic
		return false;
	end, nil, function()
		CombatTutorial.HideTip();
	end);
	MsgHandler.OnArenaNormalUpdate_by_key_value("arena_"..arena_id, pre_round2_arena_value);
	CombatTutorial.ShowTip("script/apps/Aries/Login/Tutorial/CombatTutorial_dialog.teen.html?start_state=9");
	ArrowPointer.ShowArrow(9842, 2, "_ct", -360, -180, 64, 64);
end

-- handler stage 7: show the round 2 card picker arrow
function CombatTutorial.Handler_Stage7(...)
	--ArrowPointer.ShowArrow(9842, 2, "_ct", -360, -180, 64, 64);

	---- wait till 2 seconds to hide the arrow
	--UIAnimManager.PlayCustomAnimation(2000, function(elapsedTime)
		--if(elapsedTime == 2000) then
			---- hide arrow
			--ArrowPointer.HideArrow(9842);
		--end
	--end);
end

-- handler stage 8: play round 2
function CombatTutorial.Handler_Stage8(...)
	local value = "2?"..user_nid..",?";
	local sequence = {
		"update_arena:arena_"..arena_id.."+"..pre_round2_arena_value,
		"movearrow:"..arena_id.."+1+1",
		"Ice_GlobalShield:Ice_GlobalShield,"..arena_id..",1,false,"..user_nid..",1,false,"..user_nid..",1,0,0######27##",
		"update_arena:arena_"..arena_id.."+"..mid_round2_arena_value,
		"movearrow:"..arena_id.."+1+5",
		"speak:"..arena_id..",true,"..(mob_id_base + 1).."[哎呦，好疼啊，该我了！]";
		"Fire_SingleAttack_Level3:Fire_SingleAttack_Level3,"..arena_id..",5,true,"..(mob_id_base + 1)..",5,false,"..user_nid..",1,50,0########",
		"update_arena:arena_"..arena_id.."+"..post_round2_arena_value,
	};
	local _, seq;
	for _, seq in ipairs(sequence) do
		value = value.."<"..seq..">";
	end
	
	MsgHandler.OnPlayTurn(value, function()
		-- process next stage
		CombatTutorial.ProcessNextStage(); -- continute to stage 5, stage 4 in an immediate process
		-- to stop the network traffic
		return false;
	end);
end

-- handler stage 9: show the round 3 card picker and tip
function CombatTutorial.Handler_Stage9(...)
	-- card picker handler
	MsgHandler.OnShowPick(3, "pve", 0, false, "false,"..tostring(user_nid)..";", "true,"..tostring(mob_id_base + 1)..";", "1+true+0+Life_SingleHeal_LevelX+1", nil, "", "", "", function()
		-- wait till 0.5 seconds to proceed next step
		UIAnimManager.PlayCustomAnimation(500, function(elapsedTime)
			if(elapsedTime == 500) then
				-- process next stage
				CombatTutorial.ProcessNextStage(); -- continute to stage 5, stage 4 in an immediate process
				CombatTutorial.ProcessNextStage(); -- continute to stage 5, stage 4 in an immediate process
			end
		end);
		-- to stop the network traffic
		return false;
	end, nil, function()
		CombatTutorial.HideTip();
	end);
	MsgHandler.OnArenaNormalUpdate_by_key_value("arena_"..arena_id, pre_round3_arena_value);
	CombatTutorial.ShowTip("script/apps/Aries/Login/Tutorial/CombatTutorial_dialog.teen.html?start_state=10");
	ArrowPointer.ShowArrow(9842, 2, "_ct", -360, -180, 64, 64);
end

-- handler stage 10: show the round 3 card picker arrow
function CombatTutorial.Handler_Stage10(...)
	--ArrowPointer.ShowArrow(9842, 2, "_ct", -360, -180, 64, 64);

	---- wait till 2 seconds to hide the arrow
	--UIAnimManager.PlayCustomAnimation(2000, function(elapsedTime)
		--if(elapsedTime == 2000) then
			---- hide arrow
			--ArrowPointer.HideArrow(9842);
		--end
	--end);
end

-- handler stage 11: play round 3
function CombatTutorial.Handler_Stage11(...)
	local value = "3?"..user_nid..",?";
	local sequence = {
		"update_arena:arena_"..arena_id.."+"..pre_round3_arena_value,
		"movearrow:"..arena_id.."+1+1",
		"Life_SingleHeal_LevelX:Life_SingleHeal_LevelX,"..arena_id..",1,false,"..user_nid..",1,false,"..user_nid..",1,400,0########",
		"update_arena:arena_"..arena_id.."+"..mid_round3_arena_value,
		"movearrow:"..arena_id.."+1+5",
		"fizzle:"..arena_id..",5,true,"..(mob_id_base + 1)..",5,false,"..user_nid..",1,ice",
		"speak:"..arena_id..",true,"..(mob_id_base + 1).."[该死，居然发招失败！大哥，快来帮我！]";
		"update_arena:arena_"..arena_id.."+"..post_round3_arena_value,
	};
	local _, seq;
	for _, seq in ipairs(sequence) do
		value = value.."<"..seq..">";
	end
	
	MsgHandler.OnPlayTurn(value, function()
		UIAnimManager.PlayCustomAnimation(3000, function(elapsedTime)
			if(elapsedTime == 3000) then
				-- process next stage
				CombatTutorial.ProcessNextStage(); -- continute to stage 5, stage 4 in an immediate process
			end
		end);
		-- to stop the network traffic
		return false;
	end);
end

-- handler stage 12: show the round 4 card picker and tip
function CombatTutorial.Handler_Stage12(...)
	-- card picker handler
	MsgHandler.OnShowPick(4, "pve", 0, false, "false,"..tostring(user_nid)..";", "true,"..tostring(mob_id_base + 1)..";", "1+true+0+Fire_AreaAttack_Level4+1", nil, "", "", "", function()
		-- wait till 0.5 seconds to proceed next step
		UIAnimManager.PlayCustomAnimation(500, function(elapsedTime)
			if(elapsedTime == 500) then
				-- process next stage
				CombatTutorial.ProcessNextStage(); -- continute to stage 5, stage 4 in an immediate process
				CombatTutorial.ProcessNextStage(); -- continute to stage 5, stage 4 in an immediate process
			end
		end);
		-- to stop the network traffic
		return false;
	end, nil, function()
		CombatTutorial.HideTip();
	end);
	MsgHandler.OnArenaNormalUpdate_by_key_value("arena_"..arena_id, pre_round4_arena_value);
	CombatTutorial.ShowTip("script/apps/Aries/Login/Tutorial/CombatTutorial_dialog.teen.html?start_state=11");
	ArrowPointer.ShowArrow(9842, 2, "_ct", -360, -180, 64, 64);
end

-- handler stage 13: show the round 4 card picker arrow
function CombatTutorial.Handler_Stage13(...)
	--ArrowPointer.ShowArrow(9842, 2, "_ct", -360, -180, 64, 64);

	---- wait till 2 seconds to hide the arrow
	--UIAnimManager.PlayCustomAnimation(2000, function(elapsedTime)
		--if(elapsedTime == 2000) then
			---- hide arrow
			--ArrowPointer.HideArrow(9842);
		--end
	--end);
end

-- handler stage 14: play round 4
function CombatTutorial.Handler_Stage14(...)
	local value = "4?"..user_nid..",?";
	local sequence = {
		"update_arena:arena_"..arena_id.."+"..pre_round4_arena_value,
		"movearrow:"..arena_id.."+1+1",
		"Fire_AreaAttack_Level4:Fire_AreaAttack_Level4,"..arena_id..",1,false,"..user_nid.."+++(true,"..(mob_id_base + 1)..",5,320######)(true,"..(mob_id_base + 2)..",5,320######)",
		"dead:"..arena_id..",5,true,"..(mob_id_base + 1),
		"update_arena:arena_"..arena_id.."+"..mid_round4_arena_value,
		"movearrow:"..arena_id.."+1+6",
		"speak:"..arena_id..",true,"..(mob_id_base + 2).."[我的老弟啊，我要为你报仇！]";
		"Storm_SingleAttack_Level4:Storm_SingleAttack_Level4,"..arena_id..",6,true,"..(mob_id_base + 2)..",6,false,"..user_nid..",1,120,0########",
		"update_arena:arena_"..arena_id.."+"..post_round4_arena_value,
	};
	local _, seq;
	for _, seq in ipairs(sequence) do
		value = value.."<"..seq..">";
	end
	
	MsgHandler.OnPlayTurn(value, function()
		-- process next stage
		CombatTutorial.ProcessNextStage(); -- continute to stage 5, stage 4 in an immediate process
		-- to stop the network traffic
		return false;
	end);
end

-- handler stage 15: show the round 5 card picker and tip
function CombatTutorial.Handler_Stage15(...)
	-- card picker handler
	MsgHandler.OnShowPick(5, "pve", 0, false, "false,"..tostring(user_nid)..";", "true,"..tostring(mob_id_base + 2)..";", "1+true+0+Death_SingleAttackWithLifeTap_Level6+1", nil, "", "", "", function()
		-- wait till 0.5 seconds to proceed next step
		UIAnimManager.PlayCustomAnimation(500, function(elapsedTime)
			if(elapsedTime == 500) then
				-- process next stage
				CombatTutorial.ProcessNextStage(); -- continute to stage 5, stage 4 in an immediate process
				CombatTutorial.ProcessNextStage(); -- continute to stage 5, stage 4 in an immediate process
			end
		end);
		-- to stop the network traffic
		return false;
	end, nil, function()
		CombatTutorial.HideTip();
	end);
	MsgHandler.OnArenaNormalUpdate_by_key_value("arena_"..arena_id, pre_round5_arena_value);
	CombatTutorial.ShowTip("script/apps/Aries/Login/Tutorial/CombatTutorial_dialog.teen.html?start_state=12");
	ArrowPointer.ShowArrow(9842, 2, "_ct", -360, -180, 64, 64);
end

-- handler stage 16: show the round 5 card picker arrow
function CombatTutorial.Handler_Stage16(...)
	--ArrowPointer.ShowArrow(9842, 2, "_ct", -360, -180, 64, 64);

	---- wait till 2 seconds to hide the arrow
	--UIAnimManager.PlayCustomAnimation(2000, function(elapsedTime)
		--if(elapsedTime == 2000) then
			---- hide arrow
			--ArrowPointer.HideArrow(9842);
		--end
	--end);
end

-- handler stage 17: play round 5
function CombatTutorial.Handler_Stage17(...)
	local value = "5?"..user_nid..",?";
	local sequence = {
		"update_arena:arena_"..arena_id.."+"..pre_round5_arena_value,
		"movearrow:"..arena_id.."+1+1",
		"Death_SingleAttackWithLifeTap_Level6:Death_SingleAttackWithLifeTap_Level6,"..arena_id..",1,false,"..user_nid..",1,true,"..(mob_id_base + 2)..",6,300,150########",
		"speak:"..arena_id..",true,"..(mob_id_base + 2).."[哼！别得意，暗黑魔王会为我们报仇的！]";
		"dead:"..arena_id..",6,true,"..(mob_id_base + 2),
		"update_arena:arena_"..arena_id.."+"..mid_round5_arena_value,
		"update_arena:arena_"..arena_id.."+"..post_round5_arena_value,
	};
	local _, seq;
	for _, seq in ipairs(sequence) do
		value = value.."<"..seq..">";
	end
	
	MsgHandler.OnPlayTurn(value, function()
		-- process next stage
		CombatTutorial.ProcessNextStage(); -- continute to stage 5, stage 4 in an immediate process
		-- to stop the network traffic
		return false;
	end);
end

-- finish the combat
function CombatTutorial.Handler_Stage18(...)
	-- wait till 2 seconds to hide the arrow
	UIAnimManager.PlayCustomAnimation(500, function(elapsedTime)
		if(elapsedTime == 500) then
			-- hide arrow
			MsgHandler.OnArenaNormalUpdate_by_key_value("arena_"..arena_id, empty_arena_value);
			-- process next stage
			CombatTutorial.ProcessNextStage();
		end
	end);

end

-- finish master congrats
function CombatTutorial.Handler_Stage19(...)
	
	-- hide all desktop areas
	MyCompany.Aries.Desktop.HideAllAreas();
	
	-- lock user input
	ParaScene.GetAttributeObject():SetField("BlockInput", true);
	ParaCamera.GetAttributeObject():SetField("BlockInput", true);

	local Pet = commonlib.gettable("MyCompany.Aries.Pet");
	local player
	if(Pet.GetRealPlayer) then
		player = Pet.GetRealPlayer();
	else
		player = ParaScene.GetPlayer();
	end
	-- set init user position and facing
	player:SetPosition(user_position[1], user_position[2], user_position[3]);
	player:SetFacing(user_facing);
	
	-- set init camera position
	local att = ParaCamera.GetAttributeObject();
	att:SetField("CameraObjectDistance", init_camera_setting[1]);
	att:SetField("CameraLiftupAngle", init_camera_setting[2]);
	att:SetField("CameraRotY", init_camera_setting[3]);
	
	NPL.load("(gl)script/apps/Aries/Desktop/EXPArea.lua");
	MyCompany.Aries.Desktop.EXPArea.UnlockShow();
	MyCompany.Aries.Desktop.EXPArea.Show(true);
	ArrowPointer.ShowArrow(9843, 2, "_ctb", 0, -50, 64, 64);
	CombatTutorial.ShowTip("script/apps/Aries/Login/Tutorial/CombatTutorial_dialog.teen.html?start_state=16");
end

-- intro letter and every essentials
function CombatTutorial.Handler_Stage20(...)
	UIAnimManager.PlayCustomAnimation(50, function(elapsedTime)
		if(elapsedTime == 50) then
			ArrowPointer.HideArrow(9843);
			CombatTutorial.ShowTip("script/apps/Aries/Login/Tutorial/CombatTutorial_dialog.teen.html?start_state=14");
		end
	end);
end

-- pick school
function CombatTutorial.Handler_Stage21(...)
	
	local params = {
		url = "script/apps/Aries/Login/Tutorial/PickSchoolOfSpell.teen.html", 
		name = "OnPickSchoolOfSpell", 
		isShowTitleBar = false,
		app_key = MyCompany.Aries.app.app_key, 
		DestroyOnClose = true,
		style = CommonCtrl.WindowFrame.ContainerStyle,
		zorder = -1,
		allowDrag = false,
		directPosition = true,
			align = "_fi",
			x = 10,
			y = 0,
			width = 0,
			height = 0,
	};
	System.App.Commands.Call("File.MCMLWindowFrame", params);
end

-- show exp bar
function CombatTutorial.Handler_Stage22(...)
	System.App.Commands.Call("File.MCMLWindowFrame", {name="OnPickSchoolOfSpell", 
			app_key = MyCompany.Aries.app.app_key, 
			bShow = false,bDestroy = true,});
	
	local nid_str = tostring(System.App.profiles.ProfileManager.GetNID());
	local avatar = ParaScene.GetCharacter(nid_str);
	if(avatar and avatar:IsValid()) then
		avatar:ToCharacter():SetFocus();
	end
	if(MyCompany.Aries.Tutorial.CombatTutorialMain.skip_combat_tutorial) then
		-- finish them all. 
		stage = 24;
		CombatTutorial.ProcessNextStage();
		-- CombatTutorial.ShowDialog("");
	else
		-- reset camera back
		ParaCamera.SetLookAtPos(user_position[1], user_position[2] + 2, user_position[3])

		UIAnimManager.PlayCustomAnimation(50, function(elapsedTime)
			if(elapsedTime == 50) then
				CombatTutorial.ShowDialog("script/apps/Aries/Login/Tutorial/CombatTutorial_dialog.teen.html?start_state=15");
			end
		end);
	end
end

-- talk to captain foster
function CombatTutorial.Handler_Stage23(...)
	UIAnimManager.PlayCustomAnimation(500, function(elapsedTime)
		if(elapsedTime == 500) then
			CombatTutorial.ShowDialog("script/apps/Aries/Login/Tutorial/CombatTutorial_dialog.teen.html?start_state=17");
		end
	end);
end
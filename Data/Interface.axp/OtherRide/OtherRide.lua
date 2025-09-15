local Current_Ride_Index = -1;
local INVALID_ID =-1;
local RIDE_TAB_TEXT = {};
local OtherRide_g_Ride;			--Æï³Ë¶ÔÏó
local OtherRide_g_EquipMask;

local OtherRide_Info = 0;
local OtherRide_Item = 0;

local RiderCommon_MountID = {}
	RiderCommon_MountID[30141000] = {21}
	RiderCommon_MountID[30141001] = {0}
	RiderCommon_MountID[30141002] = {1}
	RiderCommon_MountID[30141003] = {7}
	RiderCommon_MountID[30141004] = {5}
	RiderCommon_MountID[30141005] = {6}
	RiderCommon_MountID[30141006] = {8}
	RiderCommon_MountID[30141007] = {4}
	RiderCommon_MountID[30141008] = {3}
	RiderCommon_MountID[30141009] = {2}
	RiderCommon_MountID[30141010] = {9}
	RiderCommon_MountID[30141011] = {10}
	RiderCommon_MountID[30141012] = {16}
	RiderCommon_MountID[30141013] = {14}
	RiderCommon_MountID[30141014] = {15}
	RiderCommon_MountID[30141015] = {17}
	RiderCommon_MountID[30141016] = {13}
	RiderCommon_MountID[30141017] = {12}
	RiderCommon_MountID[30141018] = {11}
	RiderCommon_MountID[30141019] = {18}
	RiderCommon_MountID[30141020] = {19}
	RiderCommon_MountID[30141155] = {54}
	RiderCommon_MountID[30141159] = {57}
	RiderCommon_MountID[30141163] = {61}
	RiderCommon_MountID[30141167] = {56}
	RiderCommon_MountID[30141171] = {59}
	RiderCommon_MountID[30141175] = {53}
	RiderCommon_MountID[30141179] = {55}
	RiderCommon_MountID[30141183] = {58}
	RiderCommon_MountID[30141187] = {60}
	RiderCommon_MountID[30141219] = {66}
	RiderCommon_MountID[30141220] = {67}
	RiderCommon_MountID[30141224] = {68}
	RiderCommon_MountID[30280240] = {24}
	RiderCommon_MountID[30280260] = {26}
	RiderCommon_MountID[30280270] = {27}
	RiderCommon_MountID[30280280] = {28}
	RiderCommon_MountID[30280290] = {29}
	RiderCommon_MountID[30280300] = {30}
	RiderCommon_MountID[30280310] = {31}
	RiderCommon_MountID[30280320] = {32}
	RiderCommon_MountID[30280330] = {33}
	RiderCommon_MountID[30280350] = {35}
	RiderCommon_MountID[30280360] = {36}
	RiderCommon_MountID[30280370] = {37}
	RiderCommon_MountID[30280380] = {38}
	RiderCommon_MountID[30280390] = {39}
	RiderCommon_MountID[30280400] = {40}
	RiderCommon_MountID[30280410] = {41}
	RiderCommon_MountID[30280420] = {42}
	RiderCommon_MountID[30280430] = {43}
	RiderCommon_MountID[30280440] = {44}
	RiderCommon_MountID[30280450] = {45}
	RiderCommon_MountID[30280460] = {46}
	RiderCommon_MountID[30280470] = {47}
	RiderCommon_MountID[30280480] = {48}
	RiderCommon_MountID[30280490] = {49}
	RiderCommon_MountID[30280500] = {50}
	RiderCommon_MountID[30280510] = {51}
	RiderCommon_MountID[30280520] = {52}
	RiderCommon_MountID[30280620] = {62}
	RiderCommon_MountID[30280630] = {63}
	RiderCommon_MountID[30280640] = {64}
	RiderCommon_MountID[30280650] = {65}
	RiderCommon_MountID[30280690] = {69}
	RiderCommon_MountID[30280700] = {70}
	RiderCommon_MountID[30280710] = {71}
	RiderCommon_MountID[30280720] = {72}
	RiderCommon_MountID[30280730] = {73}
	RiderCommon_MountID[30280740] = {74}
	RiderCommon_MountID[30280750] = {75}
	RiderCommon_MountID[30280760] = {76}
	RiderCommon_MountID[30280770] = {77}
	RiderCommon_MountID[30280780] = {78}
	RiderCommon_MountID[30280790] = {79}
	RiderCommon_MountID[30280800] = {80}
	RiderCommon_MountID[30280810] = {81}
	RiderCommon_MountID[30280820] = {82}
	RiderCommon_MountID[30280830] = {83}
	RiderCommon_MountID[30280840] = {84}
	RiderCommon_MountID[30280850] = {85}
	RiderCommon_MountID[30280860] = {86}
	RiderCommon_MountID[30280870] = {87}
	RiderCommon_MountID[30280880] = {88}
	RiderCommon_MountID[30280890] = {89}
	RiderCommon_MountID[30280900] = {90}
	RiderCommon_MountID[30280910] = {91}
	RiderCommon_MountID[30280920] = {92}
	RiderCommon_MountID[30280930] = {93}
	RiderCommon_MountID[30280940] = {94}
	RiderCommon_MountID[30280960] = {96}
	RiderCommon_MountID[30280980] = {98}
	RiderCommon_MountID[30280990] = {99}
	RiderCommon_MountID[30281000] = {100}
	RiderCommon_MountID[30281020] = {102}
	RiderCommon_MountID[30281030] = {103}
	RiderCommon_MountID[30281040] = {104}
	RiderCommon_MountID[30281510] = {151}
	RiderCommon_MountID[30281530] = {153}
	RiderCommon_MountID[30281540] = {154}
	RiderCommon_MountID[30281570] = {157}
	RiderCommon_MountID[30281580] = {158}
	RiderCommon_MountID[30281600] = {160}
	RiderCommon_MountID[30281620] = {162}
	RiderCommon_MountID[30281640] = {164}
	RiderCommon_MountID[30281650] = {165}
	RiderCommon_MountID[30281660] = {166}
	RiderCommon_MountID[30281670] = {167}
	RiderCommon_MountID[30281680] = {168}
	RiderCommon_MountID[30281690] = {169}
	RiderCommon_MountID[30281710] = {171}
	RiderCommon_MountID[30281720] = {172}
	RiderCommon_MountID[30281730] = {173}
	RiderCommon_MountID[30281740] = {174}
	RiderCommon_MountID[30281750] = {175}
	RiderCommon_MountID[30281760] = {176}
	RiderCommon_MountID[30281770] = {177}
	RiderCommon_MountID[30281780] = {178}
	RiderCommon_MountID[30281790] = {179}
	RiderCommon_MountID[30281800] = {180}
	RiderCommon_MountID[30281810] = {181}
	RiderCommon_MountID[30281860] = {186}
	RiderCommon_MountID[30281870] = {187}
	RiderCommon_MountID[30281880] = {188}
	RiderCommon_MountID[30281890] = {189}
	RiderCommon_MountID[30281900] = {190}
	RiderCommon_MountID[30281910] = {191}
	RiderCommon_MountID[30281920] = {192}
	RiderCommon_MountID[30281940] = {194}
	RiderCommon_MountID[30281950] = {195}
	RiderCommon_MountID[30281960] = {196}
	RiderCommon_MountID[30281970] = {197}
	RiderCommon_MountID[30281980] = {198}
	RiderCommon_MountID[30281990] = {199}
	RiderCommon_MountID[30282000] = {200}
	RiderCommon_MountID[30282010] = {201}
	RiderCommon_MountID[30282020] = {202}
	RiderCommon_MountID[30282030] = {203}
	RiderCommon_MountID[30282040] = {204}
	RiderCommon_MountID[30282050] = {205}
	RiderCommon_MountID[30282060] = {206}
	RiderCommon_MountID[30282070] = {207}
	RiderCommon_MountID[30282080] = {208}
	RiderCommon_MountID[30282090] = {209}
	RiderCommon_MountID[30282100] = {210}
	RiderCommon_MountID[30282110] = {211}
	RiderCommon_MountID[30282120] = {212}
	RiderCommon_MountID[30282130] = {213}
	RiderCommon_MountID[30282140] = {214}
	RiderCommon_MountID[30282160] = {216}
	RiderCommon_MountID[30282170] = {217}
	RiderCommon_MountID[30282180] = {218}
	RiderCommon_MountID[30282190] = {219}
	RiderCommon_MountID[30282200] = {220}
	RiderCommon_MountID[30282210] = {221}
	RiderCommon_MountID[30282220] = {222}
	RiderCommon_MountID[30282230] = {223}
	RiderCommon_MountID[30282240] = {224}
	RiderCommon_MountID[30282250] = {225}
	RiderCommon_MountID[30282260] = {226}
	RiderCommon_MountID[30282300] = {230}
	RiderCommon_MountID[30282310] = {231}
	RiderCommon_MountID[30282320] = {232}
	RiderCommon_MountID[30282330] = {233}
	RiderCommon_MountID[30282340] = {234}
	RiderCommon_MountID[30282350] = {235}
	RiderCommon_MountID[30282370] = {237}
	RiderCommon_MountID[30282380] = {238}
	RiderCommon_MountID[30282390] = {239}
	RiderCommon_MountID[30282420] = {242}
	RiderCommon_MountID[30282430] = {243}
	RiderCommon_MountID[30282440] = {244}
	RiderCommon_MountID[30282450] = {245}
	RiderCommon_MountID[30282460] = {246}
	RiderCommon_MountID[30282470] = {247}
	RiderCommon_MountID[30282480] = {248}
	RiderCommon_MountID[30282490] = {249}
	RiderCommon_MountID[30282500] = {250}
	RiderCommon_MountID[30282570] = {257}

function OtherRide_PreLoad()
	
	-- ´ò¿ª½çÃæ
	this:RegisterEvent("TOGLE_OTHERRIDE_PAGE");
	
	--Àë¿ª³¡¾°£¬×Ô¶¯¹Ø±Õ
	this:RegisterEvent("PLAYER_LEAVE_WORLD");

	this:RegisterEvent("UI_COMMAND");
end

function OtherRide_OnLoad()
	
	RIDE_TAB_TEXT = {
		[0] = "Ð°",
		"Nhân",
		"Thú",
		"KÜ",
	};
	
	OtherRide_g_Ride = OtherRide_Equip;
	OtherRide_g_EquipMask = OtherRide_Equip_Mask;
end

-- OnEvent
function OtherRide_OnEvent(event) --145001
	if event == "UI_COMMAND" and tonumber(arg0) == 145001 then
		OtherRide_Info = Get_XParam_INT(1)
		OtherRide_Item = Get_XParam_INT(2)
		
		this:Show();
		OtherRide_OnShow();
		this:Show();
	end
	
	if ( event == "TOGLE_OTHERRIDE_PAGE" ) then
	
		if(this:IsVisible()) then
			
			this:Hide();
			return;
		end

		Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("XSCRIPT")
		Set_XSCRIPT_ScriptID(045002)
		Set_XSCRIPT_Parameter(0,81)
		Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT();
		-- OtherRide_OnShow();
	end
	
	if( event == "PLAYER_LEAVE_WORLD") then
		this:Hide();
		return;
	end	
	return;		
end
function OtherRide_SetTabColor(idx)
	if(idx == nil or idx < 0 or idx > 4) then
		return;
	end	
	
	--AxTrace(0,0,tostring(idx));
	local i = 0;
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = OtherRide_TargetEquip,
								OtherRide_TargetData,
								OtherRide_Pet,
								OtherRide_Ride,
							};
	
	while i < 4 do
		if(i == idx) then
			tab[i]:SetText(selColor..RIDE_TAB_TEXT[i]);
		else
			tab[i]:SetText(noselColor..RIDE_TAB_TEXT[i]);
		end
		i = i + 1;
	end
end
function OtherRide_OnShow()
	OtherRide_Ride:SetCheck(1)
	local OtherUnionPos = Variable:GetVariable("OtherUnionPos");
	if(OtherUnionPos ~= nil) then
		OtherRide_Frame:SetProperty("UnifiedPosition", OtherUnionPos);
	end
	
	OtherRide_Equip_Update();   --ÏÔÊ¾¶Ô·½Æï³Ë
end

function OtherRide_Equip_Update()
	OtherRide_g_Ride:SetActionItem(-1);
	local ActionMount = GemMelting:UpdateProductAction(OtherRide_Item);
	OtherRide_g_Ride:SetActionItem(ActionMount:GetID());	
	
	if OtherRide_Item ~= 0 then
		if IsWindowShow("OtherRide") then
			OtherRide_FakeObject:SetFakeObject("");
			Target:SetHorseModel(RiderCommon_MountID[OtherRide_Item][1]);
			OtherRide_FakeObject:SetFakeObject("Other_Horse");
		end
	else
		OtherRide_FakeObject:SetFakeObject("")
	end
end

local OtherRideMouse = -1
function OtherRide_MousePos(nValue)
	OtherRideMouse = nValue;
end

function GlobalMouseOtherRide()
	return OtherRideMouse;
end

function GlobalInfoOtherRide()
	return OtherRide_Info;
end
----------------------------------------------------------------------------------
--
-- Ñ¡×°Íæ¼ÒÄ£ÐÍ£¨Ïò×ó)
--
function OtherRide_Model_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--Ïò×óÐý×ª¿ªÊ¼
		if(start == 1) then
			OtherRide_FakeObject:RotateBegin(-0.3);
		--Ïò×óÐý×ª½áÊø
		else
			OtherRide_FakeObject:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
-- Ñ¡×°Íæ¼ÒÄ£ÐÍ£¨ÏòÓÒ)
--
function OtherRide_Model_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--ÏòÓÒÐý×ª¿ªÊ¼
		if(start == 1) then
			OtherRide_FakeObject:RotateBegin(0.3);
		--ÏòÓÒÐý×ª½áÊø
		else
			OtherRide_FakeObject:RotateEnd();
		end
	end
end

--===============================================
-- ´ò¿ªÍæ¼Ò×°±¸UI
--===============================================
function OtherRide_TargetEquip_Down()
	OtherRide_FakeObject : SetFakeObject( "" )
	Variable:SetVariable("OtherUnionPos", OtherRide_Frame:GetProperty("UnifiedPosition"), 1);
	OtherRide_OnHiden()
	SystemSetup:OpenEquipFrame("other");
end

--===============================================
-- ´ò¿ªÍæ¼Ò×ÊÁÏUI
--===============================================
function OtherRide_TargetData_Down()
	OtherRide_FakeObject : SetFakeObject( "" )
	Variable:SetVariable("OtherUnionPos", OtherRide_Frame:GetProperty("UnifiedPosition"), 1);
	OtherRide_OnHiden()
	SystemSetup:OpenPrivatePage("other")
end
--===============================================
-- ´ò¿ªÍæ¼Ò²©¿ÍUI
--===============================================
function OtherRide_TargetWuhun_Switch()
	OtherRide_FakeObject : SetFakeObject( "" )
	Variable:SetVariable("OtherUnionPos", OtherRide_Frame:GetProperty("UnifiedPosition"), 1);
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("XSCRIPT")
	Set_XSCRIPT_ScriptID(045002)
	Set_XSCRIPT_Parameter(0,1)
	Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT();
end

function OtherRide_OtherPet_Down()
	OtherRide_FakeObject : SetFakeObject( "" )
	Variable:SetVariable("OtherUnionPos", OtherRide_Frame:GetProperty("UnifiedPosition"), 1);
	OtherRide_OnHiden()
	SystemSetup:OpenPetFrame("other");
end


function OtherRide_Equip_Click( buttonIn )
	local button = tonumber( buttonIn );
	if( button == 1 ) then
		OtherRide_g_Ride:DoAction();	--Æï³Ë
	else
		OtherRide_g_Ride:DoSubAction();	--Æï³Ë
	end
end

function OtherRide_OnHiden()
	OtherRide_FakeObject : SetFakeObject( "" );
end
local Style_Index = {};
local Current = 0;
local Max_Style = 1;
local Original_Style = 0;
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local g_Object = -1;
local g_HaveChange = 0;
local HairStyle_Icon = {}
local HairStyle_Frame = {}
local Current_Page = 0
local STYLE_BUTTON = 12
local g_SelectHairstyle_Frame_UnifiedPosition;

function SelectHairstyle_PreLoad()
	this:RegisterEvent("UI_COMMAND");	
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("SEX_CHANGED");	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function SelectHairstyle_OnLoad()
	HairStyle_Icon[1] = SelectHairstyle_Skill1_BKG
	HairStyle_Icon[2] = SelectHairstyle_Skill2_BKG
	HairStyle_Icon[3] = SelectHairstyle_Skill3_BKG
	HairStyle_Icon[4] = SelectHairstyle_Skill4_BKG
	HairStyle_Icon[5] = SelectHairstyle_Skill5_BKG
	HairStyle_Icon[6] = SelectHairstyle_Skill6_BKG
	HairStyle_Icon[7] = SelectHairstyle_Skill7_BKG
	HairStyle_Icon[8] = SelectHairstyle_Skill8_BKG
	HairStyle_Icon[9] = SelectHairstyle_Skill9_BKG
	HairStyle_Icon[10] = SelectHairstyle_Skill10_BKG
	HairStyle_Icon[11] = SelectHairstyle_Skill11_BKG
	HairStyle_Icon[12] = SelectHairstyle_Skill12_BKG
	
	g_SelectHairstyle_Frame_UnifiedPosition=SelectHairstyle_Frame:GetProperty("UnifiedPosition");
	
end

function SelectHairstyle_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 21) then

			local xx = Get_XParam_INT(0);
			objCared = DataPool : GetNPCIDByServerID(xx);
			AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
			if objCared == -1 then
					PushDebugMessage("D� li�u c�a server truy�n tr� l�i c� v�n �");
					return;
			end

			if(IsWindowShow("SelectHairColor")) then
				CloseWindow("SelectHairColor", true);
			end
			
			if(IsWindowShow("SelectFacestyle")) then
				CloseWindow("SelectFacestyle", true);
			end
			
			if(this:IsVisible() and tonumber(Original_Style)) then
				DataPool : Change_MyHairStyle(Original_Style);
			end
			BeginCareObject_SelectHairstyle(objCared)
			SelectHairstyle_OnShown();
	elseif (event == "OBJECT_CARED_EVENT") then

		if(not this:IsVisible() ) then
			return;
		end
	
		if(tonumber(arg0) ~= objCared) then
			Close_HairStyle()
			return;
		end
		
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--ȡ������
			SelectHairstyle_Cancel_Clicked()
		end
	end

	if event == "SEX_CHANGED" and  this:IsVisible() then
			SelectHairstyle_Model : Hide();
			SelectHairstyle_Model : Show();
			SelectHairstyle_Model:SetFakeObject("Player_Head");
	end
	
	if (event == "ADJEST_UI_POS" ) then
		SelectHairstyle_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		SelectHairstyle_Frame_On_ResetPos()
	end
	
end


function SelectHairstyle_OnShown()
	for i,eachstyle in HairStyle_Icon do
		eachstyle : SetPushed(0)
	end
	Original_Style = DataPool : Get_MyHairStyle();
--	AxTrace(0,1,"Original_Style="..Original_Style)
	SelectHairstyle_Update();
	this:Show();
end

function SelectHairstyle_Update()
	local i,RaceID,ItemID,ItemCount,SelectType,k,IconFile;
	k = 1;
	Current = 1
	
	for i,eachstyle in HairStyle_Icon do
		eachstyle : SetPushed(0)
		eachstyle : SetProperty("NormalImage","")
		eachstyle : SetProperty("HoverImage","")
		eachstyle : SetToolTip("")
	end
	
	for i=0, 200 do
		ItemID,ItemCount,SelectType,IconFile,CostMoney,StyleName = DataPool : Change_MyHairStyle_Item(i);
		
		if(ItemID ~= -1 and SelectType >= 2) then
--			if( DataPool:GetPlayerMission_ItemCountNow(ItemID) >= ItemCount) then
--				AxTrace(0,1,"ItemID="..ItemID.." i="..i);
			if k > STYLE_BUTTON * (Current_Page) and k <= STYLE_BUTTON * (Current_Page+1) then
				local m = k - STYLE_BUTTON * (Current_Page);
				Style_Index[m] = i;
				IconFile = GetIconFullName(IconFile)
				HairStyle_Icon[m]:SetProperty("NormalImage",IconFile)
				HairStyle_Icon[m]:SetProperty("HoverImage",IconFile)
--				HairStyle_Icon[m]:SetProperty("PushedImage",IconFile)
				HairStyle_Icon[m]:SetToolTip(StyleName)
				
				if Original_Style == i then
--					Max_Style = k + 1
					SelectHairstyle_Clicked(m)
				end
			end
			Max_Style = k
			k = k+1;
--				if k > STYLE_BUTTON then
--					break
--				end
--			end
		end
	end
	


	if(Max_Style <= 0) then
		SelectHairstyle_Require:SetText("Kh�ng th� s�a �i ki�u t�c");
		SelectHairstyle_CurrentlyPage:SetText("1/1");
		SelectHairstyle_Model : SetFakeObject( "" );
		SelectHairstyle_Model : SetFakeObject( "Player_Head" );
		SelectHairstyle_PageUp : Disable();
		SelectHairstyle_PageDown : Disable();
		SelectHairstyle_Accept : Disable();
		return;
	end
	SelectHairstyle_Require: SetText("");
	ItemID,ItemCount,SelectType,IconFile,CostMoney = DataPool : Change_MyHairStyle_Item(Style_Index[Current]);
	local name,icon = LifeAbility : GetPrescr_Material(ItemID);
	
	SelectHairstyle_WarningText : SetText("C�n "..name.." : "..ItemCount.."#r C�n ti�u hao: #{_EXCHG"..CostMoney.."}#rM�i l�a ch�n ki�u t�c � ph�a b�n tr�i m�n h�nh, sau �� k�ch n�t \"Duy�t\"");

	SelectHairstyle_Model : SetFakeObject( "Player_Head" );
	if Max_Style > STYLE_BUTTON then
		SelectHairstyle_PageUp : Enable();
		SelectHairstyle_PageDown : Enable();
	else
		SelectHairstyle_PageUp : Disable();
		SelectHairstyle_PageDown : Disable();
	end
	
	if Current_Page == 0 then
		SelectHairstyle_PageUp : Disable();
	else
		SelectHairstyle_PageUp : Enable();
	end
	
	if (Current_Page+1)*STYLE_BUTTON <= Max_Style then
		SelectHairstyle_PageDown : Enable();
	else
		SelectHairstyle_PageDown : Disable();
	end
	
	SelectHairstyle_Accept : Enable();
	SelectHairstyle_Clicked(Current)
end


function SelectHairstyle_Add_Clicked()

	if(Current >= Max_Style) then
		Current = 1;
	else
		Current = Current + 1;
	end
	
	local ItemID,ItemCount,SelectType,IconFile,CostMoney  = DataPool : Change_MyHairStyle_Item(Style_Index[Current]);
	local name,icon = LifeAbility : GetPrescr_Material(ItemID);
	
	SelectHairstyle_WarningText : SetText("C�n "..name.." : "..ItemCount.."#r C�n ti�u hao: #{_EXCHG"..CostMoney.."}#rM�i l�a ch�n ki�u t�c � ph�a b�n tr�i m�n h�nh, sau �� k�ch n�t \"Duy�t\"");
	SelectHairstyle_CurrentlyPage : SetText(Current .."/".. Max_Style);
	DataPool : Change_MyHairStyle(Style_Index[Current]);
	g_HaveChange = 1;
end

function SelectHairstyle_Minus_Clicked()
	if(Current <= 1) then
		Current = Max_Style;
	else
		Current = Current - 1;
	end
	
	local ItemID,ItemCount,SelectType,IconFile,CostMoney = DataPool : Change_MyHairStyle_Item(Style_Index[Current]);
	local name,icon = LifeAbility : GetPrescr_Material(ItemID);
	
	SelectHairstyle_WarningText : SetText("C�n "..name.." : "..ItemCount.."#r C�n ti�u hao: #{_EXCHG"..CostMoney.."}#rM�i l�a ch�n ki�u t�c � ph�a b�n tr�i m�n h�nh, sau �� k�ch n�t \"Duy�t\"");
	SelectHairstyle_CurrentlyPage : SetText(Current .."/".. Max_Style);
	DataPool : Change_MyHairStyle(Style_Index[Current]);
	g_HaveChange = 1;
end

--==================================
--ȷ��
--==================================
function SelectHairstyle_OK_Clicked()

	-- �õ�ѡ��ķ�����Ϣ
	ItemID,ItemCount,SelectType,IconFile,CostMoney = DataPool : Change_MyHairStyle_Item(Style_Index[Current]);

	-- �õ�ѡ��ķ�����Ϣ
	if(ItemID ~= -1 and SelectType >= 2) then
		if( DataPool:GetPlayerMission_ItemCountNow(ItemID) < ItemCount) then
			PushDebugMessage("Thi�u Ph�t H�nh а");
			return;
		end
	end
	
	-- �õ���ҵĽ�Һͽ�����Ŀ
	local nMoney = Player:GetData("MONEY")
	local nMoneyJZ = Player:GetData("MONEY_JZ")
	
	if (nMoney + nMoneyJZ) < CostMoney then
		PushDebugMessage("Ng�n l��ng kh�ng ��");
		return
	end
	
	-- ������Ϣ����ǰѡ��ķ���ID
	--PushDebugMessage ("StyleId = "..Style_Index[Current])
	-- ���ѡ��ķ��ͺ͵�ǰ���Ͳ�ͬ
	if Style_Index[Current] ~= Original_Style then
		
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("FinishAdjust");
			Set_XSCRIPT_ScriptID(801010);
			Set_XSCRIPT_Parameter(0,Style_Index[Current]);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		Close_HairStyle();

	else
		PushDebugMessage("Xin ch�n m�t ki�u t�c kh�c ki�u hi�n t�i c�a c�c h�.");
	end
	
end

function SelectHairstyle_Cancel_Clicked()

	DataPool : Change_MyHairStyle(Original_Style);
	Close_HairStyle()
end

----------------------------------------------------------------------------------
--
-- ��ת����ͷ��ģ�ͣ�����)
--
function Player_Head_Modle_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--������ת��ʼ
		if(start == 1) then
			SelectHairstyle_Model:RotateBegin(-0.3);
		--������ת����
		else
			SelectHairstyle_Model:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
--��ת����ͷ��ģ�ͣ�����)
--
function Player_Head_Modle_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--������ת��ʼ
		if(start == 1) then
			SelectHairstyle_Model:RotateBegin(0.3);
		--������ת����
		else
			SelectHairstyle_Model:RotateEnd();
		end
	end
end

function Close_HairStyle()
	g_HaveChange = 0;
	SelectHairstyle_Model : SetFakeObject( "" );
	StopCareObject_SelectHairstyle(objCared)
	this:Hide();
		
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_SelectHairstyle(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "SelectHairstyle");

end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_SelectHairstyle(objCaredId)
	this:CareObject(objCaredId, 0, "SelectHairstyle");
	g_Object = -1;

end

function SelectHairstyle_Clicked(nIndex)

	if( nIndex < 0 or nIndex + STYLE_BUTTON * (Current_Page) > Max_Style ) then
		return
	end

	HairStyle_Icon[Current] : SetPushed(0);
	Current = nIndex
	HairStyle_Icon[Current] : SetPushed(1);

	local ItemID,ItemCount,SelectType,IconFile,CostMoney = DataPool : Change_MyHairStyle_Item(Style_Index[nIndex]);
	local name,icon = LifeAbility : GetPrescr_Material(ItemID);
	
	SelectHairstyle_WarningText : SetText("C�n "..name.." : "..ItemCount.."#r C�n ti�u hao: #{_EXCHG"..CostMoney.."}#rM�i l�a ch�n ki�u t�c � ph�a b�n tr�i m�n h�nh, sau �� k�ch n�t \"Duy�t\"");

	DataPool : Change_MyHairStyle(Style_Index[nIndex]);
	g_HaveChange = 1;
end

function SelectHairstyle_Page(nPage)
	
	Current_Page = Current_Page + nPage;

	SelectHairstyle_Update();

end


function SelectHairstyle_Frame_On_ResetPos()
  SelectHairstyle_Frame:SetProperty("UnifiedPosition", g_SelectHairstyle_Frame_UnifiedPosition);
end

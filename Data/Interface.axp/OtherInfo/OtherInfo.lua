--------------------------------------------------------------------------------
-- װ����ť���ݶ���
--
local  g_BAG;			--����
local  g_BOX;			--����

--ʦ�����ToolTip����	--add by xindefeng
local g_ShiDeTbl = {
											[0] = {"Kh�ng#r", "0#r", 0},
											[1] = {"S� Ph� S� C�p#r", "2#r", 30},
											[2] = {"S� Ph� Trung C�p#r", "3#r", 35},
											[3] = {"S� Ph� Cao C�p#r", "5#r", 50},
											[4] = {"Nh�t ��i Danh S�#r", "8#r", 70}
										}

function OtherInfo_PreLoad()
	
	-- �򿪽���
	this:RegisterEvent("OPEN_OTHER_INFO");
	
	--�뿪�������Զ��ر�
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("UPDATE_DOUBLE_EXP");
	
	--����װ��
	this:RegisterEvent("REFRESH_EQUIP1");
	
	-- �������ݷ����仯
	this:RegisterEvent("UPDATE_MISSION_DATA");
		
	--���ʹ������--add by xindefeng
	this:RegisterEvent("UPDATE_PET_EXTRANUM");
	
end

function OtherInfo_OnLoad()

	g_BAG = OtherInfo_Packet1_Skill1; --����
	g_BOX = OtherInfo_Packet2_Skill1; --����
	
	OTHERINFO_TAB_TEXT = {
		[0] = "а",
		"Nh�n",
		"Th�",
		"K�",
		"Kh�c",
	};
end

-- OnEvent
function OtherInfo_OnEvent(event)
OtherInfo_SetTabColor(4);
	if ( event == "OPEN_OTHER_INFO" ) then
	
		if(this:IsVisible()) then
			
			this:Hide();
			return;
		end
		
		-- ִ�з������ű���������´������
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("UpdataDacoityData");
			Set_XSCRIPT_ScriptID(311012);
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT();

		OtherInfo_OnShow();
		this:Show();
	end
	
	if( event == "PLAYER_LEAVE_WORLD") then
		this:Hide();
		return;
	end
	
	if( event == "UPDATE_DOUBLE_EXP") then
		local str = SystemSetup:GetDoubleExp( "count" )
		OtherInfo_6 : SetText(str.." gi�")	
		local str1 = SystemSetup:GetDoubleExp( "juqing" )
		OtherInfo_7 : SetText(str1 .. "")	
		return;
	end

	if( event == "REFRESH_EQUIP1") then
		Equip_RefreshEquip1();
	end
	
	if(event == "UPDATE_MISSION_DATA")  then
		OtherInfo_OnShow();
	end
	
	--���������¼�--add by xindefeng
	if(event == "UPDATE_PET_EXTRANUM") then
		if(this:IsVisible()) then			
			OtherInfo_OnShow()			
		end	
	end
	
	return;		
end

function Equip_RefreshEquip1()
	--  ��հ�ť��ʾͼ��
	g_BAG:SetActionItem(-1);			--����
	g_BOX:SetActionItem(-1);			--����
	
	local ActionBag 		= EnumAction(9 , "equip");
	local ActionBox 		= EnumAction(10, "equip");
	
	-- ��ʾ�����ϵ�����װ��
	g_BAG:SetActionItem(ActionBag:GetID());			--����
	g_BOX:SetActionItem(ActionBox:GetID());			--���� 
end

-- ���ҵ���¼�
function SelfEquip_Bag_Click()
	g_BAG:DoSubAction();	--����
end

-- �������¼�
function SelfEquip_Box_Click()
	g_BOX:DoSubAction();	--����
end

function OtherInfo_OnShow()
	OtherInfo_OtherInfo : SetCheck(1);
	local str;
	local selfUnionPos = Variable:GetVariable("SelfUnionPos");
	if(selfUnionPos ~= nil) then
		OtherInfo_Frame:SetProperty("UnifiedPosition", selfUnionPos);
	end
	
	str = Player : GetData("GOODBADVALUE");
	OtherInfo_1 : SetText(str)
	SetOtherInfo_1_Tooltip()	--������ToolTips	-- add by xindefeng	

	str = Player : GetData("PKVALUE");
	OtherInfo_2 : SetText(str)
		
	local prenticeNum = Player : GetData("PRENTICCOUNT");
	local masterLvl = Player : GetData("MASTERLEVEL");
	local availRecruitNum = 0;
	if masterLvl == 1 then
		availRecruitNum = 2;
	elseif masterLvl == 2 then
		availRecruitNum = 3;
	elseif masterLvl == 3 then
		availRecruitNum = 5;
	elseif masterLvl == 4 then
		availRecruitNum = 8;
	end
	OtherInfo_9_Text:SetText("S� l��ng thu nh�n � �: ");
	OtherInfo_9:SetText(prenticeNum.."/"..availRecruitNum);
--	str = Player : GetData("MORALPOINT");
--	OtherInfo_3 : SetText(str)
	
	str = Player : GetData("MENPAIPOINT");
	OtherInfo_4 : SetText(str)
	
	str = SystemSetup:GetDoubleExp( "count" )
	OtherInfo_6 : SetText(str.." gi�")	
	str = Guild:GetGuildContri();
	OtherInfo_5 : SetText(str);
	
	local nCount = DataPool:GetPlayerMission_DataRound(150)
	OtherInfo_3:SetText(tostring(nCount))
		
	OtherInfo_8:SetText(tonumber(Player:GetData("PET_EXTRANUM")))	--��ʾ�����ռ�--add by xindefeng
		
	OtherInfo_10 : SetText(Player : GetData("HONOR"));
end


function OtherInfo_SetTabColor(idx)
	if(idx == nil or idx < 0 or idx > 4) then
		return;
	end	
	
	--AxTrace(0,0,tostring(idx));
	local i = 0;
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = OtherInfo_SelfEquip,
								OtherInfo_SelfData,
								OtherInfo_Pet,
								OtherInfo_Ride,
								OtherInfo_OtherInfo,
							};
	
	while i < 5 do
		if(i == idx) then
			tab[i]:SetText(selColor..OTHERINFO_TAB_TEXT[i]);
		else
			tab[i]:SetText(noselColor..OTHERINFO_TAB_TEXT[i]);
		end
		i = i + 1;
	end
end

function OtherInfo_SelfEquip_Page_Switch()
	Variable:SetVariable("SelfUnionPos", OtherInfo_Frame:GetProperty("UnifiedPosition"), 1);

	OpenEquip(1);
	this:Hide();
	OtherInfo_SelfEquip : SetCheck(0);
	OtherInfo_SelfData : SetCheck(0);
	OtherInfo_Pet : SetCheck(0)
	OtherInfo_Ride : SetCheck(0);
	OtherInfo_OtherInfo : SetCheck(1);
	OtherInfo_SetTabColor(4);
end

--���Լ�������ҳ��
function OtherInfo_SelfData_Switch()
	Variable:SetVariable("SelfUnionPos", OtherInfo_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPrivatePage("self");
	this:Hide();
end

function OtherInfo_Pet_Switch()
	Variable:SetVariable("SelfUnionPos", OtherInfo_Frame:GetProperty("UnifiedPosition"), 1);

	TogglePetPage();
	this:Hide();
	OtherInfo_SelfEquip : SetCheck(0);
	OtherInfo_SelfData : SetCheck(0);
	OtherInfo_Pet : SetCheck(0);
	OtherInfo_Ride : SetCheck(0);
	OtherInfo_OtherInfo : SetCheck(1);
	OtherInfo_SetTabColor(4);
end

function OtherInfo_Ride_Page_Switch()
	Variable:SetVariable("SelfUnionPos", OtherInfo_Frame:GetProperty("UnifiedPosition"), 1);

	OpenRidePage();
	this:Hide();
	OtherInfo_SelfEquip : SetCheck(0);
	OtherInfo_SelfData : SetCheck(0);
	OtherInfo_Pet : SetCheck(0);
	OtherInfo_Ride : SetCheck(0);
	OtherInfo_OtherInfo : SetCheck(1);
	OtherInfo_SetTabColor(4);
end

function OtherInfo_Xiulian_Switch()
	PushDebugMessage("Ch�c n�ng ch�a m�!")
	OtherInfo_OtherInfo:SetCheck(1)
	OtherInfo_Xiulian:SetCheck(0)
end

function OtherInfo_Wuhun_Switch()
	local Level = Player:GetData("LEVEL")
	if Level < 65 then
		OtherInfo_Wuhun : SetCheck(0)
		PushDebugMessage("C�p 65 m�i c� th� s� d�ng.")
	else
		Variable:SetVariable("SelfUnionPos", OtherInfo_Frame:GetProperty("UnifiedPosition"), 1);
		PushEvent("UI_COMMAND",20111211)
	end
end

function OnOtherInfo_OpenReputationClick()
	
	OpenWindow( "Reputation" );
	AxTrace( 0,0, "Open Window Reputation" );
end

function OtherInfo_OnOpenGruidClick()
	Guild:ToggleGuildDetailInfo();
end

-- �򿪹�ϵ����
function OtherInfo_OpenGuanXi_Click()
	OpenWindow( "Relation" );
	AxTrace( 0,0, "Open Window Relation" );
end

--����otherinfo_1��tooltip	--add by xindefeng
function SetOtherInfo_1_Tooltip()
	local MasterLevel = Player:GetData("MASTERLEVEL")	--��ȡʦ�µȼ�	
	if(MasterLevel < 0)then
		return
	end
	
	local ShanEValue = Player:GetData("GOODBADVALUE")						--��ȡ�ƶ�ֵ	
	local TuDiCount = Player:GetData("PRENTICCOUNT")						--��ȡͽ������
	local TuDiSupplyExp = Player:GetData("PRENTICSUPPLYEXP")		--��ȡ��ǰͽ�ܹ��׵ľ���ֵ
	local ShanEExp = ShanEValue * (g_ShiDeTbl[MasterLevel][3])	--�������ƶ�ֵ�ҹ�������ȡ�ľ���ֵ
	local TrueExp = ((TuDiSupplyExp < ShanEExp) and TuDiSupplyExp) or ShanEExp	--��ȡ������Сֵ	
	
	local str =	"��ng c�p s� ph�:"..g_ShiDeTbl[MasterLevel][1].."S� l��ng � t�:"..TuDiCount.."/"..g_ShiDeTbl[MasterLevel][2].."Kinh nghi�m c� th� �i:"..TrueExp
	
	OtherInfo_1:SetToolTip(str)
end

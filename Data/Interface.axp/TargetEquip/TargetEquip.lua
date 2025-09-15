
--------------------------------------------------------------------------------
-- װ����ť���ݶ���
--
local  g_WEAPON;		--����
local  g_ARMOR;			--�·�
local  g_CAP;			--ñ��
local  g_CUFF;			--����
local  g_BOOT;			--Ь
local  g_RING;			--����
local  g_SASH;			--����
local  g_NECKLACE;		--����
local  g_Dark;			--����---���޸�Ϊ����
local  g_Charm;			-- ����
local  g_Charm2;		-- ����2
local  g_Shoulder;		-- ����
local  g_Glove;			-- ����
local  g_Ring2;			-- ��ָ2
local  g_FashionDress;	-- ʱװ

local Cur_Name = "";
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local g_Object = -1;

local TARGETEQUIP_TAB_TEXT = {};

function TargetEquip_PreLoad()

	-- �򿪽���
	this:RegisterEvent("MAINTARGET_CHANGED");
	this:RegisterEvent("OTHERPLAYER_UPDATE_EQUIP");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("CLOSE_TARGET_EQUIP");
	this:RegisterEvent("OBJECT_CARED_EVENT");

end

function TargetEquip_OnLoad()

	-- action buttion ��ť
	g_WEAPON		= TargetEquip_Equip11;		--����
	g_ARMOR			= TargetEquip_Equip12;		--�·�
	g_CAP			= TargetEquip_Equip1;		--ñ��
	g_CUFF			= TargetEquip_Equip8;		--����
	g_BOOT			= TargetEquip_Equip4;		--Ь
	g_RING			= TargetEquip_Equip6;		--����
	g_SASH			= TargetEquip_Equip7;		--����
	g_NECKLACE		= TargetEquip_Equip13;		--����
	g_Dark			= TargetEquip_Equip14;		--����
	g_Charm			= TargetEquip_Equip9;		-- ����
	g_Charm2		= TargetEquip_Equip10;		-- ����2
	g_Shoulder		= TargetEquip_Equip3;		-- ����
	g_Glove			= TargetEquip_Equip2;		-- ����
	g_Ring2			= TargetEquip_Equip5;		-- ��ָ2
	g_FashionDress	= TargetEquip_Equip15;		-- ʱװ
	
	TARGETEQUIP_TAB_TEXT = {
		[0] = "а",
		"Nh�n",
		"Th�",
		"K�",
	};
end
function TargetEquip_SetTabColor(idx)

	local i = 0;
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = TargetEquip_SelfEquip,
								TargetEquip_TargetData,								
								TargetEquip_Pet,
								TargetEquip_Ride,
							};
	
	while i < 4 do
		if(i == idx) then
			tab[i]:SetText(selColor..TARGETEQUIP_TAB_TEXT[i]);
		else
			tab[i]:SetText(noselColor..TARGETEQUIP_TAB_TEXT[i]);
		end
		i = i + 1;
	end
end
-- OnEvent
function TargetEquip_OnEvent(event)

	if ( event == "MAINTARGET_CHANGED" and tonumber(arg0) == -1) then
--		if(this:IsVisible()) then
--			TargetEquip_CloseUI();
--		end
		return;
	end

	if( "PLAYER_LEAVE_WORLD" == event) then
		this : Hide();
		return;
	end

	-- װ���仯ʱˢ��װ��.
	if("OTHERPLAYER_UPDATE_EQUIP" == event) then

		if (not CachedTarget:IsPresent(1)) or (type(CachedTarget:GetData("NPCID", 1))~="number") then
			return;
		end

		local otherUnionPos = Variable:GetVariable("OtherUnionPos");
		if(otherUnionPos ~= nil) then
			TargetEquip_Frame:SetProperty("UnifiedPosition", otherUnionPos);
		end
		TargetEquip_SetTabColor(0);
--		TargetEquip_TargetPet:Disable();
		TargetEquip_SelfEquip:SetCheck(1);
		TargetEquip_TargetData:SetCheck(0);
		TargetEquip_FakeObject:SetFakeObject("");
		CachedTarget:TargetEquip_ChangeModel();
		TargetEquip_FakeObject:SetFakeObject("Target");
		TargetEquip_OnUpdateShow();
		TargetEquip_RefreshEquip();
		this:Show();
		return;
	end

	if( "CLOSE_TARGET_EQUIP" == event ) then

		this : Hide();
		return;
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end

		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if( arg1=="destroy") then
			this:Hide();

			--ȡ������
			StopCareObject_TargetEquip(objCared);
		end

	end

end

-- �������ǻ�����Ϣ
function TargetEquip_OnUpdateShow()
	local PlayerTarget = GetTargetPlayerGUID();
	if PlayerTarget ~= nil then
		Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("XSCRIPT")
		Set_XSCRIPT_ScriptID(045002)
		Set_XSCRIPT_Parameter(0,0)
		Set_XSCRIPT_Parameter(1,PlayerTarget)
		Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT();
	end
	
	local nNumber=0;
	local nMaxnumber=0;
	local strName;

	objCared = CachedTarget:GetData("NPCID",1)

	if(type(objCared) ~="number") then
		return
	end
	
	strCharName =  CachedTarget:GetData("NAME");
	strAccount =  CachedTarget:GetData("ACCOUNTNAME")

	BeginCareObject_TargetEquip(objCared)
	-- �õ��Լ�������
  strName = CachedTarget:GetData("NAME",1);
  Cur_Name = strName;
	TargetEquip_PageHeader:SetText("#gFF0FA0" .. strName );
	--�õ��ƺ�
	strName = CachedTarget:GetData("TITLE",1)
	TargetEquip_Agname:SetText( ""..strName );
	strName = CachedTarget:GetData("GUILD",1)
	TargetEquip_Confraternity:SetText( ""..strName );
		-- �õ��ȼ�
	nNumber = CachedTarget:GetData("LEVEL",1);
	TargetEquip_Level:SetText("C�p: " .. tostring( nNumber ));

	-- �õ���ż��Ϣ
	local szConsort = SystemSetup:GetPrivateInfo("other","Consort");
	TargetEquip_Spouse:SetText(szConsort);

	-- ����
	local menpai = CachedTarget:GetData("MEMPAI",1);
	local strName = "";

	-- �õ���������.
	-- AxTrace(0,0,"��="..menpai);
	if(0 == menpai) then
		strName = "Thi�u L�m";

	elseif(1 == menpai) then
		strName = "Minh Gi�o";

	elseif(2 == menpai) then
		strName = "C�i Bang";

	elseif(3 == menpai) then
		strName = "V� �ang";

	elseif(4 == menpai) then
		strName = "Nga My";

	elseif(5 == menpai) then
		strName = "Tinh T�c";

	elseif(6 == menpai) then
		strName = "Thi�n Long";

	elseif(7 == menpai) then
		strName = "Thi�n S�n";

	elseif(8 == menpai) then
		strName = "Ti�u Dao";

	elseif(9 == menpai) then
		strName = "Kh�ng c�";

	elseif(10 == menpai) then
		strName = "M� Dung";
	end

	-- ������ʾ������.
	-- AxTrace(0,1,"strName="..strName)
	TargetEquip_MenPai:SetText("" .. strName);

	local szLuck = SystemSetup:GetPrivateInfo("other","luck");
	if(szLuck == "�@�һ�ܑУ�ʲôҲ�]������!") then 
	szLuck = "Hi�n t�i h� �ang b� quan tu luy�n, xin c�c h� vui l�ng quay l�i sau!"
	end
	TargetEquip_Message:SetText(szLuck);

end

-- ˢ��װ��
function TargetEquip_RefreshEquip()

	--  ��հ�ť��ʾͼ��
	g_WEAPON:SetActionItem(-1);			--����
	g_CAP:SetActionItem(-1);				--ñ��
	g_ARMOR:SetActionItem(-1);			--����
	g_CUFF:SetActionItem(-1);				--����
	g_BOOT:SetActionItem(-1);				--Ь
	g_SASH:SetActionItem(-1);				--����
	g_RING:SetActionItem(-1);				--����
	g_NECKLACE:SetActionItem(-1);		--����
	g_Dark:SetActionItem(-1);			--����
	g_Charm:SetActionItem(-1);		-- ����
	g_Charm2:SetActionItem(-1);		-- ����2
	g_Shoulder:SetActionItem(-1);		-- ����
	g_Glove:SetActionItem(-1);		-- ����
	g_Ring2:SetActionItem(-1);		-- ��ָ2
	g_FashionDress:SetActionItem(-1);		-- ʱװ

	local ActionWeapon 		= EnumAction(0, "targetequip");
	local ActionCap    		= EnumAction(1, "targetequip");
	local ActionArmor  		= EnumAction(2, "targetequip");
	local ActionGlove		= EnumAction(3, "targetequip");
	local ActionBoot   		= EnumAction(4, "targetequip");
	local ActionSash   		= EnumAction(5, "targetequip");
	local ActionRing    	= EnumAction(6, "targetequip");
	local ActionNecklace	= EnumAction(7, "targetequip");
	local ActionDark		= EnumAction(17, "targetequip");    --�޸�Ϊ����  by houzhifang
	local ActionRing2		= EnumAction(11, "targetequip");
	local ActionCharm		= EnumAction(12, "targetequip");
	local ActionCharm2		= EnumAction(13, "targetequip");
	local ActionCuff  		= EnumAction(14, "targetequip");
	local ActionShoulder	= EnumAction(15, "targetequip");
	local ActionDress		= EnumAction(16, "targetequip");

	-- ��ʾ�����ϵ�����װ��
	g_WEAPON:SetActionItem(ActionWeapon:GetID());			--����
	g_CAP:SetActionItem(ActionCap:GetID());						--ñ��
	g_ARMOR:SetActionItem(ActionArmor:GetID());				--����
	g_CUFF:SetActionItem(ActionCuff:GetID());					--����
	g_BOOT:SetActionItem(ActionBoot:GetID());					--Ь
	g_SASH:SetActionItem(ActionSash:GetID());					--����
	g_RING:SetActionItem(ActionRing:GetID());					--����
	g_NECKLACE:SetActionItem(ActionNecklace:GetID());	--����
	g_Dark:SetActionItem(ActionDark:GetID());				--����
	g_Charm:SetActionItem(ActionCharm:GetID());		-- ����
	g_Charm2:SetActionItem(ActionCharm2:GetID());		-- ����2
	g_Shoulder:SetActionItem(ActionShoulder:GetID());		-- ����
	g_Glove:SetActionItem(ActionGlove:GetID());		-- ����
	g_Ring2:SetActionItem(ActionRing2:GetID());		-- ��ָ2
	g_FashionDress:SetActionItem(ActionDress:GetID());		-- ʱװ

end

----------------------------------------------------------------------------------
--
-- ��ת���ģ�ͣ�����)
--
function TargetEquip_Modle_TurnLeft(start)
	--������ת��ʼ
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		TargetEquip_FakeObject:RotateBegin(-0.3);
	--������ת����
	else
		TargetEquip_FakeObject:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
-- ��ת���ģ�ͣ�����)
--
function TargetEquip_Modle_TurnRight(start)
	--������ת��ʼ
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		TargetEquip_FakeObject:RotateBegin(0.3);
	--������ת����
	else
		TargetEquip_FakeObject:RotateEnd();
	end
end

----------------------------------------------------------------------------------------
--
-- �رս���
--

function TargetEquip_CloseUI()
	-- AxTrace(0,1,"asldkfj")
	StopCareObject_TargetEquip(objCared);
	TargetEquip_FakeObject:SetFakeObject("");
	

	CachedTarget:TargetEquip_DestroyUIModel();
end

function Set_To_Private()
		CachedTarget:Set_To_Private(Cur_Name);
end

----------------------------------------------------------------------------------------
--
-- �������Ϣ����
--
function TargetEquip_TargetData_Down()
	Variable:SetVariable("OtherUnionPos", TargetEquip_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPrivatePage("other")
end

function Set_To_Friend()
	DataPool:AddFriend( Friend:GetCurrentTeam(),Cur_Name );
end

function TargetEquip_OtherPet_Down()
	Variable:SetVariable("OtherUnionPos", TargetEquip_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPetFrame("other");
end

function TargetEquip_OtherRide_Down()
	Variable:SetVariable("OtherUnionPos", TargetEquip_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenRidePage("other");
end
--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_TargetEquip(objCaredId)

	g_Object = objCaredId;
	-- AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "TargetEquip");

end
function TargetEquip_TargetWuhun_Switch()
	Variable:SetVariable("OtherUnionPos", TargetEquip_Frame:GetProperty("UnifiedPosition"), 1);
	--SystemSetup:OpenRidePage("other");
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("XSCRIPT")
	Set_XSCRIPT_ScriptID(045002)
	Set_XSCRIPT_Parameter(0,1)
	Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT();
end
--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_TargetEquip(objCaredId)
	this:CareObject(objCaredId, 0, "TargetEquip");
	g_Object = -1;

end
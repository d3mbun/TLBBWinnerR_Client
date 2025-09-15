local g_ItemMax = 0;
local g_ItemIdx = -1;

local CU_MONEY			= 1	-- Ǯ

local objCared = -1;

local g_CameraHeight = 1;     --��Ӱ���߶�
local g_CameraDistance = 2;   --��Ӱ������
local g_CameraPitch = 3;      --��Ӱ���Ƕ�

-- ��ҪΪһЩ�������ϵ��Դ�Ч���������������λ��

local g_MountXueYuID = 39;	--����ѩ���id
local g_MountMingYuID = 44;	--����ڤ���id
local g_MountHuanYuID = 62;	--��������id
local g_MountJuYuanID = 52;	--�����Գ��id
local g_MountDaFengID = 41; --�������id

--�ף�����ף�������
local g_MountWuDang = {5,14,55}
--�񣬰׵���Ӱ��
local g_MountTianShan = {3,12,53}
--����׷������
local g_MountEMei = {6,15,54}

--����ӥ,����ӥ,����ӥ
local g_MountAFanDa = {73,74,75}

local g_Shop_Fitting_Frame_UnifiedPosition;

function Shop_Fitting_PreLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("OPEN_SHOP_FITTING");
	this:RegisterEvent("CLOSE_SHOP_FITTING");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("SEX_CHANGED");

	-- FakeObjectģ�ͽ��滥��
	this:RegisterEvent("OPEN_EQUIP");										-- ��ɫ���Ͻ���
	this:RegisterEvent("OPEN_DRESS_PAINT_FITTING");			-- ʱװȾɫ���¼�
	this:RegisterEvent("OPEN_DRESS_ENCHASE_FITTING");		-- ʱװ��Ƕ���¼�
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
end

function Shop_Fitting_OnLoad()
g_Shop_Fitting_Frame_UnifiedPosition= Shop_Fitting_Frame:GetProperty("UnifiedPosition");
end


function ShopFitting_OnHiden()
	SetDefaultMouse();
	RestoreShopFitting();
	this:Hide();
end

function Shop_Fitting_OnEvent(event)

	if ( event == "PLAYER_ENTERING_WORLD" ) then
		Shop_Fitting_Booth_Close();
	end

	-- FakeObjectģ�ͽ��滥��
	if ( event == "OPEN_EQUIP" ) or												-- ��ɫ���Ͻ���
		 ( event == "OPEN_DRESS_PAINT_FITTING" ) or					-- ʱװȾɫ���¼�
		 ( event == "OPEN_DRESS_ENCHASE_FITTING" ) then			-- ʱװ��Ƕ���¼�
		if (this:IsVisible()) then
			RestoreShopFitting();
			this:Hide();
		end
	end

	if(event == "OPEN_SHOP_FITTING") then
		this:Show();
		
		objCared = NpcShop:GetNpcId();
		this:CareObject(objCared, 1, "Shop_Fitting");
	
		Shop_Fitting_FakeObject:SetFakeObject("");	
		Shop_Fitting_FakeObject:SetFakeObject("EquipChange_Player");
		
		local nMountID = GetMountID();
		if g_MountXueYuID == nMountID or g_MountMingYuID == nMountID or g_MountHuanYuID == nMountID or g_MountJuYuanID == nMountID then   --��������Ƚ����⣬���������������λ��
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == g_MountWuDang[1] or nMountID == g_MountWuDang[2]  then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == g_MountWuDang[3] or nMountID == g_MountTianShan[3] then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,3);
		elseif nMountID == g_MountTianShan[1] or nMountID == g_MountTianShan[2] then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == g_MountEMei[1] or nMountID == g_MountEMei[2] or nMountID == g_MountEMei[3] then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,3);
		elseif nMountID == g_MountDaFengID then     --�������
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,23);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,4);
		elseif nMountID == g_MountAFanDa[1] or nMountID == g_MountAFanDa[2] or nMountID == g_MountAFanDa[3] then
			--����ӥ,����ӥ,����ӥ
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,15);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,3);
		elseif nMountID > 0 then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);	
		end

	end
		
	if(event == "CLOSE_SHOP_FITTING") then
		RestoreShopFitting();
		this:Hide();
	end
		
	if (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--��������˵ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			--ȡ������
			RestoreShopFitting();
			this:CareObject(objCared, 0, "Shop_Fitting");
			this:Hide();			
		end
	end

	if event == "SEX_CHANGED" and  this:IsVisible() then
		Shop_Fitting_FakeObject : Hide();
		Shop_Fitting_FakeObject : Show();
		Shop_Fitting_FakeObject:SetFakeObject("EquipChange_Player");

		local nMountID = GetMountID();
		if g_MountXueYuID == nMountID or g_MountMingYuID == nMountID or g_MountHuanYuID == nMountID or g_MountJuYuanID == nMountID then   --��������Ƚ����⣬���������������λ��
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == g_MountWuDang[1] or nMountID == g_MountWuDang[2]  then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == g_MountWuDang[3] or nMountID == g_MountTianShan[3] then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,3);
		elseif nMountID == g_MountTianShan[1] or nMountID == g_MountTianShan[2] then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == g_MountEMei[1] or nMountID == g_MountEMei[2] or nMountID == g_MountEMei[3] then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,3);
		elseif nMountID == g_MountDaFengID then     --�������
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,23);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,4);
		elseif nMountID == g_MountAFanDa[1] or nMountID == g_MountAFanDa[2] or nMountID == g_MountAFanDa[3] then
			--����ӥ,����ӥ,����ӥ
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,15);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,3);
		elseif nMountID > 0 then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);	
		end

	end
	
	if (event == "ADJEST_UI_POS" ) then
		Shop_Fitting_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Shop_Fitting_Frame_On_ResetPos()
	end
		

end

function Shop_Fitting_Booth_Close()
	
	--ȡ������
	this:CareObject(objCared, 0, "Shop_Fitting");
	RestoreShopFitting();
	CloseShopFitting();
	this:Hide();
end


function Shop_Fitting_Accept_Clicked()

	this:Hide();
end

function Shop_Fitting_TextChanged()

	
end


----------------------------------------------------------------------------------
--
-- ��ת����ͷ��ģ�ͣ�����)
--
function Shop_Fitting_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--������ת��ʼ
		if(start == 1) then
			Shop_Fitting_FakeObject:RotateBegin(-0.3);
		--������ת����
		else
			Shop_Fitting_FakeObject:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
--��ת����ͷ��ģ�ͣ�����)
--
function Shop_Fitting_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--������ת��ʼ
		if(start == 1) then
			Shop_Fitting_FakeObject:RotateBegin(0.3);
		--������ת����
		else
			Shop_Fitting_FakeObject:RotateEnd();
		end
	end
end

function Shop_Fitting_Frame_On_ResetPos()
  Shop_Fitting_Frame:SetProperty("UnifiedPosition", g_Shop_Fitting_Frame_UnifiedPosition);
end
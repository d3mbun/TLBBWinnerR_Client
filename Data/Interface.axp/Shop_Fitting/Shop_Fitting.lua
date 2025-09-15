local g_ItemMax = 0;
local g_ItemIdx = -1;

local CU_MONEY			= 1	-- 钱

local objCared = -1;

local g_CameraHeight = 1;     --摄影机高度
local g_CameraDistance = 2;   --摄影机距离
local g_CameraPitch = 3;      --摄影机角度

-- 需要为一些在坐骑上的试穿效果单独设置摄像机位置

local g_MountXueYuID = 39;	--座骑雪羽的id
local g_MountMingYuID = 44;	--座骑冥羽的id
local g_MountHuanYuID = 62;	--座骑幻羽的id
local g_MountJuYuanID = 52;	--座骑巨猿的id
local g_MountDaFengID = 41; --座骑大风的id

--鹤，金翼鹤，瑞莲鹤
local g_MountWuDang = {5,14,55}
--雕，白雕，鹜影雕
local g_MountTianShan = {3,12,53}
--青凤，红白凤，琉璃凤
local g_MountEMei = {6,15,54}

--赤魅鹰,暗魅鹰,紫魅鹰
local g_MountAFanDa = {73,74,75}

local g_Shop_Fitting_Frame_UnifiedPosition;

function Shop_Fitting_PreLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("OPEN_SHOP_FITTING");
	this:RegisterEvent("CLOSE_SHOP_FITTING");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("SEX_CHANGED");

	-- FakeObject模型界面互斥
	this:RegisterEvent("OPEN_EQUIP");										-- 角色资料界面
	this:RegisterEvent("OPEN_DRESS_PAINT_FITTING");			-- 时装染色试衣间
	this:RegisterEvent("OPEN_DRESS_ENCHASE_FITTING");		-- 时装镶嵌试衣间
	
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

	-- FakeObject模型界面互斥
	if ( event == "OPEN_EQUIP" ) or												-- 角色资料界面
		 ( event == "OPEN_DRESS_PAINT_FITTING" ) or					-- 时装染色试衣间
		 ( event == "OPEN_DRESS_ENCHASE_FITTING" ) then			-- 时装镶嵌试衣间
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
		if g_MountXueYuID == nMountID or g_MountMingYuID == nMountID or g_MountHuanYuID == nMountID or g_MountJuYuanID == nMountID then   --翅膀的试骑比较特殊，单独设置摄像机的位置
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
		elseif nMountID == g_MountDaFengID then     --大风坐骑
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,23);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,4);
		elseif nMountID == g_MountAFanDa[1] or nMountID == g_MountAFanDa[2] or nMountID == g_MountAFanDa[3] then
			--赤魅鹰,暗魅鹰,紫魅鹰
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
		
		--如果和商人的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			--取消关心
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
		if g_MountXueYuID == nMountID or g_MountMingYuID == nMountID or g_MountHuanYuID == nMountID or g_MountJuYuanID == nMountID then   --翅膀的试骑比较特殊，单独设置摄像机的位置
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
		elseif nMountID == g_MountDaFengID then     --大风坐骑
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,23);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,4);
		elseif nMountID == g_MountAFanDa[1] or nMountID == g_MountAFanDa[2] or nMountID == g_MountAFanDa[3] then
			--赤魅鹰,暗魅鹰,紫魅鹰
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
	
	--取消关心
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
-- 旋转人物头像模型（向左)
--
function Shop_Fitting_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向左旋转开始
		if(start == 1) then
			Shop_Fitting_FakeObject:RotateBegin(-0.3);
		--向左旋转结束
		else
			Shop_Fitting_FakeObject:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
--旋转人物头像模型（向右)
--
function Shop_Fitting_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向右旋转开始
		if(start == 1) then
			Shop_Fitting_FakeObject:RotateBegin(0.3);
		--向右旋转结束
		else
			Shop_Fitting_FakeObject:RotateEnd();
		end
	end
end

function Shop_Fitting_Frame_On_ResetPos()
  Shop_Fitting_Frame:SetProperty("UnifiedPosition", g_Shop_Fitting_Frame_UnifiedPosition);
end
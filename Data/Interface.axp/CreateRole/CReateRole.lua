----------------------------------------------------------------------------------------------------------------
--
-- È«¾Ö±äÁ¿¶¨Òå
--

-- Ã¿Ò»Ò³ÖÐÍ·ÏñµÄ¸öÊý.
local g_iFaceCountInPage = 9;

local g_iFaceIndexInPage = -1;         --by chengy TT52805

-- µ±Ç°Ñ¡ÔñµÄÐÔ±ð
local iCurSelSex = 0;			-- 0 : Å®
													-- 1 : ÄÐ
--Á³ÐÎ¿Ø¼þ
local g_FaceSel = {};

--µ±Ç°Ñ¡ÔñµÄÒ³Êý
local g_FacePageCount = 0;

-- µ±Ç°µÃµ½Á³ÐÎµÄ¸öÊý
local g_iCurFaceCount = 0;

-- µ±Ç°Ñ¡ÔñµÄÍ·ÏñµÄË÷Òý
local g_iCurSelFaceIndex = 0;

-- µ±Ç°Ñ¡ÔñµÄÁ³ÐÎ
local g_iCurSelFaceIndex    = 0;
local g_iCurSelFaceIndexOld = 0;

-- µ±Ç°Ñ¡ÔñµÄ·¢ÐÍ
local g_iCurSelHairIndex    = 0;
local g_iCurSelHairIndexOld = 0;

-- µ±Ç°Ñ¡ÔñµÄÌ××°2006-6-2
local g_iCurSelEquipSetIndex    = 0;
local g_iCurSelEquipSetIndexOld = 0;

local MaxEquipIndex = 9

local g_FaceModel = {}
local g_iCurSelectFace = 0

-----------------------------------------------------------------------------------------------------------------
--
-- º¯Êý¶¨Òå
--

function LoginCreateRole_PreLoad()
	-- ´ò¿ª½çÃæ
	this:RegisterEvent("GAMELOGIN_OPEN_CREATE_CHARACTOR");
	
	-- ¹Ø±Õ½çÃæ
	this:RegisterEvent("GAMELOGIN_CLOSE_CREATE_CHARACTOR");
	
	-- Çå¿Õ´´½¨½ÇÉ«Ãû×Ö¡£
	this:RegisterEvent("GAMELOGIN_CREATE_CLEAR_NAME");

end

-- ×¢²áonLoadÊÂ¼þ
function LoginCreateRole_OnLoad()
	
	CreateRole_SelectSex_Girl:SetText("Næ");
	CreateRole_SelectSex_Boy:SetText("Nam");
	
	CreateRole_SelectSex_Girl:SetProperty("CheckMode", "1");	
	CreateRole_SelectSex_Boy:SetProperty("CheckMode", "1");	
	
	-- Í·ÏñÑ¡Ôñ°´Å¥
	g_FaceSel[0] = CreateRole_Select_HeadImage1;
	g_FaceSel[1] = CreateRole_Select_HeadImage2;
	g_FaceSel[2] = CreateRole_Select_HeadImage3;
	g_FaceSel[3] = CreateRole_Select_HeadImage4;
	g_FaceSel[4] = CreateRole_Select_HeadImage5;
	g_FaceSel[5] = CreateRole_Select_HeadImage6;
	g_FaceSel[6] = CreateRole_Select_HeadImage7;
	g_FaceSel[7] = CreateRole_Select_HeadImage8;
	g_FaceSel[8] = CreateRole_Select_HeadImage9;
	
	for i=0, 20  do
		g_FaceModel[i] = -1
	end	
	
	-- µÃµ½Á³ÐÎÐÅÏ¢
	CreateRole_GetFaceModel();
	
	-- µÃµ½·¢ÐÍÐÅÏ¢
	CreateRole_GetHairModel();
	
	-- µÃµ½Ì××°ÐÅÏ¢
	CreateRole_GetNewRoleEquipSet();
	
	-- Ëæ»úÑ¡ÔñÒ»¸öÐÂÊÖ×°¡£
	local RandVal = math.random( 0, MaxEquipIndex )
	g_iCurSelEquipSetIndex = RandVal
	
	CreateRole_SelEquipSet(g_iCurSelEquipSetIndex);

end

-- OnEvent
function LoginCreateRole_OnEvent(event)

	if( event == "GAMELOGIN_OPEN_CREATE_CHARACTOR" ) then
	
		CreateRole_Name:SetProperty("DefaultEditBox", "True");
		this:Show();
		if(0 == iCurSelSex) then
			-- Ñ¡ÔñÅ®Ö÷½Ç.
			CreateRole_SelectGirl();
		elseif(1 == iCurSelSex) then
			-- Ñ¡ÔñÄÐÖ÷½Ç.
			CreateRole_SelectBoy();
		end
		
		-- ÏÔÊ¾Í·Ïñ.
		CreateRole_ShowRoleFace(iCurSelSex);
		
		return;
	end
		
	if( event == "GAMELOGIN_CLOSE_CREATE_CHARACTOR") then
		
		CreateRole_Name:SetProperty("DefaultEditBox", "False");
		this:Hide();
		return;
	end
	
	if( event == "GAMELOGIN_CREATE_CLEAR_NAME") then
		
		CreateRole_Name:SetText("");
		return;
	end
	
 		
end


---------------------------------------------------------------------------------------------------------
--
-- ¸ü¶àÁ³ÐÎ
--
function CreateRole_BnClickMoreFace()
			
end			

---------------------------------------------------------------------------------------------------------
--
-- ´´½¨½ÇÉ«
--
function CreateRole_BnClickCreateRole()

	if g_iFaceIndexInPage < 0 then          --by chengy TT52805
		GameProduceLogin:GameLoginShowSystemInfo("#{DLXZ_100409_1}");
		return;
	end
	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + g_iFaceIndexInPage;

	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then

		g_iCurSelFaceIndex = -1;
		--return;
	end;
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);

	local strImageName = "";
	strImageName = GameProduceLogin:GetFaceName(iCurSelSex, g_iCurSelFaceIndex);
	if strImageName == "" then
		GameProduceLogin:GameLoginShowSystemInfo("#{DLXZ_090711_1}");
		return;
	end
	
	local szName = CreateRole_Name:GetText();
	GameProduceLogin:CreateRole(szName, iCurSelSex);
end


---------------------------------------------------------------------------------------------------------
--
-- »Øµ½ÈËÎïÑ¡Ôñ½çÃæ
--
function CreateRole_BnClickReturnSelectRole()

	-- ´ÓÈËÎï´´½¨½çÃæ·µ»Øµ½ÈËÎïÑ¡Ôñ½çÃæ.
	GameProduceLogin:ChangeToSelectRoleDlgFromCreateRole();
end


---------------------------------------------------------------------------------------------------------
--
-- Ñ¡ÔñÅ®
--
function CreateRole_SelectGirl()

	CreateRole_Model:SetFakeObject("");
	CreateRole_Model:SetFakeObject("CreateRole_Woman");
	CreateRole_SelectSex_Girl:SetCheck(1);
	
	-- Ñ¡ÔñÅ®
	iCurSelSex = 0;
	
	-- ÏÔÊ¾µÚÒ»Ò³
	g_FacePageCount = 0;
	
	-- ÏÔÊ¾Í·Ïñ.
	CreateRole_ShowRoleFace(iCurSelSex);
	
	-- Ñ¡ÔñµÚÒ»¸öÁ³ÐÎ
	CreateRole_BnSelFace1();
	
	-- ÉèÖÃÍ·Ïñ°´Å¥×´Ì¬
	CreateRole_SetFacePageStatus();
	
	-- ÏÔÊ¾Á³ÐÎÄ£ÐÍ
	CreateRole_GetFaceModel();
	
	-- µÃµ½·¢ÐÍÐÅÏ¢
	CreateRole_GetHairModel();
	
	-- µ±Ç°Ñ¡ÔñµÄÁ³ÐÎ
	g_iCurSelFaceIndex = 0;

	-- µ±Ç°Ñ¡ÔñµÄ·¢ÐÍ
	g_iCurSelHairIndex = 0;
	
	-- Ñ¡ÔñµÚÒ»¸ö·¢ÐÍ
	CreateRole_SelHairModel(g_iCurSelHairIndex);
	
	-- ½çÃæÑ¡ÔñÒ»¸öÏÂÀ­ÁÐ±í
	CreateRole_SelectFace:SetCurrentSelect(0);
	-- Ñ¡ÔñµÚÒ»¸öÁ³ÐÎ
	CreateRole_SelFaceModel(g_FaceModel[0]);
	
	-- ¸Ä±äÐÂÊÖ×°
	
	-- Ëæ»úÑ¡ÔñÒ»¸öÐÂÊÖ×°¡£
	local RandVal = math.random( 0, MaxEquipIndex )
	g_iCurSelEquipSetIndex = RandVal
	
	CreateRole_SelEquipSet(g_iCurSelEquipSetIndex);	
	
	GameProduceLogin:ChangeNewRoleEquipSet(iCurSelSex, g_iCurSelEquipSetIndex);
	
end


---------------------------------------------------------------------------------------------------------
--
-- Ñ¡ÔñÄÐ
--			
function CreateRole_SelectBoy()

	CreateRole_Model:SetFakeObject("");
	CreateRole_Model:SetFakeObject("CreateRole_Man");
	CreateRole_SelectSex_Boy:SetCheck(1);
	
	-- Ñ¡ÔñÄÐ
	iCurSelSex = 1;
	
	-- ÏÔÊ¾µÚÒ»Ò³
	g_FacePageCount = 0;
	
	-- ÏÔÊ¾Í·Ïñ.
	CreateRole_ShowRoleFace(iCurSelSex);
	
	-- Ñ¡ÔñµÚÒ»¸öÁ³ÐÎ
	CreateRole_BnSelFace1();
	
	-- ÉèÖÃÍ·Ïñ°´Å¥×´Ì¬
	CreateRole_SetFacePageStatus();
	
	-- ÏÔÊ¾Á³ÐÎÄ£ÐÍ
	CreateRole_GetFaceModel();
	
	-- µÃµ½·¢ÐÍÐÅÏ¢
	CreateRole_GetHairModel();
	
	-- µ±Ç°Ñ¡ÔñµÄÁ³ÐÎ
	g_iCurSelFaceIndex = 0;

	-- µ±Ç°Ñ¡ÔñµÄ·¢ÐÍ
	g_iCurSelHairIndex = 0;
	
	-- Ñ¡ÔñµÚÒ»¸ö·¢ÐÍ
	CreateRole_SelHairModel(g_iCurSelHairIndex);
	
	CreateRole_SelectFace:SetCurrentSelect(0);
	-- Ñ¡ÔñµÚÒ»¸öÁ³ÐÎ
	CreateRole_SelFaceModel(g_FaceModel[0]);
	
	-- ¸Ä±äÐÂÊÖ×°
	-- Ëæ»úÑ¡ÔñÒ»¸öÐÂÊÖ×°¡£
	local RandVal = math.random( 0, MaxEquipIndex )
	g_iCurSelEquipSetIndex = RandVal
	
	CreateRole_SelEquipSet(g_iCurSelEquipSetIndex);	
		
	GameProduceLogin:ChangeNewRoleEquipSet(iCurSelSex, g_iCurSelEquipSetIndex);

end

---------------------------------------------------------------------------------------------------------
--
-- ÏÔÊ¾Ö÷½ÇÍ·Ïñ
--			
function CreateRole_ShowRoleFace(iType)

	-- Çå¿ÕÍ·ÏñÊý¾Ý.
	CreateRole_ClearImageData();
	if(0 == iType) then
	
		g_iCurFaceCount = GameProduceLogin:GetWomanFaceCount();
	elseif(1 == iType) then
	
		g_iCurFaceCount = GameProduceLogin:GetManFaceCount();
	end
	
	-- Ë¢ÐÂµ±Ç°Ò³
	CreateRole_RefreshCurShowFacePage();
	
		CreateRole_SetFacePageStatus();
	
	
end

---------------------------------------------------------------------------------------------------------
--
-- ÏÔÊ¾Ö÷½ÇÍ·Ïñ
--			
function CreateRole_ClearImageData()

	CreateRole_PageUp:Disable();
	CreateRole_PageDown:Disable();
	
	local strImageName = "";
	for index = 0, 8 do
	 		
		g_FaceSel[index]:SetProperty("Image", strImageName);
	end
	
end


---------------------------------------------------------------------------------------------------------
--
-- Ë¢ÐÂµ±Ç°ÏÔÊ¾µÄÍ·ÏñÒ³
--
function CreateRole_RefreshCurShowFacePage()

	-- Çå¿ÕÍ¼ÏñÊý¾Ý
	CreateRole_ClearImageData();
	
	-- µ±Ç°¿ªÊ¼ÏÔÊ¾Í·ÏñµÄÎ»ÖÃ
	local iCurStart = g_FacePageCount * g_iFaceCountInPage;
	
	-- µ±Ç°ÏÔÊ¾Í·Ïñ½áÊøµÄÎ»ÖÃ
	local iCurEnd   = iCurStart + g_iFaceCountInPage;
	if(iCurEnd > g_iCurFaceCount) then
	
		iCurEnd = g_iCurFaceCount;
	end;
	
	
	local strImageName = "";
	for index = iCurStart, iCurEnd - 1 do
	 		
		strImageName = GameProduceLogin:GetFaceName(iCurSelSex, index);
		g_FaceSel[index - iCurStart]:SetProperty("Image", strImageName);
	end
end

---------------------------------------------------------------------------------------------------------
--
-- Ö÷½ÇÍ·ÏñÉÏ·­Ò»Ò³
--
function CreateRole_BnClickFacePageUp()
	
	
	
	g_FacePageCount = g_FacePageCount - 1;
	
	if(g_FacePageCount < 0) then
	
		g_FacePageCount = 0;
		return;
	end
	
	-- Ë¢ÐÂµ±Ç°ÏÔÊ¾µÄfaceÒ³
	CreateRole_RefreshCurShowFacePage();
	
	-- ÉèÖÃÍ·Ïñ°´Å¥×´Ì¬
	CreateRole_SetFacePageStatus();
	
end


---------------------------------------------------------------------------------------------------------
--
-- Ö÷½ÇÍ·ÏñÏÂ·­Ò»Ò³
--
function CreateRole_BnClickFacePageDown()
	
	
	
	g_FacePageCount = g_FacePageCount + 1;
	
	if(g_FacePageCount * g_iFaceCountInPage >= g_iCurFaceCount) then
	
		g_FacePageCount = g_FacePageCount - 1;
		return;
	end;
	
	-- Ë¢ÐÂµ±Ç°ÏÔÊ¾µÄfaceÒ³
	CreateRole_RefreshCurShowFacePage();
	
	-- ÉèÖÃÍ·Ïñ°´Å¥×´Ì¬
	CreateRole_SetFacePageStatus();
	
end


---------------------------------------------------------------------------------------------------------
--
-- Ñ¡ÔñÍ·Ïñ1
--
function CreateRole_BnSelFace1()

	g_iFaceIndexInPage = 0;

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- Í¨¹ýÐÔ±ðºÍË÷ÒýÉèÖÃÍ·Ïñid
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end

---------------------------------------------------------------------------------------------------------
--
-- Ñ¡ÔñÍ·Ïñ2
--
function CreateRole_BnSelFace2()

	g_iFaceIndexInPage = 1;

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 1;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- Í¨¹ýÐÔ±ðºÍË÷ÒýÉèÖÃÍ·Ïñid
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end


---------------------------------------------------------------------------------------------------------
--
-- Ñ¡ÔñÍ·Ïñ3
--
function CreateRole_BnSelFace3()

	g_iFaceIndexInPage = 2;

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 2;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- Í¨¹ýÐÔ±ðºÍË÷ÒýÉèÖÃÍ·Ïñid
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end

---------------------------------------------------------------------------------------------------------
--
-- Ñ¡ÔñÍ·Ïñ4
--
function CreateRole_BnSelFace4()

	g_iFaceIndexInPage = 3;

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 3;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- Í¨¹ýÐÔ±ðºÍË÷ÒýÉèÖÃÍ·Ïñid
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end

---------------------------------------------------------------------------------------------------------
--
-- Ñ¡ÔñÍ·Ïñ5
--
function CreateRole_BnSelFace5()

	g_iFaceIndexInPage = 4;

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 4;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- Í¨¹ýÐÔ±ðºÍË÷ÒýÉèÖÃÍ·Ïñid
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end

---------------------------------------------------------------------------------------------------------
--
-- Ñ¡ÔñÍ·Ïñ6
--
function CreateRole_BnSelFace6()

	g_iFaceIndexInPage = 5;

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 5;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- Í¨¹ýÐÔ±ðºÍË÷ÒýÉèÖÃÍ·Ïñid
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end

---------------------------------------------------------------------------------------------------------
--
-- Ñ¡ÔñÍ·Ïñ7
--
function CreateRole_BnSelFace7()
	
	g_iFaceIndexInPage = 6;
	
	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 6;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- Í¨¹ýÐÔ±ðºÍË÷ÒýÉèÖÃÍ·Ïñid
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end

---------------------------------------------------------------------------------------------------------
--
-- Ñ¡ÔñÍ·Ïñ8
--
function CreateRole_BnSelFace8()

	g_iFaceIndexInPage = 7;

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 7;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- Í¨¹ýÐÔ±ðºÍË÷ÒýÉèÖÃÍ·Ïñid
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end

---------------------------------------------------------------------------------------------------------
--
-- Ñ¡ÔñÍ·Ïñ9
--
function CreateRole_BnSelFace9()

	g_iFaceIndexInPage = 8;

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 8;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- Í¨¹ýÐÔ±ðºÍË÷ÒýÉèÖÃÍ·Ïñid
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end


---------------------------------------------------------------------------------------------------------
--
-- ÉèÖÃÍ·Ïñ°´Å¥µÄ×´Ì¬
--
function CreateRole_SetFacePageStatus()

	-- Í·ÏñÏòÉÏ·­Ò³°´Å¥
	local PageCount = g_FacePageCount;
	PageCount = PageCount - 1;
	if(PageCount < 0) then
	
		CreateRole_PageUp:Disable();
	else
	
		CreateRole_PageUp:Enable();
	end
	
	
	PageCount = g_FacePageCount;
	-- Í·ÏñÏòÏÂ·­Ò³°´Å¥
	PageCount = PageCount + 1;
	if(PageCount * g_iFaceCountInPage >= g_iCurFaceCount) then
	
		CreateRole_PageDown:Disable();
	else
		CreateRole_PageDown:Enable();
	end;
	
end


-----------------------------------------------------------------------------------------------------------
--
-- Ñ¡ÔñÐÂµÄ·¢ÐÍ
--
function CreateRole_ComboListSelectHairChanged()

  local strMeshName = "";
  strMeshName
	,g_iCurSelHairIndex = CreateRole_SelectHair:GetCurrentSelect();
	
	--AxTrace( 0,0, "==Ñ¡Ôñ·¢ÐÍË÷Òý"..tostring(g_iCurSelHairIndex));
	--if(g_iCurSelHairIndexOld == g_iCurSelHairIndex) then
		
	--	return;
	--end
	g_iCurSelHairIndexOld = g_iCurSelHairIndex;

	CreateRole_SelHairModel(g_iCurSelHairIndex);
	
end
	
-----------------------------------------------------------------------------------------------------------
--
-- Ñ¡ÔñÐÂµÄÁ³ÐÍ
--	
function CreateRole_ComboListSelectFaceChanged()
	
	local strMeshName = "";
	 
	strMeshName
	,g_iCurSelectFace = CreateRole_SelectFace:GetCurrentSelect();
	--AxTrace( 0,0, "==Ñ¡ÔñÁ³ÐÍË÷Òý"..tostring(g_iCurSelFaceIndex));
	
	--if(g_iCurSelFaceIndexOld == g_iCurSelFaceIndex) then
		
	--	return;
	--end
	--g_iCurSelFaceIndexOld = g_iCurSelFaceIndex;
	
	CreateRole_SelFaceModel(g_FaceModel[g_iCurSelectFace]);
	
end


-----------------------------------------------------------------------------------------------------------
--
-- µÃµ½Á³ÐÎÊý¾Ý
--	
function CreateRole_GetFaceModel()
	
	-- Çå¿ÕÊý¾Ý
	CreateRole_SelectFace:ResetList();
	
	local iFaceCount = GameProduceLogin:GetFaceModelCount(iCurSelSex);
	local strFaceModelName = "";

	local j=0
	for index = 0, iFaceCount - 1 do
		if GameProduceLogin:GetFaceModelInfo(iCurSelSex, index) == 3  or
		   GameProduceLogin:GetFaceModelInfo(iCurSelSex, index) == 1  then
			strFaceModelName = GameProduceLogin:GetFaceModelName(iCurSelSex, index);
			CreateRole_SelectFace:ComboBoxAddItem(strFaceModelName, j);
			g_FaceModel[j] = index
			j = j+1
		end
	end;

end


-----------------------------------------------------------------------------------------------------------
--
-- µÃµ½·¢ÐÎÊý¾Ý
--	
function CreateRole_GetHairModel()
	
	-- Çå¿ÕÊý¾Ý
	CreateRole_SelectHair:ResetList();
	
	local iHairCount = GameProduceLogin:GetHairModelCount(iCurSelSex);
	local strHairModelName = "";

	for index = 0, iHairCount - 1 do
	
		strHairModelName = GameProduceLogin:GetHairModelName(iCurSelSex, index);
		CreateRole_SelectHair:ComboBoxAddItem(strHairModelName, index);
	end;

end


-----------------------------------------------------------------------------------------------------------
--
-- Ñ¡Ôñ·¢ÐÍ
--	
function CreateRole_SelHairModel(index)
	
	--AxTrace( 0,0, "==Ñ¡Ôñ·¢ÐÍ"..tostring(index));
	CreateRole_SelectHair:SetCurrentSelect(index);
	GameProduceLogin:SetHairModelId(iCurSelSex, index);

end


-----------------------------------------------------------------------------------------------------------
--
-- Ñ¡ÔñÁ³ÐÎ
--	
function CreateRole_SelFaceModel(index)
	
	--AxTrace( 0,0, "==Ñ¡ÔñÁ³ÐÎ"..tostring(index));
	--CreateRole_SelectFace:SetCurrentSelect(index);
	GameProduceLogin:SetFaceModelId(iCurSelSex, index);

end


function CreateRole_Name_MouseEnter()

	CreateRole_Info:SetText("Ðång nhâp tên nhân v§t");

end

function CreateRole_MouseLeave()

	CreateRole_Info:SetText("");
end

function CreateRole_SelectHair_MouseEnter()
	
	--AxTrace( 0,0, "<==?Ñ¡Ôñ·¢ÐÍ");
	CreateRole_Info:SetText("Lña ch÷n cho các hÕ ki¬u tóc nhân v§t");
end


function CreateRole_SelectFace_MouseEnter()
	
	--AxTrace( 0,0, "<==?Ñ¡ÔñÁ³ÐÎ");
	CreateRole_Info:SetText("Lña ch÷n cho các hÕ ki¬u m£t nhân v§t");
end

function CreateRole_SelectRace_MouseEnter()

	CreateRole_Info:SetText("Lña ch÷n cho các hÕ gi¾i tính nhân v§t");
end

function CreateRole_SelectHead_MouseEnter()

	CreateRole_Info:SetText("Lña ch÷n cho các hÕ änh nhân v§t");
end

function CreateRole_CreateRole_MouseEnter()

	CreateRole_Info:SetText("TÕo nhân v§t");
end

function CreateRole_Last_MouseEnter()

	CreateRole_Info:SetText("Quay tr· lÕi trang giao di®n lña ch÷n nhân v§t");
end

----------------------------------------------------------------------------------
--
-- Ðý×ªÈËÎïÄ£ÐÍ£¨Ïò×ó)
--
function CreateRole_Modle_TurnLeft(start)
	--Ïò×óÐý×ª¿ªÊ¼
	if(start == 1) then
		--CreateRole_Model:RotateBegin(-0.3);
                GameProduceLogin:ModelRotBegin(-1.0)
	--Ïò×óÐý×ª½áÊø
	else
		--CreateRole_Model:ModelRotEnd( 0 );
                GameProduceLogin:ModelRotEnd( 0.0 )
	end
end

----------------------------------------------------------------------------------
--
--Ðý×ªÈËÎïÄ£ÐÍ£¨ÏòÓÒ)
--
function CreateRole_Modle_TurnRight(start)
	--ÏòÓÒÐý×ª¿ªÊ¼
	if(start == 1) then
		--CreateRole_Model:RotateBegin(0.3);
                GameProduceLogin:ModelRotBegin(1.0)
	--ÏòÓÒÐý×ª½áÊø
	else
		--CreateRole_Model:RotateEnd();
                GameProduceLogin:ModelRotEnd( 0.0 )
	end
end



-----------------------------------------------------------------------------------------------------------
--
-- µÃµ½Ì××°Êý¾Ý
--	
function CreateRole_GetNewRoleEquipSet()
	
	-- Çå¿ÕÊý¾Ý
	CreateRole_SelectClothin:ResetList();
	
	local iCount = GameProduceLogin:GetEquipSetCount();
	--AxTrace( 0,0, "µÃµ½Ì××°¸öÊý £½ "..tostring(iCount));
	
	local strShowName = "";
	for index = 0, iCount - 1 do
	
		strShowName = GameProduceLogin:GetEquipSetName(index);
		--AxTrace( 0,0, "µÃµ½Ì××°Ãû×Ö £½ "..tostring(strShowName));
		CreateRole_SelectClothin:ComboBoxAddItem(strShowName, index);
	end;

end


-----------------------------------------------------------------------------------------------------------
--
-- Ñ¡Ôñ·¢ÐÍ
--	
function CreateRole_SelEquipSet(index)
	
	CreateRole_SelectClothin:SetCurrentSelect(index);

end


function CreateRole_ComboListSelectClothin()

	local strMeshName = "";
		 
	strMeshName
	,g_iCurSelEquipSetIndex = CreateRole_SelectClothin:GetCurrentSelect();
	
	g_iCurSelEquipSetIndexOld = g_iCurSelEquipSetIndex;
	
	--AxTrace( 0,0, "Ñ¡ÔñÌ××° £½ "..tostring(g_iCurSelEquipSetIndex));
	CreateRole_SelEquipSet(g_iCurSelEquipSetIndex);
	
	-- ¸Ä±äÐÂÊÖ×°
	GameProduceLogin:ChangeNewRoleEquipSet(iCurSelSex, g_iCurSelEquipSetIndex);

end;

function CreateRole_Modle_ZoomOut( start )
	if(start == 1) then
	    GameProduceLogin:ModelZoom( -1.0 )
	else
	    GameProduceLogin:ModelZoom( 0.0 )
	end
	
end

function CreateRole_Modle_ZoomIn( start )
    if(start == 1) then
         GameProduceLogin:ModelZoom( 1.0 )
	else
	     GameProduceLogin:ModelZoom( 0.0 )
	end
	
end
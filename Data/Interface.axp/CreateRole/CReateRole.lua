----------------------------------------------------------------------------------------------------------------
--
-- ȫ�ֱ�������
--

-- ÿһҳ��ͷ��ĸ���.
local g_iFaceCountInPage = 9;

local g_iFaceIndexInPage = -1;         --by chengy TT52805

-- ��ǰѡ����Ա�
local iCurSelSex = 0;			-- 0 : Ů
													-- 1 : ��
--���οؼ�
local g_FaceSel = {};

--��ǰѡ���ҳ��
local g_FacePageCount = 0;

-- ��ǰ�õ����εĸ���
local g_iCurFaceCount = 0;

-- ��ǰѡ���ͷ�������
local g_iCurSelFaceIndex = 0;

-- ��ǰѡ�������
local g_iCurSelFaceIndex    = 0;
local g_iCurSelFaceIndexOld = 0;

-- ��ǰѡ��ķ���
local g_iCurSelHairIndex    = 0;
local g_iCurSelHairIndexOld = 0;

-- ��ǰѡ�����װ2006-6-2
local g_iCurSelEquipSetIndex    = 0;
local g_iCurSelEquipSetIndexOld = 0;

local MaxEquipIndex = 9

local g_FaceModel = {}
local g_iCurSelectFace = 0

-----------------------------------------------------------------------------------------------------------------
--
-- ��������
--

function LoginCreateRole_PreLoad()
	-- �򿪽���
	this:RegisterEvent("GAMELOGIN_OPEN_CREATE_CHARACTOR");
	
	-- �رս���
	this:RegisterEvent("GAMELOGIN_CLOSE_CREATE_CHARACTOR");
	
	-- ��մ�����ɫ���֡�
	this:RegisterEvent("GAMELOGIN_CREATE_CLEAR_NAME");

end

-- ע��onLoad�¼�
function LoginCreateRole_OnLoad()
	
	CreateRole_SelectSex_Girl:SetText("N�");
	CreateRole_SelectSex_Boy:SetText("Nam");
	
	CreateRole_SelectSex_Girl:SetProperty("CheckMode", "1");	
	CreateRole_SelectSex_Boy:SetProperty("CheckMode", "1");	
	
	-- ͷ��ѡ��ť
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
	
	-- �õ�������Ϣ
	CreateRole_GetFaceModel();
	
	-- �õ�������Ϣ
	CreateRole_GetHairModel();
	
	-- �õ���װ��Ϣ
	CreateRole_GetNewRoleEquipSet();
	
	-- ���ѡ��һ������װ��
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
			-- ѡ��Ů����.
			CreateRole_SelectGirl();
		elseif(1 == iCurSelSex) then
			-- ѡ��������.
			CreateRole_SelectBoy();
		end
		
		-- ��ʾͷ��.
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
-- ��������
--
function CreateRole_BnClickMoreFace()
			
end			

---------------------------------------------------------------------------------------------------------
--
-- ������ɫ
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
-- �ص�����ѡ�����
--
function CreateRole_BnClickReturnSelectRole()

	-- �����ﴴ�����淵�ص�����ѡ�����.
	GameProduceLogin:ChangeToSelectRoleDlgFromCreateRole();
end


---------------------------------------------------------------------------------------------------------
--
-- ѡ��Ů
--
function CreateRole_SelectGirl()

	CreateRole_Model:SetFakeObject("");
	CreateRole_Model:SetFakeObject("CreateRole_Woman");
	CreateRole_SelectSex_Girl:SetCheck(1);
	
	-- ѡ��Ů
	iCurSelSex = 0;
	
	-- ��ʾ��һҳ
	g_FacePageCount = 0;
	
	-- ��ʾͷ��.
	CreateRole_ShowRoleFace(iCurSelSex);
	
	-- ѡ���һ������
	CreateRole_BnSelFace1();
	
	-- ����ͷ��ť״̬
	CreateRole_SetFacePageStatus();
	
	-- ��ʾ����ģ��
	CreateRole_GetFaceModel();
	
	-- �õ�������Ϣ
	CreateRole_GetHairModel();
	
	-- ��ǰѡ�������
	g_iCurSelFaceIndex = 0;

	-- ��ǰѡ��ķ���
	g_iCurSelHairIndex = 0;
	
	-- ѡ���һ������
	CreateRole_SelHairModel(g_iCurSelHairIndex);
	
	-- ����ѡ��һ�������б�
	CreateRole_SelectFace:SetCurrentSelect(0);
	-- ѡ���һ������
	CreateRole_SelFaceModel(g_FaceModel[0]);
	
	-- �ı�����װ
	
	-- ���ѡ��һ������װ��
	local RandVal = math.random( 0, MaxEquipIndex )
	g_iCurSelEquipSetIndex = RandVal
	
	CreateRole_SelEquipSet(g_iCurSelEquipSetIndex);	
	
	GameProduceLogin:ChangeNewRoleEquipSet(iCurSelSex, g_iCurSelEquipSetIndex);
	
end


---------------------------------------------------------------------------------------------------------
--
-- ѡ����
--			
function CreateRole_SelectBoy()

	CreateRole_Model:SetFakeObject("");
	CreateRole_Model:SetFakeObject("CreateRole_Man");
	CreateRole_SelectSex_Boy:SetCheck(1);
	
	-- ѡ����
	iCurSelSex = 1;
	
	-- ��ʾ��һҳ
	g_FacePageCount = 0;
	
	-- ��ʾͷ��.
	CreateRole_ShowRoleFace(iCurSelSex);
	
	-- ѡ���һ������
	CreateRole_BnSelFace1();
	
	-- ����ͷ��ť״̬
	CreateRole_SetFacePageStatus();
	
	-- ��ʾ����ģ��
	CreateRole_GetFaceModel();
	
	-- �õ�������Ϣ
	CreateRole_GetHairModel();
	
	-- ��ǰѡ�������
	g_iCurSelFaceIndex = 0;

	-- ��ǰѡ��ķ���
	g_iCurSelHairIndex = 0;
	
	-- ѡ���һ������
	CreateRole_SelHairModel(g_iCurSelHairIndex);
	
	CreateRole_SelectFace:SetCurrentSelect(0);
	-- ѡ���һ������
	CreateRole_SelFaceModel(g_FaceModel[0]);
	
	-- �ı�����װ
	-- ���ѡ��һ������װ��
	local RandVal = math.random( 0, MaxEquipIndex )
	g_iCurSelEquipSetIndex = RandVal
	
	CreateRole_SelEquipSet(g_iCurSelEquipSetIndex);	
		
	GameProduceLogin:ChangeNewRoleEquipSet(iCurSelSex, g_iCurSelEquipSetIndex);

end

---------------------------------------------------------------------------------------------------------
--
-- ��ʾ����ͷ��
--			
function CreateRole_ShowRoleFace(iType)

	-- ���ͷ������.
	CreateRole_ClearImageData();
	if(0 == iType) then
	
		g_iCurFaceCount = GameProduceLogin:GetWomanFaceCount();
	elseif(1 == iType) then
	
		g_iCurFaceCount = GameProduceLogin:GetManFaceCount();
	end
	
	-- ˢ�µ�ǰҳ
	CreateRole_RefreshCurShowFacePage();
	
		CreateRole_SetFacePageStatus();
	
	
end

---------------------------------------------------------------------------------------------------------
--
-- ��ʾ����ͷ��
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
-- ˢ�µ�ǰ��ʾ��ͷ��ҳ
--
function CreateRole_RefreshCurShowFacePage()

	-- ���ͼ������
	CreateRole_ClearImageData();
	
	-- ��ǰ��ʼ��ʾͷ���λ��
	local iCurStart = g_FacePageCount * g_iFaceCountInPage;
	
	-- ��ǰ��ʾͷ�������λ��
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
-- ����ͷ���Ϸ�һҳ
--
function CreateRole_BnClickFacePageUp()
	
	
	
	g_FacePageCount = g_FacePageCount - 1;
	
	if(g_FacePageCount < 0) then
	
		g_FacePageCount = 0;
		return;
	end
	
	-- ˢ�µ�ǰ��ʾ��faceҳ
	CreateRole_RefreshCurShowFacePage();
	
	-- ����ͷ��ť״̬
	CreateRole_SetFacePageStatus();
	
end


---------------------------------------------------------------------------------------------------------
--
-- ����ͷ���·�һҳ
--
function CreateRole_BnClickFacePageDown()
	
	
	
	g_FacePageCount = g_FacePageCount + 1;
	
	if(g_FacePageCount * g_iFaceCountInPage >= g_iCurFaceCount) then
	
		g_FacePageCount = g_FacePageCount - 1;
		return;
	end;
	
	-- ˢ�µ�ǰ��ʾ��faceҳ
	CreateRole_RefreshCurShowFacePage();
	
	-- ����ͷ��ť״̬
	CreateRole_SetFacePageStatus();
	
end


---------------------------------------------------------------------------------------------------------
--
-- ѡ��ͷ��1
--
function CreateRole_BnSelFace1()

	g_iFaceIndexInPage = 0;

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- ͨ���Ա����������ͷ��id
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end

---------------------------------------------------------------------------------------------------------
--
-- ѡ��ͷ��2
--
function CreateRole_BnSelFace2()

	g_iFaceIndexInPage = 1;

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 1;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- ͨ���Ա����������ͷ��id
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end


---------------------------------------------------------------------------------------------------------
--
-- ѡ��ͷ��3
--
function CreateRole_BnSelFace3()

	g_iFaceIndexInPage = 2;

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 2;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- ͨ���Ա����������ͷ��id
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end

---------------------------------------------------------------------------------------------------------
--
-- ѡ��ͷ��4
--
function CreateRole_BnSelFace4()

	g_iFaceIndexInPage = 3;

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 3;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- ͨ���Ա����������ͷ��id
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end

---------------------------------------------------------------------------------------------------------
--
-- ѡ��ͷ��5
--
function CreateRole_BnSelFace5()

	g_iFaceIndexInPage = 4;

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 4;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- ͨ���Ա����������ͷ��id
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end

---------------------------------------------------------------------------------------------------------
--
-- ѡ��ͷ��6
--
function CreateRole_BnSelFace6()

	g_iFaceIndexInPage = 5;

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 5;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- ͨ���Ա����������ͷ��id
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end

---------------------------------------------------------------------------------------------------------
--
-- ѡ��ͷ��7
--
function CreateRole_BnSelFace7()
	
	g_iFaceIndexInPage = 6;
	
	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 6;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- ͨ���Ա����������ͷ��id
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end

---------------------------------------------------------------------------------------------------------
--
-- ѡ��ͷ��8
--
function CreateRole_BnSelFace8()

	g_iFaceIndexInPage = 7;

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 7;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- ͨ���Ա����������ͷ��id
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end

---------------------------------------------------------------------------------------------------------
--
-- ѡ��ͷ��9
--
function CreateRole_BnSelFace9()

	g_iFaceIndexInPage = 8;

	g_iCurSelFaceIndex = g_FacePageCount * g_iFaceCountInPage + 8;
	if(g_iCurSelFaceIndex >= g_iCurFaceCount) then
	
		g_iCurSelFaceIndex = -1;
		return;
	end;
	
	-- ͨ���Ա����������ͷ��id
	GameProduceLogin:SetFaceId(iCurSelSex, g_iCurSelFaceIndex);
end


---------------------------------------------------------------------------------------------------------
--
-- ����ͷ��ť��״̬
--
function CreateRole_SetFacePageStatus()

	-- ͷ�����Ϸ�ҳ��ť
	local PageCount = g_FacePageCount;
	PageCount = PageCount - 1;
	if(PageCount < 0) then
	
		CreateRole_PageUp:Disable();
	else
	
		CreateRole_PageUp:Enable();
	end
	
	
	PageCount = g_FacePageCount;
	-- ͷ�����·�ҳ��ť
	PageCount = PageCount + 1;
	if(PageCount * g_iFaceCountInPage >= g_iCurFaceCount) then
	
		CreateRole_PageDown:Disable();
	else
		CreateRole_PageDown:Enable();
	end;
	
end


-----------------------------------------------------------------------------------------------------------
--
-- ѡ���µķ���
--
function CreateRole_ComboListSelectHairChanged()

  local strMeshName = "";
  strMeshName
	,g_iCurSelHairIndex = CreateRole_SelectHair:GetCurrentSelect();
	
	--AxTrace( 0,0, "==ѡ��������"..tostring(g_iCurSelHairIndex));
	--if(g_iCurSelHairIndexOld == g_iCurSelHairIndex) then
		
	--	return;
	--end
	g_iCurSelHairIndexOld = g_iCurSelHairIndex;

	CreateRole_SelHairModel(g_iCurSelHairIndex);
	
end
	
-----------------------------------------------------------------------------------------------------------
--
-- ѡ���µ�����
--	
function CreateRole_ComboListSelectFaceChanged()
	
	local strMeshName = "";
	 
	strMeshName
	,g_iCurSelectFace = CreateRole_SelectFace:GetCurrentSelect();
	--AxTrace( 0,0, "==ѡ����������"..tostring(g_iCurSelFaceIndex));
	
	--if(g_iCurSelFaceIndexOld == g_iCurSelFaceIndex) then
		
	--	return;
	--end
	--g_iCurSelFaceIndexOld = g_iCurSelFaceIndex;
	
	CreateRole_SelFaceModel(g_FaceModel[g_iCurSelectFace]);
	
end


-----------------------------------------------------------------------------------------------------------
--
-- �õ���������
--	
function CreateRole_GetFaceModel()
	
	-- �������
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
-- �õ���������
--	
function CreateRole_GetHairModel()
	
	-- �������
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
-- ѡ����
--	
function CreateRole_SelHairModel(index)
	
	--AxTrace( 0,0, "==ѡ����"..tostring(index));
	CreateRole_SelectHair:SetCurrentSelect(index);
	GameProduceLogin:SetHairModelId(iCurSelSex, index);

end


-----------------------------------------------------------------------------------------------------------
--
-- ѡ������
--	
function CreateRole_SelFaceModel(index)
	
	--AxTrace( 0,0, "==ѡ������"..tostring(index));
	--CreateRole_SelectFace:SetCurrentSelect(index);
	GameProduceLogin:SetFaceModelId(iCurSelSex, index);

end


function CreateRole_Name_MouseEnter()

	CreateRole_Info:SetText("��ng nh�p t�n nh�n v�t");

end

function CreateRole_MouseLeave()

	CreateRole_Info:SetText("");
end

function CreateRole_SelectHair_MouseEnter()
	
	--AxTrace( 0,0, "<==?ѡ����");
	CreateRole_Info:SetText("L�a ch�n cho c�c h� ki�u t�c nh�n v�t");
end


function CreateRole_SelectFace_MouseEnter()
	
	--AxTrace( 0,0, "<==?ѡ������");
	CreateRole_Info:SetText("L�a ch�n cho c�c h� ki�u m�t nh�n v�t");
end

function CreateRole_SelectRace_MouseEnter()

	CreateRole_Info:SetText("L�a ch�n cho c�c h� gi�i t�nh nh�n v�t");
end

function CreateRole_SelectHead_MouseEnter()

	CreateRole_Info:SetText("L�a ch�n cho c�c h� �nh nh�n v�t");
end

function CreateRole_CreateRole_MouseEnter()

	CreateRole_Info:SetText("T�o nh�n v�t");
end

function CreateRole_Last_MouseEnter()

	CreateRole_Info:SetText("Quay tr� l�i trang giao di�n l�a ch�n nh�n v�t");
end

----------------------------------------------------------------------------------
--
-- ��ת����ģ�ͣ�����)
--
function CreateRole_Modle_TurnLeft(start)
	--������ת��ʼ
	if(start == 1) then
		--CreateRole_Model:RotateBegin(-0.3);
                GameProduceLogin:ModelRotBegin(-1.0)
	--������ת����
	else
		--CreateRole_Model:ModelRotEnd( 0 );
                GameProduceLogin:ModelRotEnd( 0.0 )
	end
end

----------------------------------------------------------------------------------
--
--��ת����ģ�ͣ�����)
--
function CreateRole_Modle_TurnRight(start)
	--������ת��ʼ
	if(start == 1) then
		--CreateRole_Model:RotateBegin(0.3);
                GameProduceLogin:ModelRotBegin(1.0)
	--������ת����
	else
		--CreateRole_Model:RotateEnd();
                GameProduceLogin:ModelRotEnd( 0.0 )
	end
end



-----------------------------------------------------------------------------------------------------------
--
-- �õ���װ����
--	
function CreateRole_GetNewRoleEquipSet()
	
	-- �������
	CreateRole_SelectClothin:ResetList();
	
	local iCount = GameProduceLogin:GetEquipSetCount();
	--AxTrace( 0,0, "�õ���װ���� �� "..tostring(iCount));
	
	local strShowName = "";
	for index = 0, iCount - 1 do
	
		strShowName = GameProduceLogin:GetEquipSetName(index);
		--AxTrace( 0,0, "�õ���װ���� �� "..tostring(strShowName));
		CreateRole_SelectClothin:ComboBoxAddItem(strShowName, index);
	end;

end


-----------------------------------------------------------------------------------------------------------
--
-- ѡ����
--	
function CreateRole_SelEquipSet(index)
	
	CreateRole_SelectClothin:SetCurrentSelect(index);

end


function CreateRole_ComboListSelectClothin()

	local strMeshName = "";
		 
	strMeshName
	,g_iCurSelEquipSetIndex = CreateRole_SelectClothin:GetCurrentSelect();
	
	g_iCurSelEquipSetIndexOld = g_iCurSelEquipSetIndex;
	
	--AxTrace( 0,0, "ѡ����װ �� "..tostring(g_iCurSelEquipSetIndex));
	CreateRole_SelEquipSet(g_iCurSelEquipSetIndex);
	
	-- �ı�����װ
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
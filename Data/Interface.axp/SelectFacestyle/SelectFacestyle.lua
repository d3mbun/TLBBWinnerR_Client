local g_Facestyle_Icon = {}
local MAX_OBJ_DISTANCE = 3.0;
local g_nCurPage = 0								-- ��ǰѡ���ͼ���ڵڼ�ҳ
local g_nCurSelect = 0							-- ��ǰѡ���ͼ����
local g_Style_Index = {}
local g_Style_Count = 0							-- ʵ�����ж��ٸ����Ϳɹ�ѡ��
local g_Original_Style = 0				
local STYLE_PAGE_BUTTON = 12				-- ÿҳ���ٸ�ͼ��
local MAX_STYLE = 200								-- ����ж���ͼ��

local g_SelectFacestyle_Frame_UnifiedPosition;

--==================================
-- SelectFacestyle_PreLoad
--==================================
function SelectFacestyle_PreLoad()
	this:RegisterEvent("UI_COMMAND");	
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("SEX_CHANGED");	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--==================================
-- SelectFacestyle_OnLoad
--==================================
function SelectFacestyle_OnLoad()
	g_Facestyle_Icon[1]		= SelectFacestyle_Skill1_BKG
	g_Facestyle_Icon[2] 	= SelectFacestyle_Skill2_BKG
	g_Facestyle_Icon[3] 	= SelectFacestyle_Skill3_BKG
	g_Facestyle_Icon[4] 	= SelectFacestyle_Skill4_BKG
	g_Facestyle_Icon[5] 	= SelectFacestyle_Skill5_BKG
	g_Facestyle_Icon[6] 	= SelectFacestyle_Skill6_BKG
	g_Facestyle_Icon[7] 	= SelectFacestyle_Skill7_BKG
	g_Facestyle_Icon[8] 	= SelectFacestyle_Skill8_BKG
	g_Facestyle_Icon[9] 	= SelectFacestyle_Skill9_BKG
	g_Facestyle_Icon[10]	= SelectFacestyle_Skill10_BKG
	g_Facestyle_Icon[11]	= SelectFacestyle_Skill11_BKG
	g_Facestyle_Icon[12]	= SelectFacestyle_Skill12_BKG
	
	for i=1, MAX_STYLE do
		g_Style_Index[i] = -1
	end	

g_SelectFacestyle_Frame_UnifiedPosition=SelectFacestyle_Frame:GetProperty("UnifiedPosition");

end

--==================================
-- SelectFacestyle_OnEvent
--==================================
function SelectFacestyle_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 928) then
		local xx = Get_XParam_INT(0);
		objCared = DataPool : GetNPCIDByServerID(xx);
		if objCared == -1 then
				PushDebugMessage("D� li�u c�a server truy�n tr� l�i c� v�n �");
				return;
		end

		if(IsWindowShow("SelectHairstyle")) then
			CloseWindow("SelectHairstyle", true);
		end

		if(IsWindowShow("SelectHairColor")) then
			CloseWindow("SelectHairColor", true);
		end
		
		if(this:IsVisible() and tonumber(g_Original_Style)) then
			DataPool : Change_MyFaceStyle(g_Original_Style);
		end
		SelectFacestyle_OnShown()
		BeginCareObject_SelectFacestyle(objCared)

	elseif (event == "OBJECT_CARED_EVENT") then
		if(not this:IsVisible() ) then
			return;
		end
		if(tonumber(arg0) ~= objCared) then
			Close_Facestyle()
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--ȡ������
			Close_Facestyle()
		end
	end
	if event == "SEX_CHANGED" and  this:IsVisible() then
			SelectFacestyle_Model : Hide();
			SelectFacestyle_Model : Show();
			SelectFacestyle_Model:SetFakeObject("Player_Head");
	end
	if (event == "ADJEST_UI_POS" ) then
		SelectFacestyle_Frame_On_ResetPos()
	end
	if (event == "VIEW_RESOLUTION_CHANGED") then
		SelectFacestyle_Frame_On_ResetPos()
	end

end

--==================================
-- SelectFacestyle_OnShown
--==================================
function SelectFacestyle_OnShown()
	for i,eachstyle in g_Facestyle_Icon do
		eachstyle : SetPushed(0)
	end
	
	-- �õ���ǰ������
	g_Original_Style = DataPool : Get_MyFaceStyle();

	SelectFacestyle_Update();
	this:Show();
end

--==================================
-- SelectFacestyle_Update
--==================================
function SelectFacestyle_Update()

	local i;
	local k = 1;
	
	for i,eachstyle in g_Facestyle_Icon do
		eachstyle : SetPushed(0)
		eachstyle : SetProperty("NormalImage","")
		eachstyle : SetProperty("HoverImage","")
		eachstyle : SetToolTip("")
	end
	
	-- ���CharFaceGeo.txt��1-99ΪŮ�����ͣ�100-200Ϊ��������
	-- ������õ��е����⣬Ӧ����1-100ΪŮ�����ͣ�101-200Ϊ��������
	for i=0, MAX_STYLE do		
		local ItemID,ItemCount,SelectType,IconFile,CostMoney,StyleName = DataPool : Change_MyFaceStyle_Item(i);
		
		-- ItemID == -1��˵��Change_MyFaceStyle_Item()�������ص�������Ϣ���Ա��뵱ǰ��ɫ��һ�¡�����ֻ��Ҫ�͵�ǰ��ɫ�Ա�һ�����������ݡ�
		-- SelectType == 2��ֻ������Ϸ�п�ѡ�����ͣ�SelectType == 3����Ϸ�С���ʼʱ����ѡ������
		if(ItemID ~= -1 and SelectType >= 2) then
			if k > STYLE_PAGE_BUTTON * (g_nCurPage) and k <= STYLE_PAGE_BUTTON * (g_nCurPage+1) then
				local m = k - STYLE_PAGE_BUTTON * (g_nCurPage);
				IconFile = GetIconFullName(IconFile)
				g_Facestyle_Icon[m]:SetProperty("NormalImage",IconFile)
				g_Facestyle_Icon[m]:SetProperty("HoverImage",IconFile)
				g_Facestyle_Icon[m]:SetToolTip(StyleName)
				g_Style_Index[m] = i;
			end
			k = k+1
		end
	end
	-- ��¼������ܹ��ж��ٸ�����
	g_Style_Count = k-1
	--PushDebugMessage ("g_Style_Count = "..g_Style_Count)
	
	if(g_Style_Count <= 0) then
		SelectFacestyle_Require:SetText("Kh�ng c� khu�n m�t c� th� thay �i");
		SelectFacestyle_CurrentlyPage:SetText("1/1");
		SelectFacestyle_Model : SetFakeObject( "" );
		SelectFacestyle_Model : SetFakeObject( "Player_Head" );
		SelectFacestyle_PageUp : Disable();
		SelectFacestyle_PageDown : Disable();
		SelectFacestyle_Accept : Disable();
		return;
	end
	
	SelectFacestyle_Model : SetFakeObject( "Player_Head" )

	g_nCurSelect = 0;
	SelectFacestyle_WarningText : SetText("Xin l�a ch�n khu�n m�t t�i giao di�n ph�a tr�n b�n ph�i, sau �� �n \"x�c nh�n\"");
	
	-- ��ҳ����
	if g_nCurPage == 0 then
		SelectFacestyle_PageUp : Disable();				-- ��1ҳ
	else
		SelectFacestyle_PageUp : Enable();				-- ���ǵ�1ҳ
	end

	if (g_nCurPage+1)*STYLE_PAGE_BUTTON < g_Style_Count then
		SelectFacestyle_PageDown : Enable();			-- �������1ҳ
	else
		SelectFacestyle_PageDown : Disable();			-- ���1ҳ
	end

end

--==================================
--��ת
--==================================
function SelectFacestyle_Modle_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			SelectFacestyle_Model:RotateBegin(-0.3);
		else
			SelectFacestyle_Model:RotateEnd();
		end
	end
end

--==================================
--��ת
--==================================
function SelectFacestyle_Modle_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			SelectFacestyle_Model:RotateBegin(0.3);
		else
			SelectFacestyle_Model:RotateEnd();
		end
	end
end

--==================================
--�ر�
--==================================
function Close_Facestyle()
	g_HaveChange = 0
	g_nCurPage = 0
	g_nCurSelect = 0
	SelectFacestyle_Model : SetFakeObject( "" );
	StopCareObject_SelectFacestyle(objCared)
	this:Hide();	
end

--==================================
--��ʼ����NPC
--==================================
function BeginCareObject_SelectFacestyle(objCaredId)
	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "SelectFacestyle");
end

--==================================
--ֹͣ��ĳNPC�Ĺ���
--==================================
function StopCareObject_SelectFacestyle(objCaredId)
	this:CareObject(objCaredId, 0, "SelectFacestyle");
	g_Object = -1;
end

--==================================
--ȡ��
--==================================
function SelectFacestyle_Cancel_Clicked()
	DataPool : Change_MyFaceStyle(g_Original_Style);
	Close_Facestyle()
end

--==================================
--ȷ��
--==================================
function SelectFacestyle_OK_Clicked()
	-- û��ѡ������
	if(g_nCurSelect == 0 )then
		PushDebugMessage("Xin l�a 1 m� h�nh di�n m�o.");
		return;
	end

	-- �õ�ѡ���������Ϣ
	local ItemID,ItemCount,SelectType,IconFile,CostMoney = DataPool : Change_MyFaceStyle_Item(g_Style_Index[g_nCurSelect]);

	-- ������
	if(ItemID ~= -1 and SelectType >= 2) then
		if( DataPool:GetPlayerMission_ItemCountNow(ItemID) < ItemCount) then
			PushDebugMessage("Thi�u иnh Nhan Ch�u");
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
	
	-- ������Ϣ����ǰѡ�������ID
	--PushDebugMessage ("StyleId = "..g_Style_Index[g_nCurSelect])
	-- ���ѡ������ͺ͵�ǰ���Ͳ�ͬ
	if g_Style_Index[g_nCurSelect] ~= g_Original_Style then

		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("FinishAdjust");
			Set_XSCRIPT_ScriptID(805029);
			Set_XSCRIPT_Parameter(0,g_Style_Index[g_nCurSelect]);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		Close_Facestyle();
		
	else

		PushDebugMessage("Xin h�y ch�n 1 lo�i khu�n m�t kh�c v�i l�c tr߾c ��.");

	end
	
end

--==================================
--ѡ��һ��ͼ��
--==================================
function SelectFacestyle_Clicked(nIndex)

	-- ѡ����Чͼ��ʱ�Ĵ���
	if ((nIndex < 0) or (nIndex + STYLE_PAGE_BUTTON * (g_nCurPage) > g_Style_Count))  then
		g_HaveChange = 0
		if(g_nCurSelect > 0 )then
			g_Facestyle_Icon[g_nCurSelect]:SetPushed(0);
		end
		g_nCurSelect = 0
		DataPool : Change_MyFaceStyle(g_Original_Style);
		SelectFacestyle_WarningText : SetText("Xin l�a ch�n khu�n m�t t�i giao di�n ph�a tr�n b�n ph�i, sau �� �n \"x�c nh�n\"");
		return
	end

	-- ѡ����Чͼ��ʱ�Ĵ���
	if(g_nCurSelect > 0 )then
		g_Facestyle_Icon[g_nCurSelect]:SetPushed(0);
	end
	g_nCurSelect = nIndex
	g_Facestyle_Icon[g_nCurSelect]:SetPushed(1);

	local ItemID,ItemCount,SelectType,IconFile,CostMoney = DataPool : Change_MyFaceStyle_Item(g_Style_Index[nIndex]);
	local name,icon = LifeAbility : GetPrescr_Material(ItemID);

	SelectFacestyle_WarningText : SetText("C�n ��o c�: #G"..name.."#r#W C�n ti�u hao: #Y#{_EXCHG"..CostMoney.."}#W#rXin ch�n h�nh khu�n m�t tr�n h�nh g�c ph�i ph�a tr�n, sau �� �n \"X�c nh�n\".");
	DataPool : Change_MyFaceStyle(g_Style_Index[nIndex])
	g_HaveChange = 1

end

--=========================================
--��ҳ
--=========================================
function SelectFacestyle_Page(nPage)
	
	g_nCurPage = g_nCurPage + nPage;

	SelectFacestyle_Update();

end

function SelectFacestyle_Frame_On_ResetPos()
  SelectFacestyle_Frame:SetProperty("UnifiedPosition", g_SelectFacestyle_Frame_UnifiedPosition);
end

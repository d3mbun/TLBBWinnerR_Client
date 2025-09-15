
-----------------------------------------------------------------------------------------------------------------
--
-- ȫ�ֱ�����
--

-- ����
local g_RoleName = {};

-- ����
local g_iMenPai = {};

-- �ȼ�
local g_iLevel = {};

-- �ȼ�
local g_iDelTime = {};

-- �ڽ�������ʾ��uiģ��
local g_UIModel = {};

-- ѡ��ť
local g_BnSelCheck = {};

-- ��ǰѡ��Ľ�ɫ
local g_iCurSelRole = 0;

-- ��ǰ��ɫ�ĸ���
local g_iCurRoleCount = 0;

-- ����Ǵ����ɹ���ˢ�½��棬 Ҫѡ����󴴽��������ɫ.
--
-- 0 -- ������ɫʧ�ܡ�
-- 1 -- ������ɫ�ɹ���
local g_bCreateSuccess = 0;

------------------------------------------------------------------------------------------------------------------
--
-- ������
--

-- ע��onLoad�¼�
function LoginSelectRole_PreLoad()
	-- �򿪽���
	this:RegisterEvent("GAMELOGIN_OPEN_SELECT_CHARACTOR");
	
	-- �رս���
	this:RegisterEvent("GAMELOGIN_CLOSE_SELECT_CHARACTOR");
	
	-- ˢ�½�ɫ��Ϣ
	this:RegisterEvent("GAMELOGIN_REFRESH_ROLE_SELECT_CHARACTOR"); 
	
	-- ������ɫ�ɹ���
	this:RegisterEvent("GAMELOGIN_CREATE_ROLE_OK"); 

	this:RegisterEvent("ENTER_GAME"); 
	
	this:RegisterEvent("GAMELOGIN_SELECTCHARACTER"); 
	
end

-- ע��onLoad�¼�
function LoginSelectRole_OnLoad()

	-- ��ɫ����
	--g_RoleName[1] = SelectRole_Role1_Name;
	--g_RoleName[2] = SelectRole_Role2_Name;
	--g_RoleName[3] = SelectRole_Role3_Name;
	
	g_RoleName[1] = ""
	g_RoleName[2] = ""
	g_RoleName[3] = ""
		
	-- ��ɫ����
	g_iMenPai[1] = 0;
	g_iMenPai[2] = 0;
	g_iMenPai[3] = 0;
	
	-- ��ɫ�ȼ�
	g_iLevel[1] = 0;
	g_iLevel[2] = 0;
	g_iLevel[3] = 0;
	
	g_iDelTime[1] = 0;
	g_iDelTime[2] = 0;
	g_iDelTime[3] = 0;
	
end

-- OnEvent
function LoginSelectRole_OnEvent(event)

	if( event == "GAMELOGIN_OPEN_SELECT_CHARACTOR" ) then
	    
	    local CurSelIndex = GameProduceLogin:GetCurSelectRole();
	    
		-- Ĭ��ѡ���һ�����
		g_iCurSelRole = CurSelIndex + 1  --1;
		
		AxTrace( 1, 0, g_iCurSelRole )
		
		SelectRole_ClearInfo();
		SelectRole_RefreshRoleInfo();
		this:Show();
		return;
	end
	
	
	if( event == "GAMELOGIN_CLOSE_SELECT_CHARACTOR" ) then
	
		-- �������
		SelectRole_ClearInfo();
		this:Hide();
		return;
	end
	
	
	-- ˢ�½�ɫ
	if( event == "GAMELOGIN_REFRESH_ROLE_SELECT_CHARACTOR") then
		
		SelectRole_RefreshRoleInfo();
		return;
	end
	
	
	-- ������ɫ�ɹ���
	if( event == "GAMELOGIN_CREATE_ROLE_OK") then
		
		g_bCreateSuccess = 1;
		return;
	end

	if( event == "ENTER_GAME" ) then
		GameProduceLogin:SendEnterGameMsg(g_iCurSelRole - 1);
		return;
	end
	
	if( event == "GAMELOGIN_SELECTCHARACTER" ) then
	   local CurSel = tonumber( arg0 )
	   
	   if( 0 == CurSel ) then 
	     SelectRole_SelectRole1()
	   end
	   
	   if( 1 == CurSel ) then 
	     SelectRole_SelectRole2()
	   end
	   
	   if( 2 == CurSel ) then 
	     SelectRole_SelectRole3()
	   end
	   
	end
			
 		
end



---------------------------------------------------------------------------------------------
--
-- ������Ϸ
--
function SelectRole_EnterGame()

	-- ���ͽ�����Ϸ��Ϣ
	GameProduceLogin:SendEnterGameMsg(g_iCurSelRole - 1);
end

---------------------------------------------------------------------------------------------
--
-- ������ɫ
--
function SelectRole_CreateRole()

	--�˴���ֱ�Ӵ�����ѡ������л������ﴴ������....
	--��Login���󴴽������ͼ����֤��Ϣ....��֤��Ϣ������Ὺ����֤����....��֤ͨ������֤������л������ﴴ������....
	DataPool:AskCreateCharCode();

end



---------------------------------------------------------------------------------------------
--
-- ɾ����ɫ
--
function SelectRole_DelRole()

	GameProduceLogin:SetCurSelect( g_iCurSelRole - 1 );
	-- ������ѡ������л������ﴴ������.
	local strName;
	local iMenPai;
	local iLevel;
	local iDelTime;
	local strInfo;
	strName
	,iMenPai
	,iLevel
	,iDelTime
	= GameProduceLogin:GetRoleInfo(g_iCurSelRole-1);
	if( iLevel == 0 ) then --˵��û�н�ɫ
		strInfo="Kh�ng ch�n nh�n v�t";
			GameProduceLogin:ShowMessageBox( strInfo, "OK", "6" );
		return;
	end
	if( iLevel >= 1 ) then --�������10��
		if( iDelTime >= 11 ) then--˵��������ɾ���أ�����ʾ�Ի���
			strInfo="H�y b� xin �� ��a cho"..tostring( 14 - iDelTime ).."ng�y r�i, sau 3 ng�y khi h�y b� nh�n v�t, trong v�ng 14 ng�y ��ng nh�p tr� ch�i, h�y �n th�nh L�c D߽ng (268, 46) t�m Quan H�n Th� ho�c ho�c ��i L� (80, 136) t�m Chu X߽ng x�c nh�n.";
			GameProduceLogin:ShowMessageBox( strInfo, "OK", "6" );
		elseif( iDelTime > 0 ) then		--˵������ɾ���أ�����ʾ�Ի���
			strInfo="Xin ��ng nh�p v�o tr� ch�i, �n L�c D߽ng (268,46) t�m Quan H�n Th� ho�c ��i L� (80,136) t�m Chu X߽ng x�c nh�n, c� th� x�a b�. C�c h� c�n ph�i kh�ng c� bang h�i, k�t h�n, m� ti�m, k�t b�i, s� � c�c lo�i quan h� n�y m�i c� th� x�a b�. ";
			GameProduceLogin:ShowMessageBox( strInfo, "OK", "5" );
		else --˵��Ҫɾ���ˣ�������ʾ�Ի���
			strInfo = "C�c h� quy�t �nh mu�n s�"..tostring( iLevel ).."Nh�n v�t c�p #c00ff00"..strName.."#cffffff h�y b� kh�ng?";
			GameProduceLogin:ShowMessageBox( strInfo, "YesNo", "4" );
		end
	else --ֱ�ӳ�����ʾ���Ƿ�ɾ��
		strInfo = "C�c h� quy�t �nh mu�n s�"..tostring( iLevel ).."Nh�n v�t c�p #c00ff00"..strName.."#cffffff h�y b� kh�ng?";
		GameProduceLogin:ShowMessageBox( strInfo, "YesNo", "7" );
	end
	
end
	
	
---------------------------------------------------------------------------------------------
--
-- ���ص���һ��
--				
function SelectRole_Return()
			
	GameProduceLogin:ExitToAccountInput_YesNo();	
	--GameProduceLogin:ChangeToAccountInputDlgFromSelectRole();
end
				

---------------------------------------------------------------------------------------------------------------
--
--   ˢ�½�ɫ��Ϣ
--
function SelectRole_RefreshRoleInfo()

	-- ��ս���.
	SelectRole_ClearInfo();
	
	g_iCurRoleCount = GameProduceLogin:GetRoleCount();
	-- �õ�����ĸ���
	AxTrace( 0,0, "��t ���c s� nh�n v�t "..tostring(g_iCurRoleCount));
	
	if(0 == g_iCurRoleCount) then
	
		return;
	end;
	
	for index =0 , g_iCurRoleCount-1 do
	 		
	 		AxTrace( 0,0, "Hi�n th� nh�n v�t "..tostring(index));
			SelectRole_GetRoleInfo(index);
	end
	
	-- ѡ���ɫ
	if(1 == g_bCreateSuccess) then
			
			-- �����ɹ���
			g_iCurSelRole = g_iCurRoleCount;
			g_bCreateSuccess = 0;
	end
			
	SelectRole_ShowSelRoleInfo(g_iCurSelRole);
	
end


---------------------------------------------------------------------------------------------------------------
--
--   ˢ�½�ɫ��Ϣ
--
function SelectRole_GetRoleInfo(index)

	local strName;
	local iMenPai;
	local iLevel;
	local iDelTime;
	
	strName
	,iMenPai
	,iLevel
	,iDelTime
	= GameProduceLogin:GetRoleInfo(index);
	
	-- ��������
	--g_RoleName[index+1]:SetText(strName);
	g_RoleName[index+1] = strName;
	g_iMenPai[index+1] = iMenPai;
	g_iLevel[index+1]  = iLevel;
	g_iDelTime[index+1] = iDelTime;
	
end

---------------------------------------------------------------------------------------------------------------
--
--   ��ս�ɫ��Ϣ.
--
function SelectRole_ClearInfo()

	SelectRole_TargetInfo_Name_Text:SetText("");
	SelectRole_TargetInfo_Menpai_Text:SetText("");
	SelectRole_TargetInfo_Level_Text:SetText("");
	SelectRole_TargetInfo_Delete:Hide();
	--g_RoleName[1]:SetText("");
	--g_RoleName[2]:SetText("");
	--g_RoleName[3]:SetText("");
	
	--g_UIModel[1]:SetFakeObject("");
	--g_UIModel[2]:SetFakeObject("");
	--g_UIModel[3]:SetFakeObject("");
		
end


---------------------------------------------------------------------------------------------------------------
--
--   ѡ���ɫ1.
--
function SelectRole_SelectRole1()

	AxTrace( 0,0, " Ch�n 1");	
	g_iCurSelRole = 1;
	if(g_iCurRoleCount < g_iCurSelRole) then

		AxTrace( 0,0, " Ch�a ch�n 1 trong s� d߾i ��y");	
		SelectRole_TargetInfo_Name_Text:SetText("");
		SelectRole_TargetInfo_Menpai_Text:SetText("");
		SelectRole_TargetInfo_Level_Text:SetText("");
		return;
	end
	
	SelectRole_ShowSelRoleInfo(g_iCurSelRole);
	
end

---------------------------------------------------------------------------------------------------------------
--
--   ѡ���ɫ2.
--
function SelectRole_SelectRole2()

	AxTrace( 0,0, " Ch�n 2");	
	g_iCurSelRole = 2;
	if(g_iCurRoleCount < g_iCurSelRole) then
	
		SelectRole_TargetInfo_Name_Text:SetText("");
		SelectRole_TargetInfo_Menpai_Text:SetText("");
		SelectRole_TargetInfo_Level_Text:SetText("");
		return;
	end
	
	SelectRole_ShowSelRoleInfo(g_iCurSelRole);
	
end


---------------------------------------------------------------------------------------------------------------
--
--   ѡ���ɫ3.
--
function SelectRole_SelectRole3()

	AxTrace( 0,0, " Ch�n 3");	
	g_iCurSelRole = 3;
	if(g_iCurRoleCount < g_iCurSelRole) then
	
		SelectRole_TargetInfo_Name_Text:SetText("");
		SelectRole_TargetInfo_Menpai_Text:SetText("");
		SelectRole_TargetInfo_Level_Text:SetText("");
		return;
	end
	
	SelectRole_ShowSelRoleInfo(g_iCurSelRole);
	
end


---------------------------------------------------------------------------------------------------------------
--
--   ͨ������, ѡ���ɫ
--
function SelectRole_ShowSelRoleInfo(index)

	if(g_iCurRoleCount < index or 0 >= index ) then
	
		SelectRole_TargetInfo_Name_Text:SetText("");
		SelectRole_TargetInfo_Menpai_Text:SetText("");
		SelectRole_TargetInfo_Level_Text:SetText("");
		return;
	end
		
	if(index < 1)	then
	
		return;
	end;
	-- ��ʾ����
	AxTrace(0, 0, "show sel info index="..index);
	--SelectRole_TargetInfo_Name_Text:SetText(g_RoleName[index]:GetText());
	SelectRole_TargetInfo_Name_Text:SetText( "#c00ff00Nh�n v�t: #cffffff"..g_RoleName[index] );
	
	
	-- ��ʾ����
	local strName = "Kh�ng c�";
	local Family  = g_iMenPai[index];

	-- �õ���������.
	if(0 == Family) then
		strName = "Thi�u L�m";

	elseif(1 == Family) then
		strName = "Minh Gi�o";

	elseif(2 == Family) then
		strName = "C�i Bang";

	elseif(3 == Family) then
		strName = "V� �ang";

	elseif(4 == Family) then
		strName = "Nga My";

	elseif(5 == Family) then
		strName = "Tinh T�c";

	elseif(6 == Family) then
		strName = "Thi�n Long";

	elseif(7 == Family) then
		strName = "Thi�n S�n";

	elseif(8 == Family) then
		strName = "Ti�u Dao";

	elseif(10 == Family) then
		strName = "M� Dung";
		
	end
	SelectRole_TargetInfo_Menpai_Text:SetText("#c00ff00M�n ph�i: #cffffff"..strName);
	
	-- ��ʾ�ȼ�
	SelectRole_TargetInfo_Level_Text:SetText("#c00ff00��ng c�p: #cffffff"..tostring(g_iLevel[index]));

	if(tonumber(g_iDelTime[index])>0)then
		if(g_iDelTime[index]>=11)then
			SelectRole_TargetInfo_Delete:SetText("#c00ff00"..(3-(14-g_iDelTime[index])).." ng�y sau c� th� x�a nh�n v�t");
		else
			SelectRole_TargetInfo_Delete:SetText("#c00ff00 �� c� th� x�a nh�n v�t");
		end
		
		SelectRole_TargetInfo_Delete:Show();
	else
		SelectRole_TargetInfo_Delete:Hide();
	end
	-- ��Ϊѡ��״̬
	--g_BnSelCheck[index]:SetCheck(1);
	

end


function SelectRole_SelRole_MouseEnter(index)

	SelectRole_Info:SetText("L�a ch�n nh�n v�t ��ng nh�p");
end
	
function SelectRole_MouseLeave()

	SelectRole_Info:SetText("");
end

function SelectRole_Play_MouseEnter()

	SelectRole_Info:SetText("V�o tr� ch�i");
end

function SelectRole_Create_MouseEnter()

	SelectRole_Info:SetText("T�o nh�n v�t");
end

function SelectRole_Delete_MouseEnter()

	SelectRole_Info:SetText("X�a nh�n v�t");
end

function SelectRole_Last_MouseEnter()

	SelectRole_Info:SetText("Quay l�i giao di�n ��ng k� t�i kho�n");
end;


function SelectRole_Role_Modle_TurnRightBegin(index)

	if(1 == index) then
		
		SelectRole_Role1_Model:RotateBegin(0.3);
	
	elseif(2 == index) then
	
		SelectRole_Role2_Model:RotateBegin(0.3);
		
	elseif(3 == index) then
	
		SelectRole_Role3_Model:RotateBegin(0.3);
		
	end;
		
end;
		
		
function SelectRole_Role_Modle_TurnRightEnd(index)

	if(1 == index) then
		
		SelectRole_Role1_Model:RotateEnd();
	
	elseif(2 == index) then
	
		SelectRole_Role2_Model:RotateEnd();
		
	elseif(3 == index) then
	
		SelectRole_Role3_Model:RotateEnd();
	
	end;	
		
end;

function SelectRole_Role_Modle_TurnLeftBegin(index)

	if(1 == index) then
		
		SelectRole_Role1_Model:RotateBegin(-0.3);
	
	elseif(2 == index) then
	
		SelectRole_Role2_Model:RotateBegin(-0.3);
		
	elseif(3 == index) then
	
		SelectRole_Role3_Model:RotateBegin(-0.3);
		
	end;
	
end;


function SelectRole_Role_Modle_TurnLeftEnd(index)
		
	if(1 == index) then
		
		SelectRole_Role1_Model:RotateEnd();
	
	elseif(2 == index) then
	
		SelectRole_Role2_Model:RotateEnd();
		
	elseif(3 == index) then
	
		SelectRole_Role3_Model:RotateEnd();
	
	end;	
		
end;





function SelectRole_Role_Modle_TurnRight( start )
	--������ת��ʼ
	if(start == 1) then		
        --GameProduceLogin:ModelRotBegin(0.3)
            GameProduceLogin:ModelRotBegin(1.0)   --ÿ��һȦ
	--������ת����
	else
        GameProduceLogin:ModelRotEnd( 0.0 )
	end
	
end

function SelectRole_Role_Modle_TurnLeft( start )
	if(start == 1) then
            --GameProduceLogin:ModelRotBegin(-0.3)
            GameProduceLogin:ModelRotBegin(-1.0)   --ÿ��-1Ȧ
	else		
        GameProduceLogin:ModelRotEnd( 0.0 )
	end
	
end

function SelectRole_Modle_ZoomOut( start )
	if(start == 1) then
	    GameProduceLogin:ModelZoom( -1.0 )
	else
	    GameProduceLogin:ModelZoom( 0.0 )
	end
	
end

function SelectRole_Modle_ZoomIn( start )
    if(start == 1) then
         GameProduceLogin:ModelZoom( 1.0 )
	else
	     GameProduceLogin:ModelZoom( 0.0 )
	end
	
end
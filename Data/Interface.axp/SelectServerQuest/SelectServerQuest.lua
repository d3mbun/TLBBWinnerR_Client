

------------------------------------------------------------------------------------------------------
--
-- ȫ�ֱ�����
--
--
local g_iYesNoType = -1;	-- yes-no �Ի�������
													-- -1 -- ��ͨ��Ϣ��ʾ
													-- 0 - �˳���Ϸ
													-- 1 - ɾ����ɫ
													-- 2 - �����ʺ�
													-- 3 - �Ͽ�����
													-- 4 - ȷ���Ƿ�ɾ��10���������
													-- 5 - 7��������ɾ��10���������
													-- 6 - 7���14��������ɾ��10���������
													-- 7 - �Ƿ�ɾ��10���������
													-- 8 ɾ�����
													-- 9 �Ƿ�ע��
local g_strMessageData;

local g_bagIndex = -1
-- ע��onLoad�¼�
function LoginSelectServerQuest_PreLoad()
	
	-- �򿪽���
	this:RegisterEvent("GAMELOGIN_SHOW_SYSTEM_INFO");
	
	-- �رս���
	this:RegisterEvent("GAMELOGIN_CLOSE_SYSTEM_INFO");
	
	
	-- ���ȷ����ť�ر�����
	this:RegisterEvent("GAMELOGIN_SHOW_SYSTEM_INFO_CLOSE_NET");   

	-- ��ʾ������ť����Ϣ
	this:RegisterEvent("GAMELOGIN_SHOW_SYSTEM_INFO_NO_BUTTON");   
	-- ��ʾyes-no��Ϣ
	this:RegisterEvent("GAMELOGIN_SYSTEM_INFO_YESNO");   
	this:RegisterEvent("GAMELOGIN_SYSTEM_INFO_OK");   
	this:RegisterEvent("GAMELOGIN_SYSTEM_INFO_CANCEL"); 
	this:RegisterEvent("GAMELOGIN_SYSTEM_INFO_CLOSE"); 
	this:RegisterEvent("UI_COMMAND");

end

function LoginSelectServerQuest_OnLoad()
	
	-- �������������ϲ���ʾ
	SelectServerQuest_Frame_sub:SetProperty("AlwaysOnTop", "True");
	
	-- 
	

end
function LoginSelectUpdateRect()
	local nWidth, nHeight = SelectServerQuest_InfoWindow:GetWindowSize();
	local nTitleHeight = 23;
	local nBottomHeight = 25;
	nWindowHeight = nTitleHeight + nBottomHeight + nHeight;
	SelectServerQuest_Frame_sub:SetProperty( "AbsoluteHeight", tostring( nWindowHeight ) );
	AxTrace( 0,0, "LastWindowSize ="..tostring( nWindowWidth )..","..tostring(nWindowHeight) );
	--SelectServerQuest_Frame_sub:SetWindowSize( nWindowWidth, nWindowHeight );
end

local TimerArg = "";
local g_QuitType = 0;
local g_bIsQuitMsgBox = 0;
-- OnEvent
function LoginSelectServerQuest_OnEvent(event)
		g_bIsQuitMsgBox = 0;
    SelectServerQuest_Frame_sub:SetProperty( "UnifiedPosition", "{{0.500000,-173.000000},{0.500000,-118.000000}}" )

	--AxTrace( 0,0, "get event");
	SelectServerQuest_Button2:Hide();
	SelectServerQuest_Button1:Hide();
	SelectServerQuest_Time_Text : Hide();
	SelectServerQuest_InfoWindow:Show();
	if( event == "GAMELOGIN_SHOW_SYSTEM_INFO" ) then
	
		g_iYesNoType = -1;
		--AxTrace( 0,0, "��ʾϵͳ��Ϣ");
		if( arg1 ~= "WAITFORQUIT" ) then
			SelectServerQuest_InfoWindow:SetText(arg0);
			LoginSelectUpdateRect();
		end
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:SetText("��ng");
		SelectServerQuest_Button1:Enable()
		
		if( arg1 == "USERONLINE" ) then
		    SelectServerQuest_Time_Text : SetProperty("Timer",tostring(20));
		    SelectServerQuest_Time_Text : Show()
		    SelectServerQuest_Button1:Disable()
		    TimerArg = arg1;
		    arg1 = nil;
		elseif(arg1 == "USERFROMMAINPRO") then
		    SelectServerQuest_Time_Text : SetProperty("Timer",tostring(20));
		    SelectServerQuest_Time_Text : Show()
		    SelectServerQuest_Button1:Hide();
		    SelectServerQuest_Button2:Hide();
		    TimerArg = arg1;
		    arg1 = nil;
		elseif( arg1 == "MIBAOERROR" ) then
		    SelectServerQuest_Time_Text : SetProperty("Timer",tostring(60));
		    SelectServerQuest_Time_Text : Show()
		    SelectServerQuest_Button1:Disable()
		    TimerArg = arg1;
		    arg1 = nil;
		elseif( arg1 == "WAITFORQUIT" ) then
		    if(arg3~=nil and tonumber(arg3)~=nil)then
			if(tonumber(arg3)>0)then
				SelectServerQuest_Time_Text : SetProperty("Timer",tostring(10));
				SelectServerQuest_InfoWindow:SetText("Sau 10 gi�y s� tho�t kh�i tr� ch�i");
				LoginSelectUpdateRect();
				
			else
				SelectServerQuest_Time_Text : SetProperty("Timer",tostring(3));
				SelectServerQuest_InfoWindow:SetText("Sau 3 gi�y s� tho�t kh�i tr� ch�i!");
				LoginSelectUpdateRect();
			end
		    else
			 SelectServerQuest_Time_Text : SetProperty("Timer",tostring(3));
			 SelectServerQuest_InfoWindow:SetText("Sau 3 gi�y s� tho�t kh�i tr� ch�i!");
			LoginSelectUpdateRect();
		    end
		    SelectServerQuest_Time_Text : Show()
		    SelectServerQuest_Button1:SetText("Hu�");
		    SelectServerQuest_Button1:Show();
		    SelectServerQuest_Button1:Enable()
		    TimerArg = arg1;
		    g_QuitType = tonumber(arg2);
		    g_bIsQuitMsgBox = 1;
		    arg1 = nil;
		else
		    TimerArg = nil;
		    arg1 = nil;
		    SelectServerQuest_Time_Text : Hide()    
		end
				
		this:Show();
		return;
	end
	
	
	
	
	if( event == "GAMELOGIN_CLOSE_SYSTEM_INFO") then
		
		g_iYesNoType = -1;
		this:Hide();
		return;
	end
	
	--AxTrace( 0,0, "event yes no");
	if( event == "GAMELOGIN_SYSTEM_INFO_YESNO") then
		
		if( tonumber(arg1) == 11 ) then
			GameProduceLogin:CheckAccountNoMibao();
		else 
			--AxTrace( 0,0, "��ʾyes no");
			SelectServerQuest_InfoWindow:SetText(arg0);
			LoginSelectUpdateRect();
			g_iYesNoType = tonumber(arg1);
		
			SelectServerQuest_Button1:SetText("Duy�t");
			SelectServerQuest_Button2:SetText("Hu�");
			SelectServerQuest_Button2:Show();
			SelectServerQuest_Button1:Show();
			this:Show();
			return;
		end
	end
	if( event == "GAMELOGIN_SHOW_SYSTEM_INFO_NO_BUTTON" ) then
	
	    if( nil ~= arg1 ) then
	        local strArg = tostring( arg1 )
			if( strArg == "CharSel_EnterGame" ) then
			--if( strArg == "CharSel_EnterGam" ) then
				SelectServerQuest_Frame_sub:SetProperty( "UnifiedPosition", "{{0.500000,-173.000000},{0.900000,-118.000000}}" )
			end
		arg1 = nil;
	    end
	
		g_iYesNoType = -1;--tonumber(arg1);
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		this:Show();
		SelectServerQuest_Button1:Hide();
		SelectServerQuest_Button2:Hide();
		return;


	end
	if( event == "GAMELOGIN_SYSTEM_INFO_OK" ) then
		AxTrace( 0,0,"GAMELOGIN_SYSTEM_INFO_OK" );
		g_iYesNoType = tonumber(arg1);
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		if g_iYesNoType == 0 then
			SelectServerQuest_Button1:SetText("��ng");
		else
			SelectServerQuest_Button1:SetText("Duy�t");
		end
		this:Show();
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:Hide();
		return;
	end
	if( event == "GAMELOGIN_SYSTEM_INFO_CANCEL" ) then
	
		g_iYesNoType = tonumber(arg1);
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("Hu�");
		this:Show();
		SelectServerQuest_Button2:Hide();
		return;
	end
	if( event == "GAMELOGIN_SYSTEM_INFO_CLOSE" ) then
	
		g_iYesNoType = tonumber(arg1);
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("��ng");
		this:Show();
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:Hide();
		return;
	end
	
	
	
	if( event == "GAMELOGIN_SHOW_SYSTEM_INFO_CLOSE_NET") then
		
		--AxTrace( 0,0, "��Ҫ�ر�����.");
		g_iYesNoType = 3;
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:SetText("��ng");
		this:Show();
		return;
	end
	
	-- Ѫԡ���������������
	if ( event == "UI_COMMAND" and tonumber(arg0) == 13906) then
		g_iYesNoType = -1;
		SelectServerQuest_InfoWindow:SetText("#cFFF263#{XYSB_080925_001}");
		LoginSelectUpdateRect();

		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:SetText("��ng");
		SelectServerQuest_Button1:Enable()
		
		this:Show();
	end
	
	-- Ѫԡ���������������
	if ( event == "UI_COMMAND" and tonumber(arg0) == 12032203) then
		g_iYesNoType = -1;
		SelectServerQuest_InfoWindow:SetText("#cFFF263 Sau khi ti�p t�c r�n luy�n th�n kh� s� b� h�y di�t, nh�ng b�o th�ch �� kh�m n�m ho�c c߶ng h�a l�n Th�n kh� c�ng s� m�t theo.");
		LoginSelectUpdateRect();

		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:SetText("��ng");
		SelectServerQuest_Button1:Enable()
		
		this:Show();
	end

	if( event == "UI_COMMAND" and tonumber(arg0) == 300077) then
		g_iYesNoType = 12;
		local slzExp = Get_XParam_INT( 0 )
		local levelCanUp = Get_XParam_INT( 1 )
		local petLevel = Get_XParam_INT( 2 )
		local toMaxLevel = Get_XParam_INT( 3 )
		local PetGuidH = Get_XParam_INT( 4 )
		local PetGuidL = Get_XParam_INT( 5 )
		g_bagIndex = Get_XParam_INT( 6 )
		local petClass = Pet:GetPetDBCName(PetGuidH,PetGuidL)

		if levelCanUp == 0 then
			local strText = string.format("#{ZSKSSJ_081113_19}%s#{ZSKSSJ_081113_20}%d#{ZSKSSJ_081113_21}%d#{ZSKSSJ_081113_22}",petClass,slzExp ,toMaxLevel)	
			SelectServerQuest_InfoWindow:SetText( strText );
		elseif levelCanUp > 0 then
			local strText = string.format("#{ZSKSSJ_081113_19}%s#{ZSKSSJ_081113_20}%d#{ZSKSSJ_081113_28}%d#{ZSKSSJ_081113_29}%d#{ZSKSSJ_081113_30}%d#{ZSKSSJ_081113_22}",petClass,slzExp ,petLevel ,petLevel + levelCanUp ,toMaxLevel)
			SelectServerQuest_InfoWindow:SetText( strText );
		end
		
		LoginSelectUpdateRect();
		
		SelectServerQuest_Button1:SetText("Duy�t");
		SelectServerQuest_Button2:SetText("Hu�");
		SelectServerQuest_Button2:Show();
		SelectServerQuest_Button1:Show();
		this:Show();
		
	end
	
	
	
end


-------------------------------------------------------------
--
-- ��ť1 ����¼�
--
function SelectServerQuest_Bn1Click()
-- 0 - �˳���Ϸ
-- 4 - ȷ���Ƿ�ɾ��10���������
-- 5 - 7��������ɾ��10���������
-- 6 - 7���14��������ɾ��10���������
-- 7 - �Ƿ�ɾ��10���������
-- 8 - ����10������ʾ
	if( -1 == g_iYesNoType and 1 == g_bIsQuitMsgBox) then
		CancelQuitWait(); --ȡ���˳�
	end
	if(0 == g_iYesNoType) then		
		QuitApplication("quit");
	elseif(1 == g_iYesNoType) then		
	elseif(2==g_iYesNoType) then
		GameProduceLogin:ChangeToAccountInputDlgFromSelectRole();
	elseif( 3 == g_iYesNoType ) then
		GameProduceLogin:CloseNetConnect();
	elseif( 4 == g_iYesNoType ) then
			local strInfo;
		  strInfo ="Nh�n v�t c�a c�c h� kh�ng th� x�a ngay ���c, xin 3 ng�y sau trong v�ng 14 ng�y ��ng nh�p v�o tr� ch�i, �n L�c D߽ng (268, 46) t�m Quan H�n Th� ho�c ��i L� (80, 136) t�m Chu X߽ng x�c nh�n, l� c� th� x�a. L�c x�c nh�n x�a nh�n v�t kh�ng th� c� bang h�i, k�t h�n, k�t b�i, m� ti�m tr�ng th�i, n�u kh�ng vi�c x�a nh�n v�t s� b� h�y. Qu� 14 ng�y kh�ng x�c nh�n thao t�c x�a nh�n v�t s� v� hi�u."
		  GameProduceLogin:ShowMessageBox( strInfo, "OK", "8" );--qds û�и����Ի�����ɲ���ɾ����ɫ
		  --strInfo ="���Ľ�ɫ��������ɾ��������3���Ժ�14�����ڵ�¼��Ϸ����������268��46���ҵ��غ��ٻ��ߵ�����80��136���ҵ��ܲ�ȷ�ϣ���������ɾ����ȷ��ɾ��ʱ��ɫ���ܴ����а�ᡢ��顢��ݡ�ʦͽ������״̬������ɾ������ȡ��������14��û���ٴ�ɾ����ɾ��������Ч��"
	elseif( 5 == g_iYesNoType ) then
	elseif( 6 == g_iYesNoType ) then
	elseif( 7 == g_iYesNoType ) then
		GameProduceLogin:DelSelRole();
	elseif( 8 == g_iYesNoType ) then
		GameProduceLogin:DelSelRole();
	elseif( 9 == g_iYesNoType ) then
		GameProduceLogin:LoginPlayer( 1 );
	elseif( 10 == g_iYesNoType ) then
		AxTrace( 0,0, "Ph�i ch�ng k�ch ho�t_g� n�t OK");
	elseif(11 == g_iYesNoType) then
		GameProduceLogin:CheckAccountNoMibao();
	elseif(12 == g_iYesNoType) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "UseShelizi" )
			Set_XSCRIPT_ScriptID( 300077 )
			Set_XSCRIPT_Parameter( 0, g_bagIndex )
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end;
	
	this:Hide();
end


-------------------------------------------------------------
--
-- ��ť2 ����¼�
--
function SelectServerQuest_Bn2Click()

	if(3 == g_iYesNoType) then
		GameProduceLogin:CloseNetConnect();
	elseif( 9 == g_iYesNoType ) then
		GameProduceLogin:PassportButNotReg();
	elseif( 10 == g_iYesNoType ) then
		AxTrace( 0,0, "Ph�i ch�ng k�ch ho�t_g� n�t NO");	
	end
	
	this:Hide();
end

function SelectServerQuest_TimeOut()
  if( TimerArg == "USERONLINE" ) then
    SelectServerQuest_Button1:Enable()
    TimerArg = nil
  elseif(TimerArg == "MIBAOERROR" ) then
    SelectServerQuest_Button1:Enable()
    TimerArg = nil
  elseif(TimerArg == "USERFROMMAINPRO") then
	this:Hide();
	TimerArg = nil
  elseif(TimerArg == "WAITFORQUIT") then
	if(tonumber(g_QuitType)==0)then
		QuitApplication("quit");
	else
		AskRet2SelServer();
	end
	this:Hide();
	TimerArg = nil
	g_QuitType = nil
   end
end

function SelectServerQuest_Frame_OnHiden()
	DataPool:SetCanUseHotKey(1);
end
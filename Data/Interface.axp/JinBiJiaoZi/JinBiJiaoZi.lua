
local ShowConfirmBox = 0
local NpcServerId = 0

local g_JinBiJiaoZi_Frame_UnifiedXPosition;
local g_JinBiJiaoZi_Frame_UnifiedYPosition;
function JinBiJiaoZi_PreLoad( )

	this:RegisterEvent( "UI_COMMAND" )
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
end

function JinBiJiaoZi_OnLoad( )
g_JinBiJiaoZi_Frame_UnifiedXPosition	= JinBiJiaoZi_Frame:GetProperty("UnifiedXPosition");
g_JinBiJiaoZi_Frame_UnifiedYPosition	= JinBiJiaoZi_Frame:GetProperty("UnifiedYPosition");
end

function JinBiJiaoZi_OnEvent( event )

	if event == "UI_COMMAND" then
		JinBiJiaoZi_OnUICommand( arg0 )
		
	elseif( event == "ADJEST_UI_POS" ) then
		JinBiJiaoZi_ResetPos()

	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		JinBiJiaoZi_ResetPos()
	end

end

function JinBiJiaoZi_OnUICommand( arg0 )
	
	local op = tonumber( arg0 )
	
	if op == 800119 then
		this : Show( )
		
		NpcServerId = Get_XParam_INT( 0 )
		
		local npcClientId = DataPool : GetNPCIDByServerID( NpcServerId )
		if npcClientId ~= -1 then
			this:CareObject( npcClientId, 1, "JinBiJiaoZi" )
		end
	end
	
end

function JinBiJiaoZi_OnShown( )

	JinBiJiaoZi_Clear( )
	
	-- ���ý���
	JinBiJiaoZi_Gold : SetProperty( "DefaultEditBox", "True" )
	
	-- �򿪵�ͬʱ������Ʒ��
	OpenWindow( "Packet" )
end

function JinBiJiaoZi_Clear( )
	
	ShowConfirmBox = 0
	JinBiJiaoZi_Gold : SetProperty( "Text", "" )
	JinBiJiaoZi_Silver : SetProperty( "Text", "" )
	JinBiJiaoZi_CopperCoin : SetProperty( "Text", "" )
	
	JinBiJiaoZi_Accept_Button : Disable( )
	
end

function JinBiJiaoZi_Hide( )

	-- �رմ���
	this : Hide( )

end

function JinBiJiaoZi_OnHidden( )
		
	-- ȡ��NPC����
	local npcClientId = DataPool : GetNPCIDByServerID( NpcServerId )
	if npcClientId ~= -1 then
		this : CareObject( npcClientId, 0, "JinBiJiaoZi")
	end
	
end


function JinBiJiaoZiAccept_Clicked( )
	
	-- ���û�м����绰�Ͷ������뷵��0
	if CheckPhoneMibaoAndMinorPassword() == 0 then
		return
	end
	
	-- �Ƿ���˰�ȫʱ��....
	if( tonumber(DataPool:GetLeftProtectTime( ) ) > 0 ) then
		PushDebugMessage( "#{OR_PILFER_LOCK_FLAG}" )
		return
	end
	
	-- ����Ϸ���ؼ��
	local jin = JinBiJiaoZi_Gold : GetProperty( "Text" )
	local yin = JinBiJiaoZi_Silver : GetProperty( "Text" )
	local tong = JinBiJiaoZi_CopperCoin : GetProperty( "Text" )
	
	-- һ������ֱ���ڽű���ӣ�9999��99��99ͭ�Ժ�Ͳ���ȷ��
	local bAvailability, money = Bank : GetInputMoney( jin , yin, tong )
	
	-- �������0��ֱ�ӹر�
	if money == 0 then
		JinBiJiaoZi_Hide( )
		return
	end
		
	-- �����ҳ�������Я��������
	local holdMoney = Player:GetData( "MONEY" )
	if holdMoney < money then
		PushDebugMessage( "#{JBJZ_090407_5}" )
		return
	end
	
	-- ��������Я������
	local holdJZ = Player:GetData( "MONEY_JZ" )
	if DataPool : ScriptPlus( holdJZ, money ) > 144000000 then
		PushDebugMessage( "#{JBJZ_090407_6}" )
		return	
	end
	
	-- ����ȷ������
	if ShowConfirmBox == 0 then
		local msgMoney = ""
		local msgJZ = ""
		if jin ~= "" and jin ~= "0" then
			msgMoney = msgMoney..jin.."#-02"
			msgJZ = msgJZ..jin.."#-14 "
		end
		if yin ~= "" and yin ~= "0" then
			msgMoney = msgMoney..yin.."#-03"
			msgJZ = msgJZ..yin.."#-15 "
		end
		if tong ~= "" and tong ~= "0" then
			msgMoney = msgMoney..tong.."#-04"
			msgJZ = msgJZ..tong.."#-16"
		end
		local msg = "#{JBJZ_090407_7}"..msgMoney.."#{JBJZ_090407_8}"..msgJZ.."#{JBJZ_090407_9}"
		GameProduceLogin : ShowMessageBox( msg, "Close", "-1")
		ShowConfirmBox = 1
		return
	end
	
	-- ���������˷��ͽű�ִ������
	Clear_XSCRIPT( )
		Set_XSCRIPT_Function_Name( "DoMoneyToJiaozi" )
		Set_XSCRIPT_ScriptID( 800119 )
		Set_XSCRIPT_Parameter( 0, money )
		Set_XSCRIPT_ParamCount( 1 )
	Send_XSCRIPT( )
	
	
	-- ��ִ�����˹رմ��ڣ������ɹ��ɷ���������ʾ��
	JinBiJiaoZi_Hide( )
end

function JinBiJiaoZi_ChangeMoney( )
	
	ShowConfirmBox = 0
	
	local jin = JinBiJiaoZi_Gold : GetProperty( "Text" )
	local yin = JinBiJiaoZi_Silver : GetProperty( "Text" )
	local tong = JinBiJiaoZi_CopperCoin : GetProperty( "Text" )
	
	if jin ~= "" and jin ~= "0" then
		JinBiJiaoZi_Gold : SetTextOriginal( ""..tonumber(jin) )
	end
	
	if yin ~= "" and yin ~= "0" then
		JinBiJiaoZi_Silver : SetTextOriginal( ""..tonumber(yin) )
	end
	
	if tong ~= "" and tong ~= "0" then
		JinBiJiaoZi_CopperCoin : SetTextOriginal( ""..tonumber(tong) )
	end
	
	-- һ������ֱ���ڽű���ӣ�9999��99��99ͭ�Ժ�Ͳ���ȷ��
	local bAvailability, money = Bank : GetInputMoney( jin , yin, tong )
	
	if money > 0 then
		JinBiJiaoZi_Accept_Button : Enable( )
	else
		JinBiJiaoZi_Accept_Button : Disable( )
	end
	
end

function JinBiJiaoZi_ResetPos()
	JinBiJiaoZi_Frame:SetProperty("UnifiedXPosition", g_JinBiJiaoZi_Frame_UnifiedXPosition);
	JinBiJiaoZi_Frame:SetProperty("UnifiedYPosition", g_JinBiJiaoZi_Frame_UnifiedYPosition);

end

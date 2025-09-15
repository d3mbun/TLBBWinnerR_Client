-- ConfraternityMessage.lua
-- ������Խ���

local currentChoose = -1											-- 1��ȷ�Ͽ�2�������3���鿴��
local waitLeaveWordUpdate = 0                 -- �Ƿ����ڵȴ�LeaveWord����

local moneyCosts = 1000												-- ��������


local g_ConfraternityMessage_Frame_UnifiedPosition;
function ConfraternityMessage_PreLoad()
	this : RegisterEvent( "UI_COMMAND" )
	this : RegisterEvent( "GUILD_LEAVE_WORD" )						-- �������

	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
end

function ConfraternityMessage_OnLoad()
	ConfraternityMessage_Clear()
	g_ConfraternityMessage_Frame_UnifiedPosition=ConfraternityMessage_Frame:GetProperty("UnifiedPosition");
end

function ConfraternityMessage_OnEvent(event)
	if event == "UI_COMMAND" and tonumber( arg0 ) == 19840424 then	-- �򿪽���
		if this : IsVisible() then									-- ������濪�ţ��򲻴���
			return
		end

		currentChoose = 1
		ConfraternityMessage_RefreshWindow()
		this : Show()
		return
	end

	if event == "GUILD_LEAVE_WORD" and this : IsVisible() then		-- �������
		if currentChoose == 2 then
			return
		end

		currentChoose = 2
		ConfraternityMessage_RefreshWindow()
		return
	end
	
	--׼���򿪲鿴���Խ���....��ֱ�Ӵ�����Ϊ�ͻ����е�LeaveWord���ܲ������µ�....
	--�����ܹܶԻ�ѡ�鿴����ʱ����world�������µ�LeaveWord....�����µ�LeaveWord������ᷢ��UI_COMMAND 19841121....��ʱ������ʾ���Դ���....
	if event == "UI_COMMAND" and tonumber( arg0 ) == 19841120 then
		
		--���õ�ǰ״̬Ϊ�ȴ�LeaveWord����....
		waitLeaveWordUpdate = 1
		--��World����������(���±��ذ������)....
		Guild : AskGuildLeaveWord()

	end

	--LeaveWord�Ѿ�����....�����ǰ״̬Ϊ�ȴ�LeaveWord������򿪲鿴���Խ���....
	if event == "UI_COMMAND" and tonumber( arg0 ) == 19841121 then

		if waitLeaveWordUpdate == 1 then
			currentChoose = 3
			ConfraternityMessage_RefreshWindow()
			this : Show()
			waitLeaveWordUpdate = 0
			return
		end
		
	end

	-- ��Ϸ���ڳߴ緢���˱仯
	if (event == "ADJEST_UI_POS" ) then
		ConfraternityMessage_Frame_On_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ConfraternityMessage_Frame_On_ResetPos()
	end
end

function ConfraternityMessage_RefreshWindow()

	local str = ""

	if currentChoose == 1 then										-- 1��ȷ�Ͽ�2������򡣣�3���鿴��
		ConfraternityMessage_Title : SetText( "#{INTERFACE_XML_55}" )
		ConfraternityMessage_EditInfo : Hide()
		ConfraternityMessage_Set : Hide()
		ConfraternityMessage_WarningText : SetText( "#{INTERFACE_XML_820}" )
		ConfraternityMessage_WarningText : Show()
		ConfraternityMessage_Ok : Show()
	elseif currentChoose == 2 then									-- 1��ȷ�Ͽ�2������򡣣�3���鿴��
		ConfraternityMessage_Title : SetText( "#{INTERFACE_XML_55}" )
		ConfraternityMessage_WarningText : Hide()
		ConfraternityMessage_Ok : Hide()
		ConfraternityMessage_EditInfo : Show()
		ConfraternityMessage_Set : Show()
	elseif currentChoose == 3 then									-- 1��ȷ�Ͽ�2������򡣣�3���鿴��
		ConfraternityMessage_Title : SetText( "#{INTERFACE_XML_972}" )
		str = Guild : GetGuildLeaveWord();
		ConfraternityMessage_WarningText : SetText( str )
		ConfraternityMessage_WarningText : Show()
		ConfraternityMessage_Ok : Hide()
		ConfraternityMessage_EditInfo : Hide()
		ConfraternityMessage_Set : Hide()
	end
	
end

function ConfraternityMessage_OK_Clicked()
	if currentChoose == 1 then										-- 1��ȷ�Ͽ�2������򡣣�3���鿴��
		-- ���Ľ�Ǯ���㣬��ȷ��
		if (Player : GetData( "MONEY" ) + Player : GetData( "MONEY_JZ" ) )< moneyCosts then
			PushDebugMessage( "Ng�n l��ng c�a c�c h� kh�ng � thanh to�n" )
		else
			-- ͬ��֧��
			Guild : ModifyGuildLeaveWord( 1 )
			return
		end
	elseif currentChoose == 2 then									-- 1��ȷ�Ͽ�2������򡣣�3���鿴��
		local ret = Guild : ModifyGuildLeaveWord( ConfraternityMessage_EditInfo : GetText() )
		if ret == false then
			return
		end
	end

	ConfraternityMessage_Close()
end

function ConfraternityMessage_Cancel_Clicked()
	ConfraternityMessage_Close()
end

function ConfraternityMessage_Close()
	this : Hide()
	ConfraternityMessage_Clear()
end

function ConfraternityMessage_Clear()
	currentChoose = -1
	ConfraternityMessage_EditInfo : SetText( "" )
end


--================================================
-- �ָ������Ĭ�����λ��
--================================================
function ConfraternityMessage_Frame_On_ResetPos()
  ConfraternityMessage_Frame:SetProperty("UnifiedPosition", g_ConfraternityMessage_Frame_UnifiedPosition);
end
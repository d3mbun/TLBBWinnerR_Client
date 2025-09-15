local g_FrameInfo
local g_ClickOk
local g_ClickCancel

local PVPFLAG = { ACCEPTDUEL = 205, DuelGUID = "", DuelName = "" }
--===============================================
-- OnLoad()
--===============================================
function AcceptBox_PreLoad()
    this:RegisterEvent("MSGBOX_ACCEPTDUEL");
end

--===============================================
-- OnLoad()
--===============================================
function AcceptBox_OnLoad()

end

--===============================================
-- OnEvent()
--===============================================
function AcceptBox_OnEvent(event)    
    g_ClickOk = 0
    g_ClickCancel = 0
    g_FrameInfo = 0
    
	AcceptBox_UpdateFrame();

	if ( event == "MSGBOX_ACCEPTDUEL" ) then
	AxTrace( 0, 0, "AcceptBox_OnEvent MSGBOX_ACCEPTDUEL" )
	    local Name = tostring( arg0 )
	    local GUID = tostring( arg1 )
	    PVPFLAG.DuelName = Name
	    PVPFLAG.DuelGUID = GUID
	    g_FrameInfo = PVPFLAG.ACCEPTDUEL;	    
	    local MsgText = "#c0000FF"..Name.."#W".."��a ra v�i c�c h� #cFF0000 t� th�#W,c�c h� ph�i ch�ng �ng �?#rCh� �: trong qu� tr�nh t� th� s�ng ch�t s� b� tr�ng ph�t"
	    AcceptBox_Text:SetText( MsgText )
	    this:Show();		
	end
	
end


--===============================================
-- UpdateFrame
--===============================================
function AcceptBox_UpdateFrame()
	AcceptBox_PageHeader_Name:SetText("#gFF0FA0X�c nh�n t� th�");
end


--===============================================
-- ���ȷ����IDOK��
--===============================================
function AcceptBox_OK_Clicked()
    if( PVPFLAG.ACCEPTDUEL == g_FrameInfo ) then
        AxTrace( 0, 0, "AcceptBox_OK_Clicked" )
        DuelAccept( tostring( PVPFLAG.DuelName ),tostring( PVPFLAG.DuelGUID ), 1 )
    end
    
    g_ClickOk = 1
	this:Hide();
end

--===============================================
-- ������̯(IDCONCEL)
--===============================================
function AcceptBox_Cancel_Clicked(bClick)
    AxTrace( 0, 0, "AcceptBox_Cancel_Clicked"..tostring( bClick ) )
    g_ClickCancel = 1
    
	--if( 0 == g_ClickOk ) then
	    if( 1 == bClick ) then
			if( PVPFLAG.ACCEPTDUEL == g_FrameInfo ) then
			    AxTrace( 0, 0,  "Duel Cancel......AcceptBox_Cancel_Clicked........................................" )
				DuelAccept( tostring( PVPFLAG.DuelName ), tostring( PVPFLAG.DuelGUID ), 0 )
			end
		end
	--end    
    
	this:Hide();
end

function AcceptBox_OnHide()
    if( 0 == g_ClickCancel ) then
        if( 0 == g_ClickOk ) then
            if( PVPFLAG.ACCEPTDUEL == g_FrameInfo ) then
                AxTrace( 0, 0,  "Duel Cancel......AcceptBox_OnHide........................................" )
                DuelAccept( tostring( PVPFLAG.DuelName ), tostring( PVPFLAG.DuelGUID ), 0 )
            end
        end
    end
    
end
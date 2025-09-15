

function PK_message_PreLoad()
	this:RegisterEvent("UI_COMMAND");
end

function PK_message_OnLoad()
end

function PK_message_OnEvent(event)
    if ( event == "UI_COMMAND" ) then
        local WndID = tonumber( arg0 )
  
        if( 123 == WndID ) then
            PK_Input_Name:SetText( "" )
            PK_Input_ID:SetText( "" )
            this:Show();
        end                
    end
end

function PK_message_PK_Input_ID_OK_Clicked()
    local ID = PK_Input_ID:GetText()

    if( "" == ID ) then
        ShowNotice( "ID ��ng nh�p kh�ng ���c � tr�ng" )
    else
        DuelByGuid_OKClicked( ID )
        this:Hide();
    end

end

function PK_message_PK_Input_Name_OK_Clicked()
    local Name = PK_Input_Name:GetText()

    if( "" == Name ) then    
        ShowNotice( "H� t�n ��ng nh�p kh�ng ���c � tr�ng" )        
    else
        DuelByName_OKClicked( Name )
        this:Hide();   
    end

end
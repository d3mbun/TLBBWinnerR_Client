
local currentSearchMode = 0;
local currentPosition;

local temp_id;
local temp_bOnline;
local temp_name;
local temp_bPrecise;
local temp_str,temp_index;

local temp_nMenpai;
local temp_nSex;
local temp_LevelDown;
local temp_LevelUp;
local temp_banghui;

local g_FriendSearch_Frame_UnifiedPosition;

--===============================================
-- OnLoad()
--===============================================
function FriendSearch_PreLoad()

	this:RegisterEvent("OPEN_FRIEND_SEARCH");
	this:RegisterEvent("SEARCH_FRIEND_OK");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end
function FriendSearch_OnLoad()


	FriendSearch_SearchMode:ComboBoxAddItem("T�n",0);
	FriendSearch_SearchMode:ComboBoxAddItem("ID",1);
	FriendSearch_SearchMode:SetCurrentSelect( 0 );
	local str,index = FriendSearch_SearchMode:GetCurrentSelect();
	AxTrace( 1,0,"str="..str.."index="..tostring( index ) );
	FriendSearch_Module2_CheckBox1:SetCheck( 0 );
	FriendSearch_Module2_CheckBox2:SetCheck( 0 );

	FriendSearch_MenPai:ComboBoxAddItem("To�n b�",-3 );
	FriendSearch_MenPai:ComboBoxAddItem("B�t k�",-2 );
	FriendSearch_MenPai:ComboBoxAddItem("Kh�ng c�", -1 );
	FriendSearch_MenPai:ComboBoxAddItem("Thi�u L�m", 0 );
	FriendSearch_MenPai:ComboBoxAddItem("Minh Gi�o", 1 );
	FriendSearch_MenPai:ComboBoxAddItem("C�i Bang", 2 );
	FriendSearch_MenPai:ComboBoxAddItem("V� �ang", 3 );
	FriendSearch_MenPai:ComboBoxAddItem("Nga My", 4 );
	FriendSearch_MenPai:ComboBoxAddItem("Tinh T�c", 5 );
	FriendSearch_MenPai:ComboBoxAddItem("Thi�n Long", 6 );
	FriendSearch_MenPai:ComboBoxAddItem("Thi�n S�n", 7 );
	FriendSearch_MenPai:ComboBoxAddItem("Ti�u Dao", 8 );
	FriendSearch_MenPai:ComboBoxAddItem("M� Dung", 10);
	FriendSearch_MenPai:SetCurrentSelect( 0 );


	FriendSearch_Confraternity:ComboBoxAddItem("To�n b�",-3 );
	FriendSearch_Confraternity:ComboBoxAddItem("B�t k�",-2 );
	FriendSearch_Confraternity:ComboBoxAddItem("Kh�ng c� Bang ph�i",-1 );
	FriendSearch_Confraternity:SetCurrentSelect( 0 );

	FriendSearch_Sexy:ComboBoxAddItem("Kh�ng gi�i h�n",-1 );
	FriendSearch_Sexy:ComboBoxAddItem( "N�", 0 );
	FriendSearch_Sexy:ComboBoxAddItem( "Nam", 1 );
	FriendSearch_Sexy:SetCurrentSelect( 0 );

	FriendSearch_Level:ComboBoxAddItem("B�t k�",-1 );
	FriendSearch_Level:ComboBoxAddItem( "1 - 10", 0 );
	FriendSearch_Level:ComboBoxAddItem( "11 - 20", 1 );
	FriendSearch_Level:ComboBoxAddItem( "21 - 30", 2 );
	FriendSearch_Level:ComboBoxAddItem( "31 - 40", 3 );
	FriendSearch_Level:ComboBoxAddItem( "41 - 50", 4 );
	FriendSearch_Level:ComboBoxAddItem( "51 - 60", 5 );
	FriendSearch_Level:ComboBoxAddItem( "61 - 70", 6 );
	FriendSearch_Level:ComboBoxAddItem( "71 - 80", 7 );
	FriendSearch_Level:ComboBoxAddItem( "81 - 90", 8 );
	FriendSearch_Level:ComboBoxAddItem( "91 - 100", 9 );
	FriendSearch_Level:ComboBoxAddItem( "101 - 110", 10 );
	FriendSearch_Level:ComboBoxAddItem( "111 - 120", 11 );

	FriendSearch_Level:SetCurrentSelect( 0 );
	
	 g_FriendSearch_Frame_UnifiedPosition=FriendSearch_Frame:GetProperty("UnifiedPosition");

end

--===============================================
-- OnEvent()
--===============================================
function FriendSearch_OnEvent( event )

	if ( event == "OPEN_FRIEND_SEARCH" ) then
		FriendSearch_Info:RemoveAllItem();
		this:Show();
		FrinedSearch_UpdataFilter();
		FriendSearch_DiableButton();
	elseif( event =="SEARCH_FRIEND_OK" ) then
		FriendSearch_UpdateCurrentPage();
		
	elseif (event == "ADJEST_UI_POS" ) then
		FriendSearch_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		FriendSearch_Frame_On_ResetPos()
		
	end

end
-- update current page info
function FriendSearch_UpdateCurrentPage()


	FriendSearch_Info:RemoveAllItem();
	FriendSearch_UpdateButton();
	local nNumber = FriendSearcher:GetFriendNumberInPage( currentPosition );
	AxTrace( 0,0,"current page have "..tostring( nNumber ).." friends" );
	local i = 0;
	while( i < nNumber ) do
		local name = FriendSearcher:GetFriendFromPage( currentPosition, i, "NAME" );
		local id = FriendSearcher:GetFriendFromPage( currentPosition, i, "ID_TEXT" );
		local bOnline = FriendSearcher:GetFriendFromPage( currentPosition, i, "ONLINE" );
		local nLevel = FriendSearcher:GetFriendFromPage( currentPosition, i, "LEVEL" );
		local nSex = FriendSearcher:GetFriendFromPage( currentPosition, i, "SEX" );
		local strMenpai= FriendSearcher:GetFriendFromPage( currentPosition, i, "MENPAI_TEXT" );
		local strBangpai = FriendSearcher:GetFriendFromPage( currentPosition, i, "GUID_NAME" );
		local strMenpai_Type= FriendSearcher:GetFriendFromPage( currentPosition, i, "MENPAI_TYPE" )

		local namecolor = "#cC4B299";
		if( bOnline ) then
			namecolor = "#cFFFFFF";
		end

		FriendSearch_Info:AddNewItem( namecolor..name, 0, i );
		FriendSearch_Info:AddNewItem( namecolor..id, 1, i );
		if( bOnline ) then
			FriendSearch_Info:AddNewItem( namecolor.."Online", 2, i );
		else
			FriendSearch_Info:AddNewItem( namecolor.."Offline", 2, i );
		end
		FriendSearch_Info:AddNewItem( namecolor..tostring( nLevel ), 3, i );

		if( tonumber( nSex ) == 0 ) then
			FriendSearch_Info:AddNewItem( namecolor.."N�", 4, i );
		else
			FriendSearch_Info:AddNewItem( namecolor.."Nam", 4, i );
		end
		if strMenpai_Type==10 then
			strMenpai="M� Dung"
		end
		FriendSearch_Info:AddNewItem( namecolor..strMenpai, 5, i );
		FriendSearch_Info:AddNewItem( namecolor..strBangpai, 6, i );

		i = i + 1;
	end
end

function FriendSearch_Close()
	this:Hide();
end
function FriendSearch_BeginSearch()
	FriendSearch_DiableButton();
	temp_id = FriendSearch_Condition_Name:GetText();
	temp_bOnline = FriendSearch_Module2_CheckBox2:GetCheck();
	temp_name = FriendSearch_Condition_Name:GetText();
	temp_bPrecise = FriendSearch_Module2_CheckBox1:GetCheck();
	temp_str,temp_index = FriendSearch_SearchMode:GetCurrentSelect();

	temp_str,temp_nMenpai = FriendSearch_MenPai:GetCurrentSelect();
	temp_str,temp_banghui = FriendSearch_Confraternity:GetCurrentSelect();
	temp_str,temp_nSex = FriendSearch_Sexy:GetCurrentSelect();

	local str,nLevelDown = FriendSearch_Level:GetCurrentSelect();

	if( nLevelDown == -1 ) then
		temp_LevelDown = -1;
		temp_LevelUp = -1;
	else
		temp_LevelDown = nLevelDown * 10 + 1;
		temp_LevelUp = temp_LevelDown + 9;
	end

	temp_str,temp_searchtype = FriendSearch_SearchMode:GetCurrentSelect();

	currentPosition = 0;
	FriendSearch_Info:RemoveAllItem();
	FriendSearcher:ClearFingerList();
	FriendSearch_Search( currentPosition );
end
function FriendSearch_Search( nPosition )


	if( currentSearchMode == 0 ) then
		if( temp_searchtype == 1 ) then
				if( temp_id == "" ) then
					return;
				end
				FriendSearcher:FriendSearchByID( tostring( temp_id ), tonumber( temp_bOnline ) );
		elseif( temp_searchtype == 0 ) then
				FriendSearcher:FriendSearchByName( temp_name, temp_bPrecise, temp_bOnline, nPosition );
		end
	else

		FriendSearcher:FriendSearchAdvance( nPosition, tonumber( temp_nMenpai ), temp_banghui, tonumber( temp_nSex ), tonumber(temp_LevelDown), tonumber(temp_LevelUp) );
	end


end
function FriendSearch_NextPage()
	currentPosition = currentPosition + 1;
	FriendSearch_DiableButton();
	FriendSearch_Search( currentPosition );
end

function FriendSearch_LastPage()
	currentPosition = currentPosition - 1;
	FriendSearch_DiableButton();
	FriendSearch_Search( currentPosition );
end

function FriendSearch_ViewInfo()
		local nCurrentSelect = FriendSearch_Info:GetSelectItem();
		local name = FriendSearcher:GetFriendFromPage( currentPosition, nCurrentSelect, "NAME" );
		if( Friend:IsPlayerIsFriend( name ) == 1 ) then
			local nGroup,nIndex;
			nGroup,nIndex = DataPool:GetFriendByName( name );
			--Friend:SetCurrentSelect( nIndex );
			DataPool:ShowFriendInfo( name );
		else

			DataPool:ShowChatInfo( name );
		end
end

function FriendSearch_HighSearch()
	currentSearchMode = 1;
	FrinedSearch_UpdataFilter();
end

function FriendSearch_BaseSearch()
	currentSearchMode = 0;
	FrinedSearch_UpdataFilter();
end

function FrinedSearch_UpdataFilter()
	FriendSearch_DiableButton();
	if( currentSearchMode == 0 ) then
		FriendSearch_Module2:Show();
		FriendSearch_Module1:Hide();
	else
		FriendSearch_Module1:Show();
		FriendSearch_Module2:Hide();
	end
	FriendSearch_Info:RemoveAllItem();
	FriendSearcher:ClearFingerList();
end


function FriendSearch_UpdateButton()

	if( currentPosition >= FriendSearcher:GetFriendPageNumber() - 1 ) then
		FriendSearch_DownPage:Disable();
	else
		FriendSearch_DownPage:Enable();

	end

	if( currentPosition == 0 )then
		FriendSearch_UpPage:Disable();
	else
		FriendSearch_UpPage:Enable();
	end
	AxTrace( 0,0, "current select = "..tostring( FriendSearch_Info:GetSelectItem() ) );
	if( FriendSearch_Info:GetSelectItem() == -1 ) then
		FriendSearch_examine:Disable();
	else
		FriendSearch_examine:Enable();
	end
end

function FriendSearch_DiableButton()

	FriendSearch_DownPage:Disable();
	FriendSearch_UpPage:Disable();
	FriendSearch_examine:Disable();

end

function FriendSearch_Frame_On_ResetPos()
  FriendSearch_Frame:SetProperty("UnifiedPosition", g_FriendSearch_Frame_UnifiedPosition);
end
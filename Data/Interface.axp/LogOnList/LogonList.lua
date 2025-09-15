
local g_ScenIDTable = {}

local g_iRoleSel = 0;

function IsValInTable( Table, Val )
    
    for i, TempVal in Table do
        if TempVal == Val then
            return 1
        end
    end
    
    return 0
    
end

function RandomTable( Count )

    local TempTable
    TempTable = {}
    
    for i=0, 1000 do
    
		local RandomIndex = math.random( 0, Count - 1 )
		local InTable = IsValInTable( TempTable, RandomIndex )
 
		if( 0 == InTable ) then
			table.insert( TempTable, 0, RandomIndex )
			AxTrace( 1, 0, "insert RandomIndex="..RandomIndex )
		end
		
		if( Count == table.getn( TempTable ) ) then
		    g_ScenIDTable = TempTable		    
		    return
		end
		
    
    end
        
end


function LogonList_PreLoad()
	
	-- �򿪽���
	this:RegisterEvent("OPEN_ENTERING_SCENE_DLG");

	this:RegisterEvent("GAMELOGIN_OPEN_COUNT_INPUT");
	
end

-- ע��onLoad�¼�
function LogonList_OnLoad()
	
	
	--this:Show();
end

-- OnEvent
function LogonList_OnEvent(event)

	--this:Show();
	--
	-- �򿪽����¼�.
	--
	if ( event == "OPEN_ENTERING_SCENE_DLG" ) then

		AxTrace( 0,0, "M� ra t�nh c�nh l�a ch�n li�t �");
		AddEnterSceneInfo(tonumber(arg0));
		this:Show();
		return;
	end;

	if ( event == "GAMELOGIN_OPEN_COUNT_INPUT" ) then
		this:Hide();
		return;
	end;

	
		
end


function AddEnterSceneInfo(iRoleIndex)

	-- ��¼��ǰѡ��Ľ�ɫ��
	g_iRoleSel = iRoleIndex;
	
	LogOnlist_ClearData();
	local iSceneCount  = GameProduceLogin:GetSceneInfoCount(iRoleIndex);
	local strSceneName = "";
	
	-- �õ�ѡ��Ľ�ɫ���Խ���ĳ�����Ϣ
	for index =0 , iSceneCount-1 do
	 	g_ScenIDTable[ index ] = index	
	 	--strSceneName = GameProduceLogin:GetSceneInfo(iRoleIndex, index);
		--LogOnlist_List:AddItem( strSceneName, index, "FFFFFFFF", 4 );
	end
	
	RandomTable( iSceneCount )
	
	local TableSize = table.getn( g_ScenIDTable )
	for  i=0, TableSize-1 do
	    strSceneName = GameProduceLogin:GetSceneInfo(iRoleIndex, g_ScenIDTable[i] );
	    LogOnlist_List:AddItem( strSceneName, i, "FFFFFFFF", 4 );
	end
	
	LogOnlist_List:SetItemSelect( 0 )
	
end;

function LogOnlist_Choose_Click()

	-- �������ִ塣
	local iSceneIndex = LogOnlist_List:GetFirstSelectItem();
	iSceneIndex = g_ScenIDTable[ iSceneIndex ]
	
	GameProduceLogin:EnterNewRoleScene(g_iRoleSel, iSceneIndex);
	this:Hide();
end;

function LogOnlist_Refuse_Click()

	this:Hide();
end;


function LogOnlist_ClearData()

	LogOnlist_List:ClearListBox();

end;
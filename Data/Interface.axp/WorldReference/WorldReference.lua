
local g_WorldReference_Frame_UnifiedXPosition;
local g_WorldReference_Frame_UnifiedYPosition;

function WorldReference_PreLoad()
    --AxTrace( 0, 0, "WorldReference_PreLoad" )
    this:RegisterEvent("OPEN_WORLDREFERENCE")
    this:RegisterEvent("OPEN_WORLDREFERENCE_TIME")
    this:RegisterEvent("OPEN_PKDESC")
    this:RegisterEvent("OPEN_ACCOUNT_SAFE")
    this:RegisterEvent("WR_SHOWBOSSINFO")
    this:RegisterEvent("OPEN_MONSTER_TABLE")
    
    this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function WorldReference_OnLoad()

g_WorldReference_Frame_UnifiedXPosition	= WorldReference_Frame:GetProperty("UnifiedXPosition");
g_WorldReference_Frame_UnifiedYPosition	= WorldReference_Frame:GetProperty("UnifiedYPosition");

end

function WorldReference_OpenPKDesc()
    WorldReferenceGreeting_Desc:ClearAllElement()
    --WorldReference_PageHeader:SetText("#{INTERFACE_XML_39}")
    WorldReference_PageHeader:SetText("Li�n quan �n PK")
    WorldReferenceGreeting_Desc:AddTextElement( "#{PK_HELP_001}")
    this:Show();
end

--=========================================================
-- �¼�����
--=========================================================
function WorldReference_OnEvent(event)
    WorldReference_PageHeader:SetText("#{INTERFACE_XML_39}")

	if(event == "OPEN_WORLDREFERENCE") then
      WorldReference_DispatchMainPage()
	end

	if(event == "OPEN_WORLDREFERENCE_TIME") then
	  local Date = tostring( arg0 )
	  AxTrace( 0, 0, Date )
	  WorldReference_DispatchServerTime( Date )
	end

	if(event == "OPEN_PKDESC") then
        WorldReference_OpenPKDesc()
	end

	if( event == "OPEN_ACCOUNT_SAFE") then
		WorldReference_OpenAccountSafeDesc();
	end

	if(event == "WR_SHOWBOSSINFO") then
        WorldReference_OpenBossInfo( arg0 )
	end

	if(event == "OPEN_MONSTER_TABLE") then
     WorldReferenceGreeting_Desc:ClearAllElement()
     WorldReference_DispatchMonsterTable()
     this:Show();
	end
	
	if( event == "ADJEST_UI_POS" ) then
		WorldReference_ResetPos()
	end

	if( event == "VIEW_RESOLUTION_CHANGED" ) then
		WorldReference_ResetPos()
	end

end

--=========================================================
-- �ر���Ӧ
--=========================================================
function WorldReference_Close()
end

--=========================================================
-- ��ʾ�����б�
--=========================================================
function WorldReference_EventListUpdate()
end

--=========================================================
-- ��ʾ������Ϣ
--=========================================================
function WorldReference_WorldReferenceInfoUpdate()
end

--=========================================================
--Continue����ĶԻ���
--=========================================================
function WorldReference_MissionContinueUpdate(bDone)
end

--=========================================================
--��ȡ������Ʒ�ĶԻ���
--=========================================================
function WorldReference_MissionRewardUpdate()
end


function WorldReference_OpenAccountSafeDesc()
		WorldReferenceGreeting_Desc:ClearAllElement()
    --WorldReference_PageHeader:SetText("#{JIANGHU_ACCOUNT_SAFE_1}")
		WorldReference_DispatchAccountSafeTable(6);
    this:Show();
end


--=========================================================
--��ʾ��ҳ
--=========================================================
function WorldReference_DispatchMainPage()

	WorldReferenceGreeting_Desc:ClearAllElement();
	WRCollectVisiableContex( 0 )

	local NumVisiable = tonumber( WRGetVisiableContexCount() )

	WorldReferenceGreeting_Desc:AddTextElement( "Ghi nh� m�i l�n ��t 1 c�p b�c m�i kh�c th� m� t�i ra xem, t�i s� n�i cho c�c h� r�t nhi�u vi�c trong giang h� hi�n t�i")

	for i=0, NumVisiable-1 do
	    local VisiableID = WRGetVisiableContexID( i )
	    if( -1 ~= VisiableID ) then
	        --local strContex = WRGetVisiableContex( 0, VisiableID )
	        local strContex = WRGetTitle( 0, VisiableID )
	        local strTemp = strContex.."&0,"..(VisiableID+1).."$0"
	        WorldReferenceGreeting_Desc:AddOptionElement( strTemp );
	    end

	end

--	WorldReference_Frame_Debug:SetText("����ָ��")

	this:Show();
end

function WorldReference_DispatchTable( TableID )
    WorldReferenceGreeting_Desc:ClearAllElement();

	WRCollectVisiableContex( TableID )   --���������
	local NumVisiable = tonumber( WRGetVisiableContexCount() )
	if(NumVisiable>0 and TableID == 1)then
		local strTemp = "Ki�m tra nhi�m v� c� th� ti�p nh�n".."&"..TableID..","..(-1).."$0"
	        WorldReferenceGreeting_Desc:AddOptionElement( strTemp );
	end
	for i=0, NumVisiable-1 do
	    local VisiableID = WRGetVisiableContexID( i )
	    if( -1 ~= VisiableID ) then
	        local strTitle = WRGetTitle( TableID, VisiableID )
	        AxTrace( 0, 0, "strTitle="..strTitle )

	        local strTemp = strTitle.."&"..TableID..","..(VisiableID).."$0"
	        WorldReferenceGreeting_Desc:AddOptionElement( strTemp );
	    end

	end

    local strBack = "Tr� v� trang �u".."&0,0".."$0"
	WorldReferenceGreeting_Desc:AddOptionElement( strBack );
end

--=========================================================
--��ʾ����ҳ
--=========================================================
function WorldReference_DispatchMissionTable()
    WorldReference_DispatchTable( 1 )
end

--=========================================================
--��ʾ����ҳ
--=========================================================
function WorldReference_DispatchMonsterTable()
    WorldReference_DispatchTable( 2 )
end

--=========================================================
--��ʾ"����"ҳ
--=========================================================
function WorldReference_DispatchOtherTable()
    WorldReference_DispatchTable( 5 )
end

--=========================================================
--��ʾBOSS��ҳ
--=========================================================
function WorldReference_DispatchBossTable()

	WorldReferenceGreeting_Desc:ClearAllElement();

	local menuLevel = -1
	local parentId = -1

	WRCollectVisiableContex( 3 )
	local NumVisiable = tonumber( WRGetVisiableContexCount() )

	for i=0, NumVisiable-1 do
		local VisiableID = WRGetVisiableContexID( i )
		if -1 ~= VisiableID then
			menuLevel,parentId = WRBOSSTblGetContexInfo( VisiableID )
			if -1 == parentId then
				local strTitle = WRGetTitle( 3, VisiableID )
				local strTemp = strTitle.."&"..(3)..","..VisiableID.."$0"
				WorldReferenceGreeting_Desc:AddOptionElement( strTemp )
			end
		end
	end

	local strBack = "Tr� v� trang �u".."&0,0".."$0"
	WorldReferenceGreeting_Desc:AddOptionElement( strBack )

end

--=========================================================
--��ʾ"�ʺŰ�ȫ"ҳ
--=========================================================
function WorldReference_DispatchAccountSafeTable( TableID )
 WorldReferenceGreeting_Desc:ClearAllElement();

	WRCollectVisiableContexEx( TableID, -1, 1 )   --�ʺŰ�ȫ������
	WorldReferenceGreeting_Desc:AddTextElement( "    D߾i ��y gi�i thi�u v� th�ng tin v� an to�n t�i kho�n, bao g�m c�i �t m�t m�, s� d�ng c�ng n�ng b�o h� c�a tr� ch�i, .. Th�ng tin chi ti�t xin xem trong m�c l�c.")	--�ʺ�  to  �˺�
	local NumVisiable = tonumber( WRGetVisiableContexCount() )
	for i=0, NumVisiable-1 do
	    local VisiableID = WRGetVisiableContexID( i )
	    if( -1 ~= VisiableID ) then
	        local strTitle = WRGetVisiableContex( TableID, VisiableID )
	        AxTrace( 0, 0, "strTitle="..strTitle )

	        local strTemp = strTitle.."&"..TableID..","..(VisiableID).."$0"
	        WorldReferenceGreeting_Desc:AddOptionElement( strTemp );
	    end

	end

  local strBack = "Tr� v� trang �u".."&0,0".."$0"
	WorldReferenceGreeting_Desc:AddOptionElement( strBack );
end

--�����ʺŰ�ȫ ����ĺ���
function WorldReference_DispatchContexAccount(TableID, ContexID)
  	WorldReferenceGreeting_Desc:ClearAllElement()
  	if( ContexID < 0) then
  		WRCollectVisiableContexEx( TableID, -ContexID, 0 )		--��һ��
  	else
  		WRCollectVisiableContexEx( TableID, ContexID, 1 )   --�ʺŰ�ȫ������
  	end
		local NumVisiable = tonumber( WRGetVisiableContexCount() )
		local VisiableID =-1;
		for i=0, NumVisiable-1 do
	     VisiableID = WRGetVisiableContexID( i )
	     if( -1 ~= VisiableID ) then
        local strTitle = WRGetVisiableContex( TableID, VisiableID )
        --AxTrace( 0, 0, "strTitle="..strTitle )
        if WRGetContexType( TableID, VisiableID ) == 3 then
        	WorldReferenceGreeting_Desc:AddTextElement( strTitle );
        else
          local strTemp = strTitle.."&"..TableID..","..(VisiableID).."$0"
        	WorldReferenceGreeting_Desc:AddOptionElement( strTemp );
        end
	    end
		end
		local strBack;
		--VisiableID = WRGetVisiableContexID( 0 )
    if VisiableID ~= -1  and WRGetContexType( TableID, VisiableID ) > 1 then
    	strBack = "Quay l�i".."&"..TableID..","..(-VisiableID).."$0"
    else
    	strBack = "Tr� v� trang �u".."&0,0".."$0"
    end
		WorldReferenceGreeting_Desc:AddOptionElement( strBack );
end

--=========================================================
--������BOSS����ĳһ����¼�....
--=========================================================
function WorldReference_BOSSOptionClicked( Data2 )

	WorldReferenceGreeting_Desc:ClearAllElement()

	local menuLevel = -1
	local parentId = -1

	--�������Ƿ����ϼ��˵���ѡ��....���൱�ڵ��-Date2�˵�....
	if Data2 < 0 then
		Data2 = -Data2
	end

	--��ȡ��ѡ��Ŀ����Ϣ....
	menuLevel,parentId = WRBOSSTblGetContexInfo( Data2 )

	--���ѡ�Ĳ��ǲ˵�������������������ʾ����....
	if menuLevel == -1 then

		--������������....
    local strContex = WRGetVisiableContex( 3, Data2 )
    WorldReferenceGreeting_Desc:AddTextElement( strContex )

	else --���ѡ���ǲ˵�����ʾ�������Title....

		--�ռ�����IDΪData2�Ŀ���Ŀ....
		WRBOSSTblCollectVisiableContex( Data2 )

		--������Ŀ��������....
		local NumVisiable = WRGetVisiableContexCount()
		for i=0, NumVisiable-1 do
	    local VisiableID = WRGetVisiableContexID( i )
	    if -1 ~= VisiableID then
				local strTitle = WRGetTitle( 3, VisiableID )
				local strTemp = strTitle.."&"..(3)..","..VisiableID.."$0"
				WorldReferenceGreeting_Desc:AddOptionElement( strTemp )
	    end
		end

	end

	--���뷵���ϲ��ѡ��....
	local strBack
	if -1 == parentId then
			strBack = "Quay l�i".."&0,"..(3).."$0"
	else
		strBack = "Quay l�i".."&3,"..-parentId.."$0"
	end
	WorldReferenceGreeting_Desc:AddOptionElement( strBack )

end

--=========================================================
--��ʾʱ��
--=========================================================
function WorldReference_DispatchServerTime( strDate )
    WorldReferenceGreeting_Desc:ClearAllElement()

    WorldReferenceGreeting_Desc:AddTextElement( strDate )

    local strBack = "Tr� v� trang �u".."&0,"..(0).."$0"
	WorldReferenceGreeting_Desc:AddOptionElement( strBack );
end

function WorldReference_DispatchContex( TableID, ContexIndex )
    if( TableID == 1 and ContexIndex == -1) then   --����ָ��
            	--�򿪿ɽ������б�
		ToggleMissionOutLine();
		return
    end
    WorldReferenceGreeting_Desc:ClearAllElement()
    local strContex = WRGetVisiableContex( TableID, ContexIndex )
    WorldReferenceGreeting_Desc:AddTextElement( strContex )

    local strBack = "Quay l�i".."&0,"..TableID.."$0"
	WorldReferenceGreeting_Desc:AddOptionElement( strBack );

end

--=========================================================
-- ѡ��һ������
--=========================================================
function WorldReferenceOption_Clicked()

	--���ֵĸ�ʽ��
	--QuestGreeting_option_03&211207,0
	pos1,pos2 = string.find(arg0,"#");
	pos3,pos4 = string.find(arg0,",");

	local strOptionID = -1;
	local strOptionExtra1 = string.sub(arg0, pos2+1,pos3-1 );
	local strOptionExtra2 = string.sub(arg0, pos4+1);

    local Data1 = tonumber( strOptionExtra1 )      --Data1Ϊ��ı��
    local Data2 = tonumber( strOptionExtra2 )      --Data2Ϊ�������ݵ�index


    if( Data1 == 0 ) then       --��ҳ
        if( Data2 == 0 ) then   --��ҳ
            WorldReference_DispatchMainPage()
        end

        if( Data2 == 1 ) then   --�����
            WorldReference_DispatchMissionTable()
        end

        if( Data2 == 2 ) then   --����
            WorldReference_DispatchMonsterTable()
        end
        if( Data2 == 3 ) then   --BOSS
            WorldReference_DispatchBossTable()
        end

        if( Data2 == 4 ) then   --ʱ��
            WRAskTime()
        end

        if( Data2 == 5 ) then   --������
            WorldReference_DispatchOtherTable()
        end

        if( Data2 == 6) then		--�ʺŰ�ȫ��
			--WorldReference_DispatchAccountSafeTable(Data2);
			GameProduceLogin:OpenURL( "http://tl.gate.vn/" )
        		return;
        end

        if( Data2 > 6 ) then
            WorldReference_DispatchContex( Data1, Data2 - 1 )
        end

    elseif( Data1 == 3 ) then	--BOSS��Ϊ��֧�ֶ༶�˵���Ҫ�������⴦��....
    	WorldReference_BOSSOptionClicked(Data2);
    elseif( Data1 == 6 ) then	--�ʺŰ�ȫ�������
    	WorldReference_DispatchContexAccount(Data1, Data2);
    else
			WorldReference_DispatchContex( Data1, Data2 )   --��ʾһ�������ı�
    end

end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_WorldReference(objCaredId)
end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_WorldReference(objCaredId)
end

--=========================================================
--��ʾĳ��BOSS����Ϣ....
--=========================================================
function WorldReference_OpenBossInfo( BossId )

	WorldReference_BOSSOptionClicked( tonumber(BossId) )
	this:Show();

end

function WorldReference_ResetPos()
	WorldReference_Frame:SetProperty("UnifiedXPosition", g_WorldReference_Frame_UnifiedXPosition);
	WorldReference_Frame:SetProperty("UnifiedYPosition", g_WorldReference_Frame_UnifiedYPosition);

end

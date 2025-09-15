
local Reputation_Progress1={};
local Reputation_Progress2={};
local Reputation_Progress3={};
local Reputation_CurLevel = {};
local Reputation_Text		= {};
local Reputation_Name = {};
local Reputation_TextName ={};
local Reputation_Back ={};
local Reputation_RelationType ={};

local Reputation_Page = 0;

-- �����Ĭ�����λ��
local g_Reputation_Frame_UnifiedXPosition;
local g_Reputation_Frame_UnifiedYPosition;

function Reputation_PreLoad()

	this:RegisterEvent("OPEN_WINDOW");

	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")

	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

end


function Reputation_OnLoad()

	Reputation_TextName = { "Thi�u L�m",
							"Minh Gi�o",
							"C�i Bang",
							"V� �ang",
							"Nga My",
							"Tinh T�c",
							"Thi�n Long",
							"Thi�n S�n",
							"Ti�u Dao",
							"��i T�ng",
							"��iT�ng �oan V߽ng Ph�",
							"��i T�ng d�n gian",
							"Tri�u ��nh ��i Li�u",
							"��i Li�u d�n gian",
							"��i L�",
							"T�y H�",
							"Th� Ph�n",
							"M�ng C�i",
							"Di D�n",
							"K� L�u Vong",
							"B�ch Mi�u",
							"H�c Mi�u",
							"Tu La",
							"S�n Vi�t N� T� T�",
							"S�n Vi�t Nam H� Ph�p",
							"Ng�c Ng� Bang",
							"D� th�",
							"L�c l�m",
							"Y�u ma",
							"R߽ng",
							"C�nh K� Tr߶ng b�o s߽ng",
							"M� Dung",
							};

	Reputation_Progress1[ 1 ] = Reputation_Value_Menpai1_Value_Pic1;
	Reputation_Progress1[ 2 ] = Reputation_Value_Menpai2_Value_Pic1;
	Reputation_Progress1[ 3 ] = Reputation_Value_Menpai3_Value_Pic1;
	Reputation_Progress1[ 4 ] = Reputation_Value_Menpai4_Value_Pic1;
	Reputation_Progress1[ 5 ] = Reputation_Value_Menpai5_Value_Pic1;
	Reputation_Progress1[ 6 ] = Reputation_Value_Menpai6_Value_Pic1;
	Reputation_Progress1[ 7 ] = Reputation_Value_Menpai7_Value_Pic1;
	Reputation_Progress1[ 8 ] = Reputation_Value_Menpai8_Value_Pic1;
	Reputation_Progress1[ 9 ] = Reputation_Value_Menpai9_Value_Pic1;
	Reputation_Progress1[ 10 ] = Reputation_Value_Menpai10_Value_Pic1;
	Reputation_Progress2[ 1 ] = Reputation_Value_Menpai1_Value_Pic2;
	Reputation_Progress2[ 2 ] = Reputation_Value_Menpai2_Value_Pic2;
	Reputation_Progress2[ 3 ] = Reputation_Value_Menpai3_Value_Pic2;
	Reputation_Progress2[ 4 ] = Reputation_Value_Menpai4_Value_Pic2;
	Reputation_Progress2[ 5 ] = Reputation_Value_Menpai5_Value_Pic2;
	Reputation_Progress2[ 6 ] = Reputation_Value_Menpai6_Value_Pic2;
	Reputation_Progress2[ 7 ] = Reputation_Value_Menpai7_Value_Pic2;
	Reputation_Progress2[ 8 ] = Reputation_Value_Menpai8_Value_Pic2;
	Reputation_Progress2[ 9 ] = Reputation_Value_Menpai9_Value_Pic2;
	Reputation_Progress2[ 10 ] = Reputation_Value_Menpai10_Value_Pic2;
	Reputation_Progress3[ 1 ] = Reputation_Value_Menpai1_Value_Pic3;
	Reputation_Progress3[ 2 ] = Reputation_Value_Menpai2_Value_Pic3;
	Reputation_Progress3[ 3 ] = Reputation_Value_Menpai3_Value_Pic3;
	Reputation_Progress3[ 4 ] = Reputation_Value_Menpai4_Value_Pic3;
	Reputation_Progress3[ 5 ] = Reputation_Value_Menpai5_Value_Pic3;
	Reputation_Progress3[ 6 ] = Reputation_Value_Menpai6_Value_Pic3;
	Reputation_Progress3[ 7 ] = Reputation_Value_Menpai7_Value_Pic3;
	Reputation_Progress3[ 8 ] = Reputation_Value_Menpai8_Value_Pic3;
	Reputation_Progress3[ 9 ] = Reputation_Value_Menpai9_Value_Pic3;
	Reputation_Progress3[ 10 ] = Reputation_Value_Menpai10_Value_Pic3;

	Reputation_CurLevel[ 1 ] = Reputation_Value_Menpai1_CurrentLevel;
	Reputation_CurLevel[ 2 ] = Reputation_Value_Menpai2_CurrentLevel;
	Reputation_CurLevel[ 3 ] = Reputation_Value_Menpai3_CurrentLevel;
	Reputation_CurLevel[ 4 ] = Reputation_Value_Menpai4_CurrentLevel;
	Reputation_CurLevel[ 5 ] = Reputation_Value_Menpai5_CurrentLevel;
	Reputation_CurLevel[ 6 ] = Reputation_Value_Menpai6_CurrentLevel;
	Reputation_CurLevel[ 7 ] = Reputation_Value_Menpai7_CurrentLevel;
	Reputation_CurLevel[ 8 ] = Reputation_Value_Menpai8_CurrentLevel;
	Reputation_CurLevel[ 9 ] = Reputation_Value_Menpai9_CurrentLevel;
	Reputation_CurLevel[ 10 ] = Reputation_Value_Menpai10_CurrentLevel;

	Reputation_Text[ 1 ] = Reputation_Value_Menpai1_Value_Number;
	Reputation_Text[ 2 ] = Reputation_Value_Menpai2_Value_Number;
	Reputation_Text[ 3 ] = Reputation_Value_Menpai3_Value_Number;
	Reputation_Text[ 4 ] = Reputation_Value_Menpai4_Value_Number;
	Reputation_Text[ 5 ] = Reputation_Value_Menpai5_Value_Number;
	Reputation_Text[ 6 ] = Reputation_Value_Menpai6_Value_Number;
	Reputation_Text[ 7 ] = Reputation_Value_Menpai7_Value_Number;
	Reputation_Text[ 8 ] = Reputation_Value_Menpai8_Value_Number;
	Reputation_Text[ 9 ] = Reputation_Value_Menpai9_Value_Number;
	Reputation_Text[ 10 ] = Reputation_Value_Menpai10_Value_Number;

	Reputation_Name[ 1 ] = Reputation_Value_Menpai1_Name;
	Reputation_Name[ 2 ] = Reputation_Value_Menpai2_Name;
	Reputation_Name[ 3 ] = Reputation_Value_Menpai3_Name;
	Reputation_Name[ 4 ] = Reputation_Value_Menpai4_Name;
	Reputation_Name[ 5 ] = Reputation_Value_Menpai5_Name;
	Reputation_Name[ 6 ] = Reputation_Value_Menpai6_Name;
	Reputation_Name[ 7 ] = Reputation_Value_Menpai7_Name;
	Reputation_Name[ 8 ] = Reputation_Value_Menpai8_Name;
	Reputation_Name[ 9 ] = Reputation_Value_Menpai9_Name;
	Reputation_Name[ 10 ] = Reputation_Value_Menpai10_Name;

	Reputation_Back[ 1 ] = Reputation_Value_Menpai1_Back;
	Reputation_Back[ 2 ] = Reputation_Value_Menpai2_Back;
	Reputation_Back[ 3 ] = Reputation_Value_Menpai3_Back;
	Reputation_Back[ 4 ] = Reputation_Value_Menpai4_Back;
	Reputation_Back[ 5 ] = Reputation_Value_Menpai5_Back
	Reputation_Back[ 6 ] = Reputation_Value_Menpai6_Back;
	Reputation_Back[ 7 ] = Reputation_Value_Menpai7_Back;
	Reputation_Back[ 8 ] = Reputation_Value_Menpai8_Back;
	Reputation_Back[ 9 ] = Reputation_Value_Menpai9_Back;
	Reputation_Back[ 10 ] = Reputation_Value_Menpai10_Back;

	Reputation_RelationType[ 1 ] = Reputation_Value_Menpai1_Relation;
	Reputation_RelationType[ 2 ] = Reputation_Value_Menpai2_Relation;
	Reputation_RelationType[ 3 ] = Reputation_Value_Menpai3_Relation;
	Reputation_RelationType[ 4 ] = Reputation_Value_Menpai4_Relation;
	Reputation_RelationType[ 5 ] = Reputation_Value_Menpai5_Relation
	Reputation_RelationType[ 6 ] = Reputation_Value_Menpai6_Relation;
	Reputation_RelationType[ 7 ] = Reputation_Value_Menpai7_Relation;
	Reputation_RelationType[ 8 ] = Reputation_Value_Menpai8_Relation;
	Reputation_RelationType[ 9 ] = Reputation_Value_Menpai9_Relation;
	Reputation_RelationType[ 10 ] = Reputation_Value_Menpai10_Relation;

	-- ��������Ĭ�����λ��
	g_Reputation_Frame_UnifiedXPosition	= Reputation_Frame : GetProperty("UnifiedXPosition");
	g_Reputation_Frame_UnifiedYPosition	= Reputation_Frame : GetProperty("UnifiedYPosition");

end

-- OnEvent

function Reputation_OnEvent(event)
	if( event =="OPEN_WINDOW" ) then
		AxTrace( 0,0, "OPEN_WINDOW   "..arg0 )
		if( arg0 == "Reputation" ) then
			AxTrace( 0,0, "Reputation_Update   " );
			Reputation_UpdateData();
			this:Show();
		end
	end

	-- ��Ϸ���ڳߴ緢���˱仯
	if (event == "ADJEST_UI_POS" ) then
		-- ���±�������λ��
		Reputation_Frame_On_ResetPos()

	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- ���±�������λ��	
		Reputation_Frame_On_ResetPos()
	end
end

function Reputation_UpdateData()
	AxTrace( 0,0, "Reputation_Update   " )
	local i = 1;
	for i = 1, 10 do
		Reputation_Back[ i ]:Hide();
	end
	if( Reputation_Page == 0 ) then
		for i = 1, 9 do
			Reputation_Update( i, i );
		end
		Reputation_Update( 10, 32 );	--Ľ����Ҫ���⴦������IDΪ32
	elseif( Reputation_Page == 1 ) then
		Reputation_Update( 1, 10 );
		Reputation_Update( 2, 13 );
		Reputation_Update( 3, 15 );
		Reputation_Update( 4, 16 );
		Reputation_Update( 5, 17 );
	elseif( Reputation_Page == 2 ) then
		Reputation_Update( 1, 19 );
		Reputation_Update( 2, 20 );
		Reputation_Update( 3, 26 );
	end
end

function Reputation_Update( nIndex, nTragetID )
	local nReputation = Player:GetReputation( nTragetID );
	local nCurrentNumber;		--��һ���ĵ�ǰֵ
	local nCurrentMaxNumber;--��һ�������ֵ
	local strTypeMax;
	local nType = 1;
	if( nReputation < -550000 ) then
		nCurrentNumber = -550000 - nReputation ;
		nCurrentMaxNumber = 450000;
		strTypeMax = "Th�ng h�n";
	elseif( nReputation < -320000 ) then
		nCurrentNumber = -320000 - nReputation ;
		nCurrentMaxNumber = 230000;
		strTypeMax = "еc �c";
	elseif( nReputation < -160000 ) then
		nCurrentNumber = -160000 - nReputation ;
		nCurrentMaxNumber = 160000;
		strTypeMax = "Яi l�p";
	elseif( nReputation < -60000 ) then
		nCurrentNumber = -60000 - nReputation ;
		nCurrentMaxNumber = 100000;
		strTypeMax = "иch �";
		nType = 2;
	elseif( nReputation < 0 ) then
		nCurrentNumber = -nReputation;
		nCurrentMaxNumber = 60000;
		strTypeMax = "Ph�n c�m";
		nType = 2;
	elseif( nReputation < 60000 ) then
		nCurrentNumber = nReputation;
		nCurrentMaxNumber = 60000;
		strTypeMax = "Coi th߶ng";
		nType = 2;
	elseif( nReputation < 160000 ) then
		nCurrentNumber = nReputation - 60000;
		nCurrentMaxNumber = 100000;
		strTypeMax = "� t�t";
		nType = 2;
	elseif( nReputation < 320000 ) then
		nCurrentNumber = nReputation - 160000;
		nCurrentMaxNumber = 160000;
		strTypeMax = "H�u thi�n";
		nType = 2;
	elseif( nReputation < 550000 ) then
		nCurrentNumber = nReputation - 320000;
		nCurrentMaxNumber = 230000;
		strTypeMax = "T�n k�nh";
		nType = 3;
	elseif( nReputation < 1000000 ) then
		nCurrentNumber = nReputation - 550000;
		nCurrentMaxNumber = 450000;
		strTypeMax = "T�n nhi�m";
		nType = 3;
	else
		nCurrentNumber = 0;
		nCurrentMaxNumber = 0;
		strTypeMax = "K�nh y�u";
		nType = 3;
	end
	Reputation_Back[ nIndex ]:Show();
	AxTrace( 0,8,"nReputation ="..tonumber(nReputation).." nType="..tonumber( nType ) );
	Reputation_Progress1[ nIndex ]:Hide();
	Reputation_Progress2[ nIndex ]:Hide();
	Reputation_Progress3[ nIndex ]:Hide();
	Reputation_CurLevel[ nIndex ]:SetText( "Danh v�ng: ".. strTypeMax );
	Reputation_Text[ nIndex ]:SetText( tostring( nCurrentNumber ).."/"..tostring( nCurrentMaxNumber ) );
	Reputation_Name[ nIndex ]:SetText( Reputation_TextName[ nTragetID ] );

	if( nType == 1 ) then
		Reputation_RelationType[ nIndex ]:SetProperty( "SetCurrentImage", "Enemy" );
		Reputation_Progress1[ nIndex ]:SetProgress( nCurrentNumber, nCurrentMaxNumber );
		Reputation_Progress1[ nIndex ]:Show();
	elseif( nType == 2 ) then
		Reputation_RelationType[ nIndex ]:SetProperty( "SetCurrentImage", "Normal" );
		Reputation_Progress2[ nIndex ]:SetProgress( nCurrentNumber, nCurrentMaxNumber );
		Reputation_Progress2[ nIndex ]:Show();
	elseif( nType == 3 ) then
		Reputation_RelationType[ nIndex ]:SetProperty( "SetCurrentImage", "Friend" );
		Reputation_Progress3[ nIndex ]:SetProgress( nCurrentNumber, nCurrentMaxNumber );
		Reputation_Progress3[ nIndex ]:Show();
	end

end

function Reputation_OnPageClick( nIndex )
	Reputation_Page = nIndex;
	Reputation_UpdateData();
end

--================================================
-- �ָ������Ĭ�����λ��
--================================================
function Reputation_Frame_On_ResetPos()

	Reputation_Frame : SetProperty("UnifiedXPosition", g_Reputation_Frame_UnifiedXPosition);
	Reputation_Frame : SetProperty("UnifiedYPosition", g_Reputation_Frame_UnifiedYPosition);

end
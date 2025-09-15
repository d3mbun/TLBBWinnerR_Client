local g_PreAlpha = "0.8";
local g_Track_PreAlpha = "1.0";
--===============================================
-- PreLoad()
--===============================================
function GameSetup_PreLoad()

	this:RegisterEvent("TOGLE_GAMESETUP");

	this:RegisterEvent("TOGLE_SYSTEMFRAME");
	this:RegisterEvent("TOGLE_SOUNDSETUP");
	this:RegisterEvent("TOGLE_VIEWSETUP");

end

--===============================================
-- OnLoad()
--===============================================
function GameSetup_OnLoad()
	GameSetup_ChatBkg_Slider:SetProperty( "DocumentSize","1" );
	GameSetup_ChatBkg_Slider:SetProperty( "PageSize","0.1" );
	GameSetup_ChatBkg_Slider:SetProperty( "StepSize","0.1" );
	GameSetup_TrackBkg_Slider:SetProperty( "DocumentSize","1" );
	GameSetup_TrackBkg_Slider:SetProperty( "PageSize","0.0" );
	GameSetup_TrackBkg_Slider:SetProperty( "StepSize","0.1" );
end

--===============================================
-- OnEvent()
--===============================================
function GameSetup_OnEvent(event)
	
	if ( event == "TOGLE_GAMESETUP" ) then
		this:Show();
		local old = {SystemSetup:GameGetData()};
		g_PreAlpha = tostring(old[10]);
		g_Track_PreAlpha = tostring(old[17]);
		GameSetup_UpdateFrame();

	elseif(event == "TOGLE_VIEWSETUP" and this:IsVisible()) then
		GameSetup_Cancel_Clicked();

	elseif(event == "TOGLE_SYSTEMFRAME" and this:IsVisible()) then
		GameSetup_Cancel_Clicked();

	elseif(event == "TOGLE_SOUNDSETUP" and this:IsVisible()) then
		GameSetup_Cancel_Clicked();
	end

end


--===============================================
-- UpdateFrame()
--===============================================
function GameSetup_UpdateFrame()

	local n1,n2,n3,n4,n5,n6,n7,n8,n9,f10,n11,n12,n13,n14,n15,n16,f17,n18 = SystemSetup:GameGetData();
	
	GameSetup_Item1						:SetCheck(n1);					-- �ܾ������ż�
	GameSetup_Item2						:SetCheck(n2);					-- �ܾ����Һ���
	GameSetup_Item3						:SetCheck(n3);					-- �ܾ�Ĭ�����ż�
	GameSetup_Item4						:SetCheck(n4);					-- �ܾ�����
	GameSetup_Item5						:SetCheck(n5);					-- �ܾ���������
	GameSetup_Item6						:SetCheck(n6);					-- �رյ�ǰ���ݿ�
	GameSetup_Item7						:SetCheck(n7);					-- �ܾ��鿴��ż
	GameSetup_Item8						:SetCheck(n8);					-- ��ɫ��ʾñ��
	GameSetup_Item9						:SetCheck(n9);					-- ������ģʽ
	GameSetup_ChatBkg_Slider	:SetPosition(f10);			-- ���챳��͸����
	GameSetup_Item11					:SetCheck(n11);					-- �رտ������ʾ
	GameSetup_Lock						:SetCheck(n12);					-- ���������
	GameSetup_Scene						:SetCheck(n13);					-- �����л�����
																										-- �ر���ҵ�ʱװ��ʾ
	GameSetup_ChatItem				:SetCheck(n15);					-- ��ݼ��鿴����
	GameSetup_TeamFollow			:SetCheck(n16);						-- �Զ�������Ӹ���
	GameSetup_TrackBkg_Slider	:SetPosition(f17);			-- ����׷�ٱ���͸����
	GameSetup_Item12					:SetCheck(n18);					-- �ܾ����춯��

end

--===============================================
-- GameSetup_Accept
-- ȷ��
--===============================================
function GameSetup_Accept_Clicked()

	local n1,n2,n3,n4,n5,n6,n7,n8,n9,f10,n11,n12,n13,n14,n15,n16,f17,n18 = SystemSetup:GameGetData();

	n1 = GameSetup_Item1:GetCheck();									-- �ܾ������ż�
	n2 = GameSetup_Item2:GetCheck();                  -- �ܾ����Һ���       
	n3 = GameSetup_Item3:GetCheck();                  -- �ܾ�Ĭ�����ż�     
	n4 = GameSetup_Item4:GetCheck();                  -- �ܾ�����           
	n5 = GameSetup_Item5:GetCheck();                  -- �ܾ���������       
	n6 = GameSetup_Item6:GetCheck();                  -- �رյ�ǰ���ݿ�     
	n7 = GameSetup_Item7:GetCheck();                  -- �ܾ��鿴��ż       
	n8 = GameSetup_Item8:GetCheck();                  -- ��ɫ��ʾñ��       
	n9 = GameSetup_Item9:GetCheck();                  -- ������ģʽ
	f10 = GameSetup_ChatBkg_Slider:GetPosition();     -- ���챳��͸����
	n11 = GameSetup_Item11:GetCheck();                -- �رտ������ʾ  
	n12 = GameSetup_Lock:GetCheck();                  -- ���������         
	n13 = GameSetup_Scene:GetCheck();                 -- �����л�����       
	n15 = GameSetup_ChatItem:GetCheck();              -- ��ݼ��鿴����  
	n16 = GameSetup_TeamFollow:GetCheck();						-- �Զ�������Ӹ���	   
	f17 = GameSetup_TrackBkg_Slider:GetPosition();		-- ����׷�ٱ���͸����
	n18 = GameSetup_Item12:GetCheck();					-- �ܾ����춯��
	
	SystemSetup : SaveGameSetup ( n1,n2,n3,n4,n5,n6,n7,n8,n9,tonumber(f10),n11,n12,n13,n14,n15,n16,f17,n18 );
	
	g_PreAlpha = f10;
	g_Track_PreAlpha = f17;

	this:Hide();
end

--===============================================
-- GameSetup_Cancel
-- ȡ��
--===============================================
function GameSetup_Cancel_Clicked()

	GameSetup_ChatBkg_Slider:SetPosition(g_PreAlpha);
	Talk:HandleMainBarAction("chatbkg",g_PreAlpha);
	DataPool:HandleGameSetupAction(g_Track_PreAlpha);
	this:Hide();

end

--===============================================
-- GameSetup_DefaultSetting
-- �ָ�Ĭ��
--===============================================
function GameSetup_Default_Clicked()

	GameSetup_Item1						:SetCheck(0);							-- �ܾ������ż�
	GameSetup_Item2						:SetCheck(0);             -- �ܾ����Һ���
	GameSetup_Item3						:SetCheck(1);             -- �ܾ�Ĭ�����ż�
	GameSetup_Item4						:SetCheck(0);             -- �ܾ�����
	GameSetup_Item5						:SetCheck(0);             -- �ܾ���������
	GameSetup_Item6						:SetCheck(0);             -- �رյ�ǰ���ݿ�
	GameSetup_Item7						:SetCheck(0);             -- �ܾ��鿴��ż
	GameSetup_Item8						:SetCheck(0);             -- ��ɫ��ʾñ��
	GameSetup_Item9						:SetCheck(0);             -- ������ģʽ
	GameSetup_ChatBkg_Slider	:SetPosition(1);       		-- ���챳��͸����
	GameSetup_Item11					:SetCheck(0);							-- �رտ������ʾ
	GameSetup_Lock						:SetCheck(0);             -- ���������
	GameSetup_Scene						:SetCheck(0);             -- �����л�����
	GameSetup_ChatItem				:SetCheck(0);             -- ��ݼ��鿴����
	GameSetup_TeamFollow			:SetCheck(0);							-- �Զ�������Ӹ���
	GameSetup_TrackBkg_Slider	:SetPosition(1);					-- ����׷�ٱ���͸����
	GameSetup_Item12					:SetCheck(0);							-- �ܾ����춯��
	
end

--===============================================
-- GameSetup_ChatBkg_Slider
-- �������챳��͸����
--===============================================
function GameSetup_ChatBkg_Change()
	local pos = GameSetup_ChatBkg_Slider:GetPosition();
	Talk:HandleMainBarAction("chatbkg",pos);
end

function GameSetup_TrackBkg_Change()
end

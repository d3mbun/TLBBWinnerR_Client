local g_petNum = -1;

-- �����Ĭ�����λ��
local g_PetAgname_Frame_UnifiedXPosition;
local g_PetAgname_Frame_UnifiedYPosition;

function PetAgname_PreLoad()
	this:RegisterEvent("OPEN_PET_AGNAME");
	this:RegisterEvent("CLOSE_PET_AGNAME");
	this:RegisterEvent("PET_CHANGE");

	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")

	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function PetAgname_OnLoad()
	-- ��������Ĭ�����λ��
	g_PetAgname_Frame_UnifiedXPosition	= PetAgname_Frame : GetProperty("UnifiedXPosition");
	g_PetAgname_Frame_UnifiedYPosition	= PetAgname_Frame : GetProperty("UnifiedYPosition");
end

-- OnEvent
function PetAgname_OnEvent(event)
	if ( event == "OPEN_PET_AGNAME" ) then
		g_petNum = tonumber(arg0);
		if(g_petNum<0)then
			return
		end
		this:TogleShow();
		PetAgname_UpdateFrame();
	end
	
	if ( event == "CLOSE_PET_AGNAME" ) then
		this:Hide();
	end

	if ( event == "PET_CHANGE" and this:IsVisible()) then
		if(g_petNum ~= tonumber(arg0)) then
			g_petNum = tonumber(arg0)
			if(g_petNum<0)then
				this:Hide();
				return
			end
			PetAgname_UpdateFrame();
		end
	end

	-- ��Ϸ���ڳߴ緢���˱仯
	if (event == "ADJEST_UI_POS" ) then
		-- ���±�������λ��
		PetAgname_Frame_On_ResetPos()

	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- ���±�������λ��	
		PetAgname_Frame_On_ResetPos()
	end

end

function PetAgname_UpdateFrame()
	--���
	PetAgname_Listbox:ClearListBox();

	--�������гƺ���
	local nAgnameNum = Pet:GetTitleNum(g_petNum);
	
	local i;
	for i=1, nAgnameNum do
		local szAgnameName = Pet:EnumTitleByIdx(g_petNum, i-1,"name");
		PetAgname_Listbox:AddItem(szAgnameName, i);	
	end
	
	--��ǰ��ʾ�ƺ�
	PetAgname_Currently:SetText( "" .. Pet:GetCurrentTitle(g_petNum,"name") );
	PetAgname_Explain:SetText( "".. Pet:GetCurrentTitle(g_petNum,"desc"));
end


function PetAgnameListBox_Selected()
	local nSelIndex = PetAgname_Listbox:GetFirstSelectItem();
	local nAgnameNum = Pet:GetTitleNum(g_petNum);
	
	if(nSelIndex-1 < 0 or nSelIndex-1 >= nAgnameNum) then 
		return;
	end
	
	--���õ�ǰ�ƺŵĽ���
	PetAgname_Explain:SetText( Pet:EnumTitleByIdx(g_petNum,nSelIndex-1,"desc"));

end

function PetAgname_ChangeBtn_Clicked()
	local nSelIndex = PetAgname_Listbox:GetFirstSelectItem();
	local nAgnameNum = Pet:GetTitleNum(g_petNum);
	
	if(nSelIndex-1 < 0 or nSelIndex-1 >= nAgnameNum) then 
		return;
	end

	Pet:PetAskChangeCurrentTitle(g_petNum,nSelIndex-1);
	this:Hide();
end

function PetAgname_HideTitle_Clicked()

	PetAgname_Currently:SetText( "");
	Pet:SetNullCurTitle(g_petNum);
end

--================================================
-- �ָ������Ĭ�����λ��
--================================================
function PetAgname_Frame_On_ResetPos()

	PetAgname_Frame : SetProperty("UnifiedXPosition", g_PetAgname_Frame_UnifiedXPosition);
	PetAgname_Frame : SetProperty("UnifiedYPosition", g_PetAgname_Frame_UnifiedYPosition);

end
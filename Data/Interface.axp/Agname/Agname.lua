function Agname_PreLoad()
	this:RegisterEvent("OPEN_AGNAME");
	this:RegisterEvent("CLOSE_AGNAME");
end

function Agname_OnLoad()
end

-- OnEvent
function Agname_OnEvent(event)
	if ( event == "OPEN_AGNAME" ) then
		this:TogleShow();
		Agname_UpdateFrame();
	end
	
	if ( event == "CLOSE_AGNAME" ) then
		this:Hide();
	end
end

function Agname_UpdateFrame()
	--���
	Agname_Listbox:ClearListBox();

	--�������гƺ���
	local nAgnameNum = Player:GetAgnameNum();
	
	local i;
	for i=1, nAgnameNum do
		local szAgnameName = Player:EnumAgname(i-1, "name");
		
		Agname_Listbox:AddItem(szAgnameName, i);	
	end

	--��ǰ��ʾ�ƺ�
	Agname_Currently:SetText( "" .. Player:GetCurrentAgname() );
	Agname_Explain:SetText( "" );
end


function AgnameListBox_Selected()
	local nSelIndex = Agname_Listbox:GetFirstSelectItem();
	local nAgnameNum = Player:GetAgnameNum();
	
	if(nSelIndex-1 < 0 or nSelIndex-1 >= nAgnameNum) then 
		return;
	end
	
	--���õ�ǰ�ƺŵĽ���
	Agname_Explain:SetText( Player:EnumAgname(nSelIndex-1, "desc") );

end

function Agname_ChangeBtn_Clicked()
	local nSelIndex = Agname_Listbox:GetFirstSelectItem();
	local nAgnameNum = Player:GetAgnameNum();
	
	if(nSelIndex-1 < 0 or nSelIndex-1 >= nAgnameNum) then 
		return;
	end

	Player:AskChangeCurrentAgname(nSelIndex-1);
	this:Hide();
end

function Agname_HideTitle_Clicked()

	Agname_Currently:SetText( "Danh hi�u hi�n t�i");
	Player:SetNullAgname();
end
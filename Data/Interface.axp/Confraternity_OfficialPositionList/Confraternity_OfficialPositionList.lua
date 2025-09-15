-------------------------------------------------------
--"��Ա�б�"����ű�
--create by xindefeng
-------------------------------------------------------

local g_OfficialCtls = nil		--��Ա�б����ؼ��ṹ
local g_ListIdx2IDTbl = nil		--List�ؼ������к����ԱID�Ŷ�Ӧ��

local g_positionInfo = {
	"��i ph� chu�n",
	" Bang ch�ng ",
	" Tinh Anh ",
	" Th߽ng Nh�n ",
	"S� gi� H�ng Hoa ",
	"S� gi� C�ng v� ",
	"S� gi� N�i v� ",
	"Ph� Bang Ch� ",
	"Bang Ch� ",
};

local g_menpaiInfo = {
	"Thi�u L�m",
	"Minh Gi�o",
	"C�i Bang",
	"V� �ang",
	"Nga My",
	"Tinh T�c",
	"Thi�n Long",
	"Thi�n S�n",
	"Ti�u Dao",
	"Kh�ng c�",
	"M� Dung",
}

local g_Confraternity_OfficialPositionList_Frame_UnifiedPosition;

--�¼�ע��
function Confraternity_OfficialPositionList_PreLoad()
	this:RegisterEvent("GUILD_SHOW_OFFICIALLIST")
	this:RegisterEvent("GUILD_ANY_SORTDATE")
	this:RegisterEvent("GUILD_FORCE_CLOSE")
	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
end

function Confraternity_OfficialPositionList_OnLoad()
		g_Confraternity_OfficialPositionList_Frame_UnifiedPosition=Confraternity_OfficialPositionList_Frame:GetProperty("UnifiedPosition");
end

--�¼���Ӧ
function Confraternity_OfficialPositionList_OnEvent(event)
	Confraternity_OfficialPositionList_SetCtl()--������һ�¿ؼ�

	if(event == "GUILD_SHOW_OFFICIALLIST") then
		Confraternity_OfficialPositionList_Close()
		Confraternity_OfficialPositionList_Clear()
		Confraternity_OfficialPositionList_Update()
		Confraternity_OfficialPositionList_Show()
	elseif(event == "GUILD_ANY_SORTDATE") then	--��������֮ǰת��֪ͨC������һ����
		Guild:SortAnyGuildMembersByPosition()
	elseif(event == "GUILD_FORCE_CLOSE") then
		Confraternity_OfficialPositionList_Close()
	end
	
		-- ��Ϸ���ڳߴ緢���˱仯
	if (event == "ADJEST_UI_POS" ) then
		Confraternity_OfficialPositionList_Frame_On_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Confraternity_OfficialPositionList_Frame_On_ResetPos()
	end
	
end

--�����е���ʾ��Ϣ�Ŀؼ�����ṹ��,���ڲ���
function Confraternity_OfficialPositionList_SetCtl()
	g_OfficialCtls = {
										list = Confraternity_OfficialPositionList_MemberList,	--��Ա�б�
										officalname = Confraternity_OfficialPositionList_Info1_Text,--��Ա����
										info_menpai = {txt = Confraternity_OfficialPositionList_Info2_Text, msg = Confraternity_OfficialPositionList_Info2},--����
										info_level = {txt = Confraternity_OfficialPositionList_Info3_Text, msg = Confraternity_OfficialPositionList_Info3},	--�ȼ�
										info_gongxiandu = {txt = Confraternity_OfficialPositionList_Info4_Text, msg = Confraternity_OfficialPositionList_Info4},--���׶�
										info_benzhougongxiandu = {txt = Confraternity_OfficialPositionList_Info7_Text, msg = Confraternity_OfficialPositionList_Info7},--���ܹ��׶�
										info_rubangdate =	{txt = Confraternity_OfficialPositionList_Info5_Text, msg = Confraternity_OfficialPositionList_Info5},--���ʱ��
										info_lixiandate =	{txt = Confraternity_OfficialPositionList_Info6_Text, msg = Confraternity_OfficialPositionList_Info6},--����ʱ��
										desc = Confraternity_OfficialPositionList_Tenet,			--�����ּ
										edit = Confraternity_OfficialPositionList_EditTenet		--�����ּ������
								 	 }
end

--��ս���
function Confraternity_OfficialPositionList_Clear()
	--��չ�Ա�б�
	g_OfficialCtls.list:ClearListBox()

	--��չ�Ա����
	g_OfficialCtls.officalname:SetText("")

	--�������info�ؼ�
	g_OfficialCtls.info_menpai.txt:SetText("")
	g_OfficialCtls.info_level.txt:SetText("")
	g_OfficialCtls.info_gongxiandu.txt:SetText("")
	g_OfficialCtls.info_benzhougongxiandu.txt:SetText("")
	g_OfficialCtls.info_rubangdate.txt:SetText("")
	g_OfficialCtls.info_lixiandate.txt:SetText("")

	g_OfficialCtls.info_menpai.msg:SetText("")
	g_OfficialCtls.info_level.msg:SetText("")
	g_OfficialCtls.info_gongxiandu.msg:SetText("")
	g_OfficialCtls.info_benzhougongxiandu.msg:SetText("")
	g_OfficialCtls.info_rubangdate.msg:SetText("")
	g_OfficialCtls.info_lixiandate.msg:SetText("")

	--��հ����ּ
	g_OfficialCtls.desc:SetText("")
	g_OfficialCtls.desc:Show()

	g_OfficialCtls.edit:SetText("")
	g_OfficialCtls.edit:SetProperty("CaratIndex", 1024)
	g_OfficialCtls.edit:Hide()

	--�������ID��Ӧ��
	g_ListIdx2IDTbl = nil
end

--ˢ����ʾ��������
function Confraternity_OfficialPositionList_Flush(selected)
	local str = nil
	local selectedID = g_ListIdx2IDTbl[selected]

	if  selectedID == nil then
		return
	end

	--��Ա����
	str = Guild:GetAnyGuildMembersInfo(selectedID, "Name")--Ĭ��ѡ���б���ĵ�һ����
	local guid = ""
	_, guid = Guild:GetAnyGuildMembersInfo(selectedID, "GUID")--��ȡguidʮ�������ַ���
	g_OfficialCtls.officalname:SetText(str.."("..guid..")")

	--����
	str = Guild:GetAnyGuildMembersInfo(selectedID, "MenPai")
	g_OfficialCtls.info_menpai.txt:SetText("Ph�i:  ")
	g_OfficialCtls.info_menpai.msg:SetText(g_menpaiInfo[str+1])

	--�ȼ�
	str = Guild:GetAnyGuildMembersInfo(selectedID, "Level")
	g_OfficialCtls.info_level.txt:SetText("C�p: ")
	g_OfficialCtls.info_level.msg:SetText(str)

	--���׶�
	szMsg = Guild:GetAnyGuildMembersInfo(selectedID, "CurCon").."/"..Guild:GetAnyGuildMembersInfo(selectedID, "MaxCon")
	g_OfficialCtls.info_gongxiandu.txt:SetText("е c�ng hi�n: ")
	g_OfficialCtls.info_gongxiandu.msg:SetText(szMsg)

	--���ܹ��׶�
	szMsg = Guild:GetAnyGuildMembersInfo(selectedID, "ContriPerWeek")
	g_OfficialCtls.info_benzhougongxiandu.txt:SetText("C�ng hi�n tu�n n�y:")
	g_OfficialCtls.info_benzhougongxiandu.msg:SetText(szMsg)

	--���ʱ��
	szMsg = Guild:GetAnyGuildMembersInfo(selectedID, "JoinTime");
	g_OfficialCtls.info_rubangdate.txt:SetText("Ng�y v�o bang: ")
	g_OfficialCtls.info_rubangdate.msg:SetText(szMsg)

	--����ʱ��
	szMsg = Guild:GetAnyGuildMembersInfo(selectedID, "LogOutTime")
	g_OfficialCtls.info_lixiandate.txt:SetText("Ng�y r�i m�ng: ")
	g_OfficialCtls.info_lixiandate.msg:SetText(szMsg)
end

--ˢ����ʾ"��Ա�б�"List
function Confraternity_OfficialPositionList_ShowList()
	--List Ctl
	local OfficialsCount = 0			--��Ա����
	local UnSortIdx = 0						--δ����ǰ������
	local Color = nil							--��ʾ��ɫ
	local Position = nil					--ְλ(��)
	local Name = nil							--����

	local listidx = 0	--list����ʾ������
	local i = 0

	g_ListIdx2IDTbl = nil	--�����

	OfficialsCount = Guild:GetAnyGuildMembersInfo(0, "OfficialsNum")	--��ȡ��Ա����(�ײ���Ч)
	while i < OfficialsCount do
		--��ȡδ����ǰ������
		UnSortIdx = Guild:Sort2UnSortIndex(i)

		--��ȡ����
		Color = Guild:GetAnyGuildMembersInfo(UnSortIdx, "ShowColor") 	--��ȡ��ʾ��ɫ
		Position = Guild:GetAnyGuildMembersInfo(UnSortIdx, "Position")--ְλ
		Name = Guild:GetAnyGuildMembersInfo(UnSortIdx, "Name")				--��ȡ��Ա����

		--���ؼ���һ��
		g_OfficialCtls.list:AddItem(Color..g_positionInfo[Position]..Name, listidx);

		--ά����
		g_ListIdx2IDTbl[listidx] = UnSortIdx

		listidx = listidx + 1

		i = i + 1
	end

	g_OfficialCtls.list:SetItemSelectByItemID(0)	--Ĭ��ѡ���б���ĵ�һ����


end

--��ʾ����
function Confraternity_OfficialPositionList_Update()
	--title
	Confraternity_OfficialPositionList_DragTitle:SetText("#gFF0FA0Danh s�nh th�nh vi�n")

	--ˢ����ʾ"��Ա�б�"List
	Confraternity_OfficialPositionList_ShowList()

	--ˢ����ʾ��������
	Confraternity_OfficialPositionList_Selected()

	--�����ּ
	local str = Guild:GetAnyGuildMembersInfo(0, "Desc")--�ײ���Ч
	g_OfficialCtls.desc:SetText(str)
end

--�û�ѡ�����ı�,ˢ��һ��
function Confraternity_OfficialPositionList_Selected()
	local idx = g_OfficialCtls.list:GetFirstSelectItem()	--�õ�ѡ����������
	if (idx == -1) then
		return
	end

	Confraternity_OfficialPositionList_Flush(idx)--ˢ��
end

--��ʾ�Ҽ��˵�
function Confraternity_OfficialPositionList_PopMenu()
	local idx = g_OfficialCtls.list:GetFirstSelectItem()	--�õ�ѡ����������
	if( idx == -1 ) then
		return
	end

	Guild:Show_OfficialPopMenu(tonumber(g_ListIdx2IDTbl[idx])) --֪ͨC����Ҫ��ʾ�Ҽ��˵�
end

--��ʾ����
function Confraternity_OfficialPositionList_Show()
	this:Show()
end

--�رս���
function Confraternity_OfficialPositionList_Close()
	this:Hide()
end


--================================================
-- �ָ������Ĭ�����λ��
--================================================
function Confraternity_OfficialPositionList_Frame_On_ResetPos()
  Confraternity_OfficialPositionList_Frame:SetProperty("UnifiedPosition", g_Confraternity_OfficialPositionList_Frame_UnifiedPosition);
end
-- ����ƽ̨ : ������Ϣ��������Ϣ��������Ϣ�ȵ�ѡ����� cuiyinjie 2008.10.23

local g_strWndName = "ZhengyouInfoFabu";

local g_dlgctrls = {}; --�ؼ�����

-- �Ի���ѡ��
local dlgoptions = { "fabu",  "chexiao", "guanli",};

-- �Ի������
local strDlgCaptions = {"#{ZYPT_081103_056}", "#{ZYPT_081103_067}", "#{ZYPT_081103_072}"}; --{"������Ϣ", "������Ϣ", "������Ϣ",};

-- �Ի�����ʾ�ı�
local strDlgText = {
	"#{ZYPT_081103_057}", --"��ѡ����Ҫ���������ͣ�                ��ע�⣺ͬһ���͵���Ϣ��ͬһʱ����ֻ�ܷ���һ������",
	"#{ZYPT_081103_102}",--"��ѡ����Ҫ��������Ϣ���ͣ�",
	"#{ZYPT_081103_103}",--"��ѡ����Ҫ�������Ϣ���ͣ�",
};

-- ��ǰ����״̬
local g_OperationStatus = 4;     -- �μ�PlayerZhengyouPT.lua����ڲ�ѯ������ȵĶ���

-- ��ǰѡ�������
local g_curSelType = 1;

function ZhengyouInfoFabu_PreLoad()
	this:RegisterEvent("OPEN_WINDOW");
	this:RegisterEvent("CLOSE_WINDOW");
end

function ZhengyouInfoFabu_OnLoad()
   Initg_dlgctrls();
   g_dlgctrls.OptBtns[1]:SetCheck(1);
   --<Property Name="AlwaysOnTop" Value="True" />
   ZhengyouInfoFabu_Frame:SetProperty("AlwaysOnTop","True");
end

function Initg_dlgctrls()
   g_dlgctrls = {
		Caption = ZhengyouInfoFabu_DragTitle,
		DlgText = ZhengyouInfoFabuTishi,
		OptBtns = {
		                ZhengyouInfoFabu_BtnCheck_Type1,
		                ZhengyouInfoFabu_BtnCheck_Type2,
		                ZhengyouInfoFabu_BtnCheck_Type3,
		                ZhengyouInfoFabu_BtnCheck_Type4,
				  },
   };
end

function ZhengyouInfoFabu_OnEvent(event)

	if(event == "OPEN_WINDOW") then
		ZhengyouInfoFabu_OnOpen( arg0 );

	elseif(event == "CLOSE_WINDOW") then
		if( arg0 == "ZhengyouInfoFabu") then
			this:Hide();
		end	
	end

end

function ZhengyouInfoFabu_GetSelectFriendType()
  local i = 1;
  for i = 1, 4 do
    if ( 1 == g_dlgctrls.OptBtns[i]:GetCheck() ) then
      return i;
		end
  end
  return 0;
end

function ZhengyouInfoFabu_Choose_Click()
 
	-- ���;����ѯ����
	local curSel = ZhengyouInfoFabu_GetSelectFriendType();
	if ( 0 == curSel ) then
	   PushDebugMessage("#{ZYPT_081103_104}"); --("��ѡ����������");
	   return;
	end
    g_curSelType = curSel;

	-- ����������������Ҫ����������֤
	FindFriendQuery(g_OperationStatus, g_curSelType);
	
	this:Hide();
end

-- ע�⣺ ֻ�д��������ϵĲ���������ڣ�����Ĭ��ѡ�е�һ���ѭ�����ˣ�����߻ᵼ�´򿪱�Ĵ���ʱ�˴���Ҳѡ���һ�� 
function ZhengyouInfoFabu_OnOpen(strOpt)
	local i = 1;

  for i = 1, 3 do
     if( strOpt == g_strWndName .. "_" .. dlgoptions[i] ) then
     	 CloseWindow("ZhengyouSearch");
     	 CloseWindow("ZhengyouYaoqiu");
     	 CloseWindow("VotedPlayer");
        this:Show();
        g_dlgctrls.Caption:SetText(strDlgCaptions[i]);
        g_dlgctrls.DlgText:SetText(strDlgText[i]);
        g_OperationStatus = i + 3;
        
       -- Ĭ��ѡ�е�һ��
  		 for i = 1, 4 do
       	if (1 == i) then
  				g_dlgctrls.OptBtns[i]:SetCheck(1);
		else
	    	g_dlgctrls.OptBtns[i]:SetCheck(0);
		end
  		 end
  		--      
        break;
     end
  end
end


function ZhengyouInfoFabu_Close_Click()
   this:Hide();
end

function ZhengyouInfoFabu_BtnCheck_OnClicked(iType)
   local i = 1;
   for i = 1, 4 do
        if (iType == i) then
   			g_dlgctrls.OptBtns[i]:SetCheck(1);
		else
		    g_dlgctrls.OptBtns[i]:SetCheck(0);
		end
   end
end

function Evaluate_PreLoad()
    this:RegisterEvent("OPEN_EVALUATE")
end

function Evaluate_OnLoad()
end

--=========================================================
-- �¼�����
--=========================================================
function Evaluate_OnEvent(event)
    
    --Player:GetData( "LEVEL" )
    
    local strMasterName = GetMasterName()
--WorldReference_PageHeader:SetText("#{INTERFACE_XML_39}")
    Evaluate_DragTitle:SetText( "#{UI_EVALUATE_TEXT000}" )
    Evaluate_WarningText:SetText( "#{UI_EVALUATE_TEXT001}".."#G"..strMasterName.."#Y#{UI_EVALUATE_TEXT002}" )
    Evaluate_Answer1:SetText( "#{UI_EVALUATE_TEXT003}" )
    Evaluate_Answer2:SetText( "#{UI_EVALUATE_TEXT004}" )
    Evaluate_Answer3:SetText( "#{UI_EVALUATE_TEXT005}" )
    
    if 	"OPEN_EVALUATE" == event then
        this:Show()
    end
    
end

--=========================================================
-- �ر���Ӧ
--=========================================================
function Evaluate_Close()
end

--=========================================================
-- ��ʾ�����б�
--=========================================================
function Evaluate_EventListUpdate()
end

--=========================================================
-- ��ʾ������Ϣ
--=========================================================
function Evaluate_EvaluateInfoUpdate()
end

--=========================================================
--Continue����ĶԻ���
--=========================================================
function Evaluate_MissionContinueUpdate(bDone)
end

--=========================================================
--��ȡ������Ʒ�ĶԻ���
--=========================================================
function Evaluate_MissionRewardUpdate()
end

--=========================================================
-- ѡ��һ������
--=========================================================
function EvaluateOption_Clicked()
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_Evaluate(objCaredId)
end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_Evaluate(objCaredId)
end

function Evaluate_Answer1_OnClicked()
    AskLevelUp( 1 )
    this:Hide()
end
function Evaluate_Answer2_OnClicked()
    AskLevelUp( 2 )
    this:Hide()
end
function Evaluate_Answer3_OnClicked()
    AskLevelUp( 3 )
    this:Hide()
end

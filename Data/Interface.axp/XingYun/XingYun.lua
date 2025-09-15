local UI_Command_S = 1999986
local pos_ani = 0;
local AniPlaying = 0;
local WaitRecv = 0;
local count = 0;
--local prizetype_1 = 0;
--local prizetype_2 = 0;
--local prizetype_3 = 0;
local ResultPos = 
	{	
		0, 		-- ��һ����λ��
		0, 		-- �ڶ�����λ��
		0, 		-- ��������λ��
	};
	
local PrizeImageInfo = 
	{	
		"set:Choujiang image:Choujiang_14", 		-- ���飨�������
		"set:Choujiang image:Choujiang_15", 		-- ���飨С������
		"set:Choujiang image:Choujiang_12",		  -- ���ߣ����ߣ�
		"set:Choujiang image:Choujiang_16",		  -- ������һ�ſ�����
		"set:Choujiang image:Choujiang_13",		  -- ������������󽱣�
	};
--����ͼƬ�Ļ�ɫ�汾
local DisPrizeImageInfo = 
	{	
		"set:Choujiang2 image:Choujiang2_1", 		-- ���飨�������
		"set:Choujiang2 image:Choujiang2_2", 		-- ���飨С������
		"set:Choujiang2 image:Choujiang2_3",		  -- ���ߣ����ߣ�
		"set:Choujiang2 image:Choujiang2_4",		  -- ������һ�ſ�����
		"set:Choujiang2 image:Choujiang2_5",		  -- ������������󽱣�
	};

local SoundInfo = 
	{	
		497, 		-- ���飨�����������Ч
		497, 		-- ���飨С����������Ч
		497, 		-- ���ߣ����ߣ�  ����Ч
		496,   -- ������һ�ſ�������Ч
		498, 		-- �������Ч
		499,  --���ٵ���Ч
	};

local CardImageInfo = 
	{	
		"set:CommonNPCHeader12 image:CommonNPCHeader12_2",
		"set:CommonNPCHeader12 image:CommonNPCHeader12_5",
		"set:CommonNPCHeader12 image:CommonNPCHeader12_1",
		"set:CommonNPCHeader12 image:CommonNPCHeader12_3",
		"set:CommonNPCHeader12 image:CommonNPCHeader12_11",
		"set:CommonNPCHeader12 image:CommonNPCHeader12_8",
		"set:CommonNPCHeader12 image:CommonNPCHeader12_6",
		"set:CommonNPCHeader12 image:CommonNPCHeader12_4",
		"set:CommonNPCHeader12 image:CommonNPCHeader12_10",
		"set:CommonNPCHeader12 image:CommonNPCHeader12_12",
		"set:CommonNPCHeader12 image:CommonNPCHeader12_9",
		"set:CommonNPCHeader12 image:CommonNPCHeader12_13",
		"set:CommonNPCHeader12 image:CommonNPCHeader12_7",
		"set:CommonNPCHeader12 image:CommonNPCHeader12_20",
		"set:CommonNPCHeader12 image:CommonNPCHeader12_21",
		"set:CommonNPCHeader12 image:CommonNPCHeader12_22",
		"set:CommonNPCHeader12 image:CommonNPCHeader12_23",
		"set:CommonNPCHeader12 image:CommonNPCHeader12_24",
		"set:CommonNPCHeader12 image:CommonNPCHeader12_25",
		"set:CommonNPCHeader6 image:CommonNPCHeader6_8",
		};

local TBL_Ani = {}
local TBL_Head = {}

local g_PrizeArray = { 5, 1, 1, 2, 2, 2, 2, 2, 3, 3, 4, 4, 4, 4, 4,
	4, 4, 4, 4, 4}

local g_XingYun_Frame_UnifiedPosition;

function XingYun_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UPDATE_XINGYUN");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function XingYun_OnLoad()

TBL_Ani[1] = XingYun_NPC1_Ani;
TBL_Ani[2] = XingYun_NPC2_Ani;
TBL_Ani[3] = XingYun_NPC3_Ani;
TBL_Ani[4] = XingYun_NPC4_Ani;
TBL_Ani[5] = XingYun_NPC5_Ani;
TBL_Ani[6] = XingYun_NPC6_Ani;
TBL_Ani[7] = XingYun_NPC7_Ani;
TBL_Ani[8] = XingYun_NPC8_Ani;
TBL_Ani[9] = XingYun_NPC9_Ani;
TBL_Ani[10] = XingYun_NPC10_Ani;
TBL_Ani[11] = XingYun_NPC11_Ani;
TBL_Ani[12] = XingYun_NPC12_Ani;
TBL_Ani[13] = XingYun_NPC13_Ani;
TBL_Ani[14] = XingYun_NPC14_Ani;
TBL_Ani[15] = XingYun_NPC15_Ani;
TBL_Ani[16] = XingYun_NPC16_Ani;
TBL_Ani[17] = XingYun_NPC17_Ani;
TBL_Ani[18] = XingYun_NPC18_Ani;
TBL_Ani[19] = XingYun_NPC19_Ani;
TBL_Ani[20] = XingYun_NPC20_Ani;

TBL_Head[1] = XingYun_Head1;
TBL_Head[2] = XingYun_Head2;
TBL_Head[3] = XingYun_Head3;
TBL_Head[4] = XingYun_Head4;
TBL_Head[5] = XingYun_Head5;
TBL_Head[6] = XingYun_Head6;
TBL_Head[7] = XingYun_Head7;
TBL_Head[8] = XingYun_Head8;
TBL_Head[9] = XingYun_Head9;
TBL_Head[10] = XingYun_Head10;
TBL_Head[11] = XingYun_Head11;
TBL_Head[12] = XingYun_Head12;
TBL_Head[13] = XingYun_Head13;
TBL_Head[14] = XingYun_Head14;
TBL_Head[15] = XingYun_Head15;
TBL_Head[16] = XingYun_Head16;
TBL_Head[17] = XingYun_Head17;
TBL_Head[18] = XingYun_Head18;
TBL_Head[19] = XingYun_Head19;
TBL_Head[20] = XingYun_Head20;

math.randomseed(os.time());

 g_XingYun_Frame_UnifiedPosition=XingYun_Frame:GetProperty("UnifiedPosition");
 
end

local ObjCaredID = -1

function XingYun_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 19999) then

			local xx = Get_XParam_INT(0);
			ObjCaredID = DataPool : GetNPCIDByServerID(xx);
			if ObjCaredID == -1 then
					PushDebugMessage("D� li�u c�a server truy�n tr� l�i c� v�n �");
					return;
			end
			BeginCareObject_XingYun()
			XingYun_Clear()
			this:Show()
			--tip
			local tipid
			for i = 1,20 do
			  tipid = string.format( "#{INTERFACE_XML_11%d} ", i+14 )
			  TBL_Head[i]:SetToolTip(tipid);
			end
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == UI_Command_S) then
	    
--	    local index = Get_XParam_INT(0);
--	    if(index == 1) then
--	      prizetype_1 = Get_XParam_INT(1);
--	    elseif(index == 2) then
--	      prizetype_2 = Get_XParam_INT(1);
--	    elseif(index == 3) then
--	      prizetype_3 = Get_XParam_INT(1);
--	    end
      
      local pt = Get_XParam_INT(1)
        TBL_Head[pos_ani]:SetProperty("Image", PrizeImageInfo[pt]);
	      Sound:PlaySound( SoundInfo[pt], false ) --��Ӧ��������Ч
		    WaitRecv = 0;
		    
		    --���ݻ�õĽ���������������������1 9 10 ����
		    local temp = g_PrizeArray[pos_ani]
		    g_PrizeArray[pos_ani] = pt
		  
	    for i = 1,20 do
 	      if(g_PrizeArray[i] == pt and i ~= ResultPos[1]
	      and i ~= ResultPos[2] and i ~= ResultPos[3]) then
	        g_PrizeArray[i] = temp
	        break;
	      end
	    end

	elseif( event == "UPDATE_XINGYUN") then

		if arg0 == nil or arg1 == nil then
			return
		end

		XingYun_Update(tonumber(arg0),tonumber(arg1))
		
	elseif (event == "ADJEST_UI_POS" ) then
		XingYun_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		XingYun_Frame_On_ResetPos()

	end

end

--=========================================================
--���ý���
--=========================================================
function XingYun_Clear()
	 
	 for i = 1,20 do
	   TBL_Head[i]:SetProperty("Image", CardImageInfo[i]);
	   TBL_Head[i]:SetProperty("Disabled","false");
	 end
	 
	 pos_ani = 0;
   AniPlaying = 0;
   WaitRecv = 0;
   count = 0;
   
   for i = 1,3 do
	   ResultPos[i] = 0;
	 end
	 
	 RandomPrizeArray()

end

--=========================================================
--���½���
--=========================================================
function XingYun_Update( pos_ui, pos_packet )


end

--=========================================================
--�ر�
--=========================================================
function XingYun_Close()

  if(AniPlaying == 1 or WaitRecv == 1)then
		return
	end
  --�Ƿ�ѡ������ж�
  if(count < 3) then
    PushDebugMessage("C�c h� v�n ch�a r�t l� th�m n�y!");
    Clear_XSCRIPT();--����������ʾ��Ϣ
		Set_XSCRIPT_Function_Name("PlayerTip");
		Set_XSCRIPT_ScriptID(808071);
		Set_XSCRIPT_Parameter(0,1);
		Set_XSCRIPT_ParamCount(1);
	  Send_XSCRIPT();
	  return
	end
	
	PushDebugMessage("Ch�c m�ng c�c h�! H�m nay c�c h� �� r�t l� th�m \"Th� T�i V�n May\" th�nh c�ng, c�c h� c� th� t�y l�c �n g�p t�i h� � l�nh nh�n ph�n th߷ng.");
	Clear_XSCRIPT();--����������ʾ��Ϣ
		Set_XSCRIPT_Function_Name("PlayerTip");
		Set_XSCRIPT_ScriptID(808071);
		Set_XSCRIPT_Parameter(0,2);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
	this:Hide()
	StopCareObject_XingYun()
	XingYun_Clear()
end

--=========================================================
--��������
--=========================================================
function XingYun_OnHide()
	StopCareObject_XingYun()
	XingYun_Clear()
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_XingYun()
	this:CareObject(ObjCaredID, 1, "XingYun")
end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_XingYun()
	this:CareObject(ObjCaredID, 0, "XingYun")
end

--=========================================================
--���Ŷ����ҷ����û�ѡ���������
--=========================================================
function Play_Ani(pos_ui)
  if(AniPlaying == 1 or WaitRecv == 1 or count >= 3)then
		return
	end
	
	TBL_Ani[pos_ui]:Show()
  Sound:PlaySound( SoundInfo[6], false ) --������Ч
  TBL_Head[pos_ui]:SetProperty("Disabled","true");

	XingYunTimer_StopWatch1:SetProperty("Timer", "1");
	
	--���λ���
--	if(count >= 3) then
--	  return
--	end
	
	count = count + 1;
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnAugury");
		Set_XSCRIPT_ScriptID(808071);
		Set_XSCRIPT_Parameter(0,pos_ui);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
	WaitRecv = 1
	
  pos_ani = pos_ui
  
  for i = 1,3 do
     if(ResultPos[i] == 0) then
       ResultPos[i] = pos_ui;
       break;
     end	   
	end
  
	AniPlaying = 1;
end

function XingYun_TimeReach1()

	   if pos_ani > 0 then
	     TBL_Ani[pos_ani]:Hide()
	   end
     XingYunTimer_StopWatch1:SetProperty("Timer", "-1");
     AniPlaying = 0;
     
     if(count >= 3) then
       for i = 1,20 do
         TBL_Head[i]:SetProperty("Tooltip", "");
         if(i == ResultPos[1]) then
           continue
         elseif(i == ResultPos[2]) then
           continue
         elseif(i == ResultPos[3]) then
           continue
         end
	       TBL_Ani[i]:Show()
	     end 
	     AniPlaying = 1
	     XingYunTimer_StopWatch2:SetProperty("Timer", "1");    
     end
end

function XingYun_TimeReach2()

     XingYunTimer_StopWatch2:SetProperty("Timer", "-1");
     
     --����17���ƵĶ���

       for i = 1,20 do
         if(i == ResultPos[1]) then
           continue
         elseif(i == ResultPos[2]) then
           continue
         elseif(i == ResultPos[3]) then
           continue
         end
	       TBL_Ani[i]:Hide()
	       TBL_Head[i]:SetProperty("Image", DisPrizeImageInfo[g_PrizeArray[i]]);
	     end    
	     AniPlaying = 0

end
--=========================================================
--���ҽ�Ʒ����
--=========================================================
function RandomPrizeArray()
	 local odds = 0
	 local temp = 0
	 for i = 1,20 do
	   odds = math.random( 1, 20 )
	   temp = g_PrizeArray[i]
	   g_PrizeArray[i] = g_PrizeArray[odds]
	   g_PrizeArray[odds] = temp
	 end

end

function XingYun_Frame_On_ResetPos()
  XingYun_Frame:SetProperty("UnifiedPosition", g_XingYun_Frame_UnifiedPosition);
end
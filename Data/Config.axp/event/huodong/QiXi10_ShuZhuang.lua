--MisDescBegin
x808322_g_ScriptId = 808322
x808322_g_BeginDate = 20100812
x808322_g_EndDate = 20100825
x808322_g_TxtNumMissionTip = 221
x808322_g_BuffIndex =  22313
x808322_g_MinLevel = 30
x808322_g_Woman_MissionID = 1206
function x808322_OnDefaultEvent( sceneId, selfId, targetId )	--点击该任务后执行此脚本
if GetNumText() ~=  x808322_g_TxtNumMissionTip then
return	
end
local nToday = 	GetTime2Day()
if (nToday < x808322_g_BeginDate) or (nToday >  x808322_g_EndDate) then
return
end
local nLevel = GetLevel( sceneId, selfId )
if  nLevel < x808322_g_MinLevel then
return
end
if IsTeamFollow( sceneId, selfId) == 1 then
x808322_NPCMessage( sceneId, selfId,targetId, "#{FZY_100803_14}")		
return 
end
if LuaFnGetDRideFlag(sceneId, selfId) ~= 0  then
x808322_NPCMessage( sceneId, selfId,targetId, "#{FZY_100803_14}")
return
end
if ( LuaFnIsStalling( sceneId, selfId) == 1 ) then
x808322_NPCMessage( sceneId, selfId,targetId, "#{FZY_100803_14}")
return
end
local	nPlayerSex = GetSex(sceneId,selfId)
if (nPlayerSex ~= 0) then
return
end
if ( LuaFnHaveImpactOfSpecificDataIndex(sceneId, selfId, x808322_g_BuffIndex) == 1) then
x808322_NPCMessage( sceneId,selfId,targetId,"#{FZY_100803_13}")
return
end
if (IsHaveMission(sceneId, selfId, x808322_g_Woman_MissionID) ~= 1) then
x808322_NPCMessage( sceneId,selfId,targetId,"#{FZY_100803_12}")
return
end
local nMissionIndex = GetMissionIndexByID(sceneId,selfId,x808322_g_Woman_MissionID)		--得到任务的序列号
local nMisComplete = GetMissionParam(sceneId,selfId,nMissionIndex,0)
if nMisComplete == 1 then
x808322_NPCMessage( sceneId,selfId,targetId,"#{FZY_100803_11}")
return
end
if LuaFnSendSpecificImpactToUnit(sceneId, selfId, selfId, selfId, x808322_g_BuffIndex, 0) == 1 then
local strMsg = ScriptGlobal_Format("#{FZY_100803_15}", GetName(sceneId, selfId))
x808322_NPCMessage( sceneId,selfId,targetId,strMsg)
end 
end
function x808322_OnEnumerate( sceneId, selfId, targetId )
local nToday = 	GetTime2Day()
if (nToday < x808322_g_BeginDate) or (nToday >  x808322_g_EndDate) then
return
end
local	nPlayerSex = GetSex(sceneId,selfId)
if (nPlayerSex ~= 0) then
return
end
local nLevel = GetLevel( sceneId, selfId )
if  nLevel < x808322_g_MinLevel then
return  
end
if IsHaveMission(sceneId, selfId, x808322_g_Woman_MissionID) == 1 then
AddNumText(sceneId,x808322_g_ScriptId,"#{FZY_100803_2}",6,x808322_g_TxtNumMissionTip)
end                                                
end
function x808322_XingMuMessage( sceneId, selfId, strMsg)
BeginEvent(sceneId)
AddText(sceneId, strMsg)
EndEvent()
DispatchMissionTips(sceneId, selfId)
end
function x808322_NPCMessage( sceneId,selfId,targetId,strMsg)
BeginEvent(sceneId)
AddText(sceneId,strMsg)
EndEvent()
DispatchEventList(sceneId,selfId,targetId)
end

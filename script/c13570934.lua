local m=13570934
local cm=_G["c"..m]
cm.name="歪秤 伏地巨龙"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
end

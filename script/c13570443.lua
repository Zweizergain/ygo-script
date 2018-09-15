local m=13570443
local mark=1082946
local cm=_G["c"..m]
cm.name="歪秤 约定之光霞"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
cm.effectlist={}
--Activate
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local count=Duel.AnnounceNumber(tp,1,2,3)
	e:SetLabel(count)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local count=e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.turncon)
	e1:SetOperation(cm.turnop)
	e1:SetLabelObject(e)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,count)
	Duel.RegisterEffect(e1,tp)
	e:GetHandler():RegisterFlagEffect(mark,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,count)
	cm[e:GetHandler()]=e1
	table.insert(cm.effectlist,e1)
end
function cm.turncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.turnop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	ct=ct+1
	e:SetLabel(ct)
	e:GetHandler():SetTurnCounter(ct)
	e:SetDescription(aux.Stringid(m,ct))
	if ct>=e:GetLabelObject():GetLabel() then
		e:Reset()
		local i,n,v=0,0,0
		for i=1,#cm.effectlist do
			if cm.effectlist[i]==e then
				n=i
			end
			if cm.effectlist[i]:GetOwner()==e:GetOwner() then
				v=v+1
			end
		end
		table.remove(cm.effectlist,n)
		if v==1 then 
			e:GetOwner():ResetFlagEffect(mark)
		end
		if ct~=e:GetLabelObject():GetLabel() then return end
		Duel.Hint(HINT_CARD,0,m)
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
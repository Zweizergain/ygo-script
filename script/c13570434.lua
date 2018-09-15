local m=13570434
local tg={13570438,13570444}
local mark=1082946
local cm=_G["c"..m]
cm.name="歪秤战天使 梅希莎"
function cm.initial_effect(c)
	--Pendulum
	aux.EnablePendulumAttribute(c)
	--Count
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
--Count
function cm.filter(c)
	return c:GetCode()>tg[1] and c:GetCode()<tg[2] and c:GetFlagEffect(mark)~=0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0x3f,0x3f,1,nil) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,0x3f,0x3f,1,1,nil):GetFirst()
	if tc then
		local turne=tc[tc]
		if tc.effectlist and #tc.effectlist>1 then
			local te,str={},{}
			for i=1,#tc.effectlist do
				if tc.effectlist[i]:GetOwner()==tc then
					table.insert(te,tc.effectlist[i])
					table.insert(str,tc.effectlist[i]:GetDescription())
				end
			end
			if #te>1 then
				local s=Duel.SelectOption(tp,table.unpack(str))
				turne=te[s+1]
			end
		end
		local op=turne:GetOperation()
		op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
		local c=e:GetHandler()
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(300)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e1)
		end
	end
end
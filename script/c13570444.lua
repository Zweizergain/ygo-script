local m=13570444
local mark=1082946
local tg={13570438,13570444}
local cm=_G["c"..m]
cm.name="歪秤 破碎的时空"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Activate
function cm.filter1(c)
	return c:GetCode()>tg[1] and c:GetCode()<tg[2] and c:IsAbleToHand()
end
function cm.filter2(c)
	return c:GetCode()>tg[1] and c:GetCode()<tg[2] and c:GetFlagEffect(mark)~=0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local sg=Duel.GetMatchingGroup(cm.filter2,tp,0x3f,0x3f,nil)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
			local tc=sg:Select(tp,1,1,nil):GetFirst()
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
		end
	end
end
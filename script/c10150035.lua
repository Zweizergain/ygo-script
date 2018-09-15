--大日俘获
function c10150035.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10150035.eftg)
	e1:SetOperation(c10150035.efop)
	c:RegisterEffect(e1) 
end

function c10150035.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c10150035.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g1=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tc=Duel.SelectTarget(tp,c10150035.filter1,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	e:SetLabelObject(tc)
end

function c10150035.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end

function c10150035.efop(e,tp,eg,ep,ev,re,r,rp)
	   local c=e:GetHandler()
	   local tc1=e:GetLabelObject()
	   local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	   local tc2=g:GetFirst()
	  if tc1==tc2 then tc2=g:GetNext() end
	  if tc1:IsFaceup() and tc2:IsFaceup() and tc1:IsRelateToEffect(e) and tc2:IsRelateToEffect(e) then
	   if not Duel.Equip(tp,tc2,tc1,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c10150035.eqlimit)
		e1:SetLabelObject(tc1)
		tc2:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(500)
		tc2:RegisterEffect(e2)
	  end
end

function c10150035.eqlimit(e,c)
	return e:GetLabelObject()==c
end

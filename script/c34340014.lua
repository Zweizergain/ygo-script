--白色乐章-月光
function c34340014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c34340014.target)
	e1:SetOperation(c34340014.activate)
	c:RegisterEffect(e1)
end
c34340014.setname="WhiteAlbum"
function c34340014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tc=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc:IsFaceup() and tc.setname=="WhiteMagician" then e:SetLabel(100) end
end
function c34340014.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	   e1:SetValue(1)
	   e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	   tc:RegisterEffect(e1)
	   if e:GetLabel()==100 and not tc:IsImmuneToEffect(e) then
		  local e2=Effect.CreateEffect(tc)
		  e2:SetType(EFFECT_TYPE_SINGLE)
		  e2:SetCode(EFFECT_IMMUNE_EFFECT)
		  e2:SetValue(c34340014.efilter)
		  e2:SetOwnerPlayer(tp)
		  e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		  tc:RegisterEffect(e2)
		  if not tc:IsType(TYPE_EFFECT) then
			 local e3=Effect.CreateEffect(tc)
			 e3:SetType(EFFECT_TYPE_SINGLE)
			 e3:SetCode(EFFECT_ADD_TYPE)
			 e3:SetValue(TYPE_EFFECT)
			 e3:SetReset(RESET_EVENT+0x1fe0000)
			 tc:RegisterEffect(e3)
		   end
	   end
	end
end
function c34340014.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

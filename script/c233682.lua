--金鱼之舞
function c233682.initial_effect(c)
    --negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(233682,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(0x2)
	e1:SetCost(c233682.discost)
	e1:SetCondition(c233682.discon)
	e1:SetOperation(c233682.disop)
	c:RegisterEffect(e1)
end
function c233682.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),0x80)
end
function c233682.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:GetHandler():IsType(0x1) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:GetCount()==1 and tg:IsExists(Card.IsType,1,nil,0x1) 
end	
function c233682.disop(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local sel=0
	local opt=0
	if not re:GetHandler():IsDisabled() then sel=sel+1 end
	if re:GetHandler():IsAbleToGrave() then sel=sel+2 end
	if sel==0 then Duel.Damage(1-tp,1500,0x40) 
	elseif sel==1 then
	local opt=Duel.SelectOption(tp,aux.Stringid(233682,0),aux.Stringid(233682,1)) 
	if opt==0 then Duel.Damage(1-tp,1500,0x40) else 
	    Duel.NegateRelatedChain(re:GetHandler(),RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		re:GetHandler():RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		re:GetHandler():RegisterEffect(e2)
	end
    elseif sel>1 then
        local opt=Duel.SelectOption(tp,aux.Stringid(233682,0),aux.Stringid(233682,1),aux.Stringid(233682,2)) 	
	    if opt==0 then Duel.Damage(1-tp,1500,0x40) elseif opt==1 then 
		Duel.NegateRelatedChain(re:GetHandler(),RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		re:GetHandler():RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		re:GetHandler():RegisterEffect(e2)
	else
	    Duel.SendtoGrave(re:GetHandler(),0x40) 
	end	
   end
end
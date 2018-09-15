--Obedience
function c140000104.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	--e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetTarget(c140000104.target)  
	e1:SetOperation(c140000104.activate)
	c:RegisterEffect(e1)
end
function c140000104.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c140000104.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--local tc=Duel.GetFirstTarget() 
	--if tc:IsFaceup() and tc:IsRelateToEffect(e) then  
		    local e1=Effect.CreateEffect(c) 
                e1:SetDescription(aux.Stringid(140000104,0))
                e1:SetCategory(CATEGORY_POSITION)
                e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
                e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
                e1:SetCode(EVENT_ATTACK_ANNOUNCE)
                e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
                e1:SetTarget(c140000104.postg)
                e1:SetOperation(c140000104.posop)
                c:RegisterEffect(e1)
end

function c140000104.postfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()>atk
end
function c140000104.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
      return Duel.IsExistingMatchingCard(c140000104.postfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetAttack())
end
function c140000104.posop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetFirstMatchingCard(c140000104.postfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetAttack())
      local b=Duel.GetAttackTarget()
      if a==Duel.GetAttacker() and b:IsRelateToEffect(e) and b:IsDefensePos()
      then
		Duel.ChangePosition(b,0,0,0,POS_FACEUP_ATTACK,true)
	end
        --if tc and tc:IsRelateToEffect(e) then 
        	--local e2=Effect.CreateEffect(tc) 
		--e2:SetType(EFFECT_TYPE_SINGLE) 
		--e2:SetCode(EFFECT_DISABLE) 
		--e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END) 
		--tc:RegisterEffect(e2) 
		--local e3=Effect.CreateEffect(tc) 
		--e3:SetType(EFFECT_TYPE_SINGLE) 
		--e3:SetCode(EFFECT_DISABLE_EFFECT) 
		--e3:SetValue(RESET_TURN_SET) 
		--e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END) 
		--tc:RegisterEffect(e3)
end

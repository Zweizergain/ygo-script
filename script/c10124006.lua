--拟兽王 穷鼠
function c10124006.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,true) 
	--syn
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x6334),aux.NonTuner(nil),1)  
	--Remove
	local ea1=Effect.CreateEffect(c)
	ea1:SetDescription(aux.Stringid(10124006,0))
	ea1:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	ea1:SetType(EFFECT_TYPE_IGNITION)
	ea1:SetRange(LOCATION_MZONE)
	ea1:SetCountLimit(1,10124006)
	ea1:SetTarget(c10124006.rmtg)
	ea1:SetOperation(c10124006.rmop)
	c:RegisterEffect(ea1)
	--pendulum
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10124006,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCondition(c10124006.pencon)
	e5:SetTarget(c10124006.pentg)
	e5:SetOperation(c10124006.penop)
	c:RegisterEffect(e5)
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6334))
	e2:SetValue(1)
	c:RegisterEffect(e2)
end

c10124006.pendulum_level=3

function c10124006.pencon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end

function c10124006.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end

function c10124006.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

function c10124006.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD)
end
function c10124006.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10124006.thfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
	   Duel.HintSelection(g)
	   if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(c:GetAttack()*2)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	   end
	end
end
function c19920001.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c19920001.hspcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	--lv up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19920001,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c19920001.tg)
	e2:SetOperation(c19920001.op)
	c:RegisterEffect(e2)

   --control
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19920001,1))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c19920001.ctltg)
	e3:SetOperation(c19920001.ctlop)
	c:RegisterEffect(e3)

	  --disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(c19920001.distg)
	c:RegisterEffect(e4)




end



function c19920001.afilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER)
end
function c19920001.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and not Duel.IsExistingMatchingCard(c19920001.afilter,tp,LOCATION_MZONE,0,1,nil)
end


function c19920001.filter(c)
	return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_FIRE)
end
function c19920001.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c19920001.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19920001.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c19920001.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c19920001.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_FIRE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end


function c19920001.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsControlerCanBeChanged()
end
function c19920001.ctltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c19920001.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19920001.cfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c19920001.cfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c19920001.ctlop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsAttribute(ATTRIBUTE_FIRE) then
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end

function c19920001.distg(e,c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_EFFECT)
end




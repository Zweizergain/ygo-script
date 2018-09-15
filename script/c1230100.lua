
--非想天则 琪露诺
function c1230100.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1230100,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c1230100.cost2)
	e1:SetTarget(c1230100.eqtg)
	e1:SetOperation(c1230100.eqop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1230100,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,1230100)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c1230100.spcon)
	e2:SetTarget(c1230100.sptg)
	e2:SetOperation(c1230100.spop)
	c:RegisterEffect(e2)
end
function c1230100.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c1230100.cost2(e,tp,eg,ep,ev,re,r,rp,chk)    
    if chk==0 then return e:GetHandler():GetFlagEffect(12899994)==0 end
	e:GetHandler():RegisterFlagEffect(12899994,RESET_EVENT+0x1fe0000,0,0)
end
function c1230100.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1230100.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1230100.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c1230100.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c1230100.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstTarget()
	if tg:IsRelateToEffect(e) and tg:IsLocation(LOCATION_MZONE) and tg:IsFaceup() then
		if Duel.ChangePosition(tg,POS_FACEDOWN_DEFENSE)~=0 then
			local og=Duel.GetOperatedGroup()
			local tc=og:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
				tc=og:GetNext()
			end 
		end
	end
end


function c1230100.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND) 
end
function c1230100.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1230100.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
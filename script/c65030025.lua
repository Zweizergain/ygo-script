--继承的二重阴影
function c65030025.initial_effect(c)
	--SPSUMMON
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65030025,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65030025)
	e1:SetTarget(c65030025.sptg)
	e1:SetOperation(c65030025.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(65030025,1))
	e2:SetOperation(c65030025.spop2)
	c:RegisterEffect(e2)
	--Normal monster
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_ADD_TYPE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_REMOVE_TYPE)
	e4:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e4)
	--effect!
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,65030026)
	e5:SetCondition(c65030025.con)
	e5:SetTarget(c65030025.tg)
	e5:SetOperation(c65030025.op)
	c:RegisterEffect(e5)
end
c65030025.setname="DoppelShader"
function c65030025.con(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsType(TYPE_NORMAL)
end
function c65030025.tgfilter(c)
	local cd=c:GetCode()
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c65030025.tgfil2,tp,LOCATION_DECK,0,1,nil,cd)
end
function c65030025.tgfil2(c,code)
	local cd2=c:GetCode()
	return not c:IsCode(code) and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c65030025.tgfil3,tp,LOCATION_DECK,0,1,nil,code,cd2) and c:IsType(TYPE_MONSTER) and c.setname=="DoppelShader"
end
function c65030025.tgfil3(c,code,code2)
	return not c:IsCode(code) and not c:IsCode(code2) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER) and c.setname=="DoppelShader"
end
function c65030025.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65030025.tgfilter(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c65030025.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c65030025.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c65030025.thfilter(c,e,tp)
	return c.setname=="DoppelShader" and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65030025.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local code=tc:GetCode()
	if tc:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(c65030025.tgfil2,tp,LOCATION_DECK,0,1,nil,code) then
		local g=Duel.SelectMatchingCard(tp,c65030025.tgfil2,tp,LOCATION_DECK,0,1,1,nil,code)
		local gc=g:GetFirst()
		local code2=gc:GetCode()
		local g2=Duel.SelectMatchingCard(tp,c65030025.tgfil3,tp,LOCATION_DECK,0,1,1,nil,code,code2)
		local gc2=g2:GetFirst()
		g:Merge(g2)
		if (gc and gc2) and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c65030025.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(65030025,2)) then
			local sg=Duel.SelectMatchingCard(tp,c65030025.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c65030025.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function c65030025.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65030025.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c65030025.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
		--Normal monster
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(TYPE_NORMAL)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_REMOVE_TYPE)
		e2:SetValue(TYPE_EFFECT)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65030025,3))
		Duel.SpecialSummonComplete()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65030025.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c65030025.splimit(e,c)
	return not c.setname=="DoppelShader" and c:IsLocation(LOCATION_EXTRA) 
end


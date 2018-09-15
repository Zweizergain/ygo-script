--夜眸祭司 LV8
function c65000029.initial_effect(c)
	c:EnableReviveLimit()
	--rever
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65000029,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65001029)
	e1:SetTarget(c65000029.target)
	e1:SetOperation(c65000029.activate)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65000029,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65000029)
	e2:SetTarget(c65000029.rectg)
	e2:SetOperation(c65000029.recop)
	c:RegisterEffect(e2)
end
c65000029.lvupcount=1
c65000029.lvup={65000028}
c65000029.lvdncount=2
c65000029.lvdn={65000027,65000028}
function c65000029.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c65000029.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c65000029.filter(chkc,e,tp) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c65000028.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c65000028.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c65000029.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)~=0 then
			if e:GetHandler():GetFlagEffect(65000029)~=0 and not Duel.SelectYesNo(tp,aux.Stringid(65000029,1)) then
				local atk=tc:GetAttack()
				local def=tc:GetDefense()
				if atk>def then atk=def end
				Duel.SetLP(tp,Duel.GetLP(tp)-atk)
			end
		end
	end
end
function c65000029.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c65000029.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c65000029.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65000029.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c65000029.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
end
function c65000029.recop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 then
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
	end
end
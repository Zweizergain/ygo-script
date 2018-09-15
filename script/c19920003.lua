function c19920003.initial_effect(c)   
 --destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19920003,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c19920003.destg)
	e1:SetOperation(c19920003.desop)
	c:RegisterEffect(e1)

	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19920003,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetTarget(c19920003.adestg)
	e3:SetOperation(c19920003.adesop)
	c:RegisterEffect(e3)

end

function c19920003.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xffa) or c:IsSetCard(0xffb) 
end
function c19920003.spfilter(c,e,tp)
	return c:IsSetCard(0xffa) or c:IsSetCard(0xffb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19920003.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c19920003.desfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c19920003.desfilter,tp,LOCATION_MZONE,0,1,c)
		and Duel.IsExistingMatchingCard(c19920003.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c19920003.desfilter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c19920003.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c19920003.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end


function c19920003.adestg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsFaceup() and tc:IsAttribute(ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c19920003.adesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then Duel.Destroy(tc,REASON_EFFECT) end
end

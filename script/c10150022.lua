--深红爆压
function c10150022.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10150022+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c10150022.condition)
	e1:SetTarget(c10150022.target)
	e1:SetOperation(c10150022.operation)
	c:RegisterEffect(e1)  
end

function c10150022.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1045)
end
function c10150022.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10150022.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10150022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c10150022.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(c10150022.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if Duel.Damage(p,d,REASON_EFFECT)>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10150022,0)) then
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	 local tg=g:Select(tp,1,1,nil)
	 Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end

function c10150022.spfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsSetCard(0x57)
end


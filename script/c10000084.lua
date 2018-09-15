--次元融合杀
function c10000084.initial_effect(c)
	
	--特殊召唤混沌幻魔
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10000084.target)
	e1:SetOperation(c10000084.activate)
	c:RegisterEffect(e1)
	
	--效果不会被无效化
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e2)
end
-------------------------------------------------------------------------------------------------------------------------------------------
function c10000084.tffilter(c)
	local code=c:GetCode()
	return c:IsAbleToRemove()
	and (code==32491822 or code==69890967 or code==6007213)
end

function c10000084.tfilter(c,e,tp)
	return c:IsCode(43378048) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end

function c10000084.filter(c,code)
	return c:IsCode(code) and c:IsAbleToRemove()
end

function c10000084.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10000084.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,6007213)
	 and Duel.IsExistingMatchingCard(c10000084.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,32491822)
	 and Duel.IsExistingMatchingCard(c10000084.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,69890967)
	 and Duel.IsExistingMatchingCard(c10000084.tfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
end

function c10000084.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c10000084.tffilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=sg:Select(tp,1,1,nil)
	sg:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	local ft=2
	local g2=nil
	while ft>0 do
		g2=sg:Select(tp,1,1,nil)
		g1:Merge(g2)
		sg:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
		ft=ft-1
	end
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local sg=Duel.SelectMatchingCard(tp,c10000084.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		local tc=sg:GetFirst()
	end
end
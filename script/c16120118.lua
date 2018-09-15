--黑羽之宝札
function c16120118.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c16120118.cost)
	e1:SetTarget(c16120118.target)
	e1:SetOperation(c16120118.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(16120118,ACTIVITY_SPSUMMON,c16120118.chainfilter)
end
function c16120118.chainfilter(c)
	return c:IsSetCard(0x33) or c:IsCode(9012916)
end
function c16120118.filter(c)
	return c:IsSetCard(0x33) and c:IsAbleToDeck() and not c:IsPublic()
end
function c16120118.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return Duel.GetCustomActivityCount(16120118,tp,ACTIVITY_SPSUMMON)==0
		and Duel.IsExistingMatchingCard(c16120118.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c16120118.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c16120118.splimit)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	e:SetLabelObject(g:GetFirst())
end
function c16120118.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	   if e:GetLabel()~=100 then return false 
	   else return Duel.IsPlayerCanDraw(tp,2)
	   end
	end
	e:SetLabel(0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetTargetCard(e:GetLabelObject())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetLabelObject(),LOCATION_HAND,tp,1)
end
function c16120118.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) then
	   Duel.ShuffleDeck(tp)
	   local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	   Duel.Draw(p,d,REASON_EFFECT)
	end
end
function c16120118.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x33) and not c:IsCode(9012916)
end
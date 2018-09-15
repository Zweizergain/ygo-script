--黑羽之宝札
function c16120101.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCost(c16120101.cost)
	e2:SetTarget(c16120101.target)
	e2:SetOperation(c16120101.activate)
	c:RegisterEffect(e2)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c16120101.itarget)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c16120101.itarget)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c16120101.retcon)
	e5:SetTarget(c16120101.retg)
	e5:SetOperation(c16120101.retop)
	c:RegisterEffect(e5)
end
function c16120101.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(c16120101.rfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
end
function c16120101.rfilter(c)
	return (c:IsFacedown() or c:GetAttribute()~=ATTRIBUTE_DARK)
end
function c16120101.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c16120101.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c16120101.rfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c16120101.itarget(e,c)
	return c:IsSetCard(0x33) and c:IsStatus(STATUS_SUMMON_TURN+STATUS_SPSUMMON_TURN)
end
function c16120101.filter(c)
	return c:IsSetCard(0x33) and c:IsAbleToDeck() and not c:IsPublic()
end
function c16120101.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return Duel.IsExistingMatchingCard(c16120101.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c16120101.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabelObject(g:GetFirst())
end
function c16120101.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	   if e:GetLabel()~=100 then return false 
	   else return Duel.IsPlayerCanDraw(tp,1)
	   end
	end
	e:SetLabel(0)
	Duel.SetTargetCard(e:GetLabelObject())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetLabelObject(),LOCATION_HAND,tp,1)
end
function c16120101.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc,tg=e:GetLabelObject(),Group.CreateGroup()
	if tc:IsRelateToEffect(e) then
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,tc)
	if g:GetCount()>0 and ct>=2 and Duel.SelectYesNo(tp,aux.Stringid(16120101,0)) then
	   local sg=g:Select(tp,1,ct-1,nil)
	   tg:Merge(sg)
	end
	   tg:AddCard(tc)
	   local ct2=Duel.SendtoDeck(tg,nil,2,REASON_EFFECT) 
	   Duel.ShuffleDeck(tp)
	   Duel.Draw(tp,ct2,REASON_EFFECT)
	end
end
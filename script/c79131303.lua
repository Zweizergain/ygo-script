--灵噬 毁灭天灾
function c79131303.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c79131303.ffilter,6,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c79131303.splimit)
	c:RegisterEffect(e0)
	--special summon rule
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD)
	e01:SetCode(EFFECT_SPSUMMON_PROC)
	e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e01:SetRange(LOCATION_EXTRA)
	e01:SetCondition(c79131303.spcon)
	e01:SetOperation(c79131303.spop)
	c:RegisterEffect(e01)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79131303,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c79131303.cttg)
	e1:SetOperation(c79131303.ctop)
	c:RegisterEffect(e1)
	--add count in EP
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79131303,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetOperation(c79131303.adop)
	c:RegisterEffect(e2)
	--buff
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabel(1)
	e3:SetCondition(c79131303.buffcon)
	e3:SetValue(function(e,c) return e:GetHandler():GetCounter(0x1206)*200 end)
	c:RegisterEffect(e3)
	local e3_1=Effect.CreateEffect(c)
	e3_1:SetDescription(aux.Stringid(79131303,2))
	e3_1:SetCategory(CATEGORY_COUNTER+CATEGORY_TODECK)
	e3_1:SetType(EFFECT_TYPE_QUICK_O)
	e3_1:SetCode(EVENT_FREE_CHAIN)
	e3_1:SetRange(LOCATION_MZONE)
	e3_1:SetCountLimit(1)
	e3_1:SetLabel(2)
	e3_1:SetCondition(c79131303.buffcon)
	e3_1:SetTarget(c79131303.tdtg)
	e3_1:SetOperation(c79131303.tdop)
	c:RegisterEffect(e3_1)
	local e3_2=Effect.CreateEffect(c)
	e3_2:SetType(EFFECT_TYPE_SINGLE)
	e3_2:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3_2:SetRange(LOCATION_MZONE)
	e3_2:SetLabel(4)
	e3_2:SetCondition(c79131303.buffcon)
	e3_2:SetValue(function(e,te) return te:GetOwner()~=e:GetOwner() end)
	c:RegisterEffect(e3_2)
	local e6=e3_2:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)
	local e3_3=Effect.CreateEffect(c)
	e3_3:SetType(EFFECT_TYPE_SINGLE)
	e3_3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3_3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3_3:SetRange(LOCATION_MZONE)
	e3_3:SetLabel(6)
	e3_3:SetValue(function(e,te) return te:GetOwner()~=e:GetOwner() end)
	e3_3:SetCondition(c79131303.buffcon)
	c:RegisterEffect(e3_3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
end
function c79131303.ffilter(c,fc,sub,mg,sg)
	return c:IsControler(fc:GetControler()) and c:IsFusionSetCard(0x1201) 
		and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function c79131303.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c79131303.cfilter(c,fc)
	return c:IsFusionSetCard(0x1201) and c:IsAbleToDeckOrExtraAsCost() and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial(fc)
end
function c79131303.fgoal(c,tp,sg)
	return sg:GetClassCount(Card.GetFusionCode)==6 and Duel.GetLocationCountFromEx(tp,tp,sg)>0
end
function c79131303.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=c79131303.fgoal(c,tp,sg) or mg:IsExists(c79131303.fselect,1,sg,tp,mg,sg)
	local res=false
	if sg:GetCount()<6 then
		res=mg:IsExists(c79131303.fselect,1,sg,tp,mg,sg)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		res=sg:GetClassCount(Card.GetFusionCode)==6
	end
	sg:RemoveCard(c)
	return res
end
function c79131303.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c79131303.cfilter,tp,LOCATION_REMOVED,0,nil,c)
	local sg=Group.CreateGroup()
	return mg:IsExists(c79131303.fselect,1,nil,tp,mg,sg)
end
function c79131303.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c79131303.cfilter,tp,LOCATION_REMOVED,0,nil,c)
	local sg=Group.CreateGroup()
	while sg:GetCount()<6 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=mg:FilterSelect(tp,c79131303.fselect,1,1,sg,tp,mg,sg)
		sg:Merge(g)
	end
	Duel.ConfirmCards(1-tp,sg)
	c:SetMaterial(sg)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function c79131303.ctfilter(c)
	return c:GetCounter(0x1206)~=0
end
function c79131303.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetChainLimit(aux.TRUE)
end
function c79131303.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1206)
	local g=Duel.GetMatchingGroup(c79131303.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(g) do
		tc:RemoveCounter(tp,0x1206,tc:GetCounter(0x1206),REASON_EFFECT)
	end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1206,ct,REASON_EFFECT)
	if ct>0 then c:AddCounter(0x1206,ct) end
end
function c79131303.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		c:AddCounter(0x1206,1)
	end
end
function c79131303.buffcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lab=e:GetLabel()
	return c:GetCounter(0x1206)>=lab
end
function c79131303.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1206,2,REASON_EFFECT) 
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_ONFIELD)
end
function c79131303.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1206,2,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end

--幻灭神话 异律妖精
function c84530793.initial_effect(c)
	c:SetUniqueOnField(1,1,84530793)
	c:SetSPSummonOnce(84530793)
	c:EnableReviveLimit()
	--synchro summon
	aux.AddSynchroProcedure(c,c84530793.synfilter,aux.NonTuner(c84530793.matfilter),1)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c84530793.sprcon)
	e2:SetOperation(c84530793.sprop)
	c:RegisterEffect(e2)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(84530793,0))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCountLimit(2)
	e4:SetCondition(c84530793.tgcon)
	e4:SetTarget(c84530793.tgtg)
	e4:SetOperation(c84530793.tgop)
	c:RegisterEffect(e4)
end
function c84530793.synfilter(c)
	return c:IsFaceup() and c:GetLevel()==1 and c:IsSetCard(0x8351) and c:IsType(TYPE_TUNER)
end
c84530793.material_setcode=0x8351
function c84530793.matfilter(c)
	return c:IsFaceup() and (c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK))
end
function c84530793.cfilter(c,tp)
	return ((c:IsFaceup() and c:IsFusionSetCard(0x8351) and c:GetLevel()==1 and c:IsType(TYPE_TUNER)) or (c:IsFaceup() and (c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK))))
		and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost() and (c:IsControler(tp) or c:IsFaceup())
end
function c84530793.fcheck(c,sg)
	return c:IsFusionSetCard(0x8351) and c:GetLevel()==1 and c:IsType(TYPE_TUNER) and sg:FilterCount(c84530793.fcheck2,c)+1==sg:GetCount()
end
function c84530793.fcheck2(c)
	return (c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK))
end
function c84530793.fgoal(c,tp,sg)
	return sg:GetCount()>1 and Duel.GetLocationCountFromEx(tp,tp,sg)>0 and sg:IsExists(c84530793.fcheck,1,nil,sg)
end
function c84530793.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=c84530793.fgoal(c,tp,sg) or mg:IsExists(c84530793.fselect,1,sg,tp,mg,sg)
	sg:RemoveCard(c)
	return res
end
function c84530793.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c84530793.cfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	local sg=Group.CreateGroup()
	return mg:IsExists(c84530793.fselect,1,nil,tp,mg,sg)
end
function c84530793.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c84530793.cfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	local sg=Group.CreateGroup()
	while true do
		local cg=mg:Filter(c84530793.fselect,sg,tp,mg,sg)
		if cg:GetCount()==0
			or (c84530793.fgoal(c,tp,sg) and not Duel.SelectYesNo(tp,210)) then break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=cg:Select(tp,1,1,nil)
		sg:Merge(g)
	end
	Duel.SendtoGrave(sg,REASON_COST)
	--Direct Attack
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_DIRECT_ATTACK)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetValue(sg:GetCount()*250)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetReset(RESET_EVENT+0xff0000)
	e3:SetValue(sg:GetCount()-1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetReset(RESET_EVENT+0xff0000)
	e4:SetValue(sg:GetCount()>=3)
	c:RegisterEffect(e4)
end
function c84530793.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c84530793.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c84530793.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
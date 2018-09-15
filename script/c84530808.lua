--幻灭神话 妖精·星缪
function c84530808.initial_effect(c)
	c:SetUniqueOnField(1,1,84530808)
	c:EnableReviveLimit()
	--synchro summon
	aux.AddFusionProcFunRep(c,c84530808.synfilter,2,99,nil)
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
	e2:SetCondition(c84530808.sprcon)
	e2:SetOperation(c84530808.sprop)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c84530808.aclimit)
	e3:SetCondition(c84530808.actcon)
	c:RegisterEffect(e3)
end
function c84530808.synfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8351) and c:IsType(TYPE_MONSTER)
end
function c84530808.cfilter(c,tp)
	return c:IsFaceup() and c:IsFusionSetCard(0x8351) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost() and (c:IsControler(tp) or c:IsFaceup())
end
function c84530808.fcheck(c,sg)
	return c:IsFusionSetCard(0x8351) and c:IsType(TYPE_MONSTER) and sg:FilterCount(c84530808.fcheck2,c)+1==sg:GetCount()
end
function c84530808.fcheck2(c)
	return c:IsSetCard(0x8351) and c:IsType(TYPE_MONSTER)
end
function c84530808.fgoal(c,tp,sg)
	return sg:GetCount()>1 and Duel.GetLocationCountFromEx(tp,tp,sg)>0 and sg:IsExists(c84530808.fcheck,1,nil,sg)
end
function c84530808.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=c84530808.fgoal(c,tp,sg) or mg:IsExists(c84530808.fselect,1,sg,tp,mg,sg)
	sg:RemoveCard(c)
	return res
end
function c84530808.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c84530808.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	local sg=Group.CreateGroup()
	return mg:IsExists(c84530808.fselect,1,nil,tp,mg,sg)
end
function c84530808.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c84530808.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	local sg=Group.CreateGroup()
	while true do
		local cg=mg:Filter(c84530808.fselect,sg,tp,mg,sg)
		if cg:GetCount()==0
			or (c84530808.fgoal(c,tp,sg) and not Duel.SelectYesNo(tp,210)) then break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=cg:Select(tp,1,1,nil)
		sg:Merge(g)
	end
	Duel.SendtoGrave(sg,REASON_COST)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetValue(sg:GetCount()*500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetReset(RESET_EVENT+0xff0000)
	e4:SetValue(sg:GetCount()>=3)
	c:RegisterEffect(e4)
end
function c84530808.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c84530808.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
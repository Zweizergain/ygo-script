--幻灭神话 噬蝶妖精
function c84530800.initial_effect(c)
	c:SetSPSummonOnce(84530800)
	c:EnableReviveLimit()
	--synchro summon
	aux.AddSynchroProcedure(c,c84530800.synfilter,aux.NonTuner(c84530800.matfilter),1)
	--spsummon condition
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	--c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c84530800.sprcon)
	e2:SetOperation(c84530800.sprop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(84530800,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c84530800.atkcon)
	e3:SetTarget(c84530800.atktg)
	e3:SetOperation(c84530800.atkop)
	c:RegisterEffect(e3)
	--draw(battle)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCountLimit(1)
	e4:SetCondition(c84530800.drcon)
	e4:SetTarget(c84530800.drtg)
	e4:SetOperation(c84530800.drop)
	c:RegisterEffect(e4)
end
function c84530800.synfilter(c)
	return c:IsFaceup() and c:GetLevel()==1 and c:IsSetCard(0x8351) and c:IsType(TYPE_TUNER)
end
c84530800.material_setcode=0x8351
function c84530800.matfilter(c)
	return c:IsFaceup() and (c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK))
end
function c84530800.cfilter(c,tp)
	return ((c:IsFaceup() and c:IsFusionSetCard(0x8351) and c:GetLevel()==1 and c:IsType(TYPE_TUNER)) or (c:IsFaceup() and (c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK))))
		and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost() and (c:IsControler(tp) or c:IsFaceup())
end
function c84530800.fcheck(c,sg)
	return c:IsFusionSetCard(0x8351) and c:GetLevel()==1 and c:IsType(TYPE_TUNER) and sg:FilterCount(c84530800.fcheck2,c)+1==sg:GetCount()
end
function c84530800.fcheck2(c)
	return (c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK))
end
function c84530800.fgoal(c,tp,sg)
	return sg:GetCount()>1 and Duel.GetLocationCountFromEx(tp,tp,sg)>0 and sg:IsExists(c84530800.fcheck,1,nil,sg)
end
function c84530800.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=c84530800.fgoal(c,tp,sg) or mg:IsExists(c84530800.fselect,1,sg,tp,mg,sg)
	sg:RemoveCard(c)
	return res
end
function c84530800.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c84530800.cfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	local sg=Group.CreateGroup()
	return mg:IsExists(c84530800.fselect,1,nil,tp,mg,sg)
end
function c84530800.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c84530800.cfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	local sg=Group.CreateGroup()
	while true do
		local cg=mg:Filter(c84530800.fselect,sg,tp,mg,sg)
		if cg:GetCount()==0
			or (c84530800.fgoal(c,tp,sg) and not Duel.SelectYesNo(tp,210)) then break end
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
function c84530800.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c84530800.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c84530800.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local atk=c:GetAttack()
	local atk2=tc:GetAttack()
	if atk>0 and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-atk)
		tc:RegisterEffect(e1)
	--self destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c84530800.descon)
	tc:RegisterEffect(e2)
		Duel.Damage(1-tp,atk2,REASON_EFFECT)
	end
end
function c84530800.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetAttack()==0
end
function c84530800.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c84530800.drter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c84530800.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c84530807.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c84530807.drter,tp,0,LOCATION_MZONE,1,nil) end
end
function c84530800.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local tc=mg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+RESET_SELF_TURN+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+RESET_SELF_TURN+PHASE_END)
		tc:RegisterEffect(e3)
			tc=mg:GetNext()
	end
end
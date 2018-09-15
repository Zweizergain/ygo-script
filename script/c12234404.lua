--玄水祭司 瞳溟
function c12234404.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,12234403),aux.FilterBoolFunction(Card.IsCode,12234402),1)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--destroy and damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12234404,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetCondition(c12234404.ddcon)
	e2:SetTarget(c12234404.ddtg)
	e2:SetOperation(c12234404.ddop)
	c:RegisterEffect(e2) 
	--half atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c12234404.atkcon)
	e3:SetTarget(c12234404.atktg)
	e3:SetValue(c12234404.atkval)
	c:RegisterEffect(e3)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12234404,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c12234404.sumcon)
	e4:SetTarget(c12234404.sumtg)
	e4:SetOperation(c12234404.sumop)
	c:RegisterEffect(e4)
end
function c12234404.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c12234404.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12234404.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,tp,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c12234404.spfilter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:GetLevel()==7 and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function c12234404.sumop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c12234404.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)~=0 and e:GetHandler():IsLocation(LOCATION_EXTRA) and tg:GetCount()>0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local g=tg:Select(tp,1,1,nil)
	   Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c12234404.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)==0
end
function c12234404.atktg(e,c)
	return c==e:GetHandler()
end
function c12234404.atkval(e,c)
	return math.ceil(c:GetBaseAttack()/2)
end
function c12234404.ddcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle() and bc:GetBaseAttack()>0
end
function c12234404.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,bc:GetBaseAttack())
end
function c12234404.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local dam=bc:GetBaseAttack()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if c:IsFaceup() and c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() and Duel.Damage(p,dam,REASON_EFFECT)~=0 then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
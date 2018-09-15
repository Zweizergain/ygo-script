--残霞之影 月辉神 影月
function c23330033.initial_effect(c)
	--synchro Summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(SUMMON_TYPE_SYNCHRO)
	e2:SetCondition(c23330033.spcon)
	e2:SetOperation(c23330033.spop)
	c:RegisterEffect(e2)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
	--rtdrec
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23330033,1))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c23330033.con)
	e1:SetTarget(c23330033.tg)
	e1:SetOperation(c23330033.op)
	c:RegisterEffect(e1)
	--negate
	local e3=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23330033,2))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(2)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c23330033.discon)
	e3:SetTarget(c23330033.distg)
	e3:SetOperation(c23330033.disop)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e1:SetDescription(aux.Stringid(23330033,3))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c23330033.condition)
	e4:SetTarget(c23330033.target)
	e4:SetOperation(c23330033.operation)
	c:RegisterEffect(e4)
end
function c23330033.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_EXTRA)
end
function c23330033.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,800)
end
function c23330033.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)
	end
end
function c23330033.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rp~=tp
end
function c23330033.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c23330033.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c23330033.spfilter(c,fc)
	return c:IsCanBeSynchroMaterial(fc) and c:IsAbleToDeckOrExtraAsCost() and c:GetLevel()>0 and c:IsFaceup()
end
function c23330033.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c23330033.spfilter,tp,LOCATION_REMOVED,0,nil,c)
	return g:IsExists(c23330033.spfilter1,1,nil,g,c) and Duel.GetLocationCountFromEx(tp)>0
end
function c23330033.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c23330033.spfilter,tp,LOCATION_REMOVED,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=g:FilterSelect(tp,c23330033.spfilter1,1,1,nil,g,c)
	local mc=g1:GetFirst()
	local mg=g:Clone()
	local mg2=mg:Filter(Card.IsNotTuner,nil)
	local lv=13-mc:GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=mg2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,1,99,c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.SendtoDeck(g1,nil,2,REASON_COST+REASON_MATERIAL+REASON_SYNCHRO)
end
function c23330033.spfilter1(c,g,sc)
	local mg=g:Clone()
	local mg2=mg:Filter(Card.IsNotTuner,nil)
	local lv=13-c:GetLevel()
	return c:IsType(TYPE_TUNER) and c:IsSynchroType(TYPE_SYNCHRO) and c:IsSetCard(0x555) and mg2:GetCount()>0 and mg2:CheckWithSumEqual(Card.GetSynchroLevel,lv,1,99,sc)
end
function c23330033.sfilter(c)
	return c:IsSetCard(0x555) and c:IsSynchroType(TYPE_SYNCHRO)
end
function c23330033.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c23330033.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return Duel.IsExistingMatchingCard(c23330033.cfilter,tp,LOCATION_REMOVED,0,1,nil) or (g:GetCount()>0 and g:GetFirst():IsAbleToRemove()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,0,0)
end
function c23330033.op(e,tp,eg,ep,ev,re,r,rp)
   local g,ct=Duel.GetDecktopGroup(tp,1),0
   local b1=Duel.IsExistingMatchingCard(c23330033.cfilter,tp,LOCATION_REMOVED,0,1,nil)
   local b2=g:GetCount()>0 and g:GetFirst():IsAbleToRemove() 
   if not b1 and not b2 then return end
   if b1 and (not b2 or not Duel.SelectYesNo(tp,aux.Stringid(23330033,0))) then
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	  local dg=Duel.SelectMatchingCard(tp,c23330033.cfilter,tp,LOCATION_REMOVED,0,1,10,nil)
	  ct=Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
   else
	  local dt=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	  if dt>10 then dt=10 end
	  local op,dt2={},1
	  for i=1,dt do
		  op[dt2]=i
		  dt2=dt2+1
	  end
	  local xt=Duel.AnnounceNumber(tp,table.unpack(op))
	  local dg2=Duel.GetDecktopGroup(tp,xt)
	  ct=Duel.Remove(dg2,POS_FACEUP,REASON_EFFECT)
   end
   Duel.Recover(tp,ct*800,REASON_EFFECT)
end
function c23330033.cfilter(c)
	return c:IsSetCard(0x555) and c:IsFaceup() and c:IsAbleToDeck()
end
--猛毒性 淤垢
function c24762462.initial_effect(c)
	aux.AddXyzProcedure(c,nil,3,2,c24762462.ovfilter,aux.Stringid(24762462,0),2,c24762462.xyzop)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(24762462,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,24762462)
	e1:SetCondition(c24762462.e1con)
	e1:SetCost(c24762462.e1cost)
	e1:SetTarget(c24762462.e1tg)
	e1:SetOperation(c24762462.e1op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24762462,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c24762462.e2con)
	e2:SetTarget(c24762462.e2tg)
	e2:SetOperation(c24762462.e2op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(c24762462.e3reptg)
	e3:SetCondition(c24762462.e3repcon)
	e3:SetOperation(c24762462.e3repop)
	c:RegisterEffect(e3)
end
function c24762462.e1con(e)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c24762462.e1fil,tp,LOCATION_REMOVED,0,1,nil,e,tp)
end
function c24762462.e2con(e)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c24762462.e3rmfil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil)
end
function c24762462.e3repcon(e)
	local c=e:GetHandler()
	return c:GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x1390) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c24762462.e3repop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=e:GetHandler()
	Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
	local e11=Effect.CreateEffect(tc)
	e11:SetDescription(aux.Stringid(24762462,3))
	e11:SetCode(EFFECT_CHANGE_TYPE)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e11:SetReset(RESET_EVENT+0x1fc0000)
	e11:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	tc:RegisterEffect(e11)
	Duel.RaiseEvent(tc,EVENT_CUSTOM+47408488,e,0,tp,0,0)
	tc:RegisterFlagEffect(24762462,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(24762462,2))
end
function c24762462.e3reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end
end
function c24762462.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local vd=Duel.GetMatchingGroupCount(c24762462.e3rmfil,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	local gs=Duel.GetMatchingGroupCount(c24762462.e2rcfil,tp,LOCATION_MZONE,0,nil)
	e:SetLabel(gs)
	if gs==0 then
		e:SetCategory(CATEGORY_DAMAGE)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(vd*500)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,vd*500)
	else
		e:SetCategory(CATEGORY_RECOVER)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(vd*500)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,vd*500)
	end
end
function c24762462.e2op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if e:GetLabel()==0 then
	   Duel.Damage(p,d,REASON_EFFECT)
	else Duel.Recover(p,d,REASON_EFFECT) end
end
function c24762462.e3rmfil(c)
	return c:IsFaceup() and c:IsCode(24762461)
end
function c24762462.e2rcfil(c)
	return c:IsFaceup() and c:IsSetCard(0x1390) and c:IsType(TYPE_MONSTER)
end
function c24762462.e1fil(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x1390) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24762462.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c24762462.e1fil(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local g=Duel.IsExistingMatchingCard(c24762462.e1fil,tp,LOCATION_REMOVED,0,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c24762462.e1op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c24762462.e1fil,tp,LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c24762462.e1fil,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c24762462.e1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and (ft>0 and Duel.IsExistingMatchingCard(c24762462.e1cosfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsExistingMatchingCard(c24762462.mmzfil,tp,LOCATION_MZONE,0,1,nil))
	end
	if ft>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	 local g1=Duel.SelectMatchingCard(tp,c24762462.e1cosfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	 Duel.Release(g1,REASON_COST)
	  else 
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		 local g2=Duel.SelectMatchingCard(tp,c24762462.mmzfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		 Duel.Release(g2,REASON_COST)
	end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c24762462.mmzfil(c)
	return c:IsSetCard(0x1390) and c:IsFaceup() and c:IsReleasable() and c:GetSequence()<5
end
function c24762462.e1cosfil(c)
	return c:IsSetCard(0x1390) and c:IsFaceup() and c:IsReleasable()
end
function c24762462.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1390) and not c:IsCode(24762462)
end
function c24762462.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,24762462)==0 and Duel.IsExistingMatchingCard(c24762462.spfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c24762462.spfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,24762462,RESET_PHASE+PHASE_END,0,1)
end
function c24762462.spfil(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x1390)
end
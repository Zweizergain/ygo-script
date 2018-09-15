--季风的宝物
function c10140007.initial_effect(c)
	--active
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c10140007.reptg)
	e2:SetValue(c10140007.repval)
	--c:RegisterEffect(e2)
	--local g=Group.CreateGroup()
	--g:KeepAlive()
	--e2:SetLabelObject(g)  
	--indes normal ver
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c79777187.reptg2)
	e4:SetValue(c79777187.indct)
	c:RegisterEffect(e4)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10140007,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c10140007.target)
	e3:SetOperation(c10140007.operation)
	c:RegisterEffect(e3) 
end

function c10140007.tdfilter1(c,e)
	return c:IsAbleToDeck() and c:IsSetCard(0x3333) and Duel.IsExistingMatchingCard(c10140007.tdfilter2,tp,LOCATION_GRAVE,0,1,c,e,c)
end

function c10140007.tdfilter2(c,e,sc)
	return c:IsAbleToDeck() and c:IsSetCard(0x5333) and Duel.IsExistingMatchingCard(c10140007.tdfilter3,tp,LOCATION_GRAVE,0,1,c,e,sc) and c:IsCanBeEffectTarget(e)
end

function c10140007.tdfilter3(c,e,sc)
	return c:IsAbleToDeck() and c:IsSetCard(0x6333) and c:IsCanBeEffectTarget(e) and c~=sc
end

function c10140007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c67169062.tdfilter1(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingTarget(c10140007.tdfilter1,tp,LOCATION_GRAVE,0,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10140007,2))
	local g1=Duel.SelectTarget(tp,c10140007.tdfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10140007,3))
	local g2=Duel.SelectTarget(tp,c10140007.tdfilter2,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),e)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10140007,3))
	local g3=Duel.SelectTarget(tp,c10140007.tdfilter3,tp,LOCATION_GRAVE,0,1,1,g2:GetFirst(),e,g1:GetFirst())
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end

function c10140007.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and Duel.SendtoDeck(tg,REASON_EFFECT)~=0 then
	 Duel.Draw(tp,2,REASON_EFFECT)
	end
end
function c10140007.reptg2(e,c)
	return c:IsSetCard(0x6333) and c:IsFaceup() and c:GetSequence()<5
end
function c10140007.indct(e,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c10140007.repfilter(c,tp)
	return c:IsSetCard(0x6333) and c:IsControler(tp) and c:IsLocation(LOCATION_SZONE) and c:IsFaceup() and c:IsReason(REASON_EFFECT) and c:GetSequence()<5 and c:GetFlagEffect(10140007)==0 
end
function c10140007.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10140007.repfilter,1,e:GetHandler(),tp) end
	local g=eg:Filter(c10140007.repfilter,e:GetHandler(),tp)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(10140007,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10140007,1))
		tc=g:GetNext()
	end
	e:GetLabelObject():Clear()
	e:GetLabelObject():Merge(g)
	return true
end
function c10140007.repval(e,c,re,tp)
	local g=e:GetLabelObject()
	return g:IsContains(c) and tp~=e:GetHandlerPlayer()
end
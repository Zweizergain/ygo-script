--白色乐章–解放魂
function c34340029.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34340029,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,34340029)
	e2:SetTarget(c34340029.rectg)
	e2:SetOperation(c34340029.recop)
	c:RegisterEffect(e2) 
	--Destroy
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(34340029,1))
	e21:SetCategory(CATEGORY_DESTROY)
	e21:SetProperty(EFFECT_FLAG_DELAY)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e21:SetCode(EVENT_TO_GRAVE)
	e21:SetCountLimit(1,34340129)
	e21:SetCondition(c34340029.descon)
	e21:SetTarget(c34340029.destg)
	e21:SetOperation(c34340029.desop)
	c:RegisterEffect(e21)
	--draw
	local e22=Effect.CreateEffect(c)
	e22:SetDescription(aux.Stringid(34340029,2))
	e22:SetCategory(CATEGORY_DRAW)
	e22:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e22:SetRange(LOCATION_SZONE)
	e22:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e22:SetCode(EVENT_DESTROYED)
	e22:SetCountLimit(1,34340229)
	e22:SetCondition(c34340029.drcon)
	e22:SetTarget(c34340029.drtg)
	e22:SetOperation(c34340029.drop)
	c:RegisterEffect(e22)
end
c34340029.setname="WhiteAlbum"
function c34340029.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c34340029.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c34340029.cfilter,1,nil,tp)
end
function c34340029.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c34340029.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c34340029.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(0xc) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c34340029.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c34340029.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c34340029.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c34340029.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
	   Duel.Recover(tp,500,REASON_EFFECT)
	end
end
--钢·炎·击！
function c10150003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(c10150003.target)
	e1:SetOperation(c10150003.activate)
	c:RegisterEffect(e1)
	--xyzma
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10150003,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,10150003)
	e2:SetTarget(c10150003.xyztg)
	e2:SetOperation(c10150003.xyzop)
	c:RegisterEffect(e2)   
end

function c10150003.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10150003.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10150003.xyzfilter,tp,LOCATION_MZONE,0,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10150003.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end

function c10150003.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local og=tc:GetOverlayGroup()
		Duel.Overlay(tc,Group.FromCards(c))
	end
end

function c10150003.xyzfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsFaceup() and c:IsType(TYPE_XYZ)
end

function c10150003.filter(c)
	return c:IsRace(RACE_DRAGON) and c:IsFaceup()
end

function c10150003.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	local gc=Duel.GetMatchingGroupCount(c10150003.filter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return gc>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(gc*500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,gc*500)
end

function c10150003.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local gc=Duel.GetMatchingGroupCount(c10150003.filter,tp,LOCATION_MZONE,0,nil)
	Duel.Damage(p,gc*500,REASON_EFFECT)
end

--漆黑之朱姆沃尔特
function c65080034.initial_effect(c)
	 c:EnableReviveLimit()
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c65080034.sprcon)
	e0:SetOperation(c65080034.sprop)
	c:RegisterEffect(e0)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--DeckBreak
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c65080034.atkcon)
	e2:SetTarget(c65080034.atktg)
	e2:SetOperation(c65080034.atkop)
	c:RegisterEffect(e2)
end

function c65080034.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	local ct=Duel.GetAttacker()
	return ((at and at:IsFaceup() and ct==e:GetHandler() and e:GetHandler():GetAttack()<at:GetAttack()) or (at==e:GetHandler() and e:GetHandler():GetAttack()<ct:GetAttack()))
		and not e:GetHandler():IsStatus(STATUS_CHAINING)
end

function c65080034.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetAttackTarget()
	local ct=Duel.GetAttacker()
	local atk1=at:GetAttack()
	local atk2=ct:GetAttack()
	local minus=atk1-atk2
	if minus<0 then minus=0-minus end
	local num=minus/100
	local g=Duel.GetDecktopGroup(1-tp,num)
	if chk==0 then return ((at and at:IsFaceup() and ct==e:GetHandler() and e:GetHandler():GetAttack()<at:GetAttack()) or (at==e:GetHandler() and e:GetHandler():GetAttack()<ct:GetAttack()))
		and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	 Duel.SetTargetCard(e:GetHandler():GetBattleTarget())
	 Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,num,1-tp,LOCATION_DECK)
end

function c65080034.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		local atk=c:GetAttack()
		local atk2=tc:GetAttack()
		local minus=atk-atk2
		if minus<0 then minus=0-minus end
		local num=minus/100
		Duel.DisableShuffleCheck()
		local g=Duel.GetDecktopGroup(1-tp,num)
		if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end

function c65080034.sprfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c65080034.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return c:IsType(TYPE_TUNER) and g:IsExists(c65080034.sprfilter2,1,c,tp,c,sc,lv)
end
function c65080034.sprfilter2(c,tp,mc,sc,lv)
	local sg=Group.FromCards(c,mc)
	return c:GetLevel()==lv-4 and c:GetOriginalLevel()>0 and not c:IsType(TYPE_TUNER)
		and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function c65080034.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c65080034.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c65080034.sprfilter1,1,nil,tp,g,c)
end
function c65080034.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c65080034.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,c65080034.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,c65080034.sprfilter2,1,1,mc,tp,mc,c,mc:GetLevel())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
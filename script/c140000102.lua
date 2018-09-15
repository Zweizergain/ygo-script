--Guardian Formation
function c140000102.initial_effect(c)
        local e1=Effect.CreateEffect(c)
        e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c140000102.arcon)
	e1:SetTarget(c140000102.artar)
	e1:SetOperation(c140000102.arop)
	c:RegisterEffect(e1)
end
function c140000102.arcon(e,tp,eg,ep,ev,re,r,rp)
	return r~=REASON_REPLACE and Duel.GetAttackTarget():IsSetCard(0x52)
        and Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget():IsFaceup()
end
function c140000102.artar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return true end
	Duel.SetTargetCard(Duel.GetAttackTarget())
end
function c140000102.arop(e,tp,eg,ep,ev,re,r,rp)
        local tc=Duel.GetAttackTarget()
        if tc:IsRelateToEffect(e) and tc:IsFaceup() then
            Duel.NegateAttack()
            local e1=Effect.CreateEffect(tc)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
            e1:SetRange(LOCATION_MZONE)
            e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            e1:SetValue(1)
            tc:RegisterEffect(e1)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
            local tg=Duel.GetMatchingGroup(c140000102.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
            local eg=Duel.GetMatchingGroup(c140000102.efilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,tg)
            if eg:GetCount()~=0 and eg:GetCount()~=0 and Duel.SelectYesNo(tp,aux.Stringid(140000102,0)) then
                local ec=eg:Select(tp,1,1,nil):GetFirst()
                local tc=tg:Select(tp,1,1,nil):GetFirst()
                Duel.Equip(tp,ec,tc,true,true)
                Duel.EquipComplete()
            end
        end
end
function c140000102.efilter(c,g)
        return c:IsType(TYPE_EQUIP) and g:IsExists(c140000102.eqcheck,1,nil,c)
end
function c140000102.eqcheck(c,ec)
	return ec:CheckEquipTarget(c)
end
function c140000102.filter(c)
        return c:IsFaceup()
end

--光之数码兽LV9 炽天使兽
function c50218138.initial_effect(c) 
    c:EnableReviveLimit()
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c50218138.scon)
    e2:SetOperation(c50218138.sop)
    c:RegisterEffect(e2)
    --token
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(50218138,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,50218138)
    e3:SetCost(c50218138.spcost)
    e3:SetTarget(c50218138.sptg)
    e3:SetOperation(c50218138.spop)
    c:RegisterEffect(e3)
    --atk down
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(50218138,0))
    e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetCondition(c50218138.atkcon)
    e4:SetOperation(c50218138.atkop)
    c:RegisterEffect(e4)
    --remove
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(50218138,1))
    e5:SetCategory(CATEGORY_REMOVE)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetCountLimit(1,50218138)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTarget(c50218138.rmtg)
    e5:SetOperation(c50218138.rmop)
    c:RegisterEffect(e5)
end
c50218138.lvupcount=1
c50218138.lvup={50218124}
c50218138.lvdncount=3
c50218138.lvdn={50218122,50218123,50218124}
function c50218138.spfilter(c,ft,tp)
    return c:IsCode(50218124)
        and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c50218138.scon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    return ft>-1 and Duel.CheckReleaseGroup(tp,c50218138.spfilter,1,nil,ft,tp)
end
function c50218138.sop(e,tp,eg,ep,ev,re,r,rp,c)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=Duel.SelectReleaseGroup(tp,c50218138.spfilter,1,1,nil,ft,tp)
    Duel.Release(g,REASON_COST)
end
function c50218138.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c50218138.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,50218148,0,0x4011,700,300,1,RACE_FAIRY,ATTRIBUTE_LIGHT) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c50218138.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,50218148,0,0x4011,700,300,1,RACE_FAIRY,ATTRIBUTE_LIGHT) then
        local token=Duel.CreateToken(tp,50218148)
        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c50218138.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c50218138.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=tg:GetFirst()
    while tc do
        local atk=tc:GetAttack()
        local def=tc:GetDefense()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(0)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
        e2:SetValue(0)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e2)
        tc=tg:GetNext()
    end
end
function c50218138.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:IsAbleToRemove() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c50218138.rmop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
    end
end
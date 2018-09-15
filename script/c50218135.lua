--地之数码兽LV9 蔷薇兽
function c50218135.initial_effect(c) 
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
    e2:SetCondition(c50218135.scon)
    e2:SetOperation(c50218135.sop)
    c:RegisterEffect(e2)
    --token
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(50218135,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,50218135)
    e3:SetCost(c50218135.spcost)
    e3:SetTarget(c50218135.sptg)
    e3:SetOperation(c50218135.spop)
    c:RegisterEffect(e3)
   --can not be attack
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e4:SetCondition(c50218135.atcon)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    --can not be target
    local e5=e4:Clone()
    e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    c:RegisterEffect(e5)
    --control
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_CONTROL)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1,50218135)
    e6:SetTarget(c50218135.cttg)
    e6:SetOperation(c50218135.ctop)
    c:RegisterEffect(e6)
end
c50218135.lvupcount=1
c50218135.lvup={50218115}
c50218135.lvdncount=3
c50218135.lvdn={50218113,50218114,50218115}
function c50218135.spfilter(c,ft,tp)
    return c:IsCode(50218115)
        and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c50218135.scon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    return ft>-1 and Duel.CheckReleaseGroup(tp,c50218135.spfilter,1,nil,ft,tp)
end
function c50218135.sop(e,tp,eg,ep,ev,re,r,rp,c)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=Duel.SelectReleaseGroup(tp,c50218135.spfilter,1,1,nil,ft,tp)
    Duel.Release(g,REASON_COST)
end
function c50218135.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c50218135.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,50218145,0,0x4011,400,600,1,RACE_PLANT,ATTRIBUTE_EARTH) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c50218135.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,50218145,0,0x4011,400,600,1,RACE_PLANT,ATTRIBUTE_EARTH) then
        local token=Duel.CreateToken(tp,50218145)
        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c50218135.atfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xcb1)
end
function c50218135.atcon(e)
    return Duel.IsExistingMatchingCard(c50218135.atfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c50218135.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c50218135.ctop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.GetControl(tc,tp,PHASE_END,1)
    end
end
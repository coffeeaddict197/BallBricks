using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShopItemManager : MonoSingleton<ShopItemManager>
{
    [Header("Sprites")]
    public Sprite InUseImg;
    public Sprite NotInUseImg;

    [Header("GameObjects")]
    [SerializeField] ShopItemScript inUseBallScript;
    [SerializeField] PurchaseItemPanel purchaseItemPanel;

    public void ChangeInUseBall(ShopItemScript newInUseBallScript)
    {
        if (newInUseBallScript == inUseBallScript || !newInUseBallScript) return;
        inUseBallScript.InUse = false;
        inUseBallScript = newInUseBallScript;
        newInUseBallScript.InUse = true;
    }

    public void ShowPurchasePanel(ShopItemScript selectedBallScript)
    {
        purchaseItemPanel.Show(selectedBallScript);
    }
}

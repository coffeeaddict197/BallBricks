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
        UpdateBallSprite();
    }

    public void ShowPurchasePanel(ShopItemScript selectedBallScript)
    {
        purchaseItemPanel.Show(selectedBallScript);
    }

    private void UpdateBallSprite()
    {
        GameObject[] balls = GameObject.FindGameObjectsWithTag(BallLauncher.BALL_TAG);
        foreach (var ball in balls)
        {
            ball.GetComponent<SpriteRenderer>().sprite = inUseBallScript.ballScriptableObject.mainImg;
        }
    }
}

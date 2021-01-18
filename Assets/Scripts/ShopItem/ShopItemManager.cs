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

    [Header("Ball renderers")]
    public List<SpriteRenderer> ballRenderers;

    [Header("Panel")]
    [SerializeField] PurchaseErrorPanel purchaseErrorPanel;

    private void Start()
    {
        foreach (var ball in GameObject.FindGameObjectsWithTag(BallLauncher.BALL_TAG))
        {
            ballRenderers.Add(ball.GetComponent<SpriteRenderer>());
        }
    }

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

    public void ShowPurchaseErrorPanel() => purchaseErrorPanel.Show();

    public void UpdateBallSprite()
    {
        ballRenderers.Clear();
        foreach (var ball in GameObject.FindGameObjectsWithTag(BallLauncher.BALL_TAG))
        {
            ballRenderers.Add(ball.GetComponent<SpriteRenderer>());
        }

        foreach (var ballRenderer in ballRenderers)
        {
            ballRenderer.sprite = inUseBallScript.ballScriptableObject.mainImg;
        }
    }
}

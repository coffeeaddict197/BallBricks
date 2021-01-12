using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class PurchaseItemPanel : MonoBehaviour
{
    #region Variables
    [Header("Scriptable object")]
    [SerializeField] ShopItemScript ballScript;
    [SerializeField] ShopItem ball;
    [Space]

    [Header("Ball")]
    [SerializeField] GameObject ballObject;
    [SerializeField] Image ballImg;
    [Space]

    [Header("Texts")]
    [SerializeField] Text ballName;
    [SerializeField] Text ballPrice;
    [Space]

    [Header("Buttons")]
    [SerializeField] GameObject btnPurchase_Free;
    [SerializeField] GameObject btnPurchase_Nor;
    [Space]

    public static bool isPurchaseSuccess = false;
    #endregion

    #region Animation variables
    [Header("Animation variables")]
    [SerializeField] GameObject animatedObject;
    [SerializeField] float baseScale = 1f;
    [SerializeField] float animatedScale = 0.1f;
    [SerializeField] float scaleDuration = 0.5f;
    #endregion

    private void OnEnable()
    {
        a_Appear();
    }

    private void OnDisable()
    {
        btnPurchase_Free.SetActive(false);
        btnPurchase_Nor.SetActive(false);
    }

    private void LoadData(ShopItem selectedBall)
    {
        ball = selectedBall;

        ballName.text = ball.ballName;
        ballImg.sprite = ball.mainImg;

        if (ball.isFree)
        {
            btnPurchase_Free.SetActive(true);
        }
        else
        {
            ballPrice.text = ball.price.ToString();
            btnPurchase_Nor.SetActive(true);
        }

        a_Bouncing();
    }

    // to do
    public void Purchase()
    {
        if (ball.isFree)
        {
            // watch ad here
            // bool result = ...
            Debug.Log("Watch ad");
        }
        else
        {
            // check user balance here
            Debug.Log("Payment");
            isPurchaseSuccess = true;
        }

        if (isPurchaseSuccess)
        {
            ballScript.IsPurchased = true;
            ShopItemManager.Instance.ChangeInUseBall(ballScript);
            Hide();
        }
    }

    public void Show(ShopItemScript selectedBallScript)
    {
        ballScript = selectedBallScript;
        animatedObject.transform.localScale = Vector3.one * animatedScale;
        LoadData(selectedBallScript.ballScriptableObject);
        gameObject.SetActive(true);
    }

    public void Hide() => a_Disappear();

    private void DestroyMyself() => gameObject.SetActive(false);

    #region Animation function
    private void a_Bouncing()
    {
        ballObject.transform.localPosition = ShopItemScript.jumpBasePos;
        ballObject.transform.DOKill();
        ballObject.transform.DOLocalMoveY(
            ballObject.transform.localPosition.y + ShopItemScript.jumpHeight,
             ShopItemScript.jumpDuration,
            true)
            .SetEase(ShopItemScript.easeType)
            .SetLoops(-1, LoopType.Yoyo);
    }

    private void a_Appear()
    {
        animatedObject.transform.DOKill();
        animatedObject.transform.DOScale(baseScale, scaleDuration);
    }

    private void a_Disappear()
    {
        animatedObject.transform.DOKill();
        animatedObject.transform.DOScale(animatedScale, scaleDuration).OnComplete(DestroyMyself);
    }
    #endregion
}

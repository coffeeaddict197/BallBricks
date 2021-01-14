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

    public void Purchase()
    {
        StartCoroutine(CR_Purchasing());
    }

    IEnumerator CR_Purchasing()
    {
        if (ball.isFree)
        {
            yield return StartCoroutine(CR_ShowAds());
        }
        else
        {
            if (GameManager.playerData.Diamonds >= ball.price)
            {
                GameManager.playerData.Diamonds -= ball.price;
                isPurchaseSuccess = true;
            }
            else
            {
                isPurchaseSuccess = false;
            }
        }

        HandlePurchaseResult();
    }

    IEnumerator CR_ShowAds()
    {
        AdsManager.Instance.ShowRewardAd();
        while (AdsManager.Instance.IsOpening)
        {
            yield return null;
        }

        if (AdsManager.Instance.IsEarnedReward)
        {
            isPurchaseSuccess = true;
            AdsManager.Instance.ResetStatus();
        }
    }

    private void HandlePurchaseResult()
    {
        if (isPurchaseSuccess)
        {
            ballScript.IsPurchased = true;
            ShopItemManager.Instance.ChangeInUseBall(ballScript);
            Hide();
        }
        else
        {
            ShopItemManager.Instance.ShowPurchaseErrorPanel();
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

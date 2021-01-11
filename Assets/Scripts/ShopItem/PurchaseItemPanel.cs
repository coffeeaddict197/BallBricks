using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class PurchaseItemPanel : MonoBehaviour
{
    #region Variables
    [Header("Scriptable object")]
    [SerializeField] ShopItem ball;
    [Space]

    [Header("Ball")]
    [SerializeField] GameObject ballImgObject;
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

    [Header("Flag")]
    [SerializeField] bool isFree;
    #endregion

    [Header("Animation control")]
    [SerializeField] float baseScale = 1f;
    [SerializeField] float animateScale = 0.1f;
    [SerializeField] float scaleDuration = 0.5f;

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
        isFree = ball.isFree;

        ballImg.sprite = ball.mainImg;

        if (isFree)
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

    public void Show(ShopItem selectedBall)
    {
        transform.localScale = Vector3.one * 0.1f;
        LoadData(selectedBall);
        gameObject.SetActive(true);
    }

    public void Hide() => a_Disappear();

    private void DestroyMyself() => gameObject.SetActive(false);

    private void a_Bouncing()
    {
        ballImgObject.transform.localPosition = ShopItemScript.jumpBasePos;
        ballImgObject.transform.DOKill();
        ballImgObject.transform.DOLocalMoveY(
            ballImgObject.transform.localPosition.y + ShopItemScript.jumpHeight,
             ShopItemScript.jumpDuration,
            true)
            .SetEase(ShopItemScript.easeType)
            .SetLoops(-1, LoopType.Yoyo);
    }

    private void a_Appear()
    {
        transform.DOKill();
        transform.DOScale(baseScale, scaleDuration);
    }

    private void a_Disappear()
    {
        transform.DOKill();
        transform.DOScale(animateScale, scaleDuration).OnComplete(DestroyMyself);
    }
}

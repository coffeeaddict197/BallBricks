using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class ShopItemScript : MonoBehaviour
{
    #region Variables
    [Header("Scriptable Object")]
    public ShopItem ballScriptableObject;
    [Space]

    [Header("Item image")]
    [SerializeField] Image ballImg;
    [Space]

    [Header("Game Objects")]
    [SerializeField] GameObject ballImgObject;
    [Space]

    [SerializeField] GameObject btnPrice;
    [SerializeField] Text priceText;
    [Space]

    [SerializeField] GameObject btnAdFree;
    [Space]

    [SerializeField] GameObject usingStateObject;
    [SerializeField] Image usingStateImg;
    [Space]

    [SerializeField] GameObject PriceTitle;
    [Space]
    #endregion

    #region Flags
    [Header("Flags")]
    [SerializeField] bool _isFree;
    public bool IsFree
    {
        get { return _isFree; }
        set
        {
            _isFree = value;
            if (!IsPurchased)
            {
                btnPrice.SetActive(!value);
                btnAdFree.SetActive(value);
                priceText.text = ballScriptableObject.price.ToString();
            }
        }
    }

    [SerializeField] bool _inUse;
    public bool InUse
    {
        get { return _inUse; }
        set
        {
            _inUse = value;
            ToggleUseStatus();
            TogglePriceTitle();
            if (value) a_Bouncing(); else StopAnimation();
        }
    }

    public bool IsPurchased { get; set; }
    #endregion

    #region Static variables
    public static float jumpHeight = 120f;
    public static float jumpDuration = 0.45f;

    public static Ease easeType = Ease.OutCirc;

    public static Vector3 basePos = Vector3.zero;
    public static Vector3 jumpBasePos = new Vector3(0, -80, 0);
    #endregion

    private void Start()
    {
        ballImg.sprite = ballScriptableObject.mainImg;

        IsPurchased = ballScriptableObject.isPurchased;
        IsFree = ballScriptableObject.isFree;
        InUse = ballScriptableObject.inUse;
    }

    public void PurchaseButton_Clicked()
    {
        if (!IsPurchased)
        {
            ShopItemManager.Instance.ShowPurchasePanel(this);
        }
        else if (!InUse)
        {
            InUse = true;
            ShopItemManager.Instance.ChangeInUseBall(this);
        }
        else return;
    }

    private void TogglePriceTitle() => PriceTitle.SetActive(!IsPurchased);

    private void ToggleUseStatus()
    {
        if (InUse) usingStateImg.sprite = ShopItemManager.Instance.InUseImg; else usingStateImg.sprite = ShopItemManager.Instance.NotInUseImg;
        usingStateImg.SetNativeSize();
        usingStateObject.SetActive(IsPurchased);
        usingStateImg.enabled = IsPurchased;
    }

    private void StopAnimation()
    {
        ballImgObject.transform.DOKill();
        ballImgObject.transform.localPosition = basePos;
    }

    public void a_Bouncing()
    {
        ballImgObject.transform.localPosition = jumpBasePos;
        ballImgObject.transform.DOKill();
        ballImgObject.transform.DOLocalMoveY(
            ballImgObject.transform.localPosition.y + jumpHeight,
            jumpDuration,
            true)
            .SetEase(easeType)
            .SetLoops(-1, LoopType.Yoyo);
    }
}

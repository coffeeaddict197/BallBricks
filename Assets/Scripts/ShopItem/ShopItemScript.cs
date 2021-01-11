using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class ShopItemScript : MonoBehaviour
{
    #region Variables
    [Header("Scriptable Object")]
    public ShopItem itemScriptableObject;
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
    [SerializeField] bool _isPurchased;
    public bool IsPurchased
    {
        get { return _isPurchased; }
        set
        {
            _isPurchased = value;
            usingStateObject.SetActive(value);
            usingStateImg.enabled = value;

            ballImgObject.transform.localPosition = basePos;
        }
    }

    [SerializeField] bool _isFree;
    public bool IsFree
    {
        get { return _isFree; }
        set
        {
            _isFree = value;
            if (!IsPurchased)
            {
                if (value) btnAdFree.SetActive(true);
                else
                {
                    btnPrice.SetActive(true);
                    priceText.text = itemScriptableObject.price.ToString();
                }
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
            if (value) a_Bouncing(); else StopAnimation();
        }
    } 
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
        ballImg.sprite = itemScriptableObject.mainImg;

        IsPurchased = itemScriptableObject.isPurchased;
        IsFree = itemScriptableObject.isFree;
        InUse = itemScriptableObject.inUse;
    }

    public void Purchase()
    {
        if (!IsPurchased)
        {
            bool result = ShopItemManager.Instance.ShowPurchasePanel(itemScriptableObject);

            if (result)
            {
                IsPurchased = true;
                InUse = true;
                TogglePriceTitle();
            }
            else return;
        }
        else if (!InUse)
        {
            InUse = true;
        }
        else return;

        ShopItemManager.Instance.ChangeInUseBall(this);
    }

    private void TogglePriceTitle() => PriceTitle.SetActive(!PriceTitle.activeSelf);

    private void ToggleUseStatus()
    {
        if (InUse) usingStateImg.sprite = ShopItemManager.Instance.InUseImg; else usingStateImg.sprite = ShopItemManager.Instance.NotInUseImg;
        usingStateImg.SetNativeSize();
    }

    private void StopAnimation()
    {
        ballImgObject.transform.localPosition = basePos;
        ballImgObject.transform.DOKill();
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

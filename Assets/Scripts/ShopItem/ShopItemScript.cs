using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class ShopItemScript : MonoBehaviour
{
    static Vector3 basePos = Vector3.zero;

    [Header("Scriptable Object")]
    [SerializeField] ShopItem itemScriptableObject;
    [Space]

    [Header("Item image")]
    [SerializeField] Image ballImg;
    [Space]

    [Header("Animation control")]
    [SerializeField] float jumpHeight;
    [SerializeField] float jumpDuration;
    [SerializeField] Ease easeType;

    [Header("Game Objects")]
    [SerializeField] GameObject ballImgObject;
    [Space]

    [SerializeField] GameObject btnPrice;
    [SerializeField] Text priceText;
    [Space]

    [SerializeField] GameObject btnAdFree;
    [SerializeField] GameObject purchasedImg;
    [Space]

    [Header("Flags")]
    [SerializeField] bool isFree;
    [SerializeField] bool isPurchased;

    private void Start()
    {
        ballImg.sprite = itemScriptableObject.sprite;

        isFree = itemScriptableObject.isFree;
        isPurchased = itemScriptableObject.isPurchased;

        if (isPurchased)
        {
            purchasedImg.SetActive(true);
            a_Bouncing();
        }
        else
        {
            if (isFree) btnAdFree.SetActive(true);
            else
            {
                btnPrice.SetActive(true);
                priceText.text = itemScriptableObject.price.ToString();
            }

            ballImgObject.transform.localPosition = basePos;
        }
    }

    public void Purchase()
    {
        Debug.Log("Purchased");
    }

    public void a_Bouncing()
    {
        ballImgObject.transform.DOKill();
        ballImgObject.transform.DOLocalMoveY(
            ballImgObject.transform.localPosition.y + jumpHeight, 
            jumpDuration, 
            true)
            .SetEase(easeType)
            .SetLoops(-1, LoopType.Yoyo);
    }
}

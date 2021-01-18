using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using UnityEngine.UI;

public class ShopPanel : MonoBehaviour
{
    [Header("User's money")]
    [SerializeField] Text moneyText;

    [Header("Animation variables")]
    [SerializeField] Vector3 basePos;
    [SerializeField] Vector3 desPos = Vector3.zero;
    [SerializeField] float duration;

    // Start is called before the first frame update
    private void Start()
    {
        basePos = transform.localPosition;

        moneyText.text = GameManager.playerData.Diamonds.ToString();
    }

    private void OnEnable()
    {
        a_Appear();
    }

    public void Hide() => a_Disappear();

    private void a_Appear()
    {
        transform.DOKill();
        transform.DOLocalMove(desPos, duration);
    }

    private void a_Disappear()
    {
        transform.DOKill();
        transform.DOLocalMove(basePos, duration).OnComplete(() => { this.gameObject.SetActive(false); }) ;
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class ShopPanel : MonoBehaviour
{
    [Header("Animation variables")]
    [SerializeField] Vector3 basePos;
    [SerializeField] Vector3 desPos = Vector3.zero;
    [SerializeField] float duration;

    // Start is called before the first frame update
    private void Start()
    {
        basePos = transform.localPosition;
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
        transform.DOLocalMove(basePos, duration);
    }
}

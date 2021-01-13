using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class PurchaseErrorPanel : MonoBehaviour
{
    [Header("Count down variables")]
    [SerializeField] float baseTimer;
    [SerializeField] float timer;

    [SerializeField] Text countdownText;

    #region Animation variables
    [Header("Animation variables")]
    [SerializeField] Vector3 baseScale;
    [SerializeField] Vector3 animatedScale;
    [SerializeField] float scaleDuration;
    #endregion

    private void OnEnable()
    {
        a_Appear();
        timer = baseTimer;
        countdownText.text = timer.ToString();
        StartCoroutine(CR_Countdown());
    }

    IEnumerator CR_Countdown()
    {
        do
        {
            yield return new WaitForSecondsRealtime(1f);
            timer--;
            countdownText.text = timer.ToString();
        } while (timer >= 1);

        if (timer == 0) Hide();
    }

    public void Show() => gameObject.SetActive(true);

    private void Hide()
    {
        a_Disappear();
    }

    private void a_Appear()
    {
        transform.DOKill();
        transform.DOScale(baseScale, scaleDuration);
    }

    private void a_Disappear()
    {
        transform.DOKill();
        transform.DOScale(animatedScale, scaleDuration).OnComplete(DestroyMyself);
    }

    private void DestroyMyself() => gameObject.SetActive(false);
}

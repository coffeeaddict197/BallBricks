using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using DG.Tweening;
public class MainGamePanel : MonoBehaviour
{
#pragma warning disable

    [Header("Button Area")]
    [SerializeField] Button _btnGuide;
    [SerializeField] Button _btnPause;

    [Header("Text Content")]
    [SerializeField] TextMeshProUGUI _textStep;
    [SerializeField] TextMeshProUGUI _textHighScore;


    private void Awake()
    {
        AddEventOnClick();
    }
    void AddEventOnClick()
    {
        _btnPause.onClick.AddListener(PauseGame);
    }

    void PauseGame()
    {
        Time.timeScale = 0f;
        UIManager.Instance.ShowPausePanel();
    }

    void UnPause()
    {
        Time.timeScale = 1f;
    }

    public void SetStep(int step)
    {
        _textStep.text = step.ToString();
    }

    public void SetHighScore(int score)
    {
        _textHighScore.text = score.ToString();
    }

    public void Show()
    {
        transform.GetComponent<CanvasGroup>().DOFade(1, 0.5f);
        transform.GetComponent<CanvasGroup>().blocksRaycasts = true;
    }

    public void Hide()
    {
        transform.GetComponent<CanvasGroup>().DOFade(0, 0.5f);
        transform.GetComponent<CanvasGroup>().blocksRaycasts = false;
    }


}

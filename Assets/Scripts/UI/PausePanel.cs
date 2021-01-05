using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using DG.Tweening;
public class PausePanel : MonoBehaviour
{

    [SerializeField] Button _btnHome = default;
    [SerializeField] Button _btnPlayAgain = default;
    [SerializeField] Button _btnReload = default;
    [SerializeField] GameObject _btnArea = default;


    private void Awake()
    {
        AddEventClick();
    }
    private void OnEnable()
    {

        _btnArea.transform.localScale = Vector3.zero;
        _btnArea.transform.DOKill();
        _btnArea.transform.DOScale( Vector3.one , 0.5f).SetUpdate(true).SetEase(Ease.Linear);
    }


    public void ShowPanel()
    {
        this.gameObject.SetActive(true);
    }

    void AddEventClick()
    {
        _btnHome.onClick.AddListener(GoHome);
        _btnPlayAgain.onClick.AddListener(PlayAgain);
        _btnReload.onClick.AddListener(ReLoad);
    }


    void GoHome()
    {
        UIManager.Instance.ShowHomePanel();
        UIManager.Instance.HideGamePanel();
        this.gameObject.SetActive(false);
        GameManager.Instance.UnPauseGame();
    }

    void PlayAgain()
    {
        this.gameObject.SetActive(false);
        GameManager.Instance.UnPauseGame();

    }

    void ReLoad()
    {
        GameManager.Instance.ResetCurrentLevelState();
        DrawTrajectory.Instance.CantLunchOverTime(0.5F);
        this.gameObject.SetActive(false);
    }




}

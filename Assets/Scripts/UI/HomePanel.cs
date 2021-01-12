using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class HomePanel : MonoBehaviour
{
    [Header("Button")]
    [SerializeField] Button _btnPlay;
    [SerializeField] Button _btnSetting;

    [Header("Child pannel")]
    [SerializeField] GameObject optionsPanel;

    private void Awake()
    {
        AddEventClick();
    }
    private void OnEnable()
    {
        transform.DOKill();
        this.transform.localScale = Vector3.zero;
        this.transform.DOScale(1, 0.5f).SetEase(Ease.Linear);
    }
    void AddEventClick()
    {
        this._btnPlay.onClick.AddListener(Play);
        this._btnSetting.onClick.AddListener(ShowSettingPanel);
    }

    public void Show()
    {
        this.gameObject.SetActive(true);
    }

    void Play()
    {
        this.transform.DOScale(0, 0.5f).SetUpdate(true).SetEase(Ease.InOutBack).OnComplete( ()=> { 
            this.gameObject.SetActive(false);
            GameManager.Instance.InitializeAllObject();
            UIManager.Instance.ShowGamePanel();
        });
    }

    void ShowSettingPanel()
    {
        optionsPanel.gameObject.SetActive(true);
    }
}

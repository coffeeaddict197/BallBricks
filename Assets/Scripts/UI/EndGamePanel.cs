using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;
using TMPro;
public class EndGamePanel : MonoBehaviour
{

    [SerializeField] GameObject _popupEndGame;
    [SerializeField] Button _BtnPlayAgain;
    [SerializeField] Button _Btnhome;
    [SerializeField] TextMeshProUGUI _textSore;


    //VARIBLE
    Vector3 originPos;

    private void Awake()
    {
        AddEventClick();
    }
    private void OnEnable()
    {
        originPos = transform.position;
        
    }

    void AddEventClick()
    {
        _BtnPlayAgain.onClick.AddListener(PlayAgain);
    }


    public void Show()
    {
        this.gameObject.SetActive(true);
    }

    
    void PlayAgain()
    {
        _popupEndGame.transform.DOScale(0f, 0.2f).SetEase(Ease.InCubic).SetUpdate(true).OnComplete ( () => { 
            this.gameObject.SetActive(false);
            GameManager.Instance.ResetCurrentLevelState();
        });
    }

    public void ShowEndGameInfo()
    {
        _popupEndGame.transform.DOScale(1f, 0.2f).SetEase(Ease.InCubic).SetUpdate(true);
    }
}

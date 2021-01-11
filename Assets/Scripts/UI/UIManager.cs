using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIManager : MonoSingleton<UIManager>
{

    [Header("All panel in UI")]
    [SerializeField] MainGamePanel _gamePanel;
    [SerializeField] EndGamePanel _endGamePanel;
    [SerializeField] PausePanel _pausePanel;
    [SerializeField] HomePanel _homePanel;
    [SerializeField] ShopPanel _shopPanel;

    private void OnEnable()
    {
        GameManager.e_setStep += _gamePanel.SetStep;
        GameManager.e_setHighScore += _gamePanel.SetHighScore;
        _gamePanel.SetStep(0);
        _gamePanel.SetHighScore(GameManager.Instance.HighScore);
    }

    public void ShowHomePanel() 
    {
        _homePanel.Show();
    }  
    public void ShowGamePanel() => _gamePanel.Show();
    public void HideGamePanel()
    {
        _gamePanel.Hide();
        GameManager.Instance.BreakAllInMainGame();

    }
    public void ShowEndGameUI() => _endGamePanel.Show();
    public void ShowEndGameInfomation() => _endGamePanel.ShowEndGameInfo();
    public void ShowPausePanel() => _pausePanel.ShowPanel();
}

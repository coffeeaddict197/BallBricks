using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIManager : MonoSingleton<UIManager>
{
    [SerializeField] MainGamePanel panelGame;

    private void OnEnable()
    {
        GameManager.e_setStep += panelGame.SetStep;
        GameManager.e_setHighScore += panelGame.SetHighScore;
        panelGame.SetStep(0);
        panelGame.SetHighScore(GameManager.Instance.HighScore);
    }

}

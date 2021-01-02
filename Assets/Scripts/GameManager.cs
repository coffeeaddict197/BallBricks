using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
public class GameManager : MonoSingleton<GameManager>
{
    [Header("Game Properties")]
    private int _step;
    private int _highScore;

    // Getter setter
    public int Step
    {
        get => this._step;
        set
        {
            this._step = value;
            e_setStep?.Invoke(value);
            if (this._step > HighScore)
            {
                HighScore = this._step;
            }
        }
    }
    public int HighScore
    {
        get => this._highScore;
        set
        {
            this._highScore = value;
            PlayerPrefs.SetInt(KEY_HIGHSCORE, this._highScore);
            e_setHighScore?.Invoke(this._highScore);
        }
    }

    [Header("Game Event")]
    public static Action<int> e_setStep;
    public static Action<int> e_setHighScore;

    //KEY STRING
    const string KEY_HIGHSCORE = "HighScore";

    private new void Awake()
    {
        _highScore = PlayerPrefs.GetInt(KEY_HIGHSCORE, 0);

    }
}

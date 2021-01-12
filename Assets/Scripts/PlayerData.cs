using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;


[Serializable]
public class PlayerData
{
    private int _step;
    private int _highScore;
    private int _diamonds;
    private bool[] _balls;
    // Getter setter

    public bool[] Balls
    {
        get => _balls;
        set
        {
            _balls = value;
        }
    }
    public int Step
    {
        get => this._step;
        set
        {
            this._step = value;
            GameManager.e_setStep?.Invoke(value);
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
            //PlayerPrefs.SetInt(GameManager.KEY_HIGHSCORE, this._highScore);
            GameManager.e_setHighScore?.Invoke(this._highScore);
        }
    }

    public int Diamonds
    {
        get => _diamonds;
        set
        {
            _diamonds = value;
        }
    }

    public PlayerData()
    {
        HighScore = 0;
        Step = 0;
        Diamonds = 0;
        Balls = new bool[23];
    }

    public void ShowBall()
    {
        for(int i = 0; i< Balls.Length; i++)
        {
            Debug.LogFormat("{0} = {1}", i, Balls[i]);
        }
    }
}

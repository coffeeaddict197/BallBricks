﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
public class GameManager : MonoSingleton<GameManager>
{
    [Header("Game Properties")]
    public bool isGameOver;
    public static PlayerData playerData;
    //private int _step;
    //private int _highScore;
    //private int _diamonds;
    //// Getter setter
    //public int Step
    //{
    //    get => this._step;
    //    set
    //    {
    //        this._step = value;
    //        e_setStep?.Invoke(value);
    //        if (this._step > HighScore)
    //        {
    //            HighScore = this._step;
    //        }
    //    }
    //}
    //public int HighScore
    //{
    //    get => this._highScore;
    //    set
    //    {
    //        this._highScore = value;
    //        PlayerPrefs.SetInt(KEY_HIGHSCORE, this._highScore);
    //        e_setHighScore?.Invoke(this._highScore);
    //    }
    //}

    //public int Diamonds
    //{
    //    get => _diamonds;
    //    set
    //    {
    //        _diamonds = value;
    //    }
    //}
    [Header("Game Event")]
    public static Action<int> e_setStep;
    public static Action<int> e_setHighScore;

    //KEY STRING
    public const string KEY_HIGHSCORE = "HighScore";

    [Header("Game Object")]
    [SerializeField] GameObject BallObject;

    

    

    private new void Awake()
    {
        playerData = SaveLoadManager.LoadData();
        //playerData.Step = 0;
        if(playerData==null)
        {
            playerData = new PlayerData();
        }

    }


    public void ResetCurrentLevelState()
    {
        ResetGameState();
        LevelManager.Instance.currentLevel.ResetToOrigin();
        BallLauncher.Instance.ResetStateBall();
        BallLauncher.Instance.RetrieveAll();

    }

    public void InitializeAllObject()
    {
        isGameOver = false;
        BallObject.SetActive(true);
        MapGenerator.Instance.GenerateLevel(1);
        LevelManager.Instance.currentLevel.ReRandomPointNode();
        BallLauncher.Instance.ResetStateBall();
        ShopItemManager.Instance.UpdateBallSprite();


    }

    public void BreakAllInMainGame()
    {
        isGameOver = true;
        BallObject.SetActive(false);
        LevelManager.Instance.currentLevel.BrokenAll();
        BallLauncher.Instance.HideAllBall();
    }
    public void ResetGameState()
    {
        //RESET BALL NUMBER
        Time.timeScale = 1f;
        isGameOver = false;
        playerData.Step = 1;
    }


    public void PauseGame()
    {
        Time.timeScale = 0f;
    }

    public void UnPauseGame()
    {
        Time.timeScale = 1f;
    }

}

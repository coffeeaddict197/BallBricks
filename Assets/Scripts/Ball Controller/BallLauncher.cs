using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class BallLauncher : MonoSingleton<BallLauncher>
{
    public const string BALL_TAG = "Ball";

    [Header("Ball control")]
    [SerializeField] Vector2 _basePos;
    public Vector2 BasePos
    {
        get { return _basePos; }
        set
        {
            _basePos = value;
            transform.parent.gameObject.transform.DOMove(_basePos, moveTime);
            e_OnBasePosChange?.Invoke(_basePos);
        }
    }
    public Vector2 newBasePos;

    [SerializeField] int _returnedBallsCounter;
    public int ReturnedBallsCounter
    {
        get { return _returnedBallsCounter; }
        set
        {
            _returnedBallsCounter = value;
            if (value >= Balls.Count && (isMoving || isRetrieving)) Reset();
        }
    }
    [SerializeField] List<GameObject> Balls;
    [SerializeField] List<BallScript> BallScripts = new List<BallScript>();

    [Header("Moving control")]
    [Range(0.1f, 0.3f)]
    public float basePosOffset;
    [SerializeField] float _speed;
    public float Speed
    {
        get { return _speed; }
        set
        {
            _speed = value;
            e_OnSpeedChange?.Invoke(value);
        }
    }

    [SerializeField] float intervalTime;
    [SerializeField] WaitForSeconds fireInterval;

    [Header("Animation control")]
    public float moveTime;

    [Header("Flags")]
    public bool isMoving;
    public bool isRetrieving;
    public bool isBasePosChanged;

    [Header("Events")]
    public Action<float> e_OnSpeedChange;
    public Action<Vector2> e_OnBasePosChange;
    public Action e_OnRetrieveAll;
    public Action e_OnReset;

    protected override void Awake()
    {
        base.Awake();
    }

    void Start()
    {
        isMoving = false;
        BasePos = transform.position;
        ReturnedBallsCounter = Balls.Count;

        for (int i = 0; i < Balls.Count; i++)
        {
            Balls[i] = ObjectPool.Instance.Spawn(BALL_TAG);
            Balls[i].transform.position = BasePos;
            Balls[i].SetActive(true);
            BallScripts.Add(Balls[i].GetComponent<BallScript>());
        }



    }

    private void OnValidate()
    {
        fireInterval = new WaitForSeconds(intervalTime);
        e_OnSpeedChange?.Invoke(Speed);
    }

    public void StartFiring(Vector2 direction)
    {
        isMoving = true;
        StartCoroutine(CR_Fire(direction));
    }

    public void IncreaseBall()
    {
        ++ReturnedBallsCounter;
        var newBall = ObjectPool.Instance.Spawn(BALL_TAG);
        newBall.transform.position = BasePos;
        newBall.SetActive(true);
        Balls.Add(newBall);
        BallScripts.Add(newBall.GetComponent<BallScript>());
    }

    IEnumerator CR_Fire(Vector2 direction)
    {
        for (int i = 0; i < BallScripts.Count; i++)
        {
            ReturnedBallsCounter--;
            BallScripts[i].Fire(direction);
            yield return fireInterval;
        }
    }

    public void RetrieveAll()
    {
        StopAllCoroutines();
        isRetrieving = true;
        e_OnRetrieveAll?.Invoke();
    }

    public void Reset()
    {
        if (!GameManager.Instance.isGameOver)
        {
            BasePos = newBasePos;
            isMoving = false;
            isRetrieving = false;
            isBasePosChanged = false;
            ReturnedBallsCounter = Balls.Count;
            e_OnReset?.Invoke();
            LevelManager.Instance.currentLevel.DownLine();
        }
    }

    public void HideAllBall()
    {
        foreach (GameObject g in Balls)
        {
            g.GetComponent<BallScript>().Reset();
        }
    }

    public void ResetStateBall()
    {
        if (!GameManager.Instance.isGameOver)
        {
            isMoving = false;
            isRetrieving = false;
            isBasePosChanged = false;
            ReturnedBallsCounter = Balls.Count;
            e_OnReset?.Invoke();
        }
    }
}

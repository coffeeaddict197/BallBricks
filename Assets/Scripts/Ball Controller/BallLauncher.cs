using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BallLauncher : MonoSingleton<BallLauncher>
{
    public const string BALL_TAG = "Ball";

    [Header("Ball control")]
    public Vector2 basePos;

    [SerializeField] int _returnedBallsCounter;
    public int ReturnedBallsCounter
    {
        get { return _returnedBallsCounter; }
        set
        {
            _returnedBallsCounter = value;
            if (value == Balls.Count && isMoving) Reset();
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

    [Header("Flags")]
    public bool isMoving;

    [Header("Events")]
    public Action<float> e_OnSpeedChange;
    public Action e_OnReset;

    protected override void Awake()
    {
        base.Awake();
    }

    void Start()
    {
        isMoving = false;
        basePos = transform.position;
        ReturnedBallsCounter = Balls.Count;

        for (int i = 0; i < Balls.Count; i++)
        {
            Balls[i] = ObjectPool.Instance.Spawn(BALL_TAG);
            Balls[i].transform.position = basePos;
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

    IEnumerator CR_Fire(Vector2 direction)
    {
        for (int i = 0; i < BallScripts.Count; i++)
        {
            BallScripts[i].Fire(direction);
            ReturnedBallsCounter--;
            yield return fireInterval;
        }
    }

    public void Reset()
    {
        isMoving = false;
        ReturnedBallsCounter = Balls.Count;
        e_OnReset?.Invoke();
    }
}

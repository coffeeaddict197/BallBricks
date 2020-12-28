using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DrawTrajectory : MonoSingleton<DrawTrajectory>
{
    public const string DOT_TAG = "Dot";

    [Header("Gameobjects")]
    public Camera mainCamera;
    [Space]

    [Header("Line drawer")]
    [SerializeField] Vector2 touchPos;
    [SerializeField] Vector2 basePos;
    [SerializeField] Vector2 currentPos;
    [SerializeField] Vector2 nextPos;

    [SerializeField] Vector2 baseDirection;
    [SerializeField] Vector2 currentDirection;
    [SerializeField] float dotGap;
    [Space]

    [Header("Collide manage")]
    [SerializeField] CollideChecker collideChecker;
    //[SerializeField] CollideChecker collideChecker = new CollideChecker();
    [SerializeField] Vector2 collidePos = new Vector2();
    [SerializeField] GameObject collideObject;

    [Header("Dot Line")]
    [SerializeField] List<GameObject> Dots;
    [SerializeField] List<DotScript> DotScripts = new List<DotScript>();
    [Space]

    [Header("Flags")]
    [SerializeField] bool isCollided;

    // Start is called before the first frame update
    void Start()
    {
        isCollided = false;

        for (int i = 0; i < Dots.Count; i++)
        {
            Dots[i] = ObjectPool.Instance.Spawn(DOT_TAG);
            Dots[i].SetActive(true);
            DotScripts.Add(Dots[i].GetComponent<DotScript>());
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (BallLauncher.Instance.isMoving) return;

        if (Input.touchCount == 1)
        {
            var touch = Input.GetTouch(0);

            if (touch.phase == TouchPhase.Began || touch.phase == TouchPhase.Moved)
            {
                SetDirection(touch);
                DrawLine();
            }
            else if (touch.phase == TouchPhase.Ended)
            {
                Reset();
                if (touchPos.y > basePos.y) BallLauncher.Instance.StartFiring(baseDirection);
            }
        }
    }

    private void SetDirection(Touch touch)
    {
        isCollided = false;

        touchPos = mainCamera.ScreenToWorldPoint(touch.position);
        if (touchPos.y < basePos.y)
        {
            Reset();
            return;
        }

        baseDirection = (touchPos - basePos).normalized;

        collideChecker.GetCollideInfo(basePos, baseDirection, ref collidePos, ref collideObject);
    }

    private void DrawLine()
    {
        if (!isCollided)
        {
            currentDirection = baseDirection;
        }

        currentPos = basePos;
        for (int i = 0; i < Dots.Count; i++)
        {
            nextPos = currentPos + dotGap * currentDirection;

            if (collidePos != Vector2.zero && !isCollided)
            {
                if ((nextPos - basePos).sqrMagnitude >= (collidePos - basePos).sqrMagnitude)
                {
                    Collide();
                    isCollided = true;
                    nextPos = currentPos + dotGap * currentDirection;
                }
            }
            else if (collideChecker.IsWallCollided(nextPos))
            {
                DotScripts[i].Reset();
                continue;
            }

            currentPos = nextPos;

            Dots[i].transform.position = currentPos;
            Dots[i].SetActive(true);
        }
    }

    public void Collide()
    {
        CollideDirection collideDirection = collideChecker.GetCollideDirection(collidePos, collideObject, currentDirection);
        collideChecker.ChangeDirection(collideDirection, ref currentDirection);
    }

    public void Reset()
    {
        for (int i = 0; i < Dots.Count; i++)
        {
            Dots[i].transform.position = basePos;
        }
    }
}

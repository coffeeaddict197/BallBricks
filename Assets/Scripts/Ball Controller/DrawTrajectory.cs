using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DrawTrajectory : MonoSingleton<DrawTrajectory>
{
    const string DOT_TAG = "Dot";

    [Header("Gameobjects")]
    [SerializeField] Camera mainCamera;
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

    [Header("Dot Line")]
    [SerializeField] List<GameObject> Dots;
    [SerializeField] List<DotScript> DotScripts = new List<DotScript>();

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
                DrawLine(touch);
            }
            else if (touch.phase == TouchPhase.Ended)
            {
                Reset();
                if (touchPos.y > basePos.y) BallLauncher.Instance.StartFire(baseDirection);
            }
        }
    }

    private void DrawLine(Touch touch)
    {
        isCollided = false;

        touchPos = mainCamera.ScreenToWorldPoint(touch.position);
        if (touchPos.y < basePos.y)
        {
            Reset();
            return;
        }

        baseDirection = (touchPos - basePos).normalized;
        currentDirection = baseDirection;

        currentPos = basePos;
        for (int i = 0; i < Dots.Count; i++)
        {
            nextPos = currentPos + dotGap * currentDirection;

            if (CollideChecker.Instance.IsWallCollided(nextPos))
            {
                if (!isCollided) WallCollide();
                else
                {
                    DotScripts[i].Reset();
                    continue;
                }
            }
            else currentPos = nextPos;

            Dots[i].transform.position = currentPos;
            Dots[i].SetActive(true);
        }
    }

    public void CubeCollide()
    {
        CollideChecker.Instance.ChangeDirection_CubeCollided(nextPos, ref currentDirection);

        nextPos = currentPos + dotGap * currentDirection;
        isCollided = true;
    }

    public void WallCollide()
    {
        CollideChecker.Instance.ChangeDirection_WallCollided(nextPos, ref currentDirection);

        nextPos = currentPos + dotGap * currentDirection;
        isCollided = true;
    }

    public void Reset()
    {
        for (int i = 0; i < Dots.Count; i++)
        {
            Dots[i].transform.position = basePos;
        }
    }
}

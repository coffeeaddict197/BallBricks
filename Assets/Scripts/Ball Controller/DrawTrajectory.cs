using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DrawTrajectory : MonoSingleton<DrawTrajectory>
{
    public const string DOT_TAG = "Dot";
    public const string BRICK_LAYER = "Default";

    [Header("Gameobjects")]
    public Camera mainCamera;
    [Space]

    [Header("Line drawer")]
    [SerializeField] Vector2 touchPos;
    [SerializeField] Vector2 basePos;
    [SerializeField] Vector2 currentPos;
    [SerializeField] Vector2 nextPos;
    [Space]
    [SerializeField] Vector2 baseDirection;
    [SerializeField] Vector2 currentDirection;
    [SerializeField] Vector2 newDirection;
    [Space]
    [SerializeField] float lowerHeightLimit;
    [SerializeField] float dotGap;
    [Space]

    [Header("Collide manage")]
    [SerializeField] Vector2 collidePos = new Vector2();

    [Header("Dots")]
    [SerializeField] List<GameObject> Dots;
    [SerializeField] List<DotScript> DotScripts = new List<DotScript>();

    void Start()
    {
        BallLauncher.Instance.e_OnBasePosChange += ChangeBasePos;
        basePos = BallLauncher.Instance.BasePos;
        mainCamera = Camera.main;
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
        if (BallLauncher.Instance.isMoving)
        {
            if (Input.GetMouseButtonDown(1))
            {
                BallLauncher.Instance.RetrieveAll();
            }
            return;
        }

        if (Input.GetMouseButton(0))
        {
            var touchPos = mainCamera.ScreenToWorldPoint(Input.mousePosition);
            if ((touchPos.y - basePos.y) >= lowerHeightLimit)
            {
                SetDirection(touchPos);
            }
            DrawLine();
        }
        else if (Input.GetMouseButtonUp(0))
        {
            Reset();
            if (touchPos.y > basePos.y) { BallLauncher.Instance.StartFiring(baseDirection); }
        }
    }

    private void SetDirection(Vector2 touchPos)
    {
        if (touchPos.y < basePos.y)
        {
            Reset();
            return;
        }

        baseDirection = (touchPos - basePos).normalized;

        RaycastHit2D hit = Physics2D.Raycast(basePos, baseDirection, 10f, LayerMask.GetMask(BRICK_LAYER));
        if (hit.collider != null)
        {
            collidePos = hit.point;
            Vector2 inNormal = hit.normal;
            newDirection = Vector2.Reflect(baseDirection, inNormal);
        }
        else collidePos = basePos;
    }

    private void DrawLine()
    {
        currentDirection = baseDirection;

        currentPos = basePos;
        for (int i = 0; i < Dots.Count; i++)
        {
            nextPos = currentPos + dotGap * currentDirection;

            if (collidePos != Vector2.zero)
            {
                if ((nextPos - basePos).sqrMagnitude >= (collidePos - basePos).sqrMagnitude)
                {
                    currentDirection = newDirection;
                    nextPos = currentPos + dotGap * currentDirection;
                }
                if (IsWallCollided(nextPos))
                {
                    DotScripts[i].Reset();
                    continue;
                }
            }

            currentPos = nextPos;

            Dots[i].transform.position = currentPos;
            Dots[i].SetActive(true);
        }
    }

    public void ChangeBasePos(Vector2 pos) => basePos = pos;

    public void Reset()
    {
        for (int i = 0; i < Dots.Count; i++)
        {
            Dots[i].transform.position = basePos;
        }
    }

    public bool IsWallCollided(Vector2 pos)
    {
        Vector2 screenPos = mainCamera.WorldToViewportPoint(pos);
        return (screenPos.x > 1 || screenPos.x < 0 || screenPos.y > 1 || screenPos.y < 0);
    }
}

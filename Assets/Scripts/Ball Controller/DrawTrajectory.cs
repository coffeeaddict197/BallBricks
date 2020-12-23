using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DrawTrajectory : MonoBehaviour
{
    const string DOT_TAG = "Dot";

    [Header("Gameobjects")]
    [SerializeField] Camera mainCamera;
    [SerializeField] GameObject prefab;
    [Space]

    [Header("Fire line drawer")]
    [SerializeField] Vector2 baseBallPos;
    [SerializeField] Vector2 touchPos;
    [SerializeField] Vector2 direction;
    [SerializeField] float dotDistance;
    [SerializeField] int changeDirectionCounter;
    [Space]

    [Header("Dot Line")]
    [SerializeField] List<GameObject> Dots;

    // Start is called before the first frame update
    void Start()
    {
        mainCamera = Camera.main;
        changeDirectionCounter = 0;

        for (int i = 0; i < Dots.Count; i++)
        {
            Dots[i] = ObjectPool.Instance.Spawn(DOT_TAG);
            Dots[i].SetActive(true);
        }
    }

    // Update is called once per frame
    void Update()
    {
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
            }
        }
    }

    private void DrawLine(Touch touch)
    {
        changeDirectionCounter = 0;

        touchPos = mainCamera.ScreenToWorldPoint(touch.position);
        if (touchPos.y < baseBallPos.y)
        {
            Reset();
            return;
        }

        direction = (touchPos - baseBallPos).normalized;
        Vector2 dotPos = baseBallPos;
        for (int i = 0; i < Dots.Count; i++)
        {
            var nextPos = dotPos + dotDistance * direction;

            if (CollideChecker.Instance.IsWallCollided(nextPos) && changeDirectionCounter == 0)
            {
                ChangeDirection(nextPos);
            }
            dotPos += dotDistance * direction;
            Dots[i].transform.position = dotPos;
            Dots[i].SetActive(true);
        }
    }

    private void ChangeDirection(Vector2 pos)
    {
        switch (CollideChecker.Instance.GetWallCollidedDirection(pos))
        {
            case CollideDirection.Top: 
            case CollideDirection.Bottom:
                {
                    direction.y *= -1;
                    break;
                }
            case CollideDirection.Left: 
            case CollideDirection.Right:
                {
                    direction.x *= -1;
                    break;
                }
            default:
                break;
        }

        changeDirectionCounter++;
    }

    public void Reset()
    {
        for (int i = 0; i < Dots.Count; i++)
        {
            Dots[i].SetActive(false);
        }
        changeDirectionCounter = 0;
    }
}

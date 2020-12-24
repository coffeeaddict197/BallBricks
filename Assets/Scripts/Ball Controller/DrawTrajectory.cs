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
    [Space]

    [Header("Dot Line")]
    [SerializeField] List<GameObject> Dots;
    [SerializeField] List<DotScript> DotScripts = new List<DotScript>();

    [Header("Flags")]
    [SerializeField] bool isDirectionChanged;

    // Start is called before the first frame update
    void Start()
    {
        mainCamera = Camera.main;
        isDirectionChanged = false;

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
        isDirectionChanged = false;

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

            if (CollideChecker.Instance.IsWallCollided(nextPos))
            {
                if (!isDirectionChanged)
                {
                    CollideChecker.Instance.ChangeDirection(nextPos, ref direction);
                    isDirectionChanged = true;
                }
                else
                {
                    DotScripts[i].Reset();
                    continue;
                }
            }
           
            dotPos += dotDistance * direction;
            Dots[i].transform.position = dotPos;
            Dots[i].SetActive(true);
        }
    }

    public void Reset()
    {
        for (int i = 0; i < Dots.Count; i++)
        {
            Dots[i].transform.position = baseBallPos;
        }
    }
}

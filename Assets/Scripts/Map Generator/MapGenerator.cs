using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MapGenerator : MonoBehaviour
{
    Camera cam;

    private void Awake()
    {
        cam = Camera.main;
    }
    //Letter box
    private void Start()
    {
        Vector3 leftPoint = cam.MiddleLeftPoint();
        Vector3 rightPoint = cam.MiddleRightPoint();

        Debug.Log(Vector3.Distance(leftPoint,rightPoint));
        Debug.Log(rightPoint);

    }

}

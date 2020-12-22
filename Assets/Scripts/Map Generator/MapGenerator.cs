using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MapGenerator : MonoBehaviour
{
    Camera cam;
    public GameObject test;
    public int numOfWidth;
    public float offset;
    private void Awake()
    {
        cam = Camera.main;
    }
    //Letter box
    private void Start()
    {
        Vector2 leftPoint = cam.TopLeftPoint();
        Vector2 rightPoint = cam.TopRightPoint();
        float distance = (Vector2.Distance(leftPoint, rightPoint) - offset*(numOfWidth-1)) / numOfWidth;

        
        for (int i = 0; i < 9; i++)
        {
            Vector2 fistPos = new Vector2(leftPoint.x + distance / 2, leftPoint.y - distance/2);
            for (int j = 0; j < 9; j++)
            {
                GameObject block = Instantiate(test);
                block.transform.localScale = new Vector2(distance, distance);
                block.transform.position = new Vector2(fistPos.x, fistPos.y);
                fistPos = new Vector2(fistPos.x + distance + offset , fistPos.y);
            }
            leftPoint = new Vector2(leftPoint.x, leftPoint.y - distance - offset);
        }
    }

}

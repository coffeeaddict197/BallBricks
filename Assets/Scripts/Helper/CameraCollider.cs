using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraCollider : MonoBehaviour
{
    Camera cam;
    List<Vector2> points;
    EdgeCollider2D edCol;
    public GameObject wall;

    private void Awake()
    {
        points = new List<Vector2>();
        edCol = GetComponent<EdgeCollider2D>();
        cam = Camera.main;
    }

    private void Start()
    {
        DrawEdgeCollider();
        GenerateWall();
    }



    void DrawEdgeCollider()
    {
        points.Add(cam.TopLeftPoint());
        points.Add(cam.TopRightPoint());
        points.Add(cam.BottomRightPoint());
        points.Add(cam.BottomLeftPoint());
        points.Add(cam.TopLeftPoint());
        edCol.points = points.ToArray();
        edCol.offset = cam.MiddlePoint() * -1;
    }

    void GenerateWall()
    {
        //Left
        GameObject wallLeft = Instantiate(wall, transform);
        wallLeft.transform.position = new Vector2(cam.MiddleLeftPoint().x - wallLeft.GetComponent<SpriteRenderer>().bounds.size.x / 2 , cam.MiddleLeftPoint().y);

        //Right
        GameObject wallRight = Instantiate(wall, transform);
        wallRight.transform.position = new Vector2(cam.MiddleRightPoint().x + wallRight.GetComponent<SpriteRenderer>().bounds.size.x / 2, cam.MiddleRightPoint().y);

        //TOP
        GameObject wallTop = Instantiate(wall, transform);
        wallTop.transform.rotation = Quaternion.Euler(0f, 0f, 90f);
        wallTop.transform.position = new Vector2(cam.TopMiddlePoint().x, cam.TopMiddlePoint().y + wallTop.GetComponent<SpriteRenderer>().bounds.size.y / 2);

        //Bottom
        GameObject wallBot = Instantiate(wall, transform);
        wallBot.transform.rotation = Quaternion.Euler(0f, 0f, 90f);
        wallBot.transform.position = new Vector2(cam.BottomMiddlePoint().x, cam.BottomMiddlePoint().y - wallTop.GetComponent<SpriteRenderer>().bounds.size.y / 2);
    }
}

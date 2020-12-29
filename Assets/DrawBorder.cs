using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DrawBorder : MonoBehaviour
{
    Camera cam;
    List<Vector2> points;
    EdgeCollider2D edCol;

    // Start is called before the first frame update
    void Start()
    {
        cam = Camera.main;
        points = new List<Vector2>();
        edCol = GetComponent<EdgeCollider2D>();
        drawScreenBorder();
    }

    private void drawScreenBorder()
    {
        points.Add(cam.TopLeftPoint());
        points.Add(cam.TopRightPoint());
        points.Add(cam.BottomRightPoint());
        points.Add(cam.BottomLeftPoint());
        points.Add(cam.TopLeftPoint());

        edCol.points = points.ToArray();
        edCol.offset = cam.MiddlePoint() * -1;
    }
}

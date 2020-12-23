using System.Collections;
using System.Collections.Generic;
using UnityEngine;



public class MapGenerator : MonoBehaviour
{
    Camera cam;
    [SerializeField] GameObject brick;
    [SerializeField] int numOfWidth;
    [SerializeField] float offset;
    public ArrayInt[] mArray;

    private void Awake()
    {
        cam = Camera.main;
    }
    //Letter box
    private void Start()
    {

        DrawMatrix();
    }


    public void DrawMatrix()
    {
        Vector2 leftPoint = cam.TopLeftPoint();
        Vector2 rightPoint = cam.TopRightPoint();
        float distance = (Vector2.Distance(leftPoint, rightPoint) - offset * (numOfWidth - 1)) / numOfWidth;  //Distance mean scale 
        float scaleFactor = brick.GetComponent<SpriteRenderer>().sprite.rect.width / brick.GetComponent<SpriteRenderer>().sprite.pixelsPerUnit;

        //Convert scale to distance accurate
        distance /= scaleFactor;

        for (int i = 0; i < numOfWidth; i++)
        {
            Vector2 fistPos = new Vector2(leftPoint.x, leftPoint.y);
            float distanceY = 0f;
            for (int j = 0; j < numOfWidth; j++)
            {
                if (mArray[i][j] == 0)
                {

                }
                else if (mArray[i][j] == -1)
                {

                }
                else
                {
                    GameObject block = Instantiate(brick, transform);
                    //Setup
                    block.transform.localScale = new Vector2(distance, distance);
                    block.transform.position = new Vector2(fistPos.x + block.GetComponent<SpriteRenderer>().bounds.size.x / 2, fistPos.y - block.GetComponent<SpriteRenderer>().bounds.size.y / 2);
                    fistPos = new Vector2(fistPos.x + block.GetComponent<SpriteRenderer>().bounds.size.x + offset, fistPos.y);
                    block.GetComponent<Brick>().Point = mArray[i][j];

                    //Get distance Heigh
                    distanceY = block.GetComponent<SpriteRenderer>().bounds.size.y;
                }
            }
            leftPoint = new Vector2(leftPoint.x, leftPoint.y - distanceY - offset);
        }

    }

}

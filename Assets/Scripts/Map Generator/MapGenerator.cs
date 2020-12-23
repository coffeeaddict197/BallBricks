using System.Collections;
using System.Collections.Generic;
using UnityEngine;



public class MapGenerator : MonoBehaviour
{
    Camera cam;
    [SerializeField] GameObject brick;
    [SerializeField] GameObject triagle;

    [SerializeField] int numOfWidth;
    [SerializeField] float offset;
    public ArrayInt[] mArray;


    GameObject baseObject;
    private void Awake()
    {
        cam = Camera.main;
    }
    //Letter box
    private void Start()
    {

        DrawMatrix();
    }

     //Get distance Heigh
    public void DrawMatrix()
    {
        Vector2 leftPoint = cam.TopLeftPoint();
        Vector2 rightPoint = cam.TopRightPoint();
        float distance = (Vector2.Distance(leftPoint, rightPoint) - offset * (numOfWidth - 1)) / numOfWidth;  //Distance mean scale 
        float scaleFactor = brick.GetComponent<SpriteRenderer>().sprite.rect.width / brick.GetComponent<SpriteRenderer>().sprite.pixelsPerUnit;

        //Convert scale to distance accurate
        distance /= scaleFactor;

        float distanceY = 0f;
        float distanceX = 0f;
        //Create base object
        baseObject = Instantiate(brick, transform);
        baseObject.transform.localScale = new Vector2(distance, distance);
        distanceY = baseObject.GetComponent<SpriteRenderer>().bounds.size.y;
        distanceX = baseObject.GetComponent<SpriteRenderer>().bounds.size.x;
        baseObject.SetActive(false);



        for (int i = 0; i < numOfWidth; i++)
        {
            Vector2 fistPos = new Vector2(leftPoint.x, leftPoint.y);
            for (int j = 0; j < numOfWidth; j++)
            {
                if (mArray[i][j] == 0) //Blank
                {

                }
                else if (mArray[i][j] == -1)  //Inscre ball
                {

                }
                else if(mArray[i][j]>0)
                {
                    GameObject block = Instantiate(brick, transform);
                    //Setup
                    block.transform.localScale = new Vector2(distance, distance);
                    block.transform.position = new Vector2(fistPos.x + distanceX  / 2, fistPos.y - distanceY / 2);
                    block.GetComponent<Brick>().Point = mArray[i][j];
                }
                else
                {
                    GameObject tria = Instantiate(triagle, transform);
                    //Setup
                    tria.transform.localScale = new Vector2(distance, distance);
                    tria.transform.position = new Vector2(fistPos.x + distanceX / 2, fistPos.y - distanceY / 2);
                    tria.GetComponent<Triagle>().Point = mArray[i][j];
                }
                fistPos = new Vector2(fistPos.x + distanceX + offset, fistPos.y);
            }
            leftPoint = new Vector2(leftPoint.x, leftPoint.y - distanceY - offset);
        }

    }

}

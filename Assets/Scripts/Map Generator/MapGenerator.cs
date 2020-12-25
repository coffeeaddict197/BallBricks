using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class MapGenerator : MonoSingleton<MapGenerator>
{

    Camera cam;
    [SerializeField] GameObject parentBricks;


    [SerializeField] GameObject brick;
    [SerializeField] GameObject triagle1;
    [SerializeField] GameObject triagle2;
    [SerializeField] GameObject triagle3;
    [SerializeField] GameObject triagle4;
    [SerializeField] GameObject inscrease;



    [SerializeField] int numOfWidth;
    [SerializeField] float offset;

    GameObject baseObject;

    private new void Awake()
    {
        cam = Camera.main;
    }
    //Letter box
    private void Start()
    {

        DrawMatrix(LevelManager.Instance.allLevel[0]);
    }

    //Get distance Heigh
    public void DrawMatrix(Level level)
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
        baseObject = Instantiate(brick, parentBricks.transform);
        baseObject.transform.localScale = new Vector2(distance, distance);
        distanceY = baseObject.GetComponent<SpriteRenderer>().bounds.size.y;
        distanceX = baseObject.GetComponent<SpriteRenderer>().bounds.size.x;
        baseObject.SetActive(false);



        for (int i = 0; i < numOfWidth; i++)
        {
            Vector2 fistPos = new Vector2(leftPoint.x, leftPoint.y);
            for (int j = 0; j < numOfWidth; j++)
            {
                //Demical and fraction
                int d = 0, f = 0;
                SeprateFloatNumber(ref d, ref f, level.mArray[i][j]);

                //Generate block

                //Inscre ball
                if ((int)level.mArray[i][j] == -1)  
                {
                    GameObject inscre = Instantiate(inscrease, parentBricks.transform);
                    //Setup
                    inscre.transform.localScale = new Vector2(distance*0.8f, distance*0.8f);
                    inscre.transform.position = new Vector2(fistPos.x + distanceX / 2, fistPos.y - distanceY / 2);
                }
                else if (level.mArray[i][j] > 0)
                {
                    //Square
                    if (f == 0)
                    {
                        GameObject block = Instantiate(brick, parentBricks.transform);
                        //Setup
                        block.transform.localScale = new Vector2(distance, distance);
                        block.transform.position = new Vector2(fistPos.x + distanceX / 2, fistPos.y - distanceY / 2);
                        block.GetComponent<Brick>().Point = (int)level.mArray[i][j];
                    }
                    //Triagle 
                    else
                    {
                        GameObject tria = null;
                        if (f == 1)
                        {
                            tria = Instantiate(triagle1, parentBricks.transform);
                   
                        }
                        else if (f == 2)
                        {
                            tria = Instantiate(triagle2, parentBricks.transform);
                           
                        }
                        //◺
                        else if (f == 3)
                        {
                            tria = Instantiate(triagle3, parentBricks.transform);
                            
                        }
                        else if (f == 4)
                        {
                            tria = Instantiate(triagle4, parentBricks.transform);
                        }
                        //setup
                        tria.transform.localScale = new Vector2(distance, distance);
                        tria.transform.position = new Vector2(fistPos.x + distanceX / 2, fistPos.y - distanceY / 2);
                        tria.GetComponent<Triagle>().Point = (int)level.mArray[i][j];
                    }
                }


                fistPos = new Vector2(fistPos.x + distanceX + offset, fistPos.y);
            }
            leftPoint = new Vector2(leftPoint.x, leftPoint.y - distanceY - offset);
        }

    }



    void SeprateFloatNumber(ref int a, ref int b, float origin)
    {

        a = (int)origin;
        float fractionalPart = origin - a;
        b = (Mathf.RoundToInt(fractionalPart * 10f));



    }

}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class MapGenerator : MonoSingleton<MapGenerator>
{
#pragma warning disable

    Camera cam;
    [SerializeField] GameObject parentBricks;

    [Header("Prefab")]
    [SerializeField] GameObject brick;
    [SerializeField] GameObject triagle1;
    [SerializeField] GameObject triagle2;
    [SerializeField] GameObject triagle3;
    [SerializeField] GameObject triagle4;
    [SerializeField] GameObject inscrease;


    [Header("First Setup")]
    Vector2 _leftPointGenerate;
    Vector2 _rightPointGenerate;
    int numOfWidth;
    [SerializeField] float offset;

    GameObject baseObject;

    private new void Awake()
    {


        Initialize();
        numOfWidth = LevelManager.Instance.withMatrix;
    }

    



    void Initialize()
    {
        cam = Camera.main;
        GameObject objLine = GameObject.FindGameObjectWithTag("LineSetup");
        RectTransform rect = objLine.GetComponent<RectTransform>();
        //GET 4 CORNER
        Vector3[] corners = new Vector3[4];
        rect.GetWorldCorners(corners); //GET 4 Corner form world Position
        float bottomPos = corners[0].y;
        foreach(Vector3 corner in corners)
        {
            Vector2 screenPoint = RectTransformUtility.WorldToScreenPoint(null, corner);  //Convert To Screen Point
            if (bottomPos > screenPoint.y)
            {
                bottomPos = screenPoint.y;
            }
        }





        _leftPointGenerate = new Vector2(cam.TopLeftPoint().x, bottomPos);
        _rightPointGenerate = new Vector2(cam.TopRightPoint().x, bottomPos);
    }

    public void GenerateLevel(int level)
    {
        if (LevelManager.Instance.currentLevel != null)
        {
            LevelManager.Instance.currentLevel.HideAllBlock();
            LevelManager.Instance.currentLevel.allNode.Clear();
        }
        //ONLY USING INFINITY GAME
        List<NodePiece> node = new List<NodePiece>();
        node = DrawMatrix(LevelManager.Instance.LoadLevel(level));
        LevelManager.Instance.currentLevel.allNode = node;
        //LevelManager.Instance.currentLevel.RandomFirstRowMatrix(LevelManager.Instance.currentLevel.mArray);

    }



    List<NodePiece> DrawMatrix(Level level)
    {
        List<NodePiece> node = new List<NodePiece>();

        Vector2 leftPoint = _leftPointGenerate;
        Vector2 rightPoint = _rightPointGenerate;
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
                NodePiece newNode = null;
                //Inscre ball
                if ((int)level.mArray[i][j] == -1)
                {
                    //GameObject inscre = Instantiate(inscrease, parentBricks.transform);
                    //Setup
                    newNode = ObjectPool.Instance.Spawn(MyTags.INSCRE).GetComponent<NodePiece>();
                    newNode.SetLocalScale(new Vector2(distance, distance));
                    newNode.SetPosion(new Vector2(fistPos.x + distanceX / 2, fistPos.y - distanceY / 2));
                    node.Add(newNode);


                }
                else if (level.mArray[i][j] > 0)
                {
                    //Square
                    if (f == 0)
                    {
                        newNode = ObjectPool.Instance.Spawn(MyTags.BRICK).GetComponent<NodePiece>();
                    }
                    else if (f < 4)
                    {
                        //Triagle 
                        if (f == 1) newNode = ObjectPool.Instance.Spawn(MyTags.TRIAGLE_1).GetComponent<NodePiece>();
                        else if (f == 2) newNode = ObjectPool.Instance.Spawn(MyTags.TRIAGLE_2).GetComponent<NodePiece>();
                        else if (f == 3) newNode = ObjectPool.Instance.Spawn(MyTags.TRIAGLE_3).GetComponent<NodePiece>();
                        else if (f == 4) newNode = ObjectPool.Instance.Spawn(MyTags.TRIAGLE_4).GetComponent<NodePiece>();
                    }
                    else
                    {
                        //EFFECT
                        if (f == 5) newNode = ObjectPool.Instance.Spawn(MyTags.EFFECT_HORIZONTAL).GetComponent<NodePiece>();
                        else if (f == 6) newNode = ObjectPool.Instance.Spawn(MyTags.EFFECT_VERTICLE).GetComponent<NodePiece>();
                        else if (f == 7) newNode = ObjectPool.Instance.Spawn(MyTags.EFFECT_2D).GetComponent<NodePiece>();
                        newNode.SetLocalScale(new Vector2(distance, distance));
                        newNode.SetPosion(new Vector2(fistPos.x + distanceX / 2, fistPos.y - distanceY / 2));
                        node.Add(newNode);
                        fistPos = new Vector2(fistPos.x + distanceX + offset, fistPos.y);
                        continue;
                    }


                    newNode.SetLocalScale(new Vector2(distance, distance));
                    newNode.SetPosion(new Vector2(fistPos.x + distanceX / 2, fistPos.y - distanceY / 2));
                    newNode.Point = (int)level.mArray[i][j];
                    node.Add(newNode);
                }



                fistPos = new Vector2(fistPos.x + distanceX + offset, fistPos.y);
            }
            leftPoint = new Vector2(leftPoint.x, leftPoint.y - distanceY - offset);
        }

        return node;

    }


    #region USING FOR GAME 1 LEVEL ( BBTAN , ..)
    public List<NodePiece> GenerateNewLineBlock(Level level)
    {
        List<NodePiece> node = new List<NodePiece>();

        Vector2 leftPoint = _leftPointGenerate;
        Vector2 rightPoint = _rightPointGenerate;

        float distance = (Vector2.Distance(leftPoint, rightPoint) - offset * (numOfWidth - 1)) / numOfWidth;  //Distance mean scale 
        float scaleFactor = brick.GetComponent<SpriteRenderer>().sprite.rect.width / brick.GetComponent<SpriteRenderer>().sprite.pixelsPerUnit;

        //Convert scale to distance accurate
        distance /= scaleFactor;

        float distanceY = 0f;
        float distanceX = 0f;
        //Create base object
        distanceY = baseObject.GetComponent<SpriteRenderer>().bounds.size.y;
        distanceX = baseObject.GetComponent<SpriteRenderer>().bounds.size.x;


        Vector2 fistPos = new Vector2(leftPoint.x, leftPoint.y);
        for (int j = 0; j < numOfWidth; j++)
        {
            //Demical and fraction
            int d = 0, f = 0;
            SeprateFloatNumber(ref d, ref f, level.mArray[0][j]);

            //Generate block
            NodePiece newNode = null;

            //Inscre ball
            if ((int)level.mArray[0][j] == -1)
            {
                //Setup
                newNode = ObjectPool.Instance.Spawn(MyTags.INSCRE).GetComponent<NodePiece>();
                newNode.SetLocalScale(new Vector2(distance, distance));
                newNode.SetPosion(new Vector2(fistPos.x + distanceX / 2, fistPos.y - distanceY / 2));
                node.Add(newNode);


            }
            else if ((int)level.mArray[0][j] > 0)
            {
                //Square
                if (f == 0)
                {
                    newNode = ObjectPool.Instance.Spawn(MyTags.BRICK).GetComponent<NodePiece>();
                }
                //TRIAGLE
                else if (f <= 4)
                {
                    //Triagle 
                    if (f == 1) newNode = ObjectPool.Instance.Spawn(MyTags.TRIAGLE_1).GetComponent<NodePiece>();
                    else if (f == 2) newNode = ObjectPool.Instance.Spawn(MyTags.TRIAGLE_2).GetComponent<NodePiece>();
                    else if (f == 3) newNode = ObjectPool.Instance.Spawn(MyTags.TRIAGLE_3).GetComponent<NodePiece>();
                    else if (f == 4) newNode = ObjectPool.Instance.Spawn(MyTags.TRIAGLE_4).GetComponent<NodePiece>();
                }
                //EFFECT
                else
                {
                    if (f == 5) newNode = ObjectPool.Instance.Spawn(MyTags.EFFECT_HORIZONTAL).GetComponent<NodePiece>();
                    else if (f == 6) newNode = ObjectPool.Instance.Spawn(MyTags.EFFECT_VERTICLE).GetComponent<NodePiece>();
                    else if (f == 7) newNode = ObjectPool.Instance.Spawn(MyTags.EFFECT_2D).GetComponent<NodePiece>();


                    newNode.SetLocalScale(new Vector2(distance, distance));
                    newNode.SetPosion(new Vector2(fistPos.x + distanceX / 2, fistPos.y - distanceY / 2));
                    node.Add(newNode);
                    fistPos = new Vector2(fistPos.x + distanceX + offset, fistPos.y);

                    continue;

                }


                newNode.SetLocalScale(new Vector2(distance, distance));
                newNode.SetPosion(new Vector2(fistPos.x + distanceX / 2, fistPos.y - distanceY / 2));
                newNode.Point = (int)level.mArray[0][j];
                node.Add(newNode);
            }



            fistPos = new Vector2(fistPos.x + distanceX + offset, fistPos.y);
        }


        return node;

    }


    #endregion





    void SeprateFloatNumber(ref int a, ref int b, float origin)
    {

        a = (int)origin;
        float fractionalPart = origin - a;
        b = (Mathf.RoundToInt(fractionalPart * 10f));



    }

}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
public class Level : MonoBehaviour
{
    [Header("Setup default Level")]
    public int level;
    public int countBlock;
    public ArrayInt[] mArray;
    public int step;

    [HideInInspector]
    public List<NodePiece> allNode;

    [Header("RATE") , Range(0,100)]
    [SerializeField] int RateEffect;


    [HideInInspector]
    //tick the node (example effect2d , effect verticle , ...) will be destroy when launching end 
    public List<NodePiece> tickNode;



    private void Awake()
    {
        tickNode = new List<NodePiece>();
        allNode = new List<NodePiece>();
    }
    private void Start()
    {
        countBlock = GetNumOfBlock();
    }


    public void DownLine()
    {
        UnactiveAllTickNode();

        foreach (NodePiece node in allNode)
            node.DownLine();

        CreateFirstLineMatrix();
        step++;
        GameManager.Instance.Step = step;
        
    }

    void CreateFirstLineMatrix()
    {
        RandomFirstRowMatrix(mArray);
        //Add new to list
        allNode.AddRange(MapGenerator.Instance.GenerateNewLineBlock(this));
    }


    int GetNumOfBlock()
    {
        int temp = 0;
        for (int i = 0; i < LevelManager.Instance.withMatrix; i++)
        {
            for(int j = 0; j < LevelManager.Instance.withMatrix; j++)
            {
                if(mArray[i][j]>0)
                {
                    temp++;
                }
            }
        }

        return temp;
    }

    public void HideAllBlock()
    {
        for(int i = 0; i< allNode.Count; i++)
        {
            allNode[i].gameObject.SetActive(false);
        }
    }



    public void RandomFirstRowMatrix(ArrayInt[] array)
    {
        List<int> posBlank = new List<int>();
        for (int i = 0; i < LevelManager.Instance.withMatrix; i++)
        {
            if (RandomBlank(array, i))
            {
                posBlank.Add(i);
                continue;
            }
            if (RandomBlock(array, i)) continue;
        }

        //Random effect
        RandomInscreBall(array , ref posBlank);
        RandomEffect(array , ref posBlank);
    }

    bool RandomBlank(ArrayInt[] array , int i)
    {
        int isNew = Random.Range(0, 2);
        if (isNew == 0)
        {
            array[0][i] = 0;
            return true;
        }
        return false;
    }

    bool RandomBlock(ArrayInt[] array , int i)
    {
        float newPoint = Random.Range(step, step + 10);
        int ratio = Random.Range(0, 100 + 1);
        int fraction = 0;
        if (ratio < 30)
        {
            fraction = Random.Range(1, 5);
        }
        else
        {
            fraction = 0;
        }

        float dotFraction = (float)fraction / 10;
        newPoint += dotFraction;
        array[0][i] = newPoint;

        return true;
    }


    void RandomInscreBall(ArrayInt[] arr ,  ref List<int> pos)
    {
        int col = Random.Range(0, pos.Count);
        arr[0][col] = -1;
        pos.RemoveAt(col);

    }

    void RandomEffect(ArrayInt[] arr , ref List<int> pos)
    {
        int rd = Random.Range(0, 100);
        if(rd< RateEffect)
        {
            int col = Random.Range(0, pos.Count);
            int f = Random.Range(5, 8);
            arr[0][col] = 1 + (float)f / 10;
            pos.RemoveAt(col);
        }
    }

    void UnactiveAllTickNode()
    {
        if(tickNode.Count!=0)
        {
            foreach (NodePiece node in tickNode)
            {
                node.transform.gameObject.SetActive(false);
            }
            tickNode.Clear();
        }
    }

    public void StopAllNode()
    {
        for (int i = 0; i < allNode.Count; i++)
        {
            allNode[i].gameObject.GetComponent<NodePiece>().enabled = false;
        }
    }

    public void ResetToOrigin()
    {
        for(int i = 0; i < allNode.Count; i++)
        {
            allNode[i].SelfBroken();
        }
        allNode.Clear();
        step = 1;
        CreateFirstLineMatrix();
        GameManager.Instance.Step = step;
    }


}

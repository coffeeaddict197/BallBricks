﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

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


    private void Awake()
    {
        allNode = new List<NodePiece>();
    }
    private void Start()
    {
        countBlock = GetNumOfBlock();
    }


    private void Update()
    {
        if(Input.GetKeyDown(KeyCode.F))
            DownLine();
    }

    public void DownLine()
    {
        foreach (NodePiece node in allNode)
            node.DownLine();

        RandomFirstRowMatrix(mArray);
        allNode.AddRange(MapGenerator.Instance.GenerateNewLineBlock(this));
        step++;
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

            Debug.Log(1 + (float)f / 10);


        }
    }


}
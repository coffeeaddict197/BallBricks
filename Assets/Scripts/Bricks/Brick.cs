using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
public class Brick : NodePiece
{
    new void Awake()
    {
        base.Awake();
    }


    private void Update()
    {
        if(Input.GetKey(KeyCode.A))
        {
            Point--;
        }
    }
}

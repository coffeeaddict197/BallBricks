using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Diamond : NodePiece
{
     private new void Awake()
    {
        //Do nothing
    }

    public override void Collided()
    {
        GameManager.playerData.Diamonds++;
        gameObject.SetActive(false);
        
    }
}

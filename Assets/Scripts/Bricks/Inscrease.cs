using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Inscrease : NodePiece , ICollisionWithBall
{
    private void Awake()
    {
        //Do nothing
    }
    public override void Collided()
    {
        BallLauncher.Instance.IncreaseBall();
        gameObject.SetActive(false);
    }

}

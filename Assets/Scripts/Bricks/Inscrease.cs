using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Inscrease : NodePiece , ICollisionWithBall
{
    public void Collided()
    {
        BallLauncher.Instance.IncreaseBall();
        gameObject.SetActive(false);
    }

}

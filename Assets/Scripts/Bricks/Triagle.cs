using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Triagle : NodePiece , ICollisionWithBall
{
    new void Awake()
    {
        base.Awake();
    }

    public void Collided()
    {
        Point--;
        if (Point == 0)
        {
            LevelManager.Instance.currentLevel.countBlock--;
            gameObject.SetActive(false);
        }
    }

}

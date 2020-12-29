using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
public class Brick : NodePiece , ICollisionWithBall
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
            LevelManager.Instance.currentLevel.allNode.Remove(this);
            gameObject.SetActive(false);
        }
    }


}

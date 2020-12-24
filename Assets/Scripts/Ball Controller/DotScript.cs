using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DotScript : MonoBehaviour, ICollideWithCube
{
    [SerializeField] Vector2 basePos;

    public void Collide()
    {
        DrawTrajectory.Instance.CubeCollide();
    }

    public void Reset()
    {
        gameObject.transform.position = basePos;
        gameObject.SetActive(false);
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestCubeScript : MonoBehaviour
{
    private void OnCollisionEnter2D(Collision2D collision)
    {
        ICollideWithCube collider = collision.gameObject.GetComponent<ICollideWithCube>();

        if (collider != null)
        {
            collider.Collide();
            collision.gameObject.SetActive(false);
        }
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DotScript : MonoBehaviour
{
    [SerializeField] Vector2 basePos;

    public void Reset()
    {
        gameObject.transform.position = basePos;
        gameObject.SetActive(false);
    }
}

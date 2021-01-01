using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UnactiveAfterTime : MonoBehaviour
{
    [SerializeField] float second;
    private void OnEnable()
    {
        StartCoroutine(UnactiveAfterSeconds());
    }

    IEnumerator UnactiveAfterSeconds()
    {
        yield return new WaitForSecondsRealtime(second);
        gameObject.SetActive(false);
    }
}

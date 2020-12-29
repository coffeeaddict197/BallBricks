using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BallTest : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.D))
        {
            LevelManager.Instance.currentLevel.DownLine();
            Debug.Log(LevelManager.Instance.currentLevel.step);
        }
    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        var check = collision.gameObject.GetComponent<ICollisionWithBall>();
        if(check!=null)
        {
            check.Collided();
        }
    }
}

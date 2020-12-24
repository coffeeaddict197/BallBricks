using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// test only
public interface ICollideWithCube
{
    void Collide();
}

public class BallScript : MonoBehaviour, ICollideWithCube
{
    [Header("Component")]
    [SerializeField] Rigidbody2D rigid;

    [Header("Flag")]
    [SerializeField] bool isMoving;

    [Header("Moving control")]
    [SerializeField] Vector2 direction;
    [SerializeField] float speed;

    // Start is called before the first frame update
    void Start()
    {
        rigid = GetComponent<Rigidbody2D>();
        speed = BallLauncher.Instance.Speed;
        BallLauncher.Instance.e_OnSpeedChange += ChangeSpeed;
    }

    // Update is called once per frame
    void Update()
    {
        if (isMoving)
        {
            rigid.MovePosition(new Vector2(
                transform.position.x + direction.x * speed * Time.deltaTime,
                transform.position.y + direction.y * speed * Time.deltaTime)
            );
        }
    }

    public void Fire(Vector2 dir)
    {
        isMoving = true;
        direction = dir;
    }

    public void ChangeSpeed(float spd) => speed = spd;

    public void Stop()
    {

    }

    public void Collide()
    {

    }
}

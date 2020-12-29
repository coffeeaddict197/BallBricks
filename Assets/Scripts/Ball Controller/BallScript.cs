using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BallScript : MonoBehaviour, ICollideWithCube
{
    [Header("Component")]
    [SerializeField] Rigidbody2D rigid;

    [Header("Flag")]
    [SerializeField] bool isMoving;

    [Header("Moving control")]
    [SerializeField] Vector2 direction;
    [SerializeField] float speed;

    [Header("Collide manage")]
    [SerializeField] Vector2 collidePos;
    [SerializeField] GameObject collideObject;
    [SerializeField] CollideChecker collideChecker;

    // Start is called before the first frame update
    void Start()
    {
        rigid = GetComponent<Rigidbody2D>();
        collideChecker = GetComponent<CollideChecker>();

        speed = BallLauncher.Instance.Speed;
        BallLauncher.Instance.e_OnSpeedChange += ChangeSpeed;
        BallLauncher.Instance.e_OnReset += Reset;
    }

    void FixedUpdate()
    {
        if (isMoving)
        {
            if (rigid.velocity == Vector2.zero) rigid.velocity = direction * speed;
            else if (transform.position.y < BallLauncher.Instance.basePos.y - BallLauncher.Instance.basePosOffset) Stop();
        }
    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        collidePos = collision.GetContact(0).point;
        collideObject = collision.collider.gameObject;

        transform.position = new Vector2(transform.position.x - direction.x / 10, transform.position.y - direction.y / 10);
        Collide();
    }

    public void Fire(Vector2 dir)
    {
        isMoving = true;
        direction = dir;
    }

    public void ChangeSpeed(float spd) => speed = spd;

    public void Stop()
    {
        BallLauncher.Instance.ReturnedBallsCounter++;
        rigid.velocity = Vector2.zero;
        isMoving = false;
    }

    public void Reset()
    {
        transform.position = BallLauncher.Instance.basePos;
        isMoving = false;
    }

    public void Collide()
    {
        CollideDirection collideDirection = collideChecker.GetCollideDirection(collidePos, collideObject, direction);
        collideChecker.ChangeDirection(collideDirection, ref direction);
        transform.position = new Vector2(transform.position.x + direction.x / 10, transform.position.y + direction.y / 10);

        rigid.velocity = direction * speed;
    }
}

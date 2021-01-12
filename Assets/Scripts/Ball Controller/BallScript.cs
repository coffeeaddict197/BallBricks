using UnityEngine;
using DG.Tweening;

public class BallScript : MonoBehaviour
{
    [Header("Component")]
    [SerializeField] Rigidbody2D rigid;
    [SerializeField] Collider2D col;

    [Header("Flag")]
    [SerializeField] bool isMoving;

    [Header("Moving control")]
    [SerializeField] Vector2 direction;
    [SerializeField] float speed;
    [SerializeField] Vector3 randomRotateAngle;
    [SerializeField] float rotateDuration;

    [SerializeField] Vector3 baseRotate = Vector3.zero;

    [Header("Collide manage")]
    [SerializeField] Vector2 collidePos;
    [SerializeField] GameObject collideObject;

    // Start is called before the first frame update
    void Start()
    {
        rigid = GetComponent<Rigidbody2D>();
        col = GetComponent<Collider2D>();

        speed = BallLauncher.Instance.Speed;
        BallLauncher.Instance.e_OnSpeedChange += ChangeSpeed;
        BallLauncher.Instance.e_OnRetrieveAll += Retrieve;
        BallLauncher.Instance.e_OnReset += Reset;
    }

    void FixedUpdate()
    {
        if (isMoving)
        {
            if (rigid.velocity == Vector2.zero)
            {
                rigid.velocity = direction * speed;
                RandomRotate();
            }
            else if (transform.position.y < BallLauncher.Instance.BasePos.y - BallLauncher.Instance.basePosOffset) Stop();
        }
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        var check = collision.GetComponent<ICollisionWithBall>();
        if (check != null)
        {
            check.Collided();
            RandomRotate();
        }
    }

    private void RandomRotate()
    {
        transform.DOKill();
        randomRotateAngle = new Vector3(0, 0, Random.Range(-180, 180));
        transform.DORotate(randomRotateAngle, rotateDuration, RotateMode.Fast);
    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        Vector2 inDirection = rigid.velocity;
        Vector2 inNormal = collision.contacts[0].normal;
        Vector2 newVelocity = Vector2.Reflect(inDirection, inNormal);
        transform.position = new Vector2(transform.position.x - direction.x / 10, transform.position.y - direction.y / 10);
        rigid.velocity = newVelocity;

        var check = collision.collider.GetComponent<ICollisionWithBall>();
        if (check != null)
        {
            check.Collided();
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
        if (!BallLauncher.Instance.isBasePosChanged)
        {
            BallLauncher.Instance.isBasePosChanged = true;
            BallLauncher.Instance.newBasePos = new Vector2(transform.position.x, BallLauncher.Instance.BasePos.y);
        }

        BallLauncher.Instance.ReturnedBallsCounter++;
        rigid.velocity = Vector2.zero;
        transform.position = new Vector2(transform.position.x, BallLauncher.Instance.BasePos.y);
        isMoving = false;
    }

    public void Retrieve()
    {
        if (isMoving) isMoving = false; else return;
        col.enabled = false;
        rigid.velocity = Vector2.zero;

        transform.DOKill();
        transform.DOMoveY(BallLauncher.Instance.BasePos.y - BallLauncher.Instance.basePosOffset, BallLauncher.Instance.moveTime).OnComplete(Stop);
    }

    public void Reset()
    {
        col.enabled = true;
        transform.DOKill();
        transform.DOMove(BallLauncher.Instance.BasePos, BallLauncher.Instance.moveTime);
        rigid.velocity = Vector2.zero;
        isMoving = false;

        transform.rotation = Quaternion.Euler(baseRotate);
    }


}

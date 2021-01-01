using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using DG.Tweening;
public class NodePiece : MonoBehaviour , ICollisionWithBall
{

    [Header("Node Properties")]
    [SerializeField] TextMeshProUGUI _textPoint;
    [SerializeField] int _point;
    protected SpriteRenderer sprite;
    private Vector3 _originPos;
    public int Point
    {
        get => _point;
        set
        {
            int absVal = Mathf.Abs(value);
            _point = absVal;
            _textPoint.text = Mathf.Abs(_point).ToString();
            CheckToChangeColor(Mathf.Abs(_point));
        }
    }

    public void Awake()
    {
        sprite = GetComponent<SpriteRenderer>();
        Point = _point;
    }

    private void CheckToChangeColor(int point)
    {
        if(point >= 10 && point<20)
        {
            sprite.color = BrickColor.c_Around10;
        }
        else if(point<=20)
        {
            sprite.color = BrickColor.c_Around20;
        }
        else if(point <= 30)
        {
            sprite.color = BrickColor.c_Around30;
        }
        else if(point <= 40)
        {
            sprite.color = BrickColor.c_Around40;
        }
        else if(point <= 50)
        {
            sprite.color = BrickColor.c_Around50;
        }
        else if(point <= 60)
        {
            sprite.color = BrickColor.c_Around60;
        }
        else if(point <= 70)
        {
            sprite.color = BrickColor.c_Around70;
        }
        else if (point <= 80)
        {
            sprite.color = BrickColor.c_Around80;
        }
        else
        {
            sprite.color = BrickColor.c_Default;
        }

    }

   

    public void DownLine()
    {
        Vector3 newPos = new Vector3(transform.position.x, transform.position.y - transform.localScale.y , 0f);
        transform.DOMove(newPos, 0.3f).SetUpdate(false).SetEase(Ease.OutBack);
    }


    public void SetLocalScale(Vector3 localScale)
    {
        transform.localScale = localScale;
    }
    public void SetPosion(Vector3 pos)
    {
        _originPos = pos;
        transform.position = new Vector3(_originPos.x, transform.position.y + 10f);
        transform.DOKill();
        transform.DOMove(_originPos, 0.5f).SetEase(Ease.OutBack);
    }

    public virtual void Collided()
    {
        Point--;
        if (Point == 0)
        {
            LevelManager.Instance.currentLevel.countBlock--;
            SpawnBreaker();
            gameObject.SetActive(false);
        }
    }

    void SpawnBreaker()
    {
        GameObject breaker = ObjectPool.Instance.Spawn(MyTags.BREAKER);
        breaker.transform.position = transform.position;
    }

}

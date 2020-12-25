using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
public class NodePiece : MonoBehaviour , collisionWithBall
{
    [SerializeField] TextMeshProUGUI _textPoint;
    [SerializeField] int _point;
    protected SpriteRenderer sprite;

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
        if(point>=20 && point<=35)
        {
            sprite.color = BrickColor.c_Around20;
        }
        else if(point <= 50)
        {
            sprite.color = BrickColor.c_Around35;
        }
        else if(point <= 60)
        {
            sprite.color = BrickColor.c_Around50;
        }
        else if(point <= 70)
        {
            sprite.color = BrickColor.c_Around60;
        }
        else if(point <= 80)
        {
            sprite.color = BrickColor.c_Around70;
        }
        else if (point <= 90)
        {
            sprite.color = BrickColor.c_Around80;
        }
    }

    public void Collided()
    {
        Point--;
        if(Point==0)
        {
            gameObject.SetActive(false);
        }
    }
}

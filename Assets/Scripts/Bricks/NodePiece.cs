using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
public class NodePiece : MonoBehaviour
{
    [SerializeField] TextMeshProUGUI _textPoint;
    [SerializeField] int _point;

    public int Point
    {
        get => _point;
        set
        {
            _point = value;
            _textPoint.text = _point.ToString();
        }
    }

    private void Awake()
    {
        Point = _point;
    }
}

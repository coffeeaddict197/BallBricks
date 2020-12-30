using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DotScript : MonoBehaviour
{
    [SerializeField] Vector2 _basePos;
    public Vector2 BasePos
    {
        get { return _basePos; }
        set { 
            _basePos = value;
            transform.position = _basePos;
        }
    }

    private void Start()
    {
        BasePos = BallLauncher.Instance.BasePos;
        BallLauncher.Instance.e_OnBasePosChange += ChangeBasePos;
    }

    public void Reset()
    {
        gameObject.transform.position = BasePos;
        gameObject.SetActive(false);
    }

    public void ChangeBasePos(Vector2 pos) => BasePos = pos;
}

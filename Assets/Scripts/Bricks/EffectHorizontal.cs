using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EffectHorizontal : NodePiece
{
#pragma warning disable
    [SerializeField] LayerMask layer;
    bool isTick;
    new void Awake()
    {
        isTick = false;
    }

    private void OnEnable()
    {
        isTick = false;
    }

    public override void Collided()
    {
        if (!isTick)
        {
            isTick = true;
            LevelManager.Instance.currentLevel.tickNode.Add(this);
        }

        ObjectPool.Instance.Spawn(MyTags.HorizontalLine , transform.position);

        //RIGHT
        RaycastHit2D[] hits = Physics2D.RaycastAll(transform.position, Vector2.right, 50f, layer);
        ImpactToHits(hits);
        //LEFT
        hits = Physics2D.RaycastAll(transform.position, Vector2.left, 50f, layer);
        ImpactToHits(hits);
    }


    void ImpactToHits(RaycastHit2D[] hits)
    {
        foreach (RaycastHit2D hit in hits)
        {
            var check = hit.transform.gameObject.GetComponent<NodePiece>();
            if (check != null)
            {
                check.Collided();
            }
        }
    }


}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
public class EffectDoScale : MonoBehaviour
{
    // Start is called before the first frame update
    SpriteRenderer sprite;
    private void Awake()
    {
        sprite = GetComponent<SpriteRenderer>();
    }
    private void OnEnable()
    {
        transform.DOKill();
        transform.localScale = MapGenerator.Instance.commandScale;
        sprite.DOFade(1, 0);

        transform.DOScale(MapGenerator.Instance.commandScale * 1.2f , 0.1f).SetEase(Ease.Linear).OnComplete( ()=> {
            sprite.DOFade(0, 0.1f).OnComplete(()=> { this.gameObject.SetActive(false); });
        } );
    }


}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "Default Ball", menuName ="ShopItem/Ball")]
public class ShopItem : ScriptableObject
{
    public Sprite mainImg;

    public string ballName = "Ball";

    public float price = 0;

    public bool isPurchased = false;
    public bool isFree = false;
    public bool inUse = false;
}

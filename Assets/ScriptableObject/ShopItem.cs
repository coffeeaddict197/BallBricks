using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "Ball", menuName ="ShopItem")]
public class ShopItem : ScriptableObject
{
    public Sprite mainImg;

    public string ballName;

    public float price;

    public bool isPurchased = false;
    public bool isFree = false;
    public bool inUse = false;
}

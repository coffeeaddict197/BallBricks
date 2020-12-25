using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelManager : MonoSingleton<LevelManager>
{
    //Convention: 
    /*
     .0 : square
     .1 : ◸
     .2 : ◹
     .3 : ◺
     .4 : ⊿
      0 : blank
      -1 : Inscre ball number;
     */


    public Level[] allLevel;

    private new void Awake()
    {
        allLevel = GetComponents<Level>();
    }
}

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

    EFFECT:
    .5 : Horizontal
    .6 : Verticle
    .7 : 2d
     */

    [Header("Level managerment")]
    public Level[] allLevel;
    public Level currentLevel;

    [Header("Matrix Setup")]
    public int withMatrix;



    private new void Awake()
    {
        currentLevel = null;
        allLevel = GetComponents<Level>();
    }


    public Level LoadLevel(int level)
    {
        for(int i = 0; i< allLevel.Length;  i++)
        {
            if(allLevel[i].level==level)
            {
                currentLevel = allLevel[i];
                return allLevel[i];
            }
        }

        return null;
    }
}

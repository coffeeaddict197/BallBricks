using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class Preallocation
{
    public GameObject gameObject;
    public int count;
    public bool expandable;
    public int firstIndex;
}

public class ObjectPool : MonoSingleton<ObjectPool>
{
    public List<Preallocation> preAllocations;

    [SerializeField]
    List<GameObject> pooledGobjects;

    protected override void Awake()
    {
        base.Awake();

        pooledGobjects = new List<GameObject>();

        int currentIndex = 0;
        foreach (Preallocation item in preAllocations)
        {
            item.firstIndex = currentIndex;
            for (int i = currentIndex; i < currentIndex + item.count; ++i)
            {
                pooledGobjects.Add(CreateGobject(item.gameObject));
            }
            currentIndex += item.count;
        }
    }

    public GameObject Spawn(string tag)
    {
        foreach (var item in preAllocations)
        {
            if (item.gameObject.CompareTag(tag))
            {
                for (int i = item.firstIndex; i < item.firstIndex + item.count; ++i)
                {
                    if (!pooledGobjects[i].activeSelf)
                    {
                        return pooledGobjects[i];
                    }
                }
            }
        }

        for (int i = 0; i < preAllocations.Count; ++i)
        {
            if (pooledGobjects[i].gameObject.tag.Equals(tag))
                if (preAllocations[i].expandable)
                {
                    GameObject obj = CreateGobject(preAllocations[i].gameObject);
                    pooledGobjects.Add(obj);
                    return obj;
                }
        }
        return null;
    }

    GameObject CreateGobject(GameObject item)
    {
        GameObject gobject = Instantiate(item, transform);
        gobject.SetActive(false);
        return gobject;
    }

    public void Reset()
    {
        for (int i = 0; i < pooledGobjects.Count; i++)
        {
            pooledGobjects[i].SetActive(false);
        }
    }
}
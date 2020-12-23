using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(MapGenerator))]
public class CustomArrayInt : Editor
{
    int firstDimensionSize;
    int secondDimensionSize;
    string confirmation;
    bool editMode;

    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();
        MapGenerator mapGenerator = (MapGenerator)target;

        if (CanCreateNewArray()) CreateNewArray(mapGenerator);

        SetupArray(mapGenerator);
    }

    bool CanCreateNewArray()
    {
        EditorGUILayout.BeginHorizontal();
        if (GUILayout.Button("Create New Array")) editMode = true;
        if (GUILayout.Button("Cancel")) editMode = false;
        EditorGUILayout.EndHorizontal();

        return editMode;
    }

    void CreateNewArray(MapGenerator someClass)
    {
        GetDimensions();
        if (ConfirmedCanCreate()) CreateArray(someClass);
    }

    void GetDimensions()
    {
        firstDimensionSize = EditorGUILayout.IntField("First Dimension Size", firstDimensionSize);
        secondDimensionSize = EditorGUILayout.IntField("Second Dimension Size", secondDimensionSize);
    }

    bool ConfirmedCanCreate()
    {
        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("Type YES and press Create to create new array. This will clear your old array!!", EditorStyles.wordWrappedLabel);
        confirmation = EditorGUILayout.TextField(confirmation);
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        bool canCreate = (GUILayout.Button("Create New Multidimensional Array") && confirmation == "YES");
        EditorGUILayout.EndHorizontal();

        if (canCreate)
        {
            confirmation = "";
            editMode = false;
            return true;
        }
        return false;
    }

    void CreateArray(MapGenerator someClass)
    {
        someClass.mArray = new ArrayInt[firstDimensionSize];
        for (int i = 0; i < firstDimensionSize; i++)
        {
            someClass.mArray[i] = new ArrayInt(secondDimensionSize);
        }
    }

    void SetupArray(MapGenerator someClass)
    {
        if (someClass.mArray != null && someClass.mArray.Length > 0)
        {
            for (int i = 0; i < someClass.mArray.Length; i++)
            {
                EditorGUILayout.BeginHorizontal();

                for (int j = 0; j < someClass.mArray[i].Length; j++)
                {
                    someClass.mArray[i][j] = EditorGUILayout.IntField(someClass.mArray[i][j], GUILayout.Width(30));
                }

                EditorGUILayout.EndHorizontal();
            }
        }
    }
}

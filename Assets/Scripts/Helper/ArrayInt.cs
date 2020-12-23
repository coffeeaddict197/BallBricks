using System;

public class Array<T>
{
    public T[] values;

    public Array(int size)
    {
        values = new T[size];
    }

    public int Length { get { return values.Length; } }

    public T this[int index]
    {
        get { return values[index]; }
        set { values[index] = value; }
    }
}

[Serializable]
public class ArrayInt : Array<int>
{
    public ArrayInt(int size) : base(size) { }
}
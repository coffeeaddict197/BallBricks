using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;
using System.Text;

public enum CollideDirection
{
    None = 0,
    Top,
    Left,
    Right,
    Bottom
}

public class CollideChecker : MonoBehaviour
{
    public const string BRICK_LAYER = "Default";

    private static Camera mainCamera;
    public static float rayLength = 10f;

    private void Start()
    {
        mainCamera = Camera.main;
    }

    public bool IsWallCollided(Vector2 pos)
    {
        Vector2 screenPos = mainCamera.WorldToViewportPoint(pos);
        return (screenPos.x > 1 || screenPos.x < 0 || screenPos.y > 1 || screenPos.y < 0);
    }

    public void GetCollideInfo(Vector2 origin, Vector2 direction, ref Vector2 collidePos, ref GameObject collideObject)
    {
        RaycastHit2D hit = Physics2D.Raycast(origin, direction, rayLength, LayerMask.GetMask(BRICK_LAYER));
        if (hit.collider != null)
        {
            collidePos = hit.point;
            collideObject = hit.collider.gameObject;
        }
        else
        {
            collideObject = null;
        }
    }

    public CollideDirection GetCollideDirection(Vector2 collidePos, GameObject collideObject, Vector2 dir)
    {
        if (collideObject == null) return CollideDirection.None;

        CollideDirection collideDirection = CollideDirection.None;
        Bounds bounds = collideObject.GetComponent<BoxCollider2D>().bounds;

        int rightBorder = GetRoundedValue(bounds.center.x + bounds.extents.x);
        int leftBorder = GetRoundedValue(bounds.center.x - bounds.extents.x);
        int topBorder = GetRoundedValue(bounds.center.y + bounds.extents.y);
        int bottomBorder = GetRoundedValue(bounds.center.y - bounds.extents.y);
        Vector2 collidePos_rounded = new Vector2(GetRoundedValue(collidePos.x), GetRoundedValue(collidePos.y));

        if ((collidePos_rounded.y >= topBorder) && (collidePos_rounded.x <= rightBorder) && (collidePos_rounded.x >= leftBorder) && (dir.y < 0))
        {
            collideDirection = CollideDirection.Top;
        }
        else
        if ((collidePos_rounded.y <= bottomBorder) && (collidePos_rounded.x <= rightBorder) && (collidePos_rounded.x >= leftBorder) && (dir.y > 0))
        {
            collideDirection = CollideDirection.Bottom;
        }
        else
        if ((collidePos_rounded.x >= rightBorder) && (collidePos_rounded.y <= topBorder) && (collidePos_rounded.y >= bottomBorder) && (dir.x < 0))
        {
            collideDirection = CollideDirection.Right;
        }
        else
        if ((collidePos_rounded.x <= leftBorder) && (collidePos_rounded.y <= topBorder) && (collidePos_rounded.y >= bottomBorder) && (dir.x > 0))
        {
            collideDirection = CollideDirection.Left;
        }

        return collideDirection;
    }

    public void ChangeDirection(CollideDirection collideDirection, ref Vector2 direction)
    {
        switch (collideDirection)
        {
            case CollideDirection.Top:
            case CollideDirection.Bottom:
                {
                    direction.y *= -1;
                    break;
                }
            case CollideDirection.Left:
            case CollideDirection.Right:
                {
                    direction.x *= -1;
                    break;
                }
            default:
                break;
        }
    }

    public int GetRoundedValue(float value)
    {
        return (int)(Math.Round(value, 2) * 100);
    }
}

using UnityEngine;

[CreateAssetMenu(fileName = "UI element", menuName = "UI/New UI")]
public class UI_ScriptableObject : ScriptableObject
{
    [Header("UI gameobject")]
    [SerializeField] private GameObject _uiAnimator;

    public GameObject _uianimator => _uiAnimator;
}

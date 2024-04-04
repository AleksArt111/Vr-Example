using UnityEngine;


[CreateAssetMenu(fileName = "NewItem", menuName = "Items/NewItem")]
public class ItemScriptableObject : ScriptableObject
{
    public int id;
    public string _itemTitle;
    [TextArea(1, 100)]
    public string _itemDescription;

    public Sprite _itemIcon;
}

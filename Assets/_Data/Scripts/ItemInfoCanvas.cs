using UnityEngine;
using TMPro;

public class ItemInfoCanvas : MonoBehaviour
{
    [SerializeField] private TMP_Text _descriptionText;
    [SerializeField] private TMP_Text _titleText;
    [SerializeField] private GameObject _itemInfoContainer;

    [HideInInspector] public ItemScriptableObject _currentItem;


    public void OpenUI()
    {
        _itemInfoContainer.SetActive(true);

        UpdateItemInfoUI();
    }

    private void CloseUI()
    {
        _itemInfoContainer.SetActive(false);
    }

    private void UpdateItemInfoUI()
    {
        if (_currentItem != null)
        {
            _titleText.text = _currentItem._itemTitle;
            _descriptionText.text = _currentItem._itemDescription;
        }
        else
        {
            Debug.LogError($"Ошибка: переменная _currentItem пуста.");
        }
    }

    private void ToggleUI()
    {
        if (_itemInfoContainer.activeSelf) // Close
        {
            CloseUI();
        }
        else
        {
            OpenUI();
        }
    }
}

using System.Collections.Generic;
using UnityEngine;

public class ItemInfoTrigger : MonoBehaviour
{
    public ItemScriptableObject _currentItem;

    [SerializeField] private ItemInfoCanvas _canvas;
    [SerializeField] private List<ItemScriptableObject> _collectedItems;
    [SerializeField] private List<ItemScriptableObject> _totalItems;

    [SerializeField] private GameObject _nextQuestGameObject;
    [SerializeField] private GameObject _oldQuestObject;


    private void OnTriggerEnter(Collider other)
    {
        if (other.GetComponent<Item>())
        {
            _currentItem = other.GetComponent<Item>()._itemScriptableObject;
            _canvas._currentItem = _currentItem;

            if (!_collectedItems.Contains(_currentItem))
            {
                _collectedItems.Add(_currentItem);
            }

            if (_collectedItems.Count == _totalItems.Count)
            {
                _nextQuestGameObject.SetActive(true);
                _oldQuestObject.SetActive(false);
            }

            _canvas.OpenUI();
        }
    }
}

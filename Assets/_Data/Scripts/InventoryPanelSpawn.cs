using UnityEngine;

public class InventoryPanelSpawn : MonoBehaviour
{ 
    [SerializeField] private Transform _joystickPosition;
    [SerializeField] private GameObject _uiPrefab;
    private Material _uiMaterial;
    

    private bool _swordSpawn = false;


    private void Update()
    {
        if (Input.GetButtonDown("XRI_Left_GripButton"))
            SpawnSword();
    }
    private void SpawnSword()
    {
        if (_swordSpawn == false)
        {
            _swordSpawn = true;
            Instantiate(_uiPrefab, _joystickPosition);
            _uiMaterial = _uiPrefab.GetComponent<Material>();
            _uiMaterial.SetFloat("_DissolvePosition", 5);
        }
    }
}
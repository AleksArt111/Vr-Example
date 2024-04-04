using Unity.XR.CoreUtils;
using UnityEngine;

public class LookAtPlayer : MonoBehaviour
{
    [SerializeField] private Transform _HealthBar;

    private XROrigin _playerPos;

    private bool _playerInTrigger = false;

    private void OnTriggerStay(Collider other)
    {
        if (other.GetComponent<XROrigin>())
        {
            _playerPos = FindObjectOfType<XROrigin>();
            _playerInTrigger = true;
        }

        else if(other.gameObject == null) 
            return;
    }

    private void OnTriggerExit(Collider other)
    {
        _playerPos = null; 
    }

    private void Update()
    {
        if(_playerInTrigger == true)
            _HealthBar.transform.rotation = Quaternion.LookRotation(transform.position - _playerPos.transform.position);
    }
}


using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CannonTrigger : MonoBehaviour
{

    [SerializeField] private Animator _cannon;
    [SerializeField] private AudioSource _cannonShot;

    bool _isShoot = false;
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player") && _isShoot == false)
        {
            _cannon.Play("cannonFire");
            _cannonShot.Play();
            _isShoot = true;
        }
           
    }
}


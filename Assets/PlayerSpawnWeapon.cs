using UnityEngine;
using UnityEngine.InputSystem;

[RequireComponent (typeof(PlayerInput))]
public class PlayerSpawnWeapon : MonoBehaviour
{

    [SerializeField] private Transform _target;

    [SerializeField] private SwordScriptableObject _sword;

    public void SpawnSword()
    {
        Instantiate(_sword, _target.position, Quaternion.identity);

        Debug.Log("Complete");
    }
    
}

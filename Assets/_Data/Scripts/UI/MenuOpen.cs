using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.XR.Content.Interaction;

public class MenuOpen : MonoBehaviour
{

    [SerializeField] private Transform _SphereTouch;

    public InputActionProperty gripAnimationAction;

    private Vector3 vector3;

    private bool IsGripped = false;
    private float positionLeftHand;


    private void Awake()
    {
        vector3 = _SphereTouch.position;
        positionLeftHand = vector3.y;
    }

    // Update is called once per frame
    void Update()
    {
        if (positionLeftHand < vector3.y)
        {
            Debug.Log("Is complete");
        }
        
    }
}

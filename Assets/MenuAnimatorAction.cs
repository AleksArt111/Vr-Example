using UnityEngine;

public class MenuAnimatorAction : MonoBehaviour
{
    [SerializeField] private Animator _menuAnimator;

    private bool IsActive;

    private void Awake()
    {
        _menuAnimator.SetFloat("speed", 1);
        IsActive = false;
    }

    public void IconCharacterPress()
    {
        if (IsActive == false)
        {
            _menuAnimator.SetFloat("speed", 1);
            _menuAnimator.Play("OpenInventory");
            IsActive = true;   
        }

        else if (IsActive == true)
        {
            _menuAnimator.SetFloat("speed", -1);
            _menuAnimator.Play("OpenInventory");
            IsActive = false;
        }
    }
}

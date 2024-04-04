using UnityEngine;
using UnityEngine.UI;

public class HealthPlayer : MonoBehaviour
{
    [SerializeField] private Slider _healthBarSlider;

    [SerializeField] private int _valueHealth;
    
    public int valueHealth => _valueHealth;

    private void Awake()
    {
        _healthBarSlider.value = _valueHealth;
        _healthBarSlider.maxValue = _valueHealth;
    }

    private void Update()
    {
        _healthBarSlider.value = _valueHealth;
    }

    public void DamageToPlayer(int  damage)
    {
        _valueHealth -= damage;
    }
}

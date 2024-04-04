using System.Collections;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class EnemyStats : MonoBehaviour
{
    [SerializeField] private EnemyScriptableObject _enemyStat;
    [SerializeField] private TextMeshProUGUI _enemyName;
    [SerializeField] private Slider _enemyHealthIcon;
    [SerializeField] private Image _healthEnemyColor;

    public int _enemyHealth;
    private bool isComplete = false; 

    private void Awake()
    {
        _enemyName.text = _enemyStat._enemyname;

        _enemyHealth = _enemyStat._enemyhealth;

        _enemyHealthIcon.value = _enemyHealth;
    }

    private void Update()
    {
        _enemyHealthIcon.value = _enemyHealth;

        if (_enemyHealth == 0 && isComplete == false)
        {
            StartCoroutine(Respawn());
            isComplete = true;
        }
    }
    public void TakeDamage()
    {
        switch(_enemyHealth)
        {
            case >= 70:
                _healthEnemyColor.color = Color.green;
                break;
            case  >= 30:
                _healthEnemyColor.color = Color.yellow;
                break;
            case < 30:
                _healthEnemyColor.color = Color.red;
                break;
        }
    }
    IEnumerator Respawn()
    {
        yield return new WaitForSeconds(4);
        _enemyHealth = _enemyStat._enemyhealth;
        _healthEnemyColor.color = Color.green;
        isComplete = false;
        yield break;
    }
}

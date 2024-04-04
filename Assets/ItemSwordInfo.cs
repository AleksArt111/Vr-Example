using System.Collections;
using TMPro;
using Unity.VisualScripting;
using UnityEngine;

public class ItemSwordInfo : MonoBehaviour
{
    [SerializeField] private SwordScriptableObject[] _weapon;
    [SerializeField] private EnemyStats _enemyHealth;

    [SerializeField] private GameObject _hitTextGameObject;
    [SerializeField] private TextMeshProUGUI _hitDamage;
    [SerializeField] private AudioSource _attackSFX;

    private bool isComplete = false;
    private bool IsAttacked = false;

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Sword") && IsAttacked == false)
        {
            if(isComplete == false)
            {
                _hitDamage.text = _weapon[0]._swordDamage.ToString();
                _attackSFX.Play();
                _enemyHealth.TakeDamage();
                _enemyHealth._enemyHealth -= _weapon[0]._swordDamage;
                IsAttacked = true;
                StartCoroutine(ColdownAttack());
                _hitTextGameObject.SetActive(true);
                isComplete = true;
            }
        }

        if (other.gameObject.CompareTag("Hands") && IsAttacked == false)
        {
            if (isComplete == false)
            {
                _hitDamage.text = _weapon[1]._swordDamage.ToString();
                _attackSFX.Play(); 
                _enemyHealth.TakeDamage();
                _enemyHealth._enemyHealth -= _weapon[1]._swordDamage;
                IsAttacked = true;
                StartCoroutine(ColdownAttack());
                _hitTextGameObject.SetActive(true);
                isComplete = true;
            }
        }

        if (other.gameObject.CompareTag("Crystal_Sword") && IsAttacked == false)
        {
            if (isComplete == false)
            {
                _hitDamage.text = _weapon[2]._swordDamage.ToString();
                _attackSFX.Play();
                _enemyHealth.TakeDamage();
                _enemyHealth._enemyHealth -= _weapon[2]._swordDamage;
                IsAttacked = true;
                StartCoroutine(ColdownAttack());
                _hitTextGameObject.SetActive(true);
                isComplete = true;
            }

        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.CompareTag("Sword"))
        {
            StartCoroutine(DisableDamageUI());
        }

        if (other.gameObject.CompareTag("Hands"))
        {
            StartCoroutine(DisableDamageUI());
        }

        if (other.gameObject.CompareTag("Crystal_Sword"))
        {
            StartCoroutine(DisableDamageUI()); ;
        }

        isComplete = false;
    }

    IEnumerator DisableDamageUI()
    {
        yield return new WaitForSeconds(3);
        _hitTextGameObject.SetActive(false);
    }

    IEnumerator ColdownAttack()
    {
        yield return new WaitForSecondsRealtime(0.5f);
        IsAttacked = false;
    }
}

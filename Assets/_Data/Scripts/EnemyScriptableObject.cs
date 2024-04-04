using UnityEngine;

[CreateAssetMenu(fileName = "Enemy", menuName = "Enemies/New Enemy")]
public class EnemyScriptableObject : ScriptableObject
{
    [SerializeField] private string _enemyName;

    [SerializeField] private int _enemyHealth;

    public string _enemyname => this._enemyName;
    public int _enemyhealth => this._enemyHealth;

    
}

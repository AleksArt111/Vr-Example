using UnityEngine;

[CreateAssetMenu(fileName = "Sword", menuName = "Sword/New Sword")]
public class SwordScriptableObject : ScriptableObject
{
    [SerializeField] private string _swordName;
    [SerializeField] private string _swordDescription;
    [SerializeField] private AudioSource _swordSFX;

    public int _swordDamage;
    public string _swordname => this._swordName;
    public string _sworddescription => this._swordDescription;
    public int _sworddamage => this._swordDamage;
    public AudioSource _swordsfx => this._swordSFX;
}

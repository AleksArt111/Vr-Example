using System.Collections;
using UnityEngine;

public class AudioCannonShootScript : MonoBehaviour
{
    [SerializeField] private AudioSource _ñannonShotAudioSource;
    [SerializeField] private AudioClip[] _ñannonShotClips;


    private void Awake()
    {
        CannonSFX();
    }

    public void CannonSFX()
    {
        int i = Random.Range(0, _ñannonShotClips.Length);
        _ñannonShotAudioSource.PlayOneShot(_ñannonShotClips[i]);

        StartCoroutine("CannonSFXShoot");
    }

    IEnumerator CannonSFXShoot()
    {
        yield return new WaitForSeconds(5);

        CannonSFX();
    }
}

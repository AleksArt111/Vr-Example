using System.Collections;
using UnityEngine;

public class AudioCannonShootScript : MonoBehaviour
{
    [SerializeField] private AudioSource _�annonShotAudioSource;
    [SerializeField] private AudioClip[] _�annonShotClips;


    private void Awake()
    {
        CannonSFX();
    }

    public void CannonSFX()
    {
        int i = Random.Range(0, _�annonShotClips.Length);
        _�annonShotAudioSource.PlayOneShot(_�annonShotClips[i]);

        StartCoroutine("CannonSFXShoot");
    }

    IEnumerator CannonSFXShoot()
    {
        yield return new WaitForSeconds(5);

        CannonSFX();
    }
}

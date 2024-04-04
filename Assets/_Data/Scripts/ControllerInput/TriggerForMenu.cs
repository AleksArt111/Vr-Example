using System.Collections;
using Unity.XR.CoreUtils;
using UnityEngine;

public class TriggerForMenu : MonoBehaviour
{
    [SerializeField] private GameObject[] Menu;

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            Menu[0].GetComponent<Animator>().SetFloat("speed", -1);
            Menu[0].GetComponent<Animator>().Play("Start");
            StartCoroutine(DestroyMenu());
        }
    }

    IEnumerator DestroyMenu()
    {
        yield return new WaitForSecondsRealtime(1);
        Destroy(Menu[1]);
    }
}

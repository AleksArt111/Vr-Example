using System.Collections;
using UnityEngine;
using TMPro;
using System.Collections.Generic;

public class DialogueManager : MonoBehaviour
{
    [SerializeField] private TMP_Text _dialogueText;
    [SerializeField] GameObject _dialogueContainer;

    [SerializeField] private Dialogue[] _dialogues;

    [Range(0.1f, 2)]
    public float _punctuationTime;

    [Range(0.01f, 0.2f)]
    public float _charTime;

    private int _currentDialogueIndex = 0;
    public int _currentDialoguePart = 1;
    public int _maxParts = 2;


    public void NextDialogue()
    {
        StartCoroutine(NextDialogue_Co());

        UpdateUI();
    }

    public void NextPart()
    {
        if (_currentDialoguePart + 1 <= _maxParts)
        {
            _currentDialoguePart++;
        }
    }

    public void UpdateUI()
    {
        if (!_dialogueContainer.activeSelf)
        {
            _dialogueContainer.SetActive(true);
        }

        StartCoroutine(TextAnimation());
    }


    public void StartLocationDialogues(int location)
    {
        List<Dialogue> currentLocationDialogues = new List<Dialogue>();

        _currentDialoguePart = location;

        foreach (Dialogue _dialogue in _dialogues)
        {
            if (_dialogue._part == _currentDialoguePart)
            {
                currentLocationDialogues.Add(_dialogue);
            }
        }

        while (_currentDialogueIndex <= currentLocationDialogues.Count)
        {
            NextDialogue();
        }
    }

    private IEnumerator TextAnimation()
    {
        _dialogueText.text = "";

        foreach (Dialogue _dialogue in _dialogues)
        {
            if (_dialogue._part == _currentDialoguePart)
            {
                foreach (var character in _dialogue._text)
                {
                    _dialogueText.text += character;

                    if (character == '.'
                     || character == ','
                     || character == '!'
                     || character == '?')
                    {
                        yield return new WaitForSeconds(_punctuationTime);
                    }
                    else
                    {
                        yield return new WaitForSeconds(_charTime);
                    }
                }
            }
        }

        yield break;
    }

    private IEnumerator NextDialogue_Co()
    {
        if (_currentDialogueIndex + 1 <= _dialogues.Length)
        {
            yield return new WaitForSeconds(_dialogues[_currentDialogueIndex]._time);
            _currentDialogueIndex++;
        }

        yield break;
    }

    [System.Serializable]
    public class Dialogue
    {
        [TextArea(1, 100)]
        public string _text;
        public float _time;

        public int _part;
    }
}

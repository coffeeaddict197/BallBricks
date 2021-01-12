using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class OptionsHome : MonoBehaviour
{

    [SerializeField] Button sound;
    [SerializeField] Button music;
    [SerializeField] Button backHome;

    private void Awake()
    {
        AddButtonEvent();
    }

    private void OnEnable()
    {
        Initialize();
    }
    void AddButtonEvent()
    {
        sound.onClick.AddListener(SoundToggle);
        music.onClick.AddListener(MusicToggle);
        backHome.onClick.AddListener(Unactive);
    }

    void Initialize()
    {
        ChangeSprite();
    }

    void ChangeSprite()
    {
         if (SoundManager.onSound == 1) sound.transform.GetChild(0).GetComponent<Image>().sprite = Resources.Load<Sprite>("sprites/sound_unmute");
        else sound.transform.GetChild(0).GetComponent<Image>().sprite = Resources.Load<Sprite>("sprites/sound_mute") as Sprite;
        if (SoundManager.onMusic == 1) music.transform.GetChild(0).GetComponent<Image>().sprite = Resources.Load<Sprite>("sprites/music_unmute");
        else music.transform.GetChild(0).GetComponent<Image>().sprite = Resources.Load<Sprite>("sprites/music_mute");

    }
    void SoundToggle()
    {
        if (SoundManager.onSound == 1)
        {
            SoundManager.Instance.MuteSound();
            sound.transform.GetChild(0).GetComponent<Image>().sprite = Resources.Load<Sprite>("sprites/sound_mute");
        }
        else
        {
            SoundManager.Instance.UnmuteSound();
            sound.transform.GetChild(0).GetComponent<Image>().sprite = Resources.Load<Sprite>("sprites/sound_unmute") as Sprite;

        }
    }

    void MusicToggle()
    {
        if (SoundManager.onMusic == 1)
        {
            SoundManager.Instance.MuteMusic();
            music.transform.GetChild(0).GetComponent<Image>().sprite = Resources.Load<Sprite>("sprites/music_mute");

        }
        else
        {
            SoundManager.Instance.UnmuteMusic();
            music.transform.GetChild(0).GetComponent<Image>().sprite = Resources.Load<Sprite>("sprites/music_unmute");

        }
    }
    
    void Unactive()
    {
        gameObject.SetActive(false);
    }

}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.UI;
public class SoundManager : MonoSingleton<SoundManager>
{
    // Start is called before the first frame update
    public Sound[] soundLoops;
    public Sound[] soundFXs;

    public static int onSound = 1;
    public static int onMusic = 1;

    const string KEY_SOUND = "KEY_SOUND";
    const string KEY_MUSIC = "KEY_MUSIC";


    private new void Awake()
    {

        onSound = PlayerPrefs.GetInt(KEY_SOUND, 1);
        onMusic = PlayerPrefs.GetInt(KEY_MUSIC, 1);
        Initialize();

    }

    void Initialize()
    {
        foreach (Sound s in soundLoops)
        {
            s.source = gameObject.AddComponent<AudioSource>();
            s.source.clip = s.clip;
            s.source.volume = s.volume;
            s.source.loop = true;
        }

        foreach (Sound s in soundFXs)
        {
            s.source = gameObject.AddComponent<AudioSource>();
            s.source.clip = s.clip;
            s.source.volume = s.volume;
            s.source.loop = s.loop;
        }
    }


    public void PlayLoop(string name)
    {

        if (onMusic == 1)
        {
            Sound s = Array.Find(soundLoops, sound => sound.name == name);

            if (s == null)
            {
                Debug.LogWarning("Sound " + name + " not found ");
                return;
            }
            StartCoroutine(InscraseVolume(s));
            s.source.Play();
        }
    }


    public void Play(string name)
    {
        if (onSound == 1)
        {
            Sound s = Array.Find(soundFXs, sound => sound.name == name);

            if (s == null)
            {
                Debug.LogWarning("Sound " + name + " not found ");
                return;
            }
            StartCoroutine(InscraseVolume(s));
            s.source.Play();
        }
    }


    public void Stop(string name)
    {
        Sound s = Array.Find(soundFXs, sound => sound.name == name);


        if (s == null)
        {
            Debug.LogWarning("Sound " + name + " not found ");
            return;
        }

        s.source.Stop();
    }

    public void PlayOneShot(string name)
    {
        if (onSound == 1)
        {
            Sound s = Array.Find(soundFXs, sound => sound.name == name);


            if (s == null)
            {
                Debug.LogWarning("Sound " + name + " not found ");
                return;
            }

            s.source.PlayOneShot(s.source.clip);
        }
    }


    public void CheckToggleSound(bool on)
    {
        onSound = on == true ? 1 : 0;
        PlayerPrefs.SetInt(KEY_SOUND, onSound);
    }

    public void CheckToggleMusic(bool on)
    {
        onMusic = on == true ? 1 : 0;
        PlayerPrefs.SetInt(KEY_MUSIC, onMusic);
    }



    public void AwakeAllLoop()
    {
        if (onMusic == 1)
        {
            foreach (Sound s in soundLoops)
            {
                s.source.Play();
                StartCoroutine(InscraseVolume(s));
            }
        }

        if (onSound == 1)
        {
            foreach (Sound s in soundFXs)
            {
                if(s.loop)
                    s.source.Play();
                StartCoroutine(InscraseVolume(s));
            }
        }
    }

    public void StopAllLoop()
    {
        foreach (Sound s in soundLoops)
        {
            StartCoroutine(DecreaseVolume(s));
        }

        foreach (Sound s in soundFXs)
        {

            StartCoroutine(DecreaseVolume(s));
        }
    }






    IEnumerator InscraseVolume(Sound s)
    {
        AudioSource source = s.source;
        while (true)
        {
            if (source.volume < s.maxVolume)
            {
                source.volume += Time.deltaTime;
                yield return null;
            }
            else
            {
                yield break;
            }
        }
    }





    IEnumerator DecreaseVolume(Sound s)
    {
        AudioSource source = s.source;
        while (true)
        {
            if (source.volume > 0)
            {
                source.volume -= Time.unscaledDeltaTime * 2;
                yield return null;
            }
            else
            {
                yield break;
            }
        }
    }


}

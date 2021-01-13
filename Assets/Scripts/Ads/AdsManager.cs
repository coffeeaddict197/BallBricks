using GoogleMobileAds.Api;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AdsManager : MonoSingleton<AdsManager>
{
    const string REWARD_TYPE = "Reward";

    private RewardedAd setSkinAd;

    [Header("Flags")]
    [SerializeField] bool _isOpening;
    public bool IsOpening
    {
        get { return _isOpening; }
    }

    [SerializeField] bool _isEarnedReward;
    public bool IsEarnedReward
    {
        get { return _isEarnedReward; }
    }

    protected override void Awake()
    {
        base.Awake();
        CreateAndLoadRewardAds();
        ResetStatus();
    }

    private void CreateAndLoadRewardAds()
    {
        string adUnitId;

#if UNITY_EDITOR
        adUnitId = "ca-app-pub-3940256099942544/5224354917";
#elif UNITY_ANDROID
        adUnitId = "ca-app-pub-2136479507730706~3705606835";
#endif

        setSkinAd = new RewardedAd(adUnitId);
        // Create an empty ad request.
        AdRequest request = new AdRequest.Builder().Build();
        // Load the rewarded ad with the request.
        setSkinAd.LoadAd(request);

        setSkinAd.OnUserEarnedReward += RewardedAd_OnUserEarnedReward;
        setSkinAd.OnAdOpening += RewardedAd_OnAdOpening;
        setSkinAd.OnAdFailedToShow += RewardedAd_OnAdFailedToShow;
        setSkinAd.OnAdClosed += RewardedAd_OnAdClosed;
    }

    private void RewardedAd_OnAdFailedToShow(object sender, AdErrorEventArgs e)
    {
        ResetStatus();
    }

    private void RewardedAd_OnUserEarnedReward(object sender, Reward e)
    {
        string type = e.Type;
        if (type.Equals(REWARD_TYPE))
        {
            _isEarnedReward = true;
        }
        else
        {
            Debug.Log("Wrong reward type");
        }
    }

    private void RewardedAd_OnAdOpening(object sender, System.EventArgs e)
    {
        ResetStatus();
        _isOpening = true;
    }

    private void RewardedAd_OnAdClosed(object sender, System.EventArgs e)
    {
        _isOpening = false;
        CreateAndLoadRewardAds();
    }

    public void ShowRewardAd()
    {
        if (setSkinAd.IsLoaded())
        {
            setSkinAd.Show();
        }
    }

    public void ResetStatus()
    {
        _isOpening = false;
        _isEarnedReward = false;
    }
}

using GoogleMobileAds.Api;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AdsManager : MonoSingleton<AdsManager>
{
    const string REWARD_TYPE = "Reward";

    const string BANNER_AD_UNIT_ID_TEST = "ca-app-pub-3940256099942544/6300978111";
    const string REWARD_AD_UNIT_ID_TEST = "ca-app-pub-3940256099942544/5224354917";

    const string BANNER_AD_UNIT_ID = "ca-app-pub-2136479507730706/2794654305";
    const string REWARD_AD_UNIT_ID = "ca-app-pub-2136479507730706/8408915393";

    private RewardedAd rewardAd;
    private BannerView bannerView;

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
        RequestBanner();

        ResetStatus();
    }

    private void RequestBanner()
    {
        string adUnitId;

#if UNITY_EDITOR
        adUnitId = BANNER_AD_UNIT_ID_TEST;
#elif UNITY_ANDROID
        adUnitId = BANNER_AD_UNIT_ID;
#else
        adUnitId = "";
#endif

        if (string.IsNullOrEmpty(adUnitId))
        {
            Debug.Log("Unexpected platform");
            return;
        }

        // Create a 320x50 banner at the top of the screen.
        bannerView = new BannerView(adUnitId, AdSize.Banner, AdPosition.Bottom);
        // Create an empty ad request.
        AdRequest request = new AdRequest.Builder().Build();
        // Load the banner with the request.
        bannerView.LoadAd(request);
    }

    private void CreateAndLoadRewardAds()
    {
        string adUnitId;

#if UNITY_EDITOR
        adUnitId = REWARD_AD_UNIT_ID_TEST;
#elif UNITY_ANDROID
        adUnitId = REWARD_AD_UNIT_ID;
#else
        adUnitId = "";
#endif

        if (string.IsNullOrEmpty(adUnitId))
        {
            Debug.Log("Unexpected platform");
            return;
        }

        rewardAd = new RewardedAd(adUnitId);
        // Create an empty ad request.
        AdRequest request = new AdRequest.Builder().Build();
        // Load the rewarded ad with the request.
        rewardAd.LoadAd(request);

        rewardAd.OnUserEarnedReward += RewardedAd_OnUserEarnedReward;
        rewardAd.OnAdOpening += RewardedAd_OnAdOpening;
        rewardAd.OnAdFailedToShow += RewardedAd_OnAdFailedToShow;
        rewardAd.OnAdClosed += RewardedAd_OnAdClosed;
    }

    #region RewardAd handlers
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
    #endregion

    public void ShowRewardAd()
    {
        if (rewardAd.IsLoaded())
        {
            rewardAd.Show();
        }
    }

    public void ResetStatus()
    {
        _isOpening = false;
        _isEarnedReward = false;
    }
}

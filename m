Date: Fri, 9 Mar 2018 18:21:24 +0530
From: Himanshu Jha <morganfreeman6991@gmail.com>
Subject: Re: [PATCH] drivers: net: wireless: ath: ath9: dfs: remove VLA usage
Message-ID: <20180309125124.GA17968@himanshu-Vostro-3559>
References: <1520598613-3641-1-git-send-email-andreaschristofo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1520598613-3641-1-git-send-email-andreaschristofo@gmail.com>
To: Andreas Christoforou <andreaschristofo@gmail.com>
Cc: keescook@chromium.org, kernel-hardening@lists.openwall.com, QCA ath9k Development <ath9k-devel@qca.qualcomm.com>, Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 09, 2018 at 02:30:12PM +0200, Andreas Christoforou wrote:
> The kernel would like to have all stack VLA usage removed.
> 
> Signed-off-by: Andreas Christoforou <andreaschristofo@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/dfs.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
> index 6fee9a4..cfb0f84 100644
> --- a/drivers/net/wireless/ath/ath9k/dfs.c
> +++ b/drivers/net/wireless/ath/ath9k/dfs.c
> @@ -41,7 +41,6 @@ static const int BIN_DELTA_MAX		= 10;
>  
>  /* we need at least 3 deltas / 4 samples for a reliable chirp detection */
>  #define NUM_DIFFS 3
> -static const int FFT_NUM_SAMPLES	= (NUM_DIFFS + 1);

Are you sure it is correct ?
Look for other users of "FFT_NUM_SAMPLES".

>  /* Threshold for difference of delta peaks */
>  static const int MAX_DIFF		= 2;
> @@ -101,7 +100,7 @@ static bool ath9k_check_chirping(struct ath_softc *sc, u8 *data,
>  				 int datalen, bool is_ctl, bool is_ext)
>  {
>  	int i;
> -	int max_bin[FFT_NUM_SAMPLES];
> +	int max_bin[NUM_DIFFS + 1];
>  	struct ath_hw *ah = sc->sc_ah;
>  	struct ath_common *common = ath9k_hw_common(ah);
>  	int prev_delta;

Always compile test the driver before sending a patch.
Also, patch title seems incorrect *ath9k*

himanshu@himanshu-Vostro-3559:~/linux-next$ git log --oneline drivers/net/wireless/ath/ath9k/dfs.c
626ab67 ath9k: dfs: use swap macro in ath9k_check_chirping
50c8cd4 ath9k: remove cast to void pointer
8fc2b61 ath9k: DFS - add pulse chirp detection for FCC
....

-- 
Thanks
Himanshu Jha

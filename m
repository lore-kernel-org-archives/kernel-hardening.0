Subject: Re: [PATCH] drivers: net: wireless: ath: ath9: dfs: remove VLA usage
References: <1520598613-3641-1-git-send-email-andreaschristofo@gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AA464DE.90100@broadcom.com>
Date: Sun, 11 Mar 2018 00:06:06 +0100
MIME-Version: 1.0
In-Reply-To: <1520598613-3641-1-git-send-email-andreaschristofo@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andreas Christoforou <andreaschristofo@gmail.com>, keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com, QCA ath9k Development <ath9k-devel@qca.qualcomm.com>, Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 3/9/2018 1:30 PM, Andreas Christoforou wrote:
> The kernel would like to have all stack VLA usage removed.

I think there was a remark made earlier to give more explanation here. 
It should explain why we want "VLA on stack" removed.

> Signed-off-by: Andreas Christoforou <andreaschristofo@gmail.com>
> ---
>   drivers/net/wireless/ath/ath9k/dfs.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
> index 6fee9a4..cfb0f84 100644
> --- a/drivers/net/wireless/ath/ath9k/dfs.c
> +++ b/drivers/net/wireless/ath/ath9k/dfs.c
> @@ -41,7 +41,6 @@ static const int BIN_DELTA_MAX		= 10;
>
>   /* we need at least 3 deltas / 4 samples for a reliable chirp detection */
>   #define NUM_DIFFS 3
> -static const int FFT_NUM_SAMPLES	= (NUM_DIFFS + 1);
>
>   /* Threshold for difference of delta peaks */
>   static const int MAX_DIFF		= 2;
> @@ -101,7 +100,7 @@ static bool ath9k_check_chirping(struct ath_softc *sc, u8 *data,
>   				 int datalen, bool is_ctl, bool is_ext)
>   {
>   	int i;
> -	int max_bin[FFT_NUM_SAMPLES];
> +	int max_bin[NUM_DIFFS + 1];

Just wondering. Is this actually a VLA. FFT_NUM_SAMPLES was static const 
so not really going to show a lot of variation. This array will always 
have the same size on the stack.

Regards,
Arend

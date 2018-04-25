From: Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v3] ath9k: dfs: Remove VLA usage
References: <20180424235752.GA37317@beast>
Date: Wed, 25 Apr 2018 10:26:23 +0300
In-Reply-To: <20180424235752.GA37317@beast> (Kees Cook's message of "Tue, 24
	Apr 2018 16:57:52 -0700")
Message-ID: <87po2nagrk.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
To: Kees Cook <keescook@chromium.org>
Cc: Andreas Christoforou <andreaschristofo@gmail.com>, Rosen Penev <rosenp@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>, Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org, netdev@vger.kernel.org, QCA ath9k Development <ath9k-devel@qca.qualcomm.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> writes:

> In the quest to remove all stack VLA usage from the kernel[1], this
> redefines FFT_NUM_SAMPLES as a #define instead of const int, which still
> triggers gcc's VLA checking pass.
>
> [1] https://lkml.org/lkml/2018/3/7/621
>
> Co-developed-by: Andreas Christoforou <andreaschristofo@gmail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v3: replace FFT_NUM_SAMPLES as a #define (Joe)
> ---
>  drivers/net/wireless/ath/ath9k/dfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/dfs.c
> b/drivers/net/wireless/ath/ath9k/dfs.c
> index 6fee9a464cce..e6e56a925121 100644
> --- a/drivers/net/wireless/ath/ath9k/dfs.c
> +++ b/drivers/net/wireless/ath/ath9k/dfs.c
> @@ -40,8 +40,8 @@ static const int BIN_DELTA_MIN		= 1;
>  static const int BIN_DELTA_MAX		= 10;
>  
>  /* we need at least 3 deltas / 4 samples for a reliable chirp detection */
> -#define NUM_DIFFS 3
> -static const int FFT_NUM_SAMPLES	= (NUM_DIFFS + 1);
> +#define NUM_DIFFS	3
> +#define FFT_NUM_SAMPLES	(NUM_DIFFS + 1)

I have already applied an almost identical patch:

ath9k: dfs: remove accidental use of stack VLA

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=ath-next&id=9c27489a34548913baaaf3b2776e05d4a9389e3e

-- 
Kalle Valo

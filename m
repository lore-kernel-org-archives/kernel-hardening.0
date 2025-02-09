Return-Path: <kernel-hardening-return-21926-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 76CCBC02199
	for <kernel-hardening@archiver.kernel.org>; Sun,  9 Feb 2025 03:43:50 +0000 (UTC)
Received: (qmail 17765 invoked by uid 550); 9 Feb 2025 03:43:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17737 invoked from network); 9 Feb 2025 03:43:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ethancedwards.com;
	s=MBO0001; t=1739072609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gqoZcM4nfDwbCLWIhNBrMzj0yt+yJ0Y4yVQAT7915pA=;
	b=Ua0RKQyOc2Ls0JEfvaVdqF3BIMlp0kOToonnRrXBi4AMObu54PEl/drQd27U1eBrFoYzdy
	XT2nIK7r8O+hI5TFeEZtsPkwuMvIrxU18eijwVBYE4an4rvxsyd9cC/V2QJ2eNxve9c7a0
	cyKkObbPDpSMkAFiHcotMhs0qzi4utYNKwnxkU6VVnCb+uScm797iweUaUBGlznPeWwDyW
	C3A6owfQOD6aFaGdATm4JF58DiCM1ScCm7eH5VVzvmuXXvc/U6LDRga6og2fFXdRstok5j
	Ou/FTnP6y2Il0vwa3q+COl03OM5svCBh1zcnTkkin2oa2JwJ7G90GBlnToArig==
Date: Sat, 8 Feb 2025 22:43:26 -0500
From: Ethan Carter Edwards <ethan@ethancedwards.com>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>, 
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-sound@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	Takashi Iwai <tiwai@suse.com>
Subject: Re: [PATCH] ASoC: q6dsp: q6apm: change kzalloc to kcalloc
Message-ID: <lcaqr52jf5texgoro2mm5kegykgwaifq45m6gkln47tg7fjv4r@4cxw374tspnj>
References: <s6duijftssuzy34ilogc5ggfyukfqxmbflhllyzjlu4ki3xoo4@ci57esahvmxn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s6duijftssuzy34ilogc5ggfyukfqxmbflhllyzjlu4ki3xoo4@ci57esahvmxn>

I wanted to check in on this. Anything I need to change?

Thanks,
Ethan

On 25/01/19 08:32PM, Ethan Carter Edwards wrote:
> We are replacing any instances of kzalloc(size * count, ...) with
> kcalloc(count, size, ...) due to risk of overflow [1].
> 
> [1] https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
> Link: https://github.com/KSPP/linux/issues/162
> 
> Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
> ---
>  sound/soc/qcom/qdsp6/q6apm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/sound/soc/qcom/qdsp6/q6apm.c b/sound/soc/qcom/qdsp6/q6apm.c
> index 2a2a5bd98110..11e252a70f69 100644
> --- a/sound/soc/qcom/qdsp6/q6apm.c
> +++ b/sound/soc/qcom/qdsp6/q6apm.c
> @@ -230,7 +230,7 @@ int q6apm_map_memory_regions(struct q6apm_graph *graph, unsigned int dir, phys_a
>  		return 0;
>  	}
>  
> -	buf = kzalloc(((sizeof(struct audio_buffer)) * periods), GFP_KERNEL);
> +	buf = kcalloc(periods, sizeof(struct audio_buffer), GFP_KERNEL);
>  	if (!buf) {
>  		mutex_unlock(&graph->lock);
>  		return -ENOMEM;
> -- 
> 2.48.0
> 

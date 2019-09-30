Return-Path: <SRS0=AF9A=XZ=lists.openwall.com=kernel-hardening-return-16973-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7042AC32792
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Sep 2019 22:50:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8485A21855
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Sep 2019 22:50:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="MktvYa7k"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8485A21855
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16973-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24320 invoked by uid 550); 30 Sep 2019 22:49:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24286 invoked from network); 30 Sep 2019 22:49:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b/u+jVUJNZkJtOduQGP2CQtB0SH82HZOfp4KH/Fv2hs=;
        b=MktvYa7kN5jvOQa8PKtmYy4aYLzz2u7g9VxoSrRzvMMj3YrocXnamuBdg4AxqiwPUN
         hdLZb+yu/SgK0l2Pm5vBxDA12RHHmGi6zDhoh92el8Z84hjok9PrlFMwaKDbWuXVqCrO
         MCOX1nDMzDLUzbjgJdysOuVO42+NoD3btzdF8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b/u+jVUJNZkJtOduQGP2CQtB0SH82HZOfp4KH/Fv2hs=;
        b=SB8tpoZ3WUvT+TOTDIDNUtwpV2i6Yn0tibpRfy8p21dQtu9zVZXbW6HvIK5spEqcx5
         VzYzOvXdqMDQhw07Rsk+ysADoP2wRCZk23DbniMG4OoCjYjdkgrN/EWI4+/pzYXZailx
         KeJpdqVTC14g6sDVkfxH5rk1/JQUhwSXySQWZ9VlMkNBk9Gu6iR/A2ZaAHx1yba6Hx+Q
         wv0zCBZrLJQE66yVelwumrKgmHn8psnqujE6ftEb+JOYFKXzN7bgt8UFVSLt98jEL4jn
         v1v8HzsXwsQwjy6DexqEE9s2tFhD/I0sYGDvT0FTX4w0CV4DT+2LWgAPnRCvlmsMbNRl
         3rug==
X-Gm-Message-State: APjAAAX8g56ThE3TnNMcK6OrRCvBfGQJjT44/5x8hcN9yU+qQdlwy0K6
	A5/ZSmIWA5ll8z0O9aTFLm5Ygw==
X-Google-Smtp-Source: APXvYqxOmJ4KIYl8TVeHzsw6C8GsKVJMdK/S4glVPxzc9EVE+9LHr5Ab9P4oaENXKTcEdzGzMsiS6A==
X-Received: by 2002:a17:902:8d87:: with SMTP id v7mr15665064plo.126.1569883781955;
        Mon, 30 Sep 2019 15:49:41 -0700 (PDT)
Date: Mon, 30 Sep 2019 15:49:39 -0700
From: Kees Cook <keescook@chromium.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: kernel-hardening@lists.openwall.com,
	Romain Perier <romain.perier@viveris.fr>
Subject: Re: [PRE-REVIEW PATCH 13/16] tasklet: Pass tasklet_struct pointer to
 callbacks unconditionally
Message-ID: <201909301547.8DC227B@keescook>
References: <20190929163028.9665-1-romain.perier@gmail.com>
 <20190929163028.9665-14-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190929163028.9665-14-romain.perier@gmail.com>

On Sun, Sep 29, 2019 at 06:30:25PM +0200, Romain Perier wrote:
> From: Romain Perier <romain.perier@viveris.fr>
> 
> Now that all tasklet callbacks are already taking their struct
> tasklet_struct pointer as the callback argument, just do this
> unconditionally and remove the .data field. It converts all
> runtime code, init functions and the DECLARE_TASKLET() macros
> to get rid of the .data argument. Moreover, all remaining use
> or assignment of the .data field are removed in a single shot.
> 
> Signed-off-by: Romain Perier <romain.perier@viveris.fr>
> ---
>  drivers/gpu/drm/i915/gt/intel_engine_cs.c        | 2 +-
>  drivers/gpu/drm/i915/gt/intel_lrc.c              | 2 +-
>  drivers/net/usb/usbnet.c                         | 1 -
>  drivers/net/wireless/atmel/at76c50x-usb.c        | 1 -
>  drivers/net/wireless/intersil/hostap/hostap_hw.c | 2 +-
>  drivers/net/wireless/realtek/rtlwifi/usb.c       | 1 -
>  drivers/net/wireless/zydas/zd1211rw/zd_usb.c     | 1 -
>  drivers/staging/most/dim2/dim2.c                 | 1 -
>  drivers/usb/gadget/udc/snps_udc_core.c           | 1 -
>  include/linux/interrupt.h                        | 9 ++++-----
>  kernel/softirq.c                                 | 5 ++---
>  net/atm/pppoatm.c                                | 1 -
>  12 files changed, 9 insertions(+), 18 deletions(-)

Similar to the other suggestions, I would split out the individual
changes that that touch the .data assignments. This makes those
"unusual" cases easier to review.

> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
> index 82630db0394b..357d14ae32d0 100644
> --- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
> +++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
> @@ -1057,7 +1057,7 @@ bool intel_engine_is_idle(struct intel_engine_cs *engine)
>  		if (tasklet_trylock(t)) {
>  			/* Must wait for any GPU reset in progress. */
>  			if (__tasklet_is_enabled(t))
> -				t->func(t->data);
> +				t->func(t);
>  			tasklet_unlock(t);
>  		}
>  		local_bh_enable();
> diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
> index d630dbc953ad..99f39047e49f 100644
> --- a/drivers/gpu/drm/i915/gt/intel_lrc.c
> +++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
> @@ -2616,7 +2616,7 @@ static void execlists_reset_finish(struct intel_engine_cs *engine)
>  	 */
>  	GEM_BUG_ON(!reset_in_progress(execlists));
>  	if (!RB_EMPTY_ROOT(&execlists->queue.rb_root))
> -		execlists->tasklet.func(execlists->tasklet.data);
> +		execlists->tasklet.func(&execlists->tasklet);
>  
>  	if (__tasklet_enable(&execlists->tasklet))
>  		/* And kick in case we missed a new request submission. */
> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index 1c4817c05d3c..14cedee27f2f 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -1693,7 +1693,6 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
>  	skb_queue_head_init (&dev->done);
>  	skb_queue_head_init(&dev->rxq_pause);
>  	dev->bh.func = (TASKLET_FUNC_TYPE)usbnet_bh;
> -	dev->bh.data = (TASKLET_DATA_TYPE)&dev->delay;
>  	INIT_WORK (&dev->kevent, usbnet_deferred_kevent);
>  	init_usb_anchor(&dev->deferred);
>  	timer_setup(&dev->delay, usbnet_bh, 0);
> diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
> index 3a66538a0853..fd796a32c71d 100644
> --- a/drivers/net/wireless/atmel/at76c50x-usb.c
> +++ b/drivers/net/wireless/atmel/at76c50x-usb.c
> @@ -1199,7 +1199,6 @@ static void at76_rx_callback(struct urb *urb)
>  {
>  	struct at76_priv *priv = urb->context;
>  
> -	priv->rx_tasklet.data = (unsigned long)urb;

Some of these looks very strange -- how are the urb and tasklet
associated, etc?

>  	tasklet_schedule(&priv->rx_tasklet);
>  }
>  
> diff --git a/drivers/net/wireless/intersil/hostap/hostap_hw.c b/drivers/net/wireless/intersil/hostap/hostap_hw.c
> index 187095e13294..ae656563a82d 100644
> --- a/drivers/net/wireless/intersil/hostap/hostap_hw.c
> +++ b/drivers/net/wireless/intersil/hostap/hostap_hw.c
> @@ -3183,7 +3183,7 @@ prism2_init_local_data(struct prism2_helper_functions *funcs, int card_idx,
>  	/* Initialize tasklets for handling hardware IRQ related operations
>  	 * outside hw IRQ handler */
>  #define HOSTAP_TASKLET_INIT(q, f, d) \
> -do { memset((q), 0, sizeof(*(q))); (q)->func = (TASKLET_FUNC_TYPE)(f); (q)->data = (TASKLET_DATA_TYPE)(q); } \
> +do { memset((q), 0, sizeof(*(q))); (q)->func = (TASKLET_FUNC_TYPE)(f); } \
>  while (0)
>  	HOSTAP_TASKLET_INIT(&local->bap_tasklet, hostap_bap_tasklet,
>  			    (unsigned long) local);
> diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
> index aae5c5aa1769..7e9bdbd2a6f4 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/usb.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
> @@ -311,7 +311,6 @@ static int _rtl_usb_init_rx(struct ieee80211_hw *hw)
>  
>  	skb_queue_head_init(&rtlusb->rx_queue);
>  	rtlusb->rx_work_tasklet.func = (TASKLET_FUNC_TYPE)_rtl_rx_work;
> -	rtlusb->rx_work_tasklet.data = (TASKLET_DATA_TYPE)&rtlusb->rx_work_tasklet;
>  
>  	return 0;
>  }
> diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
> index 0ebbd727a452..4275549f4d98 100644
> --- a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
> +++ b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
> @@ -1181,7 +1181,6 @@ static inline void init_usb_rx(struct zd_usb *usb)
>  	ZD_ASSERT(rx->fragment_length == 0);
>  	INIT_DELAYED_WORK(&rx->idle_work, zd_rx_idle_timer_handler);
>  	rx->reset_timer_tasklet.func = (TASKLET_FUNC_TYPE)zd_usb_reset_rx_idle_timer_tasklet;
> -	rx->reset_timer_tasklet.data = (TASKLET_DATA_TYPE)&rx->reset_timer_tasklet;

These look like open-coded tasklet initializations?

-- 
Kees Cook

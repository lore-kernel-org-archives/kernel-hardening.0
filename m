Return-Path: <SRS0=As3k=67=lists.openwall.com=kernel-hardening-return-18824-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF60C433E0
	for <kernel-hardening@archiver.kernel.org>; Sun, 17 May 2020 16:43:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6524F20643
	for <kernel-hardening@archiver.kernel.org>; Sun, 17 May 2020 16:43:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d/bFl9zc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6524F20643
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18824-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3892 invoked by uid 550); 17 May 2020 16:43:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3848 invoked from network); 17 May 2020 16:43:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bW2tMhxWyyjNncTb2G7OX7x0LZat/kQuDZNZwydNgqI=;
        b=d/bFl9zc2OyPGpLznpmI7A+ZDvS789Kbw8lTq2WEMKo+Oi/9p7s+GtNlQtjyzAAHWs
         3xz2VcLzijw/7uk3s2hE8szH+6A9PFoNPbF5GzOAXXPCexmAwQu/qBbf+PcNfCRxEMDO
         x+QH6O02AYW3LjPO6VG2z8b/gDDlPMSBBJG1PlJMSsGuP7oNUilHi3uZnDU+sjOqnpay
         /jHs8xzHBCUGY4ALEcrBqEonOR0KpSKjcy//YuiZ9/l/Okvq6rfaXddyJGk8ufKmEXJG
         JcoxOqF4dXi/hTMstDEBPtdW330tAhbx/o9s7N84zN7yw6vXHKMCxOYgrfuHn/t2qkwi
         V8gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bW2tMhxWyyjNncTb2G7OX7x0LZat/kQuDZNZwydNgqI=;
        b=ViaSLUsvEUAtiIu6B6owe6VFNURkyZVzNXcKK+c57iP2UubkadF1gHhCmERuUkul5l
         V8bYnYSQynAbzXM94K73Amj7S9IC8sjcUlIe54GiyNIAbJZDNY24UY1fllarz1SPcUAj
         EEryL4IoQSmno6NylFIVUIiBVl0fcVo7lL4I+hfI3Yl21FbsAcrc8kDmMlaozq19/BYz
         IfoPR/FGsTMKAJU9FBQwDOpt+1IPEmIgdyv6StacDOCr2+EVk7oAAriOdJMSck177/w2
         piz0W6R+DMY5Rscm2AQD4+s0LDmst32Of/+ivdY9yUsRNHsmMO991gSOf/2soizUJqij
         Lf7g==
X-Gm-Message-State: AOAM5325a71DptXToXNdjYYMhOTvLY09UAdrTsj/VxtmOSE89iQxrfM8
	GUtYwIsQP2L7swR2moKnJOYGrQWhdYNzKFoVwL0=
X-Google-Smtp-Source: ABdhPJzqbU5i3pOsh9QTXXqsMPl4e4nnE4VT8jwhh5K7/GgAT+qqtvyWdOaHb1xfeVtbgJbnihxKRLuVNNoF7TrLW3Q=
X-Received: by 2002:a5e:8d17:: with SMTP id m23mr11036234ioj.11.1589733813147;
 Sun, 17 May 2020 09:43:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200516173934.31527-1-oscar.carter@gmx.com>
In-Reply-To: <20200516173934.31527-1-oscar.carter@gmx.com>
From: "Lev R. Oshvang ." <levonshe@gmail.com>
Date: Sun, 17 May 2020 19:43:21 +0300
Message-ID: <CAP22eLF2Q3O+=tnHRKE5q=jn9gw2G1rjAKiewM4qGsf4WYvP0Q@mail.gmail.com>
Subject: Re: [PATCH] firewire: Remove function callback casts
To: Oscar Carter <oscar.carter@gmx.com>
Cc: Kees Cook <keescook@chromium.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, Clemens Ladisch <clemens@ladisch.de>, 
	Takashi Sakamoto <o-takashi@sakamocchi.jp>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	kernel-hardening@lists.openwall.com, linux1394-devel@lists.sourceforge.net, 
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"

On Sat, May 16, 2020 at 8:40 PM Oscar Carter <oscar.carter@gmx.com> wrote:
>
> In an effort to enable -Wcast-function-type in the top-level Makefile to
> support Control Flow Integrity builds, remove all the function callback
> casts.
>
> To do this, modify the "fw_iso_context_create" function prototype adding
> a new parameter for the multichannel callback. Also, fix all the
> function calls accordingly.
>
> Signed-off-by: Oscar Carter <oscar.carter@gmx.com>
> ---
>  drivers/firewire/core-cdev.c        | 12 +++++++-----
>  drivers/firewire/core-iso.c         | 10 ++++++++--
>  drivers/firewire/net.c              |  2 +-
>  drivers/media/firewire/firedtv-fw.c |  3 ++-
>  include/linux/firewire.h            |  3 ++-
>  sound/firewire/amdtp-stream.c       |  2 +-
>  sound/firewire/isight.c             |  4 ++--
>  7 files changed, 23 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
> index 6e291d8f3a27..cc368b35be2e 100644
> --- a/drivers/firewire/core-cdev.c
> +++ b/drivers/firewire/core-cdev.c
> @@ -957,7 +957,8 @@ static int ioctl_create_iso_context(struct client *client, union ioctl_arg *arg)
>  {
>         struct fw_cdev_create_iso_context *a = &arg->create_iso_context;
>         struct fw_iso_context *context;
> -       fw_iso_callback_t cb;
> +       fw_iso_callback_t cb_sc = NULL;
> +       fw_iso_mc_callback_t cb_mc = NULL;
>         int ret;
>
>         BUILD_BUG_ON(FW_CDEV_ISO_CONTEXT_TRANSMIT != FW_ISO_CONTEXT_TRANSMIT ||
> @@ -970,7 +971,7 @@ static int ioctl_create_iso_context(struct client *client, union ioctl_arg *arg)
>                 if (a->speed > SCODE_3200 || a->channel > 63)
>                         return -EINVAL;
>
> -               cb = iso_callback;
> +               cb_sc = iso_callback;
>                 break;
>
>         case FW_ISO_CONTEXT_RECEIVE:
> @@ -978,11 +979,11 @@ static int ioctl_create_iso_context(struct client *client, union ioctl_arg *arg)
>                     a->channel > 63)
>                         return -EINVAL;
>
> -               cb = iso_callback;
> +               cb_sc = iso_callback;
>                 break;
>
>         case FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL:
> -               cb = (fw_iso_callback_t)iso_mc_callback;
> +               cb_mc = iso_mc_callback;
>                 break;
>
>         default:
> @@ -990,7 +991,8 @@ static int ioctl_create_iso_context(struct client *client, union ioctl_arg *arg)
>         }
>
>         context = fw_iso_context_create(client->device->card, a->type,
> -                       a->channel, a->speed, a->header_size, cb, client);
> +                       a->channel, a->speed, a->header_size, cb_sc, cb_mc,
> +                       client);
>         if (IS_ERR(context))
>                 return PTR_ERR(context);
>         if (client->version < FW_CDEV_VERSION_AUTO_FLUSH_ISO_OVERFLOW)
> diff --git a/drivers/firewire/core-iso.c b/drivers/firewire/core-iso.c
> index 185b0b78b3d6..3b8e349704f8 100644
> --- a/drivers/firewire/core-iso.c
> +++ b/drivers/firewire/core-iso.c
> @@ -131,7 +131,8 @@ size_t fw_iso_buffer_lookup(struct fw_iso_buffer *buffer, dma_addr_t completed)
>
>  struct fw_iso_context *fw_iso_context_create(struct fw_card *card,
>                 int type, int channel, int speed, size_t header_size,
> -               fw_iso_callback_t callback, void *callback_data)
> +               fw_iso_callback_t cb_sc, fw_iso_mc_callback_t cb_mc,
> +               void *callback_data)
>  {
>         struct fw_iso_context *ctx;
>
> @@ -145,7 +146,12 @@ struct fw_iso_context *fw_iso_context_create(struct fw_card *card,
>         ctx->channel = channel;
>         ctx->speed = speed;
>         ctx->header_size = header_size;
> -       ctx->callback.sc = callback;
> +
> +       if (cb_sc)
> +               ctx->callback.sc = cb_sc;
> +       else
> +               ctx->callback.mc = cb_mc;
> +
>         ctx->callback_data = callback_data;
>
>         return ctx;
> diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
> index 715e491dfbc3..c5cc0a311aa0 100644
> --- a/drivers/firewire/net.c
> +++ b/drivers/firewire/net.c
> @@ -1136,7 +1136,7 @@ static int fwnet_broadcast_start(struct fwnet_device *dev)
>         context = fw_iso_context_create(dev->card, FW_ISO_CONTEXT_RECEIVE,
>                                         IEEE1394_BROADCAST_CHANNEL,
>                                         dev->card->link_speed, 8,
> -                                       fwnet_receive_broadcast, dev);
> +                                       fwnet_receive_broadcast, NULL, dev);
>         if (IS_ERR(context)) {
>                 retval = PTR_ERR(context);
>                 goto failed;
> diff --git a/drivers/media/firewire/firedtv-fw.c b/drivers/media/firewire/firedtv-fw.c
> index 97144734eb05..d2940adefd8c 100644
> --- a/drivers/media/firewire/firedtv-fw.c
> +++ b/drivers/media/firewire/firedtv-fw.c
> @@ -141,7 +141,8 @@ int fdtv_start_iso(struct firedtv *fdtv)
>
>         ctx->context = fw_iso_context_create(device->card,
>                         FW_ISO_CONTEXT_RECEIVE, fdtv->isochannel,
> -                       device->max_speed, ISO_HEADER_SIZE, handle_iso, fdtv);
> +                       device->max_speed, ISO_HEADER_SIZE,
> +                       handle_iso, NULL, fdtv);
>         if (IS_ERR(ctx->context)) {
>                 err = PTR_ERR(ctx->context);
>                 goto fail_free;
> diff --git a/include/linux/firewire.h b/include/linux/firewire.h
> index aec8f30ab200..3a0b5e18e140 100644
> --- a/include/linux/firewire.h
> +++ b/include/linux/firewire.h
> @@ -452,7 +452,8 @@ struct fw_iso_context {
>
>  struct fw_iso_context *fw_iso_context_create(struct fw_card *card,
>                 int type, int channel, int speed, size_t header_size,
> -               fw_iso_callback_t callback, void *callback_data);
> +               fw_iso_callback_t cb_sc, fw_iso_mc_callback_t cb_mc,
> +               void *callback_data);
>  int fw_iso_context_set_channels(struct fw_iso_context *ctx, u64 *channels);
>  int fw_iso_context_queue(struct fw_iso_context *ctx,
>                          struct fw_iso_packet *packet,
> diff --git a/sound/firewire/amdtp-stream.c b/sound/firewire/amdtp-stream.c
> index 37d38efb4c87..8629ab3e2c64 100644
> --- a/sound/firewire/amdtp-stream.c
> +++ b/sound/firewire/amdtp-stream.c
> @@ -1093,7 +1093,7 @@ static int amdtp_stream_start(struct amdtp_stream *s, int channel, int speed,
>
>         s->context = fw_iso_context_create(fw_parent_device(s->unit)->card,
>                                           type, channel, speed, ctx_header_size,
> -                                         ctx_cb, ctx_data);
> +                                         ctx_cb, NULL, ctx_data);
>         if (IS_ERR(s->context)) {
>                 err = PTR_ERR(s->context);
>                 if (err == -EBUSY)
> diff --git a/sound/firewire/isight.c b/sound/firewire/isight.c
> index 6655af53b367..51cc37fca736 100644
> --- a/sound/firewire/isight.c
> +++ b/sound/firewire/isight.c
> @@ -361,8 +361,8 @@ static int isight_start_streaming(struct isight *isight)
>         isight->context = fw_iso_context_create(isight->device->card,
>                                                 FW_ISO_CONTEXT_RECEIVE,
>                                                 isight->resources.channel,
> -                                               isight->device->max_speed,
> -                                               4, isight_packet, isight);
> +                                               isight->device->max_speed, 4,
> +                                               isight_packet, NULL, isight);
>         if (IS_ERR(isight->context)) {
>                 err = PTR_ERR(isight->context);
>                 isight->context = NULL;
> --
> 2.20.1
>

Hi Oscar,
I would recommend to explicitly set NULL to _cb and use if elif to
exclude the case where botm _cb paraneters are passed as NULLs :
> +
  ctx->callback.mc =NULL:
  ctx->callback.sc = NULL;
> +       if (cb_sc)
> +               ctx->callback.sc = cb_sc;

> +       elif (cb_ms)
> +               ctx->callback.mc = cb_mc;
> +         else
                    return -EINVAL;

Hope you get the point.
Lev

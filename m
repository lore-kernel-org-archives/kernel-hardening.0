Return-Path: <SRS0=LXWA=7G=lists.openwall.com=kernel-hardening-return-18868-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 413DDC433DF
	for <kernel-hardening@archiver.kernel.org>; Sun, 24 May 2020 15:23:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6412B207CB
	for <kernel-hardening@archiver.kernel.org>; Sun, 24 May 2020 15:23:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="RU6HNXUY";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="fKZmeWRn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6412B207CB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kroah.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18868-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19507 invoked by uid 550); 24 May 2020 15:23:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19475 invoked from network); 24 May 2020 15:23:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
	date:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=fm3; bh=I79IsRBzEXTgS4Vwqt9UYflOErT
	S0Sm76ePmBkC0NLM=; b=RU6HNXUYislizSbQHkT0iPuqRgVfN/mNKHy6bAD9Ixj
	JauSCg3xKz9Pb+0EJi9BUc6EhmfboRhbjjnvWs5baO3LQt188E2u9q8TjbsGEbPu
	zP7dxSKDAoikpTfLC0EOLLoNaNTgP4j4tgrBhMTMCHYBLRn3hbWXRzpmCXgTBini
	wFrbe0JrQ6ecEfi/ZLkf5RKr07OXP9W5rVdgckmMCMwPeVaT0MVdePTXe74O//Uk
	sJPuvYLp9LK64ldUhS/lLL5nRhWUVNaDQe0ijg/cOij16E9xj82wQieicKkiWRfa
	TQrk6gHLi5/8ITczMBZr41Cbxwt/6yzrkUuVQ0InH+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=I79IsR
	BzEXTgS4Vwqt9UYflOErTS0Sm76ePmBkC0NLM=; b=fKZmeWRntqqEG8oVBwrxpK
	2omPNlC4ux4dt154XHnO5yhdXysDqQe7cXJC7cIAuq+PPYUNLo93Fe2qBujiUKDs
	WtRTRD7Ds/pCSEIUPILkhRYf8CMra07qjeMHsjelcjz+SrQoK6rEhftoMedNYGgr
	QG+j8JSo/qTf1WLHs3+SoCCfqZ2cwGbGrTzHOCPCQENU/igze5xSEphn/BrToWpM
	R2zRluzBSaVG5Rae32FEysY6kR6wgTnrig+7uCfMVbfpobn7vhmPQh0WpxaW/2tj
	eg3ZHcRyAiQHurZ0WtM0gH2xhdkW+AS2MqXzhTQhOHL7kMAGxlmfuvg+hPDHr09w
	==
X-ME-Sender: <xms:WJHKXjNg1dBCYukkoHwj1x_TkRDzb-eH5KZ8r72Ajd7ddhXrdgc4Cg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddukedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necuggftrfgrthhtvghrnhepueelledtheekleethfeludduvdfhffeuvdffudevgeehke
    egieffveehgeeftefgnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:WJHKXt_jQdCj2NagUdE83Xs2utK5kzGvWH_bFrlyHLe2kXI-HWdOqQ>
    <xmx:WJHKXiS4vEl8C_5TbBfOqxFBy0Sdo8z33g6qFEIhjWSyL2Ts3LdXzw>
    <xmx:WJHKXnsr3jC523WCM4crez8k5c8KLuOJopfLLAxNqv3hrYT6yhn6YQ>
    <xmx:WZHKXi7unnLWWZmW61f0HxerJ79Bfw-vl678SZMIghBQmtPxmI-Vjw>
Date: Sun, 24 May 2020 17:23:01 +0200
From: Greg KH <greg@kroah.com>
To: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Cc: oscar.carter@gmx.com, keescook@chromium.org, stefanr@s5r6.in-berlin.de,
	kernel-hardening@lists.openwall.com,
	linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	clemens@ladisch.de
Subject: Re: [PATCH v2] firewire-core: remove cast of function callback
Message-ID: <20200524152301.GB21163@kroah.com>
References: <20200524132048.243223-1-o-takashi@sakamocchi.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200524132048.243223-1-o-takashi@sakamocchi.jp>

On Sun, May 24, 2020 at 10:20:48PM +0900, Takashi Sakamoto wrote:
> In 1394 OHCI specification, Isochronous Receive DMA context has several
> modes. One of mode is 'BufferFill' and Linux FireWire stack uses it to
> receive isochronous packets for multiple isochronous channel as
> FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL.
> 
> The mode is not used by in-kernel driver, while it's available for
> userspace. The character device driver in firewire-core includes
> cast of function callback for the mode since the type of callback
> function is different from the other modes. The case is inconvenient
> to effort of Control Flow Integrity builds due to
> -Wcast-function-type warning.
> 
> This commit removes the cast. A inline helper function is newly added
> to initialize isochronous context for the mode. The helper function
> arranges isochronous context to assign specific callback function
> after call of existent kernel API. It's noticeable that the number of
> isochronous channel, speed, the size of header are not required for the
> mode. The helper function is used for the mode by character device
> driver instead of direct call of existent kernel API.
> 
> Changes in v2:
>  - unexport helper function
>  - use inline for helper function
>  - arrange arguments for helper function
>  - tested by libhinoko
> 
> Reported-by: Oscar Carter <oscar.carter@gmx.com>
> Reference: https://lore.kernel.org/lkml/20200519173425.4724-1-oscar.carter@gmx.com/
> Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
> ---
>  drivers/firewire/core-cdev.c | 40 +++++++++++++++---------------------
>  include/linux/firewire.h     | 16 +++++++++++++++
>  2 files changed, 33 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
> index 6e291d8f3a27..7cbf6df34b43 100644
> --- a/drivers/firewire/core-cdev.c
> +++ b/drivers/firewire/core-cdev.c
> @@ -957,7 +957,6 @@ static int ioctl_create_iso_context(struct client *client, union ioctl_arg *arg)
>  {
>  	struct fw_cdev_create_iso_context *a = &arg->create_iso_context;
>  	struct fw_iso_context *context;
> -	fw_iso_callback_t cb;
>  	int ret;
>  
>  	BUILD_BUG_ON(FW_CDEV_ISO_CONTEXT_TRANSMIT != FW_ISO_CONTEXT_TRANSMIT ||
> @@ -965,32 +964,27 @@ static int ioctl_create_iso_context(struct client *client, union ioctl_arg *arg)
>  		     FW_CDEV_ISO_CONTEXT_RECEIVE_MULTICHANNEL !=
>  					FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL);
>  
> -	switch (a->type) {
> -	case FW_ISO_CONTEXT_TRANSMIT:
> -		if (a->speed > SCODE_3200 || a->channel > 63)
> -			return -EINVAL;
> -
> -		cb = iso_callback;
> -		break;
> -
> -	case FW_ISO_CONTEXT_RECEIVE:
> -		if (a->header_size < 4 || (a->header_size & 3) ||
> -		    a->channel > 63)
> -			return -EINVAL;
> -
> -		cb = iso_callback;
> -		break;
> -
> -	case FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL:
> -		cb = (fw_iso_callback_t)iso_mc_callback;
> -		break;
> +	if (a->type == FW_ISO_CONTEXT_TRANSMIT ||
> +	    a->type == FW_ISO_CONTEXT_RECEIVE) {
> +		if (a->type == FW_ISO_CONTEXT_TRANSMIT) {
> +			if (a->speed > SCODE_3200 || a->channel > 63)
> +				return -EINVAL;
> +		} else {
> +			if (a->header_size < 4 || (a->header_size & 3) ||
> +			    a->channel > 63)
> +				return -EINVAL;
> +		}
>  
> -	default:
> +		context = fw_iso_context_create(client->device->card, a->type,
> +					a->channel, a->speed, a->header_size,
> +					iso_callback, client);
> +	} else if (a->type == FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL) {
> +		context = fw_iso_mc_context_create(client->device->card,
> +						   iso_mc_callback, client);
> +	} else {
>  		return -EINVAL;
>  	}
>  
> -	context = fw_iso_context_create(client->device->card, a->type,
> -			a->channel, a->speed, a->header_size, cb, client);
>  	if (IS_ERR(context))
>  		return PTR_ERR(context);
>  	if (client->version < FW_CDEV_VERSION_AUTO_FLUSH_ISO_OVERFLOW)
> diff --git a/include/linux/firewire.h b/include/linux/firewire.h
> index aec8f30ab200..bff08118baaf 100644
> --- a/include/linux/firewire.h
> +++ b/include/linux/firewire.h
> @@ -453,6 +453,22 @@ struct fw_iso_context {
>  struct fw_iso_context *fw_iso_context_create(struct fw_card *card,
>  		int type, int channel, int speed, size_t header_size,
>  		fw_iso_callback_t callback, void *callback_data);
> +
> +static inline struct fw_iso_context *fw_iso_mc_context_create(
> +						struct fw_card *card,
> +						fw_iso_mc_callback_t callback,
> +						void *callback_data)
> +{
> +	struct fw_iso_context *ctx;
> +
> +	ctx = fw_iso_context_create(card, FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL,
> +				    0, 0, 0, NULL, callback_data);
> +	if (!IS_ERR(ctx))
> +		ctx->callback.mc = callback;
> +
> +	return ctx;
> +}

Why is this in a .h file?  What's wrong with just putting it in the .c
file as a static function?  There's no need to make this an inline,
right?

thanks,

greg k-h

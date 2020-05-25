Return-Path: <SRS0=3+N/=7H=lists.openwall.com=kernel-hardening-return-18873-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42EABC433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 25 May 2020 09:31:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 965272078B
	for <kernel-hardening@archiver.kernel.org>; Mon, 25 May 2020 09:31:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=sakamocchi.jp header.i=@sakamocchi.jp header.b="kkqXywBz";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rQyUpMEI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 965272078B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sakamocchi.jp
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18873-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19608 invoked by uid 550); 25 May 2020 09:30:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19736 invoked from network); 25 May 2020 01:45:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
	 h=date:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=fm1; bh=w8gtuLdhRhjlG/R+K3KScUqE3pg
	NDvo53M+1qyJesbk=; b=kkqXywBzEe6SfCh5kXCpWUHn5r/0p3WrB/XkL3kYbgc
	/Yzs9rzjUBej5g3GDMC8rEa19tPMjGptGBufe4xgYECp73zXbCZKqmu+RUpsI9eK
	lExlWPNPxyrqQFgtwR4yBFR9fy/zO2Ug611xP6Ceo1wVUx65rTlDZf6COOdVm8LW
	Hiq1Aphahf2Bk7rPgI1P3F0tWrX3mOwX5BafjbXaOImClCirQcGmEh6HoCeZtw6k
	NLbV+Uh1IbO5mYGmWa7VCgxcn6w5hQab2merp8KsLzxiFKe0ajrrvQX/HXS58Ke4
	9rRYjliwAH1te4ucMzhnASQav3vQwUsDrSAIjn3s7jw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=w8gtuL
	dhRhjlG/R+K3KScUqE3pgNDvo53M+1qyJesbk=; b=rQyUpMEIuZ923uXnaBkmWp
	q8fumpUSSS4mI6wb0VAAa9eLGtg7wzzjPt1do/I4JqxZ4heKfpt4+rHp/keN75Fi
	gefHESPEIEwLM1Cgpg6GA+0s2i0AxumtMgCQG9T1vAxWeDfJRM2ywxyGkJx7Mfki
	CI0GLJnKPJjKoOD9y9mcLyKWkfbN8spKTvBhkukzxcMhtLUkI9edMomhSz3+sKln
	Q7Ic1z0uQ6u1zk/wdfoiG9hGgBHWEsZNBNsQGf3j8eKB7E7fU2vfEu8hvVOACARk
	Bm0TCmjClBYimHDBx2IF89jYfxULx6wc5cLKwinxbCGR2phRhVJ8+DbEwzmls6iw
	==
X-ME-Sender: <xms:HyPLXsO6B2wXlrpoG3Aw25ILI5-SNnPlX_pS28GFP4A-L08TtSYqMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduledggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefvrghkrghs
    hhhiucfurghkrghmohhtohcuoehoqdhtrghkrghshhhisehsrghkrghmohgttghhihdrjh
    hpqeenucggtffrrghtthgvrhhnpeelhfeugedvjefgjefgudekfedutedvtddutdeuieev
    tddtgeetjeekvdefgeefhfenucfkphepudektddrvdefhedrfedrheegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepohdqthgrkhgrshhhihes
    shgrkhgrmhhotggthhhirdhjph
X-ME-Proxy: <xmx:HyPLXi_Tz36pYaNV4MPPjzsXMK48sdEFXUY7Wk3LeQ3UiaQdH1QPaQ>
    <xmx:HyPLXjR97R5quMcaCIIyX5gKsldl1D0Ytsj-DNz_BhYd6fE0DiEPtg>
    <xmx:HyPLXktzblJ3P5EeqKJqemTL7S6OAmJS8sMj7_NUz9Nm16C-VwJmSw>
    <xmx:ICPLXj6mkXxd-0uffftvQfE6qMQFl6Jdp9htaltvYtx5PAP3DUX57Q>
Date: Mon, 25 May 2020 10:44:58 +0900
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg KH <greg@kroah.com>, oscar.carter@gmx.com, keescook@chromium.org,
	kernel-hardening@lists.openwall.com,
	linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	clemens@ladisch.de
Subject: Re: [PATCH v2] firewire-core: remove cast of function callback
Message-ID: <20200525014458.GA252667@workstation>
Mail-Followup-To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <greg@kroah.com>, oscar.carter@gmx.com,
	keescook@chromium.org, kernel-hardening@lists.openwall.com,
	linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	clemens@ladisch.de
References: <20200524132048.243223-1-o-takashi@sakamocchi.jp>
 <20200524152301.GB21163@kroah.com>
 <20200525015532.0055f9df@kant>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525015532.0055f9df@kant>

Hi,

On Mon, May 25, 2020 at 01:55:32AM +0200, Stefan Richter wrote:
> > Why is this in a .h file?  What's wrong with just putting it in the .c
> > file as a static function?  There's no need to make this an inline,
> > right?
> 
> There is no need for this in a header.
> Furthermore, I prefer the original switch statement over the nested if/else.
> 
> Here is another proposal; I will resend it later as a proper patch.
> 
> diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
> index 719791819c24..bece1b69b43f 100644
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
> @@ -969,20 +968,15 @@ static int ioctl_create_iso_context(struct client *client, union ioctl_arg *arg)
>  	case FW_ISO_CONTEXT_TRANSMIT:
>  		if (a->speed > SCODE_3200 || a->channel > 63)
>  			return -EINVAL;
> -
> -		cb = iso_callback;
>  		break;
>  
>  	case FW_ISO_CONTEXT_RECEIVE:
>  		if (a->header_size < 4 || (a->header_size & 3) ||
>  		    a->channel > 63)
>  			return -EINVAL;
> -
> -		cb = iso_callback;
>  		break;
>  
>  	case FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL:
> -		cb = (fw_iso_callback_t)iso_mc_callback;
>  		break;
>  
>  	default:
> @@ -990,9 +984,15 @@ static int ioctl_create_iso_context(struct client *client, union ioctl_arg *arg)
>  	}
>  
>  	context = fw_iso_context_create(client->device->card, a->type,
> -			a->channel, a->speed, a->header_size, cb, client);
> +			a->channel, a->speed, a->header_size, NULL, client);
>  	if (IS_ERR(context))
>  		return PTR_ERR(context);
> +
> +	if (a->type == FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL)
> +		context->callback.mc = iso_mc_callback;
> +	else
> +		context->callback.sc = iso_callback;
> +
>  	if (client->version < FW_CDEV_VERSION_AUTO_FLUSH_ISO_OVERFLOW)
>  		context->drop_overflow_headers = true;

At first place, I wrote the similar patch but judged it's a bit ad-hoc
way that callback functions are assigned after the call of
fw_iso_context_create() in raw code. For explicitness in a point of things
being declarative, I put the inline function into header, and avoid
someone's misfortune for future even if IEEE 1394 is enough legacy.

Anyway, I don't mind Stefan's proposal since it works well. It depends
on developers' fashion to choose policy to write codes.


Thanks

Takashi Sakamoto

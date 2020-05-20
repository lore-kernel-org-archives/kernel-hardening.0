Return-Path: <SRS0=s6IB=7C=lists.openwall.com=kernel-hardening-return-18834-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4432BC433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 20 May 2020 09:10:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 86EEB206C3
	for <kernel-hardening@archiver.kernel.org>; Wed, 20 May 2020 09:10:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=sakamocchi.jp header.i=@sakamocchi.jp header.b="boZgr2GG";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kvz2/Wez"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86EEB206C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sakamocchi.jp
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18834-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11770 invoked by uid 550); 20 May 2020 09:10:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16241 invoked from network); 20 May 2020 06:16:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
	 h=date:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=fm1; bh=3XNYaKnp2YGCe91EplwF85srPK8
	6i5OIm/TZfO+r/A4=; b=boZgr2GGEoSCPOnQyY7adWYwLGs6cKNwB4tPIHroF9Q
	6nBi0D14HFNTaPEDK3mIToWgpFD/SoE7jIoA7nd1Ehuqfj2nkYSu+jP+xit2P2md
	XyTPT8i1+WR8EI2wlndxzZ0JCoY2jwiZnEzCWg0NvPuRyoDazEcAnX0KRzebYOeh
	EVRIWQ0WD1GjnazMVjqf/Ab6PxSId5ikiYxDPAipIlx+4a5HXOeE1cQFGijcK+4Z
	ro7MyN64kh82CxC5mgEKPkcegXkk23zwMsIVa12ZzhglXUSQa+C08eKEbhYQ3M8h
	svQd995a84sj/zPAqYjaoID1dZyUcdtTmLgXBJ1n/1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=3XNYaK
	np2YGCe91EplwF85srPK86i5OIm/TZfO+r/A4=; b=kvz2/WezRA3U7KeAYIoye/
	GsK/JdQkFZfgnTnjy2U5r+nWxYV6BqcjDpSfSvImK33U8NDqHQjjWgIddB9ItzE5
	VQoDX9qFU83BCNZmvLoTQJxyRMkt/SBkeuaDt6CGdf22EfiLsSvhWCjXL0WoaOWk
	G5jP6/vgh7y54m0i6/oDos61fHKztdduCD99IIrEyuVmehl96QhRMEnhO2T+4zxM
	mrEi/nZR2z10IjvG0j3QEp6j/7Tf+5KyCS0BRWTIBwlN0LIkwsudGJ9r4vB+Kz9F
	mWRnnA6e+WTUa1SICCmLKb+BxjRygr+OCe+Nvn1RFo54RJDyhj0Q4OjeYX7twCiw
	==
X-ME-Sender: <xms:PMvEXtybO761tUOfUtM1Uqz2bHplKGTEmVGoIF0G3kzcLSXeGp8BQQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddtkedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepvfgrkhgr
    shhhihcuufgrkhgrmhhothhouceoohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhird
    hjpheqnecuggftrfgrthhtvghrnheplefhueegvdejgfejgfdukeefudetvddtuddtueei
    vedttdegteejkedvfeegfefhnecukfhppedukedtrddvfeehrdefrdehgeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehoqdhtrghkrghshhhi
    sehsrghkrghmohgttghhihdrjhhp
X-ME-Proxy: <xmx:PMvEXtQgL0xVSCOkaJchdgOBsjqZ2eLoEvsuUCzy-o2rOR9gqAeSCg>
    <xmx:PMvEXnXKX9pr1U5wgNkSMjZe8QCjXPg31XSMjzBCpwtmJubMfnKZXw>
    <xmx:PMvEXvi9bWn-4QBYxqXPK1RYyfQElyNhwIe9R9yz2xMB1_c_Ji2mjg>
    <xmx:QsvEXrtMztEFg7yl7BxqGmfpINuyC9xWvXo4xPA7p_oJD80NbveZlEi0-BA>
Date: Wed, 20 May 2020 15:16:24 +0900
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
To: Oscar Carter <oscar.carter@gmx.com>
Cc: Kees Cook <keescook@chromium.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	kernel-hardening@lists.openwall.com,
	linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	"Lev R . Oshvang ." <levonshe@gmail.com>
Subject: Re: [PATCH v2] firewire: Remove function callback casts
Message-ID: <20200520061624.GA25690@workstation>
Mail-Followup-To: Oscar Carter <oscar.carter@gmx.com>,
	Kees Cook <keescook@chromium.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	kernel-hardening@lists.openwall.com,
	linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	"Lev R . Oshvang ." <levonshe@gmail.com>
References: <20200519173425.4724-1-oscar.carter@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519173425.4724-1-oscar.carter@gmx.com>

Hi,

On Tue, May 19, 2020 at 07:34:25PM +0200, Oscar Carter wrote:
> In an effort to enable -Wcast-function-type in the top-level Makefile to
> support Control Flow Integrity builds, remove all the function callback
> casts.
> 
> To do this, modify the "fw_iso_context_create" function prototype adding
> a new parameter for the multichannel callback. Also, fix all the
> function calls accordingly.
> 
> In the "fw_iso_context_create" function return an error code if both
> callback parameters are NULL and also set the "ctx->callback.sc"
> explicity to NULL in this case. It is not necessary set to NULL the
> "ctx->callback.mc" variable because this and "ctx->callback.sc" are an
> union and setting one implies setting the other one to the same value.
> 
> Signed-off-by: Oscar Carter <oscar.carter@gmx.com>
> ---
> Changelog v1->v2
> -Set explicity to NULL the "ctx->callback.sc" variable and return an error
>  code in "fw_iso_context_create" function if both callback parameters are
>  NULL as Lev R. Oshvang suggested.
> -Modify the commit changelog accordingly.
> 
>  drivers/firewire/core-cdev.c        | 12 +++++++-----
>  drivers/firewire/core-iso.c         | 14 ++++++++++++--
>  drivers/firewire/net.c              |  2 +-
>  drivers/media/firewire/firedtv-fw.c |  3 ++-
>  include/linux/firewire.h            |  3 ++-
>  sound/firewire/amdtp-stream.c       |  2 +-
>  sound/firewire/isight.c             |  4 ++--
>  7 files changed, 27 insertions(+), 13 deletions(-)

I'm an author of ALSA firewire stack and thanks for the patch. I agree with
your intention to remove the cast of function callback toward CFI build.

Practically, the isochronous context with FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL
is never used by in-kernel drivers. Here, I propose to leave current
kernel API (fw_iso_context_create() with fw_iso_callback_t) as is.
Alternatively, a new kernel API for the context (e.g.
fw_iso_mc_context_create() with fw_iso_mc_callback_t). This idea leaves
current drivers as is and the change is done inner firewire-core driver,
therefore existent kernel API is not changed.

Later I post two patches for the proposal. I'd like you to review it and
I'm glad to receive your comments.


Regards

Takashi Sakamoto

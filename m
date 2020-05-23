Return-Path: <SRS0=bzQr=7F=lists.openwall.com=kernel-hardening-return-18861-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0EE7C433E0
	for <kernel-hardening@archiver.kernel.org>; Sat, 23 May 2020 06:10:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 41F20207F7
	for <kernel-hardening@archiver.kernel.org>; Sat, 23 May 2020 06:10:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="kAPKJBbB";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="o3LniShn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41F20207F7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kroah.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18861-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 6003 invoked by uid 550); 23 May 2020 06:10:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5971 invoked from network); 23 May 2020 06:10:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
	from:date:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=fm3; bh=LrrYTVFkm9x5WAtV96l5QFTVfXK
	7jcQpg5sr70HsgwE=; b=kAPKJBbB3e4aBtF2OcbBUICIud8yPLH22RFoStnp4e8
	yDZXaIlUHk0hzMRsWVU1tHFiy4j0L0oLLRjDEWOTmhX/S/kyk3zo4JPIGMqvBvu/
	pVHsRR8shbwejVVYYURo0N2WYAO0gpTmU1ZNWJ2HUmC1oVxu4P8anVPVK5dPa3D3
	VCtDB+/zUbFUwYk4BMaqAjLO9JlrzQtA/2FPzETfMh6ca94xQ5B/gQDe0te1qzXw
	/DdP9SgJLR7qZbBpupaF2rfmz2uUpswbVzE6RAxliD1hVZEC6Cxme/m7h+bltlXo
	sgi1B50yNPN4u/lqaF3ofGVVEz6iGA+UFhvCDk9u8bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LrrYTV
	Fkm9x5WAtV96l5QFTVfXK7jcQpg5sr70HsgwE=; b=o3LniShnRlpl+p+BDDClSJ
	gFgFe65lkZbszodtwx+k48xiTCURwK42S+Fty6srSnJabd4skcMtn27IN77BBB4t
	0m6wvn6WSvufHru66KSihYcVKdZmLEv188Rj/+jHrpJRk7vef08ZiRmu6xJzZeUb
	brmvvzvNucIVMlzSlDVdJOwBLrzodmiQwcIIvPxG2miwdgmgYaS1xK3qbGXy0b/B
	0gwn3JDRJH9RlFMvMAS5WoQy9X9IX7E6Zbaj4Oc+/Nc8SxPoasIiShar3D91kh21
	l8/i2gHtlYm6pgY2gXS1A6QnKUZM07e1CXyuBXaMoKSP1JNtmNR25lY6c3PjWSTg
	==
X-ME-Sender: <xms:T77IXlv6y-F4jWSN-g0qsuwh-D2FgNmSuQkyix1z2-REyP1dBZ1AQw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddugedguddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhfffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepghhrvghg
    sehkrhhorghhrdgtohhmnecuggftrfgrthhtvghrnheptdehveeuieekuddvjefhlefgke
    dugeeffeffjeetieefgfduveehfedvheeludfhnecukfhppeekfedrkeeirdekledruddt
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrh
    gvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:T77IXud2oWQcXqtjJpYSLzcm7xfysXz80uywdWroCd0IuG6WeZsNvQ>
    <xmx:T77IXoyC589Z7sLJ5OoU5m3ZDXiWXru70tkQEr2CPDnobSrWxGnt4Q>
    <xmx:T77IXsPJz4o-qG0QNang-l9w2SYk8cE6fRSpM7EiEVXr9iU2A99IVg>
    <xmx:UL7IXsVykN8rG8y8fgoGUWZ6glDMhYsF3Sub3bpYfEABCX_YO4a-ML45vUs>
From: greg@kroah.com
Date: Sat, 23 May 2020 08:10:18 +0200
To: Oscar Carter <oscar.carter@gmx.com>
Cc: stable <stable@vger.kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Kees Cook <keescook@chromium.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	kernel-hardening@lists.openwall.com,
	linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	"Lev R . Oshvang ." <levonshe@gmail.com>
Subject: Re: [PATCH v2] firewire: Remove function callback casts
Message-ID: <20200523061018.GA3131938@kroah.com>
References: <20200519173425.4724-1-oscar.carter@gmx.com>
 <20200520061624.GA25690@workstation>
 <20200522174308.GB3059@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522174308.GB3059@ubuntu>

On Fri, May 22, 2020 at 07:43:08PM +0200, Oscar Carter wrote:
> Hi,
> 
> On Wed, May 20, 2020 at 03:16:24PM +0900, Takashi Sakamoto wrote:
> > Hi,
> >
> > I'm an author of ALSA firewire stack and thanks for the patch. I agree with
> > your intention to remove the cast of function callback toward CFI build.
> >
> > Practically, the isochronous context with FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL
> > is never used by in-kernel drivers. Here, I propose to leave current
> > kernel API (fw_iso_context_create() with fw_iso_callback_t) as is.

If it's not used by anyone, why is it still there?  Can't we just delete
it?

thanks,

greg k-h

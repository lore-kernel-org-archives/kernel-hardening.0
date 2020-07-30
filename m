Return-Path: <SRS0=5yRt=BJ=lists.openwall.com=kernel-hardening-return-19491-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F5FC433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Jul 2020 07:04:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E89DE2074B
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Jul 2020 07:04:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ATVq9r2y";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="OgiJQ3sV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E89DE2074B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19491-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13837 invoked by uid 550); 30 Jul 2020 07:04:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13802 invoked from network); 30 Jul 2020 07:04:07 -0000
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1596092635;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mz+qNrmSuHhP762sVPCCbD6ZtoTLt49x/k2ylV/iW04=;
	b=ATVq9r2ySKvrHhR1Ew5gfobXzkJOa7AojOTliB75MUHbI823o3fQ0ntCWem48PvvRKqB9H
	Rt9hIre2E+faffSDe258p7pUnpiLxNrY9VnSFh5IqME+CrtiHzj9WxaiUGeZBdFpHIOAmv
	wnV7yVr+HeeHgOF9V1gPxEw/ndMBAD+sa6snxxFjk+V/ROFhMjUReFF9eq8Y2XWjuyHQdF
	6H7QimUGQoU88mR0cBx508aZtEEZImB+4c+3QuIGaiVRAuGq64btoT4du5WsNzqH7FOP2m
	IZz/+Qf17vLzhSMchX8tfx5XVjWjF9aTOve0tVRFY3jRZHZmgLJt0KbdLSrW8Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1596092635;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mz+qNrmSuHhP762sVPCCbD6ZtoTLt49x/k2ylV/iW04=;
	b=OgiJQ3sVwNFJT1r4oP0n3TmmSrJH2lyZ7rxBtMWP23shTrTVU6KuEFirMQvosT5GwEbdK2
	QqQs4lhxrmHSNbAw==
To: Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>, Allen Pais <allen.lkml@gmail.com>,
 Oscar Carter <oscar.carter@gmx.com>, Romain Perier
 <romain.perier@gmail.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
 Kevin Curtis <kevin.curtis@farsite.co.uk>, "David S. Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Harald
 Freudenberger <freude@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger
 <borntraeger@de.ibm.com>, Jiri Slaby <jslaby@suse.com>, Felipe Balbi
 <balbi@kernel.org>, Jason Wessel <jason.wessel@windriver.com>, Daniel
 Thompson <daniel.thompson@linaro.org>, Douglas Anderson
 <dianders@chromium.org>, Mitchell Blank Jr <mitch@sfgoth.com>, Julian
 Wiedmann <jwi@linux.ibm.com>, Karsten Graul <kgraul@linux.ibm.com>, Ursula
 Braun <ubraun@linux.ibm.com>, Jaroslav Kysela <perex@perex.cz>, Takashi
 Iwai <tiwai@suse.com>, Christian Gromm <christian.gromm@microchip.com>,
 Nishka Dasgupta <nishkadg.linux@gmail.com>, Masahiro Yamada
 <masahiroy@kernel.org>, Stephen Boyd <swboyd@chromium.org>, "Matthew
 Wilcox \(Oracle\)" <willy@infradead.org>, Wambui Karuga
 <wambui.karugax@gmail.com>, Guenter Roeck <linux@roeck-us.net>, Chris
 Packham <chris.packham@alliedtelesis.co.nz>, Kyungtae Kim
 <kt0755@gmail.com>, Kuppuswamy Sathyanarayanan
 <sathyanarayanan.kuppuswamy@linux.intel.com>, Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
 Jonathan Corbet <corbet@lwn.net>, Peter Zijlstra <peterz@infradead.org>,
 Will Deacon <will@kernel.org>, linux-input@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, devel@driverdev.osuosl.org,
 linux-usb@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
 alsa-devel@alsa-project.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH 0/3] Modernize tasklet callback API
In-Reply-To: <20200716030847.1564131-1-keescook@chromium.org>
References: <20200716030847.1564131-1-keescook@chromium.org>
Date: Thu, 30 Jul 2020 09:03:55 +0200
Message-ID: <87h7tpa3hg.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain

Kees,

Kees Cook <keescook@chromium.org> writes:
> This is the infrastructure changes to prepare the tasklet API for
> conversion to passing the tasklet struct as the callback argument instead
> of an arbitrary unsigned long. The first patch details why this is useful
> (it's the same rationale as the timer_struct changes from a bit ago:
> less abuse during memory corruption attacks, more in line with existing
> ways of doing things in the kernel, save a little space in struct,
> etc). Notably, the existing tasklet API use is much less messy, so there
> is less to clean up.
>
> It's not clear to me which tree this should go through... Greg since it
> starts with a USB clean-up, -tip for timer or interrupt, or if I should
> just carry it. I'm open to suggestions, but if I don't hear otherwise,
> I'll just carry it.
>
> My goal is to have this merged for v5.9-rc1 so that during the v5.10
> development cycle the new API will be available. The entire tree of
> changes is here[1] currently, but to split it up by maintainer the
> infrastructure changes need to be landed first.
>
> Review and Acks appreciated! :)

I'd rather see tasklets vanish from the planet completely, but that's
going to be a daring feat. So, grudgingly:

Acked-by: Thomas Gleixner <tglx@linutronix.de>


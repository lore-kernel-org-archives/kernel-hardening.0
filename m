Return-Path: <SRS0=u7Lh=A3=lists.openwall.com=kernel-hardening-return-19343-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83AEAC433E4
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 08:16:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BD95F2070E
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 08:16:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="UaFBKEA6";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="5Sk5Wz7P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD95F2070E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19343-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31984 invoked by uid 550); 16 Jul 2020 08:15:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31950 invoked from network); 16 Jul 2020 08:15:57 -0000
Date: Thu, 16 Jul 2020 10:15:38 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1594887345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Yn1umK+caUdMmMSNg+DEfBz4G3dj7XgdwXV/exFiYfQ=;
	b=UaFBKEA6NODD9CMCeCn4AwJJl+5Kb+eLxkOEAaardBheygNhikE3rlTYEMw5vaR51/Lawq
	7mrw/y3Z1AkwNQOP9LPdJjqePDdaFl5hWIwglIWh3mfsb2WuyFAVQIcALQM33iIyFKGFOj
	fa03u9uEJlrow8rG5a37UEKVEfdsK0ZmcBpclOT7xWQ9hH31YQZe7VjvBJv9FND71PPU45
	1K1qbauIzUgepakJxCLbRbOaMY0m7eICOmpcgqw4KVnQDM7Lkbns9Ap6g4Jqab08zfGYM1
	yr4OtcJqxtSX1gCSMt8B+famnlapOvVi1qj2ZLSe4MQSiJXSwlds1pkhkro8Jg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1594887345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Yn1umK+caUdMmMSNg+DEfBz4G3dj7XgdwXV/exFiYfQ=;
	b=5Sk5Wz7PNQjRQnpYCfpv1U5JHmR5MI/fixBOjSbTfFHFRjXeJYKxTA/HCkWq4XYLVNfwXY
	n6eqRIBMER6pBPCA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kees Cook <keescook@chromium.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Allen Pais <allen.lkml@gmail.com>,
	Oscar Carter <oscar.carter@gmx.com>,
	Romain Perier <romain.perier@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Kevin Curtis <kevin.curtis@farsite.co.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Jiri Slaby <jslaby@suse.com>, Felipe Balbi <balbi@kernel.org>,
	Jason Wessel <jason.wessel@windriver.com>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Mitchell Blank Jr <mitch@sfgoth.com>,
	Julian Wiedmann <jwi@linux.ibm.com>,
	Karsten Graul <kgraul@linux.ibm.com>,
	Ursula Braun <ubraun@linux.ibm.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	Christian Gromm <christian.gromm@microchip.com>,
	Nishka Dasgupta <nishkadg.linux@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Stephen Boyd <swboyd@chromium.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Wambui Karuga <wambui.karugax@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Kyungtae Kim <kt0755@gmail.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Jonathan Corbet <corbet@lwn.net>, Will Deacon <will@kernel.org>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, linux-s390@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
	kgdb-bugreport@lists.sourceforge.net, alsa-devel@alsa-project.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH 0/3] Modernize tasklet callback API
Message-ID: <20200716081538.2sivhkj4hcyrusem@linutronix.de>
References: <20200716030847.1564131-1-keescook@chromium.org>
 <20200716075718.GM10769@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200716075718.GM10769@hirez.programming.kicks-ass.net>

On 2020-07-16 09:57:18 [+0200], Peter Zijlstra wrote:
> 
> there appear to be hardly any users left.. Can't we stage an extinction
> event here instead?

Most of the time the tasklet is scheduled from an interrupt handler. So
we could get rid of these tasklets by using threaded IRQs.

Sebastian

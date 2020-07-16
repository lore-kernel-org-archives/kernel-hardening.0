Return-Path: <SRS0=oFci=A3=lists.openwall.com=kernel-hardening-return-19359-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2813C433E3
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 19:15:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0C42C2065F
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 19:15:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="GFAY7/qF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C42C2065F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19359-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3097 invoked by uid 550); 16 Jul 2020 19:15:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 2041 invoked from network); 16 Jul 2020 19:15:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DmwAjlYrRkrceLF5k8BiY0q5EpRy1ms1f0jDcB2PX04=;
        b=GFAY7/qFyIYdH5WwlOR6lmpQdUB8pidv4p+YEiNNV+24D6QE2wlS74FWkZdBInZexv
         UOIim5XchmtCaZ3l4TQzzuOzonn1fB1BUMbSjBEdmwtfVzMcmZFxfBS2TADWV5S1ZbJV
         +LUOh6KntXrSBKz4ZwAcXC+80++YNoPqG5L4s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DmwAjlYrRkrceLF5k8BiY0q5EpRy1ms1f0jDcB2PX04=;
        b=Q7tyr0R395JMa1Ciy5AWI6HlkTfjTWsLCdFU67IE3XYydV8uZGP304LkaJ9qh3RiQ2
         Lpwcbj9ebDKXgAbcNrltSmIM/Mt7JTSpe7oZrHSvMbi+tdWOOU1aM88UN78Wem46qAFp
         d/qqmlggUZafx9d0/920dJtixGLsgsX4nxPzfMMFcnW0uLcZI8i2w5tseZRyV6R6J7QO
         9wGu8XtUWl19xYozZ2De67xjETFQU0z6IqyJXUjfrkdgDcYo0Sr7HXvhtQPNL6naxWnB
         5xqSBwwDTxkggLTReyfLJYNWCiVTXC/7MX5TTSKv8NXJN6lETHl5WZp2OVjsGhzRRTRy
         G6yw==
X-Gm-Message-State: AOAM5300LtBsrZ4R5Izl0D5aspn2uKDDqII8WYtY3uLTU6ODjijYDUmI
	x5SO5HAlzi0JZhVLZFzf31VbFQ==
X-Google-Smtp-Source: ABdhPJzXMzbyTY5VJHPd4Edm3bSGjXJUJOwIzo3RSPKyMSZOc846WSYGarDg6OCvj6pUTCBmbdFM0Q==
X-Received: by 2002:a17:90a:318c:: with SMTP id j12mr6129543pjb.25.1594926888230;
        Thu, 16 Jul 2020 12:14:48 -0700 (PDT)
Date: Thu, 16 Jul 2020 12:14:46 -0700
From: Kees Cook <keescook@chromium.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Jonathan Corbet <corbet@lwn.net>, Will Deacon <will@kernel.org>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, linux-s390@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
	kgdb-bugreport@lists.sourceforge.net, alsa-devel@alsa-project.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH 0/3] Modernize tasklet callback API
Message-ID: <202007161214.102F6E6@keescook>
References: <20200716030847.1564131-1-keescook@chromium.org>
 <20200716075718.GM10769@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716075718.GM10769@hirez.programming.kicks-ass.net>

On Thu, Jul 16, 2020 at 09:57:18AM +0200, Peter Zijlstra wrote:
> On Wed, Jul 15, 2020 at 08:08:44PM -0700, Kees Cook wrote:
> > Hi,
> > 
> > This is the infrastructure changes to prepare the tasklet API for
> > conversion to passing the tasklet struct as the callback argument instead
> > of an arbitrary unsigned long. The first patch details why this is useful
> > (it's the same rationale as the timer_struct changes from a bit ago:
> > less abuse during memory corruption attacks, more in line with existing
> > ways of doing things in the kernel, save a little space in struct,
> > etc). Notably, the existing tasklet API use is much less messy, so there
> > is less to clean up.
> 
> I would _MUCH_ rather see tasklets go the way of the dodo, esp. given
> that:
> 
> >  drivers/input/keyboard/omap-keypad.c   |  2 +-
> >  drivers/input/serio/hil_mlc.c          |  2 +-
> >  drivers/net/wan/farsync.c              |  4 +--
> >  drivers/s390/crypto/ap_bus.c           |  2 +-
> >  drivers/staging/most/dim2/dim2.c       |  2 +-
> >  drivers/staging/octeon/ethernet-tx.c   |  2 +-
> >  drivers/tty/vt/keyboard.c              |  2 +-
> >  drivers/usb/gadget/udc/snps_udc_core.c |  6 ++---
> >  drivers/usb/host/fhci-sched.c          |  2 +-
> >  include/linux/interrupt.h              | 37 ++++++++++++++++++++++----
> >  kernel/backtracetest.c                 |  2 +-
> >  kernel/debug/debug_core.c              |  2 +-
> >  kernel/irq/resend.c                    |  2 +-
> >  kernel/softirq.c                       | 18 ++++++++++++-
> >  net/atm/pppoatm.c                      |  2 +-
> >  net/iucv/iucv.c                        |  2 +-
> >  sound/drivers/pcsp/pcsp_lib.c          |  2 +-
> >  17 files changed, 66 insertions(+), 25 deletions(-)
> 
> there appear to be hardly any users left.. Can't we stage an extinction
> event here instead?

Oh, I wish, but no. That's just the ones using DECLARE_TASKLET. There
are hundred(s?) more (see the referenced tree).

-- 
Kees Cook

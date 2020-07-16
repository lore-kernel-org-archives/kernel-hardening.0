Return-Path: <SRS0=eXXT=A3=lists.openwall.com=kernel-hardening-return-19370-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11449C433E5
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 21:24:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 33A8720787
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 21:24:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="g8LC2DWS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33A8720787
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19370-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1888 invoked by uid 550); 16 Jul 2020 21:24:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1853 invoked from network); 16 Jul 2020 21:24:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GuRiIW4nk04qSodan0OUo2QjHoiXfRAFsMTlj/9iRXw=;
        b=g8LC2DWSxvHGrs2YfNgqk3VpuTWmyx3EVdSYPeLpfd8l0h3R8fxuksSBwA40ai4ADZ
         kvo6yqRa0fHbA8eJUx9ZhH7+OM1Pi2G/tAj5fqTQQNaJxqtiMUti5yjEE1XiAduQJjm5
         0svDx9VcKd8b8SNp5t3SPolgR9wFDAMRS57OI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GuRiIW4nk04qSodan0OUo2QjHoiXfRAFsMTlj/9iRXw=;
        b=MkrIcXfHVu9i5tCj5BDoyNFEcUxQnxTrUEED+RMYQ5mQCGKObuuPcpFOU+XyuH/EvF
         16TtBzazGxmPjWOVVoChWPXtGOV17lba9aCWB5GuyRvj+cKcnDu75UY1xqIrSuML+DfT
         /xyjtfL3+nFF1nQXakGAPBZrDRK7+pneYVfg3BQoh/7SZmwRVsxotDk2sPoX3oMjZnIe
         JAm/RkuysnZ/QvOOjPCLS1zhTcChMTQxvo+4pNEagJ9DXANAzy9HJRztE3bF3Bb1iilr
         pL+4Ua0dfrUcFi+2EWTswbM2K/qGUYrhstH0iIQ+GB8GBvKDKAyAUNe3tWrA/9CyGsv+
         iWYA==
X-Gm-Message-State: AOAM531ZOVLWpCt5O3maLfi8lYMp9U4H8PSKbjnux52phVbUBNN+Ir2b
	VErl2uQveReSdsXMLZLwqFRGvg==
X-Google-Smtp-Source: ABdhPJyP3qLO1Y3SOoBLYTFQL4BEKccE2HwZrJKw7OBU3VgLMhd+dox46Tq8jY21pcPLVhtrgaAB+g==
X-Received: by 2002:a17:90a:1089:: with SMTP id c9mr6859603pja.180.1594934662399;
        Thu, 16 Jul 2020 14:24:22 -0700 (PDT)
Date: Thu, 16 Jul 2020 14:24:20 -0700
From: Kees Cook <keescook@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Allen Pais <allen.lkml@gmail.com>,
	Oscar Carter <oscar.carter@gmx.com>,
	Romain Perier <romain.perier@gmail.com>,
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
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>, linux-s390@vger.kernel.org,
	devel@driverdev.osuosl.org, USB list <linux-usb@vger.kernel.org>,
	kgdb-bugreport@lists.sourceforge.net,
	"alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH 0/3] Modernize tasklet callback API
Message-ID: <202007161416.9C1B8F3D26@keescook>
References: <20200716030847.1564131-1-keescook@chromium.org>
 <20200716075718.GM10769@hirez.programming.kicks-ass.net>
 <202007161214.102F6E6@keescook>
 <CAKdAkRQHRobiG-RpifyrAmV9ENgENn_woPBVXpRrhKwRBf9Esw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKdAkRQHRobiG-RpifyrAmV9ENgENn_woPBVXpRrhKwRBf9Esw@mail.gmail.com>

On Thu, Jul 16, 2020 at 01:48:20PM -0700, Dmitry Torokhov wrote:
> On Thu, Jul 16, 2020 at 12:14 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Thu, Jul 16, 2020 at 09:57:18AM +0200, Peter Zijlstra wrote:
> > > On Wed, Jul 15, 2020 at 08:08:44PM -0700, Kees Cook wrote:
> > > > Hi,
> > > >
> > > > This is the infrastructure changes to prepare the tasklet API for
> > > > conversion to passing the tasklet struct as the callback argument instead
> > > > of an arbitrary unsigned long. The first patch details why this is useful
> > > > (it's the same rationale as the timer_struct changes from a bit ago:
> > > > less abuse during memory corruption attacks, more in line with existing
> > > > ways of doing things in the kernel, save a little space in struct,
> > > > etc). Notably, the existing tasklet API use is much less messy, so there
> > > > is less to clean up.
> > >
> > > I would _MUCH_ rather see tasklets go the way of the dodo, esp. given
> > > that:
> > >
> > > >  drivers/input/keyboard/omap-keypad.c   |  2 +-
> > > >  drivers/input/serio/hil_mlc.c          |  2 +-
> > > >  drivers/net/wan/farsync.c              |  4 +--
> > > >  drivers/s390/crypto/ap_bus.c           |  2 +-
> > > >  drivers/staging/most/dim2/dim2.c       |  2 +-
> > > >  drivers/staging/octeon/ethernet-tx.c   |  2 +-
> > > >  drivers/tty/vt/keyboard.c              |  2 +-
> > > >  drivers/usb/gadget/udc/snps_udc_core.c |  6 ++---
> > > >  drivers/usb/host/fhci-sched.c          |  2 +-
> > > >  include/linux/interrupt.h              | 37 ++++++++++++++++++++++----
> > > >  kernel/backtracetest.c                 |  2 +-
> > > >  kernel/debug/debug_core.c              |  2 +-
> > > >  kernel/irq/resend.c                    |  2 +-
> > > >  kernel/softirq.c                       | 18 ++++++++++++-
> > > >  net/atm/pppoatm.c                      |  2 +-
> > > >  net/iucv/iucv.c                        |  2 +-
> > > >  sound/drivers/pcsp/pcsp_lib.c          |  2 +-
> > > >  17 files changed, 66 insertions(+), 25 deletions(-)
> > >
> > > there appear to be hardly any users left.. Can't we stage an extinction
> > > event here instead?
> >
> > Oh, I wish, but no. That's just the ones using DECLARE_TASKLET. There
> > are hundred(s?) more (see the referenced tree).
> 
> Still, do we really need tasklets? Can we substitute timers executing
> immediately in their place?

If there is a direct replacement, then sure, I'd be happy to do
whatever, however it does not look mechanical to me. If there is a
mechanical way that will convert these two directories (as an example of
various complexities):

drivers/crypto/ccp/
drivers/gpu/drm/i915/gt/

then let's get it documented. But if not, let's write up a paragraph for
the deprecated.rst, mark it as deprecated in comments, and modernize the
API (which is a mostly mechanical change) to avoid it being a problem
for CFI, for memory corruption, and heap space, etc.

-- 
Kees Cook

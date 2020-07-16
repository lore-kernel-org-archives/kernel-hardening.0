Return-Path: <SRS0=MxP8=A3=lists.openwall.com=kernel-hardening-return-19367-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F84C433E2
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 20:51:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9CA9A20809
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 20:51:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CLn8nEZ9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9CA9A20809
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19367-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16306 invoked by uid 550); 16 Jul 2020 20:51:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13436 invoked from network); 16 Jul 2020 20:48:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E+1tVGknt5yYZ8eT3cfGaVP/Gx6TNLloqdwWVn2c4ZM=;
        b=CLn8nEZ9Umx3u1uxQ6iB8vnvAwGkRUs5ZG9EfQL8CJiHvyLP8M7b6NUIAKo+LBuY4f
         8/9k4vjIky1k6ccVtwc1XCLpJ9OIXcaSnSgOd0xYtfqQA5VkwUEJhpc/XojQNud255Fp
         CS65GQl3KtSyU2zn3gjZRqpQReiLPt5Jdwt/SCKKel4uYCiyIFetSEXJKpr/nhCoi0IP
         Fh7/R7sRei2OUkuvv/y1qWAnzOrzRAxFmPwXU3sJhnRHuwo9BC1LeRHApdtIROKUBM0Y
         PuMZgqnjotBdORPgdDy9QbhiTqpBvHJsERxZbAO44L6pd99V8/cw6eA29lB/55EAquIA
         5X2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E+1tVGknt5yYZ8eT3cfGaVP/Gx6TNLloqdwWVn2c4ZM=;
        b=lo2n0RM2xt2zX5HQvkHs9VlDkxecobH11c5iCE/I1kgTBaClw5uxnAAKRRkLtiCYaR
         ej15VU1TAyt/Ky4QfXSnnuM93MB8NECtBGJ5uJyv31lSPzZVKUtZlC1ZT1O2k/15mU8d
         /xCF37E3MmR0A8EbXS274Tka+Si5LnHB73bWqQyAWOYj6bhxIUALNtp2gyGWfI2yNdT/
         K3Xv+PCqdM4s1iq9TXd0d/bT2lUtYh4YDEZVwAEEmzyf9zktIMUC65YbhB10pweqK63J
         O/CxO57hqJZDO54E3azVX3OdvG4Jej4GzsLpWes9nB03hTGSg64zdFXWRr3D6wn35wR9
         LCVA==
X-Gm-Message-State: AOAM5326RD8NXu5yMoJUE7SVG/uhsFG6+kEVxL23bkMHUwMSaqzM1mWq
	r4Sz/m30oCC/X9ZiXBCiYK+mYmly8FkjQqmmR/8=
X-Google-Smtp-Source: ABdhPJzpsbm7TwGhHG6RzXDqgC6/209E5TMuTQBViDF3W3srNDclU8jiNSeIW3HzQAj2kQTZKYQslP0k+o4Ij2ZF6uA=
X-Received: by 2002:a5d:9c0e:: with SMTP id 14mr6302830ioe.109.1594932511887;
 Thu, 16 Jul 2020 13:48:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200716030847.1564131-1-keescook@chromium.org>
 <20200716075718.GM10769@hirez.programming.kicks-ass.net> <202007161214.102F6E6@keescook>
In-Reply-To: <202007161214.102F6E6@keescook>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Thu, 16 Jul 2020 13:48:20 -0700
Message-ID: <CAKdAkRQHRobiG-RpifyrAmV9ENgENn_woPBVXpRrhKwRBf9Esw@mail.gmail.com>
Subject: Re: [PATCH 0/3] Modernize tasklet callback API
To: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Allen Pais <allen.lkml@gmail.com>, 
	Oscar Carter <oscar.carter@gmx.com>, Romain Perier <romain.perier@gmail.com>, 
	Kevin Curtis <kevin.curtis@farsite.co.uk>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Harald Freudenberger <freude@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@de.ibm.com>, Jiri Slaby <jslaby@suse.com>, 
	Felipe Balbi <balbi@kernel.org>, Jason Wessel <jason.wessel@windriver.com>, 
	Daniel Thompson <daniel.thompson@linaro.org>, Douglas Anderson <dianders@chromium.org>, 
	Mitchell Blank Jr <mitch@sfgoth.com>, Julian Wiedmann <jwi@linux.ibm.com>, 
	Karsten Graul <kgraul@linux.ibm.com>, Ursula Braun <ubraun@linux.ibm.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Christian Gromm <christian.gromm@microchip.com>, Nishka Dasgupta <nishkadg.linux@gmail.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Stephen Boyd <swboyd@chromium.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Wambui Karuga <wambui.karugax@gmail.com>, 
	Guenter Roeck <linux@roeck-us.net>, Chris Packham <chris.packham@alliedtelesis.co.nz>, 
	Kyungtae Kim <kt0755@gmail.com>, 
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, Will Deacon <will@kernel.org>, 
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, 
	netdev <netdev@vger.kernel.org>, linux-s390@vger.kernel.org, 
	devel@driverdev.osuosl.org, USB list <linux-usb@vger.kernel.org>, 
	kgdb-bugreport@lists.sourceforge.net, 
	"alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>, kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 16, 2020 at 12:14 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Jul 16, 2020 at 09:57:18AM +0200, Peter Zijlstra wrote:
> > On Wed, Jul 15, 2020 at 08:08:44PM -0700, Kees Cook wrote:
> > > Hi,
> > >
> > > This is the infrastructure changes to prepare the tasklet API for
> > > conversion to passing the tasklet struct as the callback argument instead
> > > of an arbitrary unsigned long. The first patch details why this is useful
> > > (it's the same rationale as the timer_struct changes from a bit ago:
> > > less abuse during memory corruption attacks, more in line with existing
> > > ways of doing things in the kernel, save a little space in struct,
> > > etc). Notably, the existing tasklet API use is much less messy, so there
> > > is less to clean up.
> >
> > I would _MUCH_ rather see tasklets go the way of the dodo, esp. given
> > that:
> >
> > >  drivers/input/keyboard/omap-keypad.c   |  2 +-
> > >  drivers/input/serio/hil_mlc.c          |  2 +-
> > >  drivers/net/wan/farsync.c              |  4 +--
> > >  drivers/s390/crypto/ap_bus.c           |  2 +-
> > >  drivers/staging/most/dim2/dim2.c       |  2 +-
> > >  drivers/staging/octeon/ethernet-tx.c   |  2 +-
> > >  drivers/tty/vt/keyboard.c              |  2 +-
> > >  drivers/usb/gadget/udc/snps_udc_core.c |  6 ++---
> > >  drivers/usb/host/fhci-sched.c          |  2 +-
> > >  include/linux/interrupt.h              | 37 ++++++++++++++++++++++----
> > >  kernel/backtracetest.c                 |  2 +-
> > >  kernel/debug/debug_core.c              |  2 +-
> > >  kernel/irq/resend.c                    |  2 +-
> > >  kernel/softirq.c                       | 18 ++++++++++++-
> > >  net/atm/pppoatm.c                      |  2 +-
> > >  net/iucv/iucv.c                        |  2 +-
> > >  sound/drivers/pcsp/pcsp_lib.c          |  2 +-
> > >  17 files changed, 66 insertions(+), 25 deletions(-)
> >
> > there appear to be hardly any users left.. Can't we stage an extinction
> > event here instead?
>
> Oh, I wish, but no. That's just the ones using DECLARE_TASKLET. There
> are hundred(s?) more (see the referenced tree).

Still, do we really need tasklets? Can we substitute timers executing
immediately in their place?

Thanks.

-- 
Dmitry

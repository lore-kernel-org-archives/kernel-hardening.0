Return-Path: <SRS0=s7Gc=A3=lists.openwall.com=kernel-hardening-return-19361-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF657C433EA
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 19:22:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1D8B42074B
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 19:22:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="IdV9MqF3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D8B42074B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19361-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7649 invoked by uid 550); 16 Jul 2020 19:22:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7616 invoked from network); 16 Jul 2020 19:22:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JkQIL6u1DfVeBakkxVv5TexNPiL0IlLMXUBOxPWyZ5M=;
        b=IdV9MqF3NgA5zvwc0WHh4MUmPJhoVdGBqF7mZzHR1z6W9+79kwebX37Odvx1RFYyD5
         TIcAItmVFebIbr0UGDR1VqZORhkkWg5GO3jP9SrAYBb/J9j1gAl6NCCYq5DxGfdZceJ5
         eJbQvOJJgIUB/uLUSvyqfC/7mWDvVcN1kqTj8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JkQIL6u1DfVeBakkxVv5TexNPiL0IlLMXUBOxPWyZ5M=;
        b=rVHJlKvVwR2DzUbolVSge6z1fJzJ7S9jlXy4UVfgmavayCwjYUua45VljckRHFXpcO
         fnmlAtiuaMdgmmSJ85KPV53PseDy45D+upfQo4NRui8aIMUsM7KC+9CgtDa1FGtPmaln
         CwVsk9XSjm//qc75GQlmuzDBPSRH4FXmZ9QurP76smVNle2TvV2xC1mMkzbSqK4qS4T2
         rsuDdS2tAywKmkftYtFP7tSHtBGRSel+KVSGmcAnfdRkE6xR7ZSs0TKchPr7AAkGvNgW
         d1tfY5ownnLtICHOXdO7pDJULJwqjgodFM3RmnxN04HZF24d+BfA1gLfAN5yxsfoJezz
         w4Vw==
X-Gm-Message-State: AOAM533DL0SUMDcMAA3iFfC4qPucS5V+pJulycPV6WAgJz4+1fZB0/vo
	h+l8d3js0v7l2Bmrs0EZfLh2UQ==
X-Google-Smtp-Source: ABdhPJxnO0DLJTMuJCiKhGS2H/q0Dgh7D9XNeLpL7v+ETZT1fO0LQZze/EzzJLe1PvzD9lREJpkfEA==
X-Received: by 2002:a17:90a:1901:: with SMTP id 1mr6710009pjg.199.1594927339413;
        Thu, 16 Jul 2020 12:22:19 -0700 (PDT)
Date: Thu, 16 Jul 2020 12:22:17 -0700
From: Kees Cook <keescook@chromium.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Romain Perier <romain.perier@gmail.com>,
	Allen Pais <allen.lkml@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Oscar Carter <oscar.carter@gmx.com>,
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
	Wambui Karuga <wambui.karugax@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Kyungtae Kim <kt0755@gmail.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Peter Zijlstra <peterz@infradead.org>,
	Will Deacon <will@kernel.org>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-s390@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-usb@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
	alsa-devel@alsa-project.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH 3/3] tasklet: Introduce new initialization API
Message-ID: <202007161216.9C9784FEBE@keescook>
References: <20200716030847.1564131-1-keescook@chromium.org>
 <20200716030847.1564131-4-keescook@chromium.org>
 <20200716153704.GM12769@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716153704.GM12769@casper.infradead.org>

On Thu, Jul 16, 2020 at 04:37:04PM +0100, Matthew Wilcox wrote:
> On Wed, Jul 15, 2020 at 08:08:47PM -0700, Kees Cook wrote:
> > +#define DECLARE_TASKLET(name, _callback)		\
> > +struct tasklet_struct name = {				\
> > +	.count = ATOMIC_INIT(0),			\
> > +	.callback = _callback,				\
> > +	.use_callback = true,				\
> > +}
> > +
> > +#define DECLARE_TASKLET_DISABLED(name, _callback)	\
> > +struct tasklet_struct name = {				\
> > +	.count = ATOMIC_INIT(1),			\
> > +	.callback = _callback,				\
> > +}
> 
> You forgot to set use_callback here.

Eek; thank you.

> > @@ -547,7 +547,10 @@ static void tasklet_action_common(struct softirq_action *a,
> >  				if (!test_and_clear_bit(TASKLET_STATE_SCHED,
> >  							&t->state))
> >  					BUG();
> > -				t->func(t->data);
> > +				if (t->use_callback)
> > +					t->callback(t);
> > +				else
> > +					t->func(t->data);
> 
> I think this is the wrong way to do the conversion.  Start out by setting
> t->data to (unsigned long)t in the new initialisers.  Then convert the
> drivers (all 350 of them) to the new API.  Then you can get rid of 'data'
> from the tasklet_struct.

That's what I did when I converted timer_struct, and it ended up creating
a mess for Control Flow Integrity checking. (The problem isn't actually
casting .data, but rather in how the callsite calls the callback --
casting the callback assignments doesn't fix the mismatch between the
caller and the callback's expectation about the function prototype
under CFI.) I got lucky with timer_struct (in v4.14) in that not much
had been converted, and I was able to do the entire conversion in the
next kernel release.

So, this time, I'm trying to avoid the prototype mismatch mess by
providing a selector to determine which prototype the callback should
be called through, and I was happy to discover I could do it without
growing the tasklet structure. Obviously the memory corruption safety
improvement won't be realized until both .data, .use_callback, and .func
are removed, but that was true even with the earlier style of conversion.

-- 
Kees Cook

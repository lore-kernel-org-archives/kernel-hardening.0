Return-Path: <SRS0=OHjJ=A3=lists.openwall.com=kernel-hardening-return-19360-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2744C433E2
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 19:16:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 280132076D
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 19:16:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ZBulK0WZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 280132076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19360-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 4033 invoked by uid 550); 16 Jul 2020 19:16:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3999 invoked from network); 16 Jul 2020 19:16:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2R0hcRnXsJS4VXyiriDanEq/mQczbWkrFO+xv3Ye6s4=;
        b=ZBulK0WZzf/Y2plsJIiBiP9vBDDMB7cKE4nNyO7pI4jhAiFahLl13+wjjYl4AYx5BB
         otJeoT7KMXmj//B0s5TndSWJM7ep3jPNHzKSwrpR80GkT/ENBrVdogHDfc7FSXQgqchK
         la7hTG8ks3MzuTa72KfZtSagY7XpH9MYfx1mQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2R0hcRnXsJS4VXyiriDanEq/mQczbWkrFO+xv3Ye6s4=;
        b=kxgdtVcVHlYH8ag7Mi0WKZSwTuVHujLXlndzzqHKuReMePM3R3ottuaT6YBvR4Deav
         S2vHGscO2N5/3/qhWWPLLc3tL/xTQf9cB3TUzvTKfcu2vHvblTtuxBITxiSzD0POFktI
         6/XSN8wcXqOh9EUmMk9y2HpixvtKQXfLlYHII1uRicb85WLGTzwZL98FbVkXLZv8UsP8
         O4Hk7HmVKnLATRF787v0HM8yenpWwRecz7tBl5wrakLkPWPLUjfV0hA/YfQJbeDp+ROk
         xOjzWC5Dcr0/Pj7ZTS02mWF5X8r6xawFRi6CcLrBujrfqcDPwaSOnMjOP5ARnkh6vScr
         eijg==
X-Gm-Message-State: AOAM530cowoFaP7w4Ph3kMJw7983bjSILn/4i9qzLpmjBzAEEIjw/bRM
	vTON+anBiRldKwkJBljanSgjCA==
X-Google-Smtp-Source: ABdhPJz1hoi+gTw0MHgO0dM+96Dp9MZSCNtNi6/yuZgpSobcItifHoGm+Bd2+MNyMCABANHPmkEEMg==
X-Received: by 2002:a65:664a:: with SMTP id z10mr5423029pgv.352.1594926957331;
        Thu, 16 Jul 2020 12:15:57 -0700 (PDT)
Date: Thu, 16 Jul 2020 12:15:55 -0700
From: Kees Cook <keescook@chromium.org>
To: Matthew Wilcox <willy@infradead.org>
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
Subject: Re: [PATCH 2/3] treewide: Replace DECLARE_TASKLET() with
 DECLARE_TASKLET_OLD()
Message-ID: <202007161215.5C0CE54AB@keescook>
References: <20200716030847.1564131-1-keescook@chromium.org>
 <20200716030847.1564131-3-keescook@chromium.org>
 <20200716112914.GK12769@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716112914.GK12769@casper.infradead.org>

On Thu, Jul 16, 2020 at 12:29:14PM +0100, Matthew Wilcox wrote:
> On Wed, Jul 15, 2020 at 08:08:46PM -0700, Kees Cook wrote:
> > This converts all the existing DECLARE_TASKLET() (and ...DISABLED)
> > macros with DECLARE_TASKLET_OLD() in preparation for refactoring the
> > tasklet callback type. All existing DECLARE_TASKLET() users had a "0"
> > data argument, it has been removed here as well.
> > 
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> [...]
> >  16 files changed, 26 insertions(+), 21 deletions(-)
> 
> This is about 5% of what needs to change.  There are 350 callers of
> tasklet_init(), and that still takes a 'data' argument.

Yup, please see the referenced tree. This "series" is just the
ground-work for allowing the rest of the 350 patches to land with calls
to the new tasklet_setup() API, and associated prototype and
container_of() changes.

-- 
Kees Cook

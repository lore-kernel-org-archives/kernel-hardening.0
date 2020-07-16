Return-Path: <SRS0=CpBq=A3=lists.openwall.com=kernel-hardening-return-19362-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7727EC433E3
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 19:24:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C48C32074B
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 19:24:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="MoeXRncz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C48C32074B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19362-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9643 invoked by uid 550); 16 Jul 2020 19:24:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9611 invoked from network); 16 Jul 2020 19:24:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IO5rF0v38hkORnZpPQ2np7PkHTT7l3o2Frf1znSvMCA=;
        b=MoeXRnczoJvOTiX060NRDer3ic+Z0a6OAKDDzvlghJHJsuwLM+IhpBPYCW1h0hZNZh
         Fr5kyGgY0/SatP2EZptwciRkxUEZBeWULPC9tbngCSgNOCvd0NXvOeL8OmnqU6ynZicD
         iZLZdIgB2wXCD8oLjuasdEEdCIEAfOKV/ccMk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IO5rF0v38hkORnZpPQ2np7PkHTT7l3o2Frf1znSvMCA=;
        b=EpJxtSbwOmovIvJgsZPBrMfW+pgRx1YD6e3thk89nf+8tVlqcpsIU1NX00dyoG9Bl9
         7KdFuw+Fkj7qNl3lHmNfQLKqjQtOeEFwOAxCa8PX+/gFGmKQN8GOuPoZYlWKsz/1JWht
         sHohGTqu0rdSR9pgW77KsrKsgR3h/vk5x/23j7pBbm3IC60QZNFZby3tiyQyWL6WC6lO
         jOyak3FTza4zmM0eFnv8KDVT+cqrMEvd3kfHL7kdY1lG0q5ufOiVQ73NTJjF7PnChkA9
         z+/438BhOie2AO3S282NH0xqzvA2v1M2ZYSqd+JzWXUSVJHOKYzQTMgYgR8xobJmGMnB
         eFTw==
X-Gm-Message-State: AOAM531U8lkhctlim16CbFBF9RLKMBcv7yYXbTuSlPboOOck7QeMIfFp
	yS07N4nlBrgBKusPw57F48WVVQ==
X-Google-Smtp-Source: ABdhPJy0sUnqF9h52WMr6418CCHExwqoVmt3MmuGhwouhxSV6Mqarvy7mOWSh3mLcM/3Qo2Kub5J7g==
X-Received: by 2002:a17:90a:d30c:: with SMTP id p12mr6742185pju.4.1594927454098;
        Thu, 16 Jul 2020 12:24:14 -0700 (PDT)
Date: Thu, 16 Jul 2020 12:24:12 -0700
From: Kees Cook <keescook@chromium.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <202007161223.19FB352B5@keescook>
References: <20200716030847.1564131-1-keescook@chromium.org>
 <20200716075718.GM10769@hirez.programming.kicks-ass.net>
 <20200716081538.2sivhkj4hcyrusem@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716081538.2sivhkj4hcyrusem@linutronix.de>

On Thu, Jul 16, 2020 at 10:15:38AM +0200, Sebastian Andrzej Siewior wrote:
> On 2020-07-16 09:57:18 [+0200], Peter Zijlstra wrote:
> > 
> > there appear to be hardly any users left.. Can't we stage an extinction
> > event here instead?
> 
> Most of the time the tasklet is scheduled from an interrupt handler. So
> we could get rid of these tasklets by using threaded IRQs.

Perhaps I can add a comment above the tasklet API area in interrupt.h?

-- 
Kees Cook

Return-Path: <SRS0=X9Qw=A3=lists.openwall.com=kernel-hardening-return-19356-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A8D1C433E1
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 15:38:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C9A882076A
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 15:38:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="blVXROz0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9A882076A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19356-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17620 invoked by uid 550); 16 Jul 2020 15:38:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17588 invoked from network); 16 Jul 2020 15:38:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=o6oHT2rpgf0cErqSO7RynM1ahrdcZBKx58Lp4xYSPqk=; b=blVXROz0kqPs9WT7AReAWRXnaN
	giDr3C3VPp7qAB5MirGN6Ghar0/xZ6skZ2oTHZrIQnlWV0t6l172otR7fmoceWN/3Omnm1QChvIMq
	v24J9raPRCn37XZp1iaolfjuwtv7Xbf1SjhRG2+phHG2UAzWRhI9WhvuDp7GGNLuphLQb40yeLPn3
	CQvkTsWNMP4QZfiCDKNmVfer2n52y/giQdVBQQgnlCxKQCaxItNDXKZ4xi8RomDl1v2I45h76ddYe
	874YANmm/lqvFG5LUaTOLCBGOMdHl/R06HcEWCdFmgnxvTEFvwNCpVE7mt6U4f8u6oQtVOhd7dG0R
	/sE940zQ==;
Date: Thu, 16 Jul 2020 16:37:04 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Kees Cook <keescook@chromium.org>
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
Message-ID: <20200716153704.GM12769@casper.infradead.org>
References: <20200716030847.1564131-1-keescook@chromium.org>
 <20200716030847.1564131-4-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716030847.1564131-4-keescook@chromium.org>

On Wed, Jul 15, 2020 at 08:08:47PM -0700, Kees Cook wrote:
> +#define DECLARE_TASKLET(name, _callback)		\
> +struct tasklet_struct name = {				\
> +	.count = ATOMIC_INIT(0),			\
> +	.callback = _callback,				\
> +	.use_callback = true,				\
> +}
> +
> +#define DECLARE_TASKLET_DISABLED(name, _callback)	\
> +struct tasklet_struct name = {				\
> +	.count = ATOMIC_INIT(1),			\
> +	.callback = _callback,				\
> +}

You forgot to set use_callback here.

> @@ -547,7 +547,10 @@ static void tasklet_action_common(struct softirq_action *a,
>  				if (!test_and_clear_bit(TASKLET_STATE_SCHED,
>  							&t->state))
>  					BUG();
> -				t->func(t->data);
> +				if (t->use_callback)
> +					t->callback(t);
> +				else
> +					t->func(t->data);

I think this is the wrong way to do the conversion.  Start out by setting
t->data to (unsigned long)t in the new initialisers.  Then convert the
drivers (all 350 of them) to the new API.  Then you can get rid of 'data'
from the tasklet_struct.


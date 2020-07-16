Return-Path: <SRS0=BqMe=A3=lists.openwall.com=kernel-hardening-return-19341-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB2A7C433E5
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 07:31:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2C5F62071B
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 07:31:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="xXkGscLL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C5F62071B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19341-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9561 invoked by uid 550); 16 Jul 2020 07:31:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9529 invoked from network); 16 Jul 2020 07:31:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594884658;
	bh=CTWyxPTHWyxqgMnm+vWIXeBCmqZkbSrc0AEZhda/f10=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xXkGscLLek9N9EogKr6n85j7W6mDu9jr4loE95Kn/BePJVkVdXfeQmIC64S/1jTBK
	 opn+bStcloxvD+/LOq6UBHLCu5pkeVSMcrvbGymLF6xbmCWu9p6nX8eDaey4wUAQCY
	 h8K057x1JyJ9ns50hganKtjoBLO8cmbEyUwND05U=
Date: Thu, 16 Jul 2020 09:30:52 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Oscar Carter <oscar.carter@gmx.com>,
	Mitchell Blank Jr <mitch@sfgoth.com>,
	kernel-hardening@lists.openwall.com,
	Peter Zijlstra <peterz@infradead.org>,
	kgdb-bugreport@lists.sourceforge.net,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	alsa-devel@alsa-project.org, Allen Pais <allen.lkml@gmail.com>,
	Christian Gromm <christian.gromm@microchip.com>,
	Will Deacon <will@kernel.org>, devel@driverdev.osuosl.org,
	Jonathan Corbet <corbet@lwn.net>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Takashi Iwai <tiwai@suse.com>, Julian Wiedmann <jwi@linux.ibm.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Nishka Dasgupta <nishkadg.linux@gmail.com>,
	Jiri Slaby <jslaby@suse.com>, Jakub Kicinski <kuba@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Wambui Karuga <wambui.karugax@gmail.com>,
	Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
	linux-input@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>,
	Stephen Boyd <swboyd@chromium.org>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jaroslav Kysela <perex@perex.cz>, Felipe Balbi <balbi@kernel.org>,
	Kyungtae Kim <kt0755@gmail.com>, netdev@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Douglas Anderson <dianders@chromium.org>,
	Kevin Curtis <kevin.curtis@farsite.co.uk>,
	linux-usb@vger.kernel.org,
	Jason Wessel <jason.wessel@windriver.com>,
	Romain Perier <romain.perier@gmail.com>,
	Karsten Graul <kgraul@linux.ibm.com>
Subject: Re: [PATCH 2/3] treewide: Replace DECLARE_TASKLET() with
 DECLARE_TASKLET_OLD()
Message-ID: <20200716073052.GC971895@kroah.com>
References: <20200716030847.1564131-1-keescook@chromium.org>
 <20200716030847.1564131-3-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716030847.1564131-3-keescook@chromium.org>

On Wed, Jul 15, 2020 at 08:08:46PM -0700, Kees Cook wrote:
> This converts all the existing DECLARE_TASKLET() (and ...DISABLED)
> macros with DECLARE_TASKLET_OLD() in preparation for refactoring the
> tasklet callback type. All existing DECLARE_TASKLET() users had a "0"
> data argument, it has been removed here as well.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/input/keyboard/omap-keypad.c   |  2 +-
>  drivers/input/serio/hil_mlc.c          |  2 +-
>  drivers/net/wan/farsync.c              |  4 ++--
>  drivers/s390/crypto/ap_bus.c           |  2 +-
>  drivers/staging/most/dim2/dim2.c       |  2 +-
>  drivers/staging/octeon/ethernet-tx.c   |  2 +-
>  drivers/tty/vt/keyboard.c              |  2 +-
>  drivers/usb/gadget/udc/snps_udc_core.c |  2 +-
>  drivers/usb/host/fhci-sched.c          |  2 +-
>  include/linux/interrupt.h              | 15 ++++++++++-----
>  kernel/backtracetest.c                 |  2 +-
>  kernel/debug/debug_core.c              |  2 +-
>  kernel/irq/resend.c                    |  2 +-
>  net/atm/pppoatm.c                      |  2 +-
>  net/iucv/iucv.c                        |  2 +-
>  sound/drivers/pcsp/pcsp_lib.c          |  2 +-
>  16 files changed, 26 insertions(+), 21 deletions(-)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

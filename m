Return-Path: <SRS0=piqs=A3=lists.openwall.com=kernel-hardening-return-19339-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7950FC433E4
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 07:28:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C4A782071B
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 07:28:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ci71ZpD5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4A782071B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19339-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5748 invoked by uid 550); 16 Jul 2020 07:28:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5715 invoked from network); 16 Jul 2020 07:28:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594884509;
	bh=SYcdFaf5HdYrp6/CLmW/0Fkwx9KixuSorUJatgNzvIA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ci71ZpD5S3+QhU/29ZLHmt6sx6CHBBFOvDFGEc8Idi+NVP4ztq8BTut8v79F9OD0a
	 UNWgcmqvc5YkyJIBSmdbiNaQ0EhtbhDfD/Du94wgViUkTHqT2jJuQZITVXgcpgrtnT
	 5bChNpquKrkCX06aKWC/AAixLbvSh2ng4sGsm3aI=
Date: Thu, 16 Jul 2020 09:28:23 +0200
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
Subject: Re: [PATCH 1/3] usb: gadget: udc: Avoid tasklet passing a global
Message-ID: <20200716072823.GA971895@kroah.com>
References: <20200716030847.1564131-1-keescook@chromium.org>
 <20200716030847.1564131-2-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716030847.1564131-2-keescook@chromium.org>

On Wed, Jul 15, 2020 at 08:08:45PM -0700, Kees Cook wrote:
> There's no reason for the tasklet callback to set an argument since it
> always uses a global. Instead, use the global directly, in preparation
> for converting the tasklet subsystem to modern callback conventions.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/usb/gadget/udc/snps_udc_core.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/gadget/udc/snps_udc_core.c b/drivers/usb/gadget/udc/snps_udc_core.c
> index 3fcded31405a..afdd28f332ce 100644
> --- a/drivers/usb/gadget/udc/snps_udc_core.c
> +++ b/drivers/usb/gadget/udc/snps_udc_core.c
> @@ -96,9 +96,7 @@ static int stop_pollstall_timer;
>  static DECLARE_COMPLETION(on_pollstall_exit);
>  
>  /* tasklet for usb disconnect */
> -static DECLARE_TASKLET(disconnect_tasklet, udc_tasklet_disconnect,
> -		(unsigned long) &udc);
> -
> +static DECLARE_TASKLET(disconnect_tasklet, udc_tasklet_disconnect, 0);
>  
>  /* endpoint names used for print */
>  static const char ep0_string[] = "ep0in";
> @@ -1661,7 +1659,7 @@ static void usb_disconnect(struct udc *dev)
>  /* Tasklet for disconnect to be outside of interrupt context */
>  static void udc_tasklet_disconnect(unsigned long par)
>  {
> -	struct udc *dev = (struct udc *)(*((struct udc **) par));
> +	struct udc *dev = udc;
>  	u32 tmp;
>  
>  	DBG(dev, "Tasklet disconnect\n");

Feel free to just take this in your tree, no need to wait for the USB
stuff to land.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

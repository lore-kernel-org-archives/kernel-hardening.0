Return-Path: <SRS0=S5t8=A3=lists.openwall.com=kernel-hardening-return-19340-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF586C433E7
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 07:30:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2FC4D2074B
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 07:30:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Phc6jm75"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2FC4D2074B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19340-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7725 invoked by uid 550); 16 Jul 2020 07:30:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7690 invoked from network); 16 Jul 2020 07:30:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594884616;
	bh=mn6iTBJseqW6x95DXLzjCrLI7Ry2VVFhniqqXYPIzaE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Phc6jm75BYs2701ce9G8bX4UnXRMO9gP//NOxj7gAtA+SR+gVk+ehe0idhpetsJbC
	 6qT1RZjEEosqxo95k/Yl4CU/mLc7bykaJGRcZSAU6YGhwz/a2yRCZIMAj+095bxmQv
	 6PeXnkbT8e99OL/8Dd8AnTc+6KMVnZ5RGOVEV95A=
Date: Thu, 16 Jul 2020 09:30:10 +0200
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
Subject: Re: [PATCH 3/3] tasklet: Introduce new initialization API
Message-ID: <20200716073010.GB971895@kroah.com>
References: <20200716030847.1564131-1-keescook@chromium.org>
 <20200716030847.1564131-4-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716030847.1564131-4-keescook@chromium.org>

On Wed, Jul 15, 2020 at 08:08:47PM -0700, Kees Cook wrote:
> From: Romain Perier <romain.perier@gmail.com>
> 
> Nowadays, modern kernel subsystems that use callbacks pass the data
> structure associated with a given callback as argument to the callback.
> The tasklet subsystem remains one which passes an arbitrary unsigned
> long to the callback function. This has several problems:
> 
> - This keeps an extra field for storing the argument in each tasklet
>   data structure, it bloats the tasklet_struct structure with a redundant
>   .data field
> 
> - No type checking can be performed on this argument. Instead of
>   using container_of() like other callback subsystems, it forces callbacks
>   to do explicit type cast of the unsigned long argument into the required
>   object type.
> 
> - Buffer overflows can overwrite the .func and the .data field, so
>   an attacker can easily overwrite the function and its first argument
>   to whatever it wants.
> 
> Add a new tasklet initialization API, via DECLARE_TASKLET() and
> tasklet_setup(), which will replace the existing ones.
> 
> This work is greatly inspired by the timer_struct conversion series,
> see commit e99e88a9d2b0 ("treewide: setup_timer() -> timer_setup()")
> 
> To avoid problems with both -Wcast-function-type (which is enabled in
> the kernel via -Wextra is several subsystems), and with mismatched
> function prototypes when build with Control Flow Integrity enabled,
> this adds the "use_callback" member to let the tasklet caller choose
> which union member to call through. Once all old API uses are removed,
> this and the .data member will be removed as well. (On 64-bit this does
> not grow the struct size as the new member fills the hole after atomic_t,
> which is also "int" sized.)
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Co-developed-by: Allen Pais <allen.lkml@gmail.com>
> Signed-off-by: Allen Pais <allen.lkml@gmail.com>
> Co-developed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/linux/interrupt.h | 24 +++++++++++++++++++++++-
>  kernel/softirq.c          | 18 +++++++++++++++++-
>  2 files changed, 40 insertions(+), 2 deletions(-)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Return-Path: <SRS0=1smT=A3=lists.openwall.com=kernel-hardening-return-19336-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2434C433EB
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 03:09:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1F98320775
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 03:09:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="FG/kfdhr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F98320775
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19336-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10153 invoked by uid 550); 16 Jul 2020 03:09:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10084 invoked from network); 16 Jul 2020 03:09:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PQ3rS81iCqlQj563UE75aUsx51oFdKIvno+SEEG/FG4=;
        b=FG/kfdhrrvpgKNO8XoFAw8rMldsyko1xxMQvI4cYzTokOwgJ4VoV67Xp7ZSUwQyuB1
         pUGFqZBMP6lpP24GnUWphnxjAPTHxBvHDhawoWy2aIc23UsRgkac0gYVUKAPjXZwMzVH
         C32IKdA7MiHJNt49J80WqSESe08lPvA2ln4BQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PQ3rS81iCqlQj563UE75aUsx51oFdKIvno+SEEG/FG4=;
        b=O0TqahgLqS1MVwPRf/A5MZNeuIqFbw7H9SP2C2JXuKnvOwv0Ur6ZJNutRMHrl7SyoZ
         KBWyuR4os0JXhd3w7Y3O9SfmzfNyC6EWBWoD7HoJfbM3nceaEUIbO4O3KeZ4toW+xE6D
         Cu2L5CRuhp61fGVPmijBim2u6+Kqcmf3pVGJ0wuEgBvF6PWAuxzBleKwjH4OtTkKUJDQ
         y0jFLepKne2hxRQo3yBoGiPJk0yWZK2KgZWRBMINzogxM1n6xKj3E6Z5n39OQiJGfF9L
         2IVTaI4osbqVmtzC4hOvu/ncJP7RmgGWNGtMPk/xO5PyFsJkD6cLzMaR2EluebwPyxBx
         mVSw==
X-Gm-Message-State: AOAM532gLVezmt74pCY3nU2jDLZom+NRLhPcI53+bgPG1ZLu++dobf1l
	XVLzCYfRemr6l/CsWYc+pZUKow==
X-Google-Smtp-Source: ABdhPJyQqOXVFa0AWxv/APlQyrdA+w7DqHfNJLE5LIIILIY1tjbP6/hW3QXi5M1V5H9nUHof0O9/lw==
X-Received: by 2002:a17:902:6181:: with SMTP id u1mr1929724plj.205.1594868933459;
        Wed, 15 Jul 2020 20:08:53 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>,
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
	Jiri Slaby <jslaby@suse.com>,
	Felipe Balbi <balbi@kernel.org>,
	Jason Wessel <jason.wessel@windriver.com>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Mitchell Blank Jr <mitch@sfgoth.com>,
	Julian Wiedmann <jwi@linux.ibm.com>,
	Karsten Graul <kgraul@linux.ibm.com>,
	Ursula Braun <ubraun@linux.ibm.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
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
	Jonathan Corbet <corbet@lwn.net>,
	Peter Zijlstra <peterz@infradead.org>,
	Will Deacon <will@kernel.org>,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-s390@vger.kernel.org,
	devel@driverdev.osuosl.org,
	linux-usb@vger.kernel.org,
	kgdb-bugreport@lists.sourceforge.net,
	alsa-devel@alsa-project.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH 1/3] usb: gadget: udc: Avoid tasklet passing a global
Date: Wed, 15 Jul 2020 20:08:45 -0700
Message-Id: <20200716030847.1564131-2-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200716030847.1564131-1-keescook@chromium.org>
References: <20200716030847.1564131-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's no reason for the tasklet callback to set an argument since it
always uses a global. Instead, use the global directly, in preparation
for converting the tasklet subsystem to modern callback conventions.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/usb/gadget/udc/snps_udc_core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/udc/snps_udc_core.c b/drivers/usb/gadget/udc/snps_udc_core.c
index 3fcded31405a..afdd28f332ce 100644
--- a/drivers/usb/gadget/udc/snps_udc_core.c
+++ b/drivers/usb/gadget/udc/snps_udc_core.c
@@ -96,9 +96,7 @@ static int stop_pollstall_timer;
 static DECLARE_COMPLETION(on_pollstall_exit);
 
 /* tasklet for usb disconnect */
-static DECLARE_TASKLET(disconnect_tasklet, udc_tasklet_disconnect,
-		(unsigned long) &udc);
-
+static DECLARE_TASKLET(disconnect_tasklet, udc_tasklet_disconnect, 0);
 
 /* endpoint names used for print */
 static const char ep0_string[] = "ep0in";
@@ -1661,7 +1659,7 @@ static void usb_disconnect(struct udc *dev)
 /* Tasklet for disconnect to be outside of interrupt context */
 static void udc_tasklet_disconnect(unsigned long par)
 {
-	struct udc *dev = (struct udc *)(*((struct udc **) par));
+	struct udc *dev = udc;
 	u32 tmp;
 
 	DBG(dev, "Tasklet disconnect\n");
-- 
2.25.1


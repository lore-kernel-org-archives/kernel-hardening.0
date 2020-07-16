Return-Path: <SRS0=UnNH=A3=lists.openwall.com=kernel-hardening-return-19337-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B36FC433EC
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 03:09:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ADEBA20775
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 03:09:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dTugxUNj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADEBA20775
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19337-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10224 invoked by uid 550); 16 Jul 2020 03:09:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10087 invoked from network); 16 Jul 2020 03:09:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8vJxKwUVpAhdj4wYAl5b2tdLtDhCjBtUhiOv5fUux8k=;
        b=dTugxUNjGm8SBhEVwZ0yB8FvtZrzhFOHuSpiIvNE2E3SjUjSrIE1w14I52dw3Uk8b5
         3VAafc7gUmjsQ/YS7Xjq8i7OhMMWVeWrbTF8mKhc0S9n4IAuIzChi1+9oaZlREtdDKow
         3jCsslDzAr0zlil4XVqBtq+3neBsSD18zU00A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8vJxKwUVpAhdj4wYAl5b2tdLtDhCjBtUhiOv5fUux8k=;
        b=RCywkvx6HWsUNsay/6SFsGp7AdQbXT1JGN0ihpm9yiWYvJEMCGf3uXBGC9LarLYhWI
         1DC157q3Apk4u3pnjIcuThGCkBlxCOsfnViNtPppYYj7hKhlr+YR+qgT7uNY5jzCfnES
         std3kLn0wZiZhGiLNFI7ToFk1z04nvPI5Vlo14x/+oVBrI2jN8aajXjWLqX/b2/4qV59
         xUSn9TNcfXTg66y2L8TVM2nnl1tMHsd5+ACUR4kotzQIgdDespsqqhvFSQ5TV09HU0M3
         kvOLrZzsuMNPU31eA1+EzFmbcnXOcuntk/XPKsHBfTD34zlHC1fk4iXaQBnFvSO/6BFI
         vjig==
X-Gm-Message-State: AOAM530vcqZmaSK/NSg8UUGGpRXvOgMk0736WJK5aRMXaasdvcoLsGw4
	905q9OgzusjzGNJfUgmFRy5xHA==
X-Google-Smtp-Source: ABdhPJxTrfzJCqi7BCSMsLwnF0LnH2/m3v4TdrKv4bsn5z85zApyPj+eDhaQfjttTIQn/Q1hTEyF2g==
X-Received: by 2002:a17:902:6181:: with SMTP id u1mr1929746plj.205.1594868934031;
        Wed, 15 Jul 2020 20:08:54 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>,
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
Subject: [PATCH 3/3] tasklet: Introduce new initialization API
Date: Wed, 15 Jul 2020 20:08:47 -0700
Message-Id: <20200716030847.1564131-4-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200716030847.1564131-1-keescook@chromium.org>
References: <20200716030847.1564131-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Romain Perier <romain.perier@gmail.com>

Nowadays, modern kernel subsystems that use callbacks pass the data
structure associated with a given callback as argument to the callback.
The tasklet subsystem remains one which passes an arbitrary unsigned
long to the callback function. This has several problems:

- This keeps an extra field for storing the argument in each tasklet
  data structure, it bloats the tasklet_struct structure with a redundant
  .data field

- No type checking can be performed on this argument. Instead of
  using container_of() like other callback subsystems, it forces callbacks
  to do explicit type cast of the unsigned long argument into the required
  object type.

- Buffer overflows can overwrite the .func and the .data field, so
  an attacker can easily overwrite the function and its first argument
  to whatever it wants.

Add a new tasklet initialization API, via DECLARE_TASKLET() and
tasklet_setup(), which will replace the existing ones.

This work is greatly inspired by the timer_struct conversion series,
see commit e99e88a9d2b0 ("treewide: setup_timer() -> timer_setup()")

To avoid problems with both -Wcast-function-type (which is enabled in
the kernel via -Wextra is several subsystems), and with mismatched
function prototypes when build with Control Flow Integrity enabled,
this adds the "use_callback" member to let the tasklet caller choose
which union member to call through. Once all old API uses are removed,
this and the .data member will be removed as well. (On 64-bit this does
not grow the struct size as the new member fills the hole after atomic_t,
which is also "int" sized.)

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Co-developed-by: Allen Pais <allen.lkml@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
Co-developed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/interrupt.h | 24 +++++++++++++++++++++++-
 kernel/softirq.c          | 18 +++++++++++++++++-
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index b911196f03eb..15570b237e53 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -608,10 +608,30 @@ struct tasklet_struct
 	struct tasklet_struct *next;
 	unsigned long state;
 	atomic_t count;
-	void (*func)(unsigned long);
+	bool use_callback;
+	union {
+		void (*func)(unsigned long data);
+		void (*callback)(struct tasklet_struct *t);
+	};
 	unsigned long data;
 };
 
+#define DECLARE_TASKLET(name, _callback)		\
+struct tasklet_struct name = {				\
+	.count = ATOMIC_INIT(0),			\
+	.callback = _callback,				\
+	.use_callback = true,				\
+}
+
+#define DECLARE_TASKLET_DISABLED(name, _callback)	\
+struct tasklet_struct name = {				\
+	.count = ATOMIC_INIT(1),			\
+	.callback = _callback,				\
+}
+
+#define from_tasklet(var, callback_tasklet, tasklet_fieldname)	\
+	container_of(callback_tasklet, typeof(*var), tasklet_fieldname)
+
 #define DECLARE_TASKLET_OLD(name, _func)		\
 struct tasklet_struct name = {				\
 	.count = ATOMIC_INIT(0),			\
@@ -691,6 +711,8 @@ extern void tasklet_kill(struct tasklet_struct *t);
 extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);
 extern void tasklet_init(struct tasklet_struct *t,
 			 void (*func)(unsigned long), unsigned long data);
+extern void tasklet_setup(struct tasklet_struct *t,
+			  void (*callback)(struct tasklet_struct *));
 
 /*
  * Autoprobing for irqs:
diff --git a/kernel/softirq.c b/kernel/softirq.c
index c4201b7f42b1..292e7c2d2333 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -547,7 +547,10 @@ static void tasklet_action_common(struct softirq_action *a,
 				if (!test_and_clear_bit(TASKLET_STATE_SCHED,
 							&t->state))
 					BUG();
-				t->func(t->data);
+				if (t->use_callback)
+					t->callback(t);
+				else
+					t->func(t->data);
 				tasklet_unlock(t);
 				continue;
 			}
@@ -573,6 +576,18 @@ static __latent_entropy void tasklet_hi_action(struct softirq_action *a)
 	tasklet_action_common(a, this_cpu_ptr(&tasklet_hi_vec), HI_SOFTIRQ);
 }
 
+void tasklet_setup(struct tasklet_struct *t,
+		   void (*callback)(struct tasklet_struct *))
+{
+	t->next = NULL;
+	t->state = 0;
+	atomic_set(&t->count, 0);
+	t->callback = callback;
+	t->use_callback = true;
+	t->data = 0;
+}
+EXPORT_SYMBOL(tasklet_setup);
+
 void tasklet_init(struct tasklet_struct *t,
 		  void (*func)(unsigned long), unsigned long data)
 {
@@ -580,6 +595,7 @@ void tasklet_init(struct tasklet_struct *t,
 	t->state = 0;
 	atomic_set(&t->count, 0);
 	t->func = func;
+	t->use_callback = false;
 	t->data = data;
 }
 EXPORT_SYMBOL(tasklet_init);
-- 
2.25.1


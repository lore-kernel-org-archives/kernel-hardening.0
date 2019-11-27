Return-Path: <SRS0=05N0=ZT=lists.openwall.com=kernel-hardening-return-17437-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6059DC432C0
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 Nov 2019 05:42:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AD8002071E
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 Nov 2019 05:42:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="BCErC1RZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD8002071E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17437-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9514 invoked by uid 550); 27 Nov 2019 05:42:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9480 invoked from network); 27 Nov 2019 05:42:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JVfdiNpIIkZybFlA7Wet324geHsXtasX8Ts1855KGnw=;
        b=BCErC1RZbtWq8kWpws1w7AYLww1/8Vl0xUopMqL00ACtbFnatvh5KIIwEOKVtNZIAP
         gojzpiX5fW908/fpf9c0ehmb6QPARQ7sfBia7whsBYTvBvnhdK03CRHQPxBNKTxDDpTJ
         bggt0TQn3E8lytfiwk30Ne0E1R6jhSBJ7lzvU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JVfdiNpIIkZybFlA7Wet324geHsXtasX8Ts1855KGnw=;
        b=KawjKojpvzwPMj2UXGViaTU1yO8H1SFg7ceJBvmLRhT+bNXO+KGm9dJxlDqAdYiSxm
         qpX+Hkd2I9WOY+5xngXocVoYwi/J/Kne0+T03r1sDKmqbI/XlS0YbOEMGDx1cHPi3mqZ
         toLeuYvR+dNQiFYedbR0T+BV2C3QI+mlzGNyAkAI57PetUxj/7sAjgulnrjS+E3iFv78
         4ilZAr0qtOQ4OoP42/mKwAc3CehncnbS60w/QBQFB/R2OBwaLGXuTqcTPhzLjeHLYwQC
         zsfaVKg6nFWob0BPWDQG/WHISWesPceHrYpjk92+Hd8i1y0P9Qz+8udTBkblKErqyNTE
         3yvA==
X-Gm-Message-State: APjAAAXwDw9z8UUhUM3PNlci9Igkkg3kZ6VQxJcHhDu9HYLy6tfMJde5
	aIcFqo3ClQt9QxL2/i5guqpyFQ==
X-Google-Smtp-Source: APXvYqwsK3qE004ktAfCs5hNfeC0dRHftIZgavowVz5TW9u42BSN1qcIJ8n61f9eLxX1xcbWAPVAwQ==
X-Received: by 2002:a17:902:7892:: with SMTP id q18mr2295211pll.171.1574833333323;
        Tue, 26 Nov 2019 21:42:13 -0800 (PST)
Date: Tue, 26 Nov 2019 21:42:11 -0800
From: Kees Cook <keescook@chromium.org>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Elena Petrova <lenaptr@google.com>,
	Alexander Potapenko <glider@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	kasan-dev <kasan-dev@googlegroups.com>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-hardening@lists.openwall.com,
	syzkaller <syzkaller@googlegroups.com>
Subject: Re: [PATCH v2 0/3] ubsan: Split out bounds checker
Message-ID: <201911262134.ED9E60965@keescook>
References: <20191121181519.28637-1-keescook@chromium.org>
 <CACT4Y+b3JZM=TSvUPZRMiJEPNH69otidRCqq9gmKX53UHxYqLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+b3JZM=TSvUPZRMiJEPNH69otidRCqq9gmKX53UHxYqLg@mail.gmail.com>

On Fri, Nov 22, 2019 at 10:07:29AM +0100, Dmitry Vyukov wrote:
> On Thu, Nov 21, 2019 at 7:15 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > v2:
> >     - clarify Kconfig help text (aryabinin)
> >     - add reviewed-by
> >     - aim series at akpm, which seems to be where ubsan goes through?
> > v1: https://lore.kernel.org/lkml/20191120010636.27368-1-keescook@chromium.org
> >
> > This splits out the bounds checker so it can be individually used. This
> > is expected to be enabled in Android and hopefully for syzbot. Includes
> > LKDTM tests for behavioral corner-cases (beyond just the bounds checker).
> >
> > -Kees
> 
> +syzkaller mailing list
> 
> This is great!

BTW, can I consider this your Acked-by for these patches? :)

> I wanted to enable UBSAN on syzbot for a long time. And it's
> _probably_ not lots of work. But it was stuck on somebody actually
> dedicating some time specifically for it.

Do you have a general mechanism to test that syzkaller will actually
pick up the kernel log splat of a new check? I noticed a few things
about the ubsan handlers: they don't use any of the common "warn"
infrastructure (neither does kasan from what I can see), and was missing
a check for panic_on_warn (kasan has this, but does it incorrectly).

I think kasan and ubsan should be reworked to use the common warn
infrastructure, and at the very least, ubsan needs this:

diff --git a/lib/ubsan.c b/lib/ubsan.c
index e7d31735950d..a2535a62c9af 100644
--- a/lib/ubsan.c
+++ b/lib/ubsan.c
@@ -160,6 +160,17 @@ static void ubsan_epilogue(unsigned long *flags)
 		"========================================\n");
 	spin_unlock_irqrestore(&report_lock, *flags);
 	current->in_ubsan--;
+
+	if (panic_on_warn) {
+		/*
+		 * This thread may hit another WARN() in the panic path.
+		 * Resetting this prevents additional WARN() from panicking the
+		 * system on this thread.  Other threads are blocked by the
+		 * panic_mutex in panic().
+		 */
+		panic_on_warn = 0;
+		panic("panic_on_warn set ...\n");
+	}
 }
 
 static void handle_overflow(struct overflow_data *data, void *lhs,

> Kees, or anybody else interested, could you provide relevant configs
> that (1) useful for kernel,

As mentioned in the other email (but just to keep the note together with
the other thoughts here) after this series, you'd want:

CONFIG_UBSAN=y
CONFIG_UBSAN_BOUNDS=y
# CONFIG_UBSAN_MISC is not set

> (2) we want 100% cleanliness,

What do you mean here by "cleanliness"? It seems different from (3)
about the test tripping a lot?

> (3) don't
> fire all the time even without fuzzing?

I ran with the bounds checker enabled (and the above patch) under
syzkaller for the weekend and saw 0 bounds checker reports.

> Anything else required to
> enable UBSAN? I don't see anything. syzbot uses gcc 8.something, which
> I assume should be enough (but we can upgrade if necessary).

As mentioned, gcc 8+ should be fine.

-- 
Kees Cook

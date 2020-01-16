Return-Path: <SRS0=0sgM=3F=lists.openwall.com=kernel-hardening-return-17566-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70EA4C33CB1
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jan 2020 05:23:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C22B3206D7
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jan 2020 05:23:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OZdQn+Tv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C22B3206D7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17566-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26241 invoked by uid 550); 16 Jan 2020 05:23:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26203 invoked from network); 16 Jan 2020 05:23:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yYiCDbJIjI5Gc+HCG21eDD5I0VhMo0bA/4w6OlV0KM0=;
        b=OZdQn+TvUSWi/oF2OJXBWYergJZIBJToM3HOQU6970b09/FLyJPx63uozadrIKOSke
         7WQfW38XDvSv/ei69rGnz+BMbLc7RsmzG0R8DjIwDh4d8sh5LI7J6rx1v4pGEGP+2OmU
         rvIlS1hXGHMkWvy8Yj7bvaLiK7paHjRYm6hpU+Qt88QjCp5nW1QwQrubI+c45EJJQhWW
         1Hrz76UGwF/MsCKxVvXnfs8jDzA/gDWziOlQgDkAEjg6Or1cqYyvyCqlWDm7R7s+j4pY
         JuOChq4Z1ceGy/gf72gVjXTzq0EUo63uR5Evy5iVYkBBiyiC9x/ooDoPPQQlWf0NHfkY
         hJgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yYiCDbJIjI5Gc+HCG21eDD5I0VhMo0bA/4w6OlV0KM0=;
        b=b9i3alGPE03jnVR0QoHLAskO9qVBV8bbY44ekdQrUZncLs94tIdAw33l9XWfUzw5OQ
         yHKFDx4p3xfPhV5vcQZ4KeFDaO+CS0lrpjeCSHR8zihhr8QsVE2Z2riWEF4Xlw1Fwhf1
         h1EGew26l4nc4mmEclMwizdHnsdeLwMYymPSPFa3j1DULmZCRCESkpw8uBOmKFl+Q7xR
         sEC34Qby0XuwEZmfbHA03gvyWmtfJ3RM1O3RwIADWS7e0et4w4SuBHUbvcmY520NxClI
         hOOPLzmmIkbvFl+fIbb29nsc8YsBzAV+247W0+/F6HNHgNG6H5bA32JwFn3cohjUzCqy
         O2MA==
X-Gm-Message-State: APjAAAUA4p5uY2tp/GHmUl+G29l4Cu2BBigLxE0yv2Ayt+vY2kbCpP+u
	8Q22Ij0TYrtzXoSq8tyhL5G9XgmGAXjgIZ11pm4lTw==
X-Google-Smtp-Source: APXvYqyc2uMQyHBLqa2xRW14JXfYwcgrlEF0pcUP7UrNbOp8FUjMFUfn4BIGXFvt+xh+6usK+SZ0+OlCkP1VAjWRSOI=
X-Received: by 2002:ac8:71d7:: with SMTP id i23mr784628qtp.50.1579152193440;
 Wed, 15 Jan 2020 21:23:13 -0800 (PST)
MIME-Version: 1.0
References: <20200116012321.26254-1-keescook@chromium.org> <20200116012321.26254-6-keescook@chromium.org>
In-Reply-To: <20200116012321.26254-6-keescook@chromium.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Thu, 16 Jan 2020 06:23:01 +0100
Message-ID: <CACT4Y+batRaj_PaDnfzLjpLDOCChhpiayKeab-rNLx5LAj1sSQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] kasan: Unset panic_on_warn before calling panic()
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, 
	Elena Petrova <lenaptr@google.com>, Alexander Potapenko <glider@google.com>, 
	Dan Carpenter <dan.carpenter@oracle.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, 
	Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	kasan-dev <kasan-dev@googlegroups.com>, Linux-MM <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, 
	syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 16, 2020 at 2:24 AM Kees Cook <keescook@chromium.org> wrote:
>
> As done in the full WARN() handler, panic_on_warn needs to be cleared
> before calling panic() to avoid recursive panics.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  mm/kasan/report.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/mm/kasan/report.c b/mm/kasan/report.c
> index 621782100eaa..844554e78893 100644
> --- a/mm/kasan/report.c
> +++ b/mm/kasan/report.c
> @@ -92,8 +92,16 @@ static void end_report(unsigned long *flags)
>         pr_err("==================================================================\n");
>         add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
>         spin_unlock_irqrestore(&report_lock, *flags);
> -       if (panic_on_warn)
> +       if (panic_on_warn) {
> +               /*
> +                * This thread may hit another WARN() in the panic path.
> +                * Resetting this prevents additional WARN() from panicking the
> +                * system on this thread.  Other threads are blocked by the
> +                * panic_mutex in panic().

I don't understand part about other threads.
Other threads are not necessary inside of panic(). And in fact since
we reset panic_on_warn, they will not get there even if they should.
If I am reading this correctly, once one thread prints a warning and
is going to panic, other threads may now print infinite amounts of
warning and proceed past them freely. Why is this the behavior we
want?

> +                */
> +               panic_on_warn = 0;
>                 panic("panic_on_warn set ...\n");
> +       }
>         kasan_enable_current();
>  }

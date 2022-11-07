Return-Path: <kernel-hardening-return-21580-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 0F462C4332F
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Nov 2022 21:49:18 +0000 (UTC)
Received: (qmail 22065 invoked by uid 550); 7 Nov 2022 21:49:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22003 invoked from network); 7 Nov 2022 21:49:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XWC+o9EuiWgnDwII3oLYBWgfLGQAEbU3zeoA94HsocY=;
        b=BJp5dFnatAyCODoMXXuloRfYrFOSXO9y53GQCHhPEAyyWK4awpuAKXyYQtuZH4wLE0
         oQ+UGdX7ix+LvFsDtaeeCQcdLre9oTVi03REpMs21+Ip5SuA1MXF28D24kQMqdnNh0fh
         bSggQGFp81AzURDMJUWmOEGM28OgaeTI+99GcB+7KuEFuRWYVeDQAhq9LxLUoKgC6V1y
         JOvNwxJQbSuk9fAMbi9EAwu2LU3sG9weEnBP0ZVYaRGlCwFrkdZhRxbWKg7LS7rn17Mr
         eBP3CrvS8GdhgvIbnFQFpxFnp1McYdvMgNQXkh/gDYYvlT5W8p3Lxx9gMb9viQKONZPo
         MuyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XWC+o9EuiWgnDwII3oLYBWgfLGQAEbU3zeoA94HsocY=;
        b=PVkc/Gh0+um1sfsgHRP3R3eFD3IcWK7tt6vwakF8PhkI5126gOPzwov9+KtiRWPYJ/
         AtODjEkbdjYdiJK2ksRmagqI61XxrZhoyw4VL/NuCzxg3HG9zdS8800DV/NP7ckfW96V
         6P018uxALxRjdeWvwaE39oTOZheJElhWQ/f5288v2PKHRXqiBYwbWn201yYv/uAZ4w2U
         4ySm/N9jlGVHQ5IDeN4TCEalPuDiNbTkCX5OwIoua28R7oUvT+JVoeQelnV0WqTvErKL
         f4Ov6E9y7KJ5br2G10AkOCPYjYpLpJqZoqy0mtjEeHCspCKecZl1y1/8Q8GHKPEKV+aS
         RMVQ==
X-Gm-Message-State: ACrzQf3s7cDR5NI4r7RBGu7HWndB6OE1hrjuTRFsVUNpUm+yq2qe3AOd
	Lw/VC68Wi0rrum7sT1aXCUjboVJuTlEMPV5YWfeHRQ==
X-Google-Smtp-Source: AMsMyM4TI4ySYBH9jynGLl8NgrYZgE0ppylJZxMeEt8hv2KKd0888+AjYQB2ezIy/kiY4p1d7MJoUV+v4xbnxItbeuo=
X-Received: by 2002:a92:d64d:0:b0:2ff:f959:bc47 with SMTP id
 x13-20020a92d64d000000b002fff959bc47mr22185752ilp.187.1667857736979; Mon, 07
 Nov 2022 13:48:56 -0800 (PST)
MIME-Version: 1.0
References: <20221107201317.324457-1-jannh@google.com> <20221107211440.GA4233@openwall.com>
In-Reply-To: <20221107211440.GA4233@openwall.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 7 Nov 2022 22:48:20 +0100
Message-ID: <CAG48ez2-xUawSs4ji_+0Bnyn_QTiS930UiOypXreU_RhwhVo_w@mail.gmail.com>
Subject: Re: [PATCH] exit: Put an upper limit on how often we can oops
To: Solar Designer <solar@openwall.com>
Cc: Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org, 
	kernel-hardening@lists.openwall.com, Greg KH <gregkh@linuxfoundation.org>, 
	Linus Torvalds <torvalds@linuxfoundation.org>, Seth Jenkins <sethjenkins@google.com>, 
	"Eric W . Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 7, 2022 at 10:15 PM Solar Designer <solar@openwall.com> wrote:
> On Mon, Nov 07, 2022 at 09:13:17PM +0100, Jann Horn wrote:
> > +oops_limit
> > +==========
> > +
> > +Number of kernel oopses after which the kernel should panic when
> > +``panic_on_oops`` is not set.
>
> Rather than introduce this separate oops_limit, how about making
> panic_on_oops (and maybe all panic_on_*) take the limit value(s) instead
> of being Boolean?  I think this would preserve the current behavior at
> panic_on_oops = 0 and panic_on_oops = 1, but would introduce your
> desired behavior at panic_on_oops = 10000.  We can make 10000 the new
> default.  If a distro overrides panic_on_oops, it probably sets it to 1
> like RHEL does.
>
> Are there distros explicitly setting panic_on_oops to 0?  If so, that
> could be a reason to introduce the separate oops_limit.
>
> I'm not advocating one way or the other - I just felt this should be
> explicitly mentioned and decided on.

I think at least internally in the kernel, it probably works better to
keep those two concepts separate? For example, sparc has a function
die_nmi() that uses panic_on_oops to determine whether the system
should panic when a watchdog detects a lockup.

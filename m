Return-Path: <SRS0=b44l=XB=lists.openwall.com=kernel-hardening-return-16868-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5651C43331
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 23:23:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 278EC20854
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 23:23:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CfxhObTV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 278EC20854
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16868-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17905 invoked by uid 550); 6 Sep 2019 23:23:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17884 invoked from network); 6 Sep 2019 23:23:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Eqinxltb4P+tBqyuO4WEtRUcfdT4qbszA3gfVj1CVng=;
        b=CfxhObTVAmcNKpN/uttdeqMFFuot/dgQ8oBhunu1p3A2/KXMdnJc7eTmTJi6e2ocMn
         NDFZD/Qh8ub6N+V6n8nGKJNHUKm6leUg+lflNX9keuez69bvdXFvHkCOlVvCSi5FCwQp
         GqpsxbxIXF0lypQ9v5DbU9u4VRzHE/ky6Ttco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Eqinxltb4P+tBqyuO4WEtRUcfdT4qbszA3gfVj1CVng=;
        b=tpsu07ATgrTiYROU5L68z2xnObsdEuo01DoCiuI67KoZUiI9lYP0yeFGM07bcANcnW
         LzkzsX1FU+JAAdMotD1xITb1v1iqXauWm1Zrj5aF8i34k9nrMRYEmq6EOSFdEqrrao19
         UmVy7BpDcEeUSrze/EKss9yaILu7xWncg/o1pBhpq+pE+DJf62QaZZTpCoyTCS7ghfyx
         MtChND6+fq2AuYbZ935fvt3Tx/pSa/D7oB1Apl/Dw9rdk8hHtV478zbnpovMVLKdD/I1
         Xx+lAu/JNugoWRiFffoNt5eketdY+2JIZ9yrlrPzh5u7+Pd4q4hC5nes5v5CuJvTLdjI
         3/Fw==
X-Gm-Message-State: APjAAAWkWi2oSg/w6MhO2Vi43Snq7KwDQoIQIXvECa3s4OpCsnkJPXKs
	w2O8gkOgCXz6t7vu9DvbaleyV+eRMU0=
X-Google-Smtp-Source: APXvYqwg3yUNA5tc52r8PpeMs4kQt+h0P6rxni/Xps2n9mK2Is12en9TagC0sVsW0cgxYYi20WraBg==
X-Received: by 2002:a50:d758:: with SMTP id i24mr12255292edj.246.1567812181020;
        Fri, 06 Sep 2019 16:23:01 -0700 (PDT)
X-Received: by 2002:adf:de08:: with SMTP id b8mr8516944wrm.200.1567812179254;
 Fri, 06 Sep 2019 16:22:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190806154347.GD25897@zn.tnic> <20190806155034.GP2349@hirez.programming.kicks-ass.net>
 <CAJcbSZETvvQYmh6U_Oauptdsrp-emmSG_QsAZzKLv+0-b2Yxig@mail.gmail.com>
In-Reply-To: <CAJcbSZETvvQYmh6U_Oauptdsrp-emmSG_QsAZzKLv+0-b2Yxig@mail.gmail.com>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Fri, 6 Sep 2019 16:22:47 -0700
X-Gmail-Original-Message-ID: <CAJcbSZEc07UJtWyM5i-DGRpNTtoxoY7cDpdyDh3N-Bb+G3s0gA@mail.gmail.com>
Message-ID: <CAJcbSZEc07UJtWyM5i-DGRpNTtoxoY7cDpdyDh3N-Bb+G3s0gA@mail.gmail.com>
Subject: Re: [PATCH v9 00/11] x86: PIE support to extend KASLR randomization
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Kristen Carlson Accardi <kristen@linux.intel.com>, Kees Cook <keescook@chromium.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Juergen Gross <jgross@suse.com>, 
	Thomas Hellstrom <thellstrom@vmware.com>, "VMware, Inc." <pv-drivers@vmware.com>, 
	"Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, 
	Nadav Amit <namit@vmware.com>, Jann Horn <jannh@google.com>, Feng Tang <feng.tang@intel.com>, 
	Maran Wilson <maran.wilson@oracle.com>, Enrico Weigelt <info@metux.net>, 
	Allison Randal <allison@lohutok.net>, Alexios Zavras <alexios.zavras@intel.com>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	virtualization@lists.linux-foundation.org, 
	Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Aug 29, 2019 at 12:55 PM Thomas Garnier <thgarnie@chromium.org> wrote:
>
> On Tue, Aug 6, 2019 at 8:51 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Tue, Aug 06, 2019 at 05:43:47PM +0200, Borislav Petkov wrote:
> > > On Tue, Jul 30, 2019 at 12:12:44PM -0700, Thomas Garnier wrote:
> > > > These patches make some of the changes necessary to build the kernel as
> > > > Position Independent Executable (PIE) on x86_64. Another patchset will
> > > > add the PIE option and larger architecture changes.
> > >
> > > Yeah, about this: do we have a longer writeup about the actual benefits
> > > of all this and why we should take this all? After all, after looking
> > > at the first couple of asm patches, it is posing restrictions to how
> > > we deal with virtual addresses in asm (only RIP-relative addressing in
> > > 64-bit mode, MOVs with 64-bit immediates, etc, for example) and I'm
> > > willing to bet money that some future unrelated change will break PIE
> > > sooner or later.
>
> The goal is being able to extend the range of addresses where the
> kernel can be placed with KASLR. I will look at clarifying that in the
> future.
>
> >
> > Possibly objtool can help here; it should be possible to teach it about
> > these rules, and then it will yell when violated. That should avoid
> > regressions.
> >
>
> I will look into that as well.

Following a discussion with Kees. I will explore objtool in the
follow-up patchset as we still have more elaborate pie changes in the
second set. I like the idea overall and I think it would be great if
it works.

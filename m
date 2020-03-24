Return-Path: <SRS0=P7WL=5J=lists.openwall.com=kernel-hardening-return-18212-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E34F7C10DCE
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 21:29:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3E205206F6
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 21:29:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YSCmWxRY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E205206F6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18212-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31784 invoked by uid 550); 24 Mar 2020 21:29:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31747 invoked from network); 24 Mar 2020 21:29:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mt9R6MAwAgMsRiTLzlySm2VmV71YyEXXijbHmE8WTzk=;
        b=YSCmWxRY40BGiMze1Yvin1YLkJXXl+PFUME/YQdtuWumwzPRmAdvKghADmWKlRrN0K
         f9xnko63sgT0KH37iYw/9/MXZe1oLeb2jpfOZFVn6TSxlkYn1LgOxa54s9Ewh6bUAMOy
         BTu90myx9FunEp53IT4emC25nbXXzPJhnl84W6vhgEIa5wtgGP30cMvv/5ZskWvr8+4O
         Nr3uuT2MSmd1BDUPB1tsmSRiIQExkkO/w1eNM2f0qE61UeZwTTOh9IfxQOOmNTpezIgO
         mLkwFd5DYS6Gf4stv1h7MySVYHXya5QyIbq/2+4YJQUlIUc7dad9mqPuRzul6/Z7nzr+
         FAAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mt9R6MAwAgMsRiTLzlySm2VmV71YyEXXijbHmE8WTzk=;
        b=jpaNj7AwNKSrxeLVkCQNQyVeu+ZxYi/5x1V9+t1BWrYWx8cRSBMN+s5/eo+LPFU6Dg
         5PrRBsebW59lMberIX08Ozp3+OBlp5OrWyBjHLyNpJiPUgj2+IGJN8ZcVbLbzSw3T6E1
         21O9QjNv3PiX/6L3oArrHFeSWt4VYxjGTGsjX5T7OdwAUz1ewPdEab5I2NuxHjhUwwC2
         CZQO0jF4kHSwrDDia9ZaJ6ivG3v3cv+3OXBNjSDTOY9LOcRWDqTA6mjtJ28pRsQzFiVe
         Ah+RfqvpGLrNlZ/+sQ1P6IHSArmOO6kHKJub0zR1MvsrUimTeSfeIJRP4oyuAYO9b4Km
         HsdQ==
X-Gm-Message-State: ANhLgQ0+G7B74sST/zdho7U9EfKdEpN8TA0BmlEtegadQjVBvoL5SreC
	FdDH5xUa/AX6zkOY574lqYvivC9Z/4KmlQYV2aXcLg==
X-Google-Smtp-Source: ADFU+vv8d+tvt43tW6wjpsme/liCuo5+2rssm9plm9lpdQXp8OhLUCZZ8xFwlvpxLM+HptNYxGF5KgkzMO7Hg0NPccQ=
X-Received: by 2002:a2e:89c1:: with SMTP id c1mr17348550ljk.215.1585085342690;
 Tue, 24 Mar 2020 14:29:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200324203231.64324-1-keescook@chromium.org>
In-Reply-To: <20200324203231.64324-1-keescook@chromium.org>
From: Jann Horn <jannh@google.com>
Date: Tue, 24 Mar 2020 22:28:35 +0100
Message-ID: <CAG48ez3yYkMdxEEW6sJzBC5BZSbzEZKnpWzco32p-TJx7y_srg@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Optionally randomize kernel stack offset each syscall
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Elena Reshetova <elena.reshetova@intel.com>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Potapenko <glider@google.com>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Perla, Enrico" <enrico.perla@intel.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-arm-kernel@lists.infradead.org, 
	Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 24, 2020 at 9:32 PM Kees Cook <keescook@chromium.org> wrote:
> This is a continuation and refactoring of Elena's earlier effort to add
> kernel stack base offset randomization. In the time since the previous
> discussions, two attacks[1][2] were made public that depended on stack
> determinism, so we're no longer in the position of "this is a good idea
> but we have no examples of attacks". :)
[...]
> [1] https://a13xp0p0v.github.io/2020/02/15/CVE-2019-18683.html

This one only starts using the stack's location after having parsed
it out of dmesg (which in any environment that wants to provide a
reasonable level of security really ought to be restricted to root),
right? If you give people read access to dmesg, they can leak all
sorts of pointers; not just the stack pointer, but also whatever else
happens to be in the registers at that point - which is likely to give
the attacker more ways to place controlled data at a known location.
See e.g. <https://googleprojectzero.blogspot.com/2018/09/a-cache-invalidation-bug-in-linux.html>,
which leaks the pointer to a BPF map out of dmesg.

Also, are you sure that it isn't possible to make the syscall that
leaked its stack pointer never return to userspace (via ptrace or
SIGSTOP or something like that), and therefore never realign its
stack, while keeping some controlled data present on the syscall's
stack?

> [2] https://repositorio-aberto.up.pt/bitstream/10216/125357/2/374717.pdf

That's a moderately large document; which specific part are you referencing?

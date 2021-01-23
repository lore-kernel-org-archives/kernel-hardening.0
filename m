Return-Path: <SRS0=Fp/Y=G2=lists.openwall.com=kernel-hardening-return-20699-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 451F8C433DB
	for <kernel-hardening@archiver.kernel.org>; Sat, 23 Jan 2021 22:59:55 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 30CC922CB3
	for <kernel-hardening@archiver.kernel.org>; Sat, 23 Jan 2021 22:59:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30CC922CB3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20699-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32530 invoked by uid 550); 23 Jan 2021 22:59:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32510 invoked from network); 23 Jan 2021 22:59:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XEmc28AGxg8G814HFx/ez3FIOIJ36RQOCl9rPqWgvnQ=;
        b=W4/1YIH5h1nwo0TQjLRQxWuhCqmWOmBpjcEApaJH7uj/3OwkPDFgVJw1I/zlOUvcJb
         KcKdWIT31OiX5BRomKzZVwrc2DGvjqmTzir9gKKP2oF7qxSIHrkr1iFvz2oY4G9txrSU
         zXbJWwWqYLma08LREe/nEyFp4fyJ6dkHkrC3kMaKauWs1HMmCcHtFaO0jFqeP8zEzmcb
         TlVnqkGVN2NPe4cJnyNGr2KsuysC9cDsqqIytYasLLXXICc9ahrXy6EDNFBgF1W46LsF
         a+QLYR5GdTOkwyj3I7rj004Oxb45fjcFqgU0UH9hFti1oZ1PkYN4MFP55HLQlblxsMUL
         3xKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XEmc28AGxg8G814HFx/ez3FIOIJ36RQOCl9rPqWgvnQ=;
        b=pvh9sDn8+mhGKGnMfr3kvaosJesdCe3/aqa6FqsyPwQR2Ee9YUqr56r2zy6/hx8+Mv
         dZzAZUFcA0XuRcUzN13jiOVyNN4Ygx0dfl4omIyAn/7DP9M+LwCWzndR1SjWa3tDO3Bn
         lC4I93miQZG0UiDpIJL3P9uzy/pIhNkRWXRqOr968xmEGTW9x9MSK7yGkqP/vGldB0wm
         vZWxRMCTaK7GOMtd8cWro3/UzxHKscLSUhqL0eFLo1yOHWeBMC96NIC8qB3YYMQkeyPJ
         04jnNGMdBdC5b6/UG8nmsre3an+bZGiqtexr9qGP+pz1/3a1a7/y0GQD0OZdVKtGq8v6
         GRWg==
X-Gm-Message-State: AOAM531C/rEEvvMYDwYQ9RJNp/4rkCHcGa0vToS8BlreAMq4d4Pwxh3K
	XC25cQcaUiW/LfQhmxvhfbRupw==
X-Google-Smtp-Source: ABdhPJwG/hyh/aI3nS1B02oCINgwBdGDzEKx4NdActW7UaoHoTBHvT62TjXIs9ZQdEA0bRmcdt0R6Q==
X-Received: by 2002:a17:90a:f998:: with SMTP id cq24mr13543739pjb.6.1611442772450;
        Sat, 23 Jan 2021 14:59:32 -0800 (PST)
Date: Sat, 23 Jan 2021 14:59:28 -0800
From: Fangrui Song <maskray@google.com>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: Miroslav Benes <mbenes@suse.cz>, Josh Poimboeuf <jpoimboe@redhat.com>,
	Kees Cook <keescook@chromium.org>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
	live-patching@vger.kernel.org, Hongjiu Lu <hongjiu.lu@intel.com>,
	joe.lawrence@redhat.com
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <20210123225928.z5hkmaw6qjs2gu5g@google.com>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <202007220738.72F26D2480@keescook>
 <20200722160730.cfhcj4eisglnzolr@treble>
 <202007221241.EBC2215A@keescook>
 <301c7fb7d22ad6ef97856b421873e32c2239d412.camel@linux.intel.com>
 <20200722213313.aetl3h5rkub6ktmw@treble>
 <46c49dec078cb8625a9c3a3cd1310a4de7ec760b.camel@linux.intel.com>
 <alpine.LSU.2.21.2008281216031.29208@pobox.suse.cz>
 <20200828192413.p6rctr42xtuh2c2e@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200828192413.p6rctr42xtuh2c2e@treble>

On 2020-08-28, Josh Poimboeuf wrote:
>On Fri, Aug 28, 2020 at 12:21:13PM +0200, Miroslav Benes wrote:
>> > Hi there! I was trying to find a super easy way to address this, so I
>> > thought the best thing would be if there were a compiler or linker
>> > switch to just eliminate any duplicate symbols at compile time for
>> > vmlinux. I filed this question on the binutils bugzilla looking to see
>> > if there were existing flags that might do this, but H.J. Lu went ahead
>> > and created a new one "-z unique", that seems to do what we would need
>> > it to do.
>> >
>> > https://sourceware.org/bugzilla/show_bug.cgi?id=26391
>> >
>> > When I use this option, it renames any duplicate symbols with an
>> > extension - for example duplicatefunc.1 or duplicatefunc.2. You could
>> > either match on the full unique name of the specific binary you are
>> > trying to patch, or you match the base name and use the extension to
>> > determine original position. Do you think this solution would work?
>>
>> Yes, I think so (thanks, Joe, for testing!).
>>
>> It looks cleaner to me than the options above, but it may just be a matter
>> of taste. Anyway, I'd go with full name matching, because -z unique-symbol
>> would allow us to remove sympos altogether, which is appealing.
>>
>> > If
>> > so, I can modify livepatch to refuse to patch on duplicated symbols if
>> > CONFIG_FG_KASLR and when this option is merged into the tool chain I
>> > can add it to KBUILD_LDFLAGS when CONFIG_FG_KASLR and livepatching
>> > should work in all cases.
>>
>> Ok.
>>
>> Josh, Petr, would this work for you too?
>
>Sounds good to me.  Kristen, thanks for finding a solution!

(I am not subscribed. I came here via https://sourceware.org/bugzilla/show_bug.cgi?id=26391 (ld -z unique-symbol))

> This works great after randomization because it always receives the
> current address at runtime rather than relying on any kind of
> buildtime address. The issue with with the live-patching code's
> algorithm for resolving duplicate symbol names. If they request a
> symbol by name from the kernel and there are 3 symbols with the same
> name, they use the symbol's position in the built binary image to
> select the correct symbol.

If a.o, b.o and c.o define local symbol 'foo'.
By position, do you mean that

* the live-patching code uses something like (findall("foo")[0], findall("foo")[1], findall("foo")[2]) ?
* shuffling a.o/b.o/c.o will make the returned triple different

Local symbols are not required to be unique. Instead of patching the toolchain,
have you thought about making the live-patching code smarter?
(Depend on the duplicates, such a linker option can increase the link time/binary size considerably
AND I don't know in what other cases such an option will be useful)

For the following example, 

https://sourceware.org/bugzilla/show_bug.cgi?id=26822

   # RUN: split-file %s %t
   # RUN: gcc -c %t/a.s -o %t/a.o
   # RUN: gcc -c %t/b.s -o %t/b.o
   # RUN: gcc -c %t/c.s -o %t/c.o
   # RUN: ld-new %t/a.o %t/b.o %t/c.o -z unique-symbol -o %t.exe
   
   #--- a.s
   a: a.1: a.2: nop
   #--- b.s
   a: nop
   #--- c.s
   a: nop

readelf -Ws output:

Symbol table '.symtab' contains 13 entries:
    Num:    Value          Size Type    Bind   Vis      Ndx Name
      0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND 
      1: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS a.o
      2: 0000000000401000     0 NOTYPE  LOCAL  DEFAULT    1 a
      3: 0000000000401000     0 NOTYPE  LOCAL  DEFAULT    1 a.1
      4: 0000000000401000     0 NOTYPE  LOCAL  DEFAULT    1 a.2
      5: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS b.o
      6: 0000000000401001     0 NOTYPE  LOCAL  DEFAULT    1 a.1
      7: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS c.o
      8: 0000000000401002     0 NOTYPE  LOCAL  DEFAULT    1 a.2
      9: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND _start
     10: 0000000000402000     0 NOTYPE  GLOBAL DEFAULT    1 __bss_start
     11: 0000000000402000     0 NOTYPE  GLOBAL DEFAULT    1 _edata
     12: 0000000000402000     0 NOTYPE  GLOBAL DEFAULT    1 _end

Note that you have STT_FILE SHN_ABS symbols.
If the compiler does not produce them, they will be synthesized by GNU ld.

   https://sourceware.org/bugzilla/show_bug.cgi?id=26822
   ld.bfd copies non-STT_SECTION local symbols from input object files.  If an
   object file does not have STT_FILE symbols (no .file directive) but has
   non-STT_SECTION local symbols, ld.bfd synthesizes a STT_FILE symbol

The filenames are usually base names, so "a.o" and "a.o" in two directories will
be indistinguishable.  The live-patching code can possibly work around this by
not changing the relative order of the two "a.o".

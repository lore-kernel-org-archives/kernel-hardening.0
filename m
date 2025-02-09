Return-Path: <kernel-hardening-return-21936-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 93B98C0219B
	for <kernel-hardening@archiver.kernel.org>; Sun,  9 Feb 2025 21:58:03 +0000 (UTC)
Received: (qmail 3958 invoked by uid 550); 9 Feb 2025 21:57:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3932 invoked from network); 9 Feb 2025 21:57:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1739138263; x=1739743063; darn=lists.openwall.com;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=A2PLT/XZrOM9Aa/16QfAGDi7D1uHeStXqgrW7NE/z7I=;
        b=EENldnJWgVrnZScnEsz9GJngwMC1/4qm8hM/FDfcuSo5TNMQLnop8wLALuku941kgO
         6QN1xdn8YrAndSDrk0Q7gWC8GXh/niz2clw2EGI3F3aaBkZIltDk6O5WYBATcrS1pbBX
         sYyLGhr5eBikcQ9y4qFjtQjWUQtsnatsWwUWI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739138263; x=1739743063;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A2PLT/XZrOM9Aa/16QfAGDi7D1uHeStXqgrW7NE/z7I=;
        b=jJ6kRS9e7uByMiZIo4w1Wk6B3Sde+VlI/kWIHzE8NQxRY0K9JYsWhBVBU3sxMEf6rb
         Nu9lGIhNu3ix73VYNXKk4FGyO+j+ktOMh6dtc4UPhFY4GpRts/AX0j08qChVzqEn+2Qu
         AYJWUXHxJrbAXx0gty68XV3UOTXZ04nF5QL3YGEdaZy4aQo1+I7y+/HAskgyQ99Z6XbP
         KJA0z9NvKEXdaJ3l3DejNcCKFb82X8Za9RFgwdug/Lfp4oVjjAV/GSI4+wY9l7Lfk/Sl
         dDvjLmrcGXPfeLQmr+8NOEBFU1v6SNq96efE/T4wOc7O0w1IuHCsFwEFbGMYznv3KcOl
         GjUA==
X-Forwarded-Encrypted: i=1; AJvYcCUBLWoqJblzw0xBeqy5MKD2JyyTTJL5q3ZBBRTdvk60DnkGhEiOLP80Z/wNRkL3swEtOAPQfIhU2B5KtG5P8MKo@lists.openwall.com
X-Gm-Message-State: AOJu0Yy7hahNB1Uzo4iVCTVnlFWImTsCVBCyXujyBOPo29PARTCI2tWa
	PKSHyewB48fQ+7PkVxbXdLVR/8mbHn0Ml9+6GZXFB6FFLlAMmMgPzNopDH1qCeSTkgMWN0Y7q3x
	zaeU=
X-Gm-Gg: ASbGnctZ9RyH1aKxLcc8pJuuv++OTrkXtqfUylCHOoAhzKUlW7vC9AGAIO+aRoJ+CKO
	jhT6qpb12YTmTA1jEAQ/5wJ+DB0tnDXaXZZiKxO6VvRCCf95q38zWx7eFsAUeVlU9TNbKQOnaKA
	xgJOA52ywOwFcTfYFCabY62F3g9cW43i1S25qYSMHL6soVYtGbes4HI2L1RI2uK1S5RTIbJ6+DE
	tneDn/yIA2PZZe7RoEGwq+xDmDq+z0+qA79tRUQ7hEfcEF+GT4HK12i4OkQcG6Xnj6FFUq47iZn
	bHnIcLkFw+5/8pniK4/Gn7h5ilErp7E2ZmMempjK9u6JeDPS84m0P8YpxK9JGUj2/Q==
X-Google-Smtp-Source: AGHT+IF9jA/Jlo61MLT0lc5v4xKIhBuqefEZaGsQQ6loZ9tW4a/nL84raDfcqunMOS6vrlSdyD6IMg==
X-Received: by 2002:a17:907:6eac:b0:aa6:5910:49af with SMTP id a640c23a62f3a-ab789b1f93cmr1212400466b.24.1739138263282;
        Sun, 09 Feb 2025 13:57:43 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV0E/yMZ7b1W1CGVJfa7z93/sebTQ0BKwT9KjJV7cVQ4UZH9xS8vgVQcoIwmzC5FWvSK/fztcNx2VKRrPlyQceB@lists.openwall.com
X-Received: by 2002:a05:6402:4608:b0:5de:42f5:817b with SMTP id
 4fb4d7f45d1cf-5de450b1c5dmr11409992a12.31.1739138261105; Sun, 09 Feb 2025
 13:57:41 -0800 (PST)
MIME-Version: 1.0
References: <20250209191008.142153-1-david.laight.linux@gmail.com>
 <CAHk-=wiQQQ9yo84KCk=Y_61siPsrH=dF9t5LPva0Sbh_RZ0-3Q@mail.gmail.com> <20250209214047.4552e806@pumpkin>
In-Reply-To: <20250209214047.4552e806@pumpkin>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 9 Feb 2025 13:57:24 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiSnNEWsvDariBQ4O-mz7Nc7LbkdKUQntREVCFWiMe9zw@mail.gmail.com>
X-Gm-Features: AWEUYZlCxkYto5CUq_vVIa6_VQHZVTdppz3dRgjcGRBwEP6eBd4ulJsXEl4hnJA
Message-ID: <CAHk-=wiSnNEWsvDariBQ4O-mz7Nc7LbkdKUQntREVCFWiMe9zw@mail.gmail.com>
Subject: Re: [PATCH 1/1] x86: In x86-64 barrier_nospec can always be lfence
To: David Laight <david.laight.linux@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Andi Kleen <ak@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, 
	linux-arch@vger.kernel.org, Kees Cook <keescook@chromium.org>, 
	kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"

On Sun, 9 Feb 2025 at 13:40, David Laight <david.laight.linux@gmail.com> wrote:
>
> Any idea what the one used to synchronise rdtsc should be?
> 'lfence' is the right instruction (give or take), but it isn't
> a speculation issue.
> It really is 'wait for all memory accesses to finish' to give
> a sensible(ish) answer for cycle timing.

No, even that is actually very different.

What happened was that 'lfence' was designed and documented - and
named - as a memory fencing thing, but the *implementation* of it was
basically about the front-end pipeline.

IOW, ignore the name or the documentation. Think of "lfence" as a
"this stops the pipeline until all previous instructions have
retired". Because that is what it *is*.

So it's basically a synchronization instruction *regardless* of memory accesses.

Which is why it was then used for the rdtsc serialization - it
basically says "don't *actually* read the TSC until you've finished
everything you've started".

And which is why it ended up being used for speculation control, even
though the instructions it serializes are *not* necessarily memory
accesses at all, but things like the address conditional that precedes
it.

So the speculation control use is literally "wait for the previous
conditional branches to retire before continuing". Yes, the
"continuing" tends to be a load, but that's almost incidental.

> And on old cpu you want nothing - not a locked memory access.

Well, back in the day, those locked instructions did the same thing.

> I couldn't work out why __smp_mb() is so much stronger than the rmb()
> and wmb() forms - I presume the is history there I wasn't looking for.

So on x86, both read and write barriers are complete no-ops, because
all reads are ordered, and all writes are ordered. So those only need
compiler barriers to guarantee that the compiler itself doesn't
re-order them.

(Side note: earlier reads are also guaranteed to happen before later
writes, so it's really only writes that can be delayed past reads, but
we don't haev a barrier for that situation anyway. Also note that all
of this is not "real" ordering, but only a guarantee that the
user-visible semantics are AS IF they were actually ordered - if
things are local in cache, ordering doesn't matter because no external
CPU can *see* what the ordering was).

So basically the only memory barriers that matter on x86 are the full
"smp_mb()" that orders reads vs writes, and the ordering for
non-ordered accesses used for IO.

And then lfence is basically used for non-memory ordering too.

                Linus

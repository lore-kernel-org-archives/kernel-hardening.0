Return-Path: <kernel-hardening-return-21935-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 4BCC5C0219B
	for <kernel-hardening@archiver.kernel.org>; Sun,  9 Feb 2025 19:33:10 +0000 (UTC)
Received: (qmail 25776 invoked by uid 550); 9 Feb 2025 19:33:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25753 invoked from network); 9 Feb 2025 19:33:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1739129573; x=1739734373; darn=lists.openwall.com;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3OYZn6iFxER/JL2avDuYDbzyExRqovS2QnLbQ0tqh0Y=;
        b=iE1bkbiqAg3FQUSNbOJHFIIABNjf+nAaOl4Ko+bndMuqXf34FjUj1JMU89JsVhnE8p
         VGX6YpWHdBCm/M93NE7IHPmY0w272csg6+kyN4KeFd2XAUTgkeRBeLzREOmXDM+pf+If
         tgzeldSjkd8GjEQXe2h5aXU+tm8k6XGxqnFQ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739129573; x=1739734373;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3OYZn6iFxER/JL2avDuYDbzyExRqovS2QnLbQ0tqh0Y=;
        b=JkA3wKSYfVKaZ9JWahp35ANa8XYNXmHhwz/+xC4ZWLrL6jQKnVPBmx788A6CVNCF12
         WgDnVX/8pPXZZ4OANi2IDjIxIRh7ohRwp2+iIRg4lC+oLx1TXAQVgAUVEaMRsVir2G2V
         RMLoItOQV6NNGrXFV6oenRdZ0UHdTxZf6Uld3GUltibK60ll+XUn0mn3DDU4jDAJ57tS
         A5v1YISP5VhoG0/A7MCQvlI/guIwYQ5zenBCQwvs6k9LM/2fVqJgWTJ//m8XwzEb799s
         +inmyuGpYONS0dvpCYJwbN2OhylLNv5cYkyQFgLQUW1LTUYgsNvXpeO1T+idtqGI9gMr
         wdIA==
X-Forwarded-Encrypted: i=1; AJvYcCUOBYzYNODMSmnM7ATfTOjOWyANDEBfwHZxiYVGIlL0zB1am9xveWm9rLisbe0yDjypHw/kWnuZh/Y8QJzo6g80@lists.openwall.com
X-Gm-Message-State: AOJu0YxBqSxjRbwkxt3gMxZu9YKTqKimblWb9Ck8nvXtlwVHw3IBTmpx
	1TL2hErTTsImyLH8mASZjNpvaRcrF4/j/a7kHdZ0o1tWv/q4391lMSkjckQ2kvy04iz9JZa9m4E
	jBFw=
X-Gm-Gg: ASbGncufLi6teXTLUOwNXvRoAYQUoT64j9ERERUldE2wa/mXzKZkRkqQRO98tsOv+fh
	wrR/nAlf6A4E6wbUxCUzn4eaUcuEFR9ME5XENir6UDkRqK8XQbl/k2TT/urZPG9gYOKyMzWm3BT
	aQSNaxyPadmRP88eKKcrsDAYbitObS2j2RqhRXV8i+xVctmXaZ3b33/ZB7tuclATAbVwetdMN3k
	JkTmLqRFgmjgfK4H4J8aSMjcSdLDgGqjgWv5Uy+8WG0qVlj/FTqRgzmpvMjw8jA9MbPvuVaHqNz
	Y59u63pNZvW2qLInimG72Re5IMmAXjp3GbOFcHg2N1mY99KXBusVfisctyU2EhPvxQ==
X-Google-Smtp-Source: AGHT+IFreVMPUsfycK3P8Bnsff1EDNKZo/edYKM+q8ryq06bi2Afn/2vzLZF+nIav44YtfmNXtLTSA==
X-Received: by 2002:a17:907:1b0f:b0:ab2:b84b:2dab with SMTP id a640c23a62f3a-ab789b9c605mr1352396466b.30.1739129572565;
        Sun, 09 Feb 2025 11:32:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXp54JBnF6EEUGjj7B0FAJOpHvi+Qo0V08pQNP0VsJ44rTjZnDlxs5C1wUBKztePCSwYu0YN/uctrCpyyWrZHBK@lists.openwall.com
X-Received: by 2002:a17:907:7e92:b0:aaf:c259:7f6 with SMTP id
 a640c23a62f3a-ab789c627e1mr1220851466b.45.1739129569271; Sun, 09 Feb 2025
 11:32:49 -0800 (PST)
MIME-Version: 1.0
References: <20250209191008.142153-1-david.laight.linux@gmail.com>
In-Reply-To: <20250209191008.142153-1-david.laight.linux@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 9 Feb 2025 11:32:32 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiQQQ9yo84KCk=Y_61siPsrH=dF9t5LPva0Sbh_RZ0-3Q@mail.gmail.com>
X-Gm-Features: AWEUYZkIEyygdjdtgqEM9UjeSXpn0CystKuNI2lg08YFjtDgCkT1DG_hRzS76Rc
Message-ID: <CAHk-=wiQQQ9yo84KCk=Y_61siPsrH=dF9t5LPva0Sbh_RZ0-3Q@mail.gmail.com>
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

On Sun, 9 Feb 2025 at 11:10, David Laight <david.laight.linux@gmail.com> wrote:
>
> +#define barrier_nospec() __rmb()

This is one of those "it happens to work, but it's wrong" things.

Just make it explicit that it's "lfence" in the current implementation.

Is __rmb() also an lfence? Yes. And that's actually very confusing too
too. Because on x86, a regular read barrier is a no-op, and the "main"
rmb definition is actually this:

  #define __dma_rmb()     barrier()
  #define __smp_rmb()     dma_rmb()

so that it's only a compiler barrier.

And yes, __rmb() exists as the architecture-specific helper for "I
need to synchronize with unordered IO accesses" and is purely about
driver IO.

We should have called it "relaxed_rmb()" or "io_rmb()" or something
like that, but the IO memory ordering issues actually came up before
the modern SMP ordering issues, so due to that historical thing,
"rmb()" ends up being about the IO ordering.

It's confusing, I know. And historical. And too painful to change
because it all works and lots of people know the rules (except looking
around, it seems possibly the sunrpc code is confused, and uses
"rmb()" for SMP synchronization)

But basically a barrier_nospec() is not a IO read barrier, and an IO
read barrier is not a barrier_nospec().

They just happen to be implemented using the same instruction because
an existing instruction - that nobody uses in normal situations -
ended up effectively doing what that nospec barrier needed to do.

And some day in the future, maybe even that implementation equivalence
ends up going away again, and we end up with new barrier instructions
that depend on new CPU capabilities (or fake software capabilities:
kernel bootup flags that say "don't bother with the nospec
barriers").,

So please keep the __rmb() and the barrier_nospec() separate, don't
tie them together. They just have *soo* many differences, both
conceptual and practical.

             Linus

MIME-Version: 1.0
In-Reply-To: <CALS6=qVgYYxcjv8Fj4pdPJ0Z_fUceTV60DtKwOhFkSz4HZohxg@mail.gmail.com>
References: <CALS6=qVgYYxcjv8Fj4pdPJ0Z_fUceTV60DtKwOhFkSz4HZohxg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 21 Sep 2018 11:41:32 -0700
Message-ID: <CAGXu5jKPeXWVV0480xt_5K4O2x8iA2xRf_9t8Rr0yG6szYebhQ@mail.gmail.com>
Subject: Re: temporal and spatial locality in the kernel
Content-Type: text/plain; charset="UTF-8"
To: Carter Cheng <cartercheng@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Sep 21, 2018 at 10:25 AM, Carter Cheng <cartercheng@gmail.com> wrote:
> Hi,

Welcome!

> I recently attended a computer security conference for the first time and
> have developed some interest in kernel hardening issues after one of the
> presenters demonstrated a kernel exploit based partly around a use after
> free bug.
>
> After scanning the literature a little bit and looking at some papers I have
> encountered before on CCured and Cyclone. I was curious to what extent full
> memory saftety checks are now possible.

CONFIG_KASAN covers a lot of this, but wasn't itself designed for
"production use". The primary concern, yes, is performance.

> There are many papers going back quite a bit on spatial safety
> implementations and some on temporal safety but they mainly target user
> space. I am curious why such things don't exist in the linux kernel at least
> as some sort of compile option. Is the slow down the main concern?
>
> It seems recent work has got the performance bound down to 1.29 is this
> considered too slow for many things?

This sounds lovely! :) I'd be curious to see patches implementing the
checks you're talking about.

-Kees

-- 
Kees Cook
Pixel Security

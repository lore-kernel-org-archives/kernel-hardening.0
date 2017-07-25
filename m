MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170725114901.31403-1-ard.biesheuvel@linaro.org>
References: <20170725114901.31403-1-ard.biesheuvel@linaro.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 25 Jul 2017 10:13:19 -0700
Message-ID: <CAGXu5jLNB5dmA0o=n_nn=4NRu3LjuNf5PGRopATuRiq0aJ1ECA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC PATCH untested] arm64: kernel: implement fast refcount checking
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Li Kun <hw.likun@huawei.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Laura Abbott <labbott@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 25, 2017 at 4:49 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> Hi all,
>
> I had a stab at porting the fast refcount checks to arm64. It is slightly
> less straight-forward than x86 given that we need to support both LSE and
> LL/SC, and fallback to the latter if running a kernel built with support
> for the former on hardware that does not support it.
>
> It is build tested with and without LSE support, and boots fine on non-LSE
> hardware in both cases.

Ah! Very cool. Hopefully you and Li can compare notes; I think they've
been working on an implementation too.

> Suggestions welcome as to how to test and/or benchmark this,

I'll post a patch for LKDTM that I've been using. It's more
comprehensive than the existing ATOMIC checks (which predated the
refcount-only protection).

-Kees

-- 
Kees Cook
Pixel Security

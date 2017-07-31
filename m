MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170731192251.12491-1-ard.biesheuvel@linaro.org>
References: <20170731192251.12491-1-ard.biesheuvel@linaro.org>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 31 Jul 2017 14:16:21 -0700
Message-ID: <CAGXu5jLZw1aK_wqSiAi3ddxPavOC1i47q4ahnwVnja=gsrLs2w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v4] arm64: kernel: implement fast refcount checking
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Laura Abbott <labbott@fedoraproject.org>, Li Kun <hw.likun@huawei.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 31, 2017 at 12:22 PM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> v4: Implement add-from-zero checking using a conditional compare rather than
>     a conditional branch, which I omitted from v3 due to the 10% performance
>     hit: this will result in the new refcount to be written back to memory
>     before invoking the handler, which is more in line with the other checks,
>     and is apparently much easier on the branch predictor, given that there
>     is no performance hit whatsoever.

So refcount_inc() and refcount_add(n, ...) will write 1 and n
respectively, then hit the handler to saturate? That seems entirely
fine to me: checking inc-from-zero is just a protection against a
possible double-free condition. It's still technically a race, but a
narrow race on a rare condition is better than being able to always
win it.

Nice!

-Kees

-- 
Kees Cook
Pixel Security

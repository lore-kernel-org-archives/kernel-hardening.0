MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <db288c30-5111-18e3-caf9-8df25508b523@huawei.com>
References: <20170725181536.21092-1-ard.biesheuvel@linaro.org>
 <0816933d-7e58-0773-1441-891823983ff9@huawei.com> <CAKv+Gu8djcgmovajhUUpniHwEVDupCWW3L__3JtqZ0GCM3=U2w@mail.gmail.com>
 <34605822-8f95-f963-48c4-65d724eae0c7@huawei.com> <48B13266-4D48-40AD-A205-169D907FAD68@linaro.org>
 <db288c30-5111-18e3-caf9-8df25508b523@huawei.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 26 Jul 2017 21:16:10 -0700
Message-ID: <CAGXu5jLFAOhs0eak9BfNP=3XLwtHxdSqNF+AB_yjcWyX1=SoNQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2] arm64: kernel: implement fast refcount checking
To: Li Kun <hw.likun@huawei.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Laura Abbott <labbott@fedoraproject.org>, Will Deacon <will.deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 26, 2017 at 7:11 PM, Li Kun <hw.likun@huawei.com> wrote:
> @Kees, should we implement the add-from-zero case ? What do you think?

If it can be done efficiently, yes. In the x86 case, it would
basically change "lock inc" into a huge cmpxchg loop, and it almost
doubled the cycles for the operation. Since
refcount_inc()/refcount_dec_and_test() is the primary code pattern,
it's not a good idea to mess with performance on especially those.
This LKDTM series should provide a good perf target to compare
against:

https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=lkdtm/refcount

-Kees

-- 
Kees Cook
Pixel Security

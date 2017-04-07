MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170406033550.32525-1-ewk@edkovsky.org>
References: <20170406033550.32525-1-ewk@edkovsky.org>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 7 Apr 2017 14:53:23 -0700
Message-ID: <CAGXu5jJ49PZx9T=hTNcFK8sjxLCdp_KBpiFzKLCt1jwj2Q7+3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 0/2] provide check for ro_after_init memory sections
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Eddie Kovsky <ewk@edkovsky.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 5, 2017 at 8:35 PM, Eddie Kovsky <ewk@edkovsky.org> wrote:
> Provide a mechanism for other functions to verify that their arguments
> are read-only.
>
> This implements the first half of a suggestion made by Kees Cook for
> the Kernel Self Protection Project:
>
>     - provide mechanism to check for ro_after_init memory areas, and
>       reject structures not marked ro_after_init in vmbus_register()
>
>       http://www.openwall.com/lists/kernel-hardening/2017/02/04/1
>
> The idea is to prevent structures (including modules) that are not
> read-only from being passed to functions. It builds upon the functions
> in kernel/extable.c that test if an address is in the text section.
>
> A build failure on the Blackfin architecture led to the discovery of
> an incomplete definition of the RO_DATA macro used in this series. The
> fixes are in linux-next:
>
>         commit 906f2a51c941 ("mm: fix section name for .data..ro_after_init")
>
>         commit 939897e2d736 ("vmlinux.lds: add missing VMLINUX_SYMBOL macros")
>
> The latest version of this series uses new symbols provided in these
> fixes. The series now cross compiles on Blackfin without errors. I have
> also test compiled this series on next-20170405 for x86.
>
> I have dropped the third patch that uses these features to check the
> arguments to vmbus_register() because the maintainers have not been
> receptive to using it. My goal right now is to get the API right.
>
> Eddie Kovsky (2):
>   module: verify address is read-only
>   extable: verify address is read-only
>
>  include/linux/kernel.h |  2 ++
>  include/linux/module.h | 12 ++++++++++++
>  kernel/extable.c       | 29 +++++++++++++++++++++++++++
>  kernel/module.c        | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 96 insertions(+)

Andrew, do you have these in your mailbox (it went to lkml), or should
I resend them directly to you? Since they depend on the
__start_ro_after_init naming fixes in -mm, it seemed like it'd be best
to carry these two patches there. If so, please consider them both:

Acked-by: Kees Cook <keescook@chromium.org>

(And, from the thread on the module patch, Jessica has Acked that one too.)

Thanks!

-Kees

-- 
Kees Cook
Pixel Security

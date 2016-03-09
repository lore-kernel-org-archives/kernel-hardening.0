Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1457135448-15541-1-git-send-email-labbott@fedoraproject.org>
References: <1457135448-15541-1-git-send-email-labbott@fedoraproject.org>
Date: Wed, 9 Mar 2016 13:00:48 -0800
Message-ID: <CAGXu5jKa6KyaLjxwyek0Cnx2Po3oD61a5tQEnp_9+kN4+gwKoQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCHv4 0/2] Sanitization of buddy pages
To: Laura Abbott <labbott@fedoraproject.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 4, 2016 at 3:50 PM, Laura Abbott <labbott@fedoraproject.org> wrote:
> Hi,
>
> This is v4 of the santization of buddy pages. This is mostly just a rebase
> and some phrasing tweaks from v2. Kees submitted a rebase of v3 so this is v4.
>
> Kees, I'm hoping you will give your Tested-by and provide some stats from the
> tests you were running before.

Yeah, please consider these:

Tested-by: Kees Cook <keescook@chromium.org>

The benchmarking should be the same as the v3 I reported on, repeated
here for good measure:

The sanity checks appear to add about 3% additional overhead, but
poisoning seems to add about 9%.

DEBUG_PAGEALLOC=n
PAGE_POISONING=y
PAGE_POISONING_NO_SANITY=y
PAGE_POISONING_ZERO=y

Run times: 389.23 384.88 386.33
Mean: 386.81
Std Dev: 1.81

LKDTM detects nothing, as expected.


DEBUG_PAGEALLOC=n
PAGE_POISONING=y
PAGE_POISONING_NO_SANITY=y
PAGE_POISONING_ZERO=n
slub_debug=P page_poison=on

Run times: 435.63 419.20 422.82
Mean: 425.89
Std Dev: 7.05

Overhead: 9.2% vs all disabled

Poisoning confirmed: READ_AFTER_FREE, READ_BUDDY_AFTER_FREE
Writes not detected, as expected.


DEBUG_PAGEALLOC=n
PAGE_POISONING=y
PAGE_POISONING_NO_SANITY=y
PAGE_POISONING_ZERO=y
slub_debug=P page_poison=on

Run times: 423.44 422.32 424.95
Mean: 423.57
Std Dev: 1.08

Overhead 8.7% overhead vs disabled, 0.5% improvement over non-zero
poison (though only the buddy allocator is using the zero poison).

Poisoning confirmed: READ_AFTER_FREE, READ_BUDDY_AFTER_FREE
Writes not detected, as expected.


DEBUG_PAGEALLOC=n
PAGE_POISONING=y
PAGE_POISONING_NO_SANITY=n
PAGE_POISONING_ZERO=y
slub_debug=FP page_poison=on

Run times: 454.26 429.46 430.48
Mean: 438.07
Std Dev: 11.46

Overhead: 11.7% vs nothing, 3% more overhead than no sanitizing.

All four tests detect correctly.


>
> Thanks,
> Laura
>
> Laura Abbott (2):
>   mm/page_poison.c: Enable PAGE_POISONING as a separate option
>   mm/page_poisoning.c: Allow for zero poisoning
>
>  Documentation/kernel-parameters.txt |   5 +
>  include/linux/mm.h                  |  11 +++
>  include/linux/poison.h              |   4 +
>  kernel/power/hibernate.c            |  17 ++++
>  mm/Kconfig.debug                    |  39 +++++++-
>  mm/Makefile                         |   2 +-
>  mm/debug-pagealloc.c                | 137 ----------------------------
>  mm/page_alloc.c                     |  13 ++-
>  mm/page_ext.c                       |  10 +-
>  mm/page_poison.c                    | 176 ++++++++++++++++++++++++++++++++++++
>  10 files changed, 272 insertions(+), 142 deletions(-)
>  delete mode 100644 mm/debug-pagealloc.c
>  create mode 100644 mm/page_poison.c
>
> --
> 2.5.0
>

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security

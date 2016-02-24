Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5jLXDmyGqXWqFp4dzmKmmfmZ+dW53200OByS2+0_63CT+Q@mail.gmail.com>
References: <1455844533-24787-1-git-send-email-labbott@fedoraproject.org>
	<CAGXu5jLREPiCHSwk1LGKJm0pPGpD8O4S+4xu5=Aw_x+COLBXWg@mail.gmail.com>
	<56C79301.5040003@redhat.com>
	<CAGXu5jJ9py=VTyPDzAzD87XXUuMAOE-f+x+5eLUns_yxtkDWiA@mail.gmail.com>
	<56C7A02F.7070902@redhat.com>
	<CAGXu5jLdQNx7ineLf0zv67O30ituQ3a8WHKLBN5FzGVjMz27Bg@mail.gmail.com>
	<56CB866A.8070306@redhat.com>
	<CAGXu5jLXDmyGqXWqFp4dzmKmmfmZ+dW53200OByS2+0_63CT+Q@mail.gmail.com>
Date: Wed, 24 Feb 2016 09:22:29 -0800
Message-ID: <CAGXu5jJz-dWvHFV9jeQhT-r-bTFGxYypBniTjwnw9qp_LhLJ-w@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCHv2] lkdtm: Add READ_AFTER_FREE test
To: Laura Abbott <labbott@redhat.com>
Cc: Laura Abbott <labbott@fedoraproject.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

I did 3 defconfig builds as a benchmark, just to get ballpark numbers...

On Tue, Feb 23, 2016 at 1:25 PM, Kees Cook <keescook@chromium.org> wrote:
> Okay, it looks like the combinations to test are:
>
> default:
> DEBUG_PAGEALLOC=n
> PAGE_POISONING=n

Run times: 412.57 414.19 417.27
Mean: 414.68
Std Dev: 1.95

READ_AFTER_FREE fails:
[   83.521712] lkdtm: Performing direct entry READ_AFTER_FREE
[   83.521851] lkdtm: Value in memory before free: 12345678
[   83.521861] lkdtm: Attempting to read from freed memory
[   83.521864] lkdtm: Successfully read value: 12345678

WRITE_AFTER_FREE accidentally(?) gets detected (due to
CONFIG_SLUB_DEBUG=y default) but does not kill process:
[  120.544198] lkdtm: Performing direct entry WRITE_AFTER_FREE
[  120.544874] =============================================================================
[  120.545028] BUG kmalloc-1024 (Not tainted): Freepointer corrupt

READ_BUDDY_AFTER_FREE fails:
[  120.711466] lkdtm: Performing direct entry READ_BUDDY_AFTER_FREE
[  120.711472] lkdtm: Value in memory before free: 12345678
[  120.711473] lkdtm: Attempting to read from freed memory
[  120.711475] lkdtm: Successfully read value: 12345678

WRITE_BUDDY_AFTER_FREE fails:
[  120.714371] lkdtm: Performing direct entry WRITE_BUDDY_AFTER_FREE
[  120.714374] lkdtm: Writing to the buddy page before free
[  120.714377] lkdtm: Writing to the buddy page after free
[  120.714378] lkdtm: Wrote to free page successfully

So, other than what SLUB_DEBUG caught (which I think is probably an
accident, as we can change the test to avoid SLUB_DEBUG detection),
this is as-expected: use-after-free was not detected.

> heavy-duty:
> DEBUG_PAGEALLOC=y (ARCH_SUPPORTS_DEBUG_PAGEALLOC=y)
> debug_pagealloc=on

Run times: 486.82 464.90 469.34
Mean: 473.69
Std Dev: 9.46

Kind of a giant std-dev, but regardless, DEBUG_PAGEALLOC appears to
introduce a 14% perf overhead.

READ_AFTER_FREE fails, as before.
WRITE_AFTER_FREE accidentally gets detected, as before.

READ_BUDDY_AFTER_FREE detected:
[ 1760.522979] lkdtm: Performing direct entry READ_BUDDY_AFTER_FREE
[ 1760.522985] lkdtm: Value in memory before free: 12345678
[ 1760.523013] BUG: unable to handle kernel paging request at ffff88007994b000

WRITE_BUDDY_AFTER_FREE detected:
[ 1938.050091] lkdtm: Performing direct entry WRITE_BUDDY_AFTER_FREE
[ 1938.051475] lkdtm: Writing to the buddy page before free
[ 1938.056455] lkdtm: Writing to the buddy page after free
[ 1938.058543] BUG: unable to handle kernel paging request at ffff880079b38000

I was expecting DEBUG_PAGEALLOC to detect the read/write after free cases too.

> random poison only:
> DEBUG_PAGEALLOC=n
> PAGE_POISONING=y
> PAGE_POISONING_NO_SANITY=y
> PAGE_POISONING_ZERO=n
> page_poison=on

Run times: 428.96 424.76 426.12
Mean: 426.61
Std Dev: 1.75

This is under 3% perf overhead, with similar std-dev.

READ_AFTER_FREE fails, as before.
WRITE_AFTER_FREE accidentally gets detected, as before.

READ_BUDDY_AFTER_FREE detected:
[ 1448.167650] lkdtm: Performing direct entry READ_BUDDY_AFTER_FREE
[ 1448.167654] lkdtm: Value in memory before free: 12345678
[ 1448.167656] lkdtm: Attempting to read from freed memory
[ 1448.167677] general protection fault: 0000 [#1] SMP

WRITE_BUDDY_AFTER_FREE fails:
[ 1448.206587] lkdtm: Performing direct entry WRITE_BUDDY_AFTER_FREE
[ 1448.207550] lkdtm: Writing to the buddy page before free
[ 1448.208327] lkdtm: Writing to the buddy page after free
[ 1448.209088] lkdtm: Wrote to free page successfully

I wasn't expecting the GP with NO_SANITY=y. I was expecting to read
back random data?

> zero poison only:
> DEBUG_PAGEALLOC=n
> PAGE_POISONING=y
> PAGE_POISONING_NO_SANITY=y
> PAGE_POISONING_ZERO=y
> page_poison=on

This breaks my test system (as mentioned in other thread).

> random poison with sanity:
> DEBUG_PAGEALLOC=n
> PAGE_POISONING=y
> PAGE_POISONING_NO_SANITY=n
> PAGE_POISONING_ZERO=n
> page_poison=on

Run times: 432.72 434.41 429.19
Mean: 432.11
Std Dev: 2.18

Just over 4% perf overhead to no checks, and only 1.5% more overhead
compared to no sanity.

READ_AFTER_FREE fails, as before, but I thought it should be detected
with the sanity checking?
WRITE_AFTER_FREE accidentally gets detected, as before.

READ_BUDDY_AFTER_FREE detects:
[   46.720158] lkdtm: Performing direct entry READ_BUDDY_AFTER_FREE
[   46.720163] lkdtm: Value in memory before free: 12345678
[   46.720164] lkdtm: Attempting to read from freed memory
[   46.720169] general protection fault: 0000 [#1] SMP

WRITE_BUDDY_AFTER_FREE detects, but does not kill process:
[   46.756109] lkdtm: Performing direct entry WRITE_BUDDY_AFTER_FREE
[   46.756975] lkdtm: Writing to the buddy page before free
[   46.757764] lkdtm: Writing to the buddy page after free
[   46.758514] lkdtm: Wrote to free page successfully
[   46.759244] pagealloc: memory corruption

While WRITE_BUDDY_AFTER_FREE is detected, it doesn't kill the process
(similar to the WRITE_AFTER_FREE detection). We should change this
(maybe optionally) to drop processes that are triggering issues like
this.

> zero poison with sanity:
> DEBUG_PAGEALLOC=n
> PAGE_POISONING=y
> PAGE_POISONING_NO_SANITY=n
> PAGE_POISONING_ZERO=y
> page_poison=on

Again, couldn't test.

Looks like good progress to me. :)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security

Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <9020.1466040627@turing-police.cc.vt.edu>
References: <1465420302-23754-1-git-send-email-keescook@chromium.org> <9020.1466040627@turing-police.cc.vt.edu>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 15 Jun 2016 18:38:31 -0700
Message-ID: <CAGXu5jKcLHy3t0C7RyX8xXYowhYuh0rO+WPxWQFKuSn9LN6sjA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC][PATCH v2 0/4] mm: Hardened usercopy
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey.schaufler@intel.com>, Rik van Riel <riel@redhat.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 15, 2016 at 6:30 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Wed, 08 Jun 2016 14:11:38 -0700, Kees Cook said:
>> Hi,
>>
>> This is v2 of the RFC patches for a mainline port of PAX_USERCOPY. After
>> I started writing tests for Casey's earlier port[1], I kept fixing things
>> further and further until I ended up with a whole new patch series. To
>> that end, I also took Rik's feedback and made a number of other changes
>> and clean-ups, which are noted in the "v2" history at the end.
>
> In the "For what it's worth" category - the 6 patches apply mostly cleanly
> to the linux-next tree as of next-20160614 - a bunch of offsets, and one
> easily fixed reject against include/linux/slab.h caused by KASAN landing
> in linux-next.
>
> And I found a test case - the NVidia driver is, of course, not annotated
> for USERCOPY, so this happened:
>
> [   39.184701] usercopy: kernel memory exposure attempt detected from ffff8800bb056fc0 (nvidia_stack_cache) (3 bytes)
> [   39.184715] CPU: 2 PID: 1583 Comm: Xorg Tainted: G           O    4.7.0-rc3-next-20160614-dirty #302
> [   39.184720] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A17 08/19/2015
> [   39.184725]  0000000000000000 00000000422dbb87 ffff8802233cbb28 ffffffffb769f61a
> [   39.184736]  ffff8800bb056fc0 00000000422dbb87 0000000000000003 0000000000000001
> [   39.184744]  ffff8802233cbb78 ffffffffb7367b30 0000000000000000 ffffea00028e92f0
> [   39.184754] Call Trace:
> [   39.184766]  [<ffffffffb769f61a>] dump_stack+0x7b/0xd1
> [   39.184772]  [<ffffffffb7367b30>] __check_object_size+0x70/0x3d4
> [   39.184947]  [<ffffffffc0287098>] os_memcpy_to_user+0x38/0x60 [nvidia]
>
> So I guess you can stick a:
>
> Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>
>
> on that patch set. :)

Awesome, thanks! It's good to know the system operated normally up
until that point. I'm glad to have lots of people testing.

> (Of course, the system only lived for another 4 seconds after that, because the
> blocked copy_to_user() caused the module to not initialize properly, and it
> quite reasonably crapped all over itself as a result.  And yes, I realize that
> *fixing* the module with proper annotations is a problem for me and the NVidia
> engineering team...  :)

Yeah, I think the slab whitelisting may cause some pain, which is why
I've moved it to a separate config. I'll get a v3 up at some point
here with a copy_*_user_n() implementation, but I've been poking at a
few other things for the moment.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security

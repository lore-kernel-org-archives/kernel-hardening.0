Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <56D0CF64.10003@redhat.com>
References: <1455844533-24787-1-git-send-email-labbott@fedoraproject.org>
	<CAGXu5jLREPiCHSwk1LGKJm0pPGpD8O4S+4xu5=Aw_x+COLBXWg@mail.gmail.com>
	<56C79301.5040003@redhat.com>
	<CAGXu5jJ9py=VTyPDzAzD87XXUuMAOE-f+x+5eLUns_yxtkDWiA@mail.gmail.com>
	<56C7A02F.7070902@redhat.com>
	<CAGXu5jLdQNx7ineLf0zv67O30ituQ3a8WHKLBN5FzGVjMz27Bg@mail.gmail.com>
	<56CB866A.8070306@redhat.com>
	<CAGXu5jLXDmyGqXWqFp4dzmKmmfmZ+dW53200OByS2+0_63CT+Q@mail.gmail.com>
	<CAGXu5jJz-dWvHFV9jeQhT-r-bTFGxYypBniTjwnw9qp_LhLJ-w@mail.gmail.com>
	<56CE072F.7060804@redhat.com>
	<CAGXu5jKq-A+ysyP0TZSK1qT5Scu_9ekHU_GgYaQQJm9ftNjEqw@mail.gmail.com>
	<CAGXu5jLVwbaGpeHuMuZOc2H3gc=_pQ=Mao6jD71r3ZJ+6eDu_A@mail.gmail.com>
	<56CE58BA.3080900@redhat.com>
	<CAGXu5jLWqyhspaeoMs+UBu34340OfmKB8EpWRab5=c1uHwKRqw@mail.gmail.com>
	<56CF8B0D.40402@redhat.com>
	<CAGXu5jKZkywRiVNHtwNs7viFjx0WEjoBjCh28fxyK8-d2ORJkw@mail.gmail.com>
	<56D0CF64.10003@redhat.com>
Date: Fri, 26 Feb 2016 14:33:17 -0800
Message-ID: <CAGXu5jKn1pCiHxapHa=b-Xxyem9L_+qn7JvTqUdXj31EycfCJQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCHv2] lkdtm: Add READ_AFTER_FREE test
To: Laura Abbott <labbott@redhat.com>
Cc: Laura Abbott <labbott@fedoraproject.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 26, 2016 at 2:19 PM, Laura Abbott <labbott@redhat.com> wrote:
> I did a quick hack of zero poisoning for the slab allocator and I
> didn't see any improvement in hackbench performance which is fairly
> sensitive to slab performance. This doesn't surprise me when I
> actually think about it.
>
> Before I sent out my last set of performance optimizations for
> SLUB debug path, I did a profile with ftrace to see if there was
> anything else quick I could do. My profiling showed that the
> poisoning itself was not where most of the allocation time was
> spent. 25-50% of the time was being spent in removing the CPU slab.
> Considering poisoning means that the CPU slab is never really used,
> this can probably be improved. It's worth noting that the
> PAX_MEMORY_SANITIZE implementation still uses the fast path so it
> isn't affected here. (The trade off is a minor penalty on the
> fast path even when poisoning is disabled which isn't acceptable
> to the maintainers currently.)

Oh right, all of this is still the slow path...

> Basically, until we've optimized other things I don't think the
> zero poisoning will have a significant effect on performance.
> The next set of optimizations will involve changing some of the
> guts of the SLUB allocator. I have some ideas how to approach this
> but we'll see if they pan out.

And we can't just have a CONFIG for the fast-path sanitization? Then
it's not in anyone's way, etc?

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security

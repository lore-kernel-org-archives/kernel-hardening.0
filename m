Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160407231413.53e371ff@redhat.com>
References: <1459971348-81477-1-git-send-email-thgarnie@google.com>
	<CAGXu5jLEENTFL_NYA5r4SqmUefkEwL68_Br6bX_RY2xNv95GVg@mail.gmail.com>
	<20160407231413.53e371ff@redhat.com>
Date: Thu, 7 Apr 2016 19:31:52 -0700
Message-ID: <CAGXu5j+4AJ_TMKus=bwWdK9+xBgWF44gHxcu5Bagw5ApB3Eg0A@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC v1] mm: SLAB freelist randomization
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Thomas Garnier <thgarnie@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Laura Abbott <labbott@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 7, 2016 at 2:14 PM, Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Wed, 6 Apr 2016 14:45:30 -0700 Kees Cook <keescook@chromium.org> wrote:
>
>> On Wed, Apr 6, 2016 at 12:35 PM, Thomas Garnier <thgarnie@google.com> wrote:
> [...]
>> > re-used on slab creation for performance.
>>
>> I'd like to see some benchmark results for this so the Kconfig can
>> include the performance characteristics. I recommend using hackbench
>> and kernel build times with a before/after comparison.
>>
>
> It looks like it only happens on init, right? (Thus must bench tools
> might not be the right choice).

Oh! Yes, you're right. I entirely missed that detail. :) 0-cost
randomization! Sounds good to me. :)

-Kees

>
> My slab tools for benchmarking the fastpath is here:
>  https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/mm/slab_bulk_test01.c
>
> And I also carry a version of Christoph's slab bench tool:
>  https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/mm/slab_test.c
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   Author of http://www.iptv-analyzer.org
>   LinkedIn: http://www.linkedin.com/in/brouer



-- 
Kees Cook
Chrome OS & Brillo Security

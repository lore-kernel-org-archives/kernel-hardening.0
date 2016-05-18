Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1605181323260.14349@east.gentwo.org>
References: <1463594175-111929-1-git-send-email-thgarnie@google.com>
 <1463594175-111929-3-git-send-email-thgarnie@google.com> <alpine.DEB.2.20.1605181323260.14349@east.gentwo.org>
From: Thomas Garnier <thgarnie@google.com>
Date: Wed, 18 May 2016 11:34:58 -0700
Message-ID: <CAJcbSZFhsZheqdZ5FD8auhiu8ozCyq-0xY1wjYu3j+Wc2R8nGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC v1 2/2] mm: SLUB Freelist randomization
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Pranith Kumar <bobby.prani@gmail.com>, David Howells <dhowells@redhat.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, David Woodhouse <David.Woodhouse@intel.com>, Petr Mladek <pmladek@suse.com>, Kees Cook <keescook@chromium.org>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Greg Thelen <gthelen@google.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Yes, I agree that it is not related to the changes.

On Wed, May 18, 2016 at 11:24 AM, Christoph Lameter <cl@linux.com> wrote:
> 0.On Wed, 18 May 2016, Thomas Garnier wrote:
>
>> slab_test, before:
>> 10000 times kmalloc(8) -> 67 cycles kfree -> 101 cycles
>> 10000 times kmalloc(16) -> 68 cycles kfree -> 109 cycles
>> 10000 times kmalloc(32) -> 76 cycles kfree -> 119 cycles
>> 10000 times kmalloc(64) -> 88 cycles kfree -> 114 cycles
>
>> After:
>> 10000 times kmalloc(8) -> 60 cycles kfree -> 74 cycles
>> 10000 times kmalloc(16) -> 63 cycles kfree -> 78 cycles
>> 10000 times kmalloc(32) -> 72 cycles kfree -> 85 cycles
>> 10000 times kmalloc(64) -> 91 cycles kfree -> 99 cycles
>
> Erm... The fastpath was not touched and the tests primarily exercise the
> fastpath. This is likely some artifact of code placement by the compiler?
>

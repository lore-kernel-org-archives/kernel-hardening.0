Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1605181401560.29313@east.gentwo.org>
References: <1463594175-111929-1-git-send-email-thgarnie@google.com>
 <1463594175-111929-3-git-send-email-thgarnie@google.com> <alpine.DEB.2.20.1605181323260.14349@east.gentwo.org>
 <CAJcbSZFhsZheqdZ5FD8auhiu8ozCyq-0xY1wjYu3j+Wc2R8nGg@mail.gmail.com> <alpine.DEB.2.20.1605181401560.29313@east.gentwo.org>
From: Thomas Garnier <thgarnie@google.com>
Date: Wed, 18 May 2016 12:12:13 -0700
Message-ID: <CAJcbSZHwZxH=NN+xk7N+O-47QQHmRchgqMS5==_HzH1no5ho9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC v1 2/2] mm: SLUB Freelist randomization
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Pranith Kumar <bobby.prani@gmail.com>, David Howells <dhowells@redhat.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, David Woodhouse <David.Woodhouse@intel.com>, Petr Mladek <pmladek@suse.com>, Kees Cook <keescook@chromium.org>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Greg Thelen <gthelen@google.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

I thought the mix of slab_test & kernbench would show a diverse
picture on perf data. Is there another test that you think would be
useful?

Thanks,
Thomas

On Wed, May 18, 2016 at 12:02 PM, Christoph Lameter <cl@linux.com> wrote:
> On Wed, 18 May 2016, Thomas Garnier wrote:
>
>> Yes, I agree that it is not related to the changes.
>
> Could you please provide meaningful test data?

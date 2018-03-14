Subject: Re: [RFC PATCH v19 0/8] mm: security: ro protection for dynamic data
References: <20180313214554.28521-1-igor.stoppa@huawei.com>
 <a9bfc57f-1591-21b6-1676-b60341a2fadd@huawei.com>
 <20180314115653.GD29631@bombadil.infradead.org>
From: Igor Stoppa <igor.stoppa@huawei.com>
Message-ID: <8623382b-cdbe-8862-8c2f-fa5bc6a1213a@huawei.com>
Date: Wed, 14 Mar 2018 14:55:10 +0200
MIME-Version: 1.0
In-Reply-To: <20180314115653.GD29631@bombadil.infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: keescook@chromium.org, david@fromorbit.com, rppt@linux.vnet.ibm.com, mhocko@kernel.org, labbott@redhat.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On 14/03/18 13:56, Matthew Wilcox wrote:
> On Wed, Mar 14, 2018 at 01:21:54PM +0200, Igor Stoppa wrote:

[...]

> You misread my proposal.  I did not suggest storing the 'start', but the
> 'end'.

Ok, but doesn't that only change the race scenario?

Attempting to free one allocation, while it is in progress, so that all
the "space" bits are written, but the "end bit" is not yet written.
That will eat up also the following, complete allocation, if there is no
locking in place.

[...]

>> The implementation which interleaves "space" and "start" does not suffer
>> from this sort of races, because the alteration of the interleaved
>> bitmaps is atomic.
> 
> This would be a bug in the allocator implementation.  Obviously it has to
> maintain the integrity of its own data structures.

But I cannot imagine how to do it, with the split bitmaps, without a
lock :-/
And genalloc is supposed to be lockless.

>> Does this justification for the use of interleaved bitmaps (iow the
>> current implementation) make sense?
> 
> I think you're making a mistake by basing the pmalloc allocator on
> genalloc.

It was recommended to me because it was a close match to the allocator
that I was writing from scratch and, when I looked at it, I could only
agree that it was very close.

But I have no particular reason for preferring it, if something better
is available. It was just never brought up before.
At least not that I noticed.

>  The page_frag allocator seems like a much better place to
> start than genalloc.  It has a significantly lower overhead and is
> much more suited to the kind of probably-identical-lifespan that the
> pmalloc API is going to persuade its users to have.


Could you please provide me a pointer?
I did a quick search on 4.16-rc5 and found the definition of page_frag
and sk_page_frag(). Is this what you are referring to?

--
igor

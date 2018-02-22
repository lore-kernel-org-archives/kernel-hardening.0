Subject: Re: [PATCH 2/6] genalloc: selftest
References: <20180212165301.17933-1-igor.stoppa@huawei.com>
 <20180212165301.17933-3-igor.stoppa@huawei.com>
 <CAGXu5jJNERp-yni1jdqJRYJ82xrP7=_O1vkxG1sJ-b8CxudP9g@mail.gmail.com>
 <f33112e4-608f-ae8c-bf88-80ef83b61398@huawei.com>
 <CAGXu5jLeC285BGDW29aHgFZRV6CnqBmmkZULW2pzYmqd0pe9UQ@mail.gmail.com>
From: Igor Stoppa <igor.stoppa@huawei.com>
Message-ID: <fb001cd0-7f37-394f-f926-f5b98365b4b8@huawei.com>
Date: Thu, 22 Feb 2018 11:14:25 +0200
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLeC285BGDW29aHgFZRV6CnqBmmkZULW2pzYmqd0pe9UQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>, Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Laura Abbott <labbott@redhat.com>, Jerome Glisse <jglisse@redhat.com>, Christoph Hellwig <hch@infradead.org>, Christoph
 Lameter <cl@linux.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>



On 22/02/18 00:28, Kees Cook wrote:
> On Tue, Feb 20, 2018 at 8:59 AM, Igor Stoppa <igor.stoppa@huawei.com> wrote:
>>
>>
>> On 13/02/18 01:50, Kees Cook wrote:
>>> On Mon, Feb 12, 2018 at 8:52 AM, Igor Stoppa <igor.stoppa@huawei.com> wrote:

[...]

>>>> +       genalloc_selftest();
>>>
>>> I wonder if it's possible to make this module-loadable instead? That
>>> way it could be built and tested separately.
>>
>> In my case modules are not an option.
>> Of course it could be still built in, but what is the real gain?
> 
> The gain for it being a module is that it can be loaded and tested
> separately from the final kernel image and module collection. For
> example, Chrome OS builds lots of debugging test modules but doesn't
> include them on the final image. They're only used for testing, and
> can be separate from the kernel and "production" modules.

ok

> 
>> [...]
>>
>>>> +       BUG_ON(compare_bitmaps(pool, action->pattern));
>>>
>>> There's been a lot recently on BUG vs WARN. It does seem crazy to not
>>> BUG for an allocator selftest, but if we can avoid it, we should.
>>
>> If this fails, I would expect that memory corruption is almost guaranteed.
>> Do we really want to allow the boot to continue, possibly mounting a
>> filesystem, only to corrupt it? It seems very dangerous.
> 
> I would include the rationale in either a comment or the commit log.
> BUG() tends to need to be very well justified these days.

ok

> 
>>> Also, I wonder if it might make sense to split this series up a little
>>> more, as in:
>>>
>>> 1/n: add genalloc selftest
>>> 2/n: update bitmaps
>>> 3/n: add/change bitmap tests to selftest

[...]

> I'll leave it up to the -mm folks, but that was just my thought.

The reasons why I have doubts about your proposal are:

1) leaving 2/n and 3/n separate mean that the selftest could be broken,
if one does bisections with selftest enabled

2) since I would need to change the selftest, to make it work with the
updated bitmap, it would not really prove that the change is correct.

If there was a selftest that can work without changes, after the bitmap
update, I would definitely agree to introduce it first.

OTOH, as I wrote, the bitmap patch itself is already introducing
verification of the calculated value (from the bitmap) against the
provided value (from the call parameters).

This, unfortunately, cannot be split, because it still relies on the
"find end of the allocation" capability introduced by the very same patch.

Anyway, putting aside concerns about the verification of the correctness
of the patch, I still see point #1 as a problem: breaking bisectability.

Or did I not understand correctly how this works?

--
igor

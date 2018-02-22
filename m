Subject: Re: [RFC PATCH v16 0/6] mm: security: ro protection for dynamic data
References: <20180212165301.17933-1-igor.stoppa@huawei.com>
 <CAGXu5j+ZNFX17Vxd37rPnkahFepFn77Fi9zEy+OL8nNd_2bjqQ@mail.gmail.com>
 <20180220012111.GC3728@rh> <24e65dec-f452-a444-4382-d1f88fbb334c@huawei.com>
 <20180220213604.GD3728@rh> <20180220235600.GA3706@bombadil.infradead.org>
 <20180221013636.GE3728@rh> <46a9610a-182b-4765-9d83-cab6297377f3@huawei.com>
 <20180221213629.GF3728@rh>
From: Igor Stoppa <igor.stoppa@huawei.com>
Message-ID: <77b1e91b-ca65-f13c-ada5-b24c55c87cb3@huawei.com>
Date: Thu, 22 Feb 2018 10:58:58 +0200
MIME-Version: 1.0
In-Reply-To: <20180221213629.GF3728@rh>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <dchinner@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, Kees Cook <keescook@chromium.org>, Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Laura Abbott <labbott@redhat.com>, Jerome
 Glisse <jglisse@redhat.com>, Christoph Hellwig <hch@infradead.org>, Christoph Lameter <cl@linux.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>



On 21/02/18 23:36, Dave Chinner wrote:
> On Wed, Feb 21, 2018 at 11:56:22AM +0200, Igor Stoppa wrote:

[...]

> It seems lots of people get confused when discussing concepts vs
> implementation... :)

IMHO, if possible, it's better to use unambiguous terms at every point.
__ro_after_init is already taken :-P

In this specific case, I wanted to be absolutely sure I understood
correctly what you need. I think I have now, thanks.

>> is this something that is readonly from the beginning and then shared
>> among mount points or is it specific to each mount point?
> 
> It's dynamically allocated for each mount point, made read-only
> before the mount completes and lives for the length of the mount
> point.

ok. And destroyed when the mount point is unmounted, I expect.

[...]

>> The "const" modifier is a nice way to catch errors through the compiler,
>> iff the ro data will not be initialized through this handle, when it's
>> still writable.
> 
> That's kinda implied by the const, isn't it? If we don't do it that
> way, then the compiler will throw errors....


I might be splitting the hair, but since I'm advertising something I
worte, I don't want to look like a peddler of snake oil, in hindsight :-P

To clarify my previous comment:

* const can mean the world to the compiler, but that doesn't
automatically translate into write-protected memory, yet I do appreciate
the advantage of teaching the compiler what should not be altered.
And I have nothing against doing it.

* even if some handle will be const, it still needs to be aliased to
some other pointer that is not const, at the beginning, because it must
be initialized and it's anyway writable. So, this cannot be avoided.

--
igor

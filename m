MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180313183220.GA21538@bombadil.infradead.org>
References: <20180214182618.14627-1-willy@infradead.org> <20180214182618.14627-3-willy@infradead.org>
 <CAGXu5jL9hqQGe672CmvFwqNbtTr=qu7WRwHuS4Vy7o5sX_UTgg@mail.gmail.com>
 <alpine.DEB.2.20.1803072212160.2814@hadrien> <20180308025812.GA9082@bombadil.infradead.org>
 <alpine.DEB.2.20.1803080722300.3754@hadrien> <20180308230512.GD29073@bombadil.infradead.org>
 <alpine.DEB.2.20.1803131818550.3117@hadrien> <20180313183220.GA21538@bombadil.infradead.org>
From: Kees Cook <keescook@chromium.org>
Date: Sun, 29 Apr 2018 09:59:27 -0700
Message-ID: <CAGXu5jKLaY2vzeFNaEhZOXbMgDXp4nF4=BnGCFfHFRwL6LXNHA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: Add kvmalloc_ab_c and kvzalloc_struct
Content-Type: text/plain; charset="UTF-8"
To: Matthew Wilcox <willy@infradead.org>
Cc: Julia Lawall <julia.lawall@lip6.fr>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, cocci@systeme.lip6.fr, Himanshu Jha <himanshujha199640@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 13, 2018 at 11:32 AM, Matthew Wilcox <willy@infradead.org> wrote:
> On Tue, Mar 13, 2018 at 06:19:51PM +0100, Julia Lawall wrote:
>> On Thu, 8 Mar 2018, Matthew Wilcox wrote:
>> > On Thu, Mar 08, 2018 at 07:24:47AM +0100, Julia Lawall wrote:
>> > > Thanks.  So it's OK to replace kmalloc and kzalloc, even though they
>> > > didn't previously consider vmalloc and even though kmalloc doesn't zero?
>> >
>> > We'll also need to replace the corresponding places where those structs
>> > are freed with kvfree().  Can coccinelle handle that too?
>>
>> Is the use of vmalloc a necessary part of the design?  Or could there be a
>> non vmalloc versions for call sites that are already ok with that?
>
> We can also add kmalloc_struct() along with kmalloc_ab_c that won't fall
> back to vmalloc but just return NULL.

Did this ever happen? I'd also like to see kmalloc_array_3d() or
something that takes three size arguments. We have a lot of this
pattern too:

kmalloc(sizeof(foo) * A * B, gfp...)

And we could turn that into:

kmalloc_array_3d(sizeof(foo), A, B, gfp...)

-Kees


-- 
Kees Cook
Pixel Security

MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170220091417.14b21484@xeon-e3>
References: <20170218055844.1457-1-ewk@edkovsky.org> <20170218055844.1457-2-ewk@edkovsky.org>
 <20170220091417.14b21484@xeon-e3>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 21 Feb 2017 12:32:16 -0800
Message-ID: <CAGXu5jKMqPFktwOk_iodie=2J+sT2pHBbTzeuKfDMEYq=dE8Ww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 1/3] module: verify address is read-only
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Eddie Kovsky <ewk@edkovsky.org>, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 20, 2017 at 9:14 AM, Stephen Hemminger
<stephen@networkplumber.org> wrote:
> On Fri, 17 Feb 2017 21:58:42 -0800
> "Eddie Kovsky" <ewk@edkovsky.org> wrote:
>
>> Implement a mechanism to check if a module's address is in
>> the rodata or ro_after_init sections. It mimics the exsiting functions
>> that test if an address is inside a module's text section.
>>
>> Signed-off-by: Eddie Kovsky <ewk@edkovsky.org>
>
> I don't see the point of this for many of the hyper-v functions.
> They are only called from a small number of places, and this can be validated
> by code inspection. Adding this seems just seems to be code bloat to me.

I think it has value in that it effectively blocks any way for
non-ro_after_init structures from being passed into these functions.
Since there are so few callers now, it's the perfect place to add
this.

-Kees

-- 
Kees Cook
Pixel Security
